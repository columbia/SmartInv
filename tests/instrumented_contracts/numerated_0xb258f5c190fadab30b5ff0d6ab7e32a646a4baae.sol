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
197 /// @title ITradeDelegate
198 /// @dev Acts as a middle man to transfer ERC20 tokens on behalf of different
199 /// versions of Loopring protocol to avoid ERC20 re-authorization.
200 /// @author Daniel Wang - <daniel@loopring.org>.
201 contract ITradeDelegate {
202 
203     function batchTransfer(
204         bytes32[] calldata batch
205         )
206         external;
207 
208 
209     /// @dev Add a Loopring protocol address.
210     /// @param addr A loopring protocol address.
211     function authorizeAddress(
212         address addr
213         )
214         external;
215 
216     /// @dev Remove a Loopring protocol address.
217     /// @param addr A loopring protocol address.
218     function deauthorizeAddress(
219         address addr
220         )
221         external;
222 
223     function isAddressAuthorized(
224         address addr
225         )
226         public
227         view
228         returns (bool);
229 
230 
231     function suspend()
232         external;
233 
234     function resume()
235         external;
236 
237     function kill()
238         external;
239 }
240 
241 /*
242 
243   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
244 
245   Licensed under the Apache License, Version 2.0 (the "License");
246   you may not use this file except in compliance with the License.
247   You may obtain a copy of the License at
248 
249   http://www.apache.org/licenses/LICENSE-2.0
250 
251   Unless required by applicable law or agreed to in writing, software
252   distributed under the License is distributed on an "AS IS" BASIS,
253   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
254   See the License for the specific language governing permissions and
255   limitations under the License.
256 */
257 
258 
259 
260 
261 
262 
263 
264 /// @title Authorizable
265 /// @dev The Authorizable contract allows a contract to be used by other contracts
266 ///      by authorizing it by the contract owner.
267 contract Authorizable is Claimable, Errors  {
268 
269     event AddressAuthorized(
270         address indexed addr
271     );
272 
273     event AddressDeauthorized(
274         address indexed addr
275     );
276 
277     // The list of all authorized addresses
278     address[] authorizedAddresses;
279 
280     mapping (address => uint) private positionMap;
281 
282     struct AuthorizedAddress {
283         uint    pos;
284         address addr;
285     }
286 
287     modifier onlyAuthorized()
288     {
289         require(positionMap[msg.sender] > 0, UNAUTHORIZED);
290         _;
291     }
292 
293     function authorizeAddress(
294         address addr
295         )
296         external
297         onlyOwner
298     {
299         require(address(0x0) != addr, ZERO_ADDRESS);
300         require(0 == positionMap[addr], ALREADY_EXIST);
301         require(isContract(addr), INVALID_ADDRESS);
302 
303         authorizedAddresses.push(addr);
304         positionMap[addr] = authorizedAddresses.length;
305         emit AddressAuthorized(addr);
306     }
307 
308     function deauthorizeAddress(
309         address addr
310         )
311         external
312         onlyOwner
313     {
314         require(address(0x0) != addr, ZERO_ADDRESS);
315 
316         uint pos = positionMap[addr];
317         require(pos != 0, NOT_FOUND);
318 
319         uint size = authorizedAddresses.length;
320         if (pos != size) {
321             address lastOne = authorizedAddresses[size - 1];
322             authorizedAddresses[pos - 1] = lastOne;
323             positionMap[lastOne] = pos;
324         }
325 
326         authorizedAddresses.length -= 1;
327         delete positionMap[addr];
328 
329         emit AddressDeauthorized(addr);
330     }
331 
332     function isAddressAuthorized(
333         address addr
334         )
335         public
336         view
337         returns (bool)
338     {
339         return positionMap[addr] > 0;
340     }
341 
342     function isContract(
343         address addr
344         )
345         internal
346         view
347         returns (bool)
348     {
349         uint size;
350         assembly { size := extcodesize(addr) }
351         return size > 0;
352     }
353 
354 }
355 
356 /*
357 
358   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
359 
360   Licensed under the Apache License, Version 2.0 (the "License");
361   you may not use this file except in compliance with the License.
362   You may obtain a copy of the License at
363 
364   http://www.apache.org/licenses/LICENSE-2.0
365 
366   Unless required by applicable law or agreed to in writing, software
367   distributed under the License is distributed on an "AS IS" BASIS,
368   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
369   See the License for the specific language governing permissions and
370   limitations under the License.
371 */
372 
373 
374 
375 /// @title ERC20 safe transfer
376 /// @dev see https://github.com/sec-bit/badERC20Fix
377 /// @author Brecht Devos - <brecht@loopring.org>
378 library ERC20SafeTransfer {
379 
380     function safeTransfer(
381         address token,
382         address to,
383         uint256 value)
384         internal
385         returns (bool success)
386     {
387         // A transfer is successful when 'call' is successful and depending on the token:
388         // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
389         // - A single boolean is returned: this boolean needs to be true (non-zero)
390 
391         // bytes4(keccak256("transfer(address,uint256)")) = 0xa9059cbb
392         bytes memory callData = abi.encodeWithSelector(
393             bytes4(0xa9059cbb),
394             to,
395             value
396         );
397         (success, ) = token.call(callData);
398         return checkReturnValue(success);
399     }
400 
401     function safeTransferFrom(
402         address token,
403         address from,
404         address to,
405         uint256 value)
406         internal
407         returns (bool success)
408     {
409         // A transferFrom is successful when 'call' is successful and depending on the token:
410         // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
411         // - A single boolean is returned: this boolean needs to be true (non-zero)
412 
413         // bytes4(keccak256("transferFrom(address,address,uint256)")) = 0x23b872dd
414         bytes memory callData = abi.encodeWithSelector(
415             bytes4(0x23b872dd),
416             from,
417             to,
418             value
419         );
420         (success, ) = token.call(callData);
421         return checkReturnValue(success);
422     }
423 
424     function checkReturnValue(
425         bool success
426         )
427         internal
428         pure
429         returns (bool)
430     {
431         // A transfer/transferFrom is successful when 'call' is successful and depending on the token:
432         // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
433         // - A single boolean is returned: this boolean needs to be true (non-zero)
434         if (success) {
435             assembly {
436                 switch returndatasize()
437                 // Non-standard ERC20: nothing is returned so if 'call' was successful we assume the transfer succeeded
438                 case 0 {
439                     success := 1
440                 }
441                 // Standard ERC20: a single boolean value is returned which needs to be true
442                 case 32 {
443                     returndatacopy(0, 0, 32)
444                     success := mload(0)
445                 }
446                 // None of the above: not successful
447                 default {
448                     success := 0
449                 }
450             }
451         }
452         return success;
453     }
454 
455 }
456 /*
457 
458   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
459 
460   Licensed under the Apache License, Version 2.0 (the "License");
461   you may not use this file except in compliance with the License.
462   You may obtain a copy of the License at
463 
464   http://www.apache.org/licenses/LICENSE-2.0
465 
466   Unless required by applicable law or agreed to in writing, software
467   distributed under the License is distributed on an "AS IS" BASIS,
468   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
469   See the License for the specific language governing permissions and
470   limitations under the License.
471 */
472 
473 
474 
475 
476 
477 
478 
479 /// @title Killable
480 /// @dev The Killable contract allows the contract owner to suspend, resume or kill the contract
481 contract Killable is Claimable, Errors  {
482 
483     bool public suspended = false;
484 
485     modifier notSuspended()
486     {
487         require(!suspended, INVALID_STATE);
488         _;
489     }
490 
491     modifier isSuspended()
492     {
493         require(suspended, INVALID_STATE);
494         _;
495     }
496 
497     function suspend()
498         external
499         onlyOwner
500         notSuspended
501     {
502         suspended = true;
503     }
504 
505     function resume()
506         external
507         onlyOwner
508         isSuspended
509     {
510         suspended = false;
511     }
512 
513     /// owner must suspend the delegate first before invoking the kill method.
514     function kill()
515         external
516         onlyOwner
517         isSuspended
518     {
519         owner = address(0x0);
520         emit OwnershipTransferred(owner, address(0x0));
521     }
522 }
523 
524 /*
525 
526   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
527 
528   Licensed under the Apache License, Version 2.0 (the "License");
529   you may not use this file except in compliance with the License.
530   You may obtain a copy of the License at
531 
532   http://www.apache.org/licenses/LICENSE-2.0
533 
534   Unless required by applicable law or agreed to in writing, software
535   distributed under the License is distributed on an "AS IS" BASIS,
536   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
537   See the License for the specific language governing permissions and
538   limitations under the License.
539 */
540 
541 
542 
543 
544 
545 /// @title NoDefaultFunc
546 /// @dev Disable default functions.
547 contract NoDefaultFunc is Errors {
548     function ()
549         external
550         payable
551     {
552         revert(UNSUPPORTED);
553     }
554 }
555 
556 
557 
558 /// @title An Implementation of ITradeDelegate.
559 /// @author Daniel Wang - <daniel@loopring.org>.
560 /// @author Kongliang Zhong - <kongliang@loopring.org>.
561 contract TradeDelegate is ITradeDelegate, Authorizable, Killable, NoDefaultFunc {
562     using ERC20SafeTransfer for address;
563 
564     function batchTransfer(
565         bytes32[] calldata batch
566         )
567         external
568         onlyAuthorized
569         notSuspended
570     {
571         uint length = batch.length;
572         require(length % 4 == 0, INVALID_SIZE);
573 
574         uint start = 68;
575         uint end = start + length * 32;
576         for (uint p = start; p < end; p += 128) {
577             address token;
578             address from;
579             address to;
580             uint amount;
581             assembly {
582                 token := calldataload(add(p,  0))
583                 from := calldataload(add(p, 32))
584                 to := calldataload(add(p, 64))
585                 amount := calldataload(add(p, 96))
586             }
587             require(
588                 token.safeTransferFrom(
589                     from,
590                     to,
591                     amount
592                 ),
593                 TRANSFER_FAILURE
594             );
595         }
596     }
597 }