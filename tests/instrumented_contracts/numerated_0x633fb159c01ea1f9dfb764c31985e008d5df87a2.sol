1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 
7 
8 /**
9  * @dev These functions deal with verification of Merkle Trees proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  */
17 
18 
19 
20 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
21 
22 pragma solidity ^0.8.0;
23 
24 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/IERC2981.sol)
25 
26 
27 pragma solidity ^0.8.0;
28 
29 
30 
31 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev External interface of AccessControl declared to support ERC165 detection.
37  */
38 interface IAccessControl {
39     /**
40      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
41      *
42      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
43      * {RoleAdminChanged} not being emitted signaling this.
44      *
45      * _Available since v3.1._
46      */
47     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
48 
49     /**
50      * @dev Emitted when `account` is granted `role`.
51      *
52      * `sender` is the account that originated the contract call, an admin role
53      * bearer except when using {AccessControl-_setupRole}.
54      */
55     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
56 
57     /**
58      * @dev Emitted when `account` is revoked `role`.
59      *
60      * `sender` is the account that originated the contract call:
61      *   - if using `revokeRole`, it is the admin role bearer
62      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
63      */
64     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
65 
66     /**
67      * @dev Returns `true` if `account` has been granted `role`.
68      */
69     function hasRole(bytes32 role, address account) external view returns (bool);
70 
71     /**
72      * @dev Returns the admin role that controls `role`. See {grantRole} and
73      * {revokeRole}.
74      *
75      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
76      */
77     function getRoleAdmin(bytes32 role) external view returns (bytes32);
78 
79     /**
80      * @dev Grants `role` to `account`.
81      *
82      * If `account` had not been already granted `role`, emits a {RoleGranted}
83      * event.
84      *
85      * Requirements:
86      *
87      * - the caller must have ``role``'s admin role.
88      */
89     function grantRole(bytes32 role, address account) external;
90 
91     /**
92      * @dev Revokes `role` from `account`.
93      *
94      * If `account` had been granted `role`, emits a {RoleRevoked} event.
95      *
96      * Requirements:
97      *
98      * - the caller must have ``role``'s admin role.
99      */
100     function revokeRole(bytes32 role, address account) external;
101 
102     /**
103      * @dev Revokes `role` from the calling account.
104      *
105      * Roles are often managed via {grantRole} and {revokeRole}: this function's
106      * purpose is to provide a mechanism for accounts to lose their privileges
107      * if they are compromised (such as when a trusted device is misplaced).
108      *
109      * If the calling account had been granted `role`, emits a {RoleRevoked}
110      * event.
111      *
112      * Requirements:
113      *
114      * - the caller must be `account`.
115      */
116     function renounceRole(bytes32 role, address account) external;
117 }
118 
119 
120 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
121 
122 pragma solidity ^0.8.0;
123 
124 /**
125  * @dev Interface of the ERC165 standard, as defined in the
126  * https://eips.ethereum.org/EIPS/eip-165[EIP].
127  *
128  * Implementers can declare support of contract interfaces, which can then be
129  * queried by others ({ERC165Checker}).
130  *
131  * For an implementation, see {ERC165}.
132  */
133 interface IERC165 {
134     /**
135      * @dev Returns true if this contract implements the interface defined by
136      * `interfaceId`. See the corresponding
137      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
138      * to learn more about how these ids are created.
139      *
140      * This function call must use less than 30 000 gas.
141      */
142     function supportsInterface(bytes4 interfaceId) external view returns (bool);
143 }
144 
145 
146 
147 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
148 
149 pragma solidity ^0.8.0;
150 
151 
152 /**
153  * @dev Implementation of the {IERC165} interface.
154  *
155  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
156  * for the additional interface id that will be supported. For example:
157  *
158  * ```solidity
159  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
160  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
161  * }
162  * ```
163  *
164  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
165  */
166 abstract contract ERC165 is IERC165 {
167     /**
168      * @dev See {IERC165-supportsInterface}.
169      */
170     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
171         return interfaceId == type(IERC165).interfaceId;
172     }
173 }
174 
175 
176 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
177 
178 pragma solidity ^0.8.0;
179 
180 /**
181  * @dev String operations.
182  */
183 library Strings {
184     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
185 
186     /**
187      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
188      */
189     function toString(uint256 value) internal pure returns (string memory) {
190         // Inspired by OraclizeAPI's implementation - MIT licence
191         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
192 
193         if (value == 0) {
194             return "0";
195         }
196         uint256 temp = value;
197         uint256 digits;
198         while (temp != 0) {
199             digits++;
200             temp /= 10;
201         }
202         bytes memory buffer = new bytes(digits);
203         while (value != 0) {
204             digits -= 1;
205             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
206             value /= 10;
207         }
208         return string(buffer);
209     }
210 
211     /**
212      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
213      */
214     function toHexString(uint256 value) internal pure returns (string memory) {
215         if (value == 0) {
216             return "0x00";
217         }
218         uint256 temp = value;
219         uint256 length = 0;
220         while (temp != 0) {
221             length++;
222             temp >>= 8;
223         }
224         return toHexString(value, length);
225     }
226 
227     /**
228      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
229      */
230     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
231         bytes memory buffer = new bytes(2 * length + 2);
232         buffer[0] = "0";
233         buffer[1] = "x";
234         for (uint256 i = 2 * length + 1; i > 1; --i) {
235             buffer[i] = _HEX_SYMBOLS[value & 0xf];
236             value >>= 4;
237         }
238         require(value == 0, "Strings: hex length insufficient");
239         return string(buffer);
240     }
241 }
242 
243 
244 
245 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
246 
247 pragma solidity ^0.8.0;
248 
249 /**
250  * @dev Provides information about the current execution context, including the
251  * sender of the transaction and its data. While these are generally available
252  * via msg.sender and msg.data, they should not be accessed in such a direct
253  * manner, since when dealing with meta-transactions the account sending and
254  * paying for execution may not be the actual sender (as far as an application
255  * is concerned).
256  *
257  * This contract is only required for intermediate, library-like contracts.
258  */
259 abstract contract Context {
260     function _msgSender() internal view virtual returns (address) {
261         return msg.sender;
262     }
263 
264     function _msgData() internal view virtual returns (bytes calldata) {
265         return msg.data;
266     }
267 }
268 
269 
270 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
271 
272 pragma solidity ^0.8.1;
273 
274 /**
275  * @dev Collection of functions related to the address type
276  */
277 library Address {
278     /**
279      * @dev Returns true if `account` is a contract.
280      *
281      * [IMPORTANT]
282      * ====
283      * It is unsafe to assume that an address for which this function returns
284      * false is an externally-owned account (EOA) and not a contract.
285      *
286      * Among others, `isContract` will return false for the following
287      * types of addresses:
288      *
289      *  - an externally-owned account
290      *  - a contract in construction
291      *  - an address where a contract will be created
292      *  - an address where a contract lived, but was destroyed
293      * ====
294      *
295      * [IMPORTANT]
296      * ====
297      * You shouldn't rely on `isContract` to protect against flash loan attacks!
298      *
299      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
300      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
301      * constructor.
302      * ====
303      */
304     function isContract(address account) internal view returns (bool) {
305         // This method relies on extcodesize/address.code.length, which returns 0
306         // for contracts in construction, since the code is only stored at the end
307         // of the constructor execution.
308 
309         return account.code.length > 0;
310     }
311 
312     /**
313      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
314      * `recipient`, forwarding all available gas and reverting on errors.
315      *
316      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
317      * of certain opcodes, possibly making contracts go over the 2300 gas limit
318      * imposed by `transfer`, making them unable to receive funds via
319      * `transfer`. {sendValue} removes this limitation.
320      *
321      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
322      *
323      * IMPORTANT: because control is transferred to `recipient`, care must be
324      * taken to not create reentrancy vulnerabilities. Consider using
325      * {ReentrancyGuard} or the
326      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
327      */
328     function sendValue(address payable recipient, uint256 amount) internal {
329         require(address(this).balance >= amount, "Address: insufficient balance");
330 
331         (bool success, ) = recipient.call{value: amount}("");
332         require(success, "Address: unable to send value, recipient may have reverted");
333     }
334 
335     /**
336      * @dev Performs a Solidity function call using a low level `call`. A
337      * plain `call` is an unsafe replacement for a function call: use this
338      * function instead.
339      *
340      * If `target` reverts with a revert reason, it is bubbled up by this
341      * function (like regular Solidity function calls).
342      *
343      * Returns the raw returned data. To convert to the expected return value,
344      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
345      *
346      * Requirements:
347      *
348      * - `target` must be a contract.
349      * - calling `target` with `data` must not revert.
350      *
351      * _Available since v3.1._
352      */
353     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
354         return functionCall(target, data, "Address: low-level call failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
359      * `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCall(
364         address target,
365         bytes memory data,
366         string memory errorMessage
367     ) internal returns (bytes memory) {
368         return functionCallWithValue(target, data, 0, errorMessage);
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
373      * but also transferring `value` wei to `target`.
374      *
375      * Requirements:
376      *
377      * - the calling contract must have an ETH balance of at least `value`.
378      * - the called Solidity function must be `payable`.
379      *
380      * _Available since v3.1._
381      */
382     function functionCallWithValue(
383         address target,
384         bytes memory data,
385         uint256 value
386     ) internal returns (bytes memory) {
387         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
392      * with `errorMessage` as a fallback revert reason when `target` reverts.
393      *
394      * _Available since v3.1._
395      */
396     function functionCallWithValue(
397         address target,
398         bytes memory data,
399         uint256 value,
400         string memory errorMessage
401     ) internal returns (bytes memory) {
402         require(address(this).balance >= value, "Address: insufficient balance for call");
403         require(isContract(target), "Address: call to non-contract");
404 
405         (bool success, bytes memory returndata) = target.call{value: value}(data);
406         return verifyCallResult(success, returndata, errorMessage);
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
411      * but performing a static call.
412      *
413      * _Available since v3.3._
414      */
415     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
416         return functionStaticCall(target, data, "Address: low-level static call failed");
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
421      * but performing a static call.
422      *
423      * _Available since v3.3._
424      */
425     function functionStaticCall(
426         address target,
427         bytes memory data,
428         string memory errorMessage
429     ) internal view returns (bytes memory) {
430         require(isContract(target), "Address: static call to non-contract");
431 
432         (bool success, bytes memory returndata) = target.staticcall(data);
433         return verifyCallResult(success, returndata, errorMessage);
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
438      * but performing a delegate call.
439      *
440      * _Available since v3.4._
441      */
442     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
443         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
448      * but performing a delegate call.
449      *
450      * _Available since v3.4._
451      */
452     function functionDelegateCall(
453         address target,
454         bytes memory data,
455         string memory errorMessage
456     ) internal returns (bytes memory) {
457         require(isContract(target), "Address: delegate call to non-contract");
458 
459         (bool success, bytes memory returndata) = target.delegatecall(data);
460         return verifyCallResult(success, returndata, errorMessage);
461     }
462 
463     /**
464      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
465      * revert reason using the provided one.
466      *
467      * _Available since v4.3._
468      */
469     function verifyCallResult(
470         bool success,
471         bytes memory returndata,
472         string memory errorMessage
473     ) internal pure returns (bytes memory) {
474         if (success) {
475             return returndata;
476         } else {
477             // Look for revert reason and bubble it up if present
478             if (returndata.length > 0) {
479                 // The easiest way to bubble the revert reason is using memory via assembly
480 
481                 assembly {
482                     let returndata_size := mload(returndata)
483                     revert(add(32, returndata), returndata_size)
484                 }
485             } else {
486                 revert(errorMessage);
487             }
488         }
489     }
490 }
491 
492 
493 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
494 
495 pragma solidity ^0.8.0;
496 
497 
498 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 /**
503  * @title ERC721 token receiver interface
504  * @dev Interface for any contract that wants to support safeTransfers
505  * from ERC721 asset contracts.
506  */
507 interface IERC721Receiver {
508     /**
509      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
510      * by `operator` from `from`, this function is called.
511      *
512      * It must return its Solidity selector to confirm the token transfer.
513      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
514      *
515      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
516      */
517     function onERC721Received(
518         address operator,
519         address from,
520         uint256 tokenId,
521         bytes calldata data
522     ) external returns (bytes4);
523 }
524 
525 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
526 
527 
528 
529 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
530 
531 pragma solidity ^0.8.0;
532 
533 
534 /**
535  * @dev Required interface of an ERC721 compliant contract.
536  */
537 interface IERC721 is IERC165 {
538     /**
539      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
540      */
541     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
542 
543     /**
544      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
545      */
546     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
547 
548     /**
549      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
550      */
551     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
552 
553     /**
554      * @dev Returns the number of tokens in ``owner``'s account.
555      */
556     function balanceOf(address owner) external view returns (uint256 balance);
557 
558     /**
559      * @dev Returns the owner of the `tokenId` token.
560      *
561      * Requirements:
562      *
563      * - `tokenId` must exist.
564      */
565     function ownerOf(uint256 tokenId) external view returns (address owner);
566 
567     /**
568      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
569      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
570      *
571      * Requirements:
572      *
573      * - `from` cannot be the zero address.
574      * - `to` cannot be the zero address.
575      * - `tokenId` token must exist and be owned by `from`.
576      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
577      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
578      *
579      * Emits a {Transfer} event.
580      */
581     function safeTransferFrom(
582         address from,
583         address to,
584         uint256 tokenId
585     ) external;
586 
587     /**
588      * @dev Transfers `tokenId` token from `from` to `to`.
589      *
590      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
591      *
592      * Requirements:
593      *
594      * - `from` cannot be the zero address.
595      * - `to` cannot be the zero address.
596      * - `tokenId` token must be owned by `from`.
597      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
598      *
599      * Emits a {Transfer} event.
600      */
601     function transferFrom(
602         address from,
603         address to,
604         uint256 tokenId
605     ) external;
606 
607     /**
608      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
609      * The approval is cleared when the token is transferred.
610      *
611      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
612      *
613      * Requirements:
614      *
615      * - The caller must own the token or be an approved operator.
616      * - `tokenId` must exist.
617      *
618      * Emits an {Approval} event.
619      */
620     function approve(address to, uint256 tokenId) external;
621 
622     /**
623      * @dev Returns the account approved for `tokenId` token.
624      *
625      * Requirements:
626      *
627      * - `tokenId` must exist.
628      */
629     function getApproved(uint256 tokenId) external view returns (address operator);
630 
631     /**
632      * @dev Approve or remove `operator` as an operator for the caller.
633      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
634      *
635      * Requirements:
636      *
637      * - The `operator` cannot be the caller.
638      *
639      * Emits an {ApprovalForAll} event.
640      */
641     function setApprovalForAll(address operator, bool _approved) external;
642 
643     /**
644      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
645      *
646      * See {setApprovalForAll}
647      */
648     function isApprovedForAll(address owner, address operator) external view returns (bool);
649 
650     /**
651      * @dev Safely transfers `tokenId` token from `from` to `to`.
652      *
653      * Requirements:
654      *
655      * - `from` cannot be the zero address.
656      * - `to` cannot be the zero address.
657      * - `tokenId` token must exist and be owned by `from`.
658      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
659      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
660      *
661      * Emits a {Transfer} event.
662      */
663     function safeTransferFrom(
664         address from,
665         address to,
666         uint256 tokenId,
667         bytes calldata data
668     ) external;
669 }
670 
671 
672 pragma solidity ^0.8.0;
673 
674 
675 /**
676  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
677  * @dev See https://eips.ethereum.org/EIPS/eip-721
678  */
679 interface IERC721Metadata is IERC721 {
680     /**
681      * @dev Returns the token collection name.
682      */
683     function name() external view returns (string memory);
684 
685     /**
686      * @dev Returns the token collection symbol.
687      */
688     function symbol() external view returns (string memory);
689 
690     /**
691      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
692      */
693     function tokenURI(uint256 tokenId) external view returns (string memory);
694 }
695 
696 
697 
698 pragma solidity ^0.8.0;
699 
700 
701 contract ClaimBitmap {
702     uint256[] public claimedBitmap;
703 
704     /**
705      * Cannot reallocate memory if initialized
706      */
707     error BitmapAlreadyInitialized();
708 
709     /**
710      * @notice emitted when an account has claimed a token id
711      */
712     event ClaimedForTokenId(uint256 indexed tokenId);
713 
714     /**
715      * @notice emitted when an account has used token id for Free Claim
716      */
717     event UsedForFreeClaimTokenId(uint256 indexed tokenId);
718 
719     /**
720      * @notice initialize the claim bitmap array
721      * @param maximumTokens the maximum amount of tokens
722      */
723     function _initializeBitmap(uint256 maximumTokens) internal {
724         if (claimedBitmap.length != 0) revert BitmapAlreadyInitialized();
725 
726         uint256 bitMapSize = Math.ceilDiv(maximumTokens, 256);
727         claimedBitmap = new uint256[](bitMapSize);
728     }
729 
730     /**
731      * @notice checks to see if a token id has been claimed
732      * @param tokenId the token id
733      */
734     function isClaimed(uint256 tokenId) public view returns (bool) {
735         uint256 claimedWordIndex = tokenId / 256;
736         uint256 claimedBitIndex = tokenId % 256;
737         uint256 claimedWord = claimedBitmap[claimedWordIndex];
738         uint256 mask = (1 << claimedBitIndex);
739 
740         return claimedWord & mask == mask;
741     }
742 
743     /**
744      * @notice sets the token id as claimed
745      * @param tokenId the token id
746      */
747     function _setClaimed(uint256 tokenId) internal {
748         uint256 claimedWordIndex = tokenId / 256;
749         uint256 claimedBitIndex = tokenId % 256;
750         claimedBitmap[claimedWordIndex] = claimedBitmap[claimedWordIndex] | (1 << claimedBitIndex);
751 
752         emit ClaimedForTokenId(tokenId);
753     }
754 
755 }
756 
757 
758 
759 
760 pragma solidity ^0.8.0;
761 
762 
763 contract MerkleDistributorV2 {
764     bytes32 public merkleRoot;
765     bool private allowListActive = false;
766 
767     mapping(address => uint256) private _allowListNumMinted;
768 
769     /**
770      * allow list is not active
771      */
772     error AllowListIsNotActive();
773 
774     /**
775      * cannot mint if not on allow list
776      */
777     error NotOnAllowList();
778 
779     /**
780      * cannot mint past number of tokens allotted
781      */
782     error PurchaseWouldExceedMaximumAllowListMint();
783 
784     /**
785      * @dev emitted when an account has claimed some tokens
786      */
787     event Claimed(address indexed account, uint256 amount);
788 
789     /**
790      * @dev emitted when the merkle root has changed
791      */
792     event MerkleRootChanged(bytes32 merkleRoot);
793 
794     /**
795      * @notice throws when allow list is not active
796      */
797     modifier isAllowListActive() {
798         if (!allowListActive) revert AllowListIsNotActive();
799         _;
800     }
801 
802     /**
803      * @notice sets the state of the allow list
804      * @param allowListActive_ the state of the allow list
805      */
806     function _setAllowListActive(bool allowListActive_) internal virtual {
807         allowListActive = allowListActive_;
808     }
809 
810     /**
811      * @notice sets the merkle root
812      * @param merkleRoot_ the merkle root
813      */
814     function _setAllowList(bytes32 merkleRoot_) internal virtual {
815         merkleRoot = merkleRoot_;
816 
817         emit MerkleRootChanged(merkleRoot);
818     }
819 
820     /**
821      * @notice adds the number of tokens to the incoming address
822      * @param to the address
823      * @param numberOfTokens the number of tokens to be minted
824      */
825     function _setAllowListMinted(address to, uint256 numberOfTokens) internal virtual {
826         _allowListNumMinted[to] += numberOfTokens;
827 
828         emit Claimed(to, numberOfTokens);
829     }
830 
831 
832 }
833 
834 
835 // OpenZeppelin Contracts (last updated v4.5.0) (utils/math/Math.sol)
836 
837 pragma solidity ^0.8.0;
838 
839 /**
840  * @dev Standard math utilities missing in the Solidity language.
841  */
842 library Math {
843     /**
844      * @dev Returns the largest of two numbers.
845      */
846     function max(uint256 a, uint256 b) internal pure returns (uint256) {
847         return a >= b ? a : b;
848     }
849 
850     /**
851      * @dev Returns the smallest of two numbers.
852      */
853     function min(uint256 a, uint256 b) internal pure returns (uint256) {
854         return a < b ? a : b;
855     }
856 
857     /**
858      * @dev Returns the average of two numbers. The result is rounded towards
859      * zero.
860      */
861     function average(uint256 a, uint256 b) internal pure returns (uint256) {
862         // (a + b) / 2 can overflow.
863         return (a & b) + (a ^ b) / 2;
864     }
865 
866     /**
867      * @dev Returns the ceiling of the division of two numbers.
868      *
869      * This differs from standard division with `/` in that it rounds up instead
870      * of rounding down.
871      */
872     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
873         // (a + b - 1) / b can overflow on addition, so we distribute.
874         return a / b + (a % b == 0 ? 0 : 1);
875     }
876 
877     function floorDiv(uint256 a, uint256 b) internal pure returns (uint256){
878         // (a + b - 1) / b can overflow on addition, so we distribute.
879         return a / b + (a % b == 0 ? 0 : 0);
880     }
881 }
882 
883 
884 // OpenZeppelin Contracts (last updated v4.5.0) (token/common/ERC2981.sol)
885 
886 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
887 
888 pragma solidity ^0.8.0;
889 
890 
891 /**
892  * @dev Contract module which provides a basic access control mechanism, where
893  * there is an account (an owner) that can be granted exclusive access to
894  * specific functions.
895  *
896  * By default, the owner account will be the one that deploys the contract. This
897  * can later be changed with {transferOwnership}.
898  *
899  * This module is used through inheritance. It will make available the modifier
900  * `onlyOwner`, which can be applied to your functions to restrict their use to
901  * the owner.
902  */
903 abstract contract Ownable is Context {
904     address private _owner;
905 
906     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
907 
908     /**
909      * @dev Initializes the contract setting the deployer as the initial owner.
910      */
911     constructor() {
912         _transferOwnership(_msgSender());
913     }
914 
915     /**
916      * @dev Returns the address of the current owner.
917      */
918     function owner() public view virtual returns (address) {
919         return _owner;
920     }
921 
922     /**
923      * @dev Throws if called by any account other than the owner.
924      */
925     modifier onlyOwner() {
926         require(owner() == _msgSender(), "Ownable: caller is not the owner");
927         _;
928     }
929 
930     /**
931      * @dev Leaves the contract without owner. It will not be possible to call
932      * `onlyOwner` functions anymore. Can only be called by the current owner.
933      *
934      * NOTE: Renouncing ownership will leave the contract without an owner,
935      * thereby removing any functionality that is only available to the owner.
936      */
937     function renounceOwnership() public virtual onlyOwner {
938         _transferOwnership(address(0));
939     }
940 
941     /**
942      * @dev Transfers ownership of the contract to a new account (`newOwner`).
943      * Can only be called by the current owner.
944      */
945     function transferOwnership(address newOwner) public virtual onlyOwner {
946         require(newOwner != address(0), "Ownable: new owner is the zero address");
947         _transferOwnership(newOwner);
948     }
949 
950     /**
951      * @dev Transfers ownership of the contract to a new account (`newOwner`).
952      * Internal function without access restriction.
953      */
954     function _transferOwnership(address newOwner) internal virtual {
955         address oldOwner = _owner;
956         _owner = newOwner;
957         emit OwnershipTransferred(oldOwner, newOwner);
958     }
959 }
960 
961 
962 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControl.sol)
963 
964 pragma solidity ^0.8.0;
965 
966 
967 /**
968  * @dev Contract module that allows children to implement role-based access
969  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
970  * members except through off-chain means by accessing the contract event logs. Some
971  * applications may benefit from on-chain enumerability, for those cases see
972  * {AccessControlEnumerable}.
973  *
974  * Roles are referred to by their `bytes32` identifier. These should be exposed
975  * in the external API and be unique. The best way to achieve this is by
976  * using `public constant` hash digests:
977  *
978  * ```
979  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
980  * ```
981  *
982  * Roles can be used to represent a set of permissions. To restrict access to a
983  * function call, use {hasRole}:
984  *
985  * ```
986  * function foo() public {
987  *     require(hasRole(MY_ROLE, msg.sender));
988  *     ...
989  * }
990  * ```
991  *
992  * Roles can be granted and revoked dynamically via the {grantRole} and
993  * {revokeRole} functions. Each role has an associated admin role, and only
994  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
995  *
996  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
997  * that only accounts with this role will be able to grant or revoke other
998  * roles. More complex role relationships can be created by using
999  * {_setRoleAdmin}.
1000  *
1001  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1002  * grant and revoke this role. Extra precautions should be taken to secure
1003  * accounts that have been granted it.
1004  */
1005 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1006     struct RoleData {
1007         mapping(address => bool) members;
1008         bytes32 adminRole;
1009     }
1010 
1011     mapping(bytes32 => RoleData) private _roles;
1012 
1013     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1014 
1015     /**
1016      * @dev Modifier that checks that an account has a specific role. Reverts
1017      * with a standardized message including the required role.
1018      *
1019      * The format of the revert reason is given by the following regular expression:
1020      *
1021      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1022      *
1023      * _Available since v4.1._
1024      */
1025     modifier onlyRole(bytes32 role) {
1026         _checkRole(role, _msgSender());
1027         _;
1028     }
1029 
1030     /**
1031      * @dev See {IERC165-supportsInterface}.
1032      */
1033     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1034         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1035     }
1036 
1037     /**
1038      * @dev Returns `true` if `account` has been granted `role`.
1039      */
1040     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1041         return _roles[role].members[account];
1042     }
1043 
1044     /**
1045      * @dev Revert with a standard message if `account` is missing `role`.
1046      *
1047      * The format of the revert reason is given by the following regular expression:
1048      *
1049      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1050      */
1051     function _checkRole(bytes32 role, address account) internal view virtual {
1052         if (!hasRole(role, account)) {
1053             revert(
1054                 string(
1055                     abi.encodePacked(
1056                         "AccessControl: account ",
1057                         Strings.toHexString(uint160(account), 20),
1058                         " is missing role ",
1059                         Strings.toHexString(uint256(role), 32)
1060                     )
1061                 )
1062             );
1063         }
1064     }
1065 
1066     /**
1067      * @dev Returns the admin role that controls `role`. See {grantRole} and
1068      * {revokeRole}.
1069      *
1070      * To change a role's admin, use {_setRoleAdmin}.
1071      */
1072     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1073         return _roles[role].adminRole;
1074     }
1075 
1076     /**
1077      * @dev Grants `role` to `account`.
1078      *
1079      * If `account` had not been already granted `role`, emits a {RoleGranted}
1080      * event.
1081      *
1082      * Requirements:
1083      *
1084      * - the caller must have ``role``'s admin role.
1085      */
1086     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1087         _grantRole(role, account);
1088     }
1089 
1090     /**
1091      * @dev Revokes `role` from `account`.
1092      *
1093      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1094      *
1095      * Requirements:
1096      *
1097      * - the caller must have ``role``'s admin role.
1098      */
1099     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1100         _revokeRole(role, account);
1101     }
1102 
1103     /**
1104      * @dev Revokes `role` from the calling account.
1105      *
1106      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1107      * purpose is to provide a mechanism for accounts to lose their privileges
1108      * if they are compromised (such as when a trusted device is misplaced).
1109      *
1110      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1111      * event.
1112      *
1113      * Requirements:
1114      *
1115      * - the caller must be `account`.
1116      */
1117     function renounceRole(bytes32 role, address account) public virtual override {
1118         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1119 
1120         _revokeRole(role, account);
1121     }
1122 
1123     /**
1124      * @dev Grants `role` to `account`.
1125      *
1126      * If `account` had not been already granted `role`, emits a {RoleGranted}
1127      * event. Note that unlike {grantRole}, this function doesn't perform any
1128      * checks on the calling account.
1129      *
1130      * [WARNING]
1131      * ====
1132      * This function should only be called from the constructor when setting
1133      * up the initial roles for the system.
1134      *
1135      * Using this function in any other way is effectively circumventing the admin
1136      * system imposed by {AccessControl}.
1137      * ====
1138      *
1139      * NOTE: This function is deprecated in favor of {_grantRole}.
1140      */
1141     function _setupRole(bytes32 role, address account) internal virtual {
1142         _grantRole(role, account);
1143     }
1144 
1145     /**
1146      * @dev Sets `adminRole` as ``role``'s admin role.
1147      *
1148      * Emits a {RoleAdminChanged} event.
1149      */
1150     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1151         bytes32 previousAdminRole = getRoleAdmin(role);
1152         _roles[role].adminRole = adminRole;
1153         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1154     }
1155 
1156     /**
1157      * @dev Grants `role` to `account`.
1158      *
1159      * Internal function without access restriction.
1160      */
1161     function _grantRole(bytes32 role, address account) internal virtual {
1162         if (!hasRole(role, account)) {
1163             _roles[role].members[account] = true;
1164             emit RoleGranted(role, account, _msgSender());
1165         }
1166     }
1167 
1168     /**
1169      * @dev Revokes `role` from `account`.
1170      *
1171      * Internal function without access restriction.
1172      */
1173     function _revokeRole(bytes32 role, address account) internal virtual {
1174         if (hasRole(role, account)) {
1175             _roles[role].members[account] = false;
1176             emit RoleRevoked(role, account, _msgSender());
1177         }
1178     }
1179 }
1180 
1181 
1182 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1183 
1184 pragma solidity ^0.8.0;
1185 
1186 /**
1187  * @dev Contract module that helps prevent reentrant calls to a function.
1188  *
1189  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1190  * available, which can be applied to functions to make sure there are no nested
1191  * (reentrant) calls to them.
1192  *
1193  * Note that because there is a single `nonReentrant` guard, functions marked as
1194  * `nonReentrant` may not call one another. This can be worked around by making
1195  * those functions `private`, and then adding `external` `nonReentrant` entry
1196  * points to them.
1197  *
1198  * TIP: If you would like to learn more about reentrancy and alternative ways
1199  * to protect against it, check out our blog post
1200  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1201  */
1202 abstract contract ReentrancyGuard {
1203     // Booleans are more expensive than uint256 or any type that takes up a full
1204     // word because each write operation emits an extra SLOAD to first read the
1205     // slot's contents, replace the bits taken up by the boolean, and then write
1206     // back. This is the compiler's defense against contract upgrades and
1207     // pointer aliasing, and it cannot be disabled.
1208 
1209     // The values being non-zero value makes deployment a bit more expensive,
1210     // but in exchange the refund on every call to nonReentrant will be lower in
1211     // amount. Since refunds are capped to a percentage of the total
1212     // transaction's gas, it is best to keep them low in cases like this one, to
1213     // increase the likelihood of the full refund coming into effect.
1214     uint256 private constant _NOT_ENTERED = 1;
1215     uint256 private constant _ENTERED = 2;
1216 
1217     uint256 private _status;
1218 
1219     constructor() {
1220         _status = _NOT_ENTERED;
1221     }
1222 
1223     /**
1224      * @dev Prevents a contract from calling itself, directly or indirectly.
1225      * Calling a `nonReentrant` function from another `nonReentrant`
1226      * function is not supported. It is possible to prevent this from happening
1227      * by making the `nonReentrant` function external, and making it call a
1228      * `private` function that does the actual work.
1229      */
1230     modifier nonReentrant() {
1231         // On the first call to nonReentrant, _notEntered will be true
1232         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1233 
1234         // Any calls to nonReentrant after this point will fail
1235         _status = _ENTERED;
1236 
1237         _;
1238 
1239         // By storing the original value once again, a refund is triggered (see
1240         // https://eips.ethereum.org/EIPS/eip-2200)
1241         _status = _NOT_ENTERED;
1242     }
1243 }
1244 
1245 
1246 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1247 
1248 pragma solidity ^0.8.0;
1249 
1250 
1251 /**
1252  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1253  * @dev See https://eips.ethereum.org/EIPS/eip-721
1254  */
1255 interface IERC721Enumerable is IERC721 {
1256     /**
1257      * @dev Returns the total amount of tokens stored by the contract.
1258      */
1259     function totalSupply() external view returns (uint256);
1260 
1261     /**
1262      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1263      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1264      */
1265     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1266 
1267     /**
1268      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1269      * Use along with {totalSupply} to enumerate all tokens.
1270      */
1271     function tokenByIndex(uint256 index) external view returns (uint256);
1272 }
1273 
1274 
1275 // Creator: Chiru Labs
1276 
1277 pragma solidity ^0.8.4;
1278 
1279 
1280 error ApprovalCallerNotOwnerNorApproved();
1281 error ApprovalQueryForNonexistentToken();
1282 error ApproveToCaller();
1283 error ApprovalToCurrentOwner();
1284 error BalanceQueryForZeroAddress();
1285 error MintToZeroAddress();
1286 error MintZeroQuantity();
1287 error OwnerQueryForNonexistentToken();
1288 error TransferCallerNotOwnerNorApproved();
1289 error TransferFromIncorrectOwner();
1290 error TransferToNonERC721ReceiverImplementer();
1291 error TransferToZeroAddress();
1292 error URIQueryForNonexistentToken();
1293 
1294 /**
1295  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1296  * the Metadata extension. Built to optimize for lower gas during batch mints.
1297  *
1298  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1299  *
1300  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1301  *
1302  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1303  */
1304 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1305     using Address for address;
1306     using Strings for uint256;
1307 
1308     // Compiler will pack this into a single 256bit word.
1309     struct TokenOwnership {
1310         // The address of the owner.
1311         address addr;
1312         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1313         uint64 startTimestamp;
1314         // Whether the token has been burned.
1315         bool burned;
1316     }
1317 
1318     // Compiler will pack this into a single 256bit word.
1319     struct AddressData {
1320         // Realistically, 2**64-1 is more than enough.
1321         uint64 balance;
1322         // Keeps track of mint count with minimal overhead for tokenomics.
1323         uint64 numberMinted;
1324         // Keeps track of burn count with minimal overhead for tokenomics.
1325         uint64 numberBurned;
1326         // For miscellaneous variable(s) pertaining to the address
1327         // (e.g. number of whitelist mint slots used).
1328         // If there are multiple variables, please pack them into a uint64.
1329         uint64 aux;
1330     }
1331 
1332     // The tokenId of the next token to be minted.
1333     uint256 internal _currentIndex;
1334 
1335     // The number of tokens burned.
1336     uint256 internal _burnCounter;
1337 
1338     // Token name
1339     string private _name;
1340 
1341     // Token symbol
1342     string private _symbol;
1343 
1344     // Mapping from token ID to ownership details
1345     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1346     mapping(uint256 => TokenOwnership) internal _ownerships;
1347 
1348     // Mapping owner address to address data
1349     mapping(address => AddressData) private _addressData;
1350 
1351     // Mapping from token ID to approved address
1352     mapping(uint256 => address) private _tokenApprovals;
1353 
1354     // Mapping from owner to operator approvals
1355     mapping(address => mapping(address => bool)) private _operatorApprovals;
1356 
1357     constructor(string memory name_, string memory symbol_) {
1358         _name = name_;
1359         _symbol = symbol_;
1360         _currentIndex = _startTokenId();
1361     }
1362 
1363     /**
1364      * To change the starting tokenId, please override this function.
1365      */
1366     function _startTokenId() internal view virtual returns (uint256) {
1367         return 0;
1368     }
1369 
1370     /**
1371      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1372      */
1373     function totalSupply() public view returns (uint256) {
1374         // Counter underflow is impossible as _burnCounter cannot be incremented
1375         // more than _currentIndex - _startTokenId() times
1376         unchecked {
1377             return _currentIndex - _burnCounter - _startTokenId();
1378         }
1379     }
1380 
1381     /**
1382      * Returns the total amount of tokens minted in the contract.
1383      */
1384     function _totalMinted() internal view returns (uint256) {
1385         // Counter underflow is impossible as _currentIndex does not decrement,
1386         // and it is initialized to _startTokenId()
1387         unchecked {
1388             return _currentIndex - _startTokenId();
1389         }
1390     }
1391 
1392     /**
1393      * @dev See {IERC165-supportsInterface}.
1394      */
1395     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1396         return
1397             interfaceId == type(IERC721).interfaceId ||
1398             interfaceId == type(IERC721Metadata).interfaceId ||
1399             super.supportsInterface(interfaceId);
1400     }
1401 
1402     /**
1403      * @dev See {IERC721-balanceOf}.
1404      */
1405     function balanceOf(address owner) public view override returns (uint256) {
1406         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1407         return uint256(_addressData[owner].balance);
1408     }
1409 
1410     /**
1411      * Returns the number of tokens minted by `owner`.
1412      */
1413     function _numberMinted(address owner) internal view returns (uint256) {
1414         return uint256(_addressData[owner].numberMinted);
1415     }
1416 
1417     /**
1418      * Returns the number of tokens burned by or on behalf of `owner`.
1419      */
1420     function _numberBurned(address owner) internal view returns (uint256) {
1421         return uint256(_addressData[owner].numberBurned);
1422     }
1423 
1424     /**
1425      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1426      */
1427     function _getAux(address owner) internal view returns (uint64) {
1428         return _addressData[owner].aux;
1429     }
1430 
1431     /**
1432      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1433      * If there are multiple variables, please pack them into a uint64.
1434      */
1435     function _setAux(address owner, uint64 aux) internal {
1436         _addressData[owner].aux = aux;
1437     }
1438 
1439     /**
1440      * Gas spent here starts off proportional to the maximum mint batch size.
1441      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1442      */
1443     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1444         uint256 curr = tokenId;
1445 
1446         unchecked {
1447             if (_startTokenId() <= curr && curr < _currentIndex) {
1448                 TokenOwnership memory ownership = _ownerships[curr];
1449                 if (!ownership.burned) {
1450                     if (ownership.addr != address(0)) {
1451                         return ownership;
1452                     }
1453                     // Invariant:
1454                     // There will always be an ownership that has an address and is not burned
1455                     // before an ownership that does not have an address and is not burned.
1456                     // Hence, curr will not underflow.
1457                     while (true) {
1458                         curr--;
1459                         ownership = _ownerships[curr];
1460                         if (ownership.addr != address(0)) {
1461                             return ownership;
1462                         }
1463                     }
1464                 }
1465             }
1466         }
1467         revert OwnerQueryForNonexistentToken();
1468     }
1469 
1470     /**
1471      * @dev See {IERC721-ownerOf}.
1472      */
1473     function ownerOf(uint256 tokenId) public view override returns (address) {
1474         return _ownershipOf(tokenId).addr;
1475     }
1476 
1477     /**
1478      * @dev See {IERC721Metadata-name}.
1479      */
1480     function name() public view virtual override returns (string memory) {
1481         return _name;
1482     }
1483 
1484     /**
1485      * @dev See {IERC721Metadata-symbol}.
1486      */
1487     function symbol() public view virtual override returns (string memory) {
1488         return _symbol;
1489     }
1490 
1491     /**
1492      * @dev See {IERC721Metadata-tokenURI}.
1493      */
1494     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1495         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1496 
1497         string memory baseURI = _baseURI();
1498         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1499     }
1500 
1501     /**
1502      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1503      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1504      * by default, can be overriden in child contracts.
1505      */
1506     function _baseURI() internal view virtual returns (string memory) {
1507         return '';
1508     }
1509 
1510     /**
1511      * @dev See {IERC721-approve}.
1512      */
1513     function approve(address to, uint256 tokenId) public override {
1514         address owner = ERC721A.ownerOf(tokenId);
1515         if (to == owner) revert ApprovalToCurrentOwner();
1516 
1517         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1518             revert ApprovalCallerNotOwnerNorApproved();
1519         }
1520 
1521         _approve(to, tokenId, owner);
1522     }
1523 
1524     /**
1525      * @dev See {IERC721-getApproved}.
1526      */
1527     function getApproved(uint256 tokenId) public view override returns (address) {
1528         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1529 
1530         return _tokenApprovals[tokenId];
1531     }
1532 
1533     /**
1534      * @dev See {IERC721-setApprovalForAll}.
1535      */
1536     function setApprovalForAll(address operator, bool approved) public virtual override {
1537         if (operator == _msgSender()) revert ApproveToCaller();
1538 
1539         _operatorApprovals[_msgSender()][operator] = approved;
1540         emit ApprovalForAll(_msgSender(), operator, approved);
1541     }
1542 
1543     /**
1544      * @dev See {IERC721-isApprovedForAll}.
1545      */
1546     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1547         return _operatorApprovals[owner][operator];
1548     }
1549 
1550     /**
1551      * @dev See {IERC721-transferFrom}.
1552      */
1553     function transferFrom(
1554         address from,
1555         address to,
1556         uint256 tokenId
1557     ) public virtual override {
1558         _transfer(from, to, tokenId);
1559     }
1560 
1561     /**
1562      * @dev See {IERC721-safeTransferFrom}.
1563      */
1564     function safeTransferFrom(
1565         address from,
1566         address to,
1567         uint256 tokenId
1568     ) public virtual override {
1569         safeTransferFrom(from, to, tokenId, '');
1570     }
1571 
1572     /**
1573      * @dev See {IERC721-safeTransferFrom}.
1574      */
1575     function safeTransferFrom(
1576         address from,
1577         address to,
1578         uint256 tokenId,
1579         bytes memory _data
1580     ) public virtual override {
1581         _transfer(from, to, tokenId);
1582         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1583             revert TransferToNonERC721ReceiverImplementer();
1584         }
1585     }
1586 
1587     /**
1588      * @dev Returns whether `tokenId` exists.
1589      *
1590      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1591      *
1592      * Tokens start existing when they are minted (`_mint`),
1593      */
1594     function _exists(uint256 tokenId) internal view returns (bool) {
1595         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1596     }
1597 
1598     function _safeMint(address to, uint256 quantity) internal {
1599         _safeMint(to, quantity, '');
1600     }
1601 
1602     /**
1603      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1604      *
1605      * Requirements:
1606      *
1607      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1608      * - `quantity` must be greater than 0.
1609      *
1610      * Emits a {Transfer} event.
1611      */
1612     function _safeMint(
1613         address to,
1614         uint256 quantity,
1615         bytes memory _data
1616     ) internal {
1617         _mint(to, quantity, _data, true);
1618     }
1619 
1620     /**
1621      * @dev Mints `quantity` tokens and transfers them to `to`.
1622      *
1623      * Requirements:
1624      *
1625      * - `to` cannot be the zero address.
1626      * - `quantity` must be greater than 0.
1627      *
1628      * Emits a {Transfer} event.
1629      */
1630     function _mint(
1631         address to,
1632         uint256 quantity,
1633         bytes memory _data,
1634         bool safe
1635     ) internal {
1636         uint256 startTokenId = _currentIndex;
1637         if (to == address(0)) revert MintToZeroAddress();
1638         if (quantity == 0) revert MintZeroQuantity();
1639 
1640         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1641 
1642         // Overflows are incredibly unrealistic.
1643         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1644         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1645         unchecked {
1646             _addressData[to].balance += uint64(quantity);
1647             _addressData[to].numberMinted += uint64(quantity);
1648 
1649             _ownerships[startTokenId].addr = to;
1650             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1651 
1652             uint256 updatedIndex = startTokenId;
1653             uint256 end = updatedIndex + quantity;
1654 
1655             if (safe && to.isContract()) {
1656                 do {
1657                     emit Transfer(address(0), to, updatedIndex);
1658                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1659                         revert TransferToNonERC721ReceiverImplementer();
1660                     }
1661                 } while (updatedIndex != end);
1662                 // Reentrancy protection
1663                 if (_currentIndex != startTokenId) revert();
1664             } else {
1665                 do {
1666                     emit Transfer(address(0), to, updatedIndex++);
1667                 } while (updatedIndex != end);
1668             }
1669             _currentIndex = updatedIndex;
1670         }
1671         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1672     }
1673 
1674     /**
1675      * @dev Transfers `tokenId` from `from` to `to`.
1676      *
1677      * Requirements:
1678      *
1679      * - `to` cannot be the zero address.
1680      * - `tokenId` token must be owned by `from`.
1681      *
1682      * Emits a {Transfer} event.
1683      */
1684     function _transfer(
1685         address from,
1686         address to,
1687         uint256 tokenId
1688     ) private {
1689         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1690 
1691         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1692 
1693         bool isApprovedOrOwner = (_msgSender() == from ||
1694             isApprovedForAll(from, _msgSender()) ||
1695             getApproved(tokenId) == _msgSender());
1696 
1697         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1698         if (to == address(0)) revert TransferToZeroAddress();
1699 
1700         _beforeTokenTransfers(from, to, tokenId, 1);
1701 
1702         // Clear approvals from the previous owner
1703         _approve(address(0), tokenId, from);
1704 
1705         // Underflow of the sender's balance is impossible because we check for
1706         // ownership above and the recipient's balance can't realistically overflow.
1707         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1708         unchecked {
1709             _addressData[from].balance -= 1;
1710             _addressData[to].balance += 1;
1711 
1712             TokenOwnership storage currSlot = _ownerships[tokenId];
1713             currSlot.addr = to;
1714             currSlot.startTimestamp = uint64(block.timestamp);
1715 
1716             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1717             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1718             uint256 nextTokenId = tokenId + 1;
1719             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1720             if (nextSlot.addr == address(0)) {
1721                 // This will suffice for checking _exists(nextTokenId),
1722                 // as a burned slot cannot contain the zero address.
1723                 if (nextTokenId != _currentIndex) {
1724                     nextSlot.addr = from;
1725                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1726                 }
1727             }
1728         }
1729 
1730         emit Transfer(from, to, tokenId);
1731         _afterTokenTransfers(from, to, tokenId, 1);
1732     }
1733 
1734     /**
1735      * @dev This is equivalent to _burn(tokenId, false)
1736      */
1737     function _burn(uint256 tokenId) internal virtual {
1738         _burn(tokenId, false);
1739     }
1740 
1741     /**
1742      * @dev Destroys `tokenId`.
1743      * The approval is cleared when the token is burned.
1744      *
1745      * Requirements:
1746      *
1747      * - `tokenId` must exist.
1748      *
1749      * Emits a {Transfer} event.
1750      */
1751     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1752         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1753 
1754         address from = prevOwnership.addr;
1755 
1756         if (approvalCheck) {
1757             bool isApprovedOrOwner = (_msgSender() == from ||
1758                 isApprovedForAll(from, _msgSender()) ||
1759                 getApproved(tokenId) == _msgSender());
1760 
1761             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1762         }
1763 
1764         _beforeTokenTransfers(from, address(0), tokenId, 1);
1765 
1766         // Clear approvals from the previous owner
1767         _approve(address(0), tokenId, from);
1768 
1769         // Underflow of the sender's balance is impossible because we check for
1770         // ownership above and the recipient's balance can't realistically overflow.
1771         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1772         unchecked {
1773             AddressData storage addressData = _addressData[from];
1774             addressData.balance -= 1;
1775             addressData.numberBurned += 1;
1776 
1777             // Keep track of who burned the token, and the timestamp of burning.
1778             TokenOwnership storage currSlot = _ownerships[tokenId];
1779             currSlot.addr = from;
1780             currSlot.startTimestamp = uint64(block.timestamp);
1781             currSlot.burned = true;
1782 
1783             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1784             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1785             uint256 nextTokenId = tokenId + 1;
1786             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1787             if (nextSlot.addr == address(0)) {
1788                 // This will suffice for checking _exists(nextTokenId),
1789                 // as a burned slot cannot contain the zero address.
1790                 if (nextTokenId != _currentIndex) {
1791                     nextSlot.addr = from;
1792                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1793                 }
1794             }
1795         }
1796 
1797         emit Transfer(from, address(0), tokenId);
1798         _afterTokenTransfers(from, address(0), tokenId, 1);
1799 
1800         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1801         unchecked {
1802             _burnCounter++;
1803         }
1804     }
1805 
1806     /**
1807      * @dev Approve `to` to operate on `tokenId`
1808      *
1809      * Emits a {Approval} event.
1810      */
1811     function _approve(
1812         address to,
1813         uint256 tokenId,
1814         address owner
1815     ) private {
1816         _tokenApprovals[tokenId] = to;
1817         emit Approval(owner, to, tokenId);
1818     }
1819 
1820     /**
1821      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1822      *
1823      * @param from address representing the previous owner of the given token ID
1824      * @param to target address that will receive the tokens
1825      * @param tokenId uint256 ID of the token to be transferred
1826      * @param _data bytes optional data to send along with the call
1827      * @return bool whether the call correctly returned the expected magic value
1828      */
1829     function _checkContractOnERC721Received(
1830         address from,
1831         address to,
1832         uint256 tokenId,
1833         bytes memory _data
1834     ) private returns (bool) {
1835         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1836             return retval == IERC721Receiver(to).onERC721Received.selector;
1837         } catch (bytes memory reason) {
1838             if (reason.length == 0) {
1839                 revert TransferToNonERC721ReceiverImplementer();
1840             } else {
1841                 assembly {
1842                     revert(add(32, reason), mload(reason))
1843                 }
1844             }
1845         }
1846     }
1847 
1848     /**
1849      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1850      * And also called before burning one token.
1851      *
1852      * startTokenId - the first token id to be transferred
1853      * quantity - the amount to be transferred
1854      *
1855      * Calling conditions:
1856      *
1857      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1858      * transferred to `to`.
1859      * - When `from` is zero, `tokenId` will be minted for `to`.
1860      * - When `to` is zero, `tokenId` will be burned by `from`.
1861      * - `from` and `to` are never both zero.
1862      */
1863     function _beforeTokenTransfers(
1864         address from,
1865         address to,
1866         uint256 startTokenId,
1867         uint256 quantity
1868     ) internal virtual {}
1869 
1870     /**
1871      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1872      * minting.
1873      * And also called after one token has been burned.
1874      *
1875      * startTokenId - the first token id to be transferred
1876      * quantity - the amount to be transferred
1877      *
1878      * Calling conditions:
1879      *
1880      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1881      * transferred to `to`.
1882      * - When `from` is zero, `tokenId` has been minted for `to`.
1883      * - When `to` is zero, `tokenId` has been burned by `from`.
1884      * - `from` and `to` are never both zero.
1885      */
1886     function _afterTokenTransfers(
1887         address from,
1888         address to,
1889         uint256 startTokenId,
1890         uint256 quantity
1891     ) internal virtual {}
1892 }
1893 
1894 
1895 pragma solidity ^0.8.7;
1896 
1897 contract y00tsDickButts is ERC721A, Ownable, ReentrancyGuard,MerkleDistributorV2,ClaimBitmap,AccessControl {
1898 
1899     bytes32 public constant SUPPORT_ROLE = keccak256("SUPPORT");
1900     uint256 public MAX_PUBLIC_PER_TX = 10;
1901     uint256 public MAX_CLAIM_PER_TX = 5;
1902     uint256 public MAX_RESERVE_SUPPLY = 10;
1903     uint256 public MAX_PUBLIC_SUPPLY = 5000;
1904     uint256 public ReservedForYYCHolders = 5000;
1905     uint256 public maxSupply = 10000;
1906     uint256 public price = 0.0033 ether;
1907     uint256 public claimedAmount = 0;
1908 
1909   
1910     mapping(uint256 => uint256) private claimedBitMap;
1911 
1912     string public provenance;
1913     string private _baseURIextended;
1914 
1915     uint256 public reserveSupply = MAX_RESERVE_SUPPLY;
1916     uint256 public maxPublicSupply = MAX_PUBLIC_SUPPLY;
1917 
1918     IERC721Enumerable public immutable baseContractAddress;
1919     address payable public immutable shareholderAddress;
1920     bool public saleActive;
1921     bool public claimActive;
1922 
1923     /**
1924      * cannot initialize shareholder address to 0
1925      */
1926     error ShareholderAddressIsZeroAddress();
1927 
1928     /**
1929      * cannot set base contract address if not ERC721Enumerable
1930      */
1931     error ContractIsNotERC721Enumerable();
1932 
1933     /**
1934      * cannot exceed maximum supply
1935      */
1936     error PurchaseWouldExceedMaximumSupply();
1937 
1938     /**
1939      * cannot mint if public sale is not active
1940      */
1941     error PublicSaleIsNotActive();
1942 
1943     /**
1944      * cannot exceed maximum reserve supply
1945      */
1946     error ExceedMaximumReserveSupply();
1947 
1948      /**
1949      * cannot exceed maximum public supply
1950      */
1951     error ExceedMaximumPublicSupply();
1952 
1953     /**
1954      * ether value sent is not correct
1955      */
1956     error EtherValueSentIsNotCorrect();
1957 
1958     /**
1959      * no YYC left to claim
1960      */
1961     error NoYYCOwned();
1962 
1963     /**
1964      * cannot exceed maximum public mint
1965      */
1966     error PurchaseWouldExceedMaximumPublicMint();
1967 
1968 
1969     /**
1970      * cannot exceed maximum public mint
1971      */
1972     error PurchaseWouldExceedMaximumClaimMint();
1973 
1974     /**
1975      * withdraw failed
1976      */
1977     error WithdrawFailed();
1978 
1979     /**
1980      * cannot mint if mint pass claim is not active
1981      */
1982     error ClaimIsNotActive();
1983 
1984     /**
1985      * cannot claim if token id has already been claimed
1986      */
1987     error TokenIdAlreadyClaimed(uint256 tokenId);
1988 
1989     /**
1990      * cannot exceed claim supply
1991      */
1992     error PurchaseWouldExceedClaimSupply();
1993 
1994       /**
1995      * cannot exceed available claim
1996      */
1997     error PurchaseWouldExceedAvailableClaim();
1998 
1999     /**
2000      * callee is not the owner of the token id in the base contract
2001      */
2002     error NotOwnerOfMintPass(uint256 tokenId);
2003 
2004     /**
2005      * cannot set the price to 0
2006      */
2007     error SalePriceCannotBeZero();
2008 
2009     /**
2010      * cannot set supply to less than the total supply
2011      */
2012     error MaxSupplyLessThanTotalSupply();
2013 
2014     /**
2015      * cannot change states when minting is enabled
2016      */
2017     error MintingIsEnabled();
2018 
2019     /**
2020      * @notice constructor
2021      * @param shareholderAddress_ the shareholder address
2022      * @param contractAddress the contract address for mint passes
2023      */
2024     constructor(address payable shareholderAddress_, address contractAddress) ERC721A("y00ts DickButts", "YDB") {
2025         if (shareholderAddress_ == address(0)) revert ShareholderAddressIsZeroAddress();
2026         if (!IERC721Enumerable(contractAddress).supportsInterface(0x780e9d63)) revert ContractIsNotERC721Enumerable();
2027 
2028         // set immutable variables
2029         shareholderAddress = shareholderAddress_;
2030         baseContractAddress = IERC721Enumerable(contractAddress);
2031 
2032         // setup
2033         _initializeBitmap(IERC721Enumerable(contractAddress).totalSupply());
2034         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
2035         _setupRole(SUPPORT_ROLE, msg.sender);
2036     }
2037 
2038     /**
2039      * @notice checks to see if amount of tokens to be minted would exceed the maximum supply allowed
2040      * @param numberOfTokens the number of tokens to be minted
2041      */
2042     modifier supplyAvailable(uint256 numberOfTokens) {
2043         if (totalSupply() + numberOfTokens > maxSupply) revert PurchaseWouldExceedMaximumSupply();
2044         _;
2045     }
2046 
2047     /**
2048      * @notice checks to see whether saleActive is true
2049      */
2050     modifier isPublicSaleActive() {
2051         if (!saleActive) revert PublicSaleIsNotActive();
2052         _;
2053     }
2054 
2055     /**
2056      * @notice checks to see whether claimActive is true
2057      */
2058     modifier isClaimActive() {
2059         if (!claimActive) revert ClaimIsNotActive();
2060         _;
2061     }
2062 
2063     /**
2064      * @notice emitted when the price has been changed
2065      */
2066     event PriceChanged(uint256 newPrice);
2067 
2068     /**
2069      * @notice emitted when the max supply has been changed
2070      */
2071     event MaxSupplyChanged(uint256 newMaxSupply);
2072 
2073     ////////////////
2074     // admin
2075     ////////////////
2076     /**
2077      * @notice reserves a number of tokens
2078      * @param numberOfTokens the number of tokens to be minted
2079      */
2080     function devMint(uint256 numberOfTokens)
2081         external
2082         onlyRole(SUPPORT_ROLE)
2083         supplyAvailable(numberOfTokens)
2084         nonReentrant
2085     {
2086         uint256 reserveSupplyRemaining = reserveSupply;
2087 
2088         if (reserveSupplyRemaining < numberOfTokens) revert ExceedMaximumReserveSupply();
2089         
2090 
2091         reserveSupply = reserveSupplyRemaining - numberOfTokens;
2092         _safeMint(msg.sender, numberOfTokens);
2093     }
2094     
2095 
2096     /**
2097      * @notice allows public sale minting
2098      * @param state the state of the public sale
2099      */
2100     function setSaleActive(bool state) external onlyRole(SUPPORT_ROLE) {
2101         saleActive = state;
2102     }
2103 
2104     /**
2105      * @notice allows claiming of tokens
2106      * @param state the state of allowing claims to be made
2107      */
2108     function setClaimActive(bool state) external onlyRole(SUPPORT_ROLE) {
2109         claimActive = state;
2110     }
2111 
2112     /**
2113      * @notice set a new token price in wei
2114      * @param newPriceInWei the new price to set, per token, in wei
2115      */
2116     function setPrice(uint256 newPriceInWei) external onlyRole(SUPPORT_ROLE) {
2117        
2118         price = newPriceInWei;
2119 
2120         emit PriceChanged(price);
2121     }
2122   
2123 
2124     function setReserved(uint256 _MaxClaims) external onlyRole(SUPPORT_ROLE) {
2125        
2126         ReservedForYYCHolders = _MaxClaims;
2127 
2128     }
2129 
2130 
2131     /**
2132      * @notice set a new max supply
2133      * @param newMaxSupply the new max supply to set
2134      */
2135     function setMaxSupply(uint256 newMaxSupply) external onlyRole(SUPPORT_ROLE) {
2136      
2137         maxSupply = newMaxSupply;
2138 
2139         emit MaxSupplyChanged(maxSupply);
2140     }
2141 
2142     function setMaxPublicSupply(uint256 newMaxPublicSupply_) external onlyOwner {
2143         MAX_PUBLIC_SUPPLY = newMaxPublicSupply_;
2144     }
2145 
2146     function setMaxClaimPerTx(uint256 newClaimPerTx_) external onlyOwner {
2147         MAX_CLAIM_PER_TX = newClaimPerTx_;
2148     }
2149 
2150     ////////////////
2151     // allow list
2152     ////////////////
2153     /**
2154      * @notice allows minting from a list of clients
2155      * @param allowListActive the state of the allow list
2156      */
2157     function setAllowListActive(bool allowListActive) external onlyRole(SUPPORT_ROLE) {
2158         _setAllowListActive(allowListActive);
2159     }
2160 
2161     /**
2162      * @notice sets the merkle root for the allow list
2163      * @param merkleRoot the merkle root
2164      */
2165     function setAllowList(bytes32 merkleRoot) external onlyRole(SUPPORT_ROLE) {
2166         _setAllowList(merkleRoot);
2167     }
2168 
2169     ////////////////
2170     // tokens
2171     ////////////////
2172     /**
2173      * @notice sets the base uri for {_baseURI}
2174      * @param baseURI_ the base uri
2175      */
2176     function setBaseUri(string memory baseURI_) external onlyRole(SUPPORT_ROLE) {
2177         _baseURIextended = baseURI_;
2178     }
2179 
2180 
2181     function BaseURI() internal view virtual returns (string memory) {
2182         return _baseURIextended;
2183     }
2184 
2185      function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2186         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
2187         string memory currentBaseURI = BaseURI();
2188         return bytes(currentBaseURI).length > 0
2189             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId+1),".json"))
2190             : "";
2191     }
2192 
2193     /**
2194      * @notice sets the provenance hash
2195      * @param provenance_ the provenance hash
2196      */
2197     function setProvenance(string memory provenance_) external onlyRole(SUPPORT_ROLE) {
2198         provenance = provenance_;
2199     }
2200 
2201     /**
2202      * @notice See {IERC165-supportsInterface}.
2203      * @param interfaceId the interface id
2204      */
2205     function supportsInterface(bytes4 interfaceId)
2206         public
2207         view
2208         virtual
2209         override(ERC721A, AccessControl)
2210         returns (bool)
2211     {
2212         return super.supportsInterface(interfaceId);
2213     }
2214 
2215     /**
2216      * @notice See {ERC721-_burn}. This override additionally clears the royalty information for the token.
2217      * @param tokenId the token id to burn
2218      */
2219     function _burn(uint256 tokenId) internal virtual override {
2220         super._burn(tokenId);
2221     }
2222 
2223     ////////////////
2224     // public
2225     ////////////////
2226     /**
2227      * @notice allow claims based on token ids, you can claim up to 2 tokens per mint pass
2228      * each mint pass can be used only once, i.e. claiming 1 token will exhaust a full mint pass
2229      * @param tokenIds array of token ids owned in the base contract
2230      * @param numberOfTokens the number of tokens to be minted
2231      */
2232     function claimByTokenIds(uint256[] memory tokenIds, uint256 numberOfTokens)
2233         public
2234         payable
2235         isClaimActive
2236         supplyAvailable(numberOfTokens)
2237         nonReentrant
2238     {
2239        // uint256 mintPasses = tokenIds.length;
2240        // uint256 mintPassesToClaim = Math.ceilDiv(numberOfTokens, 2);
2241 
2242         if (numberOfTokens > MAX_CLAIM_PER_TX) revert PurchaseWouldExceedMaximumClaimMint();
2243 
2244         uint256 y00tsYatchClubOwned = tokenIds.length;
2245 
2246         uint256 y00tsDickButtsAvailableToClaimFree = Math.floorDiv(y00tsYatchClubOwned, 2);
2247 
2248         //if(mintPassesToClaim > mintPasses) revert PurchaseWouldExceedClaimSupply();
2249 
2250         require((numberOfTokens <= y00tsDickButtsAvailableToClaimFree), "You don't have enough y00tsYC to claim a Dick");
2251         
2252         bool isFree = (numberOfTokens <= y00tsDickButtsAvailableToClaimFree);
2253        
2254         if (isFree)   
2255         {
2256             for (uint256 index; index < (2 * numberOfTokens); index++) {
2257             uint256 tokenId = tokenIds[index];
2258             if (baseContractAddress.ownerOf(tokenId) != msg.sender) revert NotOwnerOfMintPass(tokenId);
2259             if (isClaimed(tokenId)) revert TokenIdAlreadyClaimed(tokenId);
2260 
2261             _setClaimed(tokenId);    
2262            
2263             }
2264 
2265             claimedAmount += numberOfTokens;
2266             _safeMint(msg.sender, numberOfTokens);
2267 
2268         }
2269        
2270     }
2271 
2272 
2273      /**
2274      * @notice get all tokens owned in the base contract, then claims the tokens
2275      * @dev this will revert if any tokens have been claimed already
2276      * @param numberOfTokens the number of tokens to be minted
2277      */
2278     function claim(uint256 numberOfTokens) external payable {
2279         uint256[] memory tokenIds = ownerAvailableIdsToClaim(msg.sender);
2280         claimByTokenIds(tokenIds, numberOfTokens);
2281     }
2282 
2283   
2284     function freeY00tsDickButtsLeftToClaim(address owner) external view returns (uint256){ 
2285         uint256 baseBalance = baseContractAddress.balanceOf(owner);
2286         uint256 amountOwned;
2287 
2288         for (uint256 index ; index < baseBalance; index++) {
2289             if (!isClaimed(baseContractAddress.tokenOfOwnerByIndex(owner, index))) {
2290                 amountOwned++;
2291             }
2292         }
2293       
2294         uint256 y00tsDickButtsAvailableToClaimFree = Math.floorDiv(amountOwned, 2);
2295         return y00tsDickButtsAvailableToClaimFree;
2296     }
2297 
2298     function costCheck() public view returns (uint256) {
2299         return price;
2300     }
2301 
2302 
2303     /**
2304      * @notice utility function to get available ids to claim
2305      * @param from the address to check
2306      */
2307     function ownerAvailableIdsToClaim(address from) public view returns (uint256[] memory) {
2308         uint256 totalYYC = baseContractAddress.balanceOf(from);
2309         uint256[] memory availableTokenIds = new uint256[](totalYYC);
2310 
2311         uint256 amountClaimable;
2312 
2313         for (uint256 index; index < totalYYC; index++) {
2314             uint256 tokenId = baseContractAddress.tokenOfOwnerByIndex(from, index);
2315 
2316             if (!isClaimed(tokenId)) {
2317                 availableTokenIds[amountClaimable] = tokenId;
2318                 amountClaimable++;
2319             }
2320         }
2321 
2322         uint256[] memory unclaimedTokenIds = new uint256[](amountClaimable);
2323         for (uint256 index; index < amountClaimable; index++) {
2324             unclaimedTokenIds[index] = availableTokenIds[index];
2325         }
2326 
2327         return unclaimedTokenIds;
2328     }
2329 
2330     
2331     /**
2332      * @notice allow public minting
2333      * @param numberOfTokens the number of tokens to be minted
2334      */
2335     function mint(uint256 numberOfTokens)
2336         external
2337         payable
2338         isPublicSaleActive
2339         supplyAvailable(numberOfTokens)
2340         nonReentrant
2341     {
2342         
2343         require((MAX_PUBLIC_SUPPLY >= numberOfTokens), "No more public Supply Available ");
2344         
2345         MAX_PUBLIC_SUPPLY = MAX_PUBLIC_SUPPLY - numberOfTokens;
2346         
2347         if (numberOfTokens > MAX_PUBLIC_PER_TX) revert PurchaseWouldExceedMaximumPublicMint();
2348         if (numberOfTokens * price < msg.value) revert EtherValueSentIsNotCorrect();
2349 
2350         _safeMint(msg.sender, numberOfTokens);
2351     }
2352 
2353     function burnDicks(uint256 tokenId) external onlyOwner nonReentrant {
2354         super._burn(tokenId);
2355     }
2356     /**
2357      * @notice withdraws ether from the contract to the shareholder address
2358      */
2359     function withdraw() external onlyOwner nonReentrant {
2360         (bool success, ) = msg.sender.call{value: address(this).balance}("");
2361         require(success, "Transfer failed.");
2362     }
2363 }