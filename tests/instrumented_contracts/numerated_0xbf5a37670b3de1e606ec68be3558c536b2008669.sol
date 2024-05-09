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
17 pragma solidity 0.5.0;
18 
19 
20 /// @title Errors
21 contract Errors {
22     string constant ZERO_VALUE                 = "ZERO_VALUE";
23     string constant ZERO_ADDRESS               = "ZERO_ADDRESS";
24     string constant INVALID_VALUE              = "INVALID_VALUE";
25     string constant INVALID_ADDRESS            = "INVALID_ADDRESS";
26     string constant INVALID_SIZE               = "INVALID_SIZE";
27     string constant INVALID_SIG                = "INVALID_SIG";
28     string constant INVALID_STATE              = "INVALID_STATE";
29     string constant NOT_FOUND                  = "NOT_FOUND";
30     string constant ALREADY_EXIST              = "ALREADY_EXIST";
31     string constant REENTRY                    = "REENTRY";
32     string constant UNAUTHORIZED               = "UNAUTHORIZED";
33     string constant UNIMPLEMENTED              = "UNIMPLEMENTED";
34     string constant UNSUPPORTED                = "UNSUPPORTED";
35     string constant TRANSFER_FAILURE           = "TRANSFER_FAILURE";
36     string constant WITHDRAWAL_FAILURE         = "WITHDRAWAL_FAILURE";
37     string constant BURN_FAILURE               = "BURN_FAILURE";
38     string constant BURN_RATE_FROZEN           = "BURN_RATE_FROZEN";
39     string constant BURN_RATE_MINIMIZED        = "BURN_RATE_MINIMIZED";
40     string constant UNAUTHORIZED_ONCHAIN_ORDER = "UNAUTHORIZED_ONCHAIN_ORDER";
41     string constant INVALID_CANDIDATE          = "INVALID_CANDIDATE";
42     string constant ALREADY_VOTED              = "ALREADY_VOTED";
43     string constant NOT_OWNER                  = "NOT_OWNER";
44 }
45 /*
46 
47   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
48 
49   Licensed under the Apache License, Version 2.0 (the "License");
50   you may not use this file except in compliance with the License.
51   You may obtain a copy of the License at
52 
53   http://www.apache.org/licenses/LICENSE-2.0
54 
55   Unless required by applicable law or agreed to in writing, software
56   distributed under the License is distributed on an "AS IS" BASIS,
57   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
58   See the License for the specific language governing permissions and
59   limitations under the License.
60 */
61 
62 
63 /*
64 
65   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
66 
67   Licensed under the Apache License, Version 2.0 (the "License");
68   you may not use this file except in compliance with the License.
69   You may obtain a copy of the License at
70 
71   http://www.apache.org/licenses/LICENSE-2.0
72 
73   Unless required by applicable law or agreed to in writing, software
74   distributed under the License is distributed on an "AS IS" BASIS,
75   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
76   See the License for the specific language governing permissions and
77   limitations under the License.
78 */
79 
80 
81 
82 /// @title Ownable
83 /// @dev The Ownable contract has an owner address, and provides basic
84 ///      authorization control functions, this simplifies the implementation of
85 ///      "user permissions".
86 contract Ownable {
87     address public owner;
88 
89     event OwnershipTransferred(
90         address indexed previousOwner,
91         address indexed newOwner
92     );
93 
94     /// @dev The Ownable constructor sets the original `owner` of the contract
95     ///      to the sender.
96     constructor()
97         public
98     {
99         owner = msg.sender;
100     }
101 
102     /// @dev Throws if called by any account other than the owner.
103     modifier onlyOwner()
104     {
105         require(msg.sender == owner, "NOT_OWNER");
106         _;
107     }
108 
109     /// @dev Allows the current owner to transfer control of the contract to a
110     ///      newOwner.
111     /// @param newOwner The address to transfer ownership to.
112     function transferOwnership(
113         address newOwner
114         )
115         public
116         onlyOwner
117     {
118         require(newOwner != address(0x0), "ZERO_ADDRESS");
119         emit OwnershipTransferred(owner, newOwner);
120         owner = newOwner;
121     }
122 }
123 
124 
125 
126 /// @title Claimable
127 /// @dev Extension for the Ownable contract, where the ownership needs
128 ///      to be claimed. This allows the new owner to accept the transfer.
129 contract Claimable is Ownable {
130     address public pendingOwner;
131 
132     /// @dev Modifier throws if called by any account other than the pendingOwner.
133     modifier onlyPendingOwner() {
134         require(msg.sender == pendingOwner, "UNAUTHORIZED");
135         _;
136     }
137 
138     /// @dev Allows the current owner to set the pendingOwner address.
139     /// @param newOwner The address to transfer ownership to.
140     function transferOwnership(
141         address newOwner
142         )
143         public
144         onlyOwner
145     {
146         require(newOwner != address(0x0) && newOwner != owner, "INVALID_ADDRESS");
147         pendingOwner = newOwner;
148     }
149 
150     /// @dev Allows the pendingOwner address to finalize the transfer.
151     function claimOwnership()
152         public
153         onlyPendingOwner
154     {
155         emit OwnershipTransferred(owner, pendingOwner);
156         owner = pendingOwner;
157         pendingOwner = address(0x0);
158     }
159 }
160 /*
161 
162   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
163 
164   Licensed under the Apache License, Version 2.0 (the "License");
165   you may not use this file except in compliance with the License.
166   You may obtain a copy of the License at
167 
168   http://www.apache.org/licenses/LICENSE-2.0
169 
170   Unless required by applicable law or agreed to in writing, software
171   distributed under the License is distributed on an "AS IS" BASIS,
172   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
173   See the License for the specific language governing permissions and
174   limitations under the License.
175 */
176 
177 
178 /*
179 
180   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
181 
182   Licensed under the Apache License, Version 2.0 (the "License");
183   you may not use this file except in compliance with the License.
184   You may obtain a copy of the License at
185 
186   http://www.apache.org/licenses/LICENSE-2.0
187 
188   Unless required by applicable law or agreed to in writing, software
189   distributed under the License is distributed on an "AS IS" BASIS,
190   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
191   See the License for the specific language governing permissions and
192   limitations under the License.
193 */
194 
195 
196 
197 /// @title ITradeHistory
198 /// @dev Stores the trade history and cancelled data of orders
199 /// @author Brecht Devos - <brecht@loopring.org>.
200 contract ITradeHistory {
201 
202     // The following map is used to keep trace of order fill and cancellation
203     // history.
204     mapping (bytes32 => uint) public filled;
205 
206     // This map is used to keep trace of order's cancellation history.
207     mapping (address => mapping (bytes32 => bool)) public cancelled;
208 
209     // A map from a broker to its cutoff timestamp.
210     mapping (address => uint) public cutoffs;
211 
212     // A map from a broker to its trading-pair cutoff timestamp.
213     mapping (address => mapping (bytes20 => uint)) public tradingPairCutoffs;
214 
215     // A map from a broker to an order owner to its cutoff timestamp.
216     mapping (address => mapping (address => uint)) public cutoffsOwner;
217 
218     // A map from a broker to an order owner to its trading-pair cutoff timestamp.
219     mapping (address => mapping (address => mapping (bytes20 => uint))) public tradingPairCutoffsOwner;
220 
221 
222     function batchUpdateFilled(
223         bytes32[] calldata filledInfo
224         )
225         external;
226 
227     function setCancelled(
228         address broker,
229         bytes32 orderHash
230         )
231         external;
232 
233     function setCutoffs(
234         address broker,
235         uint cutoff
236         )
237         external;
238 
239     function setTradingPairCutoffs(
240         address broker,
241         bytes20 tokenPair,
242         uint cutoff
243         )
244         external;
245 
246     function setCutoffsOfOwner(
247         address broker,
248         address owner,
249         uint cutoff
250         )
251         external;
252 
253     function setTradingPairCutoffsOfOwner(
254         address broker,
255         address owner,
256         bytes20 tokenPair,
257         uint cutoff
258         )
259         external;
260 
261     function batchGetFilledAndCheckCancelled(
262         bytes32[] calldata orderInfo
263         )
264         external
265         view
266         returns (uint[] memory fills);
267 
268 
269     /// @dev Add a Loopring protocol address.
270     /// @param addr A loopring protocol address.
271     function authorizeAddress(
272         address addr
273         )
274         external;
275 
276     /// @dev Remove a Loopring protocol address.
277     /// @param addr A loopring protocol address.
278     function deauthorizeAddress(
279         address addr
280         )
281         external;
282 
283     function isAddressAuthorized(
284         address addr
285         )
286         public
287         view
288         returns (bool);
289 
290 
291     function suspend()
292         external;
293 
294     function resume()
295         external;
296 
297     function kill()
298         external;
299 }
300 
301 
302 /*
303 
304   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
305 
306   Licensed under the Apache License, Version 2.0 (the "License");
307   you may not use this file except in compliance with the License.
308   You may obtain a copy of the License at
309 
310   http://www.apache.org/licenses/LICENSE-2.0
311 
312   Unless required by applicable law or agreed to in writing, software
313   distributed under the License is distributed on an "AS IS" BASIS,
314   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
315   See the License for the specific language governing permissions and
316   limitations under the License.
317 */
318 
319 
320 
321 
322 
323 
324 
325 /// @title Authorizable
326 /// @dev The Authorizable contract allows a contract to be used by other contracts
327 ///      by authorizing it by the contract owner.
328 contract Authorizable is Claimable, Errors  {
329 
330     event AddressAuthorized(
331         address indexed addr
332     );
333 
334     event AddressDeauthorized(
335         address indexed addr
336     );
337 
338     // The list of all authorized addresses
339     address[] authorizedAddresses;
340 
341     mapping (address => uint) private positionMap;
342 
343     struct AuthorizedAddress {
344         uint    pos;
345         address addr;
346     }
347 
348     modifier onlyAuthorized()
349     {
350         require(positionMap[msg.sender] > 0, UNAUTHORIZED);
351         _;
352     }
353 
354     function authorizeAddress(
355         address addr
356         )
357         external
358         onlyOwner
359     {
360         require(address(0x0) != addr, ZERO_ADDRESS);
361         require(0 == positionMap[addr], ALREADY_EXIST);
362         require(isContract(addr), INVALID_ADDRESS);
363 
364         authorizedAddresses.push(addr);
365         positionMap[addr] = authorizedAddresses.length;
366         emit AddressAuthorized(addr);
367     }
368 
369     function deauthorizeAddress(
370         address addr
371         )
372         external
373         onlyOwner
374     {
375         require(address(0x0) != addr, ZERO_ADDRESS);
376 
377         uint pos = positionMap[addr];
378         require(pos != 0, NOT_FOUND);
379 
380         uint size = authorizedAddresses.length;
381         if (pos != size) {
382             address lastOne = authorizedAddresses[size - 1];
383             authorizedAddresses[pos - 1] = lastOne;
384             positionMap[lastOne] = pos;
385         }
386 
387         authorizedAddresses.length -= 1;
388         delete positionMap[addr];
389 
390         emit AddressDeauthorized(addr);
391     }
392 
393     function isAddressAuthorized(
394         address addr
395         )
396         public
397         view
398         returns (bool)
399     {
400         return positionMap[addr] > 0;
401     }
402 
403     function isContract(
404         address addr
405         )
406         internal
407         view
408         returns (bool)
409     {
410         uint size;
411         assembly { size := extcodesize(addr) }
412         return size > 0;
413     }
414 
415 }
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
433 
434 
435 
436 /// @title Utility Functions for uint
437 /// @author Daniel Wang - <daniel@loopring.org>
438 library MathUint {
439 
440     function mul(
441         uint a,
442         uint b
443         )
444         internal
445         pure
446         returns (uint c)
447     {
448         c = a * b;
449         require(a == 0 || c / a == b, "INVALID_VALUE");
450     }
451 
452     function sub(
453         uint a,
454         uint b
455         )
456         internal
457         pure
458         returns (uint)
459     {
460         require(b <= a, "INVALID_VALUE");
461         return a - b;
462     }
463 
464     function add(
465         uint a,
466         uint b
467         )
468         internal
469         pure
470         returns (uint c)
471     {
472         c = a + b;
473         require(c >= a, "INVALID_VALUE");
474     }
475 
476     function hasRoundingError(
477         uint value,
478         uint numerator,
479         uint denominator
480         )
481         internal
482         pure
483         returns (bool)
484     {
485         uint multiplied = mul(value, numerator);
486         uint remainder = multiplied % denominator;
487         // Return true if the rounding error is larger than 1%
488         return mul(remainder, 100) > multiplied;
489     }
490 }
491 
492 /*
493 
494   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
495 
496   Licensed under the Apache License, Version 2.0 (the "License");
497   you may not use this file except in compliance with the License.
498   You may obtain a copy of the License at
499 
500   http://www.apache.org/licenses/LICENSE-2.0
501 
502   Unless required by applicable law or agreed to in writing, software
503   distributed under the License is distributed on an "AS IS" BASIS,
504   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
505   See the License for the specific language governing permissions and
506   limitations under the License.
507 */
508 
509 
510 
511 
512 
513 
514 
515 /// @title Killable
516 /// @dev The Killable contract allows the contract owner to suspend, resume or kill the contract
517 contract Killable is Claimable, Errors  {
518 
519     bool public suspended = false;
520 
521     modifier notSuspended()
522     {
523         require(!suspended, INVALID_STATE);
524         _;
525     }
526 
527     modifier isSuspended()
528     {
529         require(suspended, INVALID_STATE);
530         _;
531     }
532 
533     function suspend()
534         external
535         onlyOwner
536         notSuspended
537     {
538         suspended = true;
539     }
540 
541     function resume()
542         external
543         onlyOwner
544         isSuspended
545     {
546         suspended = false;
547     }
548 
549     /// owner must suspend the delegate first before invoking the kill method.
550     function kill()
551         external
552         onlyOwner
553         isSuspended
554     {
555         owner = address(0x0);
556         emit OwnershipTransferred(owner, address(0x0));
557     }
558 }
559 
560 /*
561 
562   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
563 
564   Licensed under the Apache License, Version 2.0 (the "License");
565   you may not use this file except in compliance with the License.
566   You may obtain a copy of the License at
567 
568   http://www.apache.org/licenses/LICENSE-2.0
569 
570   Unless required by applicable law or agreed to in writing, software
571   distributed under the License is distributed on an "AS IS" BASIS,
572   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
573   See the License for the specific language governing permissions and
574   limitations under the License.
575 */
576 
577 
578 
579 
580 
581 /// @title NoDefaultFunc
582 /// @dev Disable default functions.
583 contract NoDefaultFunc is Errors {
584     function ()
585         external
586         payable
587     {
588         revert(UNSUPPORTED);
589     }
590 }
591 
592 
593 
594 /// @title An Implementation of ITradeHistory.
595 /// @author Brecht Devos - <brecht@loopring.org>.
596 contract TradeHistory is ITradeHistory, Authorizable, Killable, NoDefaultFunc {
597     using MathUint for uint;
598 
599     function batchUpdateFilled(
600         bytes32[] calldata filledInfo
601         )
602         external
603         onlyAuthorized
604         notSuspended
605     {
606         uint length = filledInfo.length;
607         require(length % 2 == 0, INVALID_SIZE);
608 
609         uint start = 68;
610         uint end = start + length * 32;
611         for (uint p = start; p < end; p += 64) {
612             bytes32 hash;
613             uint filledAmount;
614             assembly {
615                 hash := calldataload(add(p,  0))
616                 filledAmount := calldataload(add(p, 32))
617             }
618             filled[hash] = filledAmount;
619         }
620     }
621 
622     function setCancelled(
623         address broker,
624         bytes32 orderHash
625         )
626         external
627         onlyAuthorized
628         notSuspended
629     {
630         cancelled[broker][orderHash] = true;
631     }
632 
633     function setCutoffs(
634         address broker,
635         uint    cutoff
636         )
637         external
638         onlyAuthorized
639         notSuspended
640     {
641         require(cutoffs[broker] < cutoff, INVALID_VALUE);
642         cutoffs[broker] = cutoff;
643     }
644 
645     function setTradingPairCutoffs(
646         address broker,
647         bytes20 tokenPair,
648         uint    cutoff
649         )
650         external
651         onlyAuthorized
652         notSuspended
653     {
654         require(tradingPairCutoffs[broker][tokenPair] < cutoff, INVALID_VALUE);
655         tradingPairCutoffs[broker][tokenPair] = cutoff;
656     }
657 
658     function setCutoffsOfOwner(
659         address broker,
660         address owner,
661         uint    cutoff
662         )
663         external
664         onlyAuthorized
665         notSuspended
666     {
667         require(cutoffsOwner[broker][owner] < cutoff, INVALID_VALUE);
668         cutoffsOwner[broker][owner] = cutoff;
669     }
670 
671     function setTradingPairCutoffsOfOwner(
672         address broker,
673         address owner,
674         bytes20 tokenPair,
675         uint    cutoff
676         )
677         external
678         onlyAuthorized
679         notSuspended
680     {
681         require(tradingPairCutoffsOwner[broker][owner][tokenPair] < cutoff, INVALID_VALUE);
682         tradingPairCutoffsOwner[broker][owner][tokenPair] = cutoff;
683     }
684 
685     function batchGetFilledAndCheckCancelled(
686         bytes32[] calldata batch
687         )
688         external
689         view
690         returns (uint[] memory fills)
691     {
692         uint length = batch.length;
693         require(length % 5 == 0, INVALID_SIZE);
694 
695         uint start = 68;
696         uint end = start + length * 32;
697         uint i = 0;
698         fills = new uint[](length / 5);
699         for (uint p = start; p < end; p += 160) {
700             address broker;
701             address owner;
702             bytes32 hash;
703             uint validSince;
704             bytes20 tradingPair;
705             assembly {
706                 broker := calldataload(add(p,  0))
707                 owner := calldataload(add(p, 32))
708                 hash := calldataload(add(p, 64))
709                 validSince := calldataload(add(p, 96))
710                 tradingPair := calldataload(add(p, 128))
711             }
712             bool valid = !cancelled[broker][hash];
713             valid = valid && validSince > tradingPairCutoffs[broker][tradingPair];
714             valid = valid && validSince > cutoffs[broker];
715             valid = valid && validSince > tradingPairCutoffsOwner[broker][owner][tradingPair];
716             valid = valid && validSince > cutoffsOwner[broker][owner];
717 
718             fills[i++] = valid ? filled[hash] : ~uint(0);
719         }
720     }
721 }