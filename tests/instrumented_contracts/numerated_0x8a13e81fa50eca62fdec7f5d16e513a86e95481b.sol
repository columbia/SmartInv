1 /*
2 
3   Copyright 2018 ZeroEx Intl.
4 
5   Licensed under the Apache License, Version 2.0 (the "License");
6   you may not use this file except in compliance with the License.
7   You may obtain a copy of the License at
8 
9     http://www.apache.org/licenses/LICENSE-2.0
10 
11   Unless required by applicable law or agreed to in writing, software
12   distributed under the License is distributed on an "AS IS" BASIS,
13   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14   See the License for the specific language governing permissions and
15   limitations under the License.
16 
17 */
18 
19 pragma solidity 0.4.24;
20 
21 
22 contract IOwnable {
23 
24     function transferOwnership(address newOwner)
25         public;
26 }
27 
28 contract Ownable is
29     IOwnable
30 {
31     address public owner;
32 
33     constructor ()
34         public
35     {
36         owner = msg.sender;
37     }
38 
39     modifier onlyOwner() {
40         require(
41             msg.sender == owner,
42             "ONLY_CONTRACT_OWNER"
43         );
44         _;
45     }
46 
47     function transferOwnership(address newOwner)
48         public
49         onlyOwner
50     {
51         if (newOwner != address(0)) {
52             owner = newOwner;
53         }
54     }
55 }
56 
57 contract IAssetProxyDispatcher {
58 
59     /// @dev Registers an asset proxy to its asset proxy id.
60     ///      Once an asset proxy is registered, it cannot be unregistered.
61     /// @param assetProxy Address of new asset proxy to register.
62     function registerAssetProxy(address assetProxy)
63         external;
64 
65     /// @dev Gets an asset proxy.
66     /// @param assetProxyId Id of the asset proxy.
67     /// @return The asset proxy registered to assetProxyId. Returns 0x0 if no proxy is registered.
68     function getAssetProxy(bytes4 assetProxyId)
69         external
70         view
71         returns (address);
72 }
73 
74 contract MAssetProxyDispatcher is
75     IAssetProxyDispatcher
76 {
77     // Logs registration of new asset proxy
78     event AssetProxyRegistered(
79         bytes4 id,              // Id of new registered AssetProxy.
80         address assetProxy      // Address of new registered AssetProxy.
81     );
82 
83     /// @dev Forwards arguments to assetProxy and calls `transferFrom`. Either succeeds or throws.
84     /// @param assetData Byte array encoded for the asset.
85     /// @param from Address to transfer token from.
86     /// @param to Address to transfer token to.
87     /// @param amount Amount of token to transfer.
88     function dispatchTransferFrom(
89         bytes memory assetData,
90         address from,
91         address to,
92         uint256 amount
93     )
94         internal;
95 }
96 
97 contract MixinAssetProxyDispatcher is
98     Ownable,
99     MAssetProxyDispatcher
100 {
101     // Mapping from Asset Proxy Id's to their respective Asset Proxy
102     mapping (bytes4 => IAssetProxy) public assetProxies;
103 
104     /// @dev Registers an asset proxy to its asset proxy id.
105     ///      Once an asset proxy is registered, it cannot be unregistered.
106     /// @param assetProxy Address of new asset proxy to register.
107     function registerAssetProxy(address assetProxy)
108         external
109         onlyOwner
110     {
111         IAssetProxy assetProxyContract = IAssetProxy(assetProxy);
112 
113         // Ensure that no asset proxy exists with current id.
114         bytes4 assetProxyId = assetProxyContract.getProxyId();
115         address currentAssetProxy = assetProxies[assetProxyId];
116         require(
117             currentAssetProxy == address(0),
118             "ASSET_PROXY_ALREADY_EXISTS"
119         );
120 
121         // Add asset proxy and log registration.
122         assetProxies[assetProxyId] = assetProxyContract;
123         emit AssetProxyRegistered(
124             assetProxyId,
125             assetProxy
126         );
127     }
128 
129     /// @dev Gets an asset proxy.
130     /// @param assetProxyId Id of the asset proxy.
131     /// @return The asset proxy registered to assetProxyId. Returns 0x0 if no proxy is registered.
132     function getAssetProxy(bytes4 assetProxyId)
133         external
134         view
135         returns (address)
136     {
137         return assetProxies[assetProxyId];
138     }
139 
140     /// @dev Forwards arguments to assetProxy and calls `transferFrom`. Either succeeds or throws.
141     /// @param assetData Byte array encoded for the asset.
142     /// @param from Address to transfer token from.
143     /// @param to Address to transfer token to.
144     /// @param amount Amount of token to transfer.
145     function dispatchTransferFrom(
146         bytes memory assetData,
147         address from,
148         address to,
149         uint256 amount
150     )
151         internal
152     {
153         // Do nothing if no amount should be transferred.
154         if (amount > 0 && from != to) {
155             // Ensure assetData length is valid
156             require(
157                 assetData.length > 3,
158                 "LENGTH_GREATER_THAN_3_REQUIRED"
159             );
160             
161             // Lookup assetProxy. We do not use `LibBytes.readBytes4` for gas efficiency reasons.
162             bytes4 assetProxyId;
163             assembly {
164                 assetProxyId := and(mload(
165                     add(assetData, 32)),
166                     0xFFFFFFFF00000000000000000000000000000000000000000000000000000000
167                 )
168             }
169             address assetProxy = assetProxies[assetProxyId];
170 
171             // Ensure that assetProxy exists
172             require(
173                 assetProxy != address(0),
174                 "ASSET_PROXY_DOES_NOT_EXIST"
175             );
176             
177             // We construct calldata for the `assetProxy.transferFrom` ABI.
178             // The layout of this calldata is in the table below.
179             // 
180             // | Area     | Offset | Length  | Contents                                    |
181             // | -------- |--------|---------|-------------------------------------------- |
182             // | Header   | 0      | 4       | function selector                           |
183             // | Params   |        | 4 * 32  | function parameters:                        |
184             // |          | 4      |         |   1. offset to assetData (*)                |
185             // |          | 36     |         |   2. from                                   |
186             // |          | 68     |         |   3. to                                     |
187             // |          | 100    |         |   4. amount                                 |
188             // | Data     |        |         | assetData:                                  |
189             // |          | 132    | 32      | assetData Length                            |
190             // |          | 164    | **      | assetData Contents                          |
191 
192             assembly {
193                 /////// Setup State ///////
194                 // `cdStart` is the start of the calldata for `assetProxy.transferFrom` (equal to free memory ptr).
195                 let cdStart := mload(64)
196                 // `dataAreaLength` is the total number of words needed to store `assetData`
197                 //  As-per the ABI spec, this value is padded up to the nearest multiple of 32,
198                 //  and includes 32-bytes for length.
199                 let dataAreaLength := and(add(mload(assetData), 63), 0xFFFFFFFFFFFE0)
200                 // `cdEnd` is the end of the calldata for `assetProxy.transferFrom`.
201                 let cdEnd := add(cdStart, add(132, dataAreaLength))
202 
203                 
204                 /////// Setup Header Area ///////
205                 // This area holds the 4-byte `transferFromSelector`.
206                 // bytes4(keccak256("transferFrom(bytes,address,address,uint256)")) = 0xa85e59e4
207                 mstore(cdStart, 0xa85e59e400000000000000000000000000000000000000000000000000000000)
208                 
209                 /////// Setup Params Area ///////
210                 // Each parameter is padded to 32-bytes. The entire Params Area is 128 bytes.
211                 // Notes:
212                 //   1. The offset to `assetData` is the length of the Params Area (128 bytes).
213                 //   2. A 20-byte mask is applied to addresses to zero-out the unused bytes.
214                 mstore(add(cdStart, 4), 128)
215                 mstore(add(cdStart, 36), and(from, 0xffffffffffffffffffffffffffffffffffffffff))
216                 mstore(add(cdStart, 68), and(to, 0xffffffffffffffffffffffffffffffffffffffff))
217                 mstore(add(cdStart, 100), amount)
218                 
219                 /////// Setup Data Area ///////
220                 // This area holds `assetData`.
221                 let dataArea := add(cdStart, 132)
222                 // solhint-disable-next-line no-empty-blocks
223                 for {} lt(dataArea, cdEnd) {} {
224                     mstore(dataArea, mload(assetData))
225                     dataArea := add(dataArea, 32)
226                     assetData := add(assetData, 32)
227                 }
228 
229                 /////// Call `assetProxy.transferFrom` using the constructed calldata ///////
230                 let success := call(
231                     gas,                    // forward all gas
232                     assetProxy,             // call address of asset proxy
233                     0,                      // don't send any ETH
234                     cdStart,                // pointer to start of input
235                     sub(cdEnd, cdStart),    // length of input  
236                     cdStart,                // write output over input
237                     512                     // reserve 512 bytes for output
238                 )
239                 if iszero(success) {
240                     revert(cdStart, returndatasize())
241                 }
242             }
243         }
244     }
245 }
246 
247 contract IAuthorizable is
248     IOwnable
249 {
250     /// @dev Authorizes an address.
251     /// @param target Address to authorize.
252     function addAuthorizedAddress(address target)
253         external;
254 
255     /// @dev Removes authorizion of an address.
256     /// @param target Address to remove authorization from.
257     function removeAuthorizedAddress(address target)
258         external;
259 
260     /// @dev Removes authorizion of an address.
261     /// @param target Address to remove authorization from.
262     /// @param index Index of target in authorities array.
263     function removeAuthorizedAddressAtIndex(
264         address target,
265         uint256 index
266     )
267         external;
268     
269     /// @dev Gets all authorized addresses.
270     /// @return Array of authorized addresses.
271     function getAuthorizedAddresses()
272         external
273         view
274         returns (address[] memory);
275 }
276 
277 contract IAssetProxy is
278     IAuthorizable
279 {
280     /// @dev Transfers assets. Either succeeds or throws.
281     /// @param assetData Byte array encoded for the respective asset proxy.
282     /// @param from Address to transfer asset from.
283     /// @param to Address to transfer asset to.
284     /// @param amount Amount of asset to transfer.
285     function transferFrom(
286         bytes assetData,
287         address from,
288         address to,
289         uint256 amount
290     )
291         external;
292     
293     /// @dev Gets the proxy id associated with the proxy address.
294     /// @return Proxy id.
295     function getProxyId()
296         external
297         pure
298         returns (bytes4);
299 }
300 
301 contract MAuthorizable is
302     IAuthorizable
303 {
304     // Event logged when a new address is authorized.
305     event AuthorizedAddressAdded(
306         address indexed target,
307         address indexed caller
308     );
309 
310     // Event logged when a currently authorized address is unauthorized.
311     event AuthorizedAddressRemoved(
312         address indexed target,
313         address indexed caller
314     );
315 
316     /// @dev Only authorized addresses can invoke functions with this modifier.
317     modifier onlyAuthorized { revert(); _; }
318 }
319 
320 contract MixinAuthorizable is
321     Ownable,
322     MAuthorizable
323 {
324     /// @dev Only authorized addresses can invoke functions with this modifier.
325     modifier onlyAuthorized {
326         require(
327             authorized[msg.sender],
328             "SENDER_NOT_AUTHORIZED"
329         );
330         _;
331     }
332 
333     mapping (address => bool) public authorized;
334     address[] public authorities;
335 
336     /// @dev Authorizes an address.
337     /// @param target Address to authorize.
338     function addAuthorizedAddress(address target)
339         external
340         onlyOwner
341     {
342         require(
343             !authorized[target],
344             "TARGET_ALREADY_AUTHORIZED"
345         );
346 
347         authorized[target] = true;
348         authorities.push(target);
349         emit AuthorizedAddressAdded(target, msg.sender);
350     }
351 
352     /// @dev Removes authorizion of an address.
353     /// @param target Address to remove authorization from.
354     function removeAuthorizedAddress(address target)
355         external
356         onlyOwner
357     {
358         require(
359             authorized[target],
360             "TARGET_NOT_AUTHORIZED"
361         );
362 
363         delete authorized[target];
364         for (uint256 i = 0; i < authorities.length; i++) {
365             if (authorities[i] == target) {
366                 authorities[i] = authorities[authorities.length - 1];
367                 authorities.length -= 1;
368                 break;
369             }
370         }
371         emit AuthorizedAddressRemoved(target, msg.sender);
372     }
373 
374     /// @dev Removes authorizion of an address.
375     /// @param target Address to remove authorization from.
376     /// @param index Index of target in authorities array.
377     function removeAuthorizedAddressAtIndex(
378         address target,
379         uint256 index
380     )
381         external
382         onlyOwner
383     {
384         require(
385             authorized[target],
386             "TARGET_NOT_AUTHORIZED"
387         );
388         require(
389             index < authorities.length,
390             "INDEX_OUT_OF_BOUNDS"
391         );
392         require(
393             authorities[index] == target,
394             "AUTHORIZED_ADDRESS_MISMATCH"
395         );
396 
397         delete authorized[target];
398         authorities[index] = authorities[authorities.length - 1];
399         authorities.length -= 1;
400         emit AuthorizedAddressRemoved(target, msg.sender);
401     }
402 
403     /// @dev Gets all authorized addresses.
404     /// @return Array of authorized addresses.
405     function getAuthorizedAddresses()
406         external
407         view
408         returns (address[] memory)
409     {
410         return authorities;
411     }
412 }
413 
414 contract MultiAssetProxy is
415     MixinAssetProxyDispatcher,
416     MixinAuthorizable
417 {
418     // Id of this proxy.
419     bytes4 constant internal PROXY_ID = bytes4(keccak256("MultiAsset(uint256[],bytes[])"));
420 
421     // solhint-disable-next-line payable-fallback
422     function ()
423         external
424     {
425         // NOTE: The below assembly assumes that clients do some input validation and that the input is properly encoded according to the AbiV2 specification.
426         // It is technically possible for inputs with very large lengths and offsets to cause overflows. However, this would make the calldata prohibitively
427         // expensive and we therefore do not check for overflows in these scenarios.
428         assembly {
429             // The first 4 bytes of calldata holds the function selector
430             let selector := and(calldataload(0), 0xffffffff00000000000000000000000000000000000000000000000000000000)
431 
432             // `transferFrom` will be called with the following parameters:
433             // assetData Encoded byte array.
434             // from Address to transfer asset from.
435             // to Address to transfer asset to.
436             // amount Amount of asset to transfer.
437             // bytes4(keccak256("transferFrom(bytes,address,address,uint256)")) = 0xa85e59e4
438             if eq(selector, 0xa85e59e400000000000000000000000000000000000000000000000000000000) {
439 
440                 // To lookup a value in a mapping, we load from the storage location keccak256(k, p),
441                 // where k is the key left padded to 32 bytes and p is the storage slot
442                 mstore(0, caller)
443                 mstore(32, authorized_slot)
444 
445                 // Revert if authorized[msg.sender] == false
446                 if iszero(sload(keccak256(0, 64))) {
447                     // Revert with `Error("SENDER_NOT_AUTHORIZED")`
448                     mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
449                     mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
450                     mstore(64, 0x0000001553454e4445525f4e4f545f415554484f52495a454400000000000000)
451                     mstore(96, 0)
452                     revert(0, 100)
453                 }
454 
455                 // `transferFrom`.
456                 // The function is marked `external`, so no abi decoding is done for
457                 // us. Instead, we expect the `calldata` memory to contain the
458                 // following:
459                 //
460                 // | Area     | Offset | Length  | Contents                            |
461                 // |----------|--------|---------|-------------------------------------|
462                 // | Header   | 0      | 4       | function selector                   |
463                 // | Params   |        | 4 * 32  | function parameters:                |
464                 // |          | 4      |         |   1. offset to assetData (*)        |
465                 // |          | 36     |         |   2. from                           |
466                 // |          | 68     |         |   3. to                             |
467                 // |          | 100    |         |   4. amount                         |
468                 // | Data     |        |         | assetData:                          |
469                 // |          | 132    | 32      | assetData Length                    |
470                 // |          | 164    | **      | assetData Contents                  |
471                 //
472                 // (*): offset is computed from start of function parameters, so offset
473                 //      by an additional 4 bytes in the calldata.
474                 //
475                 // (**): see table below to compute length of assetData Contents
476                 //
477                 // WARNING: The ABIv2 specification allows additional padding between
478                 //          the Params and Data section. This will result in a larger
479                 //          offset to assetData.
480 
481                 // Load offset to `assetData`
482                 let assetDataOffset := calldataload(4)
483 
484                 // Asset data itself is encoded as follows:
485                 //
486                 // | Area     | Offset      | Length  | Contents                            |
487                 // |----------|-------------|---------|-------------------------------------|
488                 // | Header   | 0           | 4       | assetProxyId                        |
489                 // | Params   |             | 2 * 32  | function parameters:                |
490                 // |          | 4           |         |   1. offset to amounts (*)          |
491                 // |          | 36          |         |   2. offset to nestedAssetData (*)  |
492                 // | Data     |             |         | amounts:                            |
493                 // |          | 68          | 32      | amounts Length                      |
494                 // |          | 100         | a       | amounts Contents                    | 
495                 // |          |             |         | nestedAssetData:                    |
496                 // |          | 100 + a     | 32      | nestedAssetData Length              |
497                 // |          | 132 + a     | b       | nestedAssetData Contents (offsets)  |
498                 // |          | 132 + a + b |         | nestedAssetData[0, ..., len]        |
499 
500                 // In order to find the offset to `amounts`, we must add:
501                 // 4 (function selector)
502                 // + assetDataOffset
503                 // + 32 (assetData len)
504                 // + 4 (assetProxyId)
505                 let amountsOffset := calldataload(add(assetDataOffset, 40))
506 
507                 // In order to find the offset to `nestedAssetData`, we must add:
508                 // 4 (function selector)
509                 // + assetDataOffset
510                 // + 32 (assetData len)
511                 // + 4 (assetProxyId)
512                 // + 32 (amounts offset)
513                 let nestedAssetDataOffset := calldataload(add(assetDataOffset, 72))
514 
515                 // In order to find the start of the `amounts` contents, we must add: 
516                 // 4 (function selector) 
517                 // + assetDataOffset 
518                 // + 32 (assetData len)
519                 // + 4 (assetProxyId)
520                 // + amountsOffset
521                 // + 32 (amounts len)
522                 let amountsContentsStart := add(assetDataOffset, add(amountsOffset, 72))
523 
524                 // Load number of elements in `amounts`
525                 let amountsLen := calldataload(sub(amountsContentsStart, 32))
526 
527                 // In order to find the start of the `nestedAssetData` contents, we must add: 
528                 // 4 (function selector) 
529                 // + assetDataOffset 
530                 // + 32 (assetData len)
531                 // + 4 (assetProxyId)
532                 // + nestedAssetDataOffset
533                 // + 32 (nestedAssetData len)
534                 let nestedAssetDataContentsStart := add(assetDataOffset, add(nestedAssetDataOffset, 72))
535 
536                 // Load number of elements in `nestedAssetData`
537                 let nestedAssetDataLen := calldataload(sub(nestedAssetDataContentsStart, 32))
538 
539                 // Revert if number of elements in `amounts` differs from number of elements in `nestedAssetData`
540                 if sub(amountsLen, nestedAssetDataLen) {
541                     // Revert with `Error("LENGTH_MISMATCH")`
542                     mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
543                     mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
544                     mstore(64, 0x0000000f4c454e4754485f4d49534d4154434800000000000000000000000000)
545                     mstore(96, 0)
546                     revert(0, 100)
547                 }
548 
549                 // Copy `transferFrom` selector, offset to `assetData`, `from`, and `to` from calldata to memory
550                 calldatacopy(
551                     0,   // memory can safely be overwritten from beginning
552                     0,   // start of calldata
553                     100  // length of selector (4) and 3 params (32 * 3)
554                 )
555 
556                 // Overwrite existing offset to `assetData` with our own
557                 mstore(4, 128)
558                 
559                 // Load `amount`
560                 let amount := calldataload(100)
561         
562                 // Calculate number of bytes in `amounts` contents
563                 let amountsByteLen := mul(amountsLen, 32)
564 
565                 // Initialize `assetProxyId` and `assetProxy` to 0
566                 let assetProxyId := 0
567                 let assetProxy := 0
568 
569                 // Loop through `amounts` and `nestedAssetData`, calling `transferFrom` for each respective element
570                 for {let i := 0} lt(i, amountsByteLen) {i := add(i, 32)} {
571 
572                     // Calculate the total amount
573                     let amountsElement := calldataload(add(amountsContentsStart, i))
574                     let totalAmount := mul(amountsElement, amount)
575 
576                     // Revert if `amount` != 0 and multiplication resulted in an overflow 
577                     if iszero(or(
578                         iszero(amount),
579                         eq(div(totalAmount, amount), amountsElement)
580                     )) {
581                         // Revert with `Error("UINT256_OVERFLOW")`
582                         mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
583                         mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
584                         mstore(64, 0x0000001055494e543235365f4f564552464c4f57000000000000000000000000)
585                         mstore(96, 0)
586                         revert(0, 100)
587                     }
588 
589                     // Write `totalAmount` to memory
590                     mstore(100, totalAmount)
591 
592                     // Load offset to `nestedAssetData[i]`
593                     let nestedAssetDataElementOffset := calldataload(add(nestedAssetDataContentsStart, i))
594 
595                     // In order to find the start of the `nestedAssetData[i]` contents, we must add:
596                     // 4 (function selector) 
597                     // + assetDataOffset 
598                     // + 32 (assetData len)
599                     // + 4 (assetProxyId)
600                     // + nestedAssetDataOffset
601                     // + 32 (nestedAssetData len)
602                     // + nestedAssetDataElementOffset
603                     // + 32 (nestedAssetDataElement len)
604                     let nestedAssetDataElementContentsStart := add(assetDataOffset, add(nestedAssetDataOffset, add(nestedAssetDataElementOffset, 104)))
605 
606                     // Load length of `nestedAssetData[i]`
607                     let nestedAssetDataElementLenStart := sub(nestedAssetDataElementContentsStart, 32)
608                     let nestedAssetDataElementLen := calldataload(nestedAssetDataElementLenStart)
609 
610                     // Revert if the `nestedAssetData` does not contain a 4 byte `assetProxyId`
611                     if lt(nestedAssetDataElementLen, 4) {
612                         // Revert with `Error("LENGTH_GREATER_THAN_3_REQUIRED")`
613                         mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
614                         mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
615                         mstore(64, 0x0000001e4c454e4754485f475245415445525f5448414e5f335f524551554952)
616                         mstore(96, 0x4544000000000000000000000000000000000000000000000000000000000000)
617                         revert(0, 100)
618                     }
619 
620                     // Load AssetProxy id
621                     let currentAssetProxyId := and(
622                         calldataload(nestedAssetDataElementContentsStart),
623                         0xffffffff00000000000000000000000000000000000000000000000000000000
624                     )
625 
626                     // Only load `assetProxy` if `currentAssetProxyId` does not equal `assetProxyId`
627                     // We do not need to check if `currentAssetProxyId` is 0 since `assetProxy` is also initialized to 0
628                     if sub(currentAssetProxyId, assetProxyId) {
629                         // Update `assetProxyId`
630                         assetProxyId := currentAssetProxyId
631                         // To lookup a value in a mapping, we load from the storage location keccak256(k, p),
632                         // where k is the key left padded to 32 bytes and p is the storage slot
633                         mstore(132, assetProxyId)
634                         mstore(164, assetProxies_slot)
635                         assetProxy := sload(keccak256(132, 64))
636                     }
637                     
638                     // Revert if AssetProxy with given id does not exist
639                     if iszero(assetProxy) {
640                         // Revert with `Error("ASSET_PROXY_DOES_NOT_EXIST")`
641                         mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
642                         mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
643                         mstore(64, 0x0000001a41535345545f50524f58595f444f45535f4e4f545f45584953540000)
644                         mstore(96, 0)
645                         revert(0, 100)
646                     }
647     
648                     // Copy `nestedAssetData[i]` from calldata to memory
649                     calldatacopy(
650                         132,                                // memory slot after `amounts[i]`
651                         nestedAssetDataElementLenStart,     // location of `nestedAssetData[i]` in calldata
652                         add(nestedAssetDataElementLen, 32)  // `nestedAssetData[i].length` plus 32 byte length
653                     )
654 
655                     // call `assetProxy.transferFrom`
656                     let success := call(
657                         gas,                                    // forward all gas
658                         assetProxy,                             // call address of asset proxy
659                         0,                                      // don't send any ETH
660                         0,                                      // pointer to start of input
661                         add(164, nestedAssetDataElementLen),    // length of input  
662                         0,                                      // write output over memory that won't be reused
663                         0                                       // don't copy output to memory
664                     )
665 
666                     // Revert with reason given by AssetProxy if `transferFrom` call failed
667                     if iszero(success) {
668                         returndatacopy(
669                             0,                // copy to memory at 0
670                             0,                // copy from return data at 0
671                             returndatasize()  // copy all return data
672                         )
673                         revert(0, returndatasize())
674                     }
675                 }
676 
677                 // Return if no `transferFrom` calls reverted
678                 return(0, 0)
679             }
680 
681             // Revert if undefined function is called
682             revert(0, 0)
683         }
684     }
685 
686     /// @dev Gets the proxy id associated with the proxy address.
687     /// @return Proxy id.
688     function getProxyId()
689         external
690         pure
691         returns (bytes4)
692     {
693         return PROXY_ID;
694     }
695 }