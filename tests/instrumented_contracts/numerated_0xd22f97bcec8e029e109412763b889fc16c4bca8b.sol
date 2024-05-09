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
104 /*
105   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
106   Licensed under the Apache License, Version 2.0 (the "License");
107   you may not use this file except in compliance with the License.
108   You may obtain a copy of the License at
109   http://www.apache.org/licenses/LICENSE-2.0
110   Unless required by applicable law or agreed to in writing, software
111   distributed under the License is distributed on an "AS IS" BASIS,
112   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
113   See the License for the specific language governing permissions and
114   limitations under the License.
115 */
116 /*
117   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
118   Licensed under the Apache License, Version 2.0 (the "License");
119   you may not use this file except in compliance with the License.
120   You may obtain a copy of the License at
121   http://www.apache.org/licenses/LICENSE-2.0
122   Unless required by applicable law or agreed to in writing, software
123   distributed under the License is distributed on an "AS IS" BASIS,
124   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
125   See the License for the specific language governing permissions and
126   limitations under the License.
127 */
128 /// @title Ownable
129 /// @dev The Ownable contract has an owner address, and provides basic
130 ///      authorization control functions, this simplifies the implementation of
131 ///      "user permissions".
132 contract Ownable {
133     address public owner;
134     event OwnershipTransferred(
135         address indexed previousOwner,
136         address indexed newOwner
137     );
138     /// @dev The Ownable constructor sets the original `owner` of the contract
139     ///      to the sender.
140     function Ownable()
141         public
142     {
143         owner = msg.sender;
144     }
145     /// @dev Throws if called by any account other than the owner.
146     modifier onlyOwner()
147     {
148         require(msg.sender == owner);
149         _;
150     }
151     /// @dev Allows the current owner to transfer control of the contract to a
152     ///      newOwner.
153     /// @param newOwner The address to transfer ownership to.
154     function transferOwnership(
155         address newOwner
156         )
157         onlyOwner
158         public
159     {
160         require(newOwner != 0x0);
161         emit OwnershipTransferred(owner, newOwner);
162         owner = newOwner;
163     }
164 }
165 /// @title Claimable
166 /// @dev Extension for the Ownable contract, where the ownership needs
167 ///      to be claimed. This allows the new owner to accept the transfer.
168 contract Claimable is Ownable {
169     address public pendingOwner;
170     /// @dev Modifier throws if called by any account other than the pendingOwner.
171     modifier onlyPendingOwner() {
172         require(msg.sender == pendingOwner);
173         _;
174     }
175     /// @dev Allows the current owner to set the pendingOwner address.
176     /// @param newOwner The address to transfer ownership to.
177     function transferOwnership(
178         address newOwner
179         )
180         onlyOwner
181         public
182     {
183         require(newOwner != 0x0 && newOwner != owner);
184         pendingOwner = newOwner;
185     }
186     /// @dev Allows the pendingOwner address to finalize the transfer.
187     function claimOwnership()
188         onlyPendingOwner
189         public
190     {
191         emit OwnershipTransferred(owner, pendingOwner);
192         owner = pendingOwner;
193         pendingOwner = 0x0;
194     }
195 }
196 /*
197   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
198   Licensed under the Apache License, Version 2.0 (the "License");
199   you may not use this file except in compliance with the License.
200   You may obtain a copy of the License at
201   http://www.apache.org/licenses/LICENSE-2.0
202   Unless required by applicable law or agreed to in writing, software
203   distributed under the License is distributed on an "AS IS" BASIS,
204   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
205   See the License for the specific language governing permissions and
206   limitations under the License.
207 */
208 /// @title ERC20 Token Interface
209 /// @dev see https://github.com/ethereum/EIPs/issues/20
210 /// @author Daniel Wang - <daniel@loopring.org>
211 contract ERC20 {
212     function balanceOf(
213         address who
214         )
215         view
216         public
217         returns (uint256);
218     function allowance(
219         address owner,
220         address spender
221         )
222         view
223         public
224         returns (uint256);
225     function transfer(
226         address to,
227         uint256 value
228         )
229         public
230         returns (bool);
231     function transferFrom(
232         address from,
233         address to,
234         uint256 value
235         )
236         public
237         returns (bool);
238     function approve(
239         address spender,
240         uint256 value
241         )
242         public
243         returns (bool);
244 }
245 /*
246   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
247   Licensed under the Apache License, Version 2.0 (the "License");
248   you may not use this file except in compliance with the License.
249   You may obtain a copy of the License at
250   http://www.apache.org/licenses/LICENSE-2.0
251   Unless required by applicable law or agreed to in writing, software
252   distributed under the License is distributed on an "AS IS" BASIS,
253   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
254   See the License for the specific language governing permissions and
255   limitations under the License.
256 */
257 /// @title TokenTransferDelegate
258 /// @dev Acts as a middle man to transfer ERC20 tokens on behalf of different
259 /// versions of Loopring protocol to avoid ERC20 re-authorization.
260 /// @author Daniel Wang - <daniel@loopring.org>.
261 contract TokenTransferDelegate {
262     event AddressAuthorized(
263         address indexed addr,
264         uint32          number
265     );
266     event AddressDeauthorized(
267         address indexed addr,
268         uint32          number
269     );
270     // The following map is used to keep trace of order fill and cancellation
271     // history.
272     mapping (bytes32 => uint) public cancelledOrFilled;
273     // This map is used to keep trace of order's cancellation history.
274     mapping (bytes32 => uint) public cancelled;
275     // A map from address to its cutoff timestamp.
276     mapping (address => uint) public cutoffs;
277     // A map from address to its trading-pair cutoff timestamp.
278     mapping (address => mapping (bytes20 => uint)) public tradingPairCutoffs;
279     /// @dev Add a Loopring protocol address.
280     /// @param addr A loopring protocol address.
281     function authorizeAddress(
282         address addr
283         )
284         external;
285     /// @dev Remove a Loopring protocol address.
286     /// @param addr A loopring protocol address.
287     function deauthorizeAddress(
288         address addr
289         )
290         external;
291     function getLatestAuthorizedAddresses(
292         uint max
293         )
294         external
295         view
296         returns (address[] addresses);
297     /// @dev Invoke ERC20 transferFrom method.
298     /// @param token Address of token to transfer.
299     /// @param from Address to transfer token from.
300     /// @param to Address to transfer token to.
301     /// @param value Amount of token to transfer.
302     function transferToken(
303         address token,
304         address from,
305         address to,
306         uint    value
307         )
308         external;
309     function batchTransferToken(
310         address lrcTokenAddress,
311         address minerFeeRecipient,
312         uint8 walletSplitPercentage,
313         bytes32[] batch
314         )
315         external;
316     function isAddressAuthorized(
317         address addr
318         )
319         public
320         view
321         returns (bool);
322     function addCancelled(bytes32 orderHash, uint cancelAmount)
323         external;
324     function addCancelledOrFilled(bytes32 orderHash, uint cancelOrFillAmount)
325         public;
326     function batchAddCancelledOrFilled(bytes32[] batch)
327         public;
328     function setCutoffs(uint t)
329         external;
330     function setTradingPairCutoffs(bytes20 tokenPair, uint t)
331         external;
332     function checkCutoffsBatch(address[] owners, bytes20[] tradingPairs, uint[] validSince)
333         external
334         view;
335     function suspend() external;
336     function resume() external;
337     function kill() external;
338 }
339 /// @title An Implementation of TokenTransferDelegate.
340 /// @author Daniel Wang - <daniel@loopring.org>.
341 /// @author Kongliang Zhong - <kongliang@loopring.org>.
342 contract TokenTransferDelegateImpl is TokenTransferDelegate, Claimable {
343     using MathUint for uint;
344     bool public suspended = false;
345     struct AddressInfo {
346         address previous;
347         uint32  index;
348         bool    authorized;
349     }
350     mapping(address => AddressInfo) public addressInfos;
351     address public latestAddress;
352     modifier onlyAuthorized()
353     {
354         require(addressInfos[msg.sender].authorized);
355         _;
356     }
357     modifier notSuspended()
358     {
359         require(!suspended);
360         _;
361     }
362     modifier isSuspended()
363     {
364         require(suspended);
365         _;
366     }
367     /// @dev Disable default function.
368     function ()
369         payable
370         public
371     {
372         revert();
373     }
374     function authorizeAddress(
375         address addr
376         )
377         onlyOwner
378         external
379     {
380         AddressInfo storage addrInfo = addressInfos[addr];
381         if (addrInfo.index != 0) { // existing
382             if (addrInfo.authorized == false) { // re-authorize
383                 addrInfo.authorized = true;
384                 emit AddressAuthorized(addr, addrInfo.index);
385             }
386         } else {
387             address prev = latestAddress;
388             if (prev == 0x0) {
389                 addrInfo.index = 1;
390                 addrInfo.authorized = true;
391             } else {
392                 addrInfo.previous = prev;
393                 addrInfo.index = addressInfos[prev].index + 1;
394             }
395             addrInfo.authorized = true;
396             latestAddress = addr;
397             emit AddressAuthorized(addr, addrInfo.index);
398         }
399     }
400     function deauthorizeAddress(
401         address addr
402         )
403         onlyOwner
404         external
405     {
406         uint32 index = addressInfos[addr].index;
407         if (index != 0) {
408             addressInfos[addr].authorized = false;
409             emit AddressDeauthorized(addr, index);
410         }
411     }
412     function getLatestAuthorizedAddresses(
413         uint max
414         )
415         external
416         view
417         returns (address[] addresses)
418     {
419         addresses = new address[](max);
420         address addr = latestAddress;
421         AddressInfo memory addrInfo;
422         uint count = 0;
423         while (addr != 0x0 && count < max) {
424             addrInfo = addressInfos[addr];
425             if (addrInfo.index == 0) {
426                 break;
427             }
428             addresses[count++] = addr;
429             addr = addrInfo.previous;
430         }
431     }
432     function transferToken(
433         address token,
434         address from,
435         address to,
436         uint    value
437         )
438         onlyAuthorized
439         notSuspended
440         external
441     {
442         if (value > 0 && from != to && to != 0x0) {
443             require(
444                 ERC20(token).transferFrom(from, to, value)
445             );
446         }
447     }
448     function batchTransferToken(
449         address lrcTokenAddress,
450         address minerFeeRecipient,
451         uint8 walletSplitPercentage,
452         bytes32[] batch
453         )
454         onlyAuthorized
455         notSuspended
456         external
457     {
458         uint len = batch.length;
459         require(len % 7 == 0);
460         require(walletSplitPercentage > 0 && walletSplitPercentage < 100);
461         ERC20 lrc = ERC20(lrcTokenAddress);
462         address prevOwner = address(batch[len - 7]);
463         for (uint i = 0; i < len; i += 7) {
464             address owner = address(batch[i]);
465             // Pay token to previous order, or to miner as previous order's
466             // margin split or/and this order's margin split.
467             ERC20 token = ERC20(address(batch[i + 1]));
468             // Here batch[i + 2] has been checked not to be 0.
469             if (batch[i + 2] != 0x0 && owner != prevOwner) {
470                 require(
471                     token.transferFrom(
472                         owner,
473                         prevOwner,
474                         uint(batch[i + 2])
475                     )
476                 );
477             }
478             // Miner pays LRx fee to order owner
479             uint lrcReward = uint(batch[i + 4]);
480             if (lrcReward != 0 && minerFeeRecipient != owner) {
481                 require(
482                     lrc.transferFrom(
483                         minerFeeRecipient,
484                         owner,
485                         lrcReward
486                     )
487                 );
488             }
489             // Split margin-split income between miner and wallet
490             splitPayFee(
491                 token,
492                 uint(batch[i + 3]),
493                 owner,
494                 minerFeeRecipient,
495                 address(batch[i + 6]),
496                 walletSplitPercentage
497             );
498             // Split LRx fee income between miner and wallet
499             splitPayFee(
500                 lrc,
501                 uint(batch[i + 5]),
502                 owner,
503                 minerFeeRecipient,
504                 address(batch[i + 6]),
505                 walletSplitPercentage
506             );
507             prevOwner = owner;
508         }
509     }
510     function isAddressAuthorized(
511         address addr
512         )
513         public
514         view
515         returns (bool)
516     {
517         return addressInfos[addr].authorized;
518     }
519     function splitPayFee(
520         ERC20   token,
521         uint    fee,
522         address owner,
523         address minerFeeRecipient,
524         address walletFeeRecipient,
525         uint    walletSplitPercentage
526         )
527         internal
528     {
529         if (fee == 0) {
530             return;
531         }
532         uint walletFee = (walletFeeRecipient == 0x0) ? 0 : fee.mul(walletSplitPercentage) / 100;
533         uint minerFee = fee.sub(walletFee);
534         if (walletFee > 0 && walletFeeRecipient != owner) {
535             require(
536                 token.transferFrom(
537                     owner,
538                     walletFeeRecipient,
539                     walletFee
540                 )
541             );
542         }
543         if (minerFee > 0 && minerFeeRecipient != 0x0 && minerFeeRecipient != owner) {
544             require(
545                 token.transferFrom(
546                     owner,
547                     minerFeeRecipient,
548                     minerFee
549                 )
550             );
551         }
552     }
553     function addCancelled(bytes32 orderHash, uint cancelAmount)
554         onlyAuthorized
555         notSuspended
556         external
557     {
558         cancelled[orderHash] = cancelled[orderHash].add(cancelAmount);
559     }
560     function addCancelledOrFilled(bytes32 orderHash, uint cancelOrFillAmount)
561         onlyAuthorized
562         notSuspended
563         public
564     {
565         cancelledOrFilled[orderHash] = cancelledOrFilled[orderHash].add(cancelOrFillAmount);
566     }
567     function batchAddCancelledOrFilled(bytes32[] batch)
568         onlyAuthorized
569         notSuspended
570         public
571     {
572         require(batch.length % 2 == 0);
573         for (uint i = 0; i < batch.length / 2; i++) {
574             cancelledOrFilled[batch[i * 2]] = cancelledOrFilled[batch[i * 2]]
575                 .add(uint(batch[i * 2 + 1]));
576         }
577     }
578     function setCutoffs(uint t)
579         onlyAuthorized
580         notSuspended
581         external
582     {
583         cutoffs[tx.origin] = t;
584     }
585     function setTradingPairCutoffs(bytes20 tokenPair, uint t)
586         onlyAuthorized
587         notSuspended
588         external
589     {
590         tradingPairCutoffs[tx.origin][tokenPair] = t;
591     }
592     function checkCutoffsBatch(address[] owners, bytes20[] tradingPairs, uint[] validSince)
593         external
594         view
595     {
596         uint len = owners.length;
597         require(len == tradingPairs.length);
598         require(len == validSince.length);
599         for(uint i = 0; i < len; i++) {
600             require(validSince[i] > tradingPairCutoffs[owners[i]][tradingPairs[i]]);  // order trading pair is cut off
601             require(validSince[i] > cutoffs[owners[i]]);                              // order is cut off
602         }
603     }
604     function suspend()
605         onlyOwner
606         notSuspended
607         external
608     {
609         suspended = true;
610     }
611     function resume()
612         onlyOwner
613         isSuspended
614         external
615     {
616         suspended = false;
617     }
618     /// owner must suspend delegate first before invoke kill method.
619     function kill()
620         onlyOwner
621         isSuspended
622         external
623     {
624         emit OwnershipTransferred(owner, 0x0);
625         owner = 0x0;
626     }
627 }