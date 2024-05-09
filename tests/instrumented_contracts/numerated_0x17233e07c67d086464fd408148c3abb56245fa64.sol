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
311         address miner,
312         address minerFeeRecipient,
313         uint8 walletSplitPercentage,
314         bytes32[] batch
315         )
316         external;
317     function isAddressAuthorized(
318         address addr
319         )
320         public
321         view
322         returns (bool);
323     function addCancelled(bytes32 orderHash, uint cancelAmount)
324         external;
325     function addCancelledOrFilled(bytes32 orderHash, uint cancelOrFillAmount)
326         public;
327     function batchAddCancelledOrFilled(bytes32[] batch)
328         public;
329     function setCutoffs(uint t)
330         external;
331     function setTradingPairCutoffs(bytes20 tokenPair, uint t)
332         external;
333     function checkCutoffsBatch(address[] owners, bytes20[] tradingPairs, uint[] validSince)
334         external
335         view;
336     function suspend() external;
337     function resume() external;
338     function kill() external;
339 }
340 /// @title An Implementation of TokenTransferDelegate.
341 /// @author Daniel Wang - <daniel@loopring.org>.
342 /// @author Kongliang Zhong - <kongliang@loopring.org>.
343 contract TokenTransferDelegateImpl is TokenTransferDelegate, Claimable {
344     using MathUint for uint;
345     bool public suspended = false;
346     struct AddressInfo {
347         address previous;
348         uint32  index;
349         bool    authorized;
350     }
351     mapping(address => AddressInfo) public addressInfos;
352     address private latestAddress;
353     modifier onlyAuthorized()
354     {
355         require(addressInfos[msg.sender].authorized);
356         _;
357     }
358     modifier notSuspended()
359     {
360         require(!suspended);
361         _;
362     }
363     modifier isSuspended()
364     {
365         require(suspended);
366         _;
367     }
368     /// @dev Disable default function.
369     function ()
370         payable
371         public
372     {
373         revert();
374     }
375     function authorizeAddress(
376         address addr
377         )
378         onlyOwner
379         external
380     {
381         AddressInfo storage addrInfo = addressInfos[addr];
382         if (addrInfo.index != 0) { // existing
383             if (addrInfo.authorized == false) { // re-authorize
384                 addrInfo.authorized = true;
385                 emit AddressAuthorized(addr, addrInfo.index);
386             }
387         } else {
388             address prev = latestAddress;
389             if (prev == 0x0) {
390                 addrInfo.index = 1;
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
428             if (addrInfo.authorized) {
429                 addresses[count++] = addr;
430             }
431             addr = addrInfo.previous;
432         }
433     }
434     function transferToken(
435         address token,
436         address from,
437         address to,
438         uint    value
439         )
440         onlyAuthorized
441         notSuspended
442         external
443     {
444         if (value > 0 && from != to && to != 0x0) {
445             require(
446                 ERC20(token).transferFrom(from, to, value)
447             );
448         }
449     }
450     function batchTransferToken(
451         address lrcTokenAddress,
452         address miner,
453         address feeRecipient,
454         uint8 walletSplitPercentage,
455         bytes32[] batch
456         )
457         onlyAuthorized
458         notSuspended
459         external
460     {
461         uint len = batch.length;
462         require(len % 7 == 0);
463         require(walletSplitPercentage > 0 && walletSplitPercentage < 100);
464         ERC20 lrc = ERC20(lrcTokenAddress);
465         address prevOwner = address(batch[len - 7]);
466         for (uint i = 0; i < len; i += 7) {
467             address owner = address(batch[i]);
468             // Pay token to previous order, or to miner as previous order's
469             // margin split or/and this order's margin split.
470             ERC20 token = ERC20(address(batch[i + 1]));
471             // Here batch[i + 2] has been checked not to be 0.
472             if (batch[i + 2] != 0x0 && owner != prevOwner) {
473                 require(
474                     token.transferFrom(
475                         owner,
476                         prevOwner,
477                         uint(batch[i + 2])
478                     )
479                 );
480             }
481             // Miner pays LRx fee to order owner
482             uint lrcReward = uint(batch[i + 4]);
483             if (lrcReward != 0 && miner != owner) {
484                 require(
485                     lrc.transferFrom(
486                         miner,
487                         owner,
488                         lrcReward
489                     )
490                 );
491             }
492             // Split margin-split income between miner and wallet
493             splitPayFee(
494                 token,
495                 uint(batch[i + 3]),
496                 owner,
497                 feeRecipient,
498                 address(batch[i + 6]),
499                 walletSplitPercentage
500             );
501             // Split LRx fee income between miner and wallet
502             splitPayFee(
503                 lrc,
504                 uint(batch[i + 5]),
505                 owner,
506                 feeRecipient,
507                 address(batch[i + 6]),
508                 walletSplitPercentage
509             );
510             prevOwner = owner;
511         }
512     }
513     function isAddressAuthorized(
514         address addr
515         )
516         public
517         view
518         returns (bool)
519     {
520         return addressInfos[addr].authorized;
521     }
522     function splitPayFee(
523         ERC20   token,
524         uint    fee,
525         address owner,
526         address feeRecipient,
527         address walletFeeRecipient,
528         uint    walletSplitPercentage
529         )
530         internal
531     {
532         if (fee == 0) {
533             return;
534         }
535         uint walletFee = (walletFeeRecipient == 0x0) ? 0 : fee.mul(walletSplitPercentage) / 100;
536         uint minerFee = fee.sub(walletFee);
537         if (walletFee > 0 && walletFeeRecipient != owner) {
538             require(
539                 token.transferFrom(
540                     owner,
541                     walletFeeRecipient,
542                     walletFee
543                 )
544             );
545         }
546         if (minerFee > 0 && feeRecipient != 0x0 && feeRecipient != owner) {
547             require(
548                 token.transferFrom(
549                     owner,
550                     feeRecipient,
551                     minerFee
552                 )
553             );
554         }
555     }
556     function addCancelled(bytes32 orderHash, uint cancelAmount)
557         onlyAuthorized
558         notSuspended
559         external
560     {
561         cancelled[orderHash] = cancelled[orderHash].add(cancelAmount);
562     }
563     function addCancelledOrFilled(bytes32 orderHash, uint cancelOrFillAmount)
564         onlyAuthorized
565         notSuspended
566         public
567     {
568         cancelledOrFilled[orderHash] = cancelledOrFilled[orderHash].add(cancelOrFillAmount);
569     }
570     function batchAddCancelledOrFilled(bytes32[] batch)
571         onlyAuthorized
572         notSuspended
573         public
574     {
575         require(batch.length % 2 == 0);
576         for (uint i = 0; i < batch.length / 2; i++) {
577             cancelledOrFilled[batch[i * 2]] = cancelledOrFilled[batch[i * 2]]
578                 .add(uint(batch[i * 2 + 1]));
579         }
580     }
581     function setCutoffs(uint t)
582         onlyAuthorized
583         notSuspended
584         external
585     {
586         cutoffs[tx.origin] = t;
587     }
588     function setTradingPairCutoffs(bytes20 tokenPair, uint t)
589         onlyAuthorized
590         notSuspended
591         external
592     {
593         tradingPairCutoffs[tx.origin][tokenPair] = t;
594     }
595     function checkCutoffsBatch(address[] owners, bytes20[] tradingPairs, uint[] validSince)
596         external
597         view
598     {
599         uint len = owners.length;
600         require(len == tradingPairs.length);
601         require(len == validSince.length);
602         for(uint i = 0; i < len; i++) {
603             require(validSince[i] > tradingPairCutoffs[owners[i]][tradingPairs[i]]);  // order trading pair is cut off
604             require(validSince[i] > cutoffs[owners[i]]);                              // order is cut off
605         }
606     }
607     function suspend()
608         onlyOwner
609         notSuspended
610         external
611     {
612         suspended = true;
613     }
614     function resume()
615         onlyOwner
616         isSuspended
617         external
618     {
619         suspended = false;
620     }
621     /// owner must suspend delegate first before invoke kill method.
622     function kill()
623         onlyOwner
624         isSuspended
625         external
626     {
627         emit OwnershipTransferred(owner, 0x0);
628         owner = 0x0;
629     }
630 }