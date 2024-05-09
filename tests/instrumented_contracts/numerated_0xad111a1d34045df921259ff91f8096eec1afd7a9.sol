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
130     /// [_amountSList, _amountBList, _lrcRewardList, _lrcFeeList].
131     event RingMined(
132         uint                _ringIndex,
133         bytes32     indexed _ringhash,
134         address             _miner,
135         address             _feeRecipient,
136         bool                _isRinghashReserved,
137         bytes32[]           _orderHashList,
138         uint[4][]           _amountsList
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
323     function submitRinghash(
324         address     ringminer,
325         bytes32     ringhash
326         )
327         public
328     {
329         require(canSubmit(ringhash, ringminer)); //, "Ringhash submitted");
330         submissions[ringhash] = Submission(ringminer, block.number);
331         RinghashSubmitted(ringminer, ringhash);
332     }
333     function batchSubmitRinghash(
334         address[]     ringminerList,
335         bytes32[]     ringhashList
336         )
337         external
338     {
339         uint size = ringminerList.length;
340         require(size > 0);
341         require(size == ringhashList.length);
342         for (uint i = 0; i < size; i++) {
343             submitRinghash(ringminerList[i], ringhashList[i]);
344         }
345     }
346     /// @dev Calculate the hash of a ring.
347     function calculateRinghash(
348         uint        ringSize,
349         uint8[]     vList,
350         bytes32[]   rList,
351         bytes32[]   sList
352         )
353         private
354         pure
355         returns (bytes32)
356     {
357         require(
358             ringSize == vList.length - 1 && (
359             ringSize == rList.length - 1 && (
360             ringSize == sList.length - 1))
361         ); //, "invalid ring data");
362         return keccak256(
363             vList.xorReduce(ringSize),
364             rList.xorReduce(ringSize),
365             sList.xorReduce(ringSize)
366         );
367     }
368      /// return value attributes[2] contains the following values in this order:
369      /// canSubmit, isReserved.
370     function computeAndGetRinghashInfo(
371         uint        ringSize,
372         address     ringminer,
373         uint8[]     vList,
374         bytes32[]   rList,
375         bytes32[]   sList
376         )
377         external
378         view
379         returns (bytes32 ringhash, bool[2] attributes)
380     {
381         ringhash = calculateRinghash(
382             ringSize,
383             vList,
384             rList,
385             sList
386         );
387         attributes[0] = canSubmit(ringhash, ringminer);
388         attributes[1] = isReserved(ringhash, ringminer);
389     }
390     /// @return true if a ring's hash can be submitted;
391     /// false otherwise.
392     function canSubmit(
393         bytes32 ringhash,
394         address ringminer)
395         public
396         view
397         returns (bool)
398     {
399         require(ringminer != 0x0);
400         var submission = submissions[ringhash];
401         address miner = submission.ringminer;
402         return (
403             miner == 0x0 || (
404             submission.block + blocksToLive < block.number) || (
405             miner == ringminer)
406         );
407     }
408     /// @return true if a ring's hash was submitted and still valid;
409     /// false otherwise.
410     function isReserved(
411         bytes32 ringhash,
412         address ringminer)
413         public
414         view
415         returns (bool)
416     {
417         var submission = submissions[ringhash];
418         return (
419             submission.block + blocksToLive >= block.number && (
420             submission.ringminer == ringminer)
421         );
422     }
423 }
424 /*
425   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
426   Licensed under the Apache License, Version 2.0 (the "License");
427   you may not use this file except in compliance with the License.
428   You may obtain a copy of the License at
429   http://www.apache.org/licenses/LICENSE-2.0
430   Unless required by applicable law or agreed to in writing, software
431   distributed under the License is distributed on an "AS IS" BASIS,
432   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
433   See the License for the specific language governing permissions and
434   limitations under the License.
435 */
436 /*
437   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
438   Licensed under the Apache License, Version 2.0 (the "License");
439   you may not use this file except in compliance with the License.
440   You may obtain a copy of the License at
441   http://www.apache.org/licenses/LICENSE-2.0
442   Unless required by applicable law or agreed to in writing, software
443   distributed under the License is distributed on an "AS IS" BASIS,
444   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
445   See the License for the specific language governing permissions and
446   limitations under the License.
447 */
448 /*
449   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
450   Licensed under the Apache License, Version 2.0 (the "License");
451   you may not use this file except in compliance with the License.
452   You may obtain a copy of the License at
453   http://www.apache.org/licenses/LICENSE-2.0
454   Unless required by applicable law or agreed to in writing, software
455   distributed under the License is distributed on an "AS IS" BASIS,
456   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
457   See the License for the specific language governing permissions and
458   limitations under the License.
459 */
460 /// @title Ownable
461 /// @dev The Ownable contract has an owner address, and provides basic
462 ///      authorization control functions, this simplifies the implementation of
463 ///      "user permissions".
464 contract Ownable {
465     address public owner;
466     event OwnershipTransferred(
467         address indexed previousOwner,
468         address indexed newOwner
469     );
470     /// @dev The Ownable constructor sets the original `owner` of the contract
471     ///      to the sender.
472     function Ownable() public {
473         owner = msg.sender;
474     }
475     /// @dev Throws if called by any account other than the owner.
476     modifier onlyOwner() {
477         require(msg.sender == owner);
478         _;
479     }
480     /// @dev Allows the current owner to transfer control of the contract to a
481     ///      newOwner.
482     /// @param newOwner The address to transfer ownership to.
483     function transferOwnership(address newOwner) onlyOwner public {
484         require(newOwner != 0x0);
485         OwnershipTransferred(owner, newOwner);
486         owner = newOwner;
487     }
488 }
489 /// @title Claimable
490 /// @dev Extension for the Ownable contract, where the ownership needs
491 ///      to be claimed. This allows the new owner to accept the transfer.
492 contract Claimable is Ownable {
493     address public pendingOwner;
494     /// @dev Modifier throws if called by any account other than the pendingOwner.
495     modifier onlyPendingOwner() {
496         require(msg.sender == pendingOwner);
497         _;
498     }
499     /// @dev Allows the current owner to set the pendingOwner address.
500     /// @param newOwner The address to transfer ownership to.
501     function transferOwnership(address newOwner) onlyOwner public {
502         require(newOwner != 0x0 && newOwner != owner);
503         pendingOwner = newOwner;
504     }
505     /// @dev Allows the pendingOwner address to finalize the transfer.
506     function claimOwnership() onlyPendingOwner public {
507         OwnershipTransferred(owner, pendingOwner);
508         owner = pendingOwner;
509         pendingOwner = 0x0;
510     }
511 }
512 /// @title Token Register Contract
513 /// @dev This contract maintains a list of tokens the Protocol supports.
514 /// @author Kongliang Zhong - <kongliang@loopring.org>,
515 /// @author Daniel Wang - <daniel@loopring.org>.
516 contract TokenRegistry is Claimable {
517     address[] public tokens;
518     mapping (address => bool) tokenMap;
519     mapping (string => address) tokenSymbolMap;
520     function registerToken(address _token, string _symbol)
521         external
522         onlyOwner
523     {
524         require(_token != 0x0);
525         require(!isTokenRegisteredBySymbol(_symbol));
526         require(!isTokenRegistered(_token));
527         tokens.push(_token);
528         tokenMap[_token] = true;
529         tokenSymbolMap[_symbol] = _token;
530     }
531     function unregisterToken(address _token, string _symbol)
532         external
533         onlyOwner
534     {
535         require(_token != 0x0);
536         require(tokenSymbolMap[_symbol] == _token);
537         delete tokenSymbolMap[_symbol];
538         delete tokenMap[_token];
539         for (uint i = 0; i < tokens.length; i++) {
540             if (tokens[i] == _token) {
541                 tokens[i] = tokens[tokens.length - 1];
542                 tokens.length --;
543                 break;
544             }
545         }
546     }
547     function isTokenRegisteredBySymbol(string symbol)
548         public
549         view
550         returns (bool)
551     {
552         return tokenSymbolMap[symbol] != 0x0;
553     }
554     function isTokenRegistered(address _token)
555         public
556         view
557         returns (bool)
558     {
559         return tokenMap[_token];
560     }
561     function areAllTokensRegistered(address[] tokenList)
562         external
563         view
564         returns (bool)
565     {
566         for (uint i = 0; i < tokenList.length; i++) {
567             if (!tokenMap[tokenList[i]]) {
568                 return false;
569             }
570         }
571         return true;
572     }
573     function getAddressBySymbol(string symbol)
574         external
575         view
576         returns (address)
577     {
578         return tokenSymbolMap[symbol];
579     }
580 }
581 /*
582   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
583   Licensed under the Apache License, Version 2.0 (the "License");
584   you may not use this file except in compliance with the License.
585   You may obtain a copy of the License at
586   http://www.apache.org/licenses/LICENSE-2.0
587   Unless required by applicable law or agreed to in writing, software
588   distributed under the License is distributed on an "AS IS" BASIS,
589   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
590   See the License for the specific language governing permissions and
591   limitations under the License.
592 */
593 /// @title TokenTransferDelegate
594 /// @dev Acts as a middle man to transfer ERC20 tokens on behalf of different
595 /// versions of Loopring protocol to avoid ERC20 re-authorization.
596 /// @author Daniel Wang - <daniel@loopring.org>.
597 contract TokenTransferDelegate is Claimable {
598     using MathUint for uint;
599     ////////////////////////////////////////////////////////////////////////////
600     /// Variables                                                            ///
601     ////////////////////////////////////////////////////////////////////////////
602     mapping(address => AddressInfo) private addressInfos;
603     address public latestAddress;
604     ////////////////////////////////////////////////////////////////////////////
605     /// Structs                                                              ///
606     ////////////////////////////////////////////////////////////////////////////
607     struct AddressInfo {
608         address previous;
609         uint32  index;
610         bool    authorized;
611     }
612     ////////////////////////////////////////////////////////////////////////////
613     /// Modifiers                                                            ///
614     ////////////////////////////////////////////////////////////////////////////
615     modifier onlyAuthorized() {
616         require(addressInfos[msg.sender].authorized);
617         _;
618     }
619     ////////////////////////////////////////////////////////////////////////////
620     /// Events                                                               ///
621     ////////////////////////////////////////////////////////////////////////////
622     event AddressAuthorized(address indexed addr, uint32 number);
623     event AddressDeauthorized(address indexed addr, uint32 number);
624     ////////////////////////////////////////////////////////////////////////////
625     /// Public Functions                                                     ///
626     ////////////////////////////////////////////////////////////////////////////
627     /// @dev Add a Loopring protocol address.
628     /// @param addr A loopring protocol address.
629     function authorizeAddress(address addr)
630         onlyOwner
631         external
632     {
633         var addrInfo = addressInfos[addr];
634         if (addrInfo.index != 0) { // existing
635             if (addrInfo.authorized == false) { // re-authorize
636                 addrInfo.authorized = true;
637                 AddressAuthorized(addr, addrInfo.index);
638             }
639         } else {
640             address prev = latestAddress;
641             if (prev == 0x0) {
642                 addrInfo.index = 1;
643                 addrInfo.authorized = true;
644             } else {
645                 addrInfo.previous = prev;
646                 addrInfo.index = addressInfos[prev].index + 1;
647             }
648             addrInfo.authorized = true;
649             latestAddress = addr;
650             AddressAuthorized(addr, addrInfo.index);
651         }
652     }
653     /// @dev Remove a Loopring protocol address.
654     /// @param addr A loopring protocol address.
655     function deauthorizeAddress(address addr)
656         onlyOwner
657         external
658     {
659         uint32 index = addressInfos[addr].index;
660         if (index != 0) {
661             addressInfos[addr].authorized = false;
662             AddressDeauthorized(addr, index);
663         }
664     }
665     function isAddressAuthorized(address addr)
666         public
667         view
668         returns (bool)
669     {
670         return addressInfos[addr].authorized;
671     }
672     function getLatestAuthorizedAddresses(uint max)
673         external
674         view
675         returns (address[] addresses)
676     {
677         addresses = new address[](max);
678         address addr = latestAddress;
679         AddressInfo memory addrInfo;
680         uint count = 0;
681         while (addr != 0x0 && count < max) {
682             addrInfo = addressInfos[addr];
683             if (addrInfo.index == 0) {
684                 break;
685             }
686             addresses[count++] = addr;
687             addr = addrInfo.previous;
688         }
689     }
690     /// @dev Invoke ERC20 transferFrom method.
691     /// @param token Address of token to transfer.
692     /// @param from Address to transfer token from.
693     /// @param to Address to transfer token to.
694     /// @param value Amount of token to transfer.
695     function transferToken(
696         address token,
697         address from,
698         address to,
699         uint    value)
700         onlyAuthorized
701         external
702     {
703         if (value > 0 && from != to) {
704             require(
705                 ERC20(token).transferFrom(from, to, value)
706             );
707         }
708     }
709     function batchTransferToken(
710         address lrcTokenAddress,
711         address feeRecipient,
712         bytes32[] batch)
713         onlyAuthorized
714         external
715     {
716         uint len = batch.length;
717         require(len % 6 == 0);
718         var lrc = ERC20(lrcTokenAddress);
719         for (uint i = 0; i < len; i += 6) {
720             address owner = address(batch[i]);
721             address prevOwner = address(batch[(i + len - 6) % len]);
722             
723             // Pay token to previous order, or to miner as previous order's
724             // margin split or/and this order's margin split.
725             var token = ERC20(address(batch[i + 1]));
726             // Here batch[i+2] has been checked not to be 0.
727             if (owner != prevOwner) {
728                 require(
729                     token.transferFrom(owner, prevOwner, uint(batch[i + 2]))
730                 );
731             }
732             if (owner != feeRecipient) {
733                 bytes32 item = batch[i + 3];
734                 if (item != 0) {
735                     require(
736                         token.transferFrom(owner, feeRecipient, uint(item))
737                     );
738                 } 
739                 item = batch[i + 4];
740                 if (item != 0) {
741                     require(
742                         lrc.transferFrom(feeRecipient, owner, uint(item))
743                     );
744                 }
745                 item = batch[i + 5];
746                 if (item != 0) {
747                     require(
748                         lrc.transferFrom(owner, feeRecipient, uint(item))
749                     );
750                 }
751             }
752         }
753     }
754 }
755 /// @title Loopring Token Exchange Protocol Implementation Contract v1
756 /// @author Daniel Wang - <daniel@loopring.org>,
757 /// @author Kongliang Zhong - <kongliang@loopring.org>
758 ///
759 /// Recognized contributing developers from the community:
760 ///     https://github.com/Brechtpd
761 ///     https://github.com/rainydio
762 ///     https://github.com/BenjaminPrice
763 ///     https://github.com/jonasshen
764 contract LoopringProtocolImpl is LoopringProtocol {
765     using MathUint for uint;
766     ////////////////////////////////////////////////////////////////////////////
767     /// Variables                                                            ///
768     ////////////////////////////////////////////////////////////////////////////
769     address public  lrcTokenAddress             = 0x0;
770     address public  tokenRegistryAddress        = 0x0;
771     address public  ringhashRegistryAddress     = 0x0;
772     address public  delegateAddress             = 0x0;
773     uint    public  maxRingSize                 = 0;
774     uint64  public  ringIndex                   = 0;
775     // Exchange rate (rate) is the amount to sell or sold divided by the amount
776     // to buy or bought.
777     //
778     // Rate ratio is the ratio between executed rate and an order's original
779     // rate.
780     //
781     // To require all orders' rate ratios to have coefficient ofvariation (CV)
782     // smaller than 2.5%, for an example , rateRatioCVSThreshold should be:
783     //     `(0.025 * RATE_RATIO_SCALE)^2` or 62500.
784     uint    public  rateRatioCVSThreshold       = 0;
785     uint    public constant RATE_RATIO_SCALE    = 10000;
786     uint64  public constant ENTERED_MASK        = 1 << 63;
787     // The following map is used to keep trace of order fill and cancellation
788     // history.
789     mapping (bytes32 => uint) public cancelledOrFilled;
790     // A map from address to its cutoff timestamp.
791     mapping (address => uint) public cutoffs;
792     ////////////////////////////////////////////////////////////////////////////
793     /// Structs                                                              ///
794     ////////////////////////////////////////////////////////////////////////////
795     struct Rate {
796         uint amountS;
797         uint amountB;
798     }
799     /// @param tokenS       Token to sell.
800     /// @param tokenB       Token to buy.
801     /// @param amountS      Maximum amount of tokenS to sell.
802     /// @param amountB      Minimum amount of tokenB to buy if all amountS sold.
803     /// @param timestamp    Indicating when this order is created/signed.
804     /// @param ttl          Indicating after how many seconds from `timestamp`
805     ///                     this order will expire.
806     /// @param salt         A random number to make this order's hash unique.
807     /// @param lrcFee       Max amount of LRC to pay for miner. The real amount
808     ///                     to pay is proportional to fill amount.
809     /// @param buyNoMoreThanAmountB -
810     ///                     If true, this order does not accept buying more
811     ///                     than `amountB`.
812     /// @param marginSplitPercentage -
813     ///                     The percentage of margin paid to miner.
814     /// @param v            ECDSA signature parameter v.
815     /// @param r            ECDSA signature parameters r.
816     /// @param s            ECDSA signature parameters s.
817     struct Order {
818         address owner;
819         address tokenS;
820         address tokenB;
821         uint    amountS;
822         uint    amountB;
823         uint    lrcFee;
824         bool    buyNoMoreThanAmountB;
825         uint8   marginSplitPercentage;
826     }
827     /// @param order        The original order
828     /// @param orderHash    The order's hash
829     /// @param feeSelection -
830     ///                     A miner-supplied value indicating if LRC (value = 0)
831     ///                     or margin split is choosen by the miner (value = 1).
832     ///                     We may support more fee model in the future.
833     /// @param rate         Exchange rate provided by miner.
834     /// @param fillAmountS  Amount of tokenS to sell, calculated by protocol.
835     /// @param lrcReward    The amount of LRC paid by miner to order owner in
836     ///                     exchange for margin split.
837     /// @param lrcFee       The amount of LR paid by order owner to miner.
838     /// @param splitS      TokenS paid to miner.
839     /// @param splitB      TokenB paid to miner.
840     struct OrderState {
841         Order   order;
842         bytes32 orderHash;
843         uint8   feeSelection;
844         Rate    rate;
845         uint    fillAmountS;
846         uint    lrcReward;
847         uint    lrcFee;
848         uint    splitS;
849         uint    splitB;
850     }
851     ////////////////////////////////////////////////////////////////////////////
852     /// Constructor                                                          ///
853     ////////////////////////////////////////////////////////////////////////////
854     function LoopringProtocolImpl(
855         address _lrcTokenAddress,
856         address _tokenRegistryAddress,
857         address _ringhashRegistryAddress,
858         address _delegateAddress,
859         uint    _maxRingSize,
860         uint    _rateRatioCVSThreshold
861         )
862         public
863     {
864         require(0x0 != _lrcTokenAddress);
865         require(0x0 != _tokenRegistryAddress);
866         require(0x0 != _ringhashRegistryAddress);
867         require(0x0 != _delegateAddress);
868         require(_maxRingSize > 1);
869         require(_rateRatioCVSThreshold > 0);
870         lrcTokenAddress = _lrcTokenAddress;
871         tokenRegistryAddress = _tokenRegistryAddress;
872         ringhashRegistryAddress = _ringhashRegistryAddress;
873         delegateAddress = _delegateAddress;
874         maxRingSize = _maxRingSize;
875         rateRatioCVSThreshold = _rateRatioCVSThreshold;
876     }
877     ////////////////////////////////////////////////////////////////////////////
878     /// Public Functions                                                     ///
879     ////////////////////////////////////////////////////////////////////////////
880     /// @dev Disable default function.
881     function ()
882         payable
883         public
884     {
885         revert();
886     }
887     /// @dev Submit a order-ring for validation and settlement.
888     /// @param addressList  List of each order's tokenS. Note that next order's
889     ///                     `tokenS` equals this order's `tokenB`.
890     /// @param uintArgsList List of uint-type arguments in this order:
891     ///                     amountS, amountB, timestamp, ttl, salt, lrcFee,
892     ///                     rateAmountS.
893     /// @param uint8ArgsList -
894     ///                     List of unit8-type arguments, in this order:
895     ///                     marginSplitPercentageList,feeSelectionList.
896     /// @param buyNoMoreThanAmountBList -
897     ///                     This indicates when a order should be considered
898     ///                     as 'completely filled'.
899     /// @param vList        List of v for each order. This list is 1-larger than
900     ///                     the previous lists, with the last element being the
901     ///                     v value of the ring signature.
902     /// @param rList        List of r for each order. This list is 1-larger than
903     ///                     the previous lists, with the last element being the
904     ///                     r value of the ring signature.
905     /// @param sList        List of s for each order. This list is 1-larger than
906     ///                     the previous lists, with the last element being the
907     ///                     s value of the ring signature.
908     /// @param ringminer    The address that signed this tx.
909     /// @param feeRecipient The Recipient address for fee collection. If this is
910     ///                     '0x0', all fees will be paid to the address who had
911     ///                     signed this transaction, not `msg.sender`. Noted if
912     ///                     LRC need to be paid back to order owner as the result
913     ///                     of fee selection model, LRC will also be sent from
914     ///                     this address.
915     function submitRing(
916         address[2][]  addressList,
917         uint[7][]     uintArgsList,
918         uint8[2][]    uint8ArgsList,
919         bool[]        buyNoMoreThanAmountBList,
920         uint8[]       vList,
921         bytes32[]     rList,
922         bytes32[]     sList,
923         address       ringminer,
924         address       feeRecipient
925         )
926         public
927     {
928         // Check if the highest bit of ringIndex is '1'.
929         require(ringIndex & ENTERED_MASK != ENTERED_MASK); // "attempted to re-ent submitRing function");
930         // Set the highest bit of ringIndex to '1'.
931         ringIndex |= ENTERED_MASK;
932         //Check ring size
933         uint ringSize = addressList.length;
934         require(ringSize > 1 && ringSize <= maxRingSize); // "invalid ring size");
935         verifyInputDataIntegrity(
936             ringSize,
937             addressList,
938             uintArgsList,
939             uint8ArgsList,
940             buyNoMoreThanAmountBList,
941             vList,
942             rList,
943             sList
944         );
945         verifyTokensRegistered(ringSize, addressList);
946         var (ringhash, ringhashAttributes) = RinghashRegistry(
947             ringhashRegistryAddress
948         ).computeAndGetRinghashInfo(
949             ringSize,
950             ringminer,
951             vList,
952             rList,
953             sList
954         );
955         //Check if we can submit this ringhash.
956         require(ringhashAttributes[0]); // "Ring claimed by others");
957         verifySignature(
958             ringminer,
959             ringhash,
960             vList[ringSize],
961             rList[ringSize],
962             sList[ringSize]
963         );
964         //Assemble input data into structs so we can pass them to other functions.
965         var orders = assembleOrders(
966             addressList,
967             uintArgsList,
968             uint8ArgsList,
969             buyNoMoreThanAmountBList,
970             vList,
971             rList,
972             sList
973         );
974         if (feeRecipient == 0x0) {
975             feeRecipient = ringminer;
976         }
977         handleRing(
978             ringSize,
979             ringhash,
980             orders,
981             ringminer,
982             feeRecipient,
983             ringhashAttributes[1]
984         );
985         ringIndex = (ringIndex ^ ENTERED_MASK) + 1;
986     }
987     /// @dev Cancel a order. cancel amount(amountS or amountB) can be specified
988     ///      in orderValues.
989     /// @param addresses          owner, tokenS, tokenB
990     /// @param orderValues        amountS, amountB, timestamp, ttl, salt, lrcFee,
991     ///                           cancelAmountS, and cancelAmountB.
992     /// @param buyNoMoreThanAmountB -
993     ///                           This indicates when a order should be considered
994     ///                           as 'completely filled'.
995     /// @param marginSplitPercentage -
996     ///                           Percentage of margin split to share with miner.
997     /// @param v                  Order ECDSA signature parameter v.
998     /// @param r                  Order ECDSA signature parameters r.
999     /// @param s                  Order ECDSA signature parameters s.
1000     function cancelOrder(
1001         address[3] addresses,
1002         uint[7]    orderValues,
1003         bool       buyNoMoreThanAmountB,
1004         uint8      marginSplitPercentage,
1005         uint8      v,
1006         bytes32    r,
1007         bytes32    s
1008         )
1009         external
1010     {
1011         uint cancelAmount = orderValues[6];
1012         require(cancelAmount > 0); // "amount to cancel is zero");
1013         var order = Order(
1014             addresses[0],
1015             addresses[1],
1016             addresses[2],
1017             orderValues[0],
1018             orderValues[1],
1019             orderValues[5],
1020             buyNoMoreThanAmountB,
1021             marginSplitPercentage
1022         );
1023         require(msg.sender == order.owner); // "cancelOrder not submitted by order owner");
1024         bytes32 orderHash = calculateOrderHash(
1025             order,
1026             orderValues[2], // timestamp
1027             orderValues[3], // ttl
1028             orderValues[4]  // salt
1029         );
1030         verifySignature(
1031             order.owner,
1032             orderHash,
1033             v,
1034             r,
1035             s
1036         );
1037         cancelledOrFilled[orderHash] = cancelledOrFilled[orderHash].add(cancelAmount);
1038         OrderCancelled(orderHash, cancelAmount);
1039     }
1040     /// @dev   Set a cutoff timestamp to invalidate all orders whose timestamp
1041     ///        is smaller than or equal to the new value of the address's cutoff
1042     ///        timestamp.
1043     /// @param cutoff The cutoff timestamp, will default to `block.timestamp`
1044     ///        if it is 0.
1045     function setCutoff(uint cutoff)
1046         external
1047     {
1048         uint t = (cutoff == 0 || cutoff >= block.timestamp) ? block.timestamp : cutoff;
1049         require(cutoffs[msg.sender] < t); // "attempted to set cutoff to a smaller value"
1050         cutoffs[msg.sender] = t;
1051         CutoffTimestampChanged(msg.sender, t);
1052     }
1053     ////////////////////////////////////////////////////////////////////////////
1054     /// Internal & Private Functions                                         ///
1055     ////////////////////////////////////////////////////////////////////////////
1056     /// @dev Validate a ring.
1057     function verifyRingHasNoSubRing(
1058         uint          ringSize,
1059         OrderState[]  orders
1060         )
1061         private
1062         pure
1063     {
1064         // Check the ring has no sub-ring.
1065         for (uint i = 0; i < ringSize - 1; i++) {
1066             address tokenS = orders[i].order.tokenS;
1067             for (uint j = i + 1; j < ringSize; j++) {
1068                 require(tokenS != orders[j].order.tokenS); // "found sub-ring");
1069             }
1070         }
1071     }
1072     function verifyTokensRegistered(
1073         uint          ringSize,
1074         address[2][]  addressList
1075         )
1076         private
1077         view
1078     {
1079         // Extract the token addresses
1080         var tokens = new address[](ringSize);
1081         for (uint i = 0; i < ringSize; i++) {
1082             tokens[i] = addressList[i][1];
1083         }
1084         // Test all token addresses at once
1085         require(
1086             TokenRegistry(tokenRegistryAddress).areAllTokensRegistered(tokens)
1087         ); // "token not registered");
1088     }
1089     function handleRing(
1090         uint          ringSize,
1091         bytes32       ringhash,
1092         OrderState[]  orders,
1093         address       miner,
1094         address       feeRecipient,
1095         bool          isRinghashReserved
1096         )
1097         private
1098     {
1099         uint64 _ringIndex = ringIndex ^ ENTERED_MASK;
1100         address _lrcTokenAddress = lrcTokenAddress;
1101         var delegate = TokenTransferDelegate(delegateAddress);
1102                 
1103         // Do the hard work.
1104         verifyRingHasNoSubRing(ringSize, orders);
1105         // Exchange rates calculation are performed by ring-miners as solidity
1106         // cannot get power-of-1/n operation, therefore we have to verify
1107         // these rates are correct.
1108         verifyMinerSuppliedFillRates(ringSize, orders);
1109         // Scale down each order independently by substracting amount-filled and
1110         // amount-cancelled. Order owner's current balance and allowance are
1111         // not taken into consideration in these operations.
1112         scaleRingBasedOnHistoricalRecords(delegate, ringSize, orders);
1113         // Based on the already verified exchange rate provided by ring-miners,
1114         // we can furthur scale down orders based on token balance and allowance,
1115         // then find the smallest order of the ring, then calculate each order's
1116         // `fillAmountS`.
1117         calculateRingFillAmount(ringSize, orders);
1118         // Calculate each order's `lrcFee` and `lrcRewrard` and splict how much
1119         // of `fillAmountS` shall be paid to matching order or miner as margin
1120         // split.
1121         calculateRingFees(
1122             delegate,
1123             ringSize,
1124             orders,
1125             feeRecipient,
1126             _lrcTokenAddress
1127         );
1128         /// Make transfers.
1129         var (orderHashList, amountsList) = settleRing(
1130             delegate,
1131             ringSize,
1132             orders,
1133             feeRecipient,
1134             _lrcTokenAddress
1135         );
1136         RingMined(
1137             _ringIndex,
1138             ringhash,
1139             miner,
1140             feeRecipient,
1141             isRinghashReserved,
1142             orderHashList,
1143             amountsList
1144         );
1145     }
1146     function settleRing(
1147         TokenTransferDelegate delegate,
1148         uint          ringSize,
1149         OrderState[]  orders,
1150         address       feeRecipient,
1151         address       _lrcTokenAddress
1152         )
1153         private
1154         returns(
1155         bytes32[] memory orderHashList,
1156         uint[4][] memory amountsList)
1157     {
1158         bytes32[] memory batch = new bytes32[](ringSize * 6); // ringSize * (owner + tokenS + 4 amounts)
1159         orderHashList = new bytes32[](ringSize);
1160         amountsList = new uint[4][](ringSize);
1161         uint p = 0;
1162         for (uint i = 0; i < ringSize; i++) {
1163             var state = orders[i];
1164             var order = state.order;
1165             uint prevSplitB = orders[(i + ringSize - 1) % ringSize].splitB;
1166             uint nextFillAmountS = orders[(i + 1) % ringSize].fillAmountS;
1167             // Store owner and tokenS of every order
1168             batch[p] = bytes32(order.owner);
1169             batch[p+1] = bytes32(order.tokenS);
1170             // Store all amounts
1171             batch[p+2] = bytes32(state.fillAmountS - prevSplitB);
1172             batch[p+3] = bytes32(prevSplitB + state.splitS);
1173             batch[p+4] = bytes32(state.lrcReward);
1174             batch[p+5] = bytes32(state.lrcFee);
1175             p += 6;
1176             // Update fill records
1177             if (order.buyNoMoreThanAmountB) {
1178                 cancelledOrFilled[state.orderHash] += nextFillAmountS;
1179             } else {
1180                 cancelledOrFilled[state.orderHash] += state.fillAmountS;
1181             }
1182             orderHashList[i] = state.orderHash;
1183             amountsList[i][0] = state.fillAmountS + state.splitS;
1184             amountsList[i][1] = nextFillAmountS - state.splitB;
1185             amountsList[i][2] = state.lrcReward;
1186             amountsList[i][3] = state.lrcFee;
1187         }
1188         // Do all transactions
1189         delegate.batchTransferToken(_lrcTokenAddress, feeRecipient, batch);
1190     }
1191     /// @dev Verify miner has calculte the rates correctly.
1192     function verifyMinerSuppliedFillRates(
1193         uint          ringSize,
1194         OrderState[]  orders
1195         )
1196         private
1197         view
1198     {
1199         var rateRatios = new uint[](ringSize);
1200         uint _rateRatioScale = RATE_RATIO_SCALE;
1201         for (uint i = 0; i < ringSize; i++) {
1202             uint s1b0 = orders[i].rate.amountS.mul(orders[i].order.amountB);
1203             uint s0b1 = orders[i].order.amountS.mul(orders[i].rate.amountB);
1204             require(s1b0 <= s0b1); // "miner supplied exchange rate provides invalid discount");
1205             rateRatios[i] = _rateRatioScale.mul(s1b0) / s0b1;
1206         }
1207         uint cvs = MathUint.cvsquare(rateRatios, _rateRatioScale);
1208         require(cvs <= rateRatioCVSThreshold); // "miner supplied exchange rate is not evenly discounted");
1209     }
1210     /// @dev Calculate each order's fee or LRC reward.
1211     function calculateRingFees(
1212         TokenTransferDelegate delegate,
1213         uint            ringSize,
1214         OrderState[]    orders,
1215         address         feeRecipient,
1216         address         _lrcTokenAddress
1217         )
1218         private
1219         view
1220     {
1221         bool checkedMinerLrcSpendable = false;
1222         uint minerLrcSpendable = 0;
1223         uint8 _marginSplitPercentageBase = MARGIN_SPLIT_PERCENTAGE_BASE;
1224         uint nextFillAmountS;
1225         for (uint i = 0; i < ringSize; i++) {
1226             var state = orders[i];
1227             uint lrcReceiable = 0;
1228             if (state.lrcFee == 0) {
1229                 // When an order's LRC fee is 0 or smaller than the specified fee,
1230                 // we help miner automatically select margin-split.
1231                 state.feeSelection = FEE_SELECT_MARGIN_SPLIT;
1232                 state.order.marginSplitPercentage = _marginSplitPercentageBase;
1233             } else {
1234                 uint lrcSpendable = getSpendable(
1235                     delegate,
1236                     _lrcTokenAddress,
1237                     state.order.owner
1238                 );
1239                 // If the order is selling LRC, we need to calculate how much LRC
1240                 // is left that can be used as fee.
1241                 if (state.order.tokenS == _lrcTokenAddress) {
1242                     lrcSpendable -= state.fillAmountS;
1243                 }
1244                 // If the order is buyign LRC, it will has more to pay as fee.
1245                 if (state.order.tokenB == _lrcTokenAddress) {
1246                     nextFillAmountS = orders[(i + 1) % ringSize].fillAmountS;
1247                     lrcReceiable = nextFillAmountS;
1248                 }
1249                 uint lrcTotal = lrcSpendable + lrcReceiable;
1250                 // If order doesn't have enough LRC, set margin split to 100%.
1251                 if (lrcTotal < state.lrcFee) {
1252                     state.lrcFee = lrcTotal;
1253                     state.order.marginSplitPercentage = _marginSplitPercentageBase;
1254                 }
1255                 if (state.lrcFee == 0) {
1256                     state.feeSelection = FEE_SELECT_MARGIN_SPLIT;
1257                 }
1258             }
1259             if (state.feeSelection == FEE_SELECT_LRC) {
1260                 if (lrcReceiable > 0) {
1261                     if (lrcReceiable >= state.lrcFee) {
1262                         state.splitB = state.lrcFee;
1263                         state.lrcFee = 0;
1264                     } else {
1265                         state.splitB = lrcReceiable;
1266                         state.lrcFee -= lrcReceiable;
1267                     }
1268                 }
1269             } else if (state.feeSelection == FEE_SELECT_MARGIN_SPLIT) {
1270                 // Only check the available miner balance when absolutely needed
1271                 if (!checkedMinerLrcSpendable && minerLrcSpendable < state.lrcFee) {
1272                     checkedMinerLrcSpendable = true;
1273                     minerLrcSpendable = getSpendable(delegate, _lrcTokenAddress, feeRecipient);
1274                 }
1275                 // Only calculate split when miner has enough LRC;
1276                 // otherwise all splits are 0.
1277                 if (minerLrcSpendable >= state.lrcFee) {
1278                     nextFillAmountS = orders[(i + 1) % ringSize].fillAmountS;
1279                     uint split;
1280                     if (state.order.buyNoMoreThanAmountB) {
1281                         split = (nextFillAmountS.mul(
1282                             state.order.amountS
1283                         ) / state.order.amountB).sub(
1284                             state.fillAmountS
1285                         );
1286                     } else {
1287                         split = nextFillAmountS.sub(
1288                             state.fillAmountS.mul(
1289                                 state.order.amountB
1290                             ) / state.order.amountS
1291                         );
1292                     }
1293                     if (state.order.marginSplitPercentage != _marginSplitPercentageBase) {
1294                         split = split.mul(
1295                             state.order.marginSplitPercentage
1296                         ) / _marginSplitPercentageBase;
1297                     }
1298                     if (state.order.buyNoMoreThanAmountB) {
1299                         state.splitS = split;
1300                     } else {
1301                         state.splitB = split;
1302                     }
1303                     // This implicits order with smaller index in the ring will
1304                     // be paid LRC reward first, so the orders in the ring does
1305                     // mater.
1306                     if (split > 0) {
1307                         minerLrcSpendable -= state.lrcFee;
1308                         state.lrcReward = state.lrcFee;
1309                     }
1310                 }
1311                 state.lrcFee = 0;
1312             } else {
1313                 revert(); // "unsupported fee selection value");
1314             }
1315         }
1316     }
1317     /// @dev Calculate each order's fill amount.
1318     function calculateRingFillAmount(
1319         uint          ringSize,
1320         OrderState[]  orders
1321         )
1322         private
1323         pure
1324     {
1325         uint smallestIdx = 0;
1326         uint i;
1327         uint j;
1328         for (i = 0; i < ringSize; i++) {
1329             j = (i + 1) % ringSize;
1330             smallestIdx = calculateOrderFillAmount(
1331                 orders[i],
1332                 orders[j],
1333                 i,
1334                 j,
1335                 smallestIdx
1336             );
1337         }
1338         for (i = 0; i < smallestIdx; i++) {
1339             calculateOrderFillAmount(
1340                 orders[i],
1341                 orders[(i + 1) % ringSize],
1342                 0,               // Not needed
1343                 0,               // Not needed
1344                 0                // Not needed
1345             );
1346         }
1347     }
1348     /// @return The smallest order's index.
1349     function calculateOrderFillAmount(
1350         OrderState        state,
1351         OrderState        next,
1352         uint              i,
1353         uint              j,
1354         uint              smallestIdx
1355         )
1356         private
1357         pure
1358         returns (uint newSmallestIdx)
1359     {
1360         // Default to the same smallest index
1361         newSmallestIdx = smallestIdx;
1362         uint fillAmountB = state.fillAmountS.mul(
1363             state.rate.amountB
1364         ) / state.rate.amountS;
1365         if (state.order.buyNoMoreThanAmountB) {
1366             if (fillAmountB > state.order.amountB) {
1367                 fillAmountB = state.order.amountB;
1368                 state.fillAmountS = fillAmountB.mul(
1369                     state.rate.amountS
1370                 ) / state.rate.amountB;
1371                 newSmallestIdx = i;
1372             }
1373             state.lrcFee = state.order.lrcFee.mul(
1374                 fillAmountB
1375             ) / state.order.amountB;
1376         } else {
1377             state.lrcFee = state.order.lrcFee.mul(
1378                 state.fillAmountS
1379             ) / state.order.amountS;
1380         }
1381         if (fillAmountB <= next.fillAmountS) {
1382             next.fillAmountS = fillAmountB;
1383         } else {
1384             newSmallestIdx = j;
1385         }
1386     }
1387     /// @dev Scale down all orders based on historical fill or cancellation
1388     ///      stats but key the order's original exchange rate.
1389     function scaleRingBasedOnHistoricalRecords(
1390         TokenTransferDelegate delegate,
1391         uint ringSize,
1392         OrderState[] orders
1393         )
1394         private
1395         view
1396     {
1397         for (uint i = 0; i < ringSize; i++) {
1398             var state = orders[i];
1399             var order = state.order;
1400             uint amount;
1401             if (order.buyNoMoreThanAmountB) {
1402                 amount = order.amountB.tolerantSub(
1403                     cancelledOrFilled[state.orderHash]
1404                 );
1405                 order.amountS = amount.mul(order.amountS) / order.amountB;
1406                 order.lrcFee = amount.mul(order.lrcFee) / order.amountB;
1407                 order.amountB = amount;
1408             } else {
1409                 amount = order.amountS.tolerantSub(
1410                     cancelledOrFilled[state.orderHash]
1411                 );
1412                 order.amountB = amount.mul(order.amountB) / order.amountS;
1413                 order.lrcFee = amount.mul(order.lrcFee) / order.amountS;
1414                 order.amountS = amount;
1415             }
1416             require(order.amountS > 0); // "amountS is zero");
1417             require(order.amountB > 0); // "amountB is zero");
1418             
1419             uint availableAmountS = getSpendable(delegate, order.tokenS, order.owner);
1420             require(availableAmountS > 0); // "order spendable amountS is zero");
1421             state.fillAmountS = (
1422                 order.amountS < availableAmountS ?
1423                 order.amountS : availableAmountS
1424             );
1425         }
1426     }
1427     /// @return Amount of ERC20 token that can be spent by this contract.
1428     function getSpendable(
1429         TokenTransferDelegate delegate,
1430         address tokenAddress,
1431         address tokenOwner
1432         )
1433         private
1434         view
1435         returns (uint)
1436     {
1437         var token = ERC20(tokenAddress);
1438         uint allowance = token.allowance(
1439             tokenOwner,
1440             address(delegate)
1441         );
1442         uint balance = token.balanceOf(tokenOwner);
1443         return (allowance < balance ? allowance : balance);
1444     }
1445     /// @dev verify input data's basic integrity.
1446     function verifyInputDataIntegrity(
1447         uint          ringSize,
1448         address[2][]  addressList,
1449         uint[7][]     uintArgsList,
1450         uint8[2][]    uint8ArgsList,
1451         bool[]        buyNoMoreThanAmountBList,
1452         uint8[]       vList,
1453         bytes32[]     rList,
1454         bytes32[]     sList
1455         )
1456         private
1457         pure
1458     {
1459         require(ringSize == addressList.length); // "ring data is inconsistent - addressList");
1460         require(ringSize == uintArgsList.length); // "ring data is inconsistent - uintArgsList");
1461         require(ringSize == uint8ArgsList.length); // "ring data is inconsistent - uint8ArgsList");
1462         require(ringSize == buyNoMoreThanAmountBList.length); // "ring data is inconsistent - buyNoMoreThanAmountBList");
1463         require(ringSize + 1 == vList.length); // "ring data is inconsistent - vList");
1464         require(ringSize + 1 == rList.length); // "ring data is inconsistent - rList");
1465         require(ringSize + 1 == sList.length); // "ring data is inconsistent - sList");
1466         // Validate ring-mining related arguments.
1467         for (uint i = 0; i < ringSize; i++) {
1468             require(uintArgsList[i][6] > 0); // "order rateAmountS is zero");
1469             require(uint8ArgsList[i][1] <= FEE_SELECT_MAX_VALUE); // "invalid order fee selection");
1470         }
1471     }
1472     /// @dev        assmble order parameters into Order struct.
1473     /// @return     A list of orders.
1474     function assembleOrders(
1475         address[2][]    addressList,
1476         uint[7][]       uintArgsList,
1477         uint8[2][]      uint8ArgsList,
1478         bool[]          buyNoMoreThanAmountBList,
1479         uint8[]         vList,
1480         bytes32[]       rList,
1481         bytes32[]       sList
1482         )
1483         private
1484         view
1485         returns (OrderState[] orders)
1486     {
1487         uint ringSize = addressList.length;
1488         orders = new OrderState[](ringSize);
1489         for (uint i = 0; i < ringSize; i++) {
1490             var uintArgs = uintArgsList[i];
1491         
1492             var order = Order(
1493                 addressList[i][0],
1494                 addressList[i][1],
1495                 addressList[(i + 1) % ringSize][1],
1496                 uintArgs[0],
1497                 uintArgs[1],
1498                 uintArgs[5],
1499                 buyNoMoreThanAmountBList[i],
1500                 uint8ArgsList[i][0]
1501             );
1502             bytes32 orderHash = calculateOrderHash(
1503                 order,
1504                 uintArgs[2], // timestamp
1505                 uintArgs[3], // ttl
1506                 uintArgs[4]  // salt
1507             );
1508             verifySignature(
1509                 order.owner,
1510                 orderHash,
1511                 vList[i],
1512                 rList[i],
1513                 sList[i]
1514             );
1515             validateOrder(
1516                 order,
1517                 uintArgs[2], // timestamp
1518                 uintArgs[3], // ttl
1519                 uintArgs[4]  // salt
1520             );
1521             orders[i] = OrderState(
1522                 order,
1523                 orderHash,
1524                 uint8ArgsList[i][1],  // feeSelection
1525                 Rate(uintArgs[6], order.amountB),
1526                 0,   // fillAmountS
1527                 0,   // lrcReward
1528                 0,   // lrcFee
1529                 0,   // splitS
1530                 0    // splitB
1531             );
1532         }
1533     }
1534     /// @dev validate order's parameters are OK.
1535     function validateOrder(
1536         Order        order,
1537         uint         timestamp,
1538         uint         ttl,
1539         uint         salt
1540         )
1541         private
1542         view
1543     {
1544         require(order.owner != 0x0); // "invalid order owner");
1545         require(order.tokenS != 0x0); // "invalid order tokenS");
1546         require(order.tokenB != 0x0); // "invalid order tokenB");
1547         require(order.amountS != 0); // "invalid order amountS");
1548         require(order.amountB != 0); // "invalid order amountB");
1549         require(timestamp <= block.timestamp); // "order is too early to match");
1550         require(timestamp > cutoffs[order.owner]); // "order is cut off");
1551         require(ttl != 0); // "order ttl is 0");
1552         require(timestamp + ttl > block.timestamp); // "order is expired");
1553         require(salt != 0); // "invalid order salt");
1554         require(order.marginSplitPercentage <= MARGIN_SPLIT_PERCENTAGE_BASE); // "invalid order marginSplitPercentage");
1555     }
1556     /// @dev Get the Keccak-256 hash of order with specified parameters.
1557     function calculateOrderHash(
1558         Order        order,
1559         uint         timestamp,
1560         uint         ttl,
1561         uint         salt
1562         )
1563         private
1564         view
1565         returns (bytes32)
1566     {
1567         return keccak256(
1568             address(this),
1569             order.owner,
1570             order.tokenS,
1571             order.tokenB,
1572             order.amountS,
1573             order.amountB,
1574             timestamp,
1575             ttl,
1576             salt,
1577             order.lrcFee,
1578             order.buyNoMoreThanAmountB,
1579             order.marginSplitPercentage
1580         );
1581     }
1582     /// @dev Verify signer's signature.
1583     function verifySignature(
1584         address signer,
1585         bytes32 hash,
1586         uint8   v,
1587         bytes32 r,
1588         bytes32 s
1589         )
1590         private
1591         pure
1592     {
1593         require(
1594             signer == ecrecover(
1595                 keccak256("\x19Ethereum Signed Message:\n32", hash),
1596                 v,
1597                 r,
1598                 s
1599             )
1600         ); // "invalid signature");
1601     }
1602 }