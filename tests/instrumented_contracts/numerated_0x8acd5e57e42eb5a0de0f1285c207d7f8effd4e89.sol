1 // SPDX-License-Identifier: UNLICENSED
2 // File: @openzeppelin/contracts/access/IAccessControl.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev External interface of AccessControl declared to support ERC165 detection.
11  */
12 interface IAccessControl {
13     /**
14      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
15      *
16      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
17      * {RoleAdminChanged} not being emitted signaling this.
18      *
19      * _Available since v3.1._
20      */
21     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
22 
23     /**
24      * @dev Emitted when `account` is granted `role`.
25      *
26      * `sender` is the account that originated the contract call, an admin role
27      * bearer except when using {AccessControl-_setupRole}.
28      */
29     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
30 
31     /**
32      * @dev Emitted when `account` is revoked `role`.
33      *
34      * `sender` is the account that originated the contract call:
35      *   - if using `revokeRole`, it is the admin role bearer
36      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
37      */
38     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
39 
40     /**
41      * @dev Returns `true` if `account` has been granted `role`.
42      */
43     function hasRole(bytes32 role, address account) external view returns (bool);
44 
45     /**
46      * @dev Returns the admin role that controls `role`. See {grantRole} and
47      * {revokeRole}.
48      *
49      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
50      */
51     function getRoleAdmin(bytes32 role) external view returns (bytes32);
52 
53     /**
54      * @dev Grants `role` to `account`.
55      *
56      * If `account` had not been already granted `role`, emits a {RoleGranted}
57      * event.
58      *
59      * Requirements:
60      *
61      * - the caller must have ``role``'s admin role.
62      */
63     function grantRole(bytes32 role, address account) external;
64 
65     /**
66      * @dev Revokes `role` from `account`.
67      *
68      * If `account` had been granted `role`, emits a {RoleRevoked} event.
69      *
70      * Requirements:
71      *
72      * - the caller must have ``role``'s admin role.
73      */
74     function revokeRole(bytes32 role, address account) external;
75 
76     /**
77      * @dev Revokes `role` from the calling account.
78      *
79      * Roles are often managed via {grantRole} and {revokeRole}: this function's
80      * purpose is to provide a mechanism for accounts to lose their privileges
81      * if they are compromised (such as when a trusted device is misplaced).
82      *
83      * If the calling account had been granted `role`, emits a {RoleRevoked}
84      * event.
85      *
86      * Requirements:
87      *
88      * - the caller must be `account`.
89      */
90     function renounceRole(bytes32 role, address account) external;
91 }
92 
93 // File: @openzeppelin/contracts/utils/Strings.sol
94 
95 
96 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
97 
98 pragma solidity ^0.8.0;
99 
100 /**
101  * @dev String operations.
102  */
103 library Strings {
104     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
105 
106     /**
107      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
108      */
109     function toString(uint256 value) internal pure returns (string memory) {
110         // Inspired by OraclizeAPI's implementation - MIT licence
111         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
112 
113         if (value == 0) {
114             return "0";
115         }
116         uint256 temp = value;
117         uint256 digits;
118         while (temp != 0) {
119             digits++;
120             temp /= 10;
121         }
122         bytes memory buffer = new bytes(digits);
123         while (value != 0) {
124             digits -= 1;
125             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
126             value /= 10;
127         }
128         return string(buffer);
129     }
130 
131     /**
132      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
133      */
134     function toHexString(uint256 value) internal pure returns (string memory) {
135         if (value == 0) {
136             return "0x00";
137         }
138         uint256 temp = value;
139         uint256 length = 0;
140         while (temp != 0) {
141             length++;
142             temp >>= 8;
143         }
144         return toHexString(value, length);
145     }
146 
147     /**
148      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
149      */
150     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
151         bytes memory buffer = new bytes(2 * length + 2);
152         buffer[0] = "0";
153         buffer[1] = "x";
154         for (uint256 i = 2 * length + 1; i > 1; --i) {
155             buffer[i] = _HEX_SYMBOLS[value & 0xf];
156             value >>= 4;
157         }
158         require(value == 0, "Strings: hex length insufficient");
159         return string(buffer);
160     }
161 }
162 
163 // File: @openzeppelin/contracts/utils/Address.sol
164 
165 
166 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
167 
168 pragma solidity ^0.8.1;
169 
170 /**
171  * @dev Collection of functions related to the address type
172  */
173 library Address {
174     /**
175      * @dev Returns true if `account` is a contract.
176      *
177      * [IMPORTANT]
178      * ====
179      * It is unsafe to assume that an address for which this function returns
180      * false is an externally-owned account (EOA) and not a contract.
181      *
182      * Among others, `isContract` will return false for the following
183      * types of addresses:
184      *
185      *  - an externally-owned account
186      *  - a contract in construction
187      *  - an address where a contract will be created
188      *  - an address where a contract lived, but was destroyed
189      * ====
190      *
191      * [IMPORTANT]
192      * ====
193      * You shouldn't rely on `isContract` to protect against flash loan attacks!
194      *
195      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
196      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
197      * constructor.
198      * ====
199      */
200     function isContract(address account) internal view returns (bool) {
201         // This method relies on extcodesize/address.code.length, which returns 0
202         // for contracts in construction, since the code is only stored at the end
203         // of the constructor execution.
204 
205         return account.code.length > 0;
206     }
207 
208     /**
209      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
210      * `recipient`, forwarding all available gas and reverting on errors.
211      *
212      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
213      * of certain opcodes, possibly making contracts go over the 2300 gas limit
214      * imposed by `transfer`, making them unable to receive funds via
215      * `transfer`. {sendValue} removes this limitation.
216      *
217      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
218      *
219      * IMPORTANT: because control is transferred to `recipient`, care must be
220      * taken to not create reentrancy vulnerabilities. Consider using
221      * {ReentrancyGuard} or the
222      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
223      */
224     function sendValue(address payable recipient, uint256 amount) internal {
225         require(address(this).balance >= amount, "Address: insufficient balance");
226 
227         (bool success, ) = recipient.call{value: amount}("");
228         require(success, "Address: unable to send value, recipient may have reverted");
229     }
230 
231     /**
232      * @dev Performs a Solidity function call using a low level `call`. A
233      * plain `call` is an unsafe replacement for a function call: use this
234      * function instead.
235      *
236      * If `target` reverts with a revert reason, it is bubbled up by this
237      * function (like regular Solidity function calls).
238      *
239      * Returns the raw returned data. To convert to the expected return value,
240      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
241      *
242      * Requirements:
243      *
244      * - `target` must be a contract.
245      * - calling `target` with `data` must not revert.
246      *
247      * _Available since v3.1._
248      */
249     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
250         return functionCall(target, data, "Address: low-level call failed");
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
255      * `errorMessage` as a fallback revert reason when `target` reverts.
256      *
257      * _Available since v3.1._
258      */
259     function functionCall(
260         address target,
261         bytes memory data,
262         string memory errorMessage
263     ) internal returns (bytes memory) {
264         return functionCallWithValue(target, data, 0, errorMessage);
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
269      * but also transferring `value` wei to `target`.
270      *
271      * Requirements:
272      *
273      * - the calling contract must have an ETH balance of at least `value`.
274      * - the called Solidity function must be `payable`.
275      *
276      * _Available since v3.1._
277      */
278     function functionCallWithValue(
279         address target,
280         bytes memory data,
281         uint256 value
282     ) internal returns (bytes memory) {
283         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
288      * with `errorMessage` as a fallback revert reason when `target` reverts.
289      *
290      * _Available since v3.1._
291      */
292     function functionCallWithValue(
293         address target,
294         bytes memory data,
295         uint256 value,
296         string memory errorMessage
297     ) internal returns (bytes memory) {
298         require(address(this).balance >= value, "Address: insufficient balance for call");
299         require(isContract(target), "Address: call to non-contract");
300 
301         (bool success, bytes memory returndata) = target.call{value: value}(data);
302         return verifyCallResult(success, returndata, errorMessage);
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
307      * but performing a static call.
308      *
309      * _Available since v3.3._
310      */
311     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
312         return functionStaticCall(target, data, "Address: low-level static call failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
317      * but performing a static call.
318      *
319      * _Available since v3.3._
320      */
321     function functionStaticCall(
322         address target,
323         bytes memory data,
324         string memory errorMessage
325     ) internal view returns (bytes memory) {
326         require(isContract(target), "Address: static call to non-contract");
327 
328         (bool success, bytes memory returndata) = target.staticcall(data);
329         return verifyCallResult(success, returndata, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but performing a delegate call.
335      *
336      * _Available since v3.4._
337      */
338     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
339         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
344      * but performing a delegate call.
345      *
346      * _Available since v3.4._
347      */
348     function functionDelegateCall(
349         address target,
350         bytes memory data,
351         string memory errorMessage
352     ) internal returns (bytes memory) {
353         require(isContract(target), "Address: delegate call to non-contract");
354 
355         (bool success, bytes memory returndata) = target.delegatecall(data);
356         return verifyCallResult(success, returndata, errorMessage);
357     }
358 
359     /**
360      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
361      * revert reason using the provided one.
362      *
363      * _Available since v4.3._
364      */
365     function verifyCallResult(
366         bool success,
367         bytes memory returndata,
368         string memory errorMessage
369     ) internal pure returns (bytes memory) {
370         if (success) {
371             return returndata;
372         } else {
373             // Look for revert reason and bubble it up if present
374             if (returndata.length > 0) {
375                 // The easiest way to bubble the revert reason is using memory via assembly
376 
377                 assembly {
378                     let returndata_size := mload(returndata)
379                     revert(add(32, returndata), returndata_size)
380                 }
381             } else {
382                 revert(errorMessage);
383             }
384         }
385     }
386 }
387 
388 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
389 
390 
391 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
392 
393 pragma solidity ^0.8.0;
394 
395 /**
396  * @title ERC721 token receiver interface
397  * @dev Interface for any contract that wants to support safeTransfers
398  * from ERC721 asset contracts.
399  */
400 interface IERC721Receiver {
401     /**
402      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
403      * by `operator` from `from`, this function is called.
404      *
405      * It must return its Solidity selector to confirm the token transfer.
406      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
407      *
408      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
409      */
410     function onERC721Received(
411         address operator,
412         address from,
413         uint256 tokenId,
414         bytes calldata data
415     ) external returns (bytes4);
416 }
417 
418 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
419 
420 
421 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
422 
423 pragma solidity ^0.8.0;
424 
425 /**
426  * @dev Interface of the ERC165 standard, as defined in the
427  * https://eips.ethereum.org/EIPS/eip-165[EIP].
428  *
429  * Implementers can declare support of contract interfaces, which can then be
430  * queried by others ({ERC165Checker}).
431  *
432  * For an implementation, see {ERC165}.
433  */
434 interface IERC165 {
435     /**
436      * @dev Returns true if this contract implements the interface defined by
437      * `interfaceId`. See the corresponding
438      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
439      * to learn more about how these ids are created.
440      *
441      * This function call must use less than 30 000 gas.
442      */
443     function supportsInterface(bytes4 interfaceId) external view returns (bool);
444 }
445 
446 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
447 
448 
449 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
450 
451 pragma solidity ^0.8.0;
452 
453 
454 /**
455  * @dev Implementation of the {IERC165} interface.
456  *
457  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
458  * for the additional interface id that will be supported. For example:
459  *
460  * ```solidity
461  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
462  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
463  * }
464  * ```
465  *
466  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
467  */
468 abstract contract ERC165 is IERC165 {
469     /**
470      * @dev See {IERC165-supportsInterface}.
471      */
472     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
473         return interfaceId == type(IERC165).interfaceId;
474     }
475 }
476 
477 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
478 
479 
480 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
481 
482 pragma solidity ^0.8.0;
483 
484 
485 /**
486  * @dev Required interface of an ERC721 compliant contract.
487  */
488 interface IERC721 is IERC165 {
489     /**
490      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
491      */
492     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
493 
494     /**
495      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
496      */
497     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
498 
499     /**
500      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
501      */
502     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
503 
504     /**
505      * @dev Returns the number of tokens in ``owner``'s account.
506      */
507     function balanceOf(address owner) external view returns (uint256 balance);
508 
509     /**
510      * @dev Returns the owner of the `tokenId` token.
511      *
512      * Requirements:
513      *
514      * - `tokenId` must exist.
515      */
516     function ownerOf(uint256 tokenId) external view returns (address owner);
517 
518     /**
519      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
520      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
521      *
522      * Requirements:
523      *
524      * - `from` cannot be the zero address.
525      * - `to` cannot be the zero address.
526      * - `tokenId` token must exist and be owned by `from`.
527      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
528      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
529      *
530      * Emits a {Transfer} event.
531      */
532     function safeTransferFrom(
533         address from,
534         address to,
535         uint256 tokenId
536     ) external;
537 
538     /**
539      * @dev Transfers `tokenId` token from `from` to `to`.
540      *
541      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
542      *
543      * Requirements:
544      *
545      * - `from` cannot be the zero address.
546      * - `to` cannot be the zero address.
547      * - `tokenId` token must be owned by `from`.
548      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
549      *
550      * Emits a {Transfer} event.
551      */
552     function transferFrom(
553         address from,
554         address to,
555         uint256 tokenId
556     ) external;
557 
558     /**
559      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
560      * The approval is cleared when the token is transferred.
561      *
562      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
563      *
564      * Requirements:
565      *
566      * - The caller must own the token or be an approved operator.
567      * - `tokenId` must exist.
568      *
569      * Emits an {Approval} event.
570      */
571     function approve(address to, uint256 tokenId) external;
572 
573     /**
574      * @dev Returns the account approved for `tokenId` token.
575      *
576      * Requirements:
577      *
578      * - `tokenId` must exist.
579      */
580     function getApproved(uint256 tokenId) external view returns (address operator);
581 
582     /**
583      * @dev Approve or remove `operator` as an operator for the caller.
584      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
585      *
586      * Requirements:
587      *
588      * - The `operator` cannot be the caller.
589      *
590      * Emits an {ApprovalForAll} event.
591      */
592     function setApprovalForAll(address operator, bool _approved) external;
593 
594     /**
595      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
596      *
597      * See {setApprovalForAll}
598      */
599     function isApprovedForAll(address owner, address operator) external view returns (bool);
600 
601     /**
602      * @dev Safely transfers `tokenId` token from `from` to `to`.
603      *
604      * Requirements:
605      *
606      * - `from` cannot be the zero address.
607      * - `to` cannot be the zero address.
608      * - `tokenId` token must exist and be owned by `from`.
609      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
610      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
611      *
612      * Emits a {Transfer} event.
613      */
614     function safeTransferFrom(
615         address from,
616         address to,
617         uint256 tokenId,
618         bytes calldata data
619     ) external;
620 }
621 
622 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
623 
624 
625 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
626 
627 pragma solidity ^0.8.0;
628 
629 
630 /**
631  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
632  * @dev See https://eips.ethereum.org/EIPS/eip-721
633  */
634 interface IERC721Metadata is IERC721 {
635     /**
636      * @dev Returns the token collection name.
637      */
638     function name() external view returns (string memory);
639 
640     /**
641      * @dev Returns the token collection symbol.
642      */
643     function symbol() external view returns (string memory);
644 
645     /**
646      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
647      */
648     function tokenURI(uint256 tokenId) external view returns (string memory);
649 }
650 
651 // File: @openzeppelin/contracts/interfaces/IERC721.sol
652 
653 
654 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC721.sol)
655 
656 pragma solidity ^0.8.0;
657 
658 
659 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
660 
661 
662 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
663 
664 pragma solidity ^0.8.0;
665 
666 // CAUTION
667 // This version of SafeMath should only be used with Solidity 0.8 or later,
668 // because it relies on the compiler's built in overflow checks.
669 
670 /**
671  * @dev Wrappers over Solidity's arithmetic operations.
672  *
673  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
674  * now has built in overflow checking.
675  */
676 library SafeMath {
677     /**
678      * @dev Returns the addition of two unsigned integers, with an overflow flag.
679      *
680      * _Available since v3.4._
681      */
682     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
683         unchecked {
684             uint256 c = a + b;
685             if (c < a) return (false, 0);
686             return (true, c);
687         }
688     }
689 
690     /**
691      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
692      *
693      * _Available since v3.4._
694      */
695     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
696         unchecked {
697             if (b > a) return (false, 0);
698             return (true, a - b);
699         }
700     }
701 
702     /**
703      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
704      *
705      * _Available since v3.4._
706      */
707     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
708         unchecked {
709             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
710             // benefit is lost if 'b' is also tested.
711             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
712             if (a == 0) return (true, 0);
713             uint256 c = a * b;
714             if (c / a != b) return (false, 0);
715             return (true, c);
716         }
717     }
718 
719     /**
720      * @dev Returns the division of two unsigned integers, with a division by zero flag.
721      *
722      * _Available since v3.4._
723      */
724     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
725         unchecked {
726             if (b == 0) return (false, 0);
727             return (true, a / b);
728         }
729     }
730 
731     /**
732      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
733      *
734      * _Available since v3.4._
735      */
736     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
737         unchecked {
738             if (b == 0) return (false, 0);
739             return (true, a % b);
740         }
741     }
742 
743     /**
744      * @dev Returns the addition of two unsigned integers, reverting on
745      * overflow.
746      *
747      * Counterpart to Solidity's `+` operator.
748      *
749      * Requirements:
750      *
751      * - Addition cannot overflow.
752      */
753     function add(uint256 a, uint256 b) internal pure returns (uint256) {
754         return a + b;
755     }
756 
757     /**
758      * @dev Returns the subtraction of two unsigned integers, reverting on
759      * overflow (when the result is negative).
760      *
761      * Counterpart to Solidity's `-` operator.
762      *
763      * Requirements:
764      *
765      * - Subtraction cannot overflow.
766      */
767     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
768         return a - b;
769     }
770 
771     /**
772      * @dev Returns the multiplication of two unsigned integers, reverting on
773      * overflow.
774      *
775      * Counterpart to Solidity's `*` operator.
776      *
777      * Requirements:
778      *
779      * - Multiplication cannot overflow.
780      */
781     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
782         return a * b;
783     }
784 
785     /**
786      * @dev Returns the integer division of two unsigned integers, reverting on
787      * division by zero. The result is rounded towards zero.
788      *
789      * Counterpart to Solidity's `/` operator.
790      *
791      * Requirements:
792      *
793      * - The divisor cannot be zero.
794      */
795     function div(uint256 a, uint256 b) internal pure returns (uint256) {
796         return a / b;
797     }
798 
799     /**
800      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
801      * reverting when dividing by zero.
802      *
803      * Counterpart to Solidity's `%` operator. This function uses a `revert`
804      * opcode (which leaves remaining gas untouched) while Solidity uses an
805      * invalid opcode to revert (consuming all remaining gas).
806      *
807      * Requirements:
808      *
809      * - The divisor cannot be zero.
810      */
811     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
812         return a % b;
813     }
814 
815     /**
816      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
817      * overflow (when the result is negative).
818      *
819      * CAUTION: This function is deprecated because it requires allocating memory for the error
820      * message unnecessarily. For custom revert reasons use {trySub}.
821      *
822      * Counterpart to Solidity's `-` operator.
823      *
824      * Requirements:
825      *
826      * - Subtraction cannot overflow.
827      */
828     function sub(
829         uint256 a,
830         uint256 b,
831         string memory errorMessage
832     ) internal pure returns (uint256) {
833         unchecked {
834             require(b <= a, errorMessage);
835             return a - b;
836         }
837     }
838 
839     /**
840      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
841      * division by zero. The result is rounded towards zero.
842      *
843      * Counterpart to Solidity's `/` operator. Note: this function uses a
844      * `revert` opcode (which leaves remaining gas untouched) while Solidity
845      * uses an invalid opcode to revert (consuming all remaining gas).
846      *
847      * Requirements:
848      *
849      * - The divisor cannot be zero.
850      */
851     function div(
852         uint256 a,
853         uint256 b,
854         string memory errorMessage
855     ) internal pure returns (uint256) {
856         unchecked {
857             require(b > 0, errorMessage);
858             return a / b;
859         }
860     }
861 
862     /**
863      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
864      * reverting with custom message when dividing by zero.
865      *
866      * CAUTION: This function is deprecated because it requires allocating memory for the error
867      * message unnecessarily. For custom revert reasons use {tryMod}.
868      *
869      * Counterpart to Solidity's `%` operator. This function uses a `revert`
870      * opcode (which leaves remaining gas untouched) while Solidity uses an
871      * invalid opcode to revert (consuming all remaining gas).
872      *
873      * Requirements:
874      *
875      * - The divisor cannot be zero.
876      */
877     function mod(
878         uint256 a,
879         uint256 b,
880         string memory errorMessage
881     ) internal pure returns (uint256) {
882         unchecked {
883             require(b > 0, errorMessage);
884             return a % b;
885         }
886     }
887 }
888 
889 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
890 
891 
892 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
893 
894 pragma solidity ^0.8.0;
895 
896 /**
897  * @dev These functions deal with verification of Merkle Trees proofs.
898  *
899  * The proofs can be generated using the JavaScript library
900  * https://github.com/miguelmota/merkletreejs[merkletreejs].
901  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
902  *
903  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
904  */
905 library MerkleProof {
906     /**
907      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
908      * defined by `root`. For this, a `proof` must be provided, containing
909      * sibling hashes on the branch from the leaf to the root of the tree. Each
910      * pair of leaves and each pair of pre-images are assumed to be sorted.
911      */
912     function verify(
913         bytes32[] memory proof,
914         bytes32 root,
915         bytes32 leaf
916     ) internal pure returns (bool) {
917         return processProof(proof, leaf) == root;
918     }
919 
920     /**
921      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
922      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
923      * hash matches the root of the tree. When processing the proof, the pairs
924      * of leafs & pre-images are assumed to be sorted.
925      *
926      * _Available since v4.4._
927      */
928     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
929         bytes32 computedHash = leaf;
930         for (uint256 i = 0; i < proof.length; i++) {
931             bytes32 proofElement = proof[i];
932             if (computedHash <= proofElement) {
933                 // Hash(current computed hash + current element of the proof)
934                 computedHash = _efficientHash(computedHash, proofElement);
935             } else {
936                 // Hash(current element of the proof + current computed hash)
937                 computedHash = _efficientHash(proofElement, computedHash);
938             }
939         }
940         return computedHash;
941     }
942 
943     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
944         assembly {
945             mstore(0x00, a)
946             mstore(0x20, b)
947             value := keccak256(0x00, 0x40)
948         }
949     }
950 }
951 
952 // File: @openzeppelin/contracts/utils/Context.sol
953 
954 
955 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
956 
957 pragma solidity ^0.8.0;
958 
959 /**
960  * @dev Provides information about the current execution context, including the
961  * sender of the transaction and its data. While these are generally available
962  * via msg.sender and msg.data, they should not be accessed in such a direct
963  * manner, since when dealing with meta-transactions the account sending and
964  * paying for execution may not be the actual sender (as far as an application
965  * is concerned).
966  *
967  * This contract is only required for intermediate, library-like contracts.
968  */
969 abstract contract Context {
970     function _msgSender() internal view virtual returns (address) {
971         return msg.sender;
972     }
973 
974     function _msgData() internal view virtual returns (bytes calldata) {
975         return msg.data;
976     }
977 }
978 
979 // File: @openzeppelin/contracts/access/AccessControl.sol
980 
981 
982 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControl.sol)
983 
984 pragma solidity ^0.8.0;
985 
986 
987 
988 
989 
990 /**
991  * @dev Contract module that allows children to implement role-based access
992  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
993  * members except through off-chain means by accessing the contract event logs. Some
994  * applications may benefit from on-chain enumerability, for those cases see
995  * {AccessControlEnumerable}.
996  *
997  * Roles are referred to by their `bytes32` identifier. These should be exposed
998  * in the external API and be unique. The best way to achieve this is by
999  * using `public constant` hash digests:
1000  *
1001  * ```
1002  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1003  * ```
1004  *
1005  * Roles can be used to represent a set of permissions. To restrict access to a
1006  * function call, use {hasRole}:
1007  *
1008  * ```
1009  * function foo() public {
1010  *     require(hasRole(MY_ROLE, msg.sender));
1011  *     ...
1012  * }
1013  * ```
1014  *
1015  * Roles can be granted and revoked dynamically via the {grantRole} and
1016  * {revokeRole} functions. Each role has an associated admin role, and only
1017  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1018  *
1019  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1020  * that only accounts with this role will be able to grant or revoke other
1021  * roles. More complex role relationships can be created by using
1022  * {_setRoleAdmin}.
1023  *
1024  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1025  * grant and revoke this role. Extra precautions should be taken to secure
1026  * accounts that have been granted it.
1027  */
1028 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1029     struct RoleData {
1030         mapping(address => bool) members;
1031         bytes32 adminRole;
1032     }
1033 
1034     mapping(bytes32 => RoleData) private _roles;
1035 
1036     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1037 
1038     /**
1039      * @dev Modifier that checks that an account has a specific role. Reverts
1040      * with a standardized message including the required role.
1041      *
1042      * The format of the revert reason is given by the following regular expression:
1043      *
1044      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1045      *
1046      * _Available since v4.1._
1047      */
1048     modifier onlyRole(bytes32 role) {
1049         _checkRole(role, _msgSender());
1050         _;
1051     }
1052 
1053     /**
1054      * @dev See {IERC165-supportsInterface}.
1055      */
1056     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1057         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1058     }
1059 
1060     /**
1061      * @dev Returns `true` if `account` has been granted `role`.
1062      */
1063     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1064         return _roles[role].members[account];
1065     }
1066 
1067     /**
1068      * @dev Revert with a standard message if `account` is missing `role`.
1069      *
1070      * The format of the revert reason is given by the following regular expression:
1071      *
1072      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1073      */
1074     function _checkRole(bytes32 role, address account) internal view virtual {
1075         if (!hasRole(role, account)) {
1076             revert(
1077                 string(
1078                     abi.encodePacked(
1079                         "AccessControl: account ",
1080                         Strings.toHexString(uint160(account), 20),
1081                         " is missing role ",
1082                         Strings.toHexString(uint256(role), 32)
1083                     )
1084                 )
1085             );
1086         }
1087     }
1088 
1089     /**
1090      * @dev Returns the admin role that controls `role`. See {grantRole} and
1091      * {revokeRole}.
1092      *
1093      * To change a role's admin, use {_setRoleAdmin}.
1094      */
1095     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1096         return _roles[role].adminRole;
1097     }
1098 
1099     /**
1100      * @dev Grants `role` to `account`.
1101      *
1102      * If `account` had not been already granted `role`, emits a {RoleGranted}
1103      * event.
1104      *
1105      * Requirements:
1106      *
1107      * - the caller must have ``role``'s admin role.
1108      */
1109     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1110         _grantRole(role, account);
1111     }
1112 
1113     /**
1114      * @dev Revokes `role` from `account`.
1115      *
1116      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1117      *
1118      * Requirements:
1119      *
1120      * - the caller must have ``role``'s admin role.
1121      */
1122     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1123         _revokeRole(role, account);
1124     }
1125 
1126     /**
1127      * @dev Revokes `role` from the calling account.
1128      *
1129      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1130      * purpose is to provide a mechanism for accounts to lose their privileges
1131      * if they are compromised (such as when a trusted device is misplaced).
1132      *
1133      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1134      * event.
1135      *
1136      * Requirements:
1137      *
1138      * - the caller must be `account`.
1139      */
1140     function renounceRole(bytes32 role, address account) public virtual override {
1141         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1142 
1143         _revokeRole(role, account);
1144     }
1145 
1146     /**
1147      * @dev Grants `role` to `account`.
1148      *
1149      * If `account` had not been already granted `role`, emits a {RoleGranted}
1150      * event. Note that unlike {grantRole}, this function doesn't perform any
1151      * checks on the calling account.
1152      *
1153      * [WARNING]
1154      * ====
1155      * This function should only be called from the constructor when setting
1156      * up the initial roles for the system.
1157      *
1158      * Using this function in any other way is effectively circumventing the admin
1159      * system imposed by {AccessControl}.
1160      * ====
1161      *
1162      * NOTE: This function is deprecated in favor of {_grantRole}.
1163      */
1164     function _setupRole(bytes32 role, address account) internal virtual {
1165         _grantRole(role, account);
1166     }
1167 
1168     /**
1169      * @dev Sets `adminRole` as ``role``'s admin role.
1170      *
1171      * Emits a {RoleAdminChanged} event.
1172      */
1173     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1174         bytes32 previousAdminRole = getRoleAdmin(role);
1175         _roles[role].adminRole = adminRole;
1176         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1177     }
1178 
1179     /**
1180      * @dev Grants `role` to `account`.
1181      *
1182      * Internal function without access restriction.
1183      */
1184     function _grantRole(bytes32 role, address account) internal virtual {
1185         if (!hasRole(role, account)) {
1186             _roles[role].members[account] = true;
1187             emit RoleGranted(role, account, _msgSender());
1188         }
1189     }
1190 
1191     /**
1192      * @dev Revokes `role` from `account`.
1193      *
1194      * Internal function without access restriction.
1195      */
1196     function _revokeRole(bytes32 role, address account) internal virtual {
1197         if (hasRole(role, account)) {
1198             _roles[role].members[account] = false;
1199             emit RoleRevoked(role, account, _msgSender());
1200         }
1201     }
1202 }
1203 
1204 // File: contracts/lib/PaymentSplitterConnector.sol
1205 
1206 
1207 pragma solidity ^0.8.4;
1208 
1209 
1210 
1211 contract PaymentSplitterConnector is AccessControl {
1212 
1213     address public PAYMENT_SPLITTER_ADDRESS;
1214     address public PAYMENT_DEFAULT_ADMIN;
1215     address public SPLITTER_ADMIN;
1216     bytes32 private constant SPLITTER_ADMIN_ROLE = keccak256("SPLITTER_ADMIN");
1217 
1218     constructor(address admin, address splitterAddress) {
1219         _setupRole(DEFAULT_ADMIN_ROLE, admin);
1220         _setupRole(SPLITTER_ADMIN_ROLE, admin);
1221         
1222         SPLITTER_ADMIN = admin;
1223         PAYMENT_DEFAULT_ADMIN = admin;
1224         PAYMENT_SPLITTER_ADDRESS = splitterAddress;
1225     }
1226 
1227     modifier onlySplitterAdmin {
1228         require(hasRole(SPLITTER_ADMIN_ROLE, msg.sender), "Splitter: No Splitter Role");
1229         _;
1230     }
1231 
1232     modifier onlyDefaultAdmin {
1233         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Splitter: No Admin Permission");
1234         _;
1235     }
1236 
1237     function setSplitterAddress(address _splitterAddress) public onlySplitterAdmin {
1238         PAYMENT_SPLITTER_ADDRESS = _splitterAddress;
1239     }
1240 
1241     function withdraw() public {
1242         address payable recipient = payable(PAYMENT_SPLITTER_ADDRESS);
1243         uint256 balance = address(this).balance;
1244         
1245         Address.sendValue(recipient, balance);
1246     }
1247 
1248     function transferSplitterAdminRole(address admin) public onlyDefaultAdmin{
1249         require(SPLITTER_ADMIN != admin, "Splitter: Should be different");
1250 
1251         grantRole(SPLITTER_ADMIN_ROLE, admin);
1252         revokeRole(SPLITTER_ADMIN_ROLE, SPLITTER_ADMIN);
1253         SPLITTER_ADMIN = admin;
1254     }
1255 
1256     function transferDefaultAdminRole(address admin) public onlyDefaultAdmin{
1257         require(PAYMENT_DEFAULT_ADMIN != admin, "Splitter: Should be different");
1258 
1259         grantRole(DEFAULT_ADMIN_ROLE, admin);
1260         revokeRole(DEFAULT_ADMIN_ROLE, PAYMENT_DEFAULT_ADMIN);
1261         PAYMENT_DEFAULT_ADMIN = admin;
1262     }
1263 }
1264 // File: contracts/lib/ERC721A.sol
1265 
1266 
1267 // Creator: Chiru Labs
1268 
1269 pragma solidity ^0.8.4;
1270 
1271 
1272 
1273 
1274 
1275 
1276 
1277 
1278 error ApprovalCallerNotOwnerNorApproved();
1279 error ApprovalQueryForNonexistentToken();
1280 error ApproveToCaller();
1281 error ApprovalToCurrentOwner();
1282 error BalanceQueryForZeroAddress();
1283 error MintToZeroAddress();
1284 error MintZeroQuantity();
1285 error OwnerQueryForNonexistentToken();
1286 error TransferCallerNotOwnerNorApproved();
1287 error TransferFromIncorrectOwner();
1288 error TransferToNonERC721ReceiverImplementer();
1289 error TransferToZeroAddress();
1290 error URIQueryForNonexistentToken();
1291 
1292 /**
1293  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1294  * the Metadata extension. Built to optimize for lower gas during batch mints.
1295  *
1296  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1297  *
1298  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1299  *
1300  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1301  */
1302 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1303     using Address for address;
1304     using Strings for uint256;
1305 
1306     // Compiler will pack this into a single 256bit word.
1307     struct TokenOwnership {
1308         // The address of the owner.
1309         address addr;
1310         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1311         uint64 startTimestamp;
1312         // Whether the token has been burned.
1313         bool burned;
1314     }
1315 
1316     // Compiler will pack this into a single 256bit word.
1317     struct AddressData {
1318         // Realistically, 2**64-1 is more than enough.
1319         uint64 balance;
1320         // Keeps track of mint count with minimal overhead for tokenomics.
1321         uint64 numberMinted;
1322         // Keeps track of burn count with minimal overhead for tokenomics.
1323         uint64 numberBurned;
1324         // For miscellaneous variable(s) pertaining to the address
1325         // (e.g. number of whitelist mint slots used).
1326         // If there are multiple variables, please pack them into a uint64.
1327         uint64 aux;
1328     }
1329 
1330     // The tokenId of the next token to be minted.
1331     uint256 internal _currentIndex;
1332 
1333     // The number of tokens burned.
1334     uint256 internal _burnCounter;
1335 
1336     // Token name
1337     string private _name;
1338 
1339     // Token symbol
1340     string private _symbol;
1341 
1342     // Mapping from token ID to ownership details
1343     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1344     mapping(uint256 => TokenOwnership) internal _ownerships;
1345 
1346     // Mapping owner address to address data
1347     mapping(address => AddressData) private _addressData;
1348 
1349     // Mapping from token ID to approved address
1350     mapping(uint256 => address) private _tokenApprovals;
1351 
1352     // Mapping from owner to operator approvals
1353     mapping(address => mapping(address => bool)) private _operatorApprovals;
1354 
1355     constructor(string memory name_, string memory symbol_) {
1356         _name = name_;
1357         _symbol = symbol_;
1358         _currentIndex = _startTokenId();
1359     }
1360 
1361     /**
1362      * To change the starting tokenId, please override this function.
1363      */
1364     function _startTokenId() internal view virtual returns (uint256) {
1365         return 0;
1366     }
1367 
1368     /**
1369      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1370      */
1371     function totalSupply() public view returns (uint256) {
1372         // Counter underflow is impossible as _burnCounter cannot be incremented
1373         // more than _currentIndex - _startTokenId() times
1374         unchecked {
1375             return _currentIndex - _burnCounter - _startTokenId();
1376         }
1377     }
1378 
1379     /**
1380      * Returns the total amount of tokens minted in the contract.
1381      */
1382     function _totalMinted() internal view returns (uint256) {
1383         // Counter underflow is impossible as _currentIndex does not decrement,
1384         // and it is initialized to _startTokenId()
1385         unchecked {
1386             return _currentIndex - _startTokenId();
1387         }
1388     }
1389 
1390     /**
1391      * @dev See {IERC165-supportsInterface}.
1392      */
1393     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1394         return
1395             interfaceId == type(IERC721).interfaceId ||
1396             interfaceId == type(IERC721Metadata).interfaceId ||
1397             super.supportsInterface(interfaceId);
1398     }
1399 
1400     /**
1401      * @dev See {IERC721-balanceOf}.
1402      */
1403     function balanceOf(address owner) public view override returns (uint256) {
1404         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1405         return uint256(_addressData[owner].balance);
1406     }
1407 
1408     /**
1409      * Returns the number of tokens minted by `owner`.
1410      */
1411     function _numberMinted(address owner) internal view returns (uint256) {
1412         return uint256(_addressData[owner].numberMinted);
1413     }
1414 
1415     /**
1416      * Returns the number of tokens burned by or on behalf of `owner`.
1417      */
1418     function _numberBurned(address owner) internal view returns (uint256) {
1419         return uint256(_addressData[owner].numberBurned);
1420     }
1421 
1422     /**
1423      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1424      */
1425     function _getAux(address owner) internal view returns (uint64) {
1426         return _addressData[owner].aux;
1427     }
1428 
1429     /**
1430      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1431      * If there are multiple variables, please pack them into a uint64.
1432      */
1433     function _setAux(address owner, uint64 aux) internal {
1434         _addressData[owner].aux = aux;
1435     }
1436 
1437     /**
1438      * Gas spent here starts off proportional to the maximum mint batch size.
1439      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1440      */
1441     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1442         uint256 curr = tokenId;
1443 
1444         unchecked {
1445             if (_startTokenId() <= curr && curr < _currentIndex) {
1446                 TokenOwnership memory ownership = _ownerships[curr];
1447                 if (!ownership.burned) {
1448                     if (ownership.addr != address(0)) {
1449                         return ownership;
1450                     }
1451                     // Invariant:
1452                     // There will always be an ownership that has an address and is not burned
1453                     // before an ownership that does not have an address and is not burned.
1454                     // Hence, curr will not underflow.
1455                     while (true) {
1456                         curr--;
1457                         ownership = _ownerships[curr];
1458                         if (ownership.addr != address(0)) {
1459                             return ownership;
1460                         }
1461                     }
1462                 }
1463             }
1464         }
1465         revert OwnerQueryForNonexistentToken();
1466     }
1467 
1468     /**
1469      * @dev See {IERC721-ownerOf}.
1470      */
1471     function ownerOf(uint256 tokenId) public view override returns (address) {
1472         return _ownershipOf(tokenId).addr;
1473     }
1474 
1475     /**
1476      * @dev See {IERC721Metadata-name}.
1477      */
1478     function name() public view virtual override returns (string memory) {
1479         return _name;
1480     }
1481 
1482     /**
1483      * @dev See {IERC721Metadata-symbol}.
1484      */
1485     function symbol() public view virtual override returns (string memory) {
1486         return _symbol;
1487     }
1488 
1489     /**
1490      * @dev See {IERC721Metadata-tokenURI}.
1491      */
1492     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1493         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1494 
1495         string memory baseURI = _baseURI();
1496         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1497     }
1498 
1499     /**
1500      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1501      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1502      * by default, can be overriden in child contracts.
1503      */
1504     function _baseURI() internal view virtual returns (string memory) {
1505         return '';
1506     }
1507 
1508     /**
1509      * @dev See {IERC721-approve}.
1510      */
1511     function approve(address to, uint256 tokenId) public override {
1512         address owner = ERC721A.ownerOf(tokenId);
1513         if (to == owner) revert ApprovalToCurrentOwner();
1514 
1515         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1516             revert ApprovalCallerNotOwnerNorApproved();
1517         }
1518 
1519         _approve(to, tokenId, owner);
1520     }
1521 
1522     /**
1523      * @dev See {IERC721-getApproved}.
1524      */
1525     function getApproved(uint256 tokenId) public view override returns (address) {
1526         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1527 
1528         return _tokenApprovals[tokenId];
1529     }
1530 
1531     /**
1532      * @dev See {IERC721-setApprovalForAll}.
1533      */
1534     function setApprovalForAll(address operator, bool approved) public virtual override {
1535         if (operator == _msgSender()) revert ApproveToCaller();
1536 
1537         _operatorApprovals[_msgSender()][operator] = approved;
1538         emit ApprovalForAll(_msgSender(), operator, approved);
1539     }
1540 
1541     /**
1542      * @dev See {IERC721-isApprovedForAll}.
1543      */
1544     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1545         return _operatorApprovals[owner][operator];
1546     }
1547 
1548     /**
1549      * @dev See {IERC721-transferFrom}.
1550      */
1551     function transferFrom(
1552         address from,
1553         address to,
1554         uint256 tokenId
1555     ) public virtual override {
1556         _transfer(from, to, tokenId);
1557     }
1558 
1559     /**
1560      * @dev See {IERC721-safeTransferFrom}.
1561      */
1562     function safeTransferFrom(
1563         address from,
1564         address to,
1565         uint256 tokenId
1566     ) public virtual override {
1567         safeTransferFrom(from, to, tokenId, '');
1568     }
1569 
1570     /**
1571      * @dev See {IERC721-safeTransferFrom}.
1572      */
1573     function safeTransferFrom(
1574         address from,
1575         address to,
1576         uint256 tokenId,
1577         bytes memory _data
1578     ) public virtual override {
1579         _transfer(from, to, tokenId);
1580         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1581             revert TransferToNonERC721ReceiverImplementer();
1582         }
1583     }
1584 
1585     /**
1586      * @dev Returns whether `tokenId` exists.
1587      *
1588      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1589      *
1590      * Tokens start existing when they are minted (`_mint`),
1591      */
1592     function _exists(uint256 tokenId) internal view returns (bool) {
1593         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1594             !_ownerships[tokenId].burned;
1595     }
1596 
1597     function _safeMint(address to, uint256 quantity) internal {
1598         _safeMint(to, quantity, '');
1599     }
1600 
1601     /**
1602      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1603      *
1604      * Requirements:
1605      *
1606      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1607      * - `quantity` must be greater than 0.
1608      *
1609      * Emits a {Transfer} event.
1610      */
1611     function _safeMint(
1612         address to,
1613         uint256 quantity,
1614         bytes memory _data
1615     ) internal {
1616         _mint(to, quantity, _data, true);
1617     }
1618 
1619     /**
1620      * @dev Mints `quantity` tokens and transfers them to `to`.
1621      *
1622      * Requirements:
1623      *
1624      * - `to` cannot be the zero address.
1625      * - `quantity` must be greater than 0.
1626      *
1627      * Emits a {Transfer} event.
1628      */
1629     function _mint(
1630         address to,
1631         uint256 quantity,
1632         bytes memory _data,
1633         bool safe
1634     ) internal {
1635         uint256 startTokenId = _currentIndex;
1636         if (to == address(0)) revert MintToZeroAddress();
1637         if (quantity == 0) revert MintZeroQuantity();
1638 
1639         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1640 
1641         // Overflows are incredibly unrealistic.
1642         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1643         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1644         unchecked {
1645             _addressData[to].balance += uint64(quantity);
1646             _addressData[to].numberMinted += uint64(quantity);
1647 
1648             _ownerships[startTokenId].addr = to;
1649             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1650 
1651             uint256 updatedIndex = startTokenId;
1652             uint256 end = updatedIndex + quantity;
1653 
1654             if (safe && to.isContract()) {
1655                 do {
1656                     emit Transfer(address(0), to, updatedIndex);
1657                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1658                         revert TransferToNonERC721ReceiverImplementer();
1659                     }
1660                 } while (updatedIndex != end);
1661                 // Reentrancy protection
1662                 if (_currentIndex != startTokenId) revert();
1663             } else {
1664                 do {
1665                     emit Transfer(address(0), to, updatedIndex++);
1666                 } while (updatedIndex != end);
1667             }
1668             _currentIndex = updatedIndex;
1669         }
1670         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1671     }
1672 
1673     /**
1674      * @dev Transfers `tokenId` from `from` to `to`.
1675      *
1676      * Requirements:
1677      *
1678      * - `to` cannot be the zero address.
1679      * - `tokenId` token must be owned by `from`.
1680      *
1681      * Emits a {Transfer} event.
1682      */
1683     function _transfer(
1684         address from,
1685         address to,
1686         uint256 tokenId
1687     ) private {
1688         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1689 
1690         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1691 
1692         bool isApprovedOrOwner = (_msgSender() == from ||
1693             isApprovedForAll(from, _msgSender()) ||
1694             getApproved(tokenId) == _msgSender());
1695 
1696         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1697         if (to == address(0)) revert TransferToZeroAddress();
1698 
1699         _beforeTokenTransfers(from, to, tokenId, 1);
1700 
1701         // Clear approvals from the previous owner
1702         _approve(address(0), tokenId, from);
1703 
1704         // Underflow of the sender's balance is impossible because we check for
1705         // ownership above and the recipient's balance can't realistically overflow.
1706         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1707         unchecked {
1708             _addressData[from].balance -= 1;
1709             _addressData[to].balance += 1;
1710 
1711             TokenOwnership storage currSlot = _ownerships[tokenId];
1712             currSlot.addr = to;
1713             currSlot.startTimestamp = uint64(block.timestamp);
1714 
1715             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1716             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1717             uint256 nextTokenId = tokenId + 1;
1718             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1719             if (nextSlot.addr == address(0)) {
1720                 // This will suffice for checking _exists(nextTokenId),
1721                 // as a burned slot cannot contain the zero address.
1722                 if (nextTokenId != _currentIndex) {
1723                     nextSlot.addr = from;
1724                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1725                 }
1726             }
1727         }
1728 
1729         emit Transfer(from, to, tokenId);
1730         _afterTokenTransfers(from, to, tokenId, 1);
1731     }
1732 
1733     /**
1734      * @dev This is equivalent to _burn(tokenId, false)
1735      */
1736     function _burn(uint256 tokenId) internal virtual {
1737         _burn(tokenId, false);
1738     }
1739 
1740     /**
1741      * @dev Destroys `tokenId`.
1742      * The approval is cleared when the token is burned.
1743      *
1744      * Requirements:
1745      *
1746      * - `tokenId` must exist.
1747      *
1748      * Emits a {Transfer} event.
1749      */
1750     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1751         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1752 
1753         address from = prevOwnership.addr;
1754 
1755         if (approvalCheck) {
1756             bool isApprovedOrOwner = (_msgSender() == from ||
1757                 isApprovedForAll(from, _msgSender()) ||
1758                 getApproved(tokenId) == _msgSender());
1759 
1760             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1761         }
1762 
1763         _beforeTokenTransfers(from, address(0), tokenId, 1);
1764 
1765         // Clear approvals from the previous owner
1766         _approve(address(0), tokenId, from);
1767 
1768         // Underflow of the sender's balance is impossible because we check for
1769         // ownership above and the recipient's balance can't realistically overflow.
1770         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1771         unchecked {
1772             AddressData storage addressData = _addressData[from];
1773             addressData.balance -= 1;
1774             addressData.numberBurned += 1;
1775 
1776             // Keep track of who burned the token, and the timestamp of burning.
1777             TokenOwnership storage currSlot = _ownerships[tokenId];
1778             currSlot.addr = from;
1779             currSlot.startTimestamp = uint64(block.timestamp);
1780             currSlot.burned = true;
1781 
1782             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1783             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1784             uint256 nextTokenId = tokenId + 1;
1785             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1786             if (nextSlot.addr == address(0)) {
1787                 // This will suffice for checking _exists(nextTokenId),
1788                 // as a burned slot cannot contain the zero address.
1789                 if (nextTokenId != _currentIndex) {
1790                     nextSlot.addr = from;
1791                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1792                 }
1793             }
1794         }
1795 
1796         emit Transfer(from, address(0), tokenId);
1797         _afterTokenTransfers(from, address(0), tokenId, 1);
1798 
1799         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1800         unchecked {
1801             _burnCounter++;
1802         }
1803     }
1804 
1805     /**
1806      * @dev Approve `to` to operate on `tokenId`
1807      *
1808      * Emits a {Approval} event.
1809      */
1810     function _approve(
1811         address to,
1812         uint256 tokenId,
1813         address owner
1814     ) private {
1815         _tokenApprovals[tokenId] = to;
1816         emit Approval(owner, to, tokenId);
1817     }
1818 
1819     /**
1820      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1821      *
1822      * @param from address representing the previous owner of the given token ID
1823      * @param to target address that will receive the tokens
1824      * @param tokenId uint256 ID of the token to be transferred
1825      * @param _data bytes optional data to send along with the call
1826      * @return bool whether the call correctly returned the expected magic value
1827      */
1828     function _checkContractOnERC721Received(
1829         address from,
1830         address to,
1831         uint256 tokenId,
1832         bytes memory _data
1833     ) private returns (bool) {
1834         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1835             return retval == IERC721Receiver(to).onERC721Received.selector;
1836         } catch (bytes memory reason) {
1837             if (reason.length == 0) {
1838                 revert TransferToNonERC721ReceiverImplementer();
1839             } else {
1840                 assembly {
1841                     revert(add(32, reason), mload(reason))
1842                 }
1843             }
1844         }
1845     }
1846 
1847     /**
1848      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1849      * And also called before burning one token.
1850      *
1851      * startTokenId - the first token id to be transferred
1852      * quantity - the amount to be transferred
1853      *
1854      * Calling conditions:
1855      *
1856      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1857      * transferred to `to`.
1858      * - When `from` is zero, `tokenId` will be minted for `to`.
1859      * - When `to` is zero, `tokenId` will be burned by `from`.
1860      * - `from` and `to` are never both zero.
1861      */
1862     function _beforeTokenTransfers(
1863         address from,
1864         address to,
1865         uint256 startTokenId,
1866         uint256 quantity
1867     ) internal virtual {}
1868 
1869     /**
1870      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1871      * minting.
1872      * And also called after one token has been burned.
1873      *
1874      * startTokenId - the first token id to be transferred
1875      * quantity - the amount to be transferred
1876      *
1877      * Calling conditions:
1878      *
1879      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1880      * transferred to `to`.
1881      * - When `from` is zero, `tokenId` has been minted for `to`.
1882      * - When `to` is zero, `tokenId` has been burned by `from`.
1883      * - `from` and `to` are never both zero.
1884      */
1885     function _afterTokenTransfers(
1886         address from,
1887         address to,
1888         uint256 startTokenId,
1889         uint256 quantity
1890     ) internal virtual {}
1891 }
1892 
1893 // File: contracts/lib/ERC721ABurnable.sol
1894 
1895 
1896 // Creator: Chiru Labs
1897 
1898 pragma solidity ^0.8.4;
1899 
1900 
1901 /**
1902  * @title ERC721A Burnable Token
1903  * @dev ERC721A Token that can be irreversibly burned (destroyed).
1904  */
1905 abstract contract ERC721ABurnable is ERC721A {
1906 
1907     /**
1908      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1909      *
1910      * Requirements:
1911      *
1912      * - The caller must own `tokenId` or be an approved operator.
1913      */
1914     function burn(uint256 tokenId) public virtual {
1915         _burn(tokenId, true);
1916     }
1917 }
1918 
1919 // File: @openzeppelin/contracts/access/Ownable.sol
1920 
1921 
1922 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1923 
1924 pragma solidity ^0.8.0;
1925 
1926 
1927 /**
1928  * @dev Contract module which provides a basic access control mechanism, where
1929  * there is an account (an owner) that can be granted exclusive access to
1930  * specific functions.
1931  *
1932  * By default, the owner account will be the one that deploys the contract. This
1933  * can later be changed with {transferOwnership}.
1934  *
1935  * This module is used through inheritance. It will make available the modifier
1936  * `onlyOwner`, which can be applied to your functions to restrict their use to
1937  * the owner.
1938  */
1939 abstract contract Ownable is Context {
1940     address private _owner;
1941 
1942     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1943 
1944     /**
1945      * @dev Initializes the contract setting the deployer as the initial owner.
1946      */
1947     constructor() {
1948         _transferOwnership(_msgSender());
1949     }
1950 
1951     /**
1952      * @dev Returns the address of the current owner.
1953      */
1954     function owner() public view virtual returns (address) {
1955         return _owner;
1956     }
1957 
1958     /**
1959      * @dev Throws if called by any account other than the owner.
1960      */
1961     modifier onlyOwner() {
1962         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1963         _;
1964     }
1965 
1966     /**
1967      * @dev Leaves the contract without owner. It will not be possible to call
1968      * `onlyOwner` functions anymore. Can only be called by the current owner.
1969      *
1970      * NOTE: Renouncing ownership will leave the contract without an owner,
1971      * thereby removing any functionality that is only available to the owner.
1972      */
1973     function renounceOwnership() public virtual onlyOwner {
1974         _transferOwnership(address(0));
1975     }
1976 
1977     /**
1978      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1979      * Can only be called by the current owner.
1980      */
1981     function transferOwnership(address newOwner) public virtual onlyOwner {
1982         require(newOwner != address(0), "Ownable: new owner is the zero address");
1983         _transferOwnership(newOwner);
1984     }
1985 
1986     /**
1987      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1988      * Internal function without access restriction.
1989      */
1990     function _transferOwnership(address newOwner) internal virtual {
1991         address oldOwner = _owner;
1992         _owner = newOwner;
1993         emit OwnershipTransferred(oldOwner, newOwner);
1994     }
1995 }
1996 
1997 // File: contracts/lib/MintStage.sol
1998 
1999 
2000 pragma solidity ^0.8.4;
2001 
2002 
2003 
2004 
2005 contract MintStage is Ownable {
2006 
2007     using SafeMath for uint256;
2008 
2009     struct Stage {
2010         uint id;
2011         uint totalLimit;
2012         uint walletLimit;
2013         uint256 rate;
2014         bool isPublic;
2015         bytes32 whitelistRoot;
2016         uint256 walletLimitCounter;
2017         uint256 openingTime;
2018         uint256 closingTime;
2019     }
2020 
2021     Stage public currentStage;
2022 
2023     mapping(uint => mapping(address => uint)) public walletMintCount;
2024 
2025     uint private constant BATCH_LIMIT = 20;
2026 
2027     event MintStageUpdated(
2028         uint indexed _stage,
2029         uint _stageLimit,
2030         uint _stageLimitPerWallet,
2031         uint256 _rate,
2032         uint256 _openingTime,
2033         uint256 _closingTIme
2034     );
2035 
2036     function setMintStage (
2037         uint _stage,
2038         uint _stageLimit,
2039         uint _stageLimitPerWallet,
2040         uint256 _rate,
2041         uint256 _openingTime,
2042         uint256 _closingTime,
2043         bytes32 _whitelistMerkleRoot,
2044         bool _isPublic,
2045         bool _resetClaimCounter
2046     )
2047         public onlyOwner
2048     {
2049         require(_openingTime < _closingTime, "Stage: Invalid duration");
2050         
2051         uint currentLimitWalletPerCounter = currentStage.walletLimitCounter;
2052 
2053         if (_resetClaimCounter) {
2054             currentLimitWalletPerCounter = currentLimitWalletPerCounter + 1;
2055         }
2056 
2057         currentStage = Stage(
2058             _stage,
2059             _stageLimit,
2060             _stageLimitPerWallet,
2061             _rate,
2062             _isPublic,
2063             _whitelistMerkleRoot,
2064             currentLimitWalletPerCounter,
2065             _openingTime,
2066             _closingTime
2067         );
2068 
2069         emit MintStageUpdated(_stage, _stageLimit, _stageLimitPerWallet, _rate, _openingTime, _closingTime);
2070     }
2071 
2072     function _verifyMint(bytes32[] calldata _merkleProof, uint _mintAmount, uint256 currentMintedCount, uint256 discount) internal {
2073         address sender = msg.sender;
2074         uint256 sentAmount = msg.value;
2075         uint256 requiredPayment = _mintAmount.mul(currentStage.rate.sub(discount));
2076         uint mintCount = walletMintCount[currentStage.walletLimitCounter][sender];
2077         
2078         require(_mintAmount > 0 && _mintAmount <= BATCH_LIMIT, "Stage: Mint Amount invalid");
2079         require(isStageOpen(), "Stage: Mint Not Open");
2080 
2081         require(currentMintedCount.add(_mintAmount) <= currentStage.totalLimit, "Stage: Reached Mint Stage Limit");
2082         require(currentStage.walletLimit == 0 || mintCount.add(_mintAmount) <= currentStage.walletLimit, "Stage: Reached Mint Wallet Limit");
2083 
2084         if (!currentStage.isPublic) {
2085             bytes32 leaf = keccak256(abi.encodePacked(sender));
2086             require(MerkleProof.verify(_merkleProof, currentStage.whitelistRoot, leaf), "Stage: Not in whitelist");
2087         }
2088         
2089         require(sentAmount >= requiredPayment, "Stage: Payment amount not enough");
2090     }
2091 
2092     function isStageOpen() public view returns (bool){
2093         return block.timestamp >= currentStage.openingTime && block.timestamp <= currentStage.closingTime;
2094     }
2095 
2096     function _updateWalletMintCount(address sender, uint _mintAmount) internal {
2097         uint mintCount = walletMintCount[currentStage.walletLimitCounter][sender];
2098         walletMintCount[currentStage.walletLimitCounter][sender] = mintCount.add(_mintAmount);
2099     }
2100 }
2101 // File: @openzeppelin/contracts/security/Pausable.sol
2102 
2103 
2104 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
2105 
2106 pragma solidity ^0.8.0;
2107 
2108 
2109 /**
2110  * @dev Contract module which allows children to implement an emergency stop
2111  * mechanism that can be triggered by an authorized account.
2112  *
2113  * This module is used through inheritance. It will make available the
2114  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
2115  * the functions of your contract. Note that they will not be pausable by
2116  * simply including this module, only once the modifiers are put in place.
2117  */
2118 abstract contract Pausable is Context {
2119     /**
2120      * @dev Emitted when the pause is triggered by `account`.
2121      */
2122     event Paused(address account);
2123 
2124     /**
2125      * @dev Emitted when the pause is lifted by `account`.
2126      */
2127     event Unpaused(address account);
2128 
2129     bool private _paused;
2130 
2131     /**
2132      * @dev Initializes the contract in unpaused state.
2133      */
2134     constructor() {
2135         _paused = false;
2136     }
2137 
2138     /**
2139      * @dev Returns true if the contract is paused, and false otherwise.
2140      */
2141     function paused() public view virtual returns (bool) {
2142         return _paused;
2143     }
2144 
2145     /**
2146      * @dev Modifier to make a function callable only when the contract is not paused.
2147      *
2148      * Requirements:
2149      *
2150      * - The contract must not be paused.
2151      */
2152     modifier whenNotPaused() {
2153         require(!paused(), "Pausable: paused");
2154         _;
2155     }
2156 
2157     /**
2158      * @dev Modifier to make a function callable only when the contract is paused.
2159      *
2160      * Requirements:
2161      *
2162      * - The contract must be paused.
2163      */
2164     modifier whenPaused() {
2165         require(paused(), "Pausable: not paused");
2166         _;
2167     }
2168 
2169     /**
2170      * @dev Triggers stopped state.
2171      *
2172      * Requirements:
2173      *
2174      * - The contract must not be paused.
2175      */
2176     function _pause() internal virtual whenNotPaused {
2177         _paused = true;
2178         emit Paused(_msgSender());
2179     }
2180 
2181     /**
2182      * @dev Returns to normal state.
2183      *
2184      * Requirements:
2185      *
2186      * - The contract must be paused.
2187      */
2188     function _unpause() internal virtual whenPaused {
2189         _paused = false;
2190         emit Unpaused(_msgSender());
2191     }
2192 }
2193 
2194 // File: contracts/FloorIsLava.sol
2195 
2196 
2197 pragma solidity ^0.8.4;
2198 
2199 
2200 
2201 
2202 
2203 
2204 
2205 
2206 
2207 
2208 contract FloorIsLava is ERC721A, ERC721ABurnable, Pausable, Ownable, MintStage, PaymentSplitterConnector{
2209 
2210     using SafeMath for uint256;
2211     using Strings for uint256;
2212 
2213     string public baseExtension = ".json";
2214     string public baseURI = "";
2215 
2216     uint public MAX_TOKEN_SUPPLY = 620;
2217     uint public FISHING_INTERVAL = 86400;
2218     uint private constant BATCH_LIMIT = 20;
2219     uint public FISHING_CHANCE = 5;
2220 
2221     bool public isFishingOpen = false;
2222 
2223     mapping(uint256 => uint256) public lastFishedTime;
2224 
2225     event Fished(
2226         address indexed _recipient,
2227         uint256 _tokenId,
2228         uint256 _fishedTimestamp
2229     );
2230 
2231     event AttemptedFishing(
2232         uint256 _tokenId,
2233         uint256 _fishedTimestamp
2234     );
2235 
2236     uint256 private nonce;
2237     
2238     constructor(address splitterAdmin, address splitterAddress) 
2239         ERC721A("FloorIsLava", "FIL")
2240         PaymentSplitterConnector(splitterAdmin, splitterAddress)
2241     {
2242         pauseMint();
2243     }
2244 
2245     function batchAirdrop(address[] calldata _recipients, uint[] calldata _amounts) public onlyOwner
2246     {
2247         require(_recipients.length <= BATCH_LIMIT, "QM: Batch more than limit");
2248         require(_recipients.length == _amounts.length, "QM: Need same length");
2249         
2250         for (uint i = 0; i < _recipients.length; i++){
2251             uint amount = _amounts[i];
2252             require(amount <= BATCH_LIMIT, "QM: Batch more than limit");
2253 
2254             mint(_recipients[i], amount);
2255         }
2256     }
2257 
2258     function claim(bytes32[] calldata _merkleProof, uint _mintAmount) public payable whenNotPaused {
2259         _verifyMint(_merkleProof, _mintAmount, _totalMinted(), 0);
2260         mint(msg.sender, _mintAmount);
2261         _updateWalletMintCount(msg.sender, _mintAmount);
2262     }
2263 
2264     function fish(uint[] calldata _tokenIds) public whenNotPaused returns (uint256) {
2265 
2266         address sender = msg.sender;
2267         uint256 timestamp = block.timestamp;
2268         uint256 fishedToken = 0;
2269 
2270         require(isFishingOpen, "QM: Fishing not open");
2271         require(_tokenIds.length <= BATCH_LIMIT, "QM: Batch more than limit");
2272 
2273         for (uint i = 0; i < _tokenIds.length; i++){
2274             uint tokenId = _tokenIds[i];
2275 
2276             require(ownerOf(tokenId) == sender, "QM: Need to own at least 1 FIL");
2277             require(timestamp - lastFishedTime[tokenId] >= FISHING_INTERVAL, "QM: Wait 24 hours");
2278             
2279             uint chance = _randomizeFishChance();
2280 
2281             if (chance <= FISHING_CHANCE) {
2282                 uint fishedTokenId = mint(msg.sender, 1);
2283                 fishedToken += 1;
2284 
2285                 lastFishedTime[fishedTokenId] = timestamp;
2286 
2287                 emit Fished(msg.sender, fishedTokenId, timestamp);
2288                 emit AttemptedFishing(fishedTokenId, timestamp);
2289             }
2290 
2291             lastFishedTime[tokenId] = timestamp;
2292             emit AttemptedFishing(tokenId, timestamp);
2293         }
2294 
2295         return fishedToken;
2296     }
2297 
2298     function _randomizeFishChance() private returns(uint){
2299 
2300         uint randomnumber = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))) % 100;
2301         randomnumber = randomnumber + 1;
2302         nonce++;
2303 
2304         return randomnumber;
2305     }
2306 
2307     function mint(address recipient, uint mintAmount) private returns (uint256)
2308     {
2309         require(_totalMinted().add(mintAmount) <= MAX_TOKEN_SUPPLY, "QM: Max Supply reached");
2310 
2311         _safeMint(recipient, mintAmount);
2312         
2313         return _totalMinted();
2314     }
2315 
2316     function pauseMint() public onlyOwner {
2317         _pause();
2318     }
2319 
2320     function unpauseMint() public onlyOwner {
2321         _unpause();
2322     }
2323 
2324     function tokenURI(uint _tokenId) public view override(ERC721A) returns (string memory) {
2325         require(_tokenId > 0, "QM: URI requested for invalid token");
2326         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, _tokenId.toString(), baseExtension)) : baseURI;
2327     }
2328 
2329     function totalTokensMinted() public view returns(uint256) {
2330         return _totalMinted();
2331     }
2332 
2333     function setBaseURI(string memory _baseURI) public onlyOwner {
2334         baseURI = _baseURI;
2335     }
2336 
2337     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
2338         baseExtension = _newBaseExtension;
2339     }
2340 
2341     function setFishingChance(uint _fishingChance) public onlyOwner {
2342         FISHING_CHANCE = _fishingChance;
2343     }
2344 
2345     function setFishingInterval(uint256 _fishingInterval) public onlyOwner {
2346         FISHING_INTERVAL = _fishingInterval;
2347     }
2348 
2349     function setFishingOpen(bool _isFishingOpen) public onlyOwner {
2350         isFishingOpen = _isFishingOpen;
2351     }
2352 
2353     function _baseURI() internal view override(ERC721A) returns (string memory) {
2354         return baseURI;
2355     }
2356 
2357     function supportsInterface(bytes4 interfaceId) public view override(ERC721A, AccessControl) returns (bool) {
2358         return super.supportsInterface(interfaceId);
2359     }
2360 
2361     function _startTokenId() internal view override(ERC721A) returns (uint256) {
2362         return 1;
2363     }
2364 }