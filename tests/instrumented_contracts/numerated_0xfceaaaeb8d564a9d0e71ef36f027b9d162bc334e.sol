1 // File: contracts/components/Proxy.sol
2 
3 /*
4 
5   Copyright 2019 Wanchain Foundation.
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
18 
19 */
20 
21 //                            _           _           _
22 //  __      ____ _ _ __   ___| |__   __ _(_)_ __   __| | _____   __
23 //  \ \ /\ / / _` | '_ \ / __| '_ \ / _` | | '_ \@/ _` |/ _ \ \ / /
24 //   \ V  V / (_| | | | | (__| | | | (_| | | | | | (_| |  __/\ V /
25 //    \_/\_/ \__,_|_| |_|\___|_| |_|\__,_|_|_| |_|\__,_|\___| \_/
26 //
27 //
28 
29 pragma solidity ^0.4.24;
30 
31 /**
32  * Math operations with safety checks
33  */
34 
35 
36 contract Proxy {
37 
38     event Upgraded(address indexed implementation);
39 
40     address internal _implementation;
41 
42     function implementation() public view returns (address) {
43         return _implementation;
44     }
45 
46     function () external payable {
47         address _impl = _implementation;
48         require(_impl != address(0), "implementation contract not set");
49 
50         assembly {
51             let ptr := mload(0x40)
52             calldatacopy(ptr, 0, calldatasize)
53             let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
54             let size := returndatasize
55             returndatacopy(ptr, 0, size)
56 
57             switch result
58             case 0 { revert(ptr, size) }
59             default { return(ptr, size) }
60         }
61     }
62 }
63 
64 // File: contracts/components/Owned.sol
65 
66 /*
67 
68   Copyright 2019 Wanchain Foundation.
69 
70   Licensed under the Apache License, Version 2.0 (the "License");
71   you may not use this file except in compliance with the License.
72   You may obtain a copy of the License at
73 
74   http://www.apache.org/licenses/LICENSE-2.0
75 
76   Unless required by applicable law or agreed to in writing, software
77   distributed under the License is distributed on an "AS IS" BASIS,
78   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
79   See the License for the specific language governing permissions and
80   limitations under the License.
81 
82 */
83 
84 //                            _           _           _
85 //  __      ____ _ _ __   ___| |__   __ _(_)_ __   __| | _____   __
86 //  \ \ /\ / / _` | '_ \ / __| '_ \ / _` | | '_ \@/ _` |/ _ \ \ / /
87 //   \ V  V / (_| | | | | (__| | | | (_| | | | | | (_| |  __/\ V /
88 //    \_/\_/ \__,_|_| |_|\___|_| |_|\__,_|_|_| |_|\__,_|\___| \_/
89 //
90 //
91 
92 pragma solidity ^0.4.24;
93 
94 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
95 ///  later changed
96 contract Owned {
97 
98     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
99 
100     /// @dev `owner` is the only address that can call a function with this
101     /// modifier
102     modifier onlyOwner() {
103         require(msg.sender == owner, "Not owner");
104         _;
105     }
106 
107     address public owner;
108 
109     /// @notice The Constructor assigns the message sender to be `owner`
110     constructor() public {
111         owner = msg.sender;
112     }
113 
114     address public newOwner;
115 
116     function transferOwner(address _newOwner) public onlyOwner {
117         require(_newOwner != address(0), "New owner is the zero address");
118         emit OwnershipTransferred(owner, _newOwner);
119         owner = _newOwner;
120     }
121 
122     /// @notice `owner` can step down and assign some other address to this role
123     /// @param _newOwner The address of the new owner. 0x0 can be used to create
124     ///  an unowned neutral vault, however that cannot be undone
125     function changeOwner(address _newOwner) public onlyOwner {
126         newOwner = _newOwner;
127     }
128 
129     function acceptOwnership() public {
130         if (msg.sender == newOwner) {
131             owner = newOwner;
132         }
133     }
134 
135     function renounceOwnership() public onlyOwner {
136         owner = address(0);
137     }
138 }
139 
140 // File: contracts/components/Halt.sol
141 
142 /*
143 
144   Copyright 2019 Wanchain Foundation.
145 
146   Licensed under the Apache License, Version 2.0 (the "License");
147   you may not use this file except in compliance with the License.
148   You may obtain a copy of the License at
149 
150   http://www.apache.org/licenses/LICENSE-2.0
151 
152   Unless required by applicable law or agreed to in writing, software
153   distributed under the License is distributed on an "AS IS" BASIS,
154   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
155   See the License for the specific language governing permissions and
156   limitations under the License.
157 
158 */
159 
160 //                            _           _           _
161 //  __      ____ _ _ __   ___| |__   __ _(_)_ __   __| | _____   __
162 //  \ \ /\ / / _` | '_ \ / __| '_ \ / _` | | '_ \@/ _` |/ _ \ \ / /
163 //   \ V  V / (_| | | | | (__| | | | (_| | | | | | (_| |  __/\ V /
164 //    \_/\_/ \__,_|_| |_|\___|_| |_|\__,_|_|_| |_|\__,_|\___| \_/
165 //
166 //
167 
168 pragma solidity ^0.4.24;
169 
170 
171 contract Halt is Owned {
172 
173     bool public halted = false;
174 
175     modifier notHalted() {
176         require(!halted, "Smart contract is halted");
177         _;
178     }
179 
180     modifier isHalted() {
181         require(halted, "Smart contract is not halted");
182         _;
183     }
184 
185     /// @notice function Emergency situation that requires
186     /// @notice contribution period to stop or not.
187     function setHalt(bool halt)
188         public
189         onlyOwner
190     {
191         halted = halt;
192     }
193 }
194 
195 // File: contracts/components/ReentrancyGuard.sol
196 
197 pragma solidity 0.4.26;
198 
199 /**
200  * @dev Contract module that helps prevent reentrant calls to a function.
201  *
202  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
203  * available, which can be applied to functions to make sure there are no nested
204  * (reentrant) calls to them.
205  *
206  * Note that because there is a single `nonReentrant` guard, functions marked as
207  * `nonReentrant` may not call one another. This can be worked around by making
208  * those functions `private`, and then adding `external` `nonReentrant` entry
209  * points to them.
210  *
211  * TIP: If you would like to learn more about reentrancy and alternative ways
212  * to protect against it, check out our blog post
213  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
214  */
215 contract ReentrancyGuard {
216     bool private _notEntered;
217 
218     constructor () internal {
219         // Storing an initial non-zero value makes deployment a bit more
220         // expensive, but in exchange the refund on every call to nonReentrant
221         // will be lower in amount. Since refunds are capped to a percetange of
222         // the total transaction's gas, it is best to keep them low in cases
223         // like this one, to increase the likelihood of the full refund coming
224         // into effect.
225         _notEntered = true;
226     }
227 
228     /**
229      * @dev Prevents a contract from calling itself, directly or indirectly.
230      * Calling a `nonReentrant` function from another `nonReentrant`
231      * function is not supported. It is possible to prevent this from happening
232      * by making the `nonReentrant` function external, and make it call a
233      * `private` function that does the actual work.
234      */
235     modifier nonReentrant() {
236         // On the first call to nonReentrant, _notEntered will be true
237         require(_notEntered, "ReentrancyGuard: reentrant call");
238 
239         // Any calls to nonReentrant after this point will fail
240         _notEntered = false;
241 
242         _;
243 
244         // By storing the original value once again, a refund is triggered (see
245         // https://eips.ethereum.org/EIPS/eip-2200)
246         _notEntered = true;
247     }
248 }
249 
250 // File: contracts/lib/BasicStorageLib.sol
251 
252 pragma solidity ^0.4.24;
253 
254 library BasicStorageLib {
255 
256     struct UintData {
257         mapping(bytes => mapping(bytes => uint))           _storage;
258     }
259 
260     struct BoolData {
261         mapping(bytes => mapping(bytes => bool))           _storage;
262     }
263 
264     struct AddressData {
265         mapping(bytes => mapping(bytes => address))        _storage;
266     }
267 
268     struct BytesData {
269         mapping(bytes => mapping(bytes => bytes))          _storage;
270     }
271 
272     struct StringData {
273         mapping(bytes => mapping(bytes => string))         _storage;
274     }
275 
276     /* uintStorage */
277 
278     function setStorage(UintData storage self, bytes memory key, bytes memory innerKey, uint value) internal {
279         self._storage[key][innerKey] = value;
280     }
281 
282     function getStorage(UintData storage self, bytes memory key, bytes memory innerKey) internal view returns (uint) {
283         return self._storage[key][innerKey];
284     }
285 
286     function delStorage(UintData storage self, bytes memory key, bytes memory innerKey) internal {
287         delete self._storage[key][innerKey];
288     }
289 
290     /* boolStorage */
291 
292     function setStorage(BoolData storage self, bytes memory key, bytes memory innerKey, bool value) internal {
293         self._storage[key][innerKey] = value;
294     }
295 
296     function getStorage(BoolData storage self, bytes memory key, bytes memory innerKey) internal view returns (bool) {
297         return self._storage[key][innerKey];
298     }
299 
300     function delStorage(BoolData storage self, bytes memory key, bytes memory innerKey) internal {
301         delete self._storage[key][innerKey];
302     }
303 
304     /* addressStorage */
305 
306     function setStorage(AddressData storage self, bytes memory key, bytes memory innerKey, address value) internal {
307         self._storage[key][innerKey] = value;
308     }
309 
310     function getStorage(AddressData storage self, bytes memory key, bytes memory innerKey) internal view returns (address) {
311         return self._storage[key][innerKey];
312     }
313 
314     function delStorage(AddressData storage self, bytes memory key, bytes memory innerKey) internal {
315         delete self._storage[key][innerKey];
316     }
317 
318     /* bytesStorage */
319 
320     function setStorage(BytesData storage self, bytes memory key, bytes memory innerKey, bytes memory value) internal {
321         self._storage[key][innerKey] = value;
322     }
323 
324     function getStorage(BytesData storage self, bytes memory key, bytes memory innerKey) internal view returns (bytes memory) {
325         return self._storage[key][innerKey];
326     }
327 
328     function delStorage(BytesData storage self, bytes memory key, bytes memory innerKey) internal {
329         delete self._storage[key][innerKey];
330     }
331 
332     /* stringStorage */
333 
334     function setStorage(StringData storage self, bytes memory key, bytes memory innerKey, string memory value) internal {
335         self._storage[key][innerKey] = value;
336     }
337 
338     function getStorage(StringData storage self, bytes memory key, bytes memory innerKey) internal view returns (string memory) {
339         return self._storage[key][innerKey];
340     }
341 
342     function delStorage(StringData storage self, bytes memory key, bytes memory innerKey) internal {
343         delete self._storage[key][innerKey];
344     }
345 
346 }
347 
348 // File: contracts/components/BasicStorage.sol
349 
350 pragma solidity ^0.4.24;
351 
352 
353 contract BasicStorage {
354     /************************************************************
355      **
356      ** VARIABLES
357      **
358      ************************************************************/
359 
360     //// basic variables
361     using BasicStorageLib for BasicStorageLib.UintData;
362     using BasicStorageLib for BasicStorageLib.BoolData;
363     using BasicStorageLib for BasicStorageLib.AddressData;
364     using BasicStorageLib for BasicStorageLib.BytesData;
365     using BasicStorageLib for BasicStorageLib.StringData;
366 
367     BasicStorageLib.UintData    internal uintData;
368     BasicStorageLib.BoolData    internal boolData;
369     BasicStorageLib.AddressData internal addressData;
370     BasicStorageLib.BytesData   internal bytesData;
371     BasicStorageLib.StringData  internal stringData;
372 }
373 
374 // File: contracts/interfaces/IRC20Protocol.sol
375 
376 /*
377 
378   Copyright 2019 Wanchain Foundation.
379 
380   Licensed under the Apache License, Version 2.0 (the "License");
381   you may not use this file except in compliance with the License.
382   You may obtain a copy of the License at
383 
384   http://www.apache.org/licenses/LICENSE-2.0
385 
386   Unless required by applicable law or agreed to in writing, software
387   distributed under the License is distributed on an "AS IS" BASIS,
388   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
389   See the License for the specific language governing permissions and
390   limitations under the License.
391 
392 */
393 
394 //                            _           _           _
395 //  __      ____ _ _ __   ___| |__   __ _(_)_ __   __| | _____   __
396 //  \ \ /\ / / _` | '_ \ / __| '_ \ / _` | | '_ \@/ _` |/ _ \ \ / /
397 //   \ V  V / (_| | | | | (__| | | | (_| | | | | | (_| |  __/\ V /
398 //    \_/\_/ \__,_|_| |_|\___|_| |_|\__,_|_|_| |_|\__,_|\___| \_/
399 //
400 //
401 
402 pragma solidity ^0.4.26;
403 
404 interface IRC20Protocol {
405     function transfer(address, uint) external returns (bool);
406     function transferFrom(address, address, uint) external returns (bool);
407     function balanceOf(address _owner) external view returns (uint);
408 }
409 
410 // File: contracts/interfaces/IQuota.sol
411 
412 /*
413 
414   Copyright 2019 Wanchain Foundation.
415 
416   Licensed under the Apache License, Version 2.0 (the "License");
417   you may not use this file except in compliance with the License.
418   You may obtain a copy of the License at
419 
420   http://www.apache.org/licenses/LICENSE-2.0
421 
422   Unless required by applicable law or agreed to in writing, software
423   distributed under the License is distributed on an "AS IS" BASIS,
424   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
425   See the License for the specific language governing permissions and
426   limitations under the License.
427 
428 */
429 
430 //                            _           _           _
431 //  __      ____ _ _ __   ___| |__   __ _(_)_ __   __| | _____   __
432 //  \ \ /\ / / _` | '_ \ / __| '_ \ / _` | | '_ \@/ _` |/ _ \ \ / /
433 //   \ V  V / (_| | | | | (__| | | | (_| | | | | | (_| |  __/\ V /
434 //    \_/\_/ \__,_|_| |_|\___|_| |_|\__,_|_|_| |_|\__,_|\___| \_/
435 //
436 //
437 
438 pragma solidity 0.4.26;
439 
440 interface IQuota {
441   function userMintLock(uint tokenId, bytes32 storemanGroupId, uint value) external;
442   function userMintRevoke(uint tokenId, bytes32 storemanGroupId, uint value) external;
443   function userMintRedeem(uint tokenId, bytes32 storemanGroupId, uint value) external;
444 
445   function smgMintLock(uint tokenId, bytes32 storemanGroupId, uint value) external;
446   function smgMintRevoke(uint tokenId, bytes32 storemanGroupId, uint value) external;
447   function smgMintRedeem(uint tokenId, bytes32 storemanGroupId, uint value) external;
448 
449   function userBurnLock(uint tokenId, bytes32 storemanGroupId, uint value) external;
450   function userBurnRevoke(uint tokenId, bytes32 storemanGroupId, uint value) external;
451   function userBurnRedeem(uint tokenId, bytes32 storemanGroupId, uint value) external;
452 
453   function smgBurnLock(uint tokenId, bytes32 storemanGroupId, uint value) external;
454   function smgBurnRevoke(uint tokenId, bytes32 storemanGroupId, uint value) external;
455   function smgBurnRedeem(uint tokenId, bytes32 storemanGroupId, uint value) external;
456 
457   function userFastMint(uint tokenId, bytes32 storemanGroupId, uint value) external;
458   function userFastBurn(uint tokenId, bytes32 storemanGroupId, uint value) external;
459 
460   function smgFastMint(uint tokenId, bytes32 storemanGroupId, uint value) external;
461   function smgFastBurn(uint tokenId, bytes32 storemanGroupId, uint value) external;
462 
463   function assetLock(bytes32 srcStoremanGroupId, bytes32 dstStoremanGroupId) external;
464   function assetRedeem(bytes32 srcStoremanGroupId, bytes32 dstStoremanGroupId) external;
465   function assetRevoke(bytes32 srcStoremanGroupId, bytes32 dstStoremanGroupId) external;
466 
467   function debtLock(bytes32 srcStoremanGroupId, bytes32 dstStoremanGroupId) external;
468   function debtRedeem(bytes32 srcStoremanGroupId, bytes32 dstStoremanGroupId) external;
469   function debtRevoke(bytes32 srcStoremanGroupId, bytes32 dstStoremanGroupId) external;
470 
471   function getUserMintQuota(uint tokenId, bytes32 storemanGroupId) external view returns (uint);
472   function getSmgMintQuota(uint tokenId, bytes32 storemanGroupId) external view returns (uint);
473 
474   function getUserBurnQuota(uint tokenId, bytes32 storemanGroupId) external view returns (uint);
475   function getSmgBurnQuota(uint tokenId, bytes32 storemanGroupId) external view returns (uint);
476 
477   function getAsset(uint tokenId, bytes32 storemanGroupId) external view returns (uint asset, uint asset_receivable, uint asset_payable);
478   function getDebt(uint tokenId, bytes32 storemanGroupId) external view returns (uint debt, uint debt_receivable, uint debt_payable);
479 
480   function isDebtClean(bytes32 storemanGroupId) external view returns (bool);
481 }
482 
483 // File: contracts/interfaces/IStoremanGroup.sol
484 
485 /*
486 
487   Copyright 2019 Wanchain Foundation.
488 
489   Licensed under the Apache License, Version 2.0 (the "License");
490   you may not use this file except in compliance with the License.
491   You may obtain a copy of the License at
492 
493   http://www.apache.org/licenses/LICENSE-2.0
494 
495   Unless required by applicable law or agreed to in writing, software
496   distributed under the License is distributed on an "AS IS" BASIS,
497   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
498   See the License for the specific language governing permissions and
499   limitations under the License.
500 
501 */
502 
503 //                            _           _           _
504 //  __      ____ _ _ __   ___| |__   __ _(_)_ __   __| | _____   __
505 //  \ \ /\ / / _` | '_ \ / __| '_ \ / _` | | '_ \@/ _` |/ _ \ \ / /
506 //   \ V  V / (_| | | | | (__| | | | (_| | | | | | (_| |  __/\ V /
507 //    \_/\_/ \__,_|_| |_|\___|_| |_|\__,_|_|_| |_|\__,_|\___| \_/
508 //
509 //
510 
511 pragma solidity ^0.4.24;
512 
513 interface IStoremanGroup {
514     function getSelectedSmNumber(bytes32 groupId) external view returns(uint number);
515     function getStoremanGroupConfig(bytes32 id) external view returns(bytes32 groupId, uint8 status, uint deposit, uint chain1, uint chain2, uint curve1, uint curve2,  bytes gpk1, bytes gpk2, uint startTime, uint endTime);
516     function getDeposit(bytes32 id) external view returns(uint);
517     function getStoremanGroupStatus(bytes32 id) external view returns(uint8 status, uint startTime, uint endTime);
518     function setGpk(bytes32 groupId, bytes gpk1, bytes gpk2) external;
519     function setInvalidSm(bytes32 groupId, uint[] indexs, uint8[] slashTypes) external returns(bool isContinue);
520     function getThresholdByGrpId(bytes32 groupId) external view returns (uint);
521     function getSelectedSmInfo(bytes32 groupId, uint index) external view returns(address wkAddr, bytes PK, bytes enodeId);
522     function recordSmSlash(address wk) public;
523 }
524 
525 // File: contracts/interfaces/ITokenManager.sol
526 
527 /*
528 
529   Copyright 2019 Wanchain Foundation.
530 
531   Licensed under the Apache License, Version 2.0 (the "License");
532   you may not use this file except in compliance with the License.
533   You may obtain a copy of the License at
534 
535   http://www.apache.org/licenses/LICENSE-2.0
536 
537   Unless required by applicable law or agreed to in writing, software
538   distributed under the License is distributed on an "AS IS" BASIS,
539   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
540   See the License for the specific language governing permissions and
541   limitations under the License.
542 
543 */
544 
545 //                            _           _           _
546 //  __      ____ _ _ __   ___| |__   __ _(_)_ __   __| | _____   __
547 //  \ \ /\ / / _` | '_ \ / __| '_ \ / _` | | '_ \@/ _` |/ _ \ \ / /
548 //   \ V  V / (_| | | | | (__| | | | (_| | | | | | (_| |  __/\ V /
549 //    \_/\_/ \__,_|_| |_|\___|_| |_|\__,_|_|_| |_|\__,_|\___| \_/
550 //
551 //
552 
553 pragma solidity 0.4.26;
554 
555 interface ITokenManager {
556     function getTokenPairInfo(uint id) external view
557       returns (uint origChainID, bytes tokenOrigAccount, uint shadowChainID, bytes tokenShadowAccount);
558 
559     function getTokenPairInfoSlim(uint id) external view 
560       returns (uint origChainID, bytes tokenOrigAccount, uint shadowChainID);
561 
562     function mintToken(uint id, address to,uint value) external;
563 
564     function burnToken(uint id, uint value) external;
565 }
566 
567 // File: contracts/interfaces/ISignatureVerifier.sol
568 
569 /*
570 
571   Copyright 2019 Wanchain Foundation.
572 
573   Licensed under the Apache License, Version 2.0 (the "License");
574   you may not use this file except in compliance with the License.
575   You may obtain a copy of the License at
576 
577   http://www.apache.org/licenses/LICENSE-2.0
578 
579   Unless required by applicable law or agreed to in writing, software
580   distributed under the License is distributed on an "AS IS" BASIS,
581   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
582   See the License for the specific language governing permissions and
583   limitations under the License.
584 
585 */
586 
587 //                            _           _           _
588 //  __      ____ _ _ __   ___| |__   __ _(_)_ __   __| | _____   __
589 //  \ \ /\ / / _` | '_ \ / __| '_ \ / _` | | '_ \@/ _` |/ _ \ \ / /
590 //   \ V  V / (_| | | | | (__| | | | (_| | | | | | (_| |  __/\ V /
591 //    \_/\_/ \__,_|_| |_|\___|_| |_|\__,_|_|_| |_|\__,_|\___| \_/
592 //
593 //
594 
595 pragma solidity 0.4.26;
596 
597 interface ISignatureVerifier {
598   function verify(
599         uint curveId,
600         bytes32 signature,
601         bytes32 groupKeyX,
602         bytes32 groupKeyY,
603         bytes32 randomPointX,
604         bytes32 randomPointY,
605         bytes32 message
606     ) external returns (bool);
607 }
608 
609 // File: contracts/lib/SafeMath.sol
610 
611 pragma solidity ^0.4.24;
612 
613 /**
614  * Math operations with safety checks
615  */
616 library SafeMath {
617 
618     /**
619     * @dev Multiplies two numbers, reverts on overflow.
620     */
621     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
622         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
623         // benefit is lost if 'b' is also tested.
624         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
625         if (a == 0) {
626             return 0;
627         }
628 
629         uint256 c = a * b;
630         require(c / a == b, "SafeMath mul overflow");
631 
632         return c;
633     }
634 
635     /**
636     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
637     */
638     function div(uint256 a, uint256 b) internal pure returns (uint256) {
639         require(b > 0, "SafeMath div 0"); // Solidity only automatically asserts when dividing by 0
640         uint256 c = a / b;
641         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
642 
643         return c;
644     }
645 
646     /**
647     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
648     */
649     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
650         require(b <= a, "SafeMath sub b > a");
651         uint256 c = a - b;
652 
653         return c;
654     }
655 
656     /**
657     * @dev Adds two numbers, reverts on overflow.
658     */
659     function add(uint256 a, uint256 b) internal pure returns (uint256) {
660         uint256 c = a + b;
661         require(c >= a, "SafeMath add overflow");
662 
663         return c;
664     }
665 
666     /**
667     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
668     * reverts when dividing by zero.
669     */
670     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
671         require(b != 0, "SafeMath mod 0");
672         return a % b;
673     }
674 }
675 
676 // File: contracts/crossApproach/lib/HTLCTxLib.sol
677 
678 /*
679 
680   Copyright 2019 Wanchain Foundation.
681 
682   Licensed under the Apache License, Version 2.0 (the "License");
683   you may not use this file except in compliance with the License.
684   You may obtain a copy of the License at
685 
686   http://www.apache.org/licenses/LICENSE-2.0
687 
688   Unless required by applicable law or agreed to in writing, software
689   distributed under the License is distributed on an "AS IS" BASIS,
690   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
691   See the License for the specific language governing permissions and
692   limitations under the License.
693 
694 */
695 
696 //                            _           _           _
697 //  __      ____ _ _ __   ___| |__   __ _(_)_ __   __| | _____   __
698 //  \ \ /\ / / _` | '_ \ / __| '_ \ / _` | | '_ \@/ _` |/ _ \ \ / /
699 //   \ V  V / (_| | | | | (__| | | | (_| | | | | | (_| |  __/\ V /
700 //    \_/\_/ \__,_|_| |_|\___|_| |_|\__,_|_|_| |_|\__,_|\___| \_/
701 //
702 //
703 
704 pragma solidity ^0.4.26;
705 pragma experimental ABIEncoderV2;
706 
707 
708 library HTLCTxLib {
709     using SafeMath for uint;
710 
711     /**
712      *
713      * ENUMS
714      *
715      */
716 
717     /// @notice tx info status
718     /// @notice uninitialized,locked,redeemed,revoked
719     enum TxStatus {None, Locked, Redeemed, Revoked}
720 
721     /**
722      *
723      * STRUCTURES
724      *
725      */
726 
727     /// @notice struct of HTLC user mint lock parameters
728     struct HTLCUserParams {
729         bytes32 xHash;                  /// hash of HTLC random number
730         bytes32 smgID;                  /// ID of storeman group which user has selected
731         uint tokenPairID;               /// token pair id on cross chain
732         uint value;                     /// exchange token value
733         uint lockFee;                   /// exchange token value
734         uint lockedTime;                /// HTLC lock time
735     }
736 
737     /// @notice HTLC(Hashed TimeLock Contract) tx info
738     struct BaseTx {
739         bytes32 smgID;                  /// HTLC transaction storeman ID
740         uint lockedTime;                /// HTLC transaction locked time
741         uint beginLockedTime;           /// HTLC transaction begin locked time
742         TxStatus status;                /// HTLC transaction status
743     }
744 
745     /// @notice user  tx info
746     struct UserTx {
747         BaseTx baseTx;
748         uint tokenPairID;
749         uint value;
750         uint fee;
751         address userAccount;            /// HTLC transaction sender address for the security check while user's revoke
752     }
753     /// @notice storeman  tx info
754     struct SmgTx {
755         BaseTx baseTx;
756         uint tokenPairID;
757         uint value;
758         address  userAccount;          /// HTLC transaction user address for the security check while user's redeem
759     }
760     /// @notice storeman  debt tx info
761     struct DebtTx {
762         BaseTx baseTx;
763         bytes32 srcSmgID;              /// HTLC transaction sender(source storeman) ID
764     }
765 
766     struct Data {
767         /// @notice mapping of hash(x) to UserTx -- xHash->htlcUserTxData
768         mapping(bytes32 => UserTx) mapHashXUserTxs;
769 
770         /// @notice mapping of hash(x) to SmgTx -- xHash->htlcSmgTxData
771         mapping(bytes32 => SmgTx) mapHashXSmgTxs;
772 
773         /// @notice mapping of hash(x) to DebtTx -- xHash->htlcDebtTxData
774         mapping(bytes32 => DebtTx) mapHashXDebtTxs;
775 
776     }
777 
778     /**
779      *
780      * MANIPULATIONS
781      *
782      */
783 
784     /// @notice                     add user transaction info
785     /// @param params               parameters for user tx
786     function addUserTx(Data storage self, HTLCUserParams memory params)
787         public
788     {
789         UserTx memory userTx = self.mapHashXUserTxs[params.xHash];
790         // UserTx storage userTx = self.mapHashXUserTxs[params.xHash];
791         // require(params.value != 0, "Value is invalid");
792         require(userTx.baseTx.status == TxStatus.None, "User tx exists");
793 
794         userTx.baseTx.smgID = params.smgID;
795         userTx.baseTx.lockedTime = params.lockedTime;
796         userTx.baseTx.beginLockedTime = now;
797         userTx.baseTx.status = TxStatus.Locked;
798         userTx.tokenPairID = params.tokenPairID;
799         userTx.value = params.value;
800         userTx.fee = params.lockFee;
801         userTx.userAccount = msg.sender;
802 
803         self.mapHashXUserTxs[params.xHash] = userTx;
804     }
805 
806     /// @notice                     refund coins from HTLC transaction, which is used for storeman redeem(outbound)
807     /// @param x                    HTLC random number
808     function redeemUserTx(Data storage self, bytes32 x)
809         external
810         returns(bytes32 xHash)
811     {
812         xHash = sha256(abi.encodePacked(x));
813 
814         UserTx storage userTx = self.mapHashXUserTxs[xHash];
815         require(userTx.baseTx.status == TxStatus.Locked, "Status is not locked");
816         require(now < userTx.baseTx.beginLockedTime.add(userTx.baseTx.lockedTime), "Redeem timeout");
817 
818         userTx.baseTx.status = TxStatus.Redeemed;
819 
820         return xHash;
821     }
822 
823     /// @notice                     revoke user transaction
824     /// @param  xHash               hash of HTLC random number
825     function revokeUserTx(Data storage self, bytes32 xHash)
826         external
827     {
828         UserTx storage userTx = self.mapHashXUserTxs[xHash];
829         require(userTx.baseTx.status == TxStatus.Locked, "Status is not locked");
830         require(now >= userTx.baseTx.beginLockedTime.add(userTx.baseTx.lockedTime), "Revoke is not permitted");
831 
832         userTx.baseTx.status = TxStatus.Revoked;
833     }
834 
835     /// @notice                    function for get user info
836     /// @param xHash               hash of HTLC random number
837     /// @return smgID              ID of storeman which user has selected
838     /// @return tokenPairID        token pair ID of cross chain
839     /// @return value              exchange value
840     /// @return fee                exchange fee
841     /// @return userAccount        HTLC transaction sender address for the security check while user's revoke
842     function getUserTx(Data storage self, bytes32 xHash)
843         external
844         view
845         returns (bytes32, uint, uint, uint, address)
846     {
847         UserTx storage userTx = self.mapHashXUserTxs[xHash];
848         return (userTx.baseTx.smgID, userTx.tokenPairID, userTx.value, userTx.fee, userTx.userAccount);
849     }
850 
851     /// @notice                     add storeman transaction info
852     /// @param  xHash               hash of HTLC random number
853     /// @param  smgID               ID of the storeman which user has selected
854     /// @param  tokenPairID         token pair ID of cross chain
855     /// @param  value               HTLC transfer value of token
856     /// @param  userAccount            user account address on the destination chain, which is used to redeem token
857     function addSmgTx(Data storage self, bytes32 xHash, bytes32 smgID, uint tokenPairID, uint value, address userAccount, uint lockedTime)
858         external
859     {
860         SmgTx memory smgTx = self.mapHashXSmgTxs[xHash];
861         // SmgTx storage smgTx = self.mapHashXSmgTxs[xHash];
862         require(value != 0, "Value is invalid");
863         require(smgTx.baseTx.status == TxStatus.None, "Smg tx exists");
864 
865         smgTx.baseTx.smgID = smgID;
866         smgTx.baseTx.status = TxStatus.Locked;
867         smgTx.baseTx.lockedTime = lockedTime;
868         smgTx.baseTx.beginLockedTime = now;
869         smgTx.tokenPairID = tokenPairID;
870         smgTx.value = value;
871         smgTx.userAccount = userAccount;
872 
873         self.mapHashXSmgTxs[xHash] = smgTx;
874     }
875 
876     /// @notice                     refund coins from HTLC transaction, which is used for users redeem(inbound)
877     /// @param x                    HTLC random number
878     function redeemSmgTx(Data storage self, bytes32 x)
879         external
880         returns(bytes32 xHash)
881     {
882         xHash = sha256(abi.encodePacked(x));
883 
884         SmgTx storage smgTx = self.mapHashXSmgTxs[xHash];
885         require(smgTx.baseTx.status == TxStatus.Locked, "Status is not locked");
886         require(now < smgTx.baseTx.beginLockedTime.add(smgTx.baseTx.lockedTime), "Redeem timeout");
887 
888         smgTx.baseTx.status = TxStatus.Redeemed;
889 
890         return xHash;
891     }
892 
893     /// @notice                     revoke storeman transaction
894     /// @param  xHash               hash of HTLC random number
895     function revokeSmgTx(Data storage self, bytes32 xHash)
896         external
897     {
898         SmgTx storage smgTx = self.mapHashXSmgTxs[xHash];
899         require(smgTx.baseTx.status == TxStatus.Locked, "Status is not locked");
900         require(now >= smgTx.baseTx.beginLockedTime.add(smgTx.baseTx.lockedTime), "Revoke is not permitted");
901 
902         smgTx.baseTx.status = TxStatus.Revoked;
903     }
904 
905     /// @notice                     function for get smg info
906     /// @param xHash                hash of HTLC random number
907     /// @return smgID               ID of storeman which user has selected
908     /// @return tokenPairID         token pair ID of cross chain
909     /// @return value               exchange value
910     /// @return userAccount            user account address for redeem
911     function getSmgTx(Data storage self, bytes32 xHash)
912         external
913         view
914         returns (bytes32, uint, uint, address)
915     {
916         SmgTx storage smgTx = self.mapHashXSmgTxs[xHash];
917         return (smgTx.baseTx.smgID, smgTx.tokenPairID, smgTx.value, smgTx.userAccount);
918     }
919 
920     /// @notice                     add storeman transaction info
921     /// @param  xHash               hash of HTLC random number
922     /// @param  srcSmgID            ID of source storeman group
923     /// @param  destSmgID           ID of the storeman which will take over of the debt of source storeman group
924     /// @param  lockedTime          HTLC lock time
925     function addDebtTx(Data storage self, bytes32 xHash, bytes32 srcSmgID, bytes32 destSmgID, uint lockedTime)
926         external
927     {
928         DebtTx memory debtTx = self.mapHashXDebtTxs[xHash];
929         // DebtTx storage debtTx = self.mapHashXDebtTxs[xHash];
930         require(debtTx.baseTx.status == TxStatus.None, "Debt tx exists");
931 
932         debtTx.baseTx.smgID = destSmgID;
933         debtTx.baseTx.status = TxStatus.Locked;
934         debtTx.baseTx.lockedTime = lockedTime;
935         debtTx.baseTx.beginLockedTime = now;
936         debtTx.srcSmgID = srcSmgID;
937 
938         self.mapHashXDebtTxs[xHash] = debtTx;
939     }
940 
941     /// @notice                     refund coins from HTLC transaction
942     /// @param x                    HTLC random number
943     function redeemDebtTx(Data storage self, bytes32 x)
944         external
945         returns(bytes32 xHash)
946     {
947         xHash = sha256(abi.encodePacked(x));
948 
949         DebtTx storage debtTx = self.mapHashXDebtTxs[xHash];
950         require(debtTx.baseTx.status == TxStatus.Locked, "Status is not locked");
951         require(now < debtTx.baseTx.beginLockedTime.add(debtTx.baseTx.lockedTime), "Redeem timeout");
952 
953         debtTx.baseTx.status = TxStatus.Redeemed;
954 
955         return xHash;
956     }
957 
958     /// @notice                     revoke debt transaction, which is used for source storeman group
959     /// @param  xHash               hash of HTLC random number
960     function revokeDebtTx(Data storage self, bytes32 xHash)
961         external
962     {
963         DebtTx storage debtTx = self.mapHashXDebtTxs[xHash];
964         require(debtTx.baseTx.status == TxStatus.Locked, "Status is not locked");
965         require(now >= debtTx.baseTx.beginLockedTime.add(debtTx.baseTx.lockedTime), "Revoke is not permitted");
966 
967         debtTx.baseTx.status = TxStatus.Revoked;
968     }
969 
970     /// @notice                     function for get debt info
971     /// @param xHash                hash of HTLC random number
972     /// @return srcSmgID            ID of source storeman
973     /// @return destSmgID           ID of destination storeman
974     function getDebtTx(Data storage self, bytes32 xHash)
975         external
976         view
977         returns (bytes32, bytes32)
978     {
979         DebtTx storage debtTx = self.mapHashXDebtTxs[xHash];
980         return (debtTx.srcSmgID, debtTx.baseTx.smgID);
981     }
982 
983     function getLeftTime(uint endTime) private view returns (uint) {
984         if (now < endTime) {
985             return endTime.sub(now);
986         }
987         return 0;
988     }
989 
990     /// @notice                     function for get debt info
991     /// @param xHash                hash of HTLC random number
992     /// @return leftTime            the left lock time
993     function getLeftLockedTime(Data storage self, bytes32 xHash)
994         external
995         view
996         returns (uint)
997     {
998         UserTx storage userTx = self.mapHashXUserTxs[xHash];
999         if (userTx.baseTx.status != TxStatus.None) {
1000             return getLeftTime(userTx.baseTx.beginLockedTime.add(userTx.baseTx.lockedTime));
1001         }
1002         SmgTx storage smgTx = self.mapHashXSmgTxs[xHash];
1003         if (smgTx.baseTx.status != TxStatus.None) {
1004             return getLeftTime(smgTx.baseTx.beginLockedTime.add(smgTx.baseTx.lockedTime));
1005         }
1006         DebtTx storage debtTx = self.mapHashXDebtTxs[xHash];
1007         if (debtTx.baseTx.status != TxStatus.None) {
1008             return getLeftTime(debtTx.baseTx.beginLockedTime.add(debtTx.baseTx.lockedTime));
1009         }
1010         require(false, 'invalid xHash');
1011     }
1012 }
1013 
1014 // File: contracts/crossApproach/lib/RapidityTxLib.sol
1015 
1016 /*
1017 
1018   Copyright 2019 Wanchain Foundation.
1019 
1020   Licensed under the Apache License, Version 2.0 (the "License");
1021   you may not use this file except in compliance with the License.
1022   You may obtain a copy of the License at
1023 
1024   http://www.apache.org/licenses/LICENSE-2.0
1025 
1026   Unless required by applicable law or agreed to in writing, software
1027   distributed under the License is distributed on an "AS IS" BASIS,
1028   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1029   See the License for the specific language governing permissions and
1030   limitations under the License.
1031 
1032 */
1033 
1034 //                            _           _           _
1035 //  __      ____ _ _ __   ___| |__   __ _(_)_ __   __| | _____   __
1036 //  \ \ /\ / / _` | '_ \ / __| '_ \ / _` | | '_ \@/ _` |/ _ \ \ / /
1037 //   \ V  V / (_| | | | | (__| | | | (_| | | | | | (_| |  __/\ V /
1038 //    \_/\_/ \__,_|_| |_|\___|_| |_|\__,_|_|_| |_|\__,_|\___| \_/
1039 //
1040 //
1041 
1042 pragma solidity ^0.4.26;
1043 
1044 library RapidityTxLib {
1045 
1046     /**
1047      *
1048      * ENUMS
1049      *
1050      */
1051 
1052     /// @notice tx info status
1053     /// @notice uninitialized,Redeemed
1054     enum TxStatus {None, Redeemed}
1055 
1056     /**
1057      *
1058      * STRUCTURES
1059      *
1060      */
1061     struct Data {
1062         /// @notice mapping of uniqueID to TxStatus -- uniqueID->TxStatus
1063         mapping(bytes32 => TxStatus) mapTxStatus;
1064 
1065     }
1066 
1067     /**
1068      *
1069      * MANIPULATIONS
1070      *
1071      */
1072 
1073     /// @notice                     add user transaction info
1074     /// @param  uniqueID            Rapidity random number
1075     function addRapidityTx(Data storage self, bytes32 uniqueID)
1076         internal
1077     {
1078         TxStatus status = self.mapTxStatus[uniqueID];
1079         require(status == TxStatus.None, "Rapidity tx exists");
1080         self.mapTxStatus[uniqueID] = TxStatus.Redeemed;
1081     }
1082 }
1083 
1084 // File: contracts/crossApproach/lib/CrossTypes.sol
1085 
1086 /*
1087 
1088   Copyright 2019 Wanchain Foundation.
1089 
1090   Licensed under the Apache License, Version 2.0 (the "License");
1091   you may not use this file except in compliance with the License.
1092   You may obtain a copy of the License at
1093 
1094   http://www.apache.org/licenses/LICENSE-2.0
1095 
1096   Unless required by applicable law or agreed to in writing, software
1097   distributed under the License is distributed on an "AS IS" BASIS,
1098   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1099   See the License for the specific language governing permissions and
1100   limitations under the License.
1101 
1102 */
1103 
1104 //                            _           _           _
1105 //  __      ____ _ _ __   ___| |__   __ _(_)_ __   __| | _____   __
1106 //  \ \ /\ / / _` | '_ \ / __| '_ \ / _` | | '_ \@/ _` |/ _ \ \ / /
1107 //   \ V  V / (_| | | | | (__| | | | (_| | | | | | (_| |  __/\ V /
1108 //    \_/\_/ \__,_|_| |_|\___|_| |_|\__,_|_|_| |_|\__,_|\___| \_/
1109 //
1110 //
1111 
1112 pragma solidity ^0.4.26;
1113 
1114 
1115 
1116 
1117 
1118 
1119 
1120 
1121 library CrossTypes {
1122     using SafeMath for uint;
1123 
1124     /**
1125      *
1126      * STRUCTURES
1127      *
1128      */
1129 
1130     struct Data {
1131 
1132         /// map of the htlc transaction info
1133         HTLCTxLib.Data htlcTxData;
1134 
1135         /// map of the rapidity transaction info
1136         RapidityTxLib.Data rapidityTxData;
1137 
1138         /// quota data of storeman group
1139         IQuota quota;
1140 
1141         /// token manager instance interface
1142         ITokenManager tokenManager;
1143 
1144         /// storemanGroup admin instance interface
1145         IStoremanGroup smgAdminProxy;
1146 
1147         /// storemanGroup fee admin instance address
1148         address smgFeeProxy;
1149 
1150         ISignatureVerifier sigVerifier;
1151 
1152         /// @notice transaction fee, smgID => fee
1153         mapping(bytes32 => uint) mapStoremanFee;
1154 
1155         /// @notice transaction fee, origChainID => shadowChainID => fee
1156         mapping(uint => mapping(uint =>uint)) mapLockFee;
1157 
1158         /// @notice transaction fee, origChainID => shadowChainID => fee
1159         mapping(uint => mapping(uint =>uint)) mapRevokeFee;
1160 
1161     }
1162 
1163     /**
1164      *
1165      * MANIPULATIONS
1166      *
1167      */
1168 
1169     // /// @notice       convert bytes32 to address
1170     // /// @param b      bytes32
1171     // function bytes32ToAddress(bytes32 b) internal pure returns (address) {
1172     //     return address(uint160(bytes20(b))); // high
1173     //     // return address(uint160(uint256(b))); // low
1174     // }
1175 
1176     /// @notice       convert bytes to address
1177     /// @param b      bytes
1178     function bytesToAddress(bytes b) internal pure returns (address addr) {
1179         assembly {
1180             addr := mload(add(b,20))
1181         }
1182     }
1183 
1184     function transfer(address tokenScAddr, address to, uint value)
1185         internal
1186         returns(bool)
1187     {
1188         uint beforeBalance;
1189         uint afterBalance;
1190         beforeBalance = IRC20Protocol(tokenScAddr).balanceOf(to);
1191         // IRC20Protocol(tokenScAddr).transfer(to, value);
1192         tokenScAddr.call(bytes4(keccak256("transfer(address,uint256)")), to, value);
1193         afterBalance = IRC20Protocol(tokenScAddr).balanceOf(to);
1194         return afterBalance == beforeBalance.add(value);
1195     }
1196 
1197     function transferFrom(address tokenScAddr, address from, address to, uint value)
1198         internal
1199         returns(bool)
1200     {
1201         uint beforeBalance;
1202         uint afterBalance;
1203         beforeBalance = IRC20Protocol(tokenScAddr).balanceOf(to);
1204         // IRC20Protocol(tokenScAddr).transferFrom(from, to, value);
1205         tokenScAddr.call(bytes4(keccak256("transferFrom(address,address,uint256)")), from, to, value);
1206         afterBalance = IRC20Protocol(tokenScAddr).balanceOf(to);
1207         return afterBalance == beforeBalance.add(value);
1208     }
1209 }
1210 
1211 // File: contracts/crossApproach/CrossStorage.sol
1212 
1213 /*
1214 
1215   Copyright 2019 Wanchain Foundation.
1216 
1217   Licensed under the Apache License, Version 2.0 (the "License");
1218   you may not use this file except in compliance with the License.
1219   You may obtain a copy of the License at
1220 
1221   http://www.apache.org/licenses/LICENSE-2.0
1222 
1223   Unless required by applicable law or agreed to in writing, software
1224   distributed under the License is distributed on an "AS IS" BASIS,
1225   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1226   See the License for the specific language governing permissions and
1227   limitations under the License.
1228 
1229 */
1230 
1231 //                            _           _           _
1232 //  __      ____ _ _ __   ___| |__   __ _(_)_ __   __| | _____   __
1233 //  \ \ /\ / / _` | '_ \ / __| '_ \ / _` | | '_ \@/ _` |/ _ \ \ / /
1234 //   \ V  V / (_| | | | | (__| | | | (_| | | | | | (_| |  __/\ V /
1235 //    \_/\_/ \__,_|_| |_|\___|_| |_|\__,_|_|_| |_|\__,_|\___| \_/
1236 //
1237 //
1238 
1239 pragma solidity ^0.4.26;
1240 
1241 
1242 
1243 
1244 
1245 contract CrossStorage is BasicStorage {
1246     using HTLCTxLib for HTLCTxLib.Data;
1247     using RapidityTxLib for RapidityTxLib.Data;
1248 
1249     /************************************************************
1250      **
1251      ** VARIABLES
1252      **
1253      ************************************************************/
1254 
1255     CrossTypes.Data internal storageData;
1256 
1257     /// @notice locked time(in seconds)
1258     uint public lockedTime = uint(3600*36);
1259 
1260     /// @notice Since storeman group admin receiver address may be changed, system should make sure the new address
1261     /// @notice can be used, and the old address can not be used. The solution is add timestamp.
1262     /// @notice unit: second
1263     uint public smgFeeReceiverTimeout = uint(10*60);
1264 
1265     enum GroupStatus { none, initial, curveSeted, failed, selected, ready, unregistered, dismissed }
1266 
1267 }
1268 
1269 // File: contracts/crossApproach/CrossProxy.sol
1270 
1271 /*
1272 
1273   Copyright 2019 Wanchain Foundation.
1274 
1275   Licensed under the Apache License, Version 2.0 (the "License");
1276   you may not use this file except in compliance with the License.
1277   You may obtain a copy of the License at
1278 
1279   http://www.apache.org/licenses/LICENSE-2.0
1280 
1281   Unless required by applicable law or agreed to in writing, software
1282   distributed under the License is distributed on an "AS IS" BASIS,
1283   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1284   See the License for the specific language governing permissions and
1285   limitations under the License.
1286 
1287 */
1288 
1289 //                            _           _           _
1290 //  __      ____ _ _ __   ___| |__   __ _(_)_ __   __| | _____   __
1291 //  \ \ /\ / / _` | '_ \ / __| '_ \ / _` | | '_ \@/ _` |/ _ \ \ / /
1292 //   \ V  V / (_| | | | | (__| | | | (_| | | | | | (_| |  __/\ V /
1293 //    \_/\_/ \__,_|_| |_|\___|_| |_|\__,_|_|_| |_|\__,_|\___| \_/
1294 //
1295 //
1296 
1297 pragma solidity ^0.4.26;
1298 
1299 /**
1300  * Math operations with safety checks
1301  */
1302 
1303 
1304 
1305 
1306 
1307 
1308 contract CrossProxy is CrossStorage, ReentrancyGuard, Halt, Proxy {
1309 
1310     ///@dev                   update the address of CrossDelegate contract
1311     ///@param impl            the address of the new CrossDelegate contract
1312     function upgradeTo(address impl) public onlyOwner {
1313         require(impl != address(0), "Cannot upgrade to invalid address");
1314         require(impl != _implementation, "Cannot upgrade to the same implementation");
1315         _implementation = impl;
1316         emit Upgraded(impl);
1317     }
1318 }