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
75             avg += arr[i];
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
87             cvs += mul(s, s);
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
262     event AddressAuthorized(address indexed addr, uint32 number);
263     event AddressDeauthorized(address indexed addr, uint32 number);
264     // The following map is used to keep trace of order fill and cancellation
265     // history.
266     mapping (bytes32 => uint) public cancelledOrFilled;
267     // This map is used to keep trace of order's cancellation history.
268     mapping (bytes32 => uint) public cancelled;
269     // A map from address to its cutoff timestamp.
270     mapping (address => uint) public cutoffs;
271     // A map from address to its trading-pair cutoff timestamp.
272     mapping (address => mapping (bytes20 => uint)) public tradingPairCutoffs;
273     /// @dev Add a Loopring protocol address.
274     /// @param addr A loopring protocol address.
275     function authorizeAddress(
276         address addr
277         )
278         external;
279     /// @dev Remove a Loopring protocol address.
280     /// @param addr A loopring protocol address.
281     function deauthorizeAddress(
282         address addr
283         )
284         external;
285     function getLatestAuthorizedAddresses(
286         uint max
287         )
288         external
289         view
290         returns (address[] addresses);
291     /// @dev Invoke ERC20 transferFrom method.
292     /// @param token Address of token to transfer.
293     /// @param from Address to transfer token from.
294     /// @param to Address to transfer token to.
295     /// @param value Amount of token to transfer.
296     function transferToken(
297         address token,
298         address from,
299         address to,
300         uint    value
301         )
302         external;
303     function batchTransferToken(
304         address lrcTokenAddress,
305         address minerFeeRecipient,
306         uint8 walletSplitPercentage,
307         bytes32[] batch
308         )
309         external;
310     function isAddressAuthorized(
311         address addr
312         )
313         public
314         view
315         returns (bool);
316     function addCancelled(bytes32 orderHash, uint cancelAmount)
317         external;
318     function addCancelledOrFilled(bytes32 orderHash, uint cancelOrFillAmount)
319         external;
320     function setCutoffs(uint t)
321         external;
322     function setTradingPairCutoffs(bytes20 tokenPair, uint t)
323         external;
324     function checkCutoffsBatch(address[] owners, bytes20[] tradingPairs, uint[] validSince)
325         external
326         view;
327 }
328 /// @title An Implementation of TokenTransferDelegate.
329 /// @author Daniel Wang - <daniel@loopring.org>.
330 contract TokenTransferDelegateImpl is TokenTransferDelegate, Claimable {
331     using MathUint for uint;
332     struct AddressInfo {
333         address previous;
334         uint32  index;
335         bool    authorized;
336     }
337     mapping(address => AddressInfo) public addressInfos;
338     address public latestAddress;
339     modifier onlyAuthorized()
340     {
341         require(addressInfos[msg.sender].authorized);
342         _;
343     }
344     /// @dev Disable default function.
345     function ()
346         payable
347         public
348     {
349         revert();
350     }
351     function authorizeAddress(
352         address addr
353         )
354         onlyOwner
355         external
356     {
357         AddressInfo storage addrInfo = addressInfos[addr];
358         if (addrInfo.index != 0) { // existing
359             if (addrInfo.authorized == false) { // re-authorize
360                 addrInfo.authorized = true;
361                 emit AddressAuthorized(addr, addrInfo.index);
362             }
363         } else {
364             address prev = latestAddress;
365             if (prev == 0x0) {
366                 addrInfo.index = 1;
367                 addrInfo.authorized = true;
368             } else {
369                 addrInfo.previous = prev;
370                 addrInfo.index = addressInfos[prev].index + 1;
371             }
372             addrInfo.authorized = true;
373             latestAddress = addr;
374             emit AddressAuthorized(addr, addrInfo.index);
375         }
376     }
377     function deauthorizeAddress(
378         address addr
379         )
380         onlyOwner
381         external
382     {
383         uint32 index = addressInfos[addr].index;
384         if (index != 0) {
385             addressInfos[addr].authorized = false;
386             emit AddressDeauthorized(addr, index);
387         }
388     }
389     function getLatestAuthorizedAddresses(
390         uint max
391         )
392         external
393         view
394         returns (address[] addresses)
395     {
396         addresses = new address[](max);
397         address addr = latestAddress;
398         AddressInfo memory addrInfo;
399         uint count = 0;
400         while (addr != 0x0 && count < max) {
401             addrInfo = addressInfos[addr];
402             if (addrInfo.index == 0) {
403                 break;
404             }
405             addresses[count++] = addr;
406             addr = addrInfo.previous;
407         }
408     }
409     function transferToken(
410         address token,
411         address from,
412         address to,
413         uint    value
414         )
415         onlyAuthorized
416         external
417     {
418         if (value > 0 && from != to && to != 0x0) {
419             require(
420                 ERC20(token).transferFrom(from, to, value)
421             );
422         }
423     }
424     function batchTransferToken(
425         address lrcTokenAddress,
426         address minerFeeRecipient,
427         uint8 walletSplitPercentage,
428         bytes32[] batch
429         )
430         onlyAuthorized
431         external
432     {
433         uint len = batch.length;
434         require(len % 7 == 0);
435         require(walletSplitPercentage > 0 && walletSplitPercentage < 100);
436         ERC20 lrc = ERC20(lrcTokenAddress);
437         for (uint i = 0; i < len; i += 7) {
438             address owner = address(batch[i]);
439             address prevOwner = address(batch[(i + len - 7) % len]);
440             // Pay token to previous order, or to miner as previous order's
441             // margin split or/and this order's margin split.
442             ERC20 token = ERC20(address(batch[i + 1]));
443             // Here batch[i + 2] has been checked not to be 0.
444             if (owner != prevOwner) {
445                 require(
446                     token.transferFrom(
447                         owner,
448                         prevOwner,
449                         uint(batch[i + 2])
450                     )
451                 );
452             }
453             // Miner pays LRx fee to order owner
454             uint lrcReward = uint(batch[i + 4]);
455             if (lrcReward != 0 && minerFeeRecipient != owner) {
456                 require(
457                     lrc.transferFrom(
458                         minerFeeRecipient,
459                         owner,
460                         lrcReward
461                     )
462                 );
463             }
464             // Split margin-split income between miner and wallet
465             splitPayFee(
466                 token,
467                 uint(batch[i + 3]),
468                 owner,
469                 minerFeeRecipient,
470                 address(batch[i + 6]),
471                 walletSplitPercentage
472             );
473             // Split LRx fee income between miner and wallet
474             splitPayFee(
475                 lrc,
476                 uint(batch[i + 5]),
477                 owner,
478                 minerFeeRecipient,
479                 address(batch[i + 6]),
480                 walletSplitPercentage
481             );
482         }
483     }
484     function isAddressAuthorized(
485         address addr
486         )
487         public
488         view
489         returns (bool)
490     {
491         return addressInfos[addr].authorized;
492     }
493     function splitPayFee(
494         ERC20   token,
495         uint    fee,
496         address owner,
497         address minerFeeRecipient,
498         address walletFeeRecipient,
499         uint    walletSplitPercentage
500         )
501         internal
502     {
503         if (fee == 0) {
504             return;
505         }
506         uint walletFee = (walletFeeRecipient == 0x0) ? 0 : fee.mul(walletSplitPercentage) / 100;
507         uint minerFee = fee - walletFee;
508         if (walletFee > 0 && walletFeeRecipient != owner) {
509             require(
510                 token.transferFrom(
511                     owner,
512                     walletFeeRecipient,
513                     walletFee
514                 )
515             );
516         }
517         if (minerFee > 0 && minerFeeRecipient != 0x0 && minerFeeRecipient != owner) {
518             require(
519                 token.transferFrom(
520                     owner,
521                     minerFeeRecipient,
522                     minerFee
523                 )
524             );
525         }
526     }
527     function addCancelled(bytes32 orderHash, uint cancelAmount)
528         onlyAuthorized
529         external
530     {
531         cancelled[orderHash] = cancelled[orderHash].add(cancelAmount);
532     }
533     function addCancelledOrFilled(bytes32 orderHash, uint cancelOrFillAmount)
534         onlyAuthorized
535         external
536     {
537         cancelledOrFilled[orderHash] = cancelledOrFilled[orderHash].add(cancelOrFillAmount);
538     }
539     function setCutoffs(uint t)
540         onlyAuthorized
541         external
542     {
543         cutoffs[tx.origin] = t;
544     }
545     function setTradingPairCutoffs(bytes20 tokenPair, uint t)
546         onlyAuthorized
547         external
548     {
549         tradingPairCutoffs[tx.origin][tokenPair] = t;
550     }
551     function checkCutoffsBatch(address[] owners, bytes20[] tradingPairs, uint[] validSince)
552         external
553         view
554     {
555         uint len = owners.length;
556         require(len == tradingPairs.length);
557         require(len == validSince.length);
558         for(uint i = 0; i < len; i++) {
559             require(validSince[i] > tradingPairCutoffs[owners[i]][tradingPairs[i]]);  // order trading pair is cut off
560             require(validSince[i] > cutoffs[owners[i]]);                              // order is cut off
561         }
562     }
563 }