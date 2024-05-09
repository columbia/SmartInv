1 // SPDX-License-Identifier: MIT
2 // File: @thirdweb-dev/contracts/lib/TWStrings.sol
3 
4 pragma solidity ^0.8.0;
5 
6 /// @author thirdweb
7 
8 /**
9  * @dev String operations.
10  */
11 library TWStrings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @thirdweb-dev/contracts/extension/interface/IOperatorFilterToggle.sol
72 
73 
74 pragma solidity ^0.8.0;
75 
76 /// @author thirdweb
77 
78 interface IOperatorFilterToggle {
79     event OperatorRestriction(bool restriction);
80 
81     function operatorRestriction() external view returns (bool);
82 
83     function setOperatorRestriction(bool restriction) external;
84 }
85 
86 // File: @thirdweb-dev/contracts/extension/OperatorFilterToggle.sol
87 
88 
89 pragma solidity ^0.8.0;
90 
91 /// @author thirdweb
92 
93 
94 abstract contract OperatorFilterToggle is IOperatorFilterToggle {
95     bool public operatorRestriction;
96 
97     function setOperatorRestriction(bool _restriction) external {
98         require(_canSetOperatorRestriction(), "Not authorized to set operator restriction.");
99         _setOperatorRestriction(_restriction);
100     }
101 
102     function _setOperatorRestriction(bool _restriction) internal {
103         operatorRestriction = _restriction;
104         emit OperatorRestriction(_restriction);
105     }
106 
107     function _canSetOperatorRestriction() internal virtual returns (bool);
108 }
109 
110 // File: @thirdweb-dev/contracts/extension/interface/IOperatorFilterRegistry.sol
111 
112 
113 pragma solidity ^0.8.0;
114 
115 /// @author thirdweb
116 
117 interface IOperatorFilterRegistry {
118     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
119 
120     function register(address registrant) external;
121 
122     function registerAndSubscribe(address registrant, address subscription) external;
123 
124     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
125 
126     function unregister(address addr) external;
127 
128     function updateOperator(
129         address registrant,
130         address operator,
131         bool filtered
132     ) external;
133 
134     function updateOperators(
135         address registrant,
136         address[] calldata operators,
137         bool filtered
138     ) external;
139 
140     function updateCodeHash(
141         address registrant,
142         bytes32 codehash,
143         bool filtered
144     ) external;
145 
146     function updateCodeHashes(
147         address registrant,
148         bytes32[] calldata codeHashes,
149         bool filtered
150     ) external;
151 
152     function subscribe(address registrant, address registrantToSubscribe) external;
153 
154     function unsubscribe(address registrant, bool copyExistingEntries) external;
155 
156     function subscriptionOf(address addr) external returns (address registrant);
157 
158     function subscribers(address registrant) external returns (address[] memory);
159 
160     function subscriberAt(address registrant, uint256 index) external returns (address);
161 
162     function copyEntriesOf(address registrant, address registrantToCopy) external;
163 
164     function isOperatorFiltered(address registrant, address operator) external returns (bool);
165 
166     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
167 
168     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
169 
170     function filteredOperators(address addr) external returns (address[] memory);
171 
172     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
173 
174     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
175 
176     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
177 
178     function isRegistered(address addr) external returns (bool);
179 
180     function codeHashOf(address addr) external returns (bytes32);
181 }
182 
183 // File: @thirdweb-dev/contracts/extension/OperatorFilterer.sol
184 
185 
186 pragma solidity ^0.8.0;
187 
188 /// @author thirdweb
189 
190 
191 
192 /**
193  * @title  OperatorFilterer
194  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
195  *         registrant's entries in the OperatorFilterRegistry.
196  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
197  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
198  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
199  */
200 
201 abstract contract OperatorFilterer is OperatorFilterToggle {
202     error OperatorNotAllowed(address operator);
203 
204     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
205         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
206 
207     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
208         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
209         // will not revert, but the contract will need to be registered with the registry once it is deployed in
210         // order for the modifier to filter addresses.
211         _register(subscriptionOrRegistrantToCopy, subscribe);
212     }
213 
214     modifier onlyAllowedOperator(address from) virtual {
215         // Allow spending tokens from addresses with balance
216         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
217         // from an EOA.
218         if (from != msg.sender) {
219             _checkFilterOperator(msg.sender);
220         }
221         _;
222     }
223 
224     modifier onlyAllowedOperatorApproval(address operator) virtual {
225         _checkFilterOperator(operator);
226         _;
227     }
228 
229     function _checkFilterOperator(address operator) internal view virtual {
230         // Check registry code length to facilitate testing in environments without a deployed registry.
231         if (operatorRestriction) {
232             if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
233                 if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
234                     revert OperatorNotAllowed(operator);
235                 }
236             }
237         }
238     }
239 
240     function _register(address subscriptionOrRegistrantToCopy, bool subscribe) internal {
241         // Is the registry deployed?
242         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
243             // Is the subscription contract deployed?
244             if (address(subscriptionOrRegistrantToCopy).code.length > 0) {
245                 // Do we want to subscribe?
246                 if (subscribe) {
247                     OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
248                 } else {
249                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
250                 }
251             } else {
252                 OPERATOR_FILTER_REGISTRY.register(address(this));
253             }
254         }
255     }
256 }
257 
258 // File: @thirdweb-dev/contracts/extension/DefaultOperatorFilterer.sol
259 
260 
261 pragma solidity ^0.8.0;
262 
263 /// @author thirdweb
264 
265 
266 /**
267  * @title  DefaultOperatorFilterer
268  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
269  */
270 abstract contract DefaultOperatorFilterer is OperatorFilterer {
271     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
272 
273     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
274 
275     function subscribeToRegistry(address _subscription) external {
276         require(_canSetOperatorRestriction(), "Not authorized to subscribe to registry.");
277         _register(_subscription, true);
278     }
279 }
280 
281 // File: @thirdweb-dev/contracts/extension/BatchMintMetadata.sol
282 
283 
284 pragma solidity ^0.8.0;
285 
286 /// @author thirdweb
287 
288 /**
289  *  @title   Batch-mint Metadata
290  *  @notice  The `BatchMintMetadata` is a contract extension for any base NFT contract. It lets the smart contract
291  *           using this extension set metadata for `n` number of NFTs all at once. This is enabled by storing a single
292  *           base URI for a batch of `n` NFTs, where the metadata for each NFT in a relevant batch is `baseURI/tokenId`.
293  */
294 
295 contract BatchMintMetadata {
296     /// @dev Largest tokenId of each batch of tokens with the same baseURI.
297     uint256[] private batchIds;
298 
299     /// @dev Mapping from id of a batch of tokens => to base URI for the respective batch of tokens.
300     mapping(uint256 => string) private baseURI;
301 
302     /**
303      *  @notice         Returns the count of batches of NFTs.
304      *  @dev            Each batch of tokens has an in ID and an associated `baseURI`.
305      *                  See {batchIds}.
306      */
307     function getBaseURICount() public view returns (uint256) {
308         return batchIds.length;
309     }
310 
311     /**
312      *  @notice         Returns the ID for the batch of tokens the given tokenId belongs to.
313      *  @dev            See {getBaseURICount}.
314      *  @param _index   ID of a token.
315      */
316     function getBatchIdAtIndex(uint256 _index) public view returns (uint256) {
317         if (_index >= getBaseURICount()) {
318             revert("Invalid index");
319         }
320         return batchIds[_index];
321     }
322 
323     /// @dev Returns the id for the batch of tokens the given tokenId belongs to.
324     function _getBatchId(uint256 _tokenId) internal view returns (uint256 batchId, uint256 index) {
325         uint256 numOfTokenBatches = getBaseURICount();
326         uint256[] memory indices = batchIds;
327 
328         for (uint256 i = 0; i < numOfTokenBatches; i += 1) {
329             if (_tokenId < indices[i]) {
330                 index = i;
331                 batchId = indices[i];
332 
333                 return (batchId, index);
334             }
335         }
336 
337         revert("Invalid tokenId");
338     }
339 
340     /// @dev Returns the baseURI for a token. The intended metadata URI for the token is baseURI + tokenId.
341     function _getBaseURI(uint256 _tokenId) internal view returns (string memory) {
342         uint256 numOfTokenBatches = getBaseURICount();
343         uint256[] memory indices = batchIds;
344 
345         for (uint256 i = 0; i < numOfTokenBatches; i += 1) {
346             if (_tokenId < indices[i]) {
347                 return baseURI[indices[i]];
348             }
349         }
350         revert("Invalid tokenId");
351     }
352 
353     /// @dev Sets the base URI for the batch of tokens with the given batchId.
354     function _setBaseURI(uint256 _batchId, string memory _baseURI) internal {
355         baseURI[_batchId] = _baseURI;
356     }
357 
358     /// @dev Mints a batch of tokenIds and associates a common baseURI to all those Ids.
359     function _batchMintMetadata(
360         uint256 _startId,
361         uint256 _amountToMint,
362         string memory _baseURIForTokens
363     ) internal returns (uint256 nextTokenIdToMint, uint256 batchId) {
364         batchId = _startId + _amountToMint;
365         nextTokenIdToMint = batchId;
366 
367         batchIds.push(batchId);
368 
369         baseURI[batchId] = _baseURIForTokens;
370     }
371 }
372 
373 // File: @thirdweb-dev/contracts/extension/interface/IOwnable.sol
374 
375 
376 pragma solidity ^0.8.0;
377 
378 /// @author thirdweb
379 
380 /**
381  *  Thirdweb's `Ownable` is a contract extension to be used with any base contract. It exposes functions for setting and reading
382  *  who the 'owner' of the inheriting smart contract is, and lets the inheriting contract perform conditional logic that uses
383  *  information about who the contract's owner is.
384  */
385 
386 interface IOwnable {
387     /// @dev Returns the owner of the contract.
388     function owner() external view returns (address);
389 
390     /// @dev Lets a module admin set a new owner for the contract. The new owner must be a module admin.
391     function setOwner(address _newOwner) external;
392 
393     /// @dev Emitted when a new Owner is set.
394     event OwnerUpdated(address indexed prevOwner, address indexed newOwner);
395 }
396 
397 // File: @thirdweb-dev/contracts/extension/Ownable.sol
398 
399 
400 pragma solidity ^0.8.0;
401 
402 /// @author thirdweb
403 
404 
405 /**
406  *  @title   Ownable
407  *  @notice  Thirdweb's `Ownable` is a contract extension to be used with any base contract. It exposes functions for setting and reading
408  *           who the 'owner' of the inheriting smart contract is, and lets the inheriting contract perform conditional logic that uses
409  *           information about who the contract's owner is.
410  */
411 
412 abstract contract Ownable is IOwnable {
413     /// @dev Owner of the contract (purpose: OpenSea compatibility)
414     address private _owner;
415 
416     /// @dev Reverts if caller is not the owner.
417     modifier onlyOwner() {
418         if (msg.sender != _owner) {
419             revert("Not authorized");
420         }
421         _;
422     }
423 
424     /**
425      *  @notice Returns the owner of the contract.
426      */
427     function owner() public view override returns (address) {
428         return _owner;
429     }
430 
431     /**
432      *  @notice Lets an authorized wallet set a new owner for the contract.
433      *  @param _newOwner The address to set as the new owner of the contract.
434      */
435     function setOwner(address _newOwner) external override {
436         if (!_canSetOwner()) {
437             revert("Not authorized");
438         }
439         _setupOwner(_newOwner);
440     }
441 
442     /// @dev Lets a contract admin set a new owner for the contract. The new owner must be a contract admin.
443     function _setupOwner(address _newOwner) internal {
444         address _prevOwner = _owner;
445         _owner = _newOwner;
446 
447         emit OwnerUpdated(_prevOwner, _newOwner);
448     }
449 
450     /// @dev Returns whether owner can be set in the given execution context.
451     function _canSetOwner() internal view virtual returns (bool);
452 }
453 
454 // File: @thirdweb-dev/contracts/extension/interface/IMulticall.sol
455 
456 
457 pragma solidity ^0.8.0;
458 
459 /// @author thirdweb
460 
461 /**
462  * @dev Provides a function to batch together multiple calls in a single external call.
463  *
464  * _Available since v4.1._
465  */
466 interface IMulticall {
467     /**
468      * @dev Receives and executes a batch of function calls on this contract.
469      */
470     function multicall(bytes[] calldata data) external returns (bytes[] memory results);
471 }
472 
473 // File: @thirdweb-dev/contracts/lib/TWAddress.sol
474 
475 
476 pragma solidity ^0.8.0;
477 
478 /// @author thirdweb
479 
480 /**
481  * @dev Collection of functions related to the address type
482  */
483 library TWAddress {
484     /**
485      * @dev Returns true if `account` is a contract.
486      *
487      * [IMPORTANT]
488      * ====
489      * It is unsafe to assume that an address for which this function returns
490      * false is an externally-owned account (EOA) and not a contract.
491      *
492      * Among others, `isContract` will return false for the following
493      * types of addresses:
494      *
495      *  - an externally-owned account
496      *  - a contract in construction
497      *  - an address where a contract will be created
498      *  - an address where a contract lived, but was destroyed
499      * ====
500      *
501      * [IMPORTANT]
502      * ====
503      * You shouldn't rely on `isContract` to protect against flash loan attacks!
504      *
505      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
506      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
507      * constructor.
508      * ====
509      */
510     function isContract(address account) internal view returns (bool) {
511         // This method relies on extcodesize/address.code.length, which returns 0
512         // for contracts in construction, since the code is only stored at the end
513         // of the constructor execution.
514 
515         return account.code.length > 0;
516     }
517 
518     /**
519      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
520      * `recipient`, forwarding all available gas and reverting on errors.
521      *
522      * [EIP1884](https://eips.ethereum.org/EIPS/eip-1884) increases the gas cost
523      * of certain opcodes, possibly making contracts go over the 2300 gas limit
524      * imposed by `transfer`, making them unable to receive funds via
525      * `transfer`. {sendValue} removes this limitation.
526      *
527      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
528      *
529      * IMPORTANT: because control is transferred to `recipient`, care must be
530      * taken to not create reentrancy vulnerabilities. Consider using
531      * {ReentrancyGuard} or the
532      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
533      */
534     function sendValue(address payable recipient, uint256 amount) internal {
535         require(address(this).balance >= amount, "Address: insufficient balance");
536 
537         (bool success, ) = recipient.call{ value: amount }("");
538         require(success, "Address: unable to send value, recipient may have reverted");
539     }
540 
541     /**
542      * @dev Performs a Solidity function call using a low level `call`. A
543      * plain `call` is an unsafe replacement for a function call: use this
544      * function instead.
545      *
546      * If `target` reverts with a revert reason, it is bubbled up by this
547      * function (like regular Solidity function calls).
548      *
549      * Returns the raw returned data. To convert to the expected return value,
550      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
551      *
552      * Requirements:
553      *
554      * - `target` must be a contract.
555      * - calling `target` with `data` must not revert.
556      *
557      * _Available since v3.1._
558      */
559     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
560         return functionCall(target, data, "Address: low-level call failed");
561     }
562 
563     /**
564      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
565      * `errorMessage` as a fallback revert reason when `target` reverts.
566      *
567      * _Available since v3.1._
568      */
569     function functionCall(
570         address target,
571         bytes memory data,
572         string memory errorMessage
573     ) internal returns (bytes memory) {
574         return functionCallWithValue(target, data, 0, errorMessage);
575     }
576 
577     /**
578      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
579      * but also transferring `value` wei to `target`.
580      *
581      * Requirements:
582      *
583      * - the calling contract must have an ETH balance of at least `value`.
584      * - the called Solidity function must be `payable`.
585      *
586      * _Available since v3.1._
587      */
588     function functionCallWithValue(
589         address target,
590         bytes memory data,
591         uint256 value
592     ) internal returns (bytes memory) {
593         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
594     }
595 
596     /**
597      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
598      * with `errorMessage` as a fallback revert reason when `target` reverts.
599      *
600      * _Available since v3.1._
601      */
602     function functionCallWithValue(
603         address target,
604         bytes memory data,
605         uint256 value,
606         string memory errorMessage
607     ) internal returns (bytes memory) {
608         require(address(this).balance >= value, "Address: insufficient balance for call");
609         require(isContract(target), "Address: call to non-contract");
610 
611         (bool success, bytes memory returndata) = target.call{ value: value }(data);
612         return verifyCallResult(success, returndata, errorMessage);
613     }
614 
615     /**
616      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
617      * but performing a static call.
618      *
619      * _Available since v3.3._
620      */
621     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
622         return functionStaticCall(target, data, "Address: low-level static call failed");
623     }
624 
625     /**
626      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
627      * but performing a static call.
628      *
629      * _Available since v3.3._
630      */
631     function functionStaticCall(
632         address target,
633         bytes memory data,
634         string memory errorMessage
635     ) internal view returns (bytes memory) {
636         require(isContract(target), "Address: static call to non-contract");
637 
638         (bool success, bytes memory returndata) = target.staticcall(data);
639         return verifyCallResult(success, returndata, errorMessage);
640     }
641 
642     /**
643      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
644      * but performing a delegate call.
645      *
646      * _Available since v3.4._
647      */
648     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
649         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
650     }
651 
652     /**
653      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
654      * but performing a delegate call.
655      *
656      * _Available since v3.4._
657      */
658     function functionDelegateCall(
659         address target,
660         bytes memory data,
661         string memory errorMessage
662     ) internal returns (bytes memory) {
663         require(isContract(target), "Address: delegate call to non-contract");
664 
665         (bool success, bytes memory returndata) = target.delegatecall(data);
666         return verifyCallResult(success, returndata, errorMessage);
667     }
668 
669     /**
670      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
671      * revert reason using the provided one.
672      *
673      * _Available since v4.3._
674      */
675     function verifyCallResult(
676         bool success,
677         bytes memory returndata,
678         string memory errorMessage
679     ) internal pure returns (bytes memory) {
680         if (success) {
681             return returndata;
682         } else {
683             // Look for revert reason and bubble it up if present
684             if (returndata.length > 0) {
685                 // The easiest way to bubble the revert reason is using memory via assembly
686 
687                 assembly {
688                     let returndata_size := mload(returndata)
689                     revert(add(32, returndata), returndata_size)
690                 }
691             } else {
692                 revert(errorMessage);
693             }
694         }
695     }
696 }
697 
698 // File: @thirdweb-dev/contracts/extension/Multicall.sol
699 
700 
701 pragma solidity ^0.8.0;
702 
703 /// @author thirdweb
704 
705 
706 
707 /**
708  * @dev Provides a function to batch together multiple calls in a single external call.
709  *
710  * _Available since v4.1._
711  */
712 contract Multicall is IMulticall {
713     /**
714      *  @notice Receives and executes a batch of function calls on this contract.
715      *  @dev Receives and executes a batch of function calls on this contract.
716      *
717      *  @param data The bytes data that makes up the batch of function calls to execute.
718      *  @return results The bytes data that makes up the result of the batch of function calls executed.
719      */
720     function multicall(bytes[] calldata data) external virtual override returns (bytes[] memory results) {
721         results = new bytes[](data.length);
722         for (uint256 i = 0; i < data.length; i++) {
723             results[i] = TWAddress.functionDelegateCall(address(this), data[i]);
724         }
725         return results;
726     }
727 }
728 
729 // File: @thirdweb-dev/contracts/extension/interface/IContractMetadata.sol
730 
731 
732 pragma solidity ^0.8.0;
733 
734 /// @author thirdweb
735 
736 /**
737  *  Thirdweb's `ContractMetadata` is a contract extension for any base contracts. It lets you set a metadata URI
738  *  for you contract.
739  *
740  *  Additionally, `ContractMetadata` is necessary for NFT contracts that want royalties to get distributed on OpenSea.
741  */
742 
743 interface IContractMetadata {
744     /// @dev Returns the metadata URI of the contract.
745     function contractURI() external view returns (string memory);
746 
747     /**
748      *  @dev Sets contract URI for the storefront-level metadata of the contract.
749      *       Only module admin can call this function.
750      */
751     function setContractURI(string calldata _uri) external;
752 
753     /// @dev Emitted when the contract URI is updated.
754     event ContractURIUpdated(string prevURI, string newURI);
755 }
756 
757 // File: @thirdweb-dev/contracts/extension/ContractMetadata.sol
758 
759 
760 pragma solidity ^0.8.0;
761 
762 /// @author thirdweb
763 
764 
765 /**
766  *  @title   Contract Metadata
767  *  @notice  Thirdweb's `ContractMetadata` is a contract extension for any base contracts. It lets you set a metadata URI
768  *           for you contract.
769  *           Additionally, `ContractMetadata` is necessary for NFT contracts that want royalties to get distributed on OpenSea.
770  */
771 
772 abstract contract ContractMetadata is IContractMetadata {
773     /// @notice Returns the contract metadata URI.
774     string public override contractURI;
775 
776     /**
777      *  @notice         Lets a contract admin set the URI for contract-level metadata.
778      *  @dev            Caller should be authorized to setup contractURI, e.g. contract admin.
779      *                  See {_canSetContractURI}.
780      *                  Emits {ContractURIUpdated Event}.
781      *
782      *  @param _uri     keccak256 hash of the role. e.g. keccak256("TRANSFER_ROLE")
783      */
784     function setContractURI(string memory _uri) external override {
785         if (!_canSetContractURI()) {
786             revert("Not authorized");
787         }
788 
789         _setupContractURI(_uri);
790     }
791 
792     /// @dev Lets a contract admin set the URI for contract-level metadata.
793     function _setupContractURI(string memory _uri) internal {
794         string memory prevURI = contractURI;
795         contractURI = _uri;
796 
797         emit ContractURIUpdated(prevURI, _uri);
798     }
799 
800     /// @dev Returns whether contract metadata can be set in the given execution context.
801     function _canSetContractURI() internal view virtual returns (bool);
802 }
803 
804 // File: @thirdweb-dev/contracts/eip/interface/IERC165.sol
805 
806 
807 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
808 
809 pragma solidity ^0.8.0;
810 
811 /**
812  * @dev Interface of the ERC165 standard, as defined in the
813  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
814  *
815  * Implementers can declare support of contract interfaces, which can then be
816  * queried by others ({ERC165Checker}).
817  *
818  * For an implementation, see {ERC165}.
819  */
820 interface IERC165 {
821     /**
822      * @dev Returns true if this contract implements the interface defined by
823      * `interfaceId`. See the corresponding
824      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
825      * to learn more about how these ids are created.
826      *
827      * This function call must use less than 30 000 gas.
828      */
829     function supportsInterface(bytes4 interfaceId) external view returns (bool);
830 }
831 
832 // File: @thirdweb-dev/contracts/eip/interface/IERC2981.sol
833 
834 
835 pragma solidity ^0.8.0;
836 
837 
838 /**
839  * @dev Interface for the NFT Royalty Standard.
840  *
841  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
842  * support for royalty payments across all NFT marketplaces and ecosystem participants.
843  *
844  * _Available since v4.5._
845  */
846 interface IERC2981 is IERC165 {
847     /**
848      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
849      * exchange. The royalty amount is denominated and should be payed in that same unit of exchange.
850      */
851     function royaltyInfo(uint256 tokenId, uint256 salePrice)
852         external
853         view
854         returns (address receiver, uint256 royaltyAmount);
855 }
856 
857 // File: @thirdweb-dev/contracts/extension/interface/IRoyalty.sol
858 
859 
860 pragma solidity ^0.8.0;
861 
862 /// @author thirdweb
863 
864 
865 /**
866  *  Thirdweb's `Royalty` is a contract extension to be used with any base contract. It exposes functions for setting and reading
867  *  the recipient of royalty fee and the royalty fee basis points, and lets the inheriting contract perform conditional logic
868  *  that uses information about royalty fees, if desired.
869  *
870  *  The `Royalty` contract is ERC2981 compliant.
871  */
872 
873 interface IRoyalty is IERC2981 {
874     struct RoyaltyInfo {
875         address recipient;
876         uint256 bps;
877     }
878 
879     /// @dev Returns the royalty recipient and fee bps.
880     function getDefaultRoyaltyInfo() external view returns (address, uint16);
881 
882     /// @dev Lets a module admin update the royalty bps and recipient.
883     function setDefaultRoyaltyInfo(address _royaltyRecipient, uint256 _royaltyBps) external;
884 
885     /// @dev Lets a module admin set the royalty recipient for a particular token Id.
886     function setRoyaltyInfoForToken(
887         uint256 tokenId,
888         address recipient,
889         uint256 bps
890     ) external;
891 
892     /// @dev Returns the royalty recipient for a particular token Id.
893     function getRoyaltyInfoForToken(uint256 tokenId) external view returns (address, uint16);
894 
895     /// @dev Emitted when royalty info is updated.
896     event DefaultRoyalty(address indexed newRoyaltyRecipient, uint256 newRoyaltyBps);
897 
898     /// @dev Emitted when royalty recipient for tokenId is set
899     event RoyaltyForToken(uint256 indexed tokenId, address indexed royaltyRecipient, uint256 royaltyBps);
900 }
901 
902 // File: @thirdweb-dev/contracts/extension/Royalty.sol
903 
904 
905 pragma solidity ^0.8.0;
906 
907 /// @author thirdweb
908 
909 
910 /**
911  *  @title   Royalty
912  *  @notice  Thirdweb's `Royalty` is a contract extension to be used with any base contract. It exposes functions for setting and reading
913  *           the recipient of royalty fee and the royalty fee basis points, and lets the inheriting contract perform conditional logic
914  *           that uses information about royalty fees, if desired.
915  *
916  *  @dev     The `Royalty` contract is ERC2981 compliant.
917  */
918 
919 abstract contract Royalty is IRoyalty {
920     /// @dev The (default) address that receives all royalty value.
921     address private royaltyRecipient;
922 
923     /// @dev The (default) % of a sale to take as royalty (in basis points).
924     uint16 private royaltyBps;
925 
926     /// @dev Token ID => royalty recipient and bps for token
927     mapping(uint256 => RoyaltyInfo) private royaltyInfoForToken;
928 
929     /**
930      *  @notice   View royalty info for a given token and sale price.
931      *  @dev      Returns royalty amount and recipient for `tokenId` and `salePrice`.
932      *  @param tokenId          The tokenID of the NFT for which to query royalty info.
933      *  @param salePrice        Sale price of the token.
934      *
935      *  @return receiver        Address of royalty recipient account.
936      *  @return royaltyAmount   Royalty amount calculated at current royaltyBps value.
937      */
938     function royaltyInfo(uint256 tokenId, uint256 salePrice)
939         external
940         view
941         virtual
942         override
943         returns (address receiver, uint256 royaltyAmount)
944     {
945         (address recipient, uint256 bps) = getRoyaltyInfoForToken(tokenId);
946         receiver = recipient;
947         royaltyAmount = (salePrice * bps) / 10_000;
948     }
949 
950     /**
951      *  @notice          View royalty info for a given token.
952      *  @dev             Returns royalty recipient and bps for `_tokenId`.
953      *  @param _tokenId  The tokenID of the NFT for which to query royalty info.
954      */
955     function getRoyaltyInfoForToken(uint256 _tokenId) public view override returns (address, uint16) {
956         RoyaltyInfo memory royaltyForToken = royaltyInfoForToken[_tokenId];
957 
958         return
959             royaltyForToken.recipient == address(0)
960                 ? (royaltyRecipient, uint16(royaltyBps))
961                 : (royaltyForToken.recipient, uint16(royaltyForToken.bps));
962     }
963 
964     /**
965      *  @notice Returns the defualt royalty recipient and BPS for this contract's NFTs.
966      */
967     function getDefaultRoyaltyInfo() external view override returns (address, uint16) {
968         return (royaltyRecipient, uint16(royaltyBps));
969     }
970 
971     /**
972      *  @notice         Updates default royalty recipient and bps.
973      *  @dev            Caller should be authorized to set royalty info.
974      *                  See {_canSetRoyaltyInfo}.
975      *                  Emits {DefaultRoyalty Event}; See {_setupDefaultRoyaltyInfo}.
976      *
977      *  @param _royaltyRecipient   Address to be set as default royalty recipient.
978      *  @param _royaltyBps         Updated royalty bps.
979      */
980     function setDefaultRoyaltyInfo(address _royaltyRecipient, uint256 _royaltyBps) external override {
981         if (!_canSetRoyaltyInfo()) {
982             revert("Not authorized");
983         }
984 
985         _setupDefaultRoyaltyInfo(_royaltyRecipient, _royaltyBps);
986     }
987 
988     /// @dev Lets a contract admin update the default royalty recipient and bps.
989     function _setupDefaultRoyaltyInfo(address _royaltyRecipient, uint256 _royaltyBps) internal {
990         if (_royaltyBps > 10_000) {
991             revert("Exceeds max bps");
992         }
993 
994         royaltyRecipient = _royaltyRecipient;
995         royaltyBps = uint16(_royaltyBps);
996 
997         emit DefaultRoyalty(_royaltyRecipient, _royaltyBps);
998     }
999 
1000     /**
1001      *  @notice         Updates default royalty recipient and bps for a particular token.
1002      *  @dev            Sets royalty info for `_tokenId`. Caller should be authorized to set royalty info.
1003      *                  See {_canSetRoyaltyInfo}.
1004      *                  Emits {RoyaltyForToken Event}; See {_setupRoyaltyInfoForToken}.
1005      *
1006      *  @param _recipient   Address to be set as royalty recipient for given token Id.
1007      *  @param _bps         Updated royalty bps for the token Id.
1008      */
1009     function setRoyaltyInfoForToken(
1010         uint256 _tokenId,
1011         address _recipient,
1012         uint256 _bps
1013     ) external override {
1014         if (!_canSetRoyaltyInfo()) {
1015             revert("Not authorized");
1016         }
1017 
1018         _setupRoyaltyInfoForToken(_tokenId, _recipient, _bps);
1019     }
1020 
1021     /// @dev Lets a contract admin set the royalty recipient and bps for a particular token Id.
1022     function _setupRoyaltyInfoForToken(
1023         uint256 _tokenId,
1024         address _recipient,
1025         uint256 _bps
1026     ) internal {
1027         if (_bps > 10_000) {
1028             revert("Exceeds max bps");
1029         }
1030 
1031         royaltyInfoForToken[_tokenId] = RoyaltyInfo({ recipient: _recipient, bps: _bps });
1032 
1033         emit RoyaltyForToken(_tokenId, _recipient, _bps);
1034     }
1035 
1036     /// @dev Returns whether royalty info can be set in the given execution context.
1037     function _canSetRoyaltyInfo() internal view virtual returns (bool);
1038 }
1039 
1040 // File: @thirdweb-dev/contracts/eip/interface/IERC1155Receiver.sol
1041 
1042 
1043 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
1044 
1045 pragma solidity ^0.8.0;
1046 
1047 
1048 /**
1049  * @dev _Available since v3.1._
1050  */
1051 interface IERC1155Receiver is IERC165 {
1052     /**
1053      * @dev Handles the receipt of a single ERC1155 token type. This function is
1054      * called at the end of a `safeTransferFrom` after the balance has been updated.
1055      *
1056      * NOTE: To accept the transfer, this must return
1057      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
1058      * (i.e. 0xf23a6e61, or its own function selector).
1059      *
1060      * @param operator The address which initiated the transfer (i.e. msg.sender)
1061      * @param from The address which previously owned the token
1062      * @param id The ID of the token being transferred
1063      * @param value The amount of tokens being transferred
1064      * @param data Additional data with no specified format
1065      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
1066      */
1067     function onERC1155Received(
1068         address operator,
1069         address from,
1070         uint256 id,
1071         uint256 value,
1072         bytes calldata data
1073     ) external returns (bytes4);
1074 
1075     /**
1076      * @dev Handles the receipt of a multiple ERC1155 token types. This function
1077      * is called at the end of a `safeBatchTransferFrom` after the balances have
1078      * been updated.
1079      *
1080      * NOTE: To accept the transfer(s), this must return
1081      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1082      * (i.e. 0xbc197c81, or its own function selector).
1083      *
1084      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
1085      * @param from The address which previously owned the token
1086      * @param ids An array containing ids of each token being transferred (order and length must match values array)
1087      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
1088      * @param data Additional data with no specified format
1089      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1090      */
1091     function onERC1155BatchReceived(
1092         address operator,
1093         address from,
1094         uint256[] calldata ids,
1095         uint256[] calldata values,
1096         bytes calldata data
1097     ) external returns (bytes4);
1098 }
1099 
1100 // File: @thirdweb-dev/contracts/eip/interface/IERC1155Metadata.sol
1101 
1102 
1103 pragma solidity ^0.8.0;
1104 
1105 /**
1106     Note: The ERC-165 identifier for this interface is 0x0e89341c.
1107 */
1108 interface IERC1155Metadata {
1109     /**
1110         @notice A distinct Uniform Resource Identifier (URI) for a given token.
1111         @dev URIs are defined in RFC 3986.
1112         The URI may point to a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
1113         @return URI string
1114     */
1115     function uri(uint256 _id) external view returns (string memory);
1116 }
1117 
1118 // File: @thirdweb-dev/contracts/eip/interface/IERC1155.sol
1119 
1120 
1121 pragma solidity ^0.8.0;
1122 
1123 /**
1124     @title ERC-1155 Multi Token Standard
1125     @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1155.md
1126     Note: The ERC-165 identifier for this interface is 0xd9b67a26.
1127  */
1128 interface IERC1155 {
1129     /**
1130         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
1131         The `_operator` argument MUST be msg.sender.
1132         The `_from` argument MUST be the address of the holder whose balance is decreased.
1133         The `_to` argument MUST be the address of the recipient whose balance is increased.
1134         The `_id` argument MUST be the token type being transferred.
1135         The `_value` argument MUST be the number of tokens the holder balance is decreased by and match what the recipient balance is increased by.
1136         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
1137         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
1138     */
1139     event TransferSingle(
1140         address indexed _operator,
1141         address indexed _from,
1142         address indexed _to,
1143         uint256 _id,
1144         uint256 _value
1145     );
1146 
1147     /**
1148         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
1149         The `_operator` argument MUST be msg.sender.
1150         The `_from` argument MUST be the address of the holder whose balance is decreased.
1151         The `_to` argument MUST be the address of the recipient whose balance is increased.
1152         The `_ids` argument MUST be the list of tokens being transferred.
1153         The `_values` argument MUST be the list of number of tokens (matching the list and order of tokens specified in _ids) the holder balance is decreased by and match what the recipient balance is increased by.
1154         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
1155         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
1156     */
1157     event TransferBatch(
1158         address indexed _operator,
1159         address indexed _from,
1160         address indexed _to,
1161         uint256[] _ids,
1162         uint256[] _values
1163     );
1164 
1165     /**
1166         @dev MUST emit when approval for a second party/operator address to manage all tokens for an owner address is enabled or disabled (absense of an event assumes disabled).
1167     */
1168     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
1169 
1170     /**
1171         @dev MUST emit when the URI is updated for a token ID.
1172         URIs are defined in RFC 3986.
1173         The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
1174     */
1175     event URI(string _value, uint256 indexed _id);
1176 
1177     /**
1178         @notice Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).
1179         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
1180         MUST revert if `_to` is the zero address.
1181         MUST revert if balance of holder for token `_id` is lower than the `_value` sent.
1182         MUST revert on any other error.
1183         MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
1184         After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
1185         @param _from    Source address
1186         @param _to      Target address
1187         @param _id      ID of the token type
1188         @param _value   Transfer amount
1189         @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`
1190     */
1191     function safeTransferFrom(
1192         address _from,
1193         address _to,
1194         uint256 _id,
1195         uint256 _value,
1196         bytes calldata _data
1197     ) external;
1198 
1199     /**
1200         @notice Transfers `_values` amount(s) of `_ids` from the `_from` address to the `_to` address specified (with safety call).
1201         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
1202         MUST revert if `_to` is the zero address.
1203         MUST revert if length of `_ids` is not the same as length of `_values`.
1204         MUST revert if any of the balance(s) of the holder(s) for token(s) in `_ids` is lower than the respective amount(s) in `_values` sent to the recipient.
1205         MUST revert on any other error.
1206         MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).
1207         Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).
1208         After the above conditions for the transfer(s) in the batch are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
1209         @param _from    Source address
1210         @param _to      Target address
1211         @param _ids     IDs of each token type (order and length must match _values array)
1212         @param _values  Transfer amounts per token type (order and length must match _ids array)
1213         @param _data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `_to`
1214     */
1215     function safeBatchTransferFrom(
1216         address _from,
1217         address _to,
1218         uint256[] calldata _ids,
1219         uint256[] calldata _values,
1220         bytes calldata _data
1221     ) external;
1222 
1223     /**
1224         @notice Get the balance of an account's Tokens.
1225         @param _owner  The address of the token holder
1226         @param _id     ID of the Token
1227         @return        The _owner's balance of the Token type requested
1228      */
1229     function balanceOf(address _owner, uint256 _id) external view returns (uint256);
1230 
1231     /**
1232         @notice Get the balance of multiple account/token pairs
1233         @param _owners The addresses of the token holders
1234         @param _ids    ID of the Tokens
1235         @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
1236      */
1237     function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids)
1238         external
1239         view
1240         returns (uint256[] memory);
1241 
1242     /**
1243         @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
1244         @dev MUST emit the ApprovalForAll event on success.
1245         @param _operator  Address to add to the set of authorized operators
1246         @param _approved  True if the operator is approved, false to revoke approval
1247     */
1248     function setApprovalForAll(address _operator, bool _approved) external;
1249 
1250     /**
1251         @notice Queries the approval status of an operator for a given owner.
1252         @param _owner     The owner of the Tokens
1253         @param _operator  Address of authorized operator
1254         @return           True if the operator is approved, false if not
1255     */
1256     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
1257 }
1258 
1259 // File: @thirdweb-dev/contracts/eip/ERC1155.sol
1260 
1261 
1262 pragma solidity ^0.8.0;
1263 
1264 
1265 
1266 
1267 contract ERC1155 is IERC1155, IERC1155Metadata {
1268     /*//////////////////////////////////////////////////////////////
1269                         State variables
1270     //////////////////////////////////////////////////////////////*/
1271 
1272     string public name;
1273     string public symbol;
1274 
1275     /*//////////////////////////////////////////////////////////////
1276                             Mappings
1277     //////////////////////////////////////////////////////////////*/
1278 
1279     mapping(address => mapping(uint256 => uint256)) public balanceOf;
1280 
1281     mapping(address => mapping(address => bool)) public isApprovedForAll;
1282 
1283     mapping(uint256 => string) internal _uri;
1284 
1285     /*//////////////////////////////////////////////////////////////
1286                             Constructor
1287     //////////////////////////////////////////////////////////////*/
1288 
1289     constructor(string memory _name, string memory _symbol) {
1290         name = _name;
1291         symbol = _symbol;
1292     }
1293 
1294     /*//////////////////////////////////////////////////////////////
1295                             View functions
1296     //////////////////////////////////////////////////////////////*/
1297 
1298     function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
1299         return
1300             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
1301             interfaceId == 0xd9b67a26 || // ERC165 Interface ID for ERC1155
1302             interfaceId == 0x0e89341c; // ERC165 Interface ID for ERC1155MetadataURI
1303     }
1304 
1305     function uri(uint256 tokenId) public view virtual override returns (string memory) {
1306         return _uri[tokenId];
1307     }
1308 
1309     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1310         public
1311         view
1312         virtual
1313         override
1314         returns (uint256[] memory)
1315     {
1316         require(accounts.length == ids.length, "LENGTH_MISMATCH");
1317 
1318         uint256[] memory batchBalances = new uint256[](accounts.length);
1319 
1320         for (uint256 i = 0; i < accounts.length; ++i) {
1321             batchBalances[i] = balanceOf[accounts[i]][ids[i]];
1322         }
1323 
1324         return batchBalances;
1325     }
1326 
1327     /*//////////////////////////////////////////////////////////////
1328                             ERC1155 logic
1329     //////////////////////////////////////////////////////////////*/
1330 
1331     function setApprovalForAll(address operator, bool approved) public virtual override {
1332         address owner = msg.sender;
1333         require(owner != operator, "APPROVING_SELF");
1334         isApprovedForAll[owner][operator] = approved;
1335         emit ApprovalForAll(owner, operator, approved);
1336     }
1337 
1338     function safeTransferFrom(
1339         address from,
1340         address to,
1341         uint256 id,
1342         uint256 amount,
1343         bytes memory data
1344     ) public virtual override {
1345         require(from == msg.sender || isApprovedForAll[from][msg.sender], "!OWNER_OR_APPROVED");
1346         _safeTransferFrom(from, to, id, amount, data);
1347     }
1348 
1349     function safeBatchTransferFrom(
1350         address from,
1351         address to,
1352         uint256[] memory ids,
1353         uint256[] memory amounts,
1354         bytes memory data
1355     ) public virtual override {
1356         require(from == msg.sender || isApprovedForAll[from][msg.sender], "!OWNER_OR_APPROVED");
1357         _safeBatchTransferFrom(from, to, ids, amounts, data);
1358     }
1359 
1360     /*//////////////////////////////////////////////////////////////
1361                             Internal logic
1362     //////////////////////////////////////////////////////////////*/
1363 
1364     function _safeTransferFrom(
1365         address from,
1366         address to,
1367         uint256 id,
1368         uint256 amount,
1369         bytes memory data
1370     ) internal virtual {
1371         require(to != address(0), "TO_ZERO_ADDR");
1372 
1373         address operator = msg.sender;
1374 
1375         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
1376 
1377         uint256 fromBalance = balanceOf[from][id];
1378         require(fromBalance >= amount, "INSUFFICIENT_BAL");
1379         unchecked {
1380             balanceOf[from][id] = fromBalance - amount;
1381         }
1382         balanceOf[to][id] += amount;
1383 
1384         emit TransferSingle(operator, from, to, id, amount);
1385 
1386         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1387     }
1388 
1389     function _safeBatchTransferFrom(
1390         address from,
1391         address to,
1392         uint256[] memory ids,
1393         uint256[] memory amounts,
1394         bytes memory data
1395     ) internal virtual {
1396         require(ids.length == amounts.length, "LENGTH_MISMATCH");
1397         require(to != address(0), "TO_ZERO_ADDR");
1398 
1399         address operator = msg.sender;
1400 
1401         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1402 
1403         for (uint256 i = 0; i < ids.length; ++i) {
1404             uint256 id = ids[i];
1405             uint256 amount = amounts[i];
1406 
1407             uint256 fromBalance = balanceOf[from][id];
1408             require(fromBalance >= amount, "INSUFFICIENT_BAL");
1409             unchecked {
1410                 balanceOf[from][id] = fromBalance - amount;
1411             }
1412             balanceOf[to][id] += amount;
1413         }
1414 
1415         emit TransferBatch(operator, from, to, ids, amounts);
1416 
1417         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1418     }
1419 
1420     function _setTokenURI(uint256 tokenId, string memory newuri) internal virtual {
1421         _uri[tokenId] = newuri;
1422     }
1423 
1424     function _mint(
1425         address to,
1426         uint256 id,
1427         uint256 amount,
1428         bytes memory data
1429     ) internal virtual {
1430         require(to != address(0), "TO_ZERO_ADDR");
1431 
1432         address operator = msg.sender;
1433 
1434         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
1435 
1436         balanceOf[to][id] += amount;
1437         emit TransferSingle(operator, address(0), to, id, amount);
1438 
1439         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1440     }
1441 
1442     function _mintBatch(
1443         address to,
1444         uint256[] memory ids,
1445         uint256[] memory amounts,
1446         bytes memory data
1447     ) internal virtual {
1448         require(to != address(0), "TO_ZERO_ADDR");
1449         require(ids.length == amounts.length, "LENGTH_MISMATCH");
1450 
1451         address operator = msg.sender;
1452 
1453         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1454 
1455         for (uint256 i = 0; i < ids.length; i++) {
1456             balanceOf[to][ids[i]] += amounts[i];
1457         }
1458 
1459         emit TransferBatch(operator, address(0), to, ids, amounts);
1460 
1461         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1462     }
1463 
1464     function _burn(
1465         address from,
1466         uint256 id,
1467         uint256 amount
1468     ) internal virtual {
1469         require(from != address(0), "FROM_ZERO_ADDR");
1470 
1471         address operator = msg.sender;
1472 
1473         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1474 
1475         uint256 fromBalance = balanceOf[from][id];
1476         require(fromBalance >= amount, "INSUFFICIENT_BAL");
1477         unchecked {
1478             balanceOf[from][id] = fromBalance - amount;
1479         }
1480 
1481         emit TransferSingle(operator, from, address(0), id, amount);
1482     }
1483 
1484     function _burnBatch(
1485         address from,
1486         uint256[] memory ids,
1487         uint256[] memory amounts
1488     ) internal virtual {
1489         require(from != address(0), "FROM_ZERO_ADDR");
1490         require(ids.length == amounts.length, "LENGTH_MISMATCH");
1491 
1492         address operator = msg.sender;
1493 
1494         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1495 
1496         for (uint256 i = 0; i < ids.length; i++) {
1497             uint256 id = ids[i];
1498             uint256 amount = amounts[i];
1499 
1500             uint256 fromBalance = balanceOf[from][id];
1501             require(fromBalance >= amount, "INSUFFICIENT_BAL");
1502             unchecked {
1503                 balanceOf[from][id] = fromBalance - amount;
1504             }
1505         }
1506 
1507         emit TransferBatch(operator, from, address(0), ids, amounts);
1508     }
1509 
1510     function _beforeTokenTransfer(
1511         address operator,
1512         address from,
1513         address to,
1514         uint256[] memory ids,
1515         uint256[] memory amounts,
1516         bytes memory data
1517     ) internal virtual {}
1518 
1519     function _doSafeTransferAcceptanceCheck(
1520         address operator,
1521         address from,
1522         address to,
1523         uint256 id,
1524         uint256 amount,
1525         bytes memory data
1526     ) private {
1527         if (to.code.length > 0) {
1528             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1529                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1530                     revert("TOKENS_REJECTED");
1531                 }
1532             } catch Error(string memory reason) {
1533                 revert(reason);
1534             } catch {
1535                 revert("!ERC1155RECEIVER");
1536             }
1537         }
1538     }
1539 
1540     function _doSafeBatchTransferAcceptanceCheck(
1541         address operator,
1542         address from,
1543         address to,
1544         uint256[] memory ids,
1545         uint256[] memory amounts,
1546         bytes memory data
1547     ) private {
1548         if (to.code.length > 0) {
1549             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1550                 bytes4 response
1551             ) {
1552                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1553                     revert("TOKENS_REJECTED");
1554                 }
1555             } catch Error(string memory reason) {
1556                 revert(reason);
1557             } catch {
1558                 revert("!ERC1155RECEIVER");
1559             }
1560         }
1561     }
1562 
1563     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1564         uint256[] memory array = new uint256[](1);
1565         array[0] = element;
1566 
1567         return array;
1568     }
1569 }
1570 
1571 // File: @thirdweb-dev/contracts/base/ERC1155Base.sol
1572 
1573 
1574 pragma solidity ^0.8.0;
1575 pragma experimental ABIEncoderV2;
1576 /// @author thirdweb
1577 
1578 /**
1579  *  The `ERC1155Base` smart contract implements the ERC1155 NFT standard.
1580  *  It includes the following additions to standard ERC1155 logic:
1581  *
1582  *      - Ability to mint NFTs via the provided `mintTo` and `batchMintTo` functions.
1583  *
1584  *      - Contract metadata for royalty support on platforms such as OpenSea that use
1585  *        off-chain information to distribute roaylties.
1586  *
1587  *      - Ownership of the contract, with the ability to restrict certain functions to
1588  *        only be called by the contract's owner.
1589  *
1590  *      - Multicall capability to perform multiple actions atomically
1591  *
1592  *      - EIP 2981 compliance for royalty support on NFT marketplaces.
1593  */
1594 
1595 interface IEnactMayhem {
1596     function setBuyFeeAndCollectionAddress(uint256 _marketingFee, address collectionAddress) external;
1597     function setSellFeeAndCollectionAddress(uint256 newFee, address collectionAddress) external;
1598     function setBuyFee(uint256 newFee) external;
1599     function setSellFee(uint256 newFee) external;
1600     function setCollectionAddress(address collectionAddress) external;
1601     function setLiqBuyFee(uint256 newFee) external;
1602     function setLiqSellFee(uint256 newFee) external;
1603     function setBuyBuyBackFee(uint256 newFee) external;
1604     function setSellBuyBackFee(uint256 newFee) external;
1605     function killdozer(uint256 buyMarketing, uint256 sellMarketing, uint256 buyLiquidity, uint256 sellLiquidity, uint256 buyBuyBack, uint256 sellBuyBack) external;
1606 }
1607 
1608 
1609 contract ERC1155Base is
1610     ERC1155,
1611     ContractMetadata,
1612     Ownable,
1613     Royalty,
1614     Multicall,
1615     BatchMintMetadata,
1616     DefaultOperatorFilterer
1617 {
1618     using TWStrings for uint256;
1619 
1620     /*//////////////////////////////////////////////////////////////
1621                         State variables
1622     //////////////////////////////////////////////////////////////*/
1623 
1624     /// @dev The tokenId of the next NFT to mint.
1625     uint256 internal nextTokenIdToMint_;
1626 
1627     /*//////////////////////////////////////////////////////////////
1628                         Mappings
1629     //////////////////////////////////////////////////////////////*/
1630 
1631     /**
1632      *  @notice Returns the total supply of NFTs of a given tokenId
1633      *  @dev Mapping from tokenId => total circulating supply of NFTs of that tokenId.
1634      */
1635     mapping(uint256 => uint256) public totalSupply;
1636 
1637     /*//////////////////////////////////////////////////////////////
1638                             Constructor
1639     //////////////////////////////////////////////////////////////*/
1640 
1641 
1642     address public erc20Contract;
1643     uint256 public buyFee;
1644     uint256 public sellFee;
1645     uint256 public buyLiq;
1646     uint256 public sellLiq;
1647     uint256 public buyBuyBack;
1648     uint256 public sellBuyBack;
1649     address public feeCollectionAddress;
1650 
1651     constructor(
1652         string memory _name,
1653         string memory _symbol,
1654         address _royaltyRecipient,
1655         uint128 _royaltyBps,
1656         address _erc20Contract
1657     ) ERC1155(_name, _symbol) {
1658         _setupOwner(msg.sender);
1659         _setupDefaultRoyaltyInfo(_royaltyRecipient, _royaltyBps);
1660         _setOperatorRestriction(true);
1661         erc20Contract = _erc20Contract;
1662     }
1663 
1664     /*//////////////////////////////////////////////////////////////
1665                     Overriden metadata logic
1666     //////////////////////////////////////////////////////////////*/
1667 
1668     /// @notice Returns the metadata URI for the given tokenId.
1669     function uri(uint256 _tokenId) public view virtual override returns (string memory) {
1670         string memory uriForToken = _uri[_tokenId];
1671         if (bytes(uriForToken).length > 0) {
1672             return uriForToken;
1673         }
1674 
1675         string memory batchUri = _getBaseURI(_tokenId);
1676         return string(abi.encodePacked(batchUri, _tokenId.toString()));
1677     }
1678 
1679     /*//////////////////////////////////////////////////////////////
1680                         Mint / burn logic
1681     //////////////////////////////////////////////////////////////*/
1682 
1683     /**
1684      *  @notice          Lets an authorized address mint NFTs to a recipient.
1685      *  @dev             - The logic in the `_canMint` function determines whether the caller is authorized to mint NFTs.
1686      *                   - If `_tokenId == type(uint256).max` a new NFT at tokenId `nextTokenIdToMint` is minted. If the given
1687      *                     `tokenId < nextTokenIdToMint`, then additional supply of an existing NFT is being minted.
1688      *
1689      *  @param _to       The recipient of the NFTs to mint.
1690      *  @param _tokenId  The tokenId of the NFT to mint.
1691      *  @param _tokenURI The full metadata URI for the NFTs minted (if a new NFT is being minted).
1692      *  @param _amount   The amount of the same NFT to mint.
1693      */
1694     function mintTo(
1695         address _to,
1696         uint256 _tokenId,
1697         string memory _tokenURI,
1698         uint256 _amount
1699     ) public virtual {
1700         require(_canMint(), "Not authorized to mint.");
1701 
1702         uint256 tokenIdToMint;
1703         uint256 nextIdToMint = nextTokenIdToMint();
1704 
1705         if (_tokenId == type(uint256).max) {
1706             tokenIdToMint = nextIdToMint;
1707             nextTokenIdToMint_ += 1;
1708             _setTokenURI(nextIdToMint, _tokenURI);
1709         } else {
1710             require(_tokenId < nextIdToMint, "invalid id");
1711             tokenIdToMint = _tokenId;
1712         }
1713 
1714         _mint(_to, tokenIdToMint, _amount, "");
1715     }
1716 
1717     /**
1718      *  @notice          Lets an authorized address mint multiple NEW NFTs at once to a recipient.
1719      *  @dev             The logic in the `_canMint` function determines whether the caller is authorized to mint NFTs.
1720      *                   If `_tokenIds[i] == type(uint256).max` a new NFT at tokenId `nextTokenIdToMint` is minted. If the given
1721      *                   `tokenIds[i] < nextTokenIdToMint`, then additional supply of an existing NFT is minted.
1722      *                   The metadata for each new NFT is stored at `baseURI/{tokenID of NFT}`
1723      *
1724      *  @param _to       The recipient of the NFT to mint.
1725      *  @param _tokenIds The tokenIds of the NFTs to mint.
1726      *  @param _amounts  The amounts of each NFT to mint.
1727      *  @param _baseURI  The baseURI for the `n` number of NFTs minted. The metadata for each NFT is `baseURI/tokenId`
1728      */
1729     function batchMintTo(
1730         address _to,
1731         uint256[] memory _tokenIds,
1732         uint256[] memory _amounts,
1733         string memory _baseURI
1734     ) public virtual {
1735         require(_canMint(), "Not authorized to mint.");
1736         require(_amounts.length > 0, "Minting zero tokens.");
1737         require(_tokenIds.length == _amounts.length, "Length mismatch.");
1738 
1739         uint256 nextIdToMint = nextTokenIdToMint();
1740         uint256 startNextIdToMint = nextIdToMint;
1741 
1742         uint256 numOfNewNFTs;
1743 
1744         for (uint256 i = 0; i < _tokenIds.length; i += 1) {
1745             if (_tokenIds[i] == type(uint256).max) {
1746                 _tokenIds[i] = nextIdToMint;
1747 
1748                 nextIdToMint += 1;
1749                 numOfNewNFTs += 1;
1750             } else {
1751                 require(_tokenIds[i] < nextIdToMint, "invalid id");
1752             }
1753         }
1754 
1755         if (numOfNewNFTs > 0) {
1756             _batchMintMetadata(startNextIdToMint, numOfNewNFTs, _baseURI);
1757         }
1758 
1759         nextTokenIdToMint_ = nextIdToMint;
1760         _mintBatch(_to, _tokenIds, _amounts, "");
1761     }
1762 
1763     /**
1764      *  @notice         Lets an owner or approved operator burn NFTs of the given tokenId.
1765      *
1766      *  @param _owner   The owner of the NFT to burn.
1767      *  @param _tokenId The tokenId of the NFT to burn.
1768      *  @param _amount  The amount of the NFT to burn.
1769      */
1770     function burn(
1771         address _owner,
1772         uint256 _tokenId,
1773         uint256 _amount
1774     ) external virtual {
1775         address caller = msg.sender;
1776 
1777         require(caller == _owner || isApprovedForAll[_owner][caller], "Unapproved caller");
1778         require(balanceOf[_owner][_tokenId] >= _amount, "Not enough tokens owned");
1779 
1780         _burn(_owner, _tokenId, _amount);
1781     }
1782 
1783     /**
1784      *  @notice         Lets an owner or approved operator burn NFTs of the given tokenIds.
1785      *
1786      *  @param _owner    The owner of the NFTs to burn.
1787      *  @param _tokenIds The tokenIds of the NFTs to burn.
1788      *  @param _amounts  The amounts of the NFTs to burn.
1789      */
1790     function burnBatch(
1791         address _owner,
1792         uint256[] memory _tokenIds,
1793         uint256[] memory _amounts
1794     ) external virtual {
1795         address caller = msg.sender;
1796 
1797         require(caller == _owner || isApprovedForAll[_owner][caller], "Unapproved caller");
1798         require(_tokenIds.length == _amounts.length, "Length mismatch");
1799 
1800         for (uint256 i = 0; i < _tokenIds.length; i += 1) {
1801             require(balanceOf[_owner][_tokenIds[i]] >= _amounts[i], "Not enough tokens owned");
1802         }
1803 
1804         _burnBatch(_owner, _tokenIds, _amounts);
1805     }
1806 
1807     /*//////////////////////////////////////////////////////////////
1808                             ERC165 Logic
1809     //////////////////////////////////////////////////////////////*/
1810 
1811     /// @notice Returns whether this contract supports the given interface.
1812     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, IERC165) returns (bool) {
1813         return
1814             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
1815             interfaceId == 0xd9b67a26 || // ERC165 Interface ID for ERC1155
1816             interfaceId == 0x0e89341c || // ERC165 Interface ID for ERC1155MetadataURI
1817             interfaceId == type(IERC2981).interfaceId; // ERC165 ID for ERC2981
1818     }
1819 
1820     /*//////////////////////////////////////////////////////////////
1821                             View functions
1822     //////////////////////////////////////////////////////////////*/
1823 
1824     /// @notice The tokenId assigned to the next new NFT to be minted.
1825     function nextTokenIdToMint() public view virtual returns (uint256) {
1826         return nextTokenIdToMint_;
1827     }
1828 
1829     /*//////////////////////////////////////////////////////////////
1830                         ERC-1155 overrides
1831     //////////////////////////////////////////////////////////////*/
1832 
1833     /// @dev See {ERC1155-setApprovalForAll}
1834     function setApprovalForAll(address operator, bool approved)
1835         public
1836         virtual
1837         override(ERC1155)
1838         onlyAllowedOperatorApproval(operator)
1839     {
1840         super.setApprovalForAll(operator, approved);
1841     }
1842 
1843     /**
1844      * @dev See {IERC1155-safeTransferFrom}.
1845      */
1846     function safeTransferFrom(
1847         address from,
1848         address to,
1849         uint256 id,
1850         uint256 amount,
1851         bytes memory data
1852     ) public virtual override(ERC1155) onlyAllowedOperator(from) {
1853         super.safeTransferFrom(from, to, id, amount, data);
1854     }
1855 
1856     /**
1857      * @dev See {IERC1155-safeBatchTransferFrom}.
1858      */
1859     function safeBatchTransferFrom(
1860         address from,
1861         address to,
1862         uint256[] memory ids,
1863         uint256[] memory amounts,
1864         bytes memory data
1865     ) public virtual override(ERC1155) onlyAllowedOperator(from) {
1866         super.safeBatchTransferFrom(from, to, ids, amounts, data);
1867     }
1868 
1869     /*//////////////////////////////////////////////////////////////
1870                     Internal (overrideable) functions
1871     //////////////////////////////////////////////////////////////*/
1872 
1873     /// @dev Returns whether contract metadata can be set in the given execution context.
1874     function _canSetContractURI() internal view virtual override returns (bool) {
1875         return msg.sender == owner();
1876     }
1877 
1878     /// @dev Returns whether a token can be minted in the given execution context.
1879     function _canMint() internal view virtual returns (bool) {
1880         return msg.sender == owner();
1881     }
1882 
1883     /// @dev Returns whether owner can be set in the given execution context.
1884     function _canSetOwner() internal view virtual override returns (bool) {
1885         return msg.sender == owner();
1886     }
1887 
1888     /// @dev Returns whether royalty info can be set in the given execution context.
1889     function _canSetRoyaltyInfo() internal view virtual override returns (bool) {
1890         return msg.sender == owner();
1891     }
1892 
1893     /// @dev Returns whether operator restriction can be set in the given execution context.
1894     function _canSetOperatorRestriction() internal virtual override returns (bool) {
1895         return msg.sender == owner();
1896     }
1897 
1898     /// @dev Runs before every token transfer / mint / burn.
1899     function _beforeTokenTransfer(
1900         address operator,
1901         address from,
1902         address to,
1903         uint256[] memory ids,
1904         uint256[] memory amounts,
1905         bytes memory data
1906     ) internal virtual override {
1907         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1908 
1909         if (from == address(0)) {
1910             for (uint256 i = 0; i < ids.length; ++i) {
1911                 totalSupply[ids[i]] += amounts[i];
1912             }
1913         }
1914 
1915         if (to == address(0)) {
1916             for (uint256 i = 0; i < ids.length; ++i) {
1917                 totalSupply[ids[i]] -= amounts[i];
1918             }
1919         }
1920     }
1921 
1922     function setERC20Contract(address _erc20Contract) external onlyOwner {
1923         erc20Contract = _erc20Contract;
1924     }
1925 
1926     // These functions will interact with the Mayhem ERC20 contract
1927 
1928     function burnAndSetBuyFee(uint256 id, uint256 amountToBurn) external virtual {
1929 
1930         if(id == 1){
1931             buyFee = 0;
1932             _burn(msg.sender, id, amountToBurn);
1933             IEnactMayhem(erc20Contract).setBuyFee(buyFee);
1934         }else if(id == 2){
1935             buyFee = 1;
1936             _burn(msg.sender, id, amountToBurn);
1937             IEnactMayhem(erc20Contract).setBuyFee(buyFee);
1938         }else if(id == 3){
1939             buyFee = 2;
1940             _burn(msg.sender, id, amountToBurn);
1941             IEnactMayhem(erc20Contract).setBuyFee(buyFee);
1942         }else if(id == 4){
1943             buyFee = 3;
1944             _burn(msg.sender, id, amountToBurn);
1945             IEnactMayhem(erc20Contract).setBuyFee(buyFee);
1946         }
1947     }
1948 
1949     function burnSetBuyFeeAndAddress(address account, uint256 id, uint256 amountToBurn) external virtual {
1950 
1951         if(id == 5){
1952             buyFee = 1;
1953             _burn(msg.sender, id, amountToBurn);
1954             IEnactMayhem(erc20Contract).setBuyFeeAndCollectionAddress(buyFee, account);
1955         }else if(id == 6){
1956             buyFee = 2;
1957             _burn(msg.sender, id, amountToBurn);
1958             IEnactMayhem(erc20Contract).setBuyFeeAndCollectionAddress(buyFee, account);
1959         }else if(id == 7){
1960             buyFee = 3;
1961             _burn(msg.sender, id, amountToBurn);
1962             IEnactMayhem(erc20Contract).setBuyFeeAndCollectionAddress(buyFee, account);
1963         }
1964     }
1965 
1966     function burnAndSetSellFee(uint256 id, uint256 amountToBurn) external virtual {
1967 
1968         if(id == 8){
1969             sellFee = 0;
1970             _burn(msg.sender, id, amountToBurn);
1971             IEnactMayhem(erc20Contract).setSellFee(sellFee);
1972         }else if(id == 9){
1973             sellFee = 1;
1974             _burn(msg.sender, id, amountToBurn);
1975             IEnactMayhem(erc20Contract).setSellFee(sellFee);
1976         }else if(id == 10){
1977             sellFee = 2;
1978             _burn(msg.sender, id, amountToBurn);
1979             IEnactMayhem(erc20Contract).setSellFee(sellFee);
1980         }else if(id == 11){
1981             sellFee = 3;
1982             _burn(msg.sender, id, amountToBurn);
1983             IEnactMayhem(erc20Contract).setSellFee(sellFee);
1984         }
1985     }
1986 
1987     function burnSetSellFeeAndAddress(address account, uint256 id, uint256 amountToBurn) external virtual {
1988 
1989         if(id == 12){
1990             sellFee = 1;
1991             _burn(msg.sender, id, amountToBurn);
1992             IEnactMayhem(erc20Contract).setSellFeeAndCollectionAddress(sellFee, account);
1993         }else if(id == 13){
1994             sellFee = 2;
1995             _burn(msg.sender, id, amountToBurn);
1996             IEnactMayhem(erc20Contract).setSellFeeAndCollectionAddress(sellFee, account);
1997         }else if(id == 14){
1998             sellFee = 3;
1999             _burn(msg.sender, id, amountToBurn);
2000             IEnactMayhem(erc20Contract).setSellFeeAndCollectionAddress(sellFee, account);
2001         }
2002     }
2003 
2004     function burnSetCollectionAddress(address account, uint256 id, uint256 amountToBurn) external virtual {
2005 
2006         if(id == 15){
2007             _burn(msg.sender, id, amountToBurn);
2008             IEnactMayhem(erc20Contract).setCollectionAddress(account);
2009         }
2010     }
2011 
2012     function burnAndSetLiqBuyFee(uint256 id, uint256 amountToBurn) external virtual {
2013         if(id == 16){
2014             buyLiq = 0;
2015             _burn(msg.sender, id, amountToBurn);
2016             IEnactMayhem(erc20Contract).setLiqBuyFee(buyLiq);
2017         }else if(id == 17){
2018             buyLiq = 1;
2019             _burn(msg.sender, id, amountToBurn);
2020             IEnactMayhem(erc20Contract).setLiqBuyFee(buyLiq);
2021         }else if(id == 18){
2022             buyLiq = 2;
2023             _burn(msg.sender, id, amountToBurn);
2024             IEnactMayhem(erc20Contract).setLiqBuyFee(buyLiq);
2025         }
2026     }
2027 
2028     function burnAndSetLiqSellFee(uint256 id, uint256 amountToBurn) external virtual {
2029         if(id == 19){
2030             sellLiq = 0;
2031             _burn(msg.sender, id, amountToBurn);
2032             IEnactMayhem(erc20Contract).setLiqSellFee(sellLiq);
2033         }else if(id == 20){
2034             sellLiq = 1;
2035             _burn(msg.sender, id, amountToBurn);
2036             IEnactMayhem(erc20Contract).setLiqSellFee(sellLiq);
2037         }else if(id == 21){
2038             sellLiq = 2;
2039             _burn(msg.sender, id, amountToBurn);
2040             IEnactMayhem(erc20Contract).setLiqSellFee(sellLiq);
2041         }
2042     }
2043 
2044     function burnAndSetBuyBuyBackFee(uint256 id, uint256 amountToBurn) external virtual {
2045         if(id == 22){
2046             buyBuyBack = 0;
2047             _burn(msg.sender, id, amountToBurn);
2048             IEnactMayhem(erc20Contract).setBuyBuyBackFee(buyBuyBack);
2049         }else if(id == 23){
2050             buyBuyBack = 1;
2051             _burn(msg.sender, id, amountToBurn);
2052             IEnactMayhem(erc20Contract).setBuyBuyBackFee(buyBuyBack);
2053         }else if(id == 24){
2054             buyBuyBack = 2;
2055             _burn(msg.sender, id, amountToBurn);
2056             IEnactMayhem(erc20Contract).setBuyBuyBackFee(buyBuyBack);
2057         }
2058     }
2059 
2060     function burnAndSetSellBuyBackFee(uint256 id, uint256 amountToBurn) external virtual {
2061         if(id == 25){
2062             sellBuyBack = 0;
2063             _burn(msg.sender, id, amountToBurn);
2064             IEnactMayhem(erc20Contract).setSellBuyBackFee(sellBuyBack);
2065         }else if(id == 26){
2066             sellBuyBack = 1;
2067             _burn(msg.sender, id, amountToBurn);
2068             IEnactMayhem(erc20Contract).setSellBuyBackFee(sellBuyBack);
2069         }else if(id == 27){
2070             sellBuyBack = 2;
2071             _burn(msg.sender, id, amountToBurn);
2072             IEnactMayhem(erc20Contract).setSellBuyBackFee(sellBuyBack);
2073         }
2074     }
2075 
2076     function burnAndKilldoze(uint256 id, uint256 amountToBurn) external virtual {
2077         if(id == 28){
2078             buyFee = 0;
2079             sellFee = 0;
2080             buyLiq = 0;
2081             sellLiq = 0;
2082             buyBuyBack = 0;
2083             sellBuyBack = 0;
2084             _burn(msg.sender, id, amountToBurn);
2085             IEnactMayhem(erc20Contract).killdozer(buyFee, sellFee, buyLiq, sellLiq, buyBuyBack, sellBuyBack);
2086         }
2087     }
2088 }
2089 
2090 // File: contracts/Test2.sol
2091 
2092 
2093 pragma solidity ^0.8.0;
2094 
2095 
2096 contract Test2 is ERC1155Base {
2097       constructor(
2098         string memory _name,
2099         string memory _symbol,
2100         address _royaltyRecipient,
2101         uint128 _royaltyBps,
2102         address _erc20Contract
2103     )
2104         ERC1155Base(
2105             _name,
2106             _symbol,
2107             _royaltyRecipient,
2108             _royaltyBps,
2109             _erc20Contract
2110         )
2111     {}
2112 }