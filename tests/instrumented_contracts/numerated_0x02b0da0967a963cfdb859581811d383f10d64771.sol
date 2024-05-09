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
21 contract IOwnable {
22 
23     function transferOwnership(address newOwner)
24         public;
25 }
26 
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
57 
58 contract IAuthorizable is
59     IOwnable
60 {
61     /// @dev Authorizes an address.
62     /// @param target Address to authorize.
63     function addAuthorizedAddress(address target)
64         external;
65 
66     /// @dev Removes authorizion of an address.
67     /// @param target Address to remove authorization from.
68     function removeAuthorizedAddress(address target)
69         external;
70 
71     /// @dev Removes authorizion of an address.
72     /// @param target Address to remove authorization from.
73     /// @param index Index of target in authorities array.
74     function removeAuthorizedAddressAtIndex(
75         address target,
76         uint256 index
77     )
78         external;
79     
80     /// @dev Gets all authorized addresses.
81     /// @return Array of authorized addresses.
82     function getAuthorizedAddresses()
83         external
84         view
85         returns (address[] memory);
86 }
87 
88 
89 
90 contract MAuthorizable is
91     IAuthorizable
92 {
93     // Event logged when a new address is authorized.
94     event AuthorizedAddressAdded(
95         address indexed target,
96         address indexed caller
97     );
98 
99     // Event logged when a currently authorized address is unauthorized.
100     event AuthorizedAddressRemoved(
101         address indexed target,
102         address indexed caller
103     );
104 
105     /// @dev Only authorized addresses can invoke functions with this modifier.
106     modifier onlyAuthorized { revert(); _; }
107 }
108 
109 
110 contract MixinAuthorizable is
111     Ownable,
112     MAuthorizable
113 {
114     /// @dev Only authorized addresses can invoke functions with this modifier.
115     modifier onlyAuthorized {
116         require(
117             authorized[msg.sender],
118             "SENDER_NOT_AUTHORIZED"
119         );
120         _;
121     }
122 
123     mapping (address => bool) public authorized;
124     address[] public authorities;
125 
126     /// @dev Authorizes an address.
127     /// @param target Address to authorize.
128     function addAuthorizedAddress(address target)
129         external
130         onlyOwner
131     {
132         require(
133             !authorized[target],
134             "TARGET_ALREADY_AUTHORIZED"
135         );
136 
137         authorized[target] = true;
138         authorities.push(target);
139         emit AuthorizedAddressAdded(target, msg.sender);
140     }
141 
142     /// @dev Removes authorizion of an address.
143     /// @param target Address to remove authorization from.
144     function removeAuthorizedAddress(address target)
145         external
146         onlyOwner
147     {
148         require(
149             authorized[target],
150             "TARGET_NOT_AUTHORIZED"
151         );
152 
153         delete authorized[target];
154         for (uint256 i = 0; i < authorities.length; i++) {
155             if (authorities[i] == target) {
156                 authorities[i] = authorities[authorities.length - 1];
157                 authorities.length -= 1;
158                 break;
159             }
160         }
161         emit AuthorizedAddressRemoved(target, msg.sender);
162     }
163 
164     /// @dev Removes authorizion of an address.
165     /// @param target Address to remove authorization from.
166     /// @param index Index of target in authorities array.
167     function removeAuthorizedAddressAtIndex(
168         address target,
169         uint256 index
170     )
171         external
172         onlyOwner
173     {
174         require(
175             authorized[target],
176             "TARGET_NOT_AUTHORIZED"
177         );
178         require(
179             index < authorities.length,
180             "INDEX_OUT_OF_BOUNDS"
181         );
182         require(
183             authorities[index] == target,
184             "AUTHORIZED_ADDRESS_MISMATCH"
185         );
186 
187         delete authorized[target];
188         authorities[index] = authorities[authorities.length - 1];
189         authorities.length -= 1;
190         emit AuthorizedAddressRemoved(target, msg.sender);
191     }
192 
193     /// @dev Gets all authorized addresses.
194     /// @return Array of authorized addresses.
195     function getAuthorizedAddresses()
196         external
197         view
198         returns (address[] memory)
199     {
200         return authorities;
201     }
202 }
203 
204 contract IAssetProxy is
205     IAuthorizable
206 {
207     /// @dev Transfers assets. Either succeeds or throws.
208     /// @param assetData Byte array encoded for the respective asset proxy.
209     /// @param from Address to transfer asset from.
210     /// @param to Address to transfer asset to.
211     /// @param amount Amount of asset to transfer.
212     function transferFrom(
213         bytes assetData,
214         address from,
215         address to,
216         uint256 amount
217     )
218         external;
219     
220     /// @dev Gets the proxy id associated with the proxy address.
221     /// @return Proxy id.
222     function getProxyId()
223         external
224         pure
225         returns (bytes4);
226 }
227 
228 
229 contract IAssetProxyDispatcher {
230 
231     /// @dev Registers an asset proxy to its asset proxy id.
232     ///      Once an asset proxy is registered, it cannot be unregistered.
233     /// @param assetProxy Address of new asset proxy to register.
234     function registerAssetProxy(address assetProxy)
235         external;
236 
237     /// @dev Gets an asset proxy.
238     /// @param assetProxyId Id of the asset proxy.
239     /// @return The asset proxy registered to assetProxyId. Returns 0x0 if no proxy is registered.
240     function getAssetProxy(bytes4 assetProxyId)
241         external
242         view
243         returns (address);
244 }
245 
246 
247 contract MAssetProxyDispatcher is
248     IAssetProxyDispatcher
249 {
250     // Logs registration of new asset proxy
251     event AssetProxyRegistered(
252         bytes4 id,              // Id of new registered AssetProxy.
253         address assetProxy      // Address of new registered AssetProxy.
254     );
255 
256     /// @dev Forwards arguments to assetProxy and calls `transferFrom`. Either succeeds or throws.
257     /// @param assetData Byte array encoded for the asset.
258     /// @param from Address to transfer token from.
259     /// @param to Address to transfer token to.
260     /// @param amount Amount of token to transfer.
261     function dispatchTransferFrom(
262         bytes memory assetData,
263         address from,
264         address to,
265         uint256 amount
266     )
267         internal;
268 }
269 
270 contract MixinAssetProxyDispatcher is
271     Ownable,
272     MAssetProxyDispatcher
273 {
274     // Mapping from Asset Proxy Id's to their respective Asset Proxy
275     mapping (bytes4 => IAssetProxy) public assetProxies;
276 
277     /// @dev Registers an asset proxy to its asset proxy id.
278     ///      Once an asset proxy is registered, it cannot be unregistered.
279     /// @param assetProxy Address of new asset proxy to register.
280     function registerAssetProxy(address assetProxy)
281         external
282         onlyOwner
283     {
284         IAssetProxy assetProxyContract = IAssetProxy(assetProxy);
285 
286         // Ensure that no asset proxy exists with current id.
287         bytes4 assetProxyId = assetProxyContract.getProxyId();
288         address currentAssetProxy = assetProxies[assetProxyId];
289         require(
290             currentAssetProxy == address(0),
291             "ASSET_PROXY_ALREADY_EXISTS"
292         );
293 
294         // Add asset proxy and log registration.
295         assetProxies[assetProxyId] = assetProxyContract;
296         emit AssetProxyRegistered(
297             assetProxyId,
298             assetProxy
299         );
300     }
301 
302     /// @dev Gets an asset proxy.
303     /// @param assetProxyId Id of the asset proxy.
304     /// @return The asset proxy registered to assetProxyId. Returns 0x0 if no proxy is registered.
305     function getAssetProxy(bytes4 assetProxyId)
306         external
307         view
308         returns (address)
309     {
310         return assetProxies[assetProxyId];
311     }
312 
313     /// @dev Forwards arguments to assetProxy and calls `transferFrom`. Either succeeds or throws.
314     /// @param assetData Byte array encoded for the asset.
315     /// @param from Address to transfer token from.
316     /// @param to Address to transfer token to.
317     /// @param amount Amount of token to transfer.
318     function dispatchTransferFrom(
319         bytes memory assetData,
320         address from,
321         address to,
322         uint256 amount
323     )
324         internal
325     {
326         // Do nothing if no amount should be transferred.
327         if (amount > 0 && from != to) {
328             // Ensure assetData length is valid
329             require(
330                 assetData.length > 3,
331                 "LENGTH_GREATER_THAN_3_REQUIRED"
332             );
333             
334             // Lookup assetProxy. We do not use `LibBytes.readBytes4` for gas efficiency reasons.
335             bytes4 assetProxyId;
336             assembly {
337                 assetProxyId := and(mload(
338                     add(assetData, 32)),
339                     0xFFFFFFFF00000000000000000000000000000000000000000000000000000000
340                 )
341             }
342             address assetProxy = assetProxies[assetProxyId];
343 
344             // Ensure that assetProxy exists
345             require(
346                 assetProxy != address(0),
347                 "ASSET_PROXY_DOES_NOT_EXIST"
348             );
349             
350             // We construct calldata for the `assetProxy.transferFrom` ABI.
351             // The layout of this calldata is in the table below.
352             // 
353             // | Area     | Offset | Length  | Contents                                    |
354             // | -------- |--------|---------|-------------------------------------------- |
355             // | Header   | 0      | 4       | function selector                           |
356             // | Params   |        | 4 * 32  | function parameters:                        |
357             // |          | 4      |         |   1. offset to assetData (*)                |
358             // |          | 36     |         |   2. from                                   |
359             // |          | 68     |         |   3. to                                     |
360             // |          | 100    |         |   4. amount                                 |
361             // | Data     |        |         | assetData:                                  |
362             // |          | 132    | 32      | assetData Length                            |
363             // |          | 164    | **      | assetData Contents                          |
364 
365             assembly {
366                 /////// Setup State ///////
367                 // `cdStart` is the start of the calldata for `assetProxy.transferFrom` (equal to free memory ptr).
368                 let cdStart := mload(64)
369                 // `dataAreaLength` is the total number of words needed to store `assetData`
370                 //  As-per the ABI spec, this value is padded up to the nearest multiple of 32,
371                 //  and includes 32-bytes for length.
372                 let dataAreaLength := and(add(mload(assetData), 63), 0xFFFFFFFFFFFE0)
373                 // `cdEnd` is the end of the calldata for `assetProxy.transferFrom`.
374                 let cdEnd := add(cdStart, add(132, dataAreaLength))
375 
376                 
377                 /////// Setup Header Area ///////
378                 // This area holds the 4-byte `transferFromSelector`.
379                 // bytes4(keccak256("transferFrom(bytes,address,address,uint256)")) = 0xa85e59e4
380                 mstore(cdStart, 0xa85e59e400000000000000000000000000000000000000000000000000000000)
381                 
382                 /////// Setup Params Area ///////
383                 // Each parameter is padded to 32-bytes. The entire Params Area is 128 bytes.
384                 // Notes:
385                 //   1. The offset to `assetData` is the length of the Params Area (128 bytes).
386                 //   2. A 20-byte mask is applied to addresses to zero-out the unused bytes.
387                 mstore(add(cdStart, 4), 128)
388                 mstore(add(cdStart, 36), and(from, 0xffffffffffffffffffffffffffffffffffffffff))
389                 mstore(add(cdStart, 68), and(to, 0xffffffffffffffffffffffffffffffffffffffff))
390                 mstore(add(cdStart, 100), amount)
391                 
392                 /////// Setup Data Area ///////
393                 // This area holds `assetData`.
394                 let dataArea := add(cdStart, 132)
395                 // solhint-disable-next-line no-empty-blocks
396                 for {} lt(dataArea, cdEnd) {} {
397                     mstore(dataArea, mload(assetData))
398                     dataArea := add(dataArea, 32)
399                     assetData := add(assetData, 32)
400                 }
401 
402                 /////// Call `assetProxy.transferFrom` using the constructed calldata ///////
403                 let success := call(
404                     gas,                    // forward all gas
405                     assetProxy,             // call address of asset proxy
406                     0,                      // don't send any ETH
407                     cdStart,                // pointer to start of input
408                     sub(cdEnd, cdStart),    // length of input  
409                     cdStart,                // write output over input
410                     512                     // reserve 512 bytes for output
411                 )
412                 if iszero(success) {
413                     revert(cdStart, returndatasize())
414                 }
415             }
416         }
417     }
418 }
419 
420 
421 contract MultiAssetProxy is
422     MixinAssetProxyDispatcher,
423     MixinAuthorizable
424 {
425     // Id of this proxy.
426     bytes4 constant internal PROXY_ID = bytes4(keccak256("MultiAsset(uint256[],bytes[])"));
427 
428     // solhint-disable-next-line payable-fallback
429     function ()
430         external
431     {
432         assembly {
433             // The first 4 bytes of calldata holds the function selector
434             let selector := and(calldataload(0), 0xffffffff00000000000000000000000000000000000000000000000000000000)
435 
436             // `transferFrom` will be called with the following parameters:
437             // assetData Encoded byte array.
438             // from Address to transfer asset from.
439             // to Address to transfer asset to.
440             // amount Amount of asset to transfer.
441             // bytes4(keccak256("transferFrom(bytes,address,address,uint256)")) = 0xa85e59e4
442             if eq(selector, 0xa85e59e400000000000000000000000000000000000000000000000000000000) {
443 
444                 // To lookup a value in a mapping, we load from the storage location keccak256(k, p),
445                 // where k is the key left padded to 32 bytes and p is the storage slot
446                 mstore(0, caller)
447                 mstore(32, authorized_slot)
448 
449                 // Revert if authorized[msg.sender] == false
450                 if iszero(sload(keccak256(0, 64))) {
451                     // Revert with `Error("SENDER_NOT_AUTHORIZED")`
452                     mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
453                     mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
454                     mstore(64, 0x0000001553454e4445525f4e4f545f415554484f52495a454400000000000000)
455                     mstore(96, 0)
456                     revert(0, 100)
457                 }
458 
459                 // `transferFrom`.
460                 // The function is marked `external`, so no abi decoding is done for
461                 // us. Instead, we expect the `calldata` memory to contain the
462                 // following:
463                 //
464                 // | Area     | Offset | Length  | Contents                            |
465                 // |----------|--------|---------|-------------------------------------|
466                 // | Header   | 0      | 4       | function selector                   |
467                 // | Params   |        | 4 * 32  | function parameters:                |
468                 // |          | 4      |         |   1. offset to assetData (*)        |
469                 // |          | 36     |         |   2. from                           |
470                 // |          | 68     |         |   3. to                             |
471                 // |          | 100    |         |   4. amount                         |
472                 // | Data     |        |         | assetData:                          |
473                 // |          | 132    | 32      | assetData Length                    |
474                 // |          | 164    | **      | assetData Contents                  |
475                 //
476                 // (*): offset is computed from start of function parameters, so offset
477                 //      by an additional 4 bytes in the calldata.
478                 //
479                 // (**): see table below to compute length of assetData Contents
480                 //
481                 // WARNING: The ABIv2 specification allows additional padding between
482                 //          the Params and Data section. This will result in a larger
483                 //          offset to assetData.
484 
485                 // Load offset to `assetData`
486                 let assetDataOffset := calldataload(4)
487 
488                 // Asset data itself is encoded as follows:
489                 //
490                 // | Area     | Offset      | Length  | Contents                            |
491                 // |----------|-------------|---------|-------------------------------------|
492                 // | Header   | 0           | 4       | assetProxyId                        |
493                 // | Params   |             | 2 * 32  | function parameters:                |
494                 // |          | 4           |         |   1. offset to amounts (*)          |
495                 // |          | 36          |         |   2. offset to nestedAssetData (*)  |
496                 // | Data     |             |         | amounts:                            |
497                 // |          | 68          | 32      | amounts Length                      |
498                 // |          | 100         | a       | amounts Contents                    | 
499                 // |          |             |         | nestedAssetData:                    |
500                 // |          | 100 + a     | 32      | nestedAssetData Length              |
501                 // |          | 132 + a     | b       | nestedAssetData Contents (offsets)  |
502                 // |          | 132 + a + b |         | nestedAssetData[0, ..., len]        |
503 
504                 // In order to find the offset to `amounts`, we must add:
505                 // 4 (function selector)
506                 // + assetDataOffset
507                 // + 32 (assetData len)
508                 // + 4 (assetProxyId)
509                 let amountsOffset := calldataload(add(assetDataOffset, 40))
510 
511                 // In order to find the offset to `nestedAssetData`, we must add:
512                 // 4 (function selector)
513                 // + assetDataOffset
514                 // + 32 (assetData len)
515                 // + 4 (assetProxyId)
516                 // + 32 (amounts offset)
517                 let nestedAssetDataOffset := calldataload(add(assetDataOffset, 72))
518 
519                 // In order to find the start of the `amounts` contents, we must add: 
520                 // 4 (function selector) 
521                 // + assetDataOffset 
522                 // + 32 (assetData len)
523                 // + 4 (assetProxyId)
524                 // + amountsOffset
525                 // + 32 (amounts len)
526                 let amountsContentsStart := add(assetDataOffset, add(amountsOffset, 72))
527 
528                 // Load number of elements in `amounts`
529                 let amountsLen := calldataload(sub(amountsContentsStart, 32))
530 
531                 // In order to find the start of the `nestedAssetData` contents, we must add: 
532                 // 4 (function selector) 
533                 // + assetDataOffset 
534                 // + 32 (assetData len)
535                 // + 4 (assetProxyId)
536                 // + nestedAssetDataOffset
537                 // + 32 (nestedAssetData len)
538                 let nestedAssetDataContentsStart := add(assetDataOffset, add(nestedAssetDataOffset, 72))
539 
540                 // Load number of elements in `nestedAssetData`
541                 let nestedAssetDataLen := calldataload(sub(nestedAssetDataContentsStart, 32))
542 
543                 // Revert if number of elements in `amounts` differs from number of elements in `nestedAssetData`
544                 if iszero(eq(amountsLen, nestedAssetDataLen)) {
545                     // Revert with `Error("LENGTH_MISMATCH")`
546                     mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
547                     mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
548                     mstore(64, 0x0000000f4c454e4754485f4d49534d4154434800000000000000000000000000)
549                     mstore(96, 0)
550                     revert(0, 100)
551                 }
552 
553                 // Copy `transferFrom` selector, offset to `assetData`, `from`, and `to` from calldata to memory
554                 calldatacopy(
555                     0,   // memory can safely be overwritten from beginning
556                     0,   // start of calldata
557                     100  // length of selector (4) and 3 params (32 * 3)
558                 )
559 
560                 // Overwrite existing offset to `assetData` with our own
561                 mstore(4, 128)
562                 
563                 // Load `amount`
564                 let amount := calldataload(100)
565         
566                 // Calculate number of bytes in `amounts` contents
567                 let amountsByteLen := mul(amountsLen, 32)
568 
569                 // Initialize `assetProxyId` and `assetProxy` to 0
570                 let assetProxyId := 0
571                 let assetProxy := 0
572 
573                 // Loop through `amounts` and `nestedAssetData`, calling `transferFrom` for each respective element
574                 for {let i := 0} lt(i, amountsByteLen) {i := add(i, 32)} {
575 
576                     // Calculate the total amount
577                     let amountsElement := calldataload(add(amountsContentsStart, i))
578                     let totalAmount := mul(amountsElement, amount)
579 
580                     // Revert if multiplication resulted in an overflow
581                     if iszero(eq(div(totalAmount, amount), amountsElement)) {
582                         // Revert with `Error("UINT256_OVERFLOW")`
583                         mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
584                         mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
585                         mstore(64, 0x0000001055494e543235365f4f564552464c4f57000000000000000000000000)
586                         mstore(96, 0)
587                         revert(0, 100)
588                     }
589 
590                     // Write `totalAmount` to memory
591                     mstore(100, totalAmount)
592 
593                     // Load offset to `nestedAssetData[i]`
594                     let nestedAssetDataElementOffset := calldataload(add(nestedAssetDataContentsStart, i))
595 
596                     // In order to find the start of the `nestedAssetData[i]` contents, we must add:
597                     // 4 (function selector) 
598                     // + assetDataOffset 
599                     // + 32 (assetData len)
600                     // + 4 (assetProxyId)
601                     // + nestedAssetDataOffset
602                     // + 32 (nestedAssetData len)
603                     // + nestedAssetDataElementOffset
604                     // + 32 (nestedAssetDataElement len)
605                     let nestedAssetDataElementContentsStart := add(assetDataOffset, add(nestedAssetDataOffset, add(nestedAssetDataElementOffset, 104)))
606 
607                     // Load length of `nestedAssetData[i]`
608                     let nestedAssetDataElementLenStart := sub(nestedAssetDataElementContentsStart, 32)
609                     let nestedAssetDataElementLen := calldataload(nestedAssetDataElementLenStart)
610 
611                     // Revert if the `nestedAssetData` does not contain a 4 byte `assetProxyId`
612                     if lt(nestedAssetDataElementLen, 4) {
613                         // Revert with `Error("LENGTH_GREATER_THAN_3_REQUIRED")`
614                         mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
615                         mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
616                         mstore(64, 0x0000001e4c454e4754485f475245415445525f5448414e5f335f524551554952)
617                         mstore(96, 0x4544000000000000000000000000000000000000000000000000000000000000)
618                         revert(0, 100)
619                     }
620 
621                     // Load AssetProxy id
622                     let currentAssetProxyId := and(
623                         calldataload(nestedAssetDataElementContentsStart),
624                         0xffffffff00000000000000000000000000000000000000000000000000000000
625                     )
626 
627                     // Only load `assetProxy` if `currentAssetProxyId` does not equal `assetProxyId`
628                     // We do not need to check if `currentAssetProxyId` is 0 since `assetProxy` is also initialized to 0
629                     if iszero(eq(currentAssetProxyId, assetProxyId)) {
630                         // Update `assetProxyId`
631                         assetProxyId := currentAssetProxyId
632                         // To lookup a value in a mapping, we load from the storage location keccak256(k, p),
633                         // where k is the key left padded to 32 bytes and p is the storage slot
634                         mstore(132, assetProxyId)
635                         mstore(164, assetProxies_slot)
636                         assetProxy := sload(keccak256(132, 64))
637                     }
638                     
639                     // Revert if AssetProxy with given id does not exist
640                     if iszero(assetProxy) {
641                         // Revert with `Error("ASSET_PROXY_DOES_NOT_EXIST")`
642                         mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
643                         mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
644                         mstore(64, 0x0000001a41535345545f50524f58595f444f45535f4e4f545f45584953540000)
645                         mstore(96, 0)
646                         revert(0, 100)
647                     }
648     
649                     // Copy `nestedAssetData[i]` from calldata to memory
650                     calldatacopy(
651                         132,                                // memory slot after `amounts[i]`
652                         nestedAssetDataElementLenStart,     // location of `nestedAssetData[i]` in calldata
653                         add(nestedAssetDataElementLen, 32)  // `nestedAssetData[i].length` plus 32 byte length
654                     )
655 
656                     // call `assetProxy.transferFrom`
657                     let success := call(
658                         gas,                                    // forward all gas
659                         assetProxy,                             // call address of asset proxy
660                         0,                                      // don't send any ETH
661                         0,                                      // pointer to start of input
662                         add(164, nestedAssetDataElementLen),    // length of input  
663                         0,                                      // write output over memory that won't be reused
664                         0                                       // don't copy output to memory
665                     )
666 
667                     // Revert with reason given by AssetProxy if `transferFrom` call failed
668                     if iszero(success) {
669                         returndatacopy(
670                             0,                // copy to memory at 0
671                             0,                // copy from return data at 0
672                             returndatasize()  // copy all return data
673                         )
674                         revert(0, returndatasize())
675                     }
676                 }
677 
678                 // Return if no `transferFrom` calls reverted
679                 return(0, 0)
680             }
681 
682             // Revert if undefined function is called
683             revert(0, 0)
684         }
685     }
686 
687     /// @dev Gets the proxy id associated with the proxy address.
688     /// @return Proxy id.
689     function getProxyId()
690         external
691         pure
692         returns (bytes4)
693     {
694         return PROXY_ID;
695     }
696 }