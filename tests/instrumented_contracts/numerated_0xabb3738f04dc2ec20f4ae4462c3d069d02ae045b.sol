1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
29 
30 
31 
32 pragma solidity ^0.8.0;
33 
34 
35 /**
36  * @dev Implementation of the {IERC165} interface.
37  *
38  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
39  * for the additional interface id that will be supported. For example:
40  *
41  * ```solidity
42  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
43  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
44  * }
45  * ```
46  *
47  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
48  */
49 abstract contract ERC165 is IERC165 {
50     /**
51      * @dev See {IERC165-supportsInterface}.
52      */
53     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
54         return interfaceId == type(IERC165).interfaceId;
55     }
56 }
57 
58 // File: @openzeppelin/contracts/utils/introspection/ERC165Storage.sol
59 
60 
61 
62 pragma solidity ^0.8.0;
63 
64 
65 /**
66  * @dev Storage based implementation of the {IERC165} interface.
67  *
68  * Contracts may inherit from this and call {_registerInterface} to declare
69  * their support of an interface.
70  */
71 abstract contract ERC165Storage is ERC165 {
72     /**
73      * @dev Mapping of interface ids to whether or not it's supported.
74      */
75     mapping(bytes4 => bool) private _supportedInterfaces;
76 
77     /**
78      * @dev See {IERC165-supportsInterface}.
79      */
80     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
81         return super.supportsInterface(interfaceId) || _supportedInterfaces[interfaceId];
82     }
83 
84     /**
85      * @dev Registers the contract as an implementer of the interface defined by
86      * `interfaceId`. Support of the actual ERC165 interface is automatic and
87      * registering its interface id is not required.
88      *
89      * See {IERC165-supportsInterface}.
90      *
91      * Requirements:
92      *
93      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
94      */
95     function _registerInterface(bytes4 interfaceId) internal virtual {
96         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
97         _supportedInterfaces[interfaceId] = true;
98     }
99 }
100 
101 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
102 
103 
104 
105 pragma solidity ^0.8.0;
106 
107 /**
108  * @title ERC721 token receiver interface
109  * @dev Interface for any contract that wants to support safeTransfers
110  * from ERC721 asset contracts.
111  */
112 interface IERC721Receiver {
113     /**
114      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
115      * by `operator` from `from`, this function is called.
116      *
117      * It must return its Solidity selector to confirm the token transfer.
118      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
119      *
120      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
121      */
122     function onERC721Received(
123         address operator,
124         address from,
125         uint256 tokenId,
126         bytes calldata data
127     ) external returns (bytes4);
128 }
129 
130 // File: @openzeppelin/contracts/utils/Address.sol
131 
132 
133 
134 pragma solidity ^0.8.0;
135 
136 /**
137  * @dev Collection of functions related to the address type
138  */
139 library Address {
140     /**
141      * @dev Returns true if `account` is a contract.
142      *
143      * [IMPORTANT]
144      * ====
145      * It is unsafe to assume that an address for which this function returns
146      * false is an externally-owned account (EOA) and not a contract.
147      *
148      * Among others, `isContract` will return false for the following
149      * types of addresses:
150      *
151      *  - an externally-owned account
152      *  - a contract in construction
153      *  - an address where a contract will be created
154      *  - an address where a contract lived, but was destroyed
155      * ====
156      */
157     function isContract(address account) internal view returns (bool) {
158         // This method relies on extcodesize, which returns 0 for contracts in
159         // construction, since the code is only stored at the end of the
160         // constructor execution.
161 
162         uint256 size;
163         assembly {
164             size := extcodesize(account)
165         }
166         return size > 0;
167     }
168 
169     /**
170      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
171      * `recipient`, forwarding all available gas and reverting on errors.
172      *
173      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
174      * of certain opcodes, possibly making contracts go over the 2300 gas limit
175      * imposed by `transfer`, making them unable to receive funds via
176      * `transfer`. {sendValue} removes this limitation.
177      *
178      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
179      *
180      * IMPORTANT: because control is transferred to `recipient`, care must be
181      * taken to not create reentrancy vulnerabilities. Consider using
182      * {ReentrancyGuard} or the
183      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
184      */
185     function sendValue(address payable recipient, uint256 amount) internal {
186         require(address(this).balance >= amount, "Address: insufficient balance");
187 
188         (bool success, ) = recipient.call{value: amount}("");
189         require(success, "Address: unable to send value, recipient may have reverted");
190     }
191 
192     /**
193      * @dev Performs a Solidity function call using a low level `call`. A
194      * plain `call` is an unsafe replacement for a function call: use this
195      * function instead.
196      *
197      * If `target` reverts with a revert reason, it is bubbled up by this
198      * function (like regular Solidity function calls).
199      *
200      * Returns the raw returned data. To convert to the expected return value,
201      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
202      *
203      * Requirements:
204      *
205      * - `target` must be a contract.
206      * - calling `target` with `data` must not revert.
207      *
208      * _Available since v3.1._
209      */
210     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
211         return functionCall(target, data, "Address: low-level call failed");
212     }
213 
214     /**
215      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
216      * `errorMessage` as a fallback revert reason when `target` reverts.
217      *
218      * _Available since v3.1._
219      */
220     function functionCall(
221         address target,
222         bytes memory data,
223         string memory errorMessage
224     ) internal returns (bytes memory) {
225         return functionCallWithValue(target, data, 0, errorMessage);
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
230      * but also transferring `value` wei to `target`.
231      *
232      * Requirements:
233      *
234      * - the calling contract must have an ETH balance of at least `value`.
235      * - the called Solidity function must be `payable`.
236      *
237      * _Available since v3.1._
238      */
239     function functionCallWithValue(
240         address target,
241         bytes memory data,
242         uint256 value
243     ) internal returns (bytes memory) {
244         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
245     }
246 
247     /**
248      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
249      * with `errorMessage` as a fallback revert reason when `target` reverts.
250      *
251      * _Available since v3.1._
252      */
253     function functionCallWithValue(
254         address target,
255         bytes memory data,
256         uint256 value,
257         string memory errorMessage
258     ) internal returns (bytes memory) {
259         require(address(this).balance >= value, "Address: insufficient balance for call");
260         require(isContract(target), "Address: call to non-contract");
261 
262         (bool success, bytes memory returndata) = target.call{value: value}(data);
263         return _verifyCallResult(success, returndata, errorMessage);
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
268      * but performing a static call.
269      *
270      * _Available since v3.3._
271      */
272     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
273         return functionStaticCall(target, data, "Address: low-level static call failed");
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
278      * but performing a static call.
279      *
280      * _Available since v3.3._
281      */
282     function functionStaticCall(
283         address target,
284         bytes memory data,
285         string memory errorMessage
286     ) internal view returns (bytes memory) {
287         require(isContract(target), "Address: static call to non-contract");
288 
289         (bool success, bytes memory returndata) = target.staticcall(data);
290         return _verifyCallResult(success, returndata, errorMessage);
291     }
292 
293     /**
294      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
295      * but performing a delegate call.
296      *
297      * _Available since v3.4._
298      */
299     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
300         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
305      * but performing a delegate call.
306      *
307      * _Available since v3.4._
308      */
309     function functionDelegateCall(
310         address target,
311         bytes memory data,
312         string memory errorMessage
313     ) internal returns (bytes memory) {
314         require(isContract(target), "Address: delegate call to non-contract");
315 
316         (bool success, bytes memory returndata) = target.delegatecall(data);
317         return _verifyCallResult(success, returndata, errorMessage);
318     }
319 
320     function _verifyCallResult(
321         bool success,
322         bytes memory returndata,
323         string memory errorMessage
324     ) private pure returns (bytes memory) {
325         if (success) {
326             return returndata;
327         } else {
328             // Look for revert reason and bubble it up if present
329             if (returndata.length > 0) {
330                 // The easiest way to bubble the revert reason is using memory via assembly
331 
332                 assembly {
333                     let returndata_size := mload(returndata)
334                     revert(add(32, returndata), returndata_size)
335                 }
336             } else {
337                 revert(errorMessage);
338             }
339         }
340     }
341 }
342 
343 // File: contracts/access/IKOAccessControlsLookup.sol
344 
345 
346 
347 pragma solidity 0.8.4;
348 
349 interface IKOAccessControlsLookup {
350     function hasAdminRole(address _address) external view returns (bool);
351 
352     function isVerifiedArtist(uint256 _index, address _account, bytes32[] calldata _merkleProof) external view returns (bool);
353 
354     function isVerifiedArtistProxy(address _artist, address _proxy) external view returns (bool);
355 
356     function hasLegacyMinterRole(address _address) external view returns (bool);
357 
358     function hasContractRole(address _address) external view returns (bool);
359 
360     function hasContractOrAdminRole(address _address) external view returns (bool);
361 }
362 
363 // File: contracts/core/IERC2981.sol
364 
365 
366 
367 pragma solidity 0.8.4;
368 
369 
370 /// @notice This is purely an extension for the KO platform
371 /// @notice Royalties on KO are defined at an edition level for all tokens from the same edition
372 interface IERC2981EditionExtension {
373 
374     /// @notice Does the edition have any royalties defined
375     function hasRoyalties(uint256 _editionId) external view returns (bool);
376 
377     /// @notice Get the royalty receiver - all royalties should be sent to this account if not zero address
378     function getRoyaltiesReceiver(uint256 _editionId) external view returns (address);
379 }
380 
381 /**
382  * ERC2981 standards interface for royalties
383  */
384 interface IERC2981 is IERC165, IERC2981EditionExtension {
385     /// ERC165 bytes to add to interface array - set in parent contract
386     /// implementing this standard
387     ///
388     /// bytes4(keccak256("royaltyInfo(uint256,uint256)")) == 0x2a55205a
389     /// bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
390     /// _registerInterface(_INTERFACE_ID_ERC2981);
391 
392     /// @notice Called with the sale price to determine how much royalty
393     //          is owed and to whom.
394     /// @param _tokenId - the NFT asset queried for royalty information
395     /// @param _value - the sale price of the NFT asset specified by _tokenId
396     /// @return _receiver - address of who should be sent the royalty payment
397     /// @return _royaltyAmount - the royalty payment amount for _value sale price
398     function royaltyInfo(
399         uint256 _tokenId,
400         uint256 _value
401     ) external view returns (
402         address _receiver,
403         uint256 _royaltyAmount
404     );
405 
406 }
407 
408 // File: contracts/core/IKODAV3Minter.sol
409 
410 
411 
412 pragma solidity 0.8.4;
413 
414 interface IKODAV3Minter {
415 
416     function mintBatchEdition(uint16 _editionSize, address _to, string calldata _uri) external returns (uint256 _editionId);
417 
418     function mintBatchEditionAndComposeERC20s(uint16 _editionSize, address _to, string calldata _uri, address[] calldata _erc20s, uint256[] calldata _amounts) external returns (uint256 _editionId);
419 
420     function mintConsecutiveBatchEdition(uint16 _editionSize, address _to, string calldata _uri) external returns (uint256 _editionId);
421 }
422 
423 // File: contracts/programmable/ITokenUriResolver.sol
424 
425 
426 
427 pragma solidity 0.8.4;
428 
429 interface ITokenUriResolver {
430 
431     /// @notice Return the edition or token level URI - token level trumps edition level if found
432     function tokenURI(uint256 _editionId, uint256 _tokenId) external view returns (string memory);
433 
434     /// @notice Do we have an edition level or token level token URI resolver set
435     function isDefined(uint256 _editionId, uint256 _tokenId) external view returns (bool);
436 }
437 
438 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
439 
440 
441 
442 pragma solidity ^0.8.0;
443 
444 /**
445  * @dev Interface of the ERC20 standard as defined in the EIP.
446  */
447 interface IERC20 {
448     /**
449      * @dev Returns the amount of tokens in existence.
450      */
451     function totalSupply() external view returns (uint256);
452 
453     /**
454      * @dev Returns the amount of tokens owned by `account`.
455      */
456     function balanceOf(address account) external view returns (uint256);
457 
458     /**
459      * @dev Moves `amount` tokens from the caller's account to `recipient`.
460      *
461      * Returns a boolean value indicating whether the operation succeeded.
462      *
463      * Emits a {Transfer} event.
464      */
465     function transfer(address recipient, uint256 amount) external returns (bool);
466 
467     /**
468      * @dev Returns the remaining number of tokens that `spender` will be
469      * allowed to spend on behalf of `owner` through {transferFrom}. This is
470      * zero by default.
471      *
472      * This value changes when {approve} or {transferFrom} are called.
473      */
474     function allowance(address owner, address spender) external view returns (uint256);
475 
476     /**
477      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
478      *
479      * Returns a boolean value indicating whether the operation succeeded.
480      *
481      * IMPORTANT: Beware that changing an allowance with this method brings the risk
482      * that someone may use both the old and the new allowance by unfortunate
483      * transaction ordering. One possible solution to mitigate this race
484      * condition is to first reduce the spender's allowance to 0 and set the
485      * desired value afterwards:
486      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
487      *
488      * Emits an {Approval} event.
489      */
490     function approve(address spender, uint256 amount) external returns (bool);
491 
492     /**
493      * @dev Moves `amount` tokens from `sender` to `recipient` using the
494      * allowance mechanism. `amount` is then deducted from the caller's
495      * allowance.
496      *
497      * Returns a boolean value indicating whether the operation succeeded.
498      *
499      * Emits a {Transfer} event.
500      */
501     function transferFrom(
502         address sender,
503         address recipient,
504         uint256 amount
505     ) external returns (bool);
506 
507     /**
508      * @dev Emitted when `value` tokens are moved from one account (`from`) to
509      * another (`to`).
510      *
511      * Note that `value` may be zero.
512      */
513     event Transfer(address indexed from, address indexed to, uint256 value);
514 
515     /**
516      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
517      * a call to {approve}. `value` is the new allowance.
518      */
519     event Approval(address indexed owner, address indexed spender, uint256 value);
520 }
521 
522 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
523 
524 
525 
526 pragma solidity ^0.8.0;
527 
528 
529 /**
530  * @dev Required interface of an ERC721 compliant contract.
531  */
532 interface IERC721 is IERC165 {
533     /**
534      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
535      */
536     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
537 
538     /**
539      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
540      */
541     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
542 
543     /**
544      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
545      */
546     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
547 
548     /**
549      * @dev Returns the number of tokens in ``owner``'s account.
550      */
551     function balanceOf(address owner) external view returns (uint256 balance);
552 
553     /**
554      * @dev Returns the owner of the `tokenId` token.
555      *
556      * Requirements:
557      *
558      * - `tokenId` must exist.
559      */
560     function ownerOf(uint256 tokenId) external view returns (address owner);
561 
562     /**
563      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
564      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
565      *
566      * Requirements:
567      *
568      * - `from` cannot be the zero address.
569      * - `to` cannot be the zero address.
570      * - `tokenId` token must exist and be owned by `from`.
571      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
572      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
573      *
574      * Emits a {Transfer} event.
575      */
576     function safeTransferFrom(
577         address from,
578         address to,
579         uint256 tokenId
580     ) external;
581 
582     /**
583      * @dev Transfers `tokenId` token from `from` to `to`.
584      *
585      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
586      *
587      * Requirements:
588      *
589      * - `from` cannot be the zero address.
590      * - `to` cannot be the zero address.
591      * - `tokenId` token must be owned by `from`.
592      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
593      *
594      * Emits a {Transfer} event.
595      */
596     function transferFrom(
597         address from,
598         address to,
599         uint256 tokenId
600     ) external;
601 
602     /**
603      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
604      * The approval is cleared when the token is transferred.
605      *
606      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
607      *
608      * Requirements:
609      *
610      * - The caller must own the token or be an approved operator.
611      * - `tokenId` must exist.
612      *
613      * Emits an {Approval} event.
614      */
615     function approve(address to, uint256 tokenId) external;
616 
617     /**
618      * @dev Returns the account approved for `tokenId` token.
619      *
620      * Requirements:
621      *
622      * - `tokenId` must exist.
623      */
624     function getApproved(uint256 tokenId) external view returns (address operator);
625 
626     /**
627      * @dev Approve or remove `operator` as an operator for the caller.
628      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
629      *
630      * Requirements:
631      *
632      * - The `operator` cannot be the caller.
633      *
634      * Emits an {ApprovalForAll} event.
635      */
636     function setApprovalForAll(address operator, bool _approved) external;
637 
638     /**
639      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
640      *
641      * See {setApprovalForAll}
642      */
643     function isApprovedForAll(address owner, address operator) external view returns (bool);
644 
645     /**
646      * @dev Safely transfers `tokenId` token from `from` to `to`.
647      *
648      * Requirements:
649      *
650      * - `from` cannot be the zero address.
651      * - `to` cannot be the zero address.
652      * - `tokenId` token must exist and be owned by `from`.
653      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
654      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
655      *
656      * Emits a {Transfer} event.
657      */
658     function safeTransferFrom(
659         address from,
660         address to,
661         uint256 tokenId,
662         bytes calldata data
663     ) external;
664 }
665 
666 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
667 
668 
669 
670 pragma solidity ^0.8.0;
671 
672 /**
673  * @dev Library for managing
674  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
675  * types.
676  *
677  * Sets have the following properties:
678  *
679  * - Elements are added, removed, and checked for existence in constant time
680  * (O(1)).
681  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
682  *
683  * ```
684  * contract Example {
685  *     // Add the library methods
686  *     using EnumerableSet for EnumerableSet.AddressSet;
687  *
688  *     // Declare a set state variable
689  *     EnumerableSet.AddressSet private mySet;
690  * }
691  * ```
692  *
693  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
694  * and `uint256` (`UintSet`) are supported.
695  */
696 library EnumerableSet {
697     // To implement this library for multiple types with as little code
698     // repetition as possible, we write it in terms of a generic Set type with
699     // bytes32 values.
700     // The Set implementation uses private functions, and user-facing
701     // implementations (such as AddressSet) are just wrappers around the
702     // underlying Set.
703     // This means that we can only create new EnumerableSets for types that fit
704     // in bytes32.
705 
706     struct Set {
707         // Storage of set values
708         bytes32[] _values;
709         // Position of the value in the `values` array, plus 1 because index 0
710         // means a value is not in the set.
711         mapping(bytes32 => uint256) _indexes;
712     }
713 
714     /**
715      * @dev Add a value to a set. O(1).
716      *
717      * Returns true if the value was added to the set, that is if it was not
718      * already present.
719      */
720     function _add(Set storage set, bytes32 value) private returns (bool) {
721         if (!_contains(set, value)) {
722             set._values.push(value);
723             // The value is stored at length-1, but we add 1 to all indexes
724             // and use 0 as a sentinel value
725             set._indexes[value] = set._values.length;
726             return true;
727         } else {
728             return false;
729         }
730     }
731 
732     /**
733      * @dev Removes a value from a set. O(1).
734      *
735      * Returns true if the value was removed from the set, that is if it was
736      * present.
737      */
738     function _remove(Set storage set, bytes32 value) private returns (bool) {
739         // We read and store the value's index to prevent multiple reads from the same storage slot
740         uint256 valueIndex = set._indexes[value];
741 
742         if (valueIndex != 0) {
743             // Equivalent to contains(set, value)
744             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
745             // the array, and then remove the last element (sometimes called as 'swap and pop').
746             // This modifies the order of the array, as noted in {at}.
747 
748             uint256 toDeleteIndex = valueIndex - 1;
749             uint256 lastIndex = set._values.length - 1;
750 
751             if (lastIndex != toDeleteIndex) {
752                 bytes32 lastvalue = set._values[lastIndex];
753 
754                 // Move the last value to the index where the value to delete is
755                 set._values[toDeleteIndex] = lastvalue;
756                 // Update the index for the moved value
757                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
758             }
759 
760             // Delete the slot where the moved value was stored
761             set._values.pop();
762 
763             // Delete the index for the deleted slot
764             delete set._indexes[value];
765 
766             return true;
767         } else {
768             return false;
769         }
770     }
771 
772     /**
773      * @dev Returns true if the value is in the set. O(1).
774      */
775     function _contains(Set storage set, bytes32 value) private view returns (bool) {
776         return set._indexes[value] != 0;
777     }
778 
779     /**
780      * @dev Returns the number of values on the set. O(1).
781      */
782     function _length(Set storage set) private view returns (uint256) {
783         return set._values.length;
784     }
785 
786     /**
787      * @dev Returns the value stored at position `index` in the set. O(1).
788      *
789      * Note that there are no guarantees on the ordering of values inside the
790      * array, and it may change when more values are added or removed.
791      *
792      * Requirements:
793      *
794      * - `index` must be strictly less than {length}.
795      */
796     function _at(Set storage set, uint256 index) private view returns (bytes32) {
797         return set._values[index];
798     }
799 
800     // Bytes32Set
801 
802     struct Bytes32Set {
803         Set _inner;
804     }
805 
806     /**
807      * @dev Add a value to a set. O(1).
808      *
809      * Returns true if the value was added to the set, that is if it was not
810      * already present.
811      */
812     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
813         return _add(set._inner, value);
814     }
815 
816     /**
817      * @dev Removes a value from a set. O(1).
818      *
819      * Returns true if the value was removed from the set, that is if it was
820      * present.
821      */
822     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
823         return _remove(set._inner, value);
824     }
825 
826     /**
827      * @dev Returns true if the value is in the set. O(1).
828      */
829     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
830         return _contains(set._inner, value);
831     }
832 
833     /**
834      * @dev Returns the number of values in the set. O(1).
835      */
836     function length(Bytes32Set storage set) internal view returns (uint256) {
837         return _length(set._inner);
838     }
839 
840     /**
841      * @dev Returns the value stored at position `index` in the set. O(1).
842      *
843      * Note that there are no guarantees on the ordering of values inside the
844      * array, and it may change when more values are added or removed.
845      *
846      * Requirements:
847      *
848      * - `index` must be strictly less than {length}.
849      */
850     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
851         return _at(set._inner, index);
852     }
853 
854     // AddressSet
855 
856     struct AddressSet {
857         Set _inner;
858     }
859 
860     /**
861      * @dev Add a value to a set. O(1).
862      *
863      * Returns true if the value was added to the set, that is if it was not
864      * already present.
865      */
866     function add(AddressSet storage set, address value) internal returns (bool) {
867         return _add(set._inner, bytes32(uint256(uint160(value))));
868     }
869 
870     /**
871      * @dev Removes a value from a set. O(1).
872      *
873      * Returns true if the value was removed from the set, that is if it was
874      * present.
875      */
876     function remove(AddressSet storage set, address value) internal returns (bool) {
877         return _remove(set._inner, bytes32(uint256(uint160(value))));
878     }
879 
880     /**
881      * @dev Returns true if the value is in the set. O(1).
882      */
883     function contains(AddressSet storage set, address value) internal view returns (bool) {
884         return _contains(set._inner, bytes32(uint256(uint160(value))));
885     }
886 
887     /**
888      * @dev Returns the number of values in the set. O(1).
889      */
890     function length(AddressSet storage set) internal view returns (uint256) {
891         return _length(set._inner);
892     }
893 
894     /**
895      * @dev Returns the value stored at position `index` in the set. O(1).
896      *
897      * Note that there are no guarantees on the ordering of values inside the
898      * array, and it may change when more values are added or removed.
899      *
900      * Requirements:
901      *
902      * - `index` must be strictly less than {length}.
903      */
904     function at(AddressSet storage set, uint256 index) internal view returns (address) {
905         return address(uint160(uint256(_at(set._inner, index))));
906     }
907 
908     // UintSet
909 
910     struct UintSet {
911         Set _inner;
912     }
913 
914     /**
915      * @dev Add a value to a set. O(1).
916      *
917      * Returns true if the value was added to the set, that is if it was not
918      * already present.
919      */
920     function add(UintSet storage set, uint256 value) internal returns (bool) {
921         return _add(set._inner, bytes32(value));
922     }
923 
924     /**
925      * @dev Removes a value from a set. O(1).
926      *
927      * Returns true if the value was removed from the set, that is if it was
928      * present.
929      */
930     function remove(UintSet storage set, uint256 value) internal returns (bool) {
931         return _remove(set._inner, bytes32(value));
932     }
933 
934     /**
935      * @dev Returns true if the value is in the set. O(1).
936      */
937     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
938         return _contains(set._inner, bytes32(value));
939     }
940 
941     /**
942      * @dev Returns the number of values on the set. O(1).
943      */
944     function length(UintSet storage set) internal view returns (uint256) {
945         return _length(set._inner);
946     }
947 
948     /**
949      * @dev Returns the value stored at position `index` in the set. O(1).
950      *
951      * Note that there are no guarantees on the ordering of values inside the
952      * array, and it may change when more values are added or removed.
953      *
954      * Requirements:
955      *
956      * - `index` must be strictly less than {length}.
957      */
958     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
959         return uint256(_at(set._inner, index));
960     }
961 }
962 
963 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
964 
965 
966 
967 pragma solidity ^0.8.0;
968 
969 /**
970  * @dev Contract module that helps prevent reentrant calls to a function.
971  *
972  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
973  * available, which can be applied to functions to make sure there are no nested
974  * (reentrant) calls to them.
975  *
976  * Note that because there is a single `nonReentrant` guard, functions marked as
977  * `nonReentrant` may not call one another. This can be worked around by making
978  * those functions `private`, and then adding `external` `nonReentrant` entry
979  * points to them.
980  *
981  * TIP: If you would like to learn more about reentrancy and alternative ways
982  * to protect against it, check out our blog post
983  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
984  */
985 abstract contract ReentrancyGuard {
986     // Booleans are more expensive than uint256 or any type that takes up a full
987     // word because each write operation emits an extra SLOAD to first read the
988     // slot's contents, replace the bits taken up by the boolean, and then write
989     // back. This is the compiler's defense against contract upgrades and
990     // pointer aliasing, and it cannot be disabled.
991 
992     // The values being non-zero value makes deployment a bit more expensive,
993     // but in exchange the refund on every call to nonReentrant will be lower in
994     // amount. Since refunds are capped to a percentage of the total
995     // transaction's gas, it is best to keep them low in cases like this one, to
996     // increase the likelihood of the full refund coming into effect.
997     uint256 private constant _NOT_ENTERED = 1;
998     uint256 private constant _ENTERED = 2;
999 
1000     uint256 private _status;
1001 
1002     constructor() {
1003         _status = _NOT_ENTERED;
1004     }
1005 
1006     /**
1007      * @dev Prevents a contract from calling itself, directly or indirectly.
1008      * Calling a `nonReentrant` function from another `nonReentrant`
1009      * function is not supported. It is possible to prevent this from happening
1010      * by making the `nonReentrant` function external, and make it call a
1011      * `private` function that does the actual work.
1012      */
1013     modifier nonReentrant() {
1014         // On the first call to nonReentrant, _notEntered will be true
1015         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1016 
1017         // Any calls to nonReentrant after this point will fail
1018         _status = _ENTERED;
1019 
1020         _;
1021 
1022         // By storing the original value once again, a refund is triggered (see
1023         // https://eips.ethereum.org/EIPS/eip-2200)
1024         _status = _NOT_ENTERED;
1025     }
1026 }
1027 
1028 // File: @openzeppelin/contracts/utils/Context.sol
1029 
1030 
1031 
1032 pragma solidity ^0.8.0;
1033 
1034 /*
1035  * @dev Provides information about the current execution context, including the
1036  * sender of the transaction and its data. While these are generally available
1037  * via msg.sender and msg.data, they should not be accessed in such a direct
1038  * manner, since when dealing with meta-transactions the account sending and
1039  * paying for execution may not be the actual sender (as far as an application
1040  * is concerned).
1041  *
1042  * This contract is only required for intermediate, library-like contracts.
1043  */
1044 abstract contract Context {
1045     function _msgSender() internal view virtual returns (address) {
1046         return msg.sender;
1047     }
1048 
1049     function _msgData() internal view virtual returns (bytes calldata) {
1050         return msg.data;
1051     }
1052 }
1053 
1054 // File: contracts/core/IERC2309.sol
1055 
1056 
1057 
1058 pragma solidity 0.8.4;
1059 
1060 /**
1061   @title ERC-2309: ERC-721 Batch Mint Extension
1062   @dev https://github.com/ethereum/EIPs/issues/2309
1063  */
1064 interface IERC2309 {
1065     /**
1066       @notice This event is emitted when ownership of a batch of tokens changes by any mechanism.
1067       This includes minting, transferring, and burning.
1068 
1069       @dev The address executing the transaction MUST own all the tokens within the range of
1070       fromTokenId and toTokenId, or MUST be an approved operator to act on the owners behalf.
1071       The fromTokenId and toTokenId MUST be a sequential range of tokens IDs.
1072       When minting/creating tokens, the `fromAddress` argument MUST be set to `0x0` (i.e. zero address).
1073       When burning/destroying tokens, the `toAddress` argument MUST be set to `0x0` (i.e. zero address).
1074 
1075       @param fromTokenId The token ID that begins the batch of tokens being transferred
1076       @param toTokenId The token ID that ends the batch of tokens being transferred
1077       @param fromAddress The address transferring ownership of the specified range of tokens
1078       @param toAddress The address receiving ownership of the specified range of tokens.
1079     */
1080     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed fromAddress, address indexed toAddress);
1081 }
1082 
1083 // File: contracts/core/IHasSecondarySaleFees.sol
1084 
1085 
1086 
1087 pragma solidity 0.8.4;
1088 
1089 
1090 /// @title Royalties formats required for use on the Rarible platform
1091 /// @dev https://docs.rarible.com/asset/royalties-schema
1092 interface IHasSecondarySaleFees is IERC165 {
1093 
1094     event SecondarySaleFees(uint256 tokenId, address[] recipients, uint[] bps);
1095 
1096     function getFeeRecipients(uint256 id) external returns (address payable[] memory);
1097 
1098     function getFeeBps(uint256 id) external returns (uint[] memory);
1099 }
1100 
1101 // File: contracts/core/IKODAV3.sol
1102 
1103 
1104 
1105 pragma solidity 0.8.4;
1106 
1107 
1108 
1109 
1110 
1111 
1112 /// @title Core KODA V3 functionality
1113 interface IKODAV3 is
1114 IERC165, // Contract introspection
1115 IERC721, // Core NFTs
1116 IERC2309, // Consecutive batch mint
1117 IERC2981, // Royalties
1118 IHasSecondarySaleFees // Rariable / Foundation royalties
1119 {
1120     // edition utils
1121 
1122     function getCreatorOfEdition(uint256 _editionId) external view returns (address _originalCreator);
1123 
1124     function getCreatorOfToken(uint256 _tokenId) external view returns (address _originalCreator);
1125 
1126     function getSizeOfEdition(uint256 _editionId) external view returns (uint256 _size);
1127 
1128     function getEditionSizeOfToken(uint256 _tokenId) external view returns (uint256 _size);
1129 
1130     function editionExists(uint256 _editionId) external view returns (bool);
1131 
1132     // Has the edition been disabled / soft burnt
1133     function isEditionSalesDisabled(uint256 _editionId) external view returns (bool);
1134 
1135     // Has the edition been disabled / soft burnt OR sold out
1136     function isSalesDisabledOrSoldOut(uint256 _editionId) external view returns (bool);
1137 
1138     // Work out the max token ID for an edition ID
1139     function maxTokenIdOfEdition(uint256 _editionId) external view returns (uint256 _tokenId);
1140 
1141     // Helper method for getting the next primary sale token from an edition starting low to high token IDs
1142     function getNextAvailablePrimarySaleToken(uint256 _editionId) external returns (uint256 _tokenId);
1143 
1144     // Helper method for getting the next primary sale token from an edition starting high to low token IDs
1145     function getReverseAvailablePrimarySaleToken(uint256 _editionId) external view returns (uint256 _tokenId);
1146 
1147     // Utility method to get all data needed for the next primary sale, low token ID to high
1148     function facilitateNextPrimarySale(uint256 _editionId) external returns (address _receiver, address _creator, uint256 _tokenId);
1149 
1150     // Utility method to get all data needed for the next primary sale, high token ID to low
1151     function facilitateReversePrimarySale(uint256 _editionId) external returns (address _receiver, address _creator, uint256 _tokenId);
1152 
1153     // Expanded royalty method for the edition, not token
1154     function royaltyAndCreatorInfo(uint256 _editionId, uint256 _value) external returns (address _receiver, address _creator, uint256 _amount);
1155 
1156     // Allows the creator to correct mistakes until the first token from an edition is sold
1157     function updateURIIfNoSaleMade(uint256 _editionId, string calldata _newURI) external;
1158 
1159     // Has any primary transfer happened from an edition
1160     function hasMadePrimarySale(uint256 _editionId) external view returns (bool);
1161 
1162     // Has the edition sold out
1163     function isEditionSoldOut(uint256 _editionId) external view returns (bool);
1164 
1165     // Toggle on/off the edition from being able to make sales
1166     function toggleEditionSalesDisabled(uint256 _editionId) external;
1167 
1168     // token utils
1169 
1170     function exists(uint256 _tokenId) external view returns (bool);
1171 
1172     function getEditionIdOfToken(uint256 _tokenId) external pure returns (uint256 _editionId);
1173 
1174     function getEditionDetails(uint256 _tokenId) external view returns (address _originalCreator, address _owner, uint16 _size, uint256 _editionId, string memory _uri);
1175 
1176     function hadPrimarySaleOfToken(uint256 _tokenId) external view returns (bool);
1177 
1178 }
1179 
1180 // File: contracts/core/composable/TopDownERC20Composable.sol
1181 
1182 
1183 
1184 pragma solidity 0.8.4;
1185 
1186 
1187 
1188 
1189 
1190 
1191 
1192 interface ERC998ERC20TopDown {
1193     event ReceivedERC20(address indexed _from, uint256 indexed _tokenId, address indexed _erc20Contract, uint256 _value);
1194     event ReceivedERC20ForEdition(address indexed _from, uint256 indexed _editionId, address indexed _erc20Contract, uint256 _value);
1195     event TransferERC20(uint256 indexed _tokenId, address indexed _to, address indexed _erc20Contract, uint256 _value);
1196 
1197     function balanceOfERC20(uint256 _tokenId, address _erc20Contract) external view returns (uint256);
1198 
1199     function transferERC20(uint256 _tokenId, address _to, address _erc20Contract, uint256 _value) external;
1200 
1201     function getERC20(address _from, uint256 _tokenId, address _erc20Contract, uint256 _value) external;
1202 }
1203 
1204 interface ERC998ERC20TopDownEnumerable {
1205     function totalERC20Contracts(uint256 _tokenId) external view returns (uint256);
1206 
1207     function erc20ContractByIndex(uint256 _tokenId, uint256 _index) external view returns (address);
1208 }
1209 
1210 /// @notice ERC998 ERC721 > ERC20 Top Down implementation
1211 abstract contract TopDownERC20Composable is ERC998ERC20TopDown, ERC998ERC20TopDownEnumerable, ReentrancyGuard, Context {
1212     using EnumerableSet for EnumerableSet.AddressSet;
1213 
1214     // Edition ID -> ERC20 contract -> Balance of ERC20 for every token in Edition
1215     mapping(uint256 => mapping(address => uint256)) public editionTokenERC20Balances;
1216 
1217     // Edition ID -> ERC20 contract -> Token ID -> Balance Transferred out of token
1218     mapping(uint256 => mapping(address => mapping(uint256 => uint256))) public editionTokenERC20TransferAmounts;
1219 
1220     // Edition ID -> Linked ERC20 contract addresses
1221     mapping(uint256 => EnumerableSet.AddressSet) ERC20sEmbeddedInEdition;
1222 
1223     // Token ID -> Linked ERC20 contract addresses
1224     mapping(uint256 => EnumerableSet.AddressSet) ERC20sEmbeddedInNft;
1225 
1226     // Token ID -> ERC20 contract -> balance of ERC20 owned by token
1227     mapping(uint256 => mapping(address => uint256)) public ERC20Balances;
1228 
1229     /// @notice the ERC20 balance of a NFT token given an ERC20 token address
1230     function balanceOfERC20(uint256 _tokenId, address _erc20Contract) public override view returns (uint256) {
1231         IKODAV3 koda = IKODAV3(address(this));
1232         uint256 editionId = koda.getEditionIdOfToken(_tokenId);
1233 
1234         uint256 editionBalance = editionTokenERC20Balances[editionId][_erc20Contract];
1235         uint256 tokenEditionBalance = editionBalance / koda.getSizeOfEdition(editionId);
1236         uint256 spentTokens = editionTokenERC20TransferAmounts[editionId][_erc20Contract][_tokenId];
1237         tokenEditionBalance = tokenEditionBalance - spentTokens;
1238 
1239         return tokenEditionBalance + ERC20Balances[_tokenId][_erc20Contract];
1240     }
1241 
1242     /// @notice Transfer out an ERC20 from an NFT
1243     function transferERC20(uint256 _tokenId, address _to, address _erc20Contract, uint256 _value) external override nonReentrant {
1244         _prepareERC20LikeTransfer(_tokenId, _to, _erc20Contract, _value);
1245 
1246         IERC20(_erc20Contract).transfer(_to, _value);
1247 
1248         emit TransferERC20(_tokenId, _to, _erc20Contract, _value);
1249     }
1250 
1251     /// @notice An NFT token owner (or approved) can compose multiple ERC20s in their NFT
1252     function getERC20s(address _from, uint256[] calldata _tokenIds, address _erc20Contract, uint256 _totalValue) external {
1253         uint256 totalTokens = _tokenIds.length;
1254         require(totalTokens > 0 && _totalValue > 0, "Empty values");
1255 
1256         uint256 valuePerToken = _totalValue / totalTokens;
1257         for (uint i = 0; i < totalTokens; i++) {
1258             getERC20(_from, _tokenIds[i], _erc20Contract, valuePerToken);
1259         }
1260     }
1261 
1262     /// @notice A NFT token owner (or approved address) can compose any ERC20 in their NFT
1263     function getERC20(address _from, uint256 _tokenId, address _erc20Contract, uint256 _value) public override nonReentrant {
1264         require(_value > 0, "Value zero");
1265         require(_from == _msgSender(), "Only owner");
1266 
1267         address spender = _msgSender();
1268         IERC721 self = IERC721(address(this));
1269 
1270         address owner = self.ownerOf(_tokenId);
1271         require(
1272             owner == spender || self.isApprovedForAll(owner, spender) || self.getApproved(_tokenId) == spender,
1273             "Invalid spender"
1274         );
1275 
1276         uint256 editionId = IKODAV3(address(this)).getEditionIdOfToken(_tokenId);
1277         bool editionAlreadyContainsERC20 = ERC20sEmbeddedInEdition[editionId].contains(_erc20Contract);
1278         bool nftAlreadyContainsERC20 = ERC20sEmbeddedInNft[_tokenId].contains(_erc20Contract);
1279 
1280         // does not already contain _erc20Contract
1281         if (!editionAlreadyContainsERC20 && !nftAlreadyContainsERC20) {
1282             ERC20sEmbeddedInNft[_tokenId].add(_erc20Contract);
1283         }
1284 
1285         ERC20Balances[_tokenId][_erc20Contract] = ERC20Balances[_tokenId][_erc20Contract] + _value;
1286 
1287         IERC20 token = IERC20(_erc20Contract);
1288         require(token.allowance(_from, address(this)) >= _value, "Exceeds allowance");
1289 
1290         token.transferFrom(_from, address(this), _value);
1291 
1292         emit ReceivedERC20(_from, _tokenId, _erc20Contract, _value);
1293     }
1294 
1295     function _composeERC20IntoEdition(address _from, uint256 _editionId, address _erc20Contract, uint256 _value) internal nonReentrant {
1296         require(_value > 0, "Value zero");
1297 
1298         require(!ERC20sEmbeddedInEdition[_editionId].contains(_erc20Contract), "Edition contains ERC20");
1299 
1300         ERC20sEmbeddedInEdition[_editionId].add(_erc20Contract);
1301         editionTokenERC20Balances[_editionId][_erc20Contract] = editionTokenERC20Balances[_editionId][_erc20Contract] + _value;
1302 
1303         IERC20(_erc20Contract).transferFrom(_from, address(this), _value);
1304 
1305         emit ReceivedERC20ForEdition(_from, _editionId, _erc20Contract, _value);
1306     }
1307 
1308     function totalERC20Contracts(uint256 _tokenId) override public view returns (uint256) {
1309         uint256 editionId = IKODAV3(address(this)).getEditionIdOfToken(_tokenId);
1310         return ERC20sEmbeddedInNft[_tokenId].length() + ERC20sEmbeddedInEdition[editionId].length();
1311     }
1312 
1313     function erc20ContractByIndex(uint256 _tokenId, uint256 _index) override external view returns (address) {
1314         uint256 numOfERC20sInNFT = ERC20sEmbeddedInNft[_tokenId].length();
1315         if (_index >= numOfERC20sInNFT) {
1316             uint256 editionId =  IKODAV3(address(this)).getEditionIdOfToken(_tokenId);
1317             return ERC20sEmbeddedInEdition[editionId].at(_index - numOfERC20sInNFT);
1318         }
1319 
1320         return ERC20sEmbeddedInNft[_tokenId].at(_index);
1321     }
1322 
1323     /// --- Internal ----
1324 
1325     function _prepareERC20LikeTransfer(uint256 _tokenId, address _to, address _erc20Contract, uint256 _value) private {
1326         // To avoid stack too deep, do input checks within this scope
1327         {
1328             require(_value > 0, "Value zero");
1329             require(_to != address(0), "Zero address");
1330 
1331             IERC721 self = IERC721(address(this));
1332 
1333             address owner = self.ownerOf(_tokenId);
1334             require(
1335                 owner == _msgSender() || self.isApprovedForAll(owner, _msgSender()) || self.getApproved(_tokenId) == _msgSender(),
1336                 "Not owner"
1337             );
1338         }
1339 
1340         // Check that the NFT contains the ERC20
1341         bool nftContainsERC20 = ERC20sEmbeddedInNft[_tokenId].contains(_erc20Contract);
1342 
1343         IKODAV3 koda = IKODAV3(address(this));
1344         uint256 editionId = koda.getEditionIdOfToken(_tokenId);
1345         bool editionContainsERC20 = ERC20sEmbeddedInEdition[editionId].contains(_erc20Contract);
1346         require(nftContainsERC20 || editionContainsERC20, "No such ERC20");
1347 
1348         // Check there is enough balance to transfer out
1349         require(balanceOfERC20(_tokenId, _erc20Contract) >= _value, "Exceeds balance");
1350 
1351         uint256 editionSize = koda.getSizeOfEdition(editionId);
1352         uint256 tokenInitialBalance = editionTokenERC20Balances[editionId][_erc20Contract] / editionSize;
1353         uint256 spentTokens = editionTokenERC20TransferAmounts[editionId][_erc20Contract][_tokenId];
1354         uint256 editionTokenBalance = tokenInitialBalance - spentTokens;
1355 
1356         // Check whether the value can be fully transferred from the edition balance, token balance or both balances
1357         if (editionTokenBalance >= _value) {
1358             editionTokenERC20TransferAmounts[editionId][_erc20Contract][_tokenId] = spentTokens + _value;
1359         } else if (ERC20Balances[_tokenId][_erc20Contract] >= _value) {
1360             ERC20Balances[_tokenId][_erc20Contract] = ERC20Balances[_tokenId][_erc20Contract] - _value;
1361         } else {
1362             // take from both balances
1363             editionTokenERC20TransferAmounts[editionId][_erc20Contract][_tokenId] = spentTokens + editionTokenBalance;
1364             uint256 amountOfTokensToSpendFromTokenBalance = _value - editionTokenBalance;
1365             ERC20Balances[_tokenId][_erc20Contract] = ERC20Balances[_tokenId][_erc20Contract] - amountOfTokensToSpendFromTokenBalance;
1366         }
1367 
1368         // The ERC20 is no longer composed within the token if the balance falls to zero
1369         if (nftContainsERC20 && ERC20Balances[_tokenId][_erc20Contract] == 0) {
1370             ERC20sEmbeddedInNft[_tokenId].remove(_erc20Contract);
1371         }
1372 
1373         // If all tokens in an edition have spent their ERC20 balance, then we can remove the link
1374         if (editionContainsERC20) {
1375             uint256 allTokensInEditionERC20Balance;
1376             for (uint i = 0; i < editionSize; i++) {
1377                 uint256 tokenBal = tokenInitialBalance - editionTokenERC20TransferAmounts[editionId][_erc20Contract][editionId + i];
1378                 allTokensInEditionERC20Balance = allTokensInEditionERC20Balance + tokenBal;
1379             }
1380 
1381             if (allTokensInEditionERC20Balance == 0) {
1382                 ERC20sEmbeddedInEdition[editionId].remove(_erc20Contract);
1383             }
1384         }
1385     }
1386 }
1387 
1388 // File: contracts/core/composable/TopDownSimpleERC721Composable.sol
1389 
1390 
1391 
1392 pragma solidity 0.8.4;
1393 
1394 
1395 
1396 abstract contract TopDownSimpleERC721Composable is Context {
1397     struct ComposedNFT {
1398         address nft;
1399         uint256 tokenId;
1400     }
1401 
1402     // KODA Token ID -> composed nft
1403     mapping(uint256 => ComposedNFT) public kodaTokenComposedNFT;
1404 
1405     // External NFT address -> External Token ID -> KODA token ID
1406     mapping(address => mapping(uint256 => uint256)) public composedNFTsToKodaToken;
1407 
1408     event ReceivedChild(address indexed _from, uint256 indexed _tokenId, address indexed _childContract, uint256 _childTokenId);
1409     event TransferChild(uint256 indexed _tokenId, address indexed _to, address indexed _childContract, uint256 _childTokenId);
1410 
1411     /// @notice compose a set of the same child ERC721s into a KODA tokens
1412     /// @notice Caller must own both KODA and child NFT tokens
1413     function composeNFTsIntoKodaTokens(uint256[] calldata _kodaTokenIds, address _nft, uint256[] calldata _nftTokenIds) external {
1414         uint256 totalKodaTokens = _kodaTokenIds.length;
1415         require(totalKodaTokens > 0 && totalKodaTokens == _nftTokenIds.length, "Invalid list");
1416 
1417         IERC721 nftContract = IERC721(_nft);
1418 
1419         for (uint i = 0; i < totalKodaTokens; i++) {
1420             uint256 _kodaTokenId = _kodaTokenIds[i];
1421             uint256 _nftTokenId = _nftTokenIds[i];
1422 
1423             require(
1424                 IERC721(address(this)).ownerOf(_kodaTokenId) == nftContract.ownerOf(_nftTokenId),
1425                 "Owner mismatch"
1426             );
1427 
1428             kodaTokenComposedNFT[_kodaTokenId] = ComposedNFT(_nft, _nftTokenId);
1429             composedNFTsToKodaToken[_nft][_nftTokenId] = _kodaTokenId;
1430 
1431             nftContract.transferFrom(_msgSender(), address(this), _nftTokenId);
1432             emit ReceivedChild(_msgSender(), _kodaTokenId, _nft, _nftTokenId);
1433         }
1434     }
1435 
1436     /// @notice Transfer a child 721 wrapped within a KODA token to a given recipient
1437     /// @notice only KODA token owner can call this
1438     function transferChild(uint256 _kodaTokenId, address _recipient) external {
1439         require(
1440             IERC721(address(this)).ownerOf(_kodaTokenId) == _msgSender(),
1441             "Only KODA owner"
1442         );
1443 
1444         address nft = kodaTokenComposedNFT[_kodaTokenId].nft;
1445         uint256 nftId = kodaTokenComposedNFT[_kodaTokenId].tokenId;
1446 
1447         delete kodaTokenComposedNFT[_kodaTokenId];
1448         delete composedNFTsToKodaToken[nft][nftId];
1449 
1450         IERC721(nft).transferFrom(address(this), _recipient, nftId);
1451 
1452         emit TransferChild(_kodaTokenId, _recipient, nft, nftId);
1453     }
1454 }
1455 
1456 // File: contracts/core/Konstants.sol
1457 
1458 
1459 
1460 pragma solidity 0.8.4;
1461 
1462 contract Konstants {
1463 
1464     // Every edition always goes up in batches of 1000
1465     uint16 public constant MAX_EDITION_SIZE = 1000;
1466 
1467     // magic method that defines the maximum range for an edition - this is fixed forever - tokens are minted in range
1468     function _editionFromTokenId(uint256 _tokenId) internal pure returns (uint256) {
1469         return (_tokenId / MAX_EDITION_SIZE) * MAX_EDITION_SIZE;
1470     }
1471 }
1472 
1473 // File: contracts/core/BaseKoda.sol
1474 
1475 
1476 
1477 pragma solidity 0.8.4;
1478 
1479 
1480 
1481 
1482 
1483 
1484 abstract contract BaseKoda is Konstants, Context, IKODAV3 {
1485 
1486     bytes4 constant internal ERC721_RECEIVED = bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
1487 
1488     event AdminUpdateSecondaryRoyalty(uint256 _secondarySaleRoyalty);
1489     event AdminUpdateBasisPointsModulo(uint256 _basisPointsModulo);
1490     event AdminUpdateModulo(uint256 _modulo);
1491     event AdminEditionReported(uint256 indexed _editionId, bool indexed _reported);
1492     event AdminArtistAccountReported(address indexed _account, bool indexed _reported);
1493     event AdminUpdateAccessControls(IKOAccessControlsLookup indexed _oldAddress, IKOAccessControlsLookup indexed _newAddress);
1494 
1495     modifier onlyContract(){
1496         _onlyContract();
1497         _;
1498     }
1499 
1500     function _onlyContract() private view {
1501         require(accessControls.hasContractRole(_msgSender()), "Must be contract");
1502     }
1503 
1504     modifier onlyAdmin(){
1505         _onlyAdmin();
1506         _;
1507     }
1508 
1509     function _onlyAdmin() private view {
1510         require(accessControls.hasAdminRole(_msgSender()), "Must be admin");
1511     }
1512 
1513     IKOAccessControlsLookup public accessControls;
1514 
1515     // A onchain reference to editions which have been reported for some infringement purposes to KO
1516     mapping(uint256 => bool) public reportedEditionIds;
1517 
1518     // A onchain reference to accounts which have been lost/hacked etc
1519     mapping(address => bool) public reportedArtistAccounts;
1520 
1521     // Secondary sale commission
1522     uint256 public secondarySaleRoyalty = 12_50000; // 12.5% by default
1523 
1524     /// @notice precision 100.00000%
1525     uint256 public modulo = 100_00000;
1526 
1527     /// @notice Basis points conversion modulo
1528     /// @notice This is used by the IHasSecondarySaleFees implementation which is different than EIP-2981 specs
1529     uint256 public basisPointsModulo = 1000;
1530 
1531     constructor(IKOAccessControlsLookup _accessControls) {
1532         accessControls = _accessControls;
1533     }
1534 
1535     function reportEditionId(uint256 _editionId, bool _reported) onlyAdmin public {
1536         reportedEditionIds[_editionId] = _reported;
1537         emit AdminEditionReported(_editionId, _reported);
1538     }
1539 
1540     function reportArtistAccount(address _account, bool _reported) onlyAdmin public {
1541         reportedArtistAccounts[_account] = _reported;
1542         emit AdminArtistAccountReported(_account, _reported);
1543     }
1544 
1545     function updateBasisPointsModulo(uint256 _basisPointsModulo) onlyAdmin public {
1546         require(_basisPointsModulo > 0, "Is zero");
1547         basisPointsModulo = _basisPointsModulo;
1548         emit AdminUpdateBasisPointsModulo(_basisPointsModulo);
1549     }
1550 
1551     function updateModulo(uint256 _modulo) onlyAdmin public {
1552         require(_modulo > 0, "Is zero");
1553         modulo = _modulo;
1554         emit AdminUpdateModulo(_modulo);
1555     }
1556 
1557     function updateSecondaryRoyalty(uint256 _secondarySaleRoyalty) onlyAdmin public {
1558         secondarySaleRoyalty = _secondarySaleRoyalty;
1559         emit AdminUpdateSecondaryRoyalty(_secondarySaleRoyalty);
1560     }
1561 
1562     function updateAccessControls(IKOAccessControlsLookup _accessControls) public onlyAdmin {
1563         require(_accessControls.hasAdminRole(_msgSender()), "Must be admin");
1564         emit AdminUpdateAccessControls(accessControls, _accessControls);
1565         accessControls = _accessControls;
1566     }
1567 
1568     /// @dev Allows for the ability to extract stuck ERC20 tokens
1569     /// @dev Only callable from admin
1570     function withdrawStuckTokens(address _tokenAddress, uint256 _amount, address _withdrawalAccount) onlyAdmin public {
1571         IERC20(_tokenAddress).transfer(_withdrawalAccount, _amount);
1572     }
1573 }
1574 
1575 // File: contracts/core/KnownOriginDigitalAssetV3.sol
1576 
1577 
1578 
1579 pragma solidity 0.8.4;
1580 
1581 
1582 
1583 
1584 
1585 
1586 
1587 
1588 
1589 
1590 
1591 /// @title A ERC-721 compliant contract which has a focus on being GAS efficient along with being able to support
1592 /// both unique tokens and multi-editions sharing common traits but of limited supply
1593 ///
1594 /// @author KnownOrigin Labs - https://knownorigin.io/
1595 ///
1596 /// @notice The NFT supports a range of standards such as:
1597 /// @notice EIP-2981 Royalties Standard
1598 /// @notice EIP-2309 Consecutive batch mint
1599 /// @notice ERC-998 Top-down ERC-20 composable
1600 contract KnownOriginDigitalAssetV3 is
1601 TopDownERC20Composable,
1602 TopDownSimpleERC721Composable,
1603 BaseKoda,
1604 ERC165Storage,
1605 IKODAV3Minter {
1606 
1607     event EditionURIUpdated(uint256 indexed _editionId);
1608     event EditionSalesDisabledToggled(uint256 indexed _editionId, bool _oldValue, bool _newValue);
1609     event SealedEditionMetaDataSet(uint256 indexed _editionId);
1610     event SealedTokenMetaDataSet(uint256 indexed _tokenId);
1611     event AdditionalEditionUnlockableSet(uint256 indexed _editionId);
1612     event AdminRoyaltiesRegistryProxySet(address indexed _royaltiesRegistryProxy);
1613     event AdminTokenUriResolverSet(address indexed _tokenUriResolver);
1614 
1615     modifier validateEdition(uint256 _editionId) {
1616         _validateEdition(_editionId);
1617         _;
1618     }
1619 
1620     function _validateEdition(uint256 _editionId) private view {
1621         require(_editionExists(_editionId), "Edition does not exist");
1622     }
1623 
1624     modifier validateCreator(uint256 _editionId) {
1625         address creator = getCreatorOfEdition(_editionId);
1626         require(
1627             _msgSender() == creator || accessControls.isVerifiedArtistProxy(creator, _msgSender()),
1628             "Only creator or proxy"
1629         );
1630         _;
1631     }
1632 
1633     /// @notice Token name
1634     string public constant name = "KnownOriginDigitalAsset";
1635 
1636     /// @notice Token symbol
1637     string public constant symbol = "KODA";
1638 
1639     /// @notice KODA version
1640     string public constant version = "3";
1641 
1642     /// @notice Royalties registry
1643     IERC2981 public royaltiesRegistryProxy;
1644 
1645     /// @notice Token URI resolver
1646     ITokenUriResolver public tokenUriResolver;
1647 
1648     /// @notice Edition number pointer
1649     uint256 public editionPointer;
1650 
1651     struct EditionDetails {
1652         address creator; // primary edition/token creator
1653         uint16 editionSize; // onchain edition size
1654         string uri; // the referenced metadata
1655     }
1656 
1657     /// @dev tokens are minted in batches - the first token ID used is representative of the edition ID
1658     mapping(uint256 => EditionDetails) internal editionDetails;
1659 
1660     /// @dev Mapping of tokenId => owner - only set on first transfer (after mint) such as a primary sale and/or gift
1661     mapping(uint256 => address) internal owners;
1662 
1663     /// @dev Mapping of owner => number of tokens owned
1664     mapping(address => uint256) internal balances;
1665 
1666     /// @dev Mapping of tokenId => approved address
1667     mapping(uint256 => address) internal approvals;
1668 
1669     /// @dev Mapping of owner => operator => approved
1670     mapping(address => mapping(address => bool)) internal operatorApprovals;
1671 
1672     /// @notice Optional one time use storage slot for additional edition metadata
1673     mapping(uint256 => string) public sealedEditionMetaData;
1674 
1675     /// @notice Optional one time use storage slot for additional token metadata such ass peramweb metadata
1676     mapping(uint256 => string) public sealedTokenMetaData;
1677 
1678     /// @notice Allows a creator to disable sales of their edition
1679     mapping(uint256 => bool) public editionSalesDisabled;
1680 
1681     constructor(
1682         IKOAccessControlsLookup _accessControls,
1683         IERC2981 _royaltiesRegistryProxy,
1684         uint256 _editionPointer
1685     ) BaseKoda(_accessControls) {
1686         // starting point for new edition IDs
1687         editionPointer = _editionPointer;
1688 
1689         // optional registry address - can be constructed as zero address
1690         royaltiesRegistryProxy = _royaltiesRegistryProxy;
1691 
1692         // INTERFACE_ID_ERC721
1693         _registerInterface(0x80ac58cd);
1694 
1695         // INTERFACE_ID_ERC721_METADATA
1696         _registerInterface(0x5b5e139f);
1697 
1698         // _INTERFACE_ID_ERC2981
1699         _registerInterface(0x2a55205a);
1700 
1701         // _INTERFACE_ID_FEES
1702         _registerInterface(0xb7799584);
1703     }
1704 
1705     /// @notice Mints batches of tokens emitting multiple Transfer events
1706     function mintBatchEdition(uint16 _editionSize, address _to, string calldata _uri)
1707     public
1708     override
1709     onlyContract
1710     returns (uint256 _editionId) {
1711         return _mintBatchEdition(_editionSize, _to, _uri);
1712     }
1713 
1714     /// @notice Mints an edition token batch and composes ERC20s for every token in the edition
1715     function mintBatchEditionAndComposeERC20s(
1716         uint16 _editionSize,
1717         address _to,
1718         string calldata _uri,
1719         address[] calldata _erc20s,
1720         uint256[] calldata _amounts
1721     ) external
1722     override
1723     onlyContract
1724     returns (uint256 _editionId) {
1725         uint256 totalErc20s = _erc20s.length;
1726         require(totalErc20s > 0 && totalErc20s == _amounts.length, "Tokens invalid");
1727 
1728         _editionId = _mintBatchEdition(_editionSize, _to, _uri);
1729 
1730         for (uint i = 0; i < totalErc20s; i++) {
1731             _composeERC20IntoEdition(_to, _editionId, _erc20s[i], _amounts[i]);
1732         }
1733     }
1734 
1735     function _mintBatchEdition(uint16 _editionSize, address _to, string calldata _uri) internal returns (uint256) {
1736         require(_editionSize > 0 && _editionSize <= MAX_EDITION_SIZE, "Invalid size");
1737 
1738         uint256 start = generateNextEditionNumber();
1739 
1740         // N.B: Dont store owner, see ownerOf method to special case checking to avoid storage costs on creation
1741 
1742         // assign balance
1743         balances[_to] = balances[_to] + _editionSize;
1744 
1745         // edition of x
1746         editionDetails[start] = EditionDetails(_to, _editionSize, _uri);
1747 
1748         // Loop emit all transfer events
1749         uint256 end = start + _editionSize;
1750         for (uint i = start; i < end; i++) {
1751             emit Transfer(address(0), _to, i);
1752         }
1753         return start;
1754     }
1755 
1756     /// @notice Mints batches of tokens but emits a single ConsecutiveTransfer event EIP-2309
1757     function mintConsecutiveBatchEdition(uint16 _editionSize, address _to, string calldata _uri)
1758     public
1759     override
1760     onlyContract
1761     returns (uint256 _editionId) {
1762         require(_editionSize > 0 && _editionSize <= MAX_EDITION_SIZE, "Invalid size");
1763 
1764         uint256 start = generateNextEditionNumber();
1765 
1766         // N.B: Dont store owner, see ownerOf method to special case checking to avoid storage costs on creation
1767 
1768         // assign balance
1769         balances[_to] = balances[_to] + _editionSize;
1770 
1771         // Start ID always equals edition ID
1772         editionDetails[start] = EditionDetails(_to, _editionSize, _uri);
1773 
1774         // emit EIP-2309 consecutive transfer event
1775         emit ConsecutiveTransfer(start, start + _editionSize, address(0), _to);
1776 
1777         return start;
1778     }
1779 
1780     /// @notice Allows the creator of an edition to update the token URI provided that no primary sales have been made
1781     function updateURIIfNoSaleMade(uint256 _editionId, string calldata _newURI)
1782     external
1783     override
1784     validateCreator(_editionId) {
1785         require(
1786             !hasMadePrimarySale(_editionId) && (!tokenUriResolverActive() || !tokenUriResolver.isDefined(_editionId, 0)),
1787             "Invalid state"
1788         );
1789 
1790         editionDetails[_editionId].uri = _newURI;
1791 
1792         emit EditionURIUpdated(_editionId);
1793     }
1794 
1795     /// @notice Increases the edition pointer and then returns this pointer for minting methods
1796     function generateNextEditionNumber() internal returns (uint256) {
1797         editionPointer = editionPointer + MAX_EDITION_SIZE;
1798         return editionPointer;
1799     }
1800 
1801     /// @notice URI for an edition. Individual tokens in an edition will have this URI when tokenURI() is called
1802     function editionURI(uint256 _editionId) validateEdition(_editionId) public view returns (string memory) {
1803 
1804         // Here we are checking only that the edition has a edition level resolver - there may be a overridden token level resolver
1805         if (tokenUriResolverActive() && tokenUriResolver.isDefined(_editionId, 0)) {
1806             return tokenUriResolver.tokenURI(_editionId, 0);
1807         }
1808 
1809         return editionDetails[_editionId].uri;
1810     }
1811 
1812     /// @notice Returns the URI based on the edition associated with a token
1813     function tokenURI(uint256 _tokenId) public view returns (string memory) {
1814         require(_exists(_tokenId), "Token does not exist");
1815         uint256 editionId = _editionFromTokenId(_tokenId);
1816 
1817         if (tokenUriResolverActive() && tokenUriResolver.isDefined(editionId, _tokenId)) {
1818             return tokenUriResolver.tokenURI(editionId, _tokenId);
1819         }
1820 
1821         return editionDetails[editionId].uri;
1822     }
1823 
1824     /// @notice Allows the caller to check if external URI resolver is active
1825     function tokenUriResolverActive() public view returns (bool) {
1826         return address(tokenUriResolver) != address(0);
1827     }
1828 
1829     /// @notice Additional metadata string for an edition
1830     function editionAdditionalMetaData(uint256 _editionId) public view returns (string memory) {
1831         return sealedEditionMetaData[_editionId];
1832     }
1833 
1834     /// @notice Additional metadata string for a token
1835     function tokenAdditionalMetaData(uint256 _tokenId) public view returns (string memory) {
1836         return sealedTokenMetaData[_tokenId];
1837     }
1838 
1839     /// @notice Additional metadata string for an edition given a token ID
1840     function editionAdditionalMetaDataForToken(uint256 _tokenId) public view returns (string memory) {
1841         uint256 editionId = _editionFromTokenId(_tokenId);
1842         return sealedEditionMetaData[editionId];
1843     }
1844 
1845     function getEditionDetails(uint256 _tokenId)
1846     public
1847     override
1848     view
1849     returns (address _originalCreator, address _owner, uint16 _size, uint256 _editionId, string memory _uri) {
1850         uint256 editionId = _editionFromTokenId(_tokenId);
1851         EditionDetails storage edition = editionDetails[editionId];
1852         return (
1853         edition.creator,
1854         _ownerOf(_tokenId, editionId),
1855         edition.editionSize,
1856         editionId,
1857         tokenURI(_tokenId)
1858         );
1859     }
1860 
1861 
1862     /// @notice If primary sales for an edition are disabled
1863     function isEditionSalesDisabled(uint256 _editionId) external view override returns (bool) {
1864         return editionSalesDisabled[_editionId];
1865     }
1866 
1867     /// @notice If primary sales for an edition are disabled or if the edition is sold out
1868     function isSalesDisabledOrSoldOut(uint256 _editionId) external view override returns (bool) {
1869         return editionSalesDisabled[_editionId] || isEditionSoldOut(_editionId);
1870     }
1871 
1872     /// @notice Toggle for disabling primary sales for an edition
1873     function toggleEditionSalesDisabled(uint256 _editionId) validateEdition(_editionId) external override {
1874         address creator = editionDetails[_editionId].creator;
1875 
1876         require(
1877             creator == _msgSender() || accessControls.hasAdminRole(_msgSender()),
1878             "Only creator or admin"
1879         );
1880 
1881         emit EditionSalesDisabledToggled(_editionId, editionSalesDisabled[_editionId], !editionSalesDisabled[_editionId]);
1882 
1883         editionSalesDisabled[_editionId] = !editionSalesDisabled[_editionId];
1884     }
1885 
1886     ///////////////////
1887     // Creator query //
1888     ///////////////////
1889 
1890     function getCreatorOfEdition(uint256 _editionId) public override view returns (address _originalCreator) {
1891         return _getCreatorOfEdition(_editionId);
1892     }
1893 
1894     function getCreatorOfToken(uint256 _tokenId) public override view returns (address _originalCreator) {
1895         return _getCreatorOfEdition(_editionFromTokenId(_tokenId));
1896     }
1897 
1898     function _getCreatorOfEdition(uint256 _editionId) internal view returns (address _originalCreator) {
1899         return editionDetails[_editionId].creator;
1900     }
1901 
1902     ////////////////
1903     // Size query //
1904     ////////////////
1905 
1906     function getSizeOfEdition(uint256 _editionId) public override view returns (uint256 _size) {
1907         return editionDetails[_editionId].editionSize;
1908     }
1909 
1910     function getEditionSizeOfToken(uint256 _tokenId) public override view returns (uint256 _size) {
1911         return editionDetails[_editionFromTokenId(_tokenId)].editionSize;
1912     }
1913 
1914     /////////////////////
1915     // Existence query //
1916     /////////////////////
1917 
1918     function editionExists(uint256 _editionId) public override view returns (bool) {
1919         return _editionExists(_editionId);
1920     }
1921 
1922     function _editionExists(uint256 _editionId) internal view returns (bool) {
1923         return editionDetails[_editionId].editionSize > 0;
1924     }
1925 
1926     function exists(uint256 _tokenId) public override view returns (bool) {
1927         return _exists(_tokenId);
1928     }
1929 
1930     function _exists(uint256 _tokenId) internal view returns (bool) {
1931         return _ownerOf(_tokenId, _editionFromTokenId(_tokenId)) != address(0);
1932     }
1933 
1934     /// @notice Returns the last token ID of an edition based on the edition's size
1935     function maxTokenIdOfEdition(uint256 _editionId) public override view returns (uint256 _tokenId) {
1936         return _maxTokenIdOfEdition(_editionId);
1937     }
1938 
1939     function _maxTokenIdOfEdition(uint256 _editionId) internal view returns (uint256 _tokenId) {
1940         return editionDetails[_editionId].editionSize + _editionId;
1941     }
1942 
1943     ////////////////
1944     // Edition ID //
1945     ////////////////
1946 
1947     function getEditionIdOfToken(uint256 _tokenId) public override pure returns (uint256 _editionId) {
1948         return _editionFromTokenId(_tokenId);
1949     }
1950 
1951     function _royaltyInfo(uint256 _tokenId, uint256 _value) internal view returns (address _receiver, uint256 _royaltyAmount) {
1952         uint256 editionId = _editionFromTokenId(_tokenId);
1953         // If we have a registry and its defined, use it
1954         if (royaltyRegistryActive() && royaltiesRegistryProxy.hasRoyalties(editionId)) {
1955             // Note: any registry must be edition aware so to only store one entry for all within the edition
1956             (_receiver, _royaltyAmount) = royaltiesRegistryProxy.royaltyInfo(editionId, _value);
1957         } else {
1958             // Fall back to KO defaults
1959             _receiver = _getCreatorOfEdition(editionId);
1960             _royaltyAmount = (_value / modulo) * secondarySaleRoyalty;
1961         }
1962     }
1963 
1964     //////////////
1965     // ERC-2981 //
1966     //////////////
1967 
1968     // Abstract away token royalty registry, proxy through to the implementation
1969     function royaltyInfo(uint256 _tokenId, uint256 _value)
1970     external
1971     override
1972     view
1973     returns (address _receiver, uint256 _royaltyAmount) {
1974         return _royaltyInfo(_tokenId, _value);
1975     }
1976 
1977     // Expanded method at edition level and expanding on the funds receiver and the creator
1978     function royaltyAndCreatorInfo(uint256 _tokenId, uint256 _value)
1979     external
1980     view
1981     override
1982     returns (address receiver, address creator, uint256 royaltyAmount) {
1983         address originalCreator = _getCreatorOfEdition(_editionFromTokenId(_tokenId));
1984         (address _receiver, uint256 _royaltyAmount) = _royaltyInfo(_tokenId, _value);
1985         return (_receiver, originalCreator, _royaltyAmount);
1986     }
1987 
1988     function hasRoyalties(uint256 _editionId) validateEdition(_editionId) external override view returns (bool) {
1989         return royaltyRegistryActive() && royaltiesRegistryProxy.hasRoyalties(_editionId)
1990         || secondarySaleRoyalty > 0;
1991     }
1992 
1993     function getRoyaltiesReceiver(uint256 _tokenId) public override view returns (address) {
1994         uint256 editionId = _editionFromTokenId(_tokenId);
1995         if (royaltyRegistryActive() && royaltiesRegistryProxy.hasRoyalties(editionId)) {
1996             return royaltiesRegistryProxy.getRoyaltiesReceiver(editionId);
1997         }
1998         return _getCreatorOfEdition(editionId);
1999     }
2000 
2001     function royaltyRegistryActive() public view returns (bool) {
2002         return address(royaltiesRegistryProxy) != address(0);
2003     }
2004 
2005     //////////////////////////////
2006     // Has Secondary Sale Fees //
2007     ////////////////////////////
2008 
2009     function getFeeRecipients(uint256 _tokenId) external view override returns (address payable[] memory) {
2010         address payable[] memory feeRecipients = new address payable[](1);
2011         feeRecipients[0] = payable(getRoyaltiesReceiver(_tokenId));
2012         return feeRecipients;
2013     }
2014 
2015     function getFeeBps(uint256) external view override returns (uint[] memory) {
2016         uint[] memory feeBps = new uint[](1);
2017         feeBps[0] = uint(secondarySaleRoyalty) / basisPointsModulo;
2018         // convert to basis points
2019         return feeBps;
2020     }
2021 
2022     ////////////////////////////////////
2023     // Primary Sale Utilities methods //
2024     ////////////////////////////////////
2025 
2026     /// @notice List of token IDs that are still with the original creator
2027     function getAllUnsoldTokenIdsForEdition(uint256 _editionId) validateEdition(_editionId) public view returns (uint256[] memory) {
2028         uint256 maxTokenId = _maxTokenIdOfEdition(_editionId);
2029 
2030         // work out number of unsold tokens in order to allocate memory to an array later
2031         uint256 numOfUnsoldTokens;
2032         for (uint256 i = _editionId; i < maxTokenId; i++) {
2033             // if no owner set - assume primary if not moved
2034             if (owners[i] == address(0)) {
2035                 numOfUnsoldTokens += 1;
2036             }
2037         }
2038 
2039         uint256[] memory unsoldTokens = new uint256[](numOfUnsoldTokens);
2040 
2041         // record token IDs of unsold tokens
2042         uint256 nextIndex;
2043         for (uint256 tokenId = _editionId; tokenId < maxTokenId; tokenId++) {
2044             // if no owner set - assume primary if not moved
2045             if (owners[tokenId] == address(0)) {
2046                 unsoldTokens[nextIndex] = tokenId;
2047                 nextIndex += 1;
2048             }
2049         }
2050 
2051         return unsoldTokens;
2052     }
2053 
2054     /// @notice For a given edition, returns the next token and associated royalty information
2055     function facilitateNextPrimarySale(uint256 _editionId)
2056     public
2057     view
2058     override
2059     returns (address receiver, address creator, uint256 tokenId) {
2060         require(!editionSalesDisabled[_editionId], "Edition disabled");
2061 
2062         uint256 _tokenId = getNextAvailablePrimarySaleToken(_editionId);
2063         address _creator = _getCreatorOfEdition(_editionId);
2064 
2065         if (royaltyRegistryActive() && royaltiesRegistryProxy.hasRoyalties(_editionId)) {
2066             address _receiver = royaltiesRegistryProxy.getRoyaltiesReceiver(_editionId);
2067             return (_receiver, _creator, _tokenId);
2068         }
2069 
2070         return (_creator, _creator, _tokenId);
2071     }
2072 
2073     /// @notice Return the next unsold token ID for a given edition unless all tokens have been sold
2074     function getNextAvailablePrimarySaleToken(uint256 _editionId) public override view returns (uint256 _tokenId) {
2075         uint256 maxTokenId = _maxTokenIdOfEdition(_editionId);
2076 
2077         // low to high
2078         for (uint256 tokenId = _editionId; tokenId < maxTokenId; tokenId++) {
2079             // if no owner set - assume primary if not moved
2080             if (owners[tokenId] == address(0)) {
2081                 return tokenId;
2082             }
2083         }
2084         revert("Primary market exhausted");
2085     }
2086 
2087     /// @notice Starting from the last token in an edition and going down the first, returns the next unsold token (if any)
2088     function getReverseAvailablePrimarySaleToken(uint256 _editionId) public override view returns (uint256 _tokenId) {
2089         uint256 highestTokenId = _maxTokenIdOfEdition(_editionId) - 1;
2090 
2091         // high to low
2092         while (highestTokenId >= _editionId) {
2093             // if no owner set - assume primary if not moved
2094             if (owners[highestTokenId] == address(0)) {
2095                 return highestTokenId;
2096             }
2097             highestTokenId--;
2098         }
2099         revert("Primary market exhausted");
2100     }
2101 
2102     /// @notice Using the reverse token ID logic of an edition, returns next token ID and associated royalty information
2103     function facilitateReversePrimarySale(uint256 _editionId)
2104     public
2105     view
2106     override
2107     returns (address receiver, address creator, uint256 tokenId) {
2108         require(!editionSalesDisabled[_editionId], "Edition disabled");
2109 
2110         uint256 _tokenId = getReverseAvailablePrimarySaleToken(_editionId);
2111         address _creator = _getCreatorOfEdition(_editionId);
2112 
2113         if (royaltyRegistryActive() && royaltiesRegistryProxy.hasRoyalties(_editionId)) {
2114             address _receiver = royaltiesRegistryProxy.getRoyaltiesReceiver(_editionId);
2115             return (_receiver, _creator, _tokenId);
2116         }
2117 
2118         return (_creator, _creator, _tokenId);
2119     }
2120 
2121     /// @notice If the token specified by token ID has been sold on the primary market
2122     function hadPrimarySaleOfToken(uint256 _tokenId) public override view returns (bool) {
2123         return owners[_tokenId] != address(0);
2124     }
2125 
2126     /// @notice If any token in the edition has been sold
2127     function hasMadePrimarySale(uint256 _editionId) validateEdition(_editionId) public override view returns (bool) {
2128         uint256 maxTokenId = _maxTokenIdOfEdition(_editionId);
2129 
2130         // low to high
2131         for (uint256 tokenId = _editionId; tokenId < maxTokenId; tokenId++) {
2132             // if no owner set - assume primary if not moved
2133             if (owners[tokenId] != address(0)) {
2134                 return true;
2135             }
2136         }
2137         return false;
2138     }
2139 
2140     /// @notice If all tokens in the edition have been sold
2141     function isEditionSoldOut(uint256 _editionId) validateEdition(_editionId) public override view returns (bool) {
2142         uint256 maxTokenId = _maxTokenIdOfEdition(_editionId);
2143 
2144         // low to high
2145         for (uint256 tokenId = _editionId; tokenId < maxTokenId; tokenId++) {
2146             // if no owner set - assume primary if not moved
2147             if (owners[tokenId] == address(0)) {
2148                 return false;
2149             }
2150         }
2151 
2152         return true;
2153     }
2154 
2155     //////////////
2156     // Defaults //
2157     //////////////
2158 
2159     /// @notice Transfers the ownership of an NFT from one address to another address
2160     /// @dev Throws unless `msg.sender` is the current owner, an authorized
2161     ///      operator, or the approved address for this NFT. Throws if `_from` is
2162     ///      not the current owner. Throws if `_to` is the zero address. Throws if
2163     ///      `_tokenId` is not a valid NFT. When transfer is complete, this function
2164     ///      checks if `_to` is a smart contract (code size > 0). If so, it calls
2165     ///      `onERC721Received` on `_to` and throws if the return value is not
2166     ///      `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
2167     /// @param _from The current owner of the NFT
2168     /// @param _to The new owner
2169     /// @param _tokenId The NFT to transfer
2170     /// @param _data Additional data with no specified format, sent in call to `_to`
2171     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata _data) override external {
2172         _safeTransferFrom(_from, _to, _tokenId, _data);
2173 
2174         // move the token
2175         emit Transfer(_from, _to, _tokenId);
2176     }
2177 
2178     /// @notice Transfers the ownership of an NFT from one address to another address
2179     /// @dev This works identically to the other function with an extra data parameter,
2180     ///      except this function just sets data to "".
2181     /// @param _from The current owner of the NFT
2182     /// @param _to The new owner
2183     /// @param _tokenId The NFT to transfer
2184     function safeTransferFrom(address _from, address _to, uint256 _tokenId) override external {
2185         _safeTransferFrom(_from, _to, _tokenId, bytes(""));
2186 
2187         // move the token
2188         emit Transfer(_from, _to, _tokenId);
2189     }
2190 
2191     function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) private {
2192         _transferFrom(_from, _to, _tokenId);
2193 
2194         uint256 receiverCodeSize;
2195         assembly {
2196             receiverCodeSize := extcodesize(_to)
2197         }
2198         if (receiverCodeSize > 0) {
2199             bytes4 selector = IERC721Receiver(_to).onERC721Received(
2200                 _msgSender(),
2201                 _from,
2202                 _tokenId,
2203                 _data
2204             );
2205             require(
2206                 selector == ERC721_RECEIVED,
2207                 "Invalid selector"
2208             );
2209         }
2210     }
2211 
2212     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
2213     ///         TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
2214     ///         THEY MAY BE PERMANENTLY LOST
2215     /// @dev Throws unless `_msgSender()` is the current owner, an authorized
2216     ///      operator, or the approved address for this NFT. Throws if `_from` is
2217     ///      not the current owner. Throws if `_to` is the zero address. Throws if
2218     ///      `_tokenId` is not a valid NFT.
2219     /// @param _from The current owner of the NFT
2220     /// @param _to The new owner
2221     /// @param _tokenId The NFT to transfer
2222     function transferFrom(address _from, address _to, uint256 _tokenId) override external {
2223         _transferFrom(_from, _to, _tokenId);
2224 
2225         // move the token
2226         emit Transfer(_from, _to, _tokenId);
2227     }
2228 
2229     function _transferFrom(address _from, address _to, uint256 _tokenId) private {
2230         // enforce not being able to send to zero as we have explicit rules what a minted but unbound owner is
2231         require(_to != address(0), "Invalid to address");
2232 
2233         // Ensure the owner is the sender
2234         address owner = _ownerOf(_tokenId, _editionFromTokenId(_tokenId));
2235         require(owner != address(0), "Invalid owner");
2236         require(_from == owner, "Owner mismatch");
2237 
2238         address spender = _msgSender();
2239         address approvedAddress = getApproved(_tokenId);
2240         require(
2241             spender == owner // sending to myself
2242             || isApprovedForAll(owner, spender)  // is approved to send any behalf of owner
2243             || approvedAddress == spender, // is approved to move this token ID
2244             "Invalid spender"
2245         );
2246 
2247         // Ensure approval for token ID is cleared
2248         if (approvedAddress != address(0)) {
2249             approvals[_tokenId] = address(0);
2250         }
2251 
2252         // set new owner - this will now override any specific other mappings for the base edition config
2253         owners[_tokenId] = _to;
2254 
2255         // Modify balances
2256         balances[_from] = balances[_from] - 1;
2257         balances[_to] = balances[_to] + 1;
2258     }
2259 
2260     /// @notice Find the owner of an NFT
2261     /// @dev NFTs assigned to zero address are considered invalid, and queries about them do throw.
2262     /// @param _tokenId The identifier for an NFT
2263     /// @return The address of the owner of the NFT
2264     function ownerOf(uint256 _tokenId) override public view returns (address) {
2265         uint256 editionId = _editionFromTokenId(_tokenId);
2266         address owner = _ownerOf(_tokenId, editionId);
2267         require(owner != address(0), "Invalid owner");
2268         return owner;
2269     }
2270 
2271     /// @dev Newly created editions and its tokens minted to a creator don't have the owner set until the token is sold on the primary market
2272     /// @dev Therefore, if internally an edition exists and owner of token is zero address, then creator still owns the token
2273     /// @dev Otherwise, the token owner is returned or the zero address if the token does not exist
2274     function _ownerOf(uint256 _tokenId, uint256 _editionId) internal view returns (address) {
2275 
2276         // If an owner assigned
2277         address owner = owners[_tokenId];
2278         if (owner != address(0)) {
2279             return owner;
2280         }
2281 
2282         // fall back to edition creator
2283         address possibleCreator = _getCreatorOfEdition(_editionId);
2284         if (possibleCreator != address(0) && (_maxTokenIdOfEdition(_editionId) - 1) >= _tokenId) {
2285             return possibleCreator;
2286         }
2287 
2288         return address(0);
2289     }
2290 
2291     /// @notice Change or reaffirm the approved address for an NFT
2292     /// @dev The zero address indicates there is no approved address.
2293     ///      Throws unless `msg.sender` is the current NFT owner, or an authorized
2294     ///      operator of the current owner.
2295     /// @param _approved The new approved NFT controller
2296     /// @param _tokenId The NFT to approve
2297     function approve(address _approved, uint256 _tokenId) override external {
2298         address owner = ownerOf(_tokenId);
2299         require(_approved != owner, "Approved is owner");
2300         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), "Invalid sender");
2301         approvals[_tokenId] = _approved;
2302         emit Approval(owner, _approved, _tokenId);
2303     }
2304 
2305     /// @notice Enable or disable approval for a third party ("operator") to manage
2306     ///         all of `msg.sender`"s assets
2307     /// @dev Emits the ApprovalForAll event. The contract MUST allow
2308     ///      multiple operators per owner.
2309     /// @param _operator Address to add to the set of authorized operators
2310     /// @param _approved True if the operator is approved, false to revoke approval
2311     function setApprovalForAll(address _operator, bool _approved) override external {
2312         operatorApprovals[_msgSender()][_operator] = _approved;
2313         emit ApprovalForAll(
2314             _msgSender(),
2315             _operator,
2316             _approved
2317         );
2318     }
2319 
2320     /// @notice Count all NFTs assigned to an owner
2321     /// @dev NFTs assigned to the zero address are considered invalid, and this
2322     ///      function throws for queries about the zero address.
2323     /// @param _owner An address for whom to query the balance
2324     /// @return The number of NFTs owned by `_owner`, possibly zero
2325     function balanceOf(address _owner) override external view returns (uint256) {
2326         require(_owner != address(0), "Invalid owner");
2327         return balances[_owner];
2328     }
2329 
2330     /// @notice Get the approved address for a single NFT
2331     /// @dev Throws if `_tokenId` is not a valid NFT.
2332     /// @param _tokenId The NFT to find the approved address for
2333     /// @return The approved address for this NFT, or the zero address if there is none
2334     function getApproved(uint256 _tokenId) override public view returns (address){
2335         return approvals[_tokenId];
2336     }
2337 
2338     /// @notice Query if an address is an authorized operator for another address
2339     /// @param _owner The address that owns the NFTs
2340     /// @param _operator The address that acts on behalf of the owner
2341     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
2342     function isApprovedForAll(address _owner, address _operator) override public view returns (bool){
2343         return operatorApprovals[_owner][_operator];
2344     }
2345 
2346     /// @notice An extension to the default ERC721 behaviour, derived from ERC-875.
2347     /// @dev Allowing for batch transfers from the provided address, will fail if from does not own all the tokens
2348     function batchTransferFrom(address _from, address _to, uint256[] calldata _tokenIds) public {
2349         for (uint256 i = 0; i < _tokenIds.length; i++) {
2350             _safeTransferFrom(_from, _to, _tokenIds[i], bytes(""));
2351             emit Transfer(_from, _to, _tokenIds[i]);
2352         }
2353     }
2354 
2355     /// @notice An extension to the default ERC721 behaviour, derived from ERC-875 but using the ConsecutiveTransfer event
2356     /// @dev Allowing for batch transfers from the provided address, will fail if from does not own all the tokens
2357     function consecutiveBatchTransferFrom(address _from, address _to, uint256 _fromTokenId, uint256 _toTokenId) public {
2358         for (uint256 i = _fromTokenId; i <= _toTokenId; i++) {
2359             _safeTransferFrom(_from, _to, i, bytes(""));
2360         }
2361         emit ConsecutiveTransfer(_fromTokenId, _toTokenId, _from, _to);
2362     }
2363 
2364     /////////////////////
2365     // Admin functions //
2366     /////////////////////
2367 
2368     function setRoyaltiesRegistryProxy(IERC2981 _royaltiesRegistryProxy) onlyAdmin public {
2369         royaltiesRegistryProxy = _royaltiesRegistryProxy;
2370         emit AdminRoyaltiesRegistryProxySet(address(_royaltiesRegistryProxy));
2371     }
2372 
2373     function setTokenUriResolver(ITokenUriResolver _tokenUriResolver) onlyAdmin public {
2374         tokenUriResolver = _tokenUriResolver;
2375         emit AdminTokenUriResolverSet(address(_tokenUriResolver));
2376     }
2377 
2378     ///////////////////////
2379     // Creator functions //
2380     ///////////////////////
2381 
2382     function composeERC20sAsCreator(uint16 _editionId, address[] calldata _erc20s, uint256[] calldata _amounts)
2383     external
2384     validateCreator(_editionId) {
2385         require(!isEditionSoldOut(_editionId), "Edition soldout");
2386 
2387         uint256 totalErc20s = _erc20s.length;
2388         require(totalErc20s > 0 && totalErc20s == _amounts.length, "Tokens invalid");
2389 
2390         for (uint i = 0; i < totalErc20s; i++) {
2391             _composeERC20IntoEdition(_msgSender(), _editionId, _erc20s[i], _amounts[i]);
2392         }
2393     }
2394 
2395     /// @notice Optional metadata storage slot which allows the creator to set an additional metadata blob on the edition
2396     function lockInAdditionalMetaData(uint256 _editionId, string calldata _metadata)
2397     external
2398     validateCreator(_editionId) {
2399         require(bytes(sealedEditionMetaData[_editionId]).length == 0, "Already set");
2400         sealedEditionMetaData[_editionId] = _metadata;
2401         emit SealedEditionMetaDataSet(_editionId);
2402     }
2403 
2404     /// @notice Optional metadata storage slot which allows a token owner to set an additional metadata blob on the token
2405     function lockInAdditionalTokenMetaData(uint256 _tokenId, string calldata _metadata) external {
2406         require(
2407             _msgSender() == ownerOf(_tokenId) || accessControls.hasContractRole(_msgSender()),
2408             "Invalid caller"
2409         );
2410         require(bytes(sealedTokenMetaData[_tokenId]).length == 0, "Already set");
2411         sealedTokenMetaData[_tokenId] = _metadata;
2412         emit SealedTokenMetaDataSet(_tokenId);
2413     }
2414 }