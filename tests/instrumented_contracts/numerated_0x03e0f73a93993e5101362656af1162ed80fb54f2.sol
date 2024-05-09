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
13 pragma solidity 0.4.18;
14 /// @title Utility Functions for uint
15 /// @author Daniel Wang - <daniel@loopring.org>
16 library MathUint {
17     function mul(uint a, uint b) internal pure returns (uint c) {
18         c = a * b;
19         require(a == 0 || c / a == b);
20     }
21     function sub(uint a, uint b) internal pure returns (uint) {
22         require(b <= a);
23         return a - b;
24     }
25     function add(uint a, uint b) internal pure returns (uint c) {
26         c = a + b;
27         require(c >= a);
28     }
29     function tolerantSub(uint a, uint b) internal pure returns (uint c) {
30         return (a >= b) ? a - b : 0;
31     }
32     /// @dev calculate the square of Coefficient of Variation (CV)
33     /// https://en.wikipedia.org/wiki/Coefficient_of_variation
34     function cvsquare(
35         uint[] arr,
36         uint scale
37         )
38         internal
39         pure
40         returns (uint)
41     {
42         uint len = arr.length;
43         require(len > 1);
44         require(scale > 0);
45         uint avg = 0;
46         for (uint i = 0; i < len; i++) {
47             avg += arr[i];
48         }
49         avg = avg / len;
50         if (avg == 0) {
51             return 0;
52         }
53         uint cvs = 0;
54         uint s;
55         uint item;
56         for (i = 0; i < len; i++) {
57             item = arr[i];
58             s = item > avg ? item - avg : avg - item;
59             cvs += mul(s, s);
60         }
61         return ((mul(mul(cvs, scale), scale) / avg) / avg) / (len - 1);
62     }
63 }
64 /*
65   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
66   Licensed under the Apache License, Version 2.0 (the "License");
67   you may not use this file except in compliance with the License.
68   You may obtain a copy of the License at
69   http://www.apache.org/licenses/LICENSE-2.0
70   Unless required by applicable law or agreed to in writing, software
71   distributed under the License is distributed on an "AS IS" BASIS,
72   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
73   See the License for the specific language governing permissions and
74   limitations under the License.
75 */
76 /*
77   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
78   Licensed under the Apache License, Version 2.0 (the "License");
79   you may not use this file except in compliance with the License.
80   You may obtain a copy of the License at
81   http://www.apache.org/licenses/LICENSE-2.0
82   Unless required by applicable law or agreed to in writing, software
83   distributed under the License is distributed on an "AS IS" BASIS,
84   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
85   See the License for the specific language governing permissions and
86   limitations under the License.
87 */
88 /// @title ERC20 Token Interface
89 /// @dev see https://github.com/ethereum/EIPs/issues/20
90 /// @author Daniel Wang - <daniel@loopring.org>
91 contract ERC20 {
92     uint public totalSupply;
93 	
94     event Transfer(address indexed from, address indexed to, uint256 value);
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96     function balanceOf(address who) view public returns (uint256);
97     function allowance(address owner, address spender) view public returns (uint256);
98     function transfer(address to, uint256 value) public returns (bool);
99     function transferFrom(address from, address to, uint256 value) public returns (bool);
100     function approve(address spender, uint256 value) public returns (bool);
101 }
102 /*
103   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
104   Licensed under the Apache License, Version 2.0 (the "License");
105   you may not use this file except in compliance with the License.
106   You may obtain a copy of the License at
107   http://www.apache.org/licenses/LICENSE-2.0
108   Unless required by applicable law or agreed to in writing, software
109   distributed under the License is distributed on an "AS IS" BASIS,
110   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
111   See the License for the specific language governing permissions and
112   limitations under the License.
113 */
114 /// @title Loopring Token Exchange Protocol Contract Interface
115 /// @author Daniel Wang - <daniel@loopring.org>
116 /// @author Kongliang Zhong - <kongliang@loopring.org>
117 contract LoopringProtocol {
118     ////////////////////////////////////////////////////////////////////////////
119     /// Constants                                                            ///
120     ////////////////////////////////////////////////////////////////////////////
121     uint8   public constant FEE_SELECT_LRC               = 0;
122     uint8   public constant FEE_SELECT_MARGIN_SPLIT      = 1;
123     uint8   public constant FEE_SELECT_MAX_VALUE         = 1;
124     uint8   public constant MARGIN_SPLIT_PERCENTAGE_BASE = 100;
125     ////////////////////////////////////////////////////////////////////////////
126     /// Events                                                               ///
127     ////////////////////////////////////////////////////////////////////////////
128     /// @dev Event to emit if a ring is successfully mined.
129     /// _amountsList is an array of:
130     /// [_amountS, _amountB, _lrcReward, _lrcFee, splitS, splitB].
131     event RingMined(
132         uint                _ringIndex,
133         bytes32     indexed _ringhash,
134         address             _miner,
135         address             _feeRecipient,
136         bool                _isRinghashReserved,
137         bytes32[]           _orderHashList,
138         uint[6][]           _amountsList
139     );
140     event OrderCancelled(
141         bytes32     indexed _orderHash,
142         uint                _amountCancelled
143     );
144     event CutoffTimestampChanged(
145         address     indexed _address,
146         uint                _cutoff
147     );
148     ////////////////////////////////////////////////////////////////////////////
149     /// Functions                                                            ///
150     ////////////////////////////////////////////////////////////////////////////
151     /// @dev Submit a order-ring for validation and settlement.
152     /// @param addressList  List of each order's owner and tokenS. Note that next
153     ///                     order's `tokenS` equals this order's `tokenB`.
154     /// @param uintArgsList List of uint-type arguments in this order:
155     ///                     amountS, amountB, timestamp, ttl, salt, lrcFee,
156     ///                     rateAmountS.
157     /// @param uint8ArgsList -
158     ///                     List of unit8-type arguments, in this order:
159     ///                     marginSplitPercentageList, feeSelectionList.
160     /// @param buyNoMoreThanAmountBList -
161     ///                     This indicates when a order should be considered
162     ///                     as 'completely filled'.
163     /// @param vList        List of v for each order. This list is 1-larger than
164     ///                     the previous lists, with the last element being the
165     ///                     v value of the ring signature.
166     /// @param rList        List of r for each order. This list is 1-larger than
167     ///                     the previous lists, with the last element being the
168     ///                     r value of the ring signature.
169     /// @param sList        List of s for each order. This list is 1-larger than
170     ///                     the previous lists, with the last element being the
171     ///                     s value of the ring signature.
172     /// @param ringminer    The address that signed this tx.
173     /// @param feeRecepient The recepient address for fee collection. If this is
174     ///                     '0x0', all fees will be paid to the address who had
175     ///                     signed this transaction, not `msg.sender`. Noted if
176     ///                     LRC need to be paid back to order owner as the result
177     ///                     of fee selection model, LRC will also be sent from
178     ///                     this address.
179     function submitRing(
180         address[2][]    addressList,
181         uint[7][]       uintArgsList,
182         uint8[2][]      uint8ArgsList,
183         bool[]          buyNoMoreThanAmountBList,
184         uint8[]         vList,
185         bytes32[]       rList,
186         bytes32[]       sList,
187         address         ringminer,
188         address         feeRecepient
189         ) public;
190     /// @dev Cancel a order. cancel amount(amountS or amountB) can be specified
191     ///      in orderValues.
192     /// @param addresses          owner, tokenS, tokenB
193     /// @param orderValues        amountS, amountB, timestamp, ttl, salt, lrcFee,
194     ///                           cancelAmountS, and cancelAmountB.
195     /// @param buyNoMoreThanAmountB -
196     ///                           This indicates when a order should be considered
197     ///                           as 'completely filled'.
198     /// @param marginSplitPercentage -
199     ///                           Percentage of margin split to share with miner.
200     /// @param v                  Order ECDSA signature parameter v.
201     /// @param r                  Order ECDSA signature parameters r.
202     /// @param s                  Order ECDSA signature parameters s.
203     function cancelOrder(
204         address[3] addresses,
205         uint[7]    orderValues,
206         bool       buyNoMoreThanAmountB,
207         uint8      marginSplitPercentage,
208         uint8      v,
209         bytes32    r,
210         bytes32    s
211         ) external;
212     /// @dev   Set a cutoff timestamp to invalidate all orders whose timestamp
213     ///        is smaller than or equal to the new value of the address's cutoff
214     ///        timestamp.
215     /// @param cutoff The cutoff timestamp, will default to `block.timestamp`
216     ///        if it is 0.
217     function setCutoff(uint cutoff) external;
218 }
219 /*
220   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
221   Licensed under the Apache License, Version 2.0 (the "License");
222   you may not use this file except in compliance with the License.
223   You may obtain a copy of the License at
224   http://www.apache.org/licenses/LICENSE-2.0
225   Unless required by applicable law or agreed to in writing, software
226   distributed under the License is distributed on an "AS IS" BASIS,
227   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
228   See the License for the specific language governing permissions and
229   limitations under the License.
230 */
231 /*
232   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
233   Licensed under the Apache License, Version 2.0 (the "License");
234   you may not use this file except in compliance with the License.
235   You may obtain a copy of the License at
236   http://www.apache.org/licenses/LICENSE-2.0
237   Unless required by applicable law or agreed to in writing, software
238   distributed under the License is distributed on an "AS IS" BASIS,
239   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
240   See the License for the specific language governing permissions and
241   limitations under the License.
242 */
243 /// @title Utility Functions for byte32
244 /// @author Kongliang Zhong - <kongliang@loopring.org>,
245 /// @author Daniel Wang - <daniel@loopring.org>.
246 library MathBytes32 {
247     function xorReduce(
248         bytes32[]   arr,
249         uint        len
250         )
251         internal
252         pure
253         returns (bytes32 res)
254     {
255         res = arr[0];
256         for (uint i = 1; i < len; i++) {
257             res ^= arr[i];
258         }
259     }
260 }
261 /*
262   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
263   Licensed under the Apache License, Version 2.0 (the "License");
264   you may not use this file except in compliance with the License.
265   You may obtain a copy of the License at
266   http://www.apache.org/licenses/LICENSE-2.0
267   Unless required by applicable law or agreed to in writing, software
268   distributed under the License is distributed on an "AS IS" BASIS,
269   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
270   See the License for the specific language governing permissions and
271   limitations under the License.
272 */
273 /// @title Utility Functions for uint8
274 /// @author Kongliang Zhong - <kongliang@loopring.org>,
275 /// @author Daniel Wang - <daniel@loopring.org>.
276 library MathUint8 {
277     function xorReduce(
278         uint8[] arr,
279         uint    len
280         )
281         internal
282         pure
283         returns (uint8 res)
284     {
285         res = arr[0];
286         for (uint i = 1; i < len; i++) {
287             res ^= arr[i];
288         }
289     }
290 }
291 /// @title Ring Hash Registry Contract
292 /// @dev This contracts help reserve ringhashes for miners.
293 /// @author Kongliang Zhong - <kongliang@loopring.org>,
294 /// @author Daniel Wang - <daniel@loopring.org>.
295 contract RinghashRegistry {
296     using MathBytes32   for bytes32[];
297     using MathUint8     for uint8[];
298     uint public blocksToLive;
299     struct Submission {
300         address ringminer;
301         uint block;
302     }
303     mapping (bytes32 => Submission) submissions;
304     ////////////////////////////////////////////////////////////////////////////
305     /// Events                                                               ///
306     ////////////////////////////////////////////////////////////////////////////
307     event RinghashSubmitted(
308         address indexed _ringminer,
309         bytes32 indexed _ringhash
310     );
311     ////////////////////////////////////////////////////////////////////////////
312     /// Constructor                                                          ///
313     ////////////////////////////////////////////////////////////////////////////
314     function RinghashRegistry(uint _blocksToLive)
315         public
316     {
317         require(_blocksToLive > 0);
318         blocksToLive = _blocksToLive;
319     }
320     ////////////////////////////////////////////////////////////////////////////
321     /// Public Functions                                                     ///
322     ////////////////////////////////////////////////////////////////////////////
323     /// @dev Disable default function.
324     function () payable public {
325         revert();
326     }
327     function submitRinghash(
328         address     ringminer,
329         bytes32     ringhash
330         )
331         public
332     {
333         require(canSubmit(ringhash, ringminer)); //, "Ringhash submitted");
334         submissions[ringhash] = Submission(ringminer, block.number);
335         RinghashSubmitted(ringminer, ringhash);
336     }
337     function batchSubmitRinghash(
338         address[]     ringminerList,
339         bytes32[]     ringhashList
340         )
341         external
342     {
343         uint size = ringminerList.length;
344         require(size > 0);
345         require(size == ringhashList.length);
346         for (uint i = 0; i < size; i++) {
347             submitRinghash(ringminerList[i], ringhashList[i]);
348         }
349     }
350     /// @dev Calculate the hash of a ring.
351     function calculateRinghash(
352         uint        ringSize,
353         uint8[]     vList,
354         bytes32[]   rList,
355         bytes32[]   sList
356         )
357         private
358         pure
359         returns (bytes32)
360     {
361         require(
362             ringSize == vList.length - 1 && (
363             ringSize == rList.length - 1 && (
364             ringSize == sList.length - 1))
365         ); //, "invalid ring data");
366         return keccak256(
367             vList.xorReduce(ringSize),
368             rList.xorReduce(ringSize),
369             sList.xorReduce(ringSize)
370         );
371     }
372      /// return value attributes[2] contains the following values in this order:
373      /// canSubmit, isReserved.
374     function computeAndGetRinghashInfo(
375         uint        ringSize,
376         address     ringminer,
377         uint8[]     vList,
378         bytes32[]   rList,
379         bytes32[]   sList
380         )
381         external
382         view
383         returns (bytes32 ringhash, bool[2] attributes)
384     {
385         ringhash = calculateRinghash(
386             ringSize,
387             vList,
388             rList,
389             sList
390         );
391         attributes[0] = canSubmit(ringhash, ringminer);
392         attributes[1] = isReserved(ringhash, ringminer);
393     }
394     /// @return true if a ring's hash can be submitted;
395     /// false otherwise.
396     function canSubmit(
397         bytes32 ringhash,
398         address ringminer)
399         public
400         view
401         returns (bool)
402     {
403         require(ringminer != 0x0);
404         Submission memory submission = submissions[ringhash];
405         address miner = submission.ringminer;
406         return (
407             miner == 0x0 || (
408             submission.block + blocksToLive < block.number) || (
409             miner == ringminer)
410         );
411     }
412     /// @return true if a ring's hash was submitted and still valid;
413     /// false otherwise.
414     function isReserved(
415         bytes32 ringhash,
416         address ringminer)
417         public
418         view
419         returns (bool)
420     {
421         Submission memory submission = submissions[ringhash];
422         return (
423             submission.block + blocksToLive >= block.number && (
424             submission.ringminer == ringminer)
425         );
426     }
427 }
428 /*
429   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
430   Licensed under the Apache License, Version 2.0 (the "License");
431   you may not use this file except in compliance with the License.
432   You may obtain a copy of the License at
433   http://www.apache.org/licenses/LICENSE-2.0
434   Unless required by applicable law or agreed to in writing, software
435   distributed under the License is distributed on an "AS IS" BASIS,
436   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
437   See the License for the specific language governing permissions and
438   limitations under the License.
439 */
440 /*
441   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
442   Licensed under the Apache License, Version 2.0 (the "License");
443   you may not use this file except in compliance with the License.
444   You may obtain a copy of the License at
445   http://www.apache.org/licenses/LICENSE-2.0
446   Unless required by applicable law or agreed to in writing, software
447   distributed under the License is distributed on an "AS IS" BASIS,
448   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
449   See the License for the specific language governing permissions and
450   limitations under the License.
451 */
452 /*
453   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
454   Licensed under the Apache License, Version 2.0 (the "License");
455   you may not use this file except in compliance with the License.
456   You may obtain a copy of the License at
457   http://www.apache.org/licenses/LICENSE-2.0
458   Unless required by applicable law or agreed to in writing, software
459   distributed under the License is distributed on an "AS IS" BASIS,
460   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
461   See the License for the specific language governing permissions and
462   limitations under the License.
463 */
464 /// @title Ownable
465 /// @dev The Ownable contract has an owner address, and provides basic
466 ///      authorization control functions, this simplifies the implementation of
467 ///      "user permissions".
468 contract Ownable {
469     address public owner;
470     event OwnershipTransferred(
471         address indexed previousOwner,
472         address indexed newOwner
473     );
474     /// @dev The Ownable constructor sets the original `owner` of the contract
475     ///      to the sender.
476     function Ownable() public {
477         owner = msg.sender;
478     }
479     /// @dev Throws if called by any account other than the owner.
480     modifier onlyOwner() {
481         require(msg.sender == owner);
482         _;
483     }
484     /// @dev Allows the current owner to transfer control of the contract to a
485     ///      newOwner.
486     /// @param newOwner The address to transfer ownership to.
487     function transferOwnership(address newOwner) onlyOwner public {
488         require(newOwner != 0x0);
489         OwnershipTransferred(owner, newOwner);
490         owner = newOwner;
491     }
492 }
493 /// @title Claimable
494 /// @dev Extension for the Ownable contract, where the ownership needs
495 ///      to be claimed. This allows the new owner to accept the transfer.
496 contract Claimable is Ownable {
497     address public pendingOwner;
498     /// @dev Modifier throws if called by any account other than the pendingOwner.
499     modifier onlyPendingOwner() {
500         require(msg.sender == pendingOwner);
501         _;
502     }
503     /// @dev Allows the current owner to set the pendingOwner address.
504     /// @param newOwner The address to transfer ownership to.
505     function transferOwnership(address newOwner) onlyOwner public {
506         require(newOwner != 0x0 && newOwner != owner);
507         pendingOwner = newOwner;
508     }
509     /// @dev Allows the pendingOwner address to finalize the transfer.
510     function claimOwnership() onlyPendingOwner public {
511         OwnershipTransferred(owner, pendingOwner);
512         owner = pendingOwner;
513         pendingOwner = 0x0;
514     }
515 }
516 /// @title Token Register Contract
517 /// @dev This contract maintains a list of tokens the Protocol supports.
518 /// @author Kongliang Zhong - <kongliang@loopring.org>,
519 /// @author Daniel Wang - <daniel@loopring.org>.
520 contract TokenRegistry is Claimable {
521     address[] public addresses;
522     mapping (address => TokenInfo) addressMap;
523     mapping (string => address) symbolMap;
524     
525     uint8 public constant TOKEN_STANDARD_ERC20   = 0;
526     uint8 public constant TOKEN_STANDARD_ERC223  = 1;
527     
528     ////////////////////////////////////////////////////////////////////////////
529     /// Structs                                                              ///
530     ////////////////////////////////////////////////////////////////////////////
531     struct TokenInfo {
532         uint   pos;      // 0 mens unregistered; if > 0, pos + 1 is the
533                          // token's position in `addresses`.
534         uint8  standard; // ERC20 or ERC223
535         string symbol;   // Symbol of the token
536     }
537     
538     ////////////////////////////////////////////////////////////////////////////
539     /// Events                                                               ///
540     ////////////////////////////////////////////////////////////////////////////
541     event TokenRegistered(address addr, string symbol);
542     event TokenUnregistered(address addr, string symbol);
543     
544     ////////////////////////////////////////////////////////////////////////////
545     /// Public Functions                                                     ///
546     ////////////////////////////////////////////////////////////////////////////
547     /// @dev Disable default function.
548     function () payable public {
549         revert();
550     }
551     function registerToken(
552         address addr,
553         string  symbol
554         )
555         external
556         onlyOwner
557     {
558         registerStandardToken(addr, symbol, TOKEN_STANDARD_ERC20);    
559     }
560     function registerStandardToken(
561         address addr,
562         string  symbol,
563         uint8   standard
564         )
565         public
566         onlyOwner
567     {
568         require(0x0 != addr);
569         require(bytes(symbol).length > 0);
570         require(0x0 == symbolMap[symbol]);
571         require(0 == addressMap[addr].pos);
572         require(standard <= TOKEN_STANDARD_ERC223);
573         addresses.push(addr);
574         symbolMap[symbol] = addr;
575         addressMap[addr] = TokenInfo(addresses.length, standard, symbol);
576         TokenRegistered(addr, symbol);      
577     }
578     function unregisterToken(
579         address addr,
580         string  symbol
581         )
582         external
583         onlyOwner
584     {
585         require(addr != 0x0);
586         require(symbolMap[symbol] == addr);
587         delete symbolMap[symbol];
588         
589         uint pos = addressMap[addr].pos;
590         require(pos != 0);
591         delete addressMap[addr];
592         
593         // We will replace the token we need to unregister with the last token
594         // Only the pos of the last token will need to be updated
595         address lastToken = addresses[addresses.length - 1];
596         
597         // Don't do anything if the last token is the one we want to delete
598         if (addr != lastToken) {
599             // Swap with the last token and update the pos
600             addresses[pos - 1] = lastToken;
601             addressMap[lastToken].pos = pos;
602         }
603         addresses.length--;
604         TokenUnregistered(addr, symbol);
605     }
606     function isTokenRegisteredBySymbol(string symbol)
607         public
608         view
609         returns (bool)
610     {
611         return symbolMap[symbol] != 0x0;
612     }
613     function isTokenRegistered(address addr)
614         public
615         view
616         returns (bool)
617     {
618         return addressMap[addr].pos != 0;
619     }
620     function areAllTokensRegistered(address[] addressList)
621         external
622         view
623         returns (bool)
624     {
625         for (uint i = 0; i < addressList.length; i++) {
626             if (addressMap[addressList[i]].pos == 0) {
627                 return false;
628             }
629         }
630         return true;
631     }
632     
633     function getTokenStandard(address addr)
634         public
635         view
636         returns (uint8)
637     {
638         TokenInfo memory info = addressMap[addr];
639         require(info.pos != 0);
640         return info.standard;
641     }
642     function getAddressBySymbol(string symbol)
643         external
644         view
645         returns (address)
646     {
647         return symbolMap[symbol];
648     }
649     
650     function getTokens(
651         uint start,
652         uint count
653         )
654         public
655         view
656         returns (address[] addressList)
657     {
658         uint num = addresses.length;
659         
660         if (start >= num) {
661             return;
662         }
663         
664         uint end = start + count;
665         if (end > num) {
666             end = num;
667         }
668         if (start == num) {
669             return;
670         }
671         
672         addressList = new address[](end - start);
673         for (uint i = start; i < end; i++) {
674             addressList[i - start] = addresses[i];
675         }
676     }
677 }
678 /*
679   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
680   Licensed under the Apache License, Version 2.0 (the "License");
681   you may not use this file except in compliance with the License.
682   You may obtain a copy of the License at
683   http://www.apache.org/licenses/LICENSE-2.0
684   Unless required by applicable law or agreed to in writing, software
685   distributed under the License is distributed on an "AS IS" BASIS,
686   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
687   See the License for the specific language governing permissions and
688   limitations under the License.
689 */
690 /// @title TokenTransferDelegate
691 /// @dev Acts as a middle man to transfer ERC20 tokens on behalf of different
692 /// versions of Loopring protocol to avoid ERC20 re-authorization.
693 /// @author Daniel Wang - <daniel@loopring.org>.
694 contract TokenTransferDelegate is Claimable {
695     using MathUint for uint;
696     ////////////////////////////////////////////////////////////////////////////
697     /// Variables                                                            ///
698     ////////////////////////////////////////////////////////////////////////////
699     mapping(address => AddressInfo) private addressInfos;
700     address public latestAddress;
701     ////////////////////////////////////////////////////////////////////////////
702     /// Structs                                                              ///
703     ////////////////////////////////////////////////////////////////////////////
704     struct AddressInfo {
705         address previous;
706         uint32  index;
707         bool    authorized;
708     }
709     ////////////////////////////////////////////////////////////////////////////
710     /// Modifiers                                                            ///
711     ////////////////////////////////////////////////////////////////////////////
712     modifier onlyAuthorized() {
713         require(addressInfos[msg.sender].authorized);
714         _;
715     }
716     ////////////////////////////////////////////////////////////////////////////
717     /// Events                                                               ///
718     ////////////////////////////////////////////////////////////////////////////
719     event AddressAuthorized(address indexed addr, uint32 number);
720     event AddressDeauthorized(address indexed addr, uint32 number);
721     ////////////////////////////////////////////////////////////////////////////
722     /// Public Functions                                                     ///
723     ////////////////////////////////////////////////////////////////////////////
724     /// @dev Disable default function.
725     function () payable public {
726         revert();
727     }
728     /// @dev Add a Loopring protocol address.
729     /// @param addr A loopring protocol address.
730     function authorizeAddress(address addr)
731         onlyOwner
732         external
733     {
734         AddressInfo storage addrInfo = addressInfos[addr];
735         if (addrInfo.index != 0) { // existing
736             if (addrInfo.authorized == false) { // re-authorize
737                 addrInfo.authorized = true;
738                 AddressAuthorized(addr, addrInfo.index);
739             }
740         } else {
741             address prev = latestAddress;
742             if (prev == 0x0) {
743                 addrInfo.index = 1;
744                 addrInfo.authorized = true;
745             } else {
746                 addrInfo.previous = prev;
747                 addrInfo.index = addressInfos[prev].index + 1;
748             }
749             addrInfo.authorized = true;
750             latestAddress = addr;
751             AddressAuthorized(addr, addrInfo.index);
752         }
753     }
754     /// @dev Remove a Loopring protocol address.
755     /// @param addr A loopring protocol address.
756     function deauthorizeAddress(address addr)
757         onlyOwner
758         external
759     {
760         uint32 index = addressInfos[addr].index;
761         if (index != 0) {
762             addressInfos[addr].authorized = false;
763             AddressDeauthorized(addr, index);
764         }
765     }
766     function isAddressAuthorized(address addr)
767         public
768         view
769         returns (bool)
770     {
771         return addressInfos[addr].authorized;
772     }
773     function getLatestAuthorizedAddresses(uint max)
774         external
775         view
776         returns (address[] addresses)
777     {
778         addresses = new address[](max);
779         address addr = latestAddress;
780         AddressInfo memory addrInfo;
781         uint count = 0;
782         while (addr != 0x0 && count < max) {
783             addrInfo = addressInfos[addr];
784             if (addrInfo.index == 0) {
785                 break;
786             }
787             addresses[count++] = addr;
788             addr = addrInfo.previous;
789         }
790     }
791     /// @dev Invoke ERC20 transferFrom method.
792     /// @param token Address of token to transfer.
793     /// @param from Address to transfer token from.
794     /// @param to Address to transfer token to.
795     /// @param value Amount of token to transfer.
796     function transferToken(
797         address token,
798         address from,
799         address to,
800         uint    value)
801         onlyAuthorized
802         external
803     {
804         if (value > 0 && from != to) {
805             require(
806                 ERC20(token).transferFrom(from, to, value)
807             );
808         }
809     }
810     function batchTransferToken(
811         address lrcTokenAddress,
812         address feeRecipient,
813         bytes32[] batch)
814         onlyAuthorized
815         external
816     {
817         uint len = batch.length;
818         require(len % 6 == 0);
819         ERC20 lrc = ERC20(lrcTokenAddress);
820         for (uint i = 0; i < len; i += 6) {
821             address owner = address(batch[i]);
822             address prevOwner = address(batch[(i + len - 6) % len]);
823             // Pay token to previous order, or to miner as previous order's
824             // margin split or/and this order's margin split.
825             ERC20 token = ERC20(address(batch[i + 1]));
826             // Here batch[i+2] has been checked not to be 0.
827             if (owner != prevOwner) {
828                 require(
829                     token.transferFrom(owner, prevOwner, uint(batch[i + 2]))
830                 );
831             }
832             if (owner != feeRecipient) {
833                 bytes32 item = batch[i + 3];
834                 if (item != 0) {
835                     require(
836                         token.transferFrom(owner, feeRecipient, uint(item))
837                     );
838                 }
839                 item = batch[i + 4];
840                 if (item != 0) {
841                     require(
842                         lrc.transferFrom(feeRecipient, owner, uint(item))
843                     );
844                 }
845                 item = batch[i + 5];
846                 if (item != 0) {
847                     require(
848                         lrc.transferFrom(owner, feeRecipient, uint(item))
849                     );
850                 }
851             }
852         }
853     }
854 }
855 /// @title Loopring Token Exchange Protocol Implementation Contract v1
856 /// @author Daniel Wang - <daniel@loopring.org>,
857 /// @author Kongliang Zhong - <kongliang@loopring.org>
858 ///
859 /// Recognized contributing developers from the community:
860 ///     https://github.com/Brechtpd
861 ///     https://github.com/rainydio
862 ///     https://github.com/BenjaminPrice
863 ///     https://github.com/jonasshen
864 contract LoopringProtocolImpl is LoopringProtocol {
865     using MathUint for uint;
866     ////////////////////////////////////////////////////////////////////////////
867     /// Variables                                                            ///
868     ////////////////////////////////////////////////////////////////////////////
869     address public  lrcTokenAddress             = 0x0;
870     address public  tokenRegistryAddress        = 0x0;
871     address public  ringhashRegistryAddress     = 0x0;
872     address public  delegateAddress             = 0x0;
873     uint    public  maxRingSize                 = 0;
874     uint64  public  ringIndex                   = 0;
875     // Exchange rate (rate) is the amount to sell or sold divided by the amount
876     // to buy or bought.
877     //
878     // Rate ratio is the ratio between executed rate and an order's original
879     // rate.
880     //
881     // To require all orders' rate ratios to have coefficient ofvariation (CV)
882     // smaller than 2.5%, for an example , rateRatioCVSThreshold should be:
883     //     `(0.025 * RATE_RATIO_SCALE)^2` or 62500.
884     uint    public  rateRatioCVSThreshold       = 0;
885     uint    public constant RATE_RATIO_SCALE    = 10000;
886     uint64  public constant ENTERED_MASK        = 1 << 63;
887     // The following map is used to keep trace of order fill and cancellation
888     // history.
889     mapping (bytes32 => uint) public cancelledOrFilled;
890     // A map from address to its cutoff timestamp.
891     mapping (address => uint) public cutoffs;
892     ////////////////////////////////////////////////////////////////////////////
893     /// Structs                                                              ///
894     ////////////////////////////////////////////////////////////////////////////
895     struct Rate {
896         uint amountS;
897         uint amountB;
898     }
899     /// @param tokenS       Token to sell.
900     /// @param tokenB       Token to buy.
901     /// @param amountS      Maximum amount of tokenS to sell.
902     /// @param amountB      Minimum amount of tokenB to buy if all amountS sold.
903     /// @param timestamp    Indicating when this order is created/signed.
904     /// @param ttl          Indicating after how many seconds from `timestamp`
905     ///                     this order will expire.
906     /// @param salt         A random number to make this order's hash unique.
907     /// @param lrcFee       Max amount of LRC to pay for miner. The real amount
908     ///                     to pay is proportional to fill amount.
909     /// @param buyNoMoreThanAmountB -
910     ///                     If true, this order does not accept buying more
911     ///                     than `amountB`.
912     /// @param marginSplitPercentage -
913     ///                     The percentage of margin paid to miner.
914     /// @param v            ECDSA signature parameter v.
915     /// @param r            ECDSA signature parameters r.
916     /// @param s            ECDSA signature parameters s.
917     struct Order {
918         address owner;
919         address tokenS;
920         address tokenB;
921         uint    amountS;
922         uint    amountB;
923         uint    lrcFee;
924         bool    buyNoMoreThanAmountB;
925         uint8   marginSplitPercentage;
926     }
927     /// @param order        The original order
928     /// @param orderHash    The order's hash
929     /// @param feeSelection -
930     ///                     A miner-supplied value indicating if LRC (value = 0)
931     ///                     or margin split is choosen by the miner (value = 1).
932     ///                     We may support more fee model in the future.
933     /// @param rate         Exchange rate provided by miner.
934     /// @param fillAmountS  Amount of tokenS to sell, calculated by protocol.
935     /// @param lrcReward    The amount of LRC paid by miner to order owner in
936     ///                     exchange for margin split.
937     /// @param lrcFee       The amount of LR paid by order owner to miner.
938     /// @param splitS      TokenS paid to miner.
939     /// @param splitB      TokenB paid to miner.
940     struct OrderState {
941         Order   order;
942         bytes32 orderHash;
943         uint8   feeSelection;
944         Rate    rate;
945         uint    fillAmountS;
946         uint    lrcReward;
947         uint    lrcFee;
948         uint    splitS;
949         uint    splitB;
950     }
951     ////////////////////////////////////////////////////////////////////////////
952     /// Constructor                                                          ///
953     ////////////////////////////////////////////////////////////////////////////
954     function LoopringProtocolImpl(
955         address _lrcTokenAddress,
956         address _tokenRegistryAddress,
957         address _ringhashRegistryAddress,
958         address _delegateAddress,
959         uint    _maxRingSize,
960         uint    _rateRatioCVSThreshold
961         )
962         public
963     {
964         require(0x0 != _lrcTokenAddress);
965         require(0x0 != _tokenRegistryAddress);
966         require(0x0 != _ringhashRegistryAddress);
967         require(0x0 != _delegateAddress);
968         require(_maxRingSize > 1);
969         require(_rateRatioCVSThreshold > 0);
970         lrcTokenAddress = _lrcTokenAddress;
971         tokenRegistryAddress = _tokenRegistryAddress;
972         ringhashRegistryAddress = _ringhashRegistryAddress;
973         delegateAddress = _delegateAddress;
974         maxRingSize = _maxRingSize;
975         rateRatioCVSThreshold = _rateRatioCVSThreshold;
976     }
977     ////////////////////////////////////////////////////////////////////////////
978     /// Public Functions                                                     ///
979     ////////////////////////////////////////////////////////////////////////////
980     /// @dev Disable default function.
981     function () payable public {
982         revert();
983     }
984     /// @dev Submit a order-ring for validation and settlement.
985     /// @param addressList  List of each order's tokenS. Note that next order's
986     ///                     `tokenS` equals this order's `tokenB`.
987     /// @param uintArgsList List of uint-type arguments in this order:
988     ///                     amountS, amountB, timestamp, ttl, salt, lrcFee,
989     ///                     rateAmountS.
990     /// @param uint8ArgsList -
991     ///                     List of unit8-type arguments, in this order:
992     ///                     marginSplitPercentageList,feeSelectionList.
993     /// @param buyNoMoreThanAmountBList -
994     ///                     This indicates when a order should be considered
995     ///                     as 'completely filled'.
996     /// @param vList        List of v for each order. This list is 1-larger than
997     ///                     the previous lists, with the last element being the
998     ///                     v value of the ring signature.
999     /// @param rList        List of r for each order. This list is 1-larger than
1000     ///                     the previous lists, with the last element being the
1001     ///                     r value of the ring signature.
1002     /// @param sList        List of s for each order. This list is 1-larger than
1003     ///                     the previous lists, with the last element being the
1004     ///                     s value of the ring signature.
1005     /// @param ringminer    The address that signed this tx.
1006     /// @param feeRecipient The Recipient address for fee collection. If this is
1007     ///                     '0x0', all fees will be paid to the address who had
1008     ///                     signed this transaction, not `msg.sender`. Noted if
1009     ///                     LRC need to be paid back to order owner as the result
1010     ///                     of fee selection model, LRC will also be sent from
1011     ///                     this address.
1012     function submitRing(
1013         address[2][]  addressList,
1014         uint[7][]     uintArgsList,
1015         uint8[2][]    uint8ArgsList,
1016         bool[]        buyNoMoreThanAmountBList,
1017         uint8[]       vList,
1018         bytes32[]     rList,
1019         bytes32[]     sList,
1020         address       ringminer,
1021         address       feeRecipient
1022         )
1023         public
1024     {
1025         // Check if the highest bit of ringIndex is '1'.
1026         require(ringIndex & ENTERED_MASK != ENTERED_MASK); // "attempted to re-ent submitRing function");
1027         // Set the highest bit of ringIndex to '1'.
1028         ringIndex |= ENTERED_MASK;
1029         //Check ring size
1030         uint ringSize = addressList.length;
1031         require(ringSize > 1 && ringSize <= maxRingSize); // "invalid ring size");
1032         verifyInputDataIntegrity(
1033             ringSize,
1034             addressList,
1035             uintArgsList,
1036             uint8ArgsList,
1037             buyNoMoreThanAmountBList,
1038             vList,
1039             rList,
1040             sList
1041         );
1042         verifyTokensRegistered(ringSize, addressList);
1043         var (ringhash, ringhashAttributes) = RinghashRegistry(
1044             ringhashRegistryAddress
1045         ).computeAndGetRinghashInfo(
1046             ringSize,
1047             ringminer,
1048             vList,
1049             rList,
1050             sList
1051         );
1052         //Check if we can submit this ringhash.
1053         require(ringhashAttributes[0]); // "Ring claimed by others");
1054         verifySignature(
1055             ringminer,
1056             ringhash,
1057             vList[ringSize],
1058             rList[ringSize],
1059             sList[ringSize]
1060         );
1061         //Assemble input data into structs so we can pass them to other functions.
1062         OrderState[] memory orders = assembleOrders(
1063             addressList,
1064             uintArgsList,
1065             uint8ArgsList,
1066             buyNoMoreThanAmountBList,
1067             vList,
1068             rList,
1069             sList
1070         );
1071         if (feeRecipient == 0x0) {
1072             feeRecipient = ringminer;
1073         }
1074         handleRing(
1075             ringSize,
1076             ringhash,
1077             orders,
1078             ringminer,
1079             feeRecipient,
1080             ringhashAttributes[1]
1081         );
1082         ringIndex = (ringIndex ^ ENTERED_MASK) + 1;
1083     }
1084     /// @dev Cancel a order. cancel amount(amountS or amountB) can be specified
1085     ///      in orderValues.
1086     /// @param addresses          owner, tokenS, tokenB
1087     /// @param orderValues        amountS, amountB, timestamp, ttl, salt, lrcFee,
1088     ///                           cancelAmountS, and cancelAmountB.
1089     /// @param buyNoMoreThanAmountB -
1090     ///                           This indicates when a order should be considered
1091     ///                           as 'completely filled'.
1092     /// @param marginSplitPercentage -
1093     ///                           Percentage of margin split to share with miner.
1094     /// @param v                  Order ECDSA signature parameter v.
1095     /// @param r                  Order ECDSA signature parameters r.
1096     /// @param s                  Order ECDSA signature parameters s.
1097     function cancelOrder(
1098         address[3] addresses,
1099         uint[7]    orderValues,
1100         bool       buyNoMoreThanAmountB,
1101         uint8      marginSplitPercentage,
1102         uint8      v,
1103         bytes32    r,
1104         bytes32    s
1105         )
1106         external
1107     {
1108         uint cancelAmount = orderValues[6];
1109         require(cancelAmount > 0); // "amount to cancel is zero");
1110         Order memory order = Order(
1111             addresses[0],
1112             addresses[1],
1113             addresses[2],
1114             orderValues[0],
1115             orderValues[1],
1116             orderValues[5],
1117             buyNoMoreThanAmountB,
1118             marginSplitPercentage
1119         );
1120         require(msg.sender == order.owner); // "cancelOrder not submitted by order owner");
1121         bytes32 orderHash = calculateOrderHash(
1122             order,
1123             orderValues[2], // timestamp
1124             orderValues[3], // ttl
1125             orderValues[4]  // salt
1126         );
1127         verifySignature(
1128             order.owner,
1129             orderHash,
1130             v,
1131             r,
1132             s
1133         );
1134         cancelledOrFilled[orderHash] = cancelledOrFilled[orderHash].add(cancelAmount);
1135         OrderCancelled(orderHash, cancelAmount);
1136     }
1137     /// @dev   Set a cutoff timestamp to invalidate all orders whose timestamp
1138     ///        is smaller than or equal to the new value of the address's cutoff
1139     ///        timestamp.
1140     /// @param cutoff The cutoff timestamp, will default to `block.timestamp`
1141     ///        if it is 0.
1142     function setCutoff(uint cutoff)
1143         external
1144     {
1145         uint t = (cutoff == 0 || cutoff >= block.timestamp) ? block.timestamp : cutoff;
1146         require(cutoffs[msg.sender] < t); // "attempted to set cutoff to a smaller value"
1147         cutoffs[msg.sender] = t;
1148         CutoffTimestampChanged(msg.sender, t);
1149     }
1150     ////////////////////////////////////////////////////////////////////////////
1151     /// Internal & Private Functions                                         ///
1152     ////////////////////////////////////////////////////////////////////////////
1153     /// @dev Validate a ring.
1154     function verifyRingHasNoSubRing(
1155         uint          ringSize,
1156         OrderState[]  orders
1157         )
1158         private
1159         pure
1160     {
1161         // Check the ring has no sub-ring.
1162         for (uint i = 0; i < ringSize - 1; i++) {
1163             address tokenS = orders[i].order.tokenS;
1164             for (uint j = i + 1; j < ringSize; j++) {
1165                 require(tokenS != orders[j].order.tokenS); // "found sub-ring");
1166             }
1167         }
1168     }
1169     function verifyTokensRegistered(
1170         uint          ringSize,
1171         address[2][]  addressList
1172         )
1173         private
1174         view
1175     {
1176         // Extract the token addresses
1177         address[] memory tokens = new address[](ringSize);
1178         for (uint i = 0; i < ringSize; i++) {
1179             tokens[i] = addressList[i][1];
1180         }
1181         // Test all token addresses at once
1182         require(
1183             TokenRegistry(tokenRegistryAddress).areAllTokensRegistered(tokens)
1184         ); // "token not registered");
1185     }
1186     function handleRing(
1187         uint          ringSize,
1188         bytes32       ringhash,
1189         OrderState[]  orders,
1190         address       miner,
1191         address       feeRecipient,
1192         bool          isRinghashReserved
1193         )
1194         private
1195     {
1196         uint64 _ringIndex = ringIndex ^ ENTERED_MASK;
1197         address _lrcTokenAddress = lrcTokenAddress;
1198         TokenTransferDelegate delegate = TokenTransferDelegate(delegateAddress);
1199         // Do the hard work.
1200         verifyRingHasNoSubRing(ringSize, orders);
1201         // Exchange rates calculation are performed by ring-miners as solidity
1202         // cannot get power-of-1/n operation, therefore we have to verify
1203         // these rates are correct.
1204         verifyMinerSuppliedFillRates(ringSize, orders);
1205         // Scale down each order independently by substracting amount-filled and
1206         // amount-cancelled. Order owner's current balance and allowance are
1207         // not taken into consideration in these operations.
1208         scaleRingBasedOnHistoricalRecords(delegate, ringSize, orders);
1209         // Based on the already verified exchange rate provided by ring-miners,
1210         // we can furthur scale down orders based on token balance and allowance,
1211         // then find the smallest order of the ring, then calculate each order's
1212         // `fillAmountS`.
1213         calculateRingFillAmount(ringSize, orders);
1214         // Calculate each order's `lrcFee` and `lrcRewrard` and splict how much
1215         // of `fillAmountS` shall be paid to matching order or miner as margin
1216         // split.
1217         calculateRingFees(
1218             delegate,
1219             ringSize,
1220             orders,
1221             feeRecipient,
1222             _lrcTokenAddress
1223         );
1224         /// Make transfers.
1225         var (orderHashList, amountsList) = settleRing(
1226             delegate,
1227             ringSize,
1228             orders,
1229             feeRecipient,
1230             _lrcTokenAddress
1231         );
1232         RingMined(
1233             _ringIndex,
1234             ringhash,
1235             miner,
1236             feeRecipient,
1237             isRinghashReserved,
1238             orderHashList,
1239             amountsList
1240         );
1241     }
1242     function settleRing(
1243         TokenTransferDelegate delegate,
1244         uint          ringSize,
1245         OrderState[]  orders,
1246         address       feeRecipient,
1247         address       _lrcTokenAddress
1248         )
1249         private
1250         returns(
1251         bytes32[] memory orderHashList,
1252         uint[6][] memory amountsList)
1253     {
1254         bytes32[] memory batch = new bytes32[](ringSize * 6); // ringSize * (owner + tokenS + 4 amounts)
1255         orderHashList = new bytes32[](ringSize);
1256         amountsList = new uint[6][](ringSize);
1257         uint p = 0;
1258         for (uint i = 0; i < ringSize; i++) {
1259             OrderState memory state = orders[i];
1260             Order memory order = state.order;
1261             uint prevSplitB = orders[(i + ringSize - 1) % ringSize].splitB;
1262             uint nextFillAmountS = orders[(i + 1) % ringSize].fillAmountS;
1263             // Store owner and tokenS of every order
1264             batch[p] = bytes32(order.owner);
1265             batch[p+1] = bytes32(order.tokenS);
1266             // Store all amounts
1267             batch[p+2] = bytes32(state.fillAmountS - prevSplitB);
1268             batch[p+3] = bytes32(prevSplitB + state.splitS);
1269             batch[p+4] = bytes32(state.lrcReward);
1270             batch[p+5] = bytes32(state.lrcFee);
1271             p += 6;
1272             // Update fill records
1273             if (order.buyNoMoreThanAmountB) {
1274                 cancelledOrFilled[state.orderHash] += nextFillAmountS;
1275             } else {
1276                 cancelledOrFilled[state.orderHash] += state.fillAmountS;
1277             }
1278             orderHashList[i] = state.orderHash;
1279             amountsList[i][0] = state.fillAmountS + state.splitS;
1280             amountsList[i][1] = nextFillAmountS - state.splitB;
1281             amountsList[i][2] = state.lrcReward;
1282             amountsList[i][3] = state.lrcFee;
1283             amountsList[i][4] = state.splitS;
1284             amountsList[i][5] = state.splitB;
1285         }
1286         // Do all transactions
1287         delegate.batchTransferToken(_lrcTokenAddress, feeRecipient, batch);
1288     }
1289     /// @dev Verify miner has calculte the rates correctly.
1290     function verifyMinerSuppliedFillRates(
1291         uint          ringSize,
1292         OrderState[]  orders
1293         )
1294         private
1295         view
1296     {
1297         uint[] memory rateRatios = new uint[](ringSize);
1298         uint _rateRatioScale = RATE_RATIO_SCALE;
1299         for (uint i = 0; i < ringSize; i++) {
1300             uint s1b0 = orders[i].rate.amountS.mul(orders[i].order.amountB);
1301             uint s0b1 = orders[i].order.amountS.mul(orders[i].rate.amountB);
1302             require(s1b0 <= s0b1); // "miner supplied exchange rate provides invalid discount");
1303             rateRatios[i] = _rateRatioScale.mul(s1b0) / s0b1;
1304         }
1305         uint cvs = MathUint.cvsquare(rateRatios, _rateRatioScale);
1306         require(cvs <= rateRatioCVSThreshold); // "miner supplied exchange rate is not evenly discounted");
1307     }
1308     /// @dev Calculate each order's fee or LRC reward.
1309     function calculateRingFees(
1310         TokenTransferDelegate delegate,
1311         uint            ringSize,
1312         OrderState[]    orders,
1313         address         feeRecipient,
1314         address         _lrcTokenAddress
1315         )
1316         private
1317         view
1318     {
1319         bool checkedMinerLrcSpendable = false;
1320         uint minerLrcSpendable = 0;
1321         uint8 _marginSplitPercentageBase = MARGIN_SPLIT_PERCENTAGE_BASE;
1322         uint nextFillAmountS;
1323         for (uint i = 0; i < ringSize; i++) {
1324             OrderState memory state = orders[i];
1325             uint lrcReceiable = 0;
1326             if (state.lrcFee == 0) {
1327                 // When an order's LRC fee is 0 or smaller than the specified fee,
1328                 // we help miner automatically select margin-split.
1329                 state.feeSelection = FEE_SELECT_MARGIN_SPLIT;
1330                 state.order.marginSplitPercentage = _marginSplitPercentageBase;
1331             } else {
1332                 uint lrcSpendable = getSpendable(
1333                     delegate,
1334                     _lrcTokenAddress,
1335                     state.order.owner
1336                 );
1337                 // If the order is selling LRC, we need to calculate how much LRC
1338                 // is left that can be used as fee.
1339                 if (state.order.tokenS == _lrcTokenAddress) {
1340                     lrcSpendable -= state.fillAmountS;
1341                 }
1342                 // If the order is buyign LRC, it will has more to pay as fee.
1343                 if (state.order.tokenB == _lrcTokenAddress) {
1344                     nextFillAmountS = orders[(i + 1) % ringSize].fillAmountS;
1345                     lrcReceiable = nextFillAmountS;
1346                 }
1347                 uint lrcTotal = lrcSpendable + lrcReceiable;
1348                 // If order doesn't have enough LRC, set margin split to 100%.
1349                 if (lrcTotal < state.lrcFee) {
1350                     state.lrcFee = lrcTotal;
1351                     state.order.marginSplitPercentage = _marginSplitPercentageBase;
1352                 }
1353                 if (state.lrcFee == 0) {
1354                     state.feeSelection = FEE_SELECT_MARGIN_SPLIT;
1355                 }
1356             }
1357             if (state.feeSelection == FEE_SELECT_LRC) {
1358                 if (lrcReceiable > 0) {
1359                     if (lrcReceiable >= state.lrcFee) {
1360                         state.splitB = state.lrcFee;
1361                         state.lrcFee = 0;
1362                     } else {
1363                         state.splitB = lrcReceiable;
1364                         state.lrcFee -= lrcReceiable;
1365                     }
1366                 }
1367             } else if (state.feeSelection == FEE_SELECT_MARGIN_SPLIT) {
1368                 // Only check the available miner balance when absolutely needed
1369                 if (!checkedMinerLrcSpendable && minerLrcSpendable < state.lrcFee) {
1370                     checkedMinerLrcSpendable = true;
1371                     minerLrcSpendable = getSpendable(delegate, _lrcTokenAddress, feeRecipient);
1372                 }
1373                 // Only calculate split when miner has enough LRC;
1374                 // otherwise all splits are 0.
1375                 if (minerLrcSpendable >= state.lrcFee) {
1376                     nextFillAmountS = orders[(i + 1) % ringSize].fillAmountS;
1377                     uint split;
1378                     if (state.order.buyNoMoreThanAmountB) {
1379                         split = (nextFillAmountS.mul(
1380                             state.order.amountS
1381                         ) / state.order.amountB).sub(
1382                             state.fillAmountS
1383                         );
1384                     } else {
1385                         split = nextFillAmountS.sub(
1386                             state.fillAmountS.mul(
1387                                 state.order.amountB
1388                             ) / state.order.amountS
1389                         );
1390                     }
1391                     if (state.order.marginSplitPercentage != _marginSplitPercentageBase) {
1392                         split = split.mul(
1393                             state.order.marginSplitPercentage
1394                         ) / _marginSplitPercentageBase;
1395                     }
1396                     if (state.order.buyNoMoreThanAmountB) {
1397                         state.splitS = split;
1398                     } else {
1399                         state.splitB = split;
1400                     }
1401                     // This implicits order with smaller index in the ring will
1402                     // be paid LRC reward first, so the orders in the ring does
1403                     // mater.
1404                     if (split > 0) {
1405                         minerLrcSpendable -= state.lrcFee;
1406                         state.lrcReward = state.lrcFee;
1407                     }
1408                 }
1409                 state.lrcFee = 0;
1410             } else {
1411                 revert(); // "unsupported fee selection value");
1412             }
1413         }
1414     }
1415     /// @dev Calculate each order's fill amount.
1416     function calculateRingFillAmount(
1417         uint          ringSize,
1418         OrderState[]  orders
1419         )
1420         private
1421         pure
1422     {
1423         uint smallestIdx = 0;
1424         uint i;
1425         uint j;
1426         for (i = 0; i < ringSize; i++) {
1427             j = (i + 1) % ringSize;
1428             smallestIdx = calculateOrderFillAmount(
1429                 orders[i],
1430                 orders[j],
1431                 i,
1432                 j,
1433                 smallestIdx
1434             );
1435         }
1436         for (i = 0; i < smallestIdx; i++) {
1437             calculateOrderFillAmount(
1438                 orders[i],
1439                 orders[(i + 1) % ringSize],
1440                 0,               // Not needed
1441                 0,               // Not needed
1442                 0                // Not needed
1443             );
1444         }
1445     }
1446     /// @return The smallest order's index.
1447     function calculateOrderFillAmount(
1448         OrderState        state,
1449         OrderState        next,
1450         uint              i,
1451         uint              j,
1452         uint              smallestIdx
1453         )
1454         private
1455         pure
1456         returns (uint newSmallestIdx)
1457     {
1458         // Default to the same smallest index
1459         newSmallestIdx = smallestIdx;
1460         uint fillAmountB = state.fillAmountS.mul(
1461             state.rate.amountB
1462         ) / state.rate.amountS;
1463         if (state.order.buyNoMoreThanAmountB) {
1464             if (fillAmountB > state.order.amountB) {
1465                 fillAmountB = state.order.amountB;
1466                 state.fillAmountS = fillAmountB.mul(
1467                     state.rate.amountS
1468                 ) / state.rate.amountB;
1469                 newSmallestIdx = i;
1470             }
1471             state.lrcFee = state.order.lrcFee.mul(
1472                 fillAmountB
1473             ) / state.order.amountB;
1474         } else {
1475             state.lrcFee = state.order.lrcFee.mul(
1476                 state.fillAmountS
1477             ) / state.order.amountS;
1478         }
1479         if (fillAmountB <= next.fillAmountS) {
1480             next.fillAmountS = fillAmountB;
1481         } else {
1482             newSmallestIdx = j;
1483         }
1484     }
1485     /// @dev Scale down all orders based on historical fill or cancellation
1486     ///      stats but key the order's original exchange rate.
1487     function scaleRingBasedOnHistoricalRecords(
1488         TokenTransferDelegate delegate,
1489         uint ringSize,
1490         OrderState[] orders
1491         )
1492         private
1493         view
1494     {
1495         for (uint i = 0; i < ringSize; i++) {
1496             OrderState memory state = orders[i];
1497             Order memory order = state.order;
1498             uint amount;
1499             if (order.buyNoMoreThanAmountB) {
1500                 amount = order.amountB.tolerantSub(
1501                     cancelledOrFilled[state.orderHash]
1502                 );
1503                 order.amountS = amount.mul(order.amountS) / order.amountB;
1504                 order.lrcFee = amount.mul(order.lrcFee) / order.amountB;
1505                 order.amountB = amount;
1506             } else {
1507                 amount = order.amountS.tolerantSub(
1508                     cancelledOrFilled[state.orderHash]
1509                 );
1510                 order.amountB = amount.mul(order.amountB) / order.amountS;
1511                 order.lrcFee = amount.mul(order.lrcFee) / order.amountS;
1512                 order.amountS = amount;
1513             }
1514             require(order.amountS > 0); // "amountS is zero");
1515             require(order.amountB > 0); // "amountB is zero");
1516             uint availableAmountS = getSpendable(delegate, order.tokenS, order.owner);
1517             require(availableAmountS > 0); // "order spendable amountS is zero");
1518             state.fillAmountS = (
1519                 order.amountS < availableAmountS ?
1520                 order.amountS : availableAmountS
1521             );
1522         }
1523     }
1524     /// @return Amount of ERC20 token that can be spent by this contract.
1525     function getSpendable(
1526         TokenTransferDelegate delegate,
1527         address tokenAddress,
1528         address tokenOwner
1529         )
1530         private
1531         view
1532         returns (uint)
1533     {
1534         ERC20 token = ERC20(tokenAddress);
1535         uint allowance = token.allowance(
1536             tokenOwner,
1537             address(delegate)
1538         );
1539         uint balance = token.balanceOf(tokenOwner);
1540         return (allowance < balance ? allowance : balance);
1541     }
1542     /// @dev verify input data's basic integrity.
1543     function verifyInputDataIntegrity(
1544         uint          ringSize,
1545         address[2][]  addressList,
1546         uint[7][]     uintArgsList,
1547         uint8[2][]    uint8ArgsList,
1548         bool[]        buyNoMoreThanAmountBList,
1549         uint8[]       vList,
1550         bytes32[]     rList,
1551         bytes32[]     sList
1552         )
1553         private
1554         pure
1555     {
1556         require(ringSize == addressList.length); // "ring data is inconsistent - addressList");
1557         require(ringSize == uintArgsList.length); // "ring data is inconsistent - uintArgsList");
1558         require(ringSize == uint8ArgsList.length); // "ring data is inconsistent - uint8ArgsList");
1559         require(ringSize == buyNoMoreThanAmountBList.length); // "ring data is inconsistent - buyNoMoreThanAmountBList");
1560         require(ringSize + 1 == vList.length); // "ring data is inconsistent - vList");
1561         require(ringSize + 1 == rList.length); // "ring data is inconsistent - rList");
1562         require(ringSize + 1 == sList.length); // "ring data is inconsistent - sList");
1563         // Validate ring-mining related arguments.
1564         for (uint i = 0; i < ringSize; i++) {
1565             require(uintArgsList[i][6] > 0); // "order rateAmountS is zero");
1566             require(uint8ArgsList[i][1] <= FEE_SELECT_MAX_VALUE); // "invalid order fee selection");
1567         }
1568     }
1569     /// @dev        assmble order parameters into Order struct.
1570     /// @return     A list of orders.
1571     function assembleOrders(
1572         address[2][]    addressList,
1573         uint[7][]       uintArgsList,
1574         uint8[2][]      uint8ArgsList,
1575         bool[]          buyNoMoreThanAmountBList,
1576         uint8[]         vList,
1577         bytes32[]       rList,
1578         bytes32[]       sList
1579         )
1580         private
1581         view
1582         returns (OrderState[] memory orders)
1583     {
1584         uint ringSize = addressList.length;
1585         orders = new OrderState[](ringSize);
1586         for (uint i = 0; i < ringSize; i++) {
1587             uint[7] memory uintArgs = uintArgsList[i];
1588             Order memory order = Order(
1589                 addressList[i][0],
1590                 addressList[i][1],
1591                 addressList[(i + 1) % ringSize][1],
1592                 uintArgs[0],
1593                 uintArgs[1],
1594                 uintArgs[5],
1595                 buyNoMoreThanAmountBList[i],
1596                 uint8ArgsList[i][0]
1597             );
1598             bytes32 orderHash = calculateOrderHash(
1599                 order,
1600                 uintArgs[2], // timestamp
1601                 uintArgs[3], // ttl
1602                 uintArgs[4]  // salt
1603             );
1604             verifySignature(
1605                 order.owner,
1606                 orderHash,
1607                 vList[i],
1608                 rList[i],
1609                 sList[i]
1610             );
1611             validateOrder(
1612                 order,
1613                 uintArgs[2], // timestamp
1614                 uintArgs[3], // ttl
1615                 uintArgs[4]  // salt
1616             );
1617             orders[i] = OrderState(
1618                 order,
1619                 orderHash,
1620                 uint8ArgsList[i][1],  // feeSelection
1621                 Rate(uintArgs[6], order.amountB),
1622                 0,   // fillAmountS
1623                 0,   // lrcReward
1624                 0,   // lrcFee
1625                 0,   // splitS
1626                 0    // splitB
1627             );
1628         }
1629     }
1630     /// @dev validate order's parameters are OK.
1631     function validateOrder(
1632         Order        order,
1633         uint         timestamp,
1634         uint         ttl,
1635         uint         salt
1636         )
1637         private
1638         view
1639     {
1640         require(order.owner != 0x0); // "invalid order owner");
1641         require(order.tokenS != 0x0); // "invalid order tokenS");
1642         require(order.tokenB != 0x0); // "invalid order tokenB");
1643         require(order.amountS != 0); // "invalid order amountS");
1644         require(order.amountB != 0); // "invalid order amountB");
1645         require(timestamp <= block.timestamp); // "order is too early to match");
1646         require(timestamp > cutoffs[order.owner]); // "order is cut off");
1647         require(ttl != 0); // "order ttl is 0");
1648         require(timestamp + ttl > block.timestamp); // "order is expired");
1649         require(salt != 0); // "invalid order salt");
1650         require(order.marginSplitPercentage <= MARGIN_SPLIT_PERCENTAGE_BASE); // "invalid order marginSplitPercentage");
1651     }
1652     /// @dev Get the Keccak-256 hash of order with specified parameters.
1653     function calculateOrderHash(
1654         Order        order,
1655         uint         timestamp,
1656         uint         ttl,
1657         uint         salt
1658         )
1659         private
1660         view
1661         returns (bytes32)
1662     {
1663         return keccak256(
1664             address(this),
1665             order.owner,
1666             order.tokenS,
1667             order.tokenB,
1668             order.amountS,
1669             order.amountB,
1670             timestamp,
1671             ttl,
1672             salt,
1673             order.lrcFee,
1674             order.buyNoMoreThanAmountB,
1675             order.marginSplitPercentage
1676         );
1677     }
1678     /// @dev Verify signer's signature.
1679     function verifySignature(
1680         address signer,
1681         bytes32 hash,
1682         uint8   v,
1683         bytes32 r,
1684         bytes32 s
1685         )
1686         private
1687         pure
1688     {
1689         require(
1690             signer == ecrecover(
1691                 keccak256("\x19Ethereum Signed Message:\n32", hash),
1692                 v,
1693                 r,
1694                 s
1695             )
1696         ); // "invalid signature");
1697     }
1698 }