1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.3.2 (utils/introspection/IERC165.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 // OpenZeppelin Contracts v4.3.2 (utils/Context.sol)
28 
29 
30 
31 /**
32  * @dev Provides information about the current execution context, including the
33  * sender of the transaction and its data. While these are generally available
34  * via msg.sender and msg.data, they should not be accessed in such a direct
35  * manner, since when dealing with meta-transactions the account sending and
36  * paying for execution may not be the actual sender (as far as an application
37  * is concerned).
38  *
39  * This contract is only required for intermediate, library-like contracts.
40  */
41 abstract contract Context {
42     function _msgSender() internal view virtual returns (address) {
43         return msg.sender;
44     }
45 
46     function _msgData() internal view virtual returns (bytes calldata) {
47         return msg.data;
48     }
49 }
50 
51 // OpenZeppelin Contracts v4.3.2 (utils/introspection/ERC165.sol)
52 
53 
54 
55 
56 
57 /**
58  * @dev Implementation of the {IERC165} interface.
59  *
60  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
61  * for the additional interface id that will be supported. For example:
62  *
63  * ```solidity
64  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
65  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
66  * }
67  * ```
68  *
69  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
70  */
71 abstract contract ERC165 is IERC165 {
72     /**
73      * @dev See {IERC165-supportsInterface}.
74      */
75     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
76         return interfaceId == type(IERC165).interfaceId;
77     }
78 }
79 
80 // OpenZeppelin Contracts v4.3.2 (utils/Strings.sol)
81 
82 
83 
84 /**
85  * @dev String operations.
86  */
87 library Strings {
88     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
89 
90     /**
91      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
92      */
93     function toString(uint256 value) internal pure returns (string memory) {
94         // Inspired by OraclizeAPI's implementation - MIT licence
95         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
96 
97         if (value == 0) {
98             return "0";
99         }
100         uint256 temp = value;
101         uint256 digits;
102         while (temp != 0) {
103             digits++;
104             temp /= 10;
105         }
106         bytes memory buffer = new bytes(digits);
107         while (value != 0) {
108             digits -= 1;
109             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
110             value /= 10;
111         }
112         return string(buffer);
113     }
114 
115     /**
116      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
117      */
118     function toHexString(uint256 value) internal pure returns (string memory) {
119         if (value == 0) {
120             return "0x00";
121         }
122         uint256 temp = value;
123         uint256 length = 0;
124         while (temp != 0) {
125             length++;
126             temp >>= 8;
127         }
128         return toHexString(value, length);
129     }
130 
131     /**
132      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
133      */
134     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
135         bytes memory buffer = new bytes(2 * length + 2);
136         buffer[0] = "0";
137         buffer[1] = "x";
138         for (uint256 i = 2 * length + 1; i > 1; --i) {
139             buffer[i] = _HEX_SYMBOLS[value & 0xf];
140             value >>= 4;
141         }
142         require(value == 0, "Strings: hex length insufficient");
143         return string(buffer);
144     }
145 }
146 
147 // OpenZeppelin Contracts v4.3.2 (access/IAccessControl.sol)
148 
149 
150 
151 /**
152  * @dev External interface of AccessControl declared to support ERC165 detection.
153  */
154 interface IAccessControl {
155     /**
156      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
157      *
158      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
159      * {RoleAdminChanged} not being emitted signaling this.
160      *
161      * _Available since v3.1._
162      */
163     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
164 
165     /**
166      * @dev Emitted when `account` is granted `role`.
167      *
168      * `sender` is the account that originated the contract call, an admin role
169      * bearer except when using {AccessControl-_setupRole}.
170      */
171     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
172 
173     /**
174      * @dev Emitted when `account` is revoked `role`.
175      *
176      * `sender` is the account that originated the contract call:
177      *   - if using `revokeRole`, it is the admin role bearer
178      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
179      */
180     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
181 
182     /**
183      * @dev Returns `true` if `account` has been granted `role`.
184      */
185     function hasRole(bytes32 role, address account) external view returns (bool);
186 
187     /**
188      * @dev Returns the admin role that controls `role`. See {grantRole} and
189      * {revokeRole}.
190      *
191      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
192      */
193     function getRoleAdmin(bytes32 role) external view returns (bytes32);
194 
195     /**
196      * @dev Grants `role` to `account`.
197      *
198      * If `account` had not been already granted `role`, emits a {RoleGranted}
199      * event.
200      *
201      * Requirements:
202      *
203      * - the caller must have ``role``'s admin role.
204      */
205     function grantRole(bytes32 role, address account) external;
206 
207     /**
208      * @dev Revokes `role` from `account`.
209      *
210      * If `account` had been granted `role`, emits a {RoleRevoked} event.
211      *
212      * Requirements:
213      *
214      * - the caller must have ``role``'s admin role.
215      */
216     function revokeRole(bytes32 role, address account) external;
217 
218     /**
219      * @dev Revokes `role` from the calling account.
220      *
221      * Roles are often managed via {grantRole} and {revokeRole}: this function's
222      * purpose is to provide a mechanism for accounts to lose their privileges
223      * if they are compromised (such as when a trusted device is misplaced).
224      *
225      * If the calling account had been granted `role`, emits a {RoleRevoked}
226      * event.
227      *
228      * Requirements:
229      *
230      * - the caller must be `account`.
231      */
232     function renounceRole(bytes32 role, address account) external;
233 }
234 
235 // OpenZeppelin Contracts v4.3.2 (token/ERC721/IERC721.sol)
236 
237 
238 
239 
240 
241 /**
242  * @dev Required interface of an ERC721 compliant contract.
243  */
244 interface IERC721 is IERC165 {
245     /**
246      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
247      */
248     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
249 
250     /**
251      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
252      */
253     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
254 
255     /**
256      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
257      */
258     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
259 
260     /**
261      * @dev Returns the number of tokens in ``owner``'s account.
262      */
263     function balanceOf(address owner) external view returns (uint256 balance);
264 
265     /**
266      * @dev Returns the owner of the `tokenId` token.
267      *
268      * Requirements:
269      *
270      * - `tokenId` must exist.
271      */
272     function ownerOf(uint256 tokenId) external view returns (address owner);
273 
274     /**
275      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
276      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
277      *
278      * Requirements:
279      *
280      * - `from` cannot be the zero address.
281      * - `to` cannot be the zero address.
282      * - `tokenId` token must exist and be owned by `from`.
283      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
284      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
285      *
286      * Emits a {Transfer} event.
287      */
288     function safeTransferFrom(
289         address from,
290         address to,
291         uint256 tokenId
292     ) external;
293 
294     /**
295      * @dev Transfers `tokenId` token from `from` to `to`.
296      *
297      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
298      *
299      * Requirements:
300      *
301      * - `from` cannot be the zero address.
302      * - `to` cannot be the zero address.
303      * - `tokenId` token must be owned by `from`.
304      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
305      *
306      * Emits a {Transfer} event.
307      */
308     function transferFrom(
309         address from,
310         address to,
311         uint256 tokenId
312     ) external;
313 
314     /**
315      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
316      * The approval is cleared when the token is transferred.
317      *
318      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
319      *
320      * Requirements:
321      *
322      * - The caller must own the token or be an approved operator.
323      * - `tokenId` must exist.
324      *
325      * Emits an {Approval} event.
326      */
327     function approve(address to, uint256 tokenId) external;
328 
329     /**
330      * @dev Returns the account approved for `tokenId` token.
331      *
332      * Requirements:
333      *
334      * - `tokenId` must exist.
335      */
336     function getApproved(uint256 tokenId) external view returns (address operator);
337 
338     /**
339      * @dev Approve or remove `operator` as an operator for the caller.
340      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
341      *
342      * Requirements:
343      *
344      * - The `operator` cannot be the caller.
345      *
346      * Emits an {ApprovalForAll} event.
347      */
348     function setApprovalForAll(address operator, bool _approved) external;
349 
350     /**
351      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
352      *
353      * See {setApprovalForAll}
354      */
355     function isApprovedForAll(address owner, address operator) external view returns (bool);
356 
357     /**
358      * @dev Safely transfers `tokenId` token from `from` to `to`.
359      *
360      * Requirements:
361      *
362      * - `from` cannot be the zero address.
363      * - `to` cannot be the zero address.
364      * - `tokenId` token must exist and be owned by `from`.
365      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
366      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
367      *
368      * Emits a {Transfer} event.
369      */
370     function safeTransferFrom(
371         address from,
372         address to,
373         uint256 tokenId,
374         bytes calldata data
375     ) external;
376 }
377 
378 
379 
380 
381 
382 // OpenZeppelin Contracts v4.3.2 (token/ERC721/extensions/ERC721Enumerable.sol)
383 
384 
385 
386 
387 // OpenZeppelin Contracts v4.3.2 (token/ERC721/ERC721.sol)
388 
389 
390 
391 
392 
393 // OpenZeppelin Contracts v4.3.2 (token/ERC721/IERC721Receiver.sol)
394 
395 
396 
397 /**
398  * @title ERC721 token receiver interface
399  * @dev Interface for any contract that wants to support safeTransfers
400  * from ERC721 asset contracts.
401  */
402 interface IERC721Receiver {
403     /**
404      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
405      * by `operator` from `from`, this function is called.
406      *
407      * It must return its Solidity selector to confirm the token transfer.
408      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
409      *
410      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
411      */
412     function onERC721Received(
413         address operator,
414         address from,
415         uint256 tokenId,
416         bytes calldata data
417     ) external returns (bytes4);
418 }
419 
420 
421 // OpenZeppelin Contracts v4.3.2 (token/ERC721/extensions/IERC721Metadata.sol)
422 
423 
424 
425 
426 
427 /**
428  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
429  * @dev See https://eips.ethereum.org/EIPS/eip-721
430  */
431 interface IERC721Metadata is IERC721 {
432     /**
433      * @dev Returns the token collection name.
434      */
435     function name() external view returns (string memory);
436 
437     /**
438      * @dev Returns the token collection symbol.
439      */
440     function symbol() external view returns (string memory);
441 
442     /**
443      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
444      */
445     function tokenURI(uint256 tokenId) external view returns (string memory);
446 }
447 
448 
449 // OpenZeppelin Contracts v4.3.2 (utils/Address.sol)
450 
451 
452 
453 /**
454  * @dev Collection of functions related to the address type
455  */
456 library Address {
457     /**
458      * @dev Returns true if `account` is a contract.
459      *
460      * [IMPORTANT]
461      * ====
462      * It is unsafe to assume that an address for which this function returns
463      * false is an externally-owned account (EOA) and not a contract.
464      *
465      * Among others, `isContract` will return false for the following
466      * types of addresses:
467      *
468      *  - an externally-owned account
469      *  - a contract in construction
470      *  - an address where a contract will be created
471      *  - an address where a contract lived, but was destroyed
472      * ====
473      */
474     function isContract(address account) internal view returns (bool) {
475         // This method relies on extcodesize, which returns 0 for contracts in
476         // construction, since the code is only stored at the end of the
477         // constructor execution.
478 
479         uint256 size;
480         assembly {
481             size := extcodesize(account)
482         }
483         return size > 0;
484     }
485 
486     /**
487      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
488      * `recipient`, forwarding all available gas and reverting on errors.
489      *
490      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
491      * of certain opcodes, possibly making contracts go over the 2300 gas limit
492      * imposed by `transfer`, making them unable to receive funds via
493      * `transfer`. {sendValue} removes this limitation.
494      *
495      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
496      *
497      * IMPORTANT: because control is transferred to `recipient`, care must be
498      * taken to not create reentrancy vulnerabilities. Consider using
499      * {ReentrancyGuard} or the
500      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
501      */
502     function sendValue(address payable recipient, uint256 amount) internal {
503         require(address(this).balance >= amount, "Address: insufficient balance");
504 
505         (bool success, ) = recipient.call{value: amount}("");
506         require(success, "Address: unable to send value, recipient may have reverted");
507     }
508 
509     /**
510      * @dev Performs a Solidity function call using a low level `call`. A
511      * plain `call` is an unsafe replacement for a function call: use this
512      * function instead.
513      *
514      * If `target` reverts with a revert reason, it is bubbled up by this
515      * function (like regular Solidity function calls).
516      *
517      * Returns the raw returned data. To convert to the expected return value,
518      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
519      *
520      * Requirements:
521      *
522      * - `target` must be a contract.
523      * - calling `target` with `data` must not revert.
524      *
525      * _Available since v3.1._
526      */
527     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
528         return functionCall(target, data, "Address: low-level call failed");
529     }
530 
531     /**
532      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
533      * `errorMessage` as a fallback revert reason when `target` reverts.
534      *
535      * _Available since v3.1._
536      */
537     function functionCall(
538         address target,
539         bytes memory data,
540         string memory errorMessage
541     ) internal returns (bytes memory) {
542         return functionCallWithValue(target, data, 0, errorMessage);
543     }
544 
545     /**
546      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
547      * but also transferring `value` wei to `target`.
548      *
549      * Requirements:
550      *
551      * - the calling contract must have an ETH balance of at least `value`.
552      * - the called Solidity function must be `payable`.
553      *
554      * _Available since v3.1._
555      */
556     function functionCallWithValue(
557         address target,
558         bytes memory data,
559         uint256 value
560     ) internal returns (bytes memory) {
561         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
562     }
563 
564     /**
565      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
566      * with `errorMessage` as a fallback revert reason when `target` reverts.
567      *
568      * _Available since v3.1._
569      */
570     function functionCallWithValue(
571         address target,
572         bytes memory data,
573         uint256 value,
574         string memory errorMessage
575     ) internal returns (bytes memory) {
576         require(address(this).balance >= value, "Address: insufficient balance for call");
577         require(isContract(target), "Address: call to non-contract");
578 
579         (bool success, bytes memory returndata) = target.call{value: value}(data);
580         return verifyCallResult(success, returndata, errorMessage);
581     }
582 
583     /**
584      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
585      * but performing a static call.
586      *
587      * _Available since v3.3._
588      */
589     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
590         return functionStaticCall(target, data, "Address: low-level static call failed");
591     }
592 
593     /**
594      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
595      * but performing a static call.
596      *
597      * _Available since v3.3._
598      */
599     function functionStaticCall(
600         address target,
601         bytes memory data,
602         string memory errorMessage
603     ) internal view returns (bytes memory) {
604         require(isContract(target), "Address: static call to non-contract");
605 
606         (bool success, bytes memory returndata) = target.staticcall(data);
607         return verifyCallResult(success, returndata, errorMessage);
608     }
609 
610     /**
611      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
612      * but performing a delegate call.
613      *
614      * _Available since v3.4._
615      */
616     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
617         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
618     }
619 
620     /**
621      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
622      * but performing a delegate call.
623      *
624      * _Available since v3.4._
625      */
626     function functionDelegateCall(
627         address target,
628         bytes memory data,
629         string memory errorMessage
630     ) internal returns (bytes memory) {
631         require(isContract(target), "Address: delegate call to non-contract");
632 
633         (bool success, bytes memory returndata) = target.delegatecall(data);
634         return verifyCallResult(success, returndata, errorMessage);
635     }
636 
637     /**
638      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
639      * revert reason using the provided one.
640      *
641      * _Available since v4.3._
642      */
643     function verifyCallResult(
644         bool success,
645         bytes memory returndata,
646         string memory errorMessage
647     ) internal pure returns (bytes memory) {
648         if (success) {
649             return returndata;
650         } else {
651             // Look for revert reason and bubble it up if present
652             if (returndata.length > 0) {
653                 // The easiest way to bubble the revert reason is using memory via assembly
654 
655                 assembly {
656                     let returndata_size := mload(returndata)
657                     revert(add(32, returndata), returndata_size)
658                 }
659             } else {
660                 revert(errorMessage);
661             }
662         }
663     }
664 }
665 
666 
667 
668 
669 
670 /**
671  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
672  * the Metadata extension, but not including the Enumerable extension, which is available separately as
673  * {ERC721Enumerable}.
674  */
675 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
676     using Address for address;
677     using Strings for uint256;
678 
679     // Token name
680     string private _name;
681 
682     // Token symbol
683     string private _symbol;
684 
685     // Mapping from token ID to owner address
686     mapping(uint256 => address) private _owners;
687 
688     // Mapping owner address to token count
689     mapping(address => uint256) private _balances;
690 
691     // Mapping from token ID to approved address
692     mapping(uint256 => address) private _tokenApprovals;
693 
694     // Mapping from owner to operator approvals
695     mapping(address => mapping(address => bool)) private _operatorApprovals;
696 
697     /**
698      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
699      */
700     constructor(string memory name_, string memory symbol_) {
701         _name = name_;
702         _symbol = symbol_;
703     }
704 
705     /**
706      * @dev See {IERC165-supportsInterface}.
707      */
708     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
709         return
710             interfaceId == type(IERC721).interfaceId ||
711             interfaceId == type(IERC721Metadata).interfaceId ||
712             super.supportsInterface(interfaceId);
713     }
714 
715     /**
716      * @dev See {IERC721-balanceOf}.
717      */
718     function balanceOf(address owner) public view virtual override returns (uint256) {
719         require(owner != address(0), "ERC721: balance query for the zero address");
720         return _balances[owner];
721     }
722 
723     /**
724      * @dev See {IERC721-ownerOf}.
725      */
726     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
727         address owner = _owners[tokenId];
728         require(owner != address(0), "ERC721: owner query for nonexistent token");
729         return owner;
730     }
731 
732     /**
733      * @dev See {IERC721Metadata-name}.
734      */
735     function name() public view virtual override returns (string memory) {
736         return _name;
737     }
738 
739     /**
740      * @dev See {IERC721Metadata-symbol}.
741      */
742     function symbol() public view virtual override returns (string memory) {
743         return _symbol;
744     }
745 
746     /**
747      * @dev See {IERC721Metadata-tokenURI}.
748      */
749     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
750         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
751 
752         string memory baseURI = _baseURI();
753         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
754     }
755 
756     /**
757      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
758      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
759      * by default, can be overriden in child contracts.
760      */
761     function _baseURI() internal view virtual returns (string memory) {
762         return "";
763     }
764 
765     /**
766      * @dev See {IERC721-approve}.
767      */
768     function approve(address to, uint256 tokenId) public virtual override {
769         address owner = ERC721.ownerOf(tokenId);
770         require(to != owner, "ERC721: approval to current owner");
771 
772         require(
773             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
774             "ERC721: approve caller is not owner nor approved for all"
775         );
776 
777         _approve(to, tokenId);
778     }
779 
780     /**
781      * @dev See {IERC721-getApproved}.
782      */
783     function getApproved(uint256 tokenId) public view virtual override returns (address) {
784         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
785 
786         return _tokenApprovals[tokenId];
787     }
788 
789     /**
790      * @dev See {IERC721-setApprovalForAll}.
791      */
792     function setApprovalForAll(address operator, bool approved) public virtual override {
793         _setApprovalForAll(_msgSender(), operator, approved);
794     }
795 
796     /**
797      * @dev See {IERC721-isApprovedForAll}.
798      */
799     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
800         return _operatorApprovals[owner][operator];
801     }
802 
803     /**
804      * @dev See {IERC721-transferFrom}.
805      */
806     function transferFrom(
807         address from,
808         address to,
809         uint256 tokenId
810     ) public virtual override {
811         //solhint-disable-next-line max-line-length
812         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
813 
814         _transfer(from, to, tokenId);
815     }
816 
817     /**
818      * @dev See {IERC721-safeTransferFrom}.
819      */
820     function safeTransferFrom(
821         address from,
822         address to,
823         uint256 tokenId
824     ) public virtual override {
825         safeTransferFrom(from, to, tokenId, "");
826     }
827 
828     /**
829      * @dev See {IERC721-safeTransferFrom}.
830      */
831     function safeTransferFrom(
832         address from,
833         address to,
834         uint256 tokenId,
835         bytes memory _data
836     ) public virtual override {
837         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
838         _safeTransfer(from, to, tokenId, _data);
839     }
840 
841     /**
842      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
843      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
844      *
845      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
846      *
847      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
848      * implement alternative mechanisms to perform token transfer, such as signature-based.
849      *
850      * Requirements:
851      *
852      * - `from` cannot be the zero address.
853      * - `to` cannot be the zero address.
854      * - `tokenId` token must exist and be owned by `from`.
855      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
856      *
857      * Emits a {Transfer} event.
858      */
859     function _safeTransfer(
860         address from,
861         address to,
862         uint256 tokenId,
863         bytes memory _data
864     ) internal virtual {
865         _transfer(from, to, tokenId);
866         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
867     }
868 
869     /**
870      * @dev Returns whether `tokenId` exists.
871      *
872      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
873      *
874      * Tokens start existing when they are minted (`_mint`),
875      * and stop existing when they are burned (`_burn`).
876      */
877     function _exists(uint256 tokenId) internal view virtual returns (bool) {
878         return _owners[tokenId] != address(0);
879     }
880 
881     /**
882      * @dev Returns whether `spender` is allowed to manage `tokenId`.
883      *
884      * Requirements:
885      *
886      * - `tokenId` must exist.
887      */
888     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
889         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
890         address owner = ERC721.ownerOf(tokenId);
891         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
892     }
893 
894     /**
895      * @dev Safely mints `tokenId` and transfers it to `to`.
896      *
897      * Requirements:
898      *
899      * - `tokenId` must not exist.
900      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
901      *
902      * Emits a {Transfer} event.
903      */
904     function _safeMint(address to, uint256 tokenId) internal virtual {
905         _safeMint(to, tokenId, "");
906     }
907 
908     /**
909      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
910      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
911      */
912     function _safeMint(
913         address to,
914         uint256 tokenId,
915         bytes memory _data
916     ) internal virtual {
917         _mint(to, tokenId);
918         require(
919             _checkOnERC721Received(address(0), to, tokenId, _data),
920             "ERC721: transfer to non ERC721Receiver implementer"
921         );
922     }
923 
924     /**
925      * @dev Mints `tokenId` and transfers it to `to`.
926      *
927      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
928      *
929      * Requirements:
930      *
931      * - `tokenId` must not exist.
932      * - `to` cannot be the zero address.
933      *
934      * Emits a {Transfer} event.
935      */
936     function _mint(address to, uint256 tokenId) internal virtual {
937         require(to != address(0), "ERC721: mint to the zero address");
938         require(!_exists(tokenId), "ERC721: token already minted");
939 
940         _beforeTokenTransfer(address(0), to, tokenId);
941 
942         _balances[to] += 1;
943         _owners[tokenId] = to;
944 
945         emit Transfer(address(0), to, tokenId);
946     }
947 
948     /**
949      * @dev Destroys `tokenId`.
950      * The approval is cleared when the token is burned.
951      *
952      * Requirements:
953      *
954      * - `tokenId` must exist.
955      *
956      * Emits a {Transfer} event.
957      */
958     function _burn(uint256 tokenId) internal virtual {
959         address owner = ERC721.ownerOf(tokenId);
960 
961         _beforeTokenTransfer(owner, address(0), tokenId);
962 
963         // Clear approvals
964         _approve(address(0), tokenId);
965 
966         _balances[owner] -= 1;
967         delete _owners[tokenId];
968 
969         emit Transfer(owner, address(0), tokenId);
970     }
971 
972     /**
973      * @dev Transfers `tokenId` from `from` to `to`.
974      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
975      *
976      * Requirements:
977      *
978      * - `to` cannot be the zero address.
979      * - `tokenId` token must be owned by `from`.
980      *
981      * Emits a {Transfer} event.
982      */
983     function _transfer(
984         address from,
985         address to,
986         uint256 tokenId
987     ) internal virtual {
988         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
989         require(to != address(0), "ERC721: transfer to the zero address");
990 
991         _beforeTokenTransfer(from, to, tokenId);
992 
993         // Clear approvals from the previous owner
994         _approve(address(0), tokenId);
995 
996         _balances[from] -= 1;
997         _balances[to] += 1;
998         _owners[tokenId] = to;
999 
1000         emit Transfer(from, to, tokenId);
1001     }
1002 
1003     /**
1004      * @dev Approve `to` to operate on `tokenId`
1005      *
1006      * Emits a {Approval} event.
1007      */
1008     function _approve(address to, uint256 tokenId) internal virtual {
1009         _tokenApprovals[tokenId] = to;
1010         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1011     }
1012 
1013     /**
1014      * @dev Approve `operator` to operate on all of `owner` tokens
1015      *
1016      * Emits a {ApprovalForAll} event.
1017      */
1018     function _setApprovalForAll(
1019         address owner,
1020         address operator,
1021         bool approved
1022     ) internal virtual {
1023         require(owner != operator, "ERC721: approve to caller");
1024         _operatorApprovals[owner][operator] = approved;
1025         emit ApprovalForAll(owner, operator, approved);
1026     }
1027 
1028     /**
1029      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1030      * The call is not executed if the target address is not a contract.
1031      *
1032      * @param from address representing the previous owner of the given token ID
1033      * @param to target address that will receive the tokens
1034      * @param tokenId uint256 ID of the token to be transferred
1035      * @param _data bytes optional data to send along with the call
1036      * @return bool whether the call correctly returned the expected magic value
1037      */
1038     function _checkOnERC721Received(
1039         address from,
1040         address to,
1041         uint256 tokenId,
1042         bytes memory _data
1043     ) private returns (bool) {
1044         if (to.isContract()) {
1045             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1046                 return retval == IERC721Receiver.onERC721Received.selector;
1047             } catch (bytes memory reason) {
1048                 if (reason.length == 0) {
1049                     revert("ERC721: transfer to non ERC721Receiver implementer");
1050                 } else {
1051                     assembly {
1052                         revert(add(32, reason), mload(reason))
1053                     }
1054                 }
1055             }
1056         } else {
1057             return true;
1058         }
1059     }
1060 
1061     /**
1062      * @dev Hook that is called before any token transfer. This includes minting
1063      * and burning.
1064      *
1065      * Calling conditions:
1066      *
1067      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1068      * transferred to `to`.
1069      * - When `from` is zero, `tokenId` will be minted for `to`.
1070      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1071      * - `from` and `to` are never both zero.
1072      *
1073      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1074      */
1075     function _beforeTokenTransfer(
1076         address from,
1077         address to,
1078         uint256 tokenId
1079     ) internal virtual {}
1080 }
1081 
1082 
1083 // OpenZeppelin Contracts v4.3.2 (token/ERC721/extensions/IERC721Enumerable.sol)
1084 
1085 
1086 
1087 
1088 
1089 /**
1090  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1091  * @dev See https://eips.ethereum.org/EIPS/eip-721
1092  */
1093 interface IERC721Enumerable is IERC721 {
1094     /**
1095      * @dev Returns the total amount of tokens stored by the contract.
1096      */
1097     function totalSupply() external view returns (uint256);
1098 
1099     /**
1100      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1101      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1102      */
1103     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1104 
1105     /**
1106      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1107      * Use along with {totalSupply} to enumerate all tokens.
1108      */
1109     function tokenByIndex(uint256 index) external view returns (uint256);
1110 }
1111 
1112 
1113 /**
1114  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1115  * enumerability of all the token ids in the contract as well as all token ids owned by each
1116  * account.
1117  */
1118 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1119     // Mapping from owner to list of owned token IDs
1120     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1121 
1122     // Mapping from token ID to index of the owner tokens list
1123     mapping(uint256 => uint256) private _ownedTokensIndex;
1124 
1125     // Array with all token ids, used for enumeration
1126     uint256[] private _allTokens;
1127 
1128     // Mapping from token id to position in the allTokens array
1129     mapping(uint256 => uint256) private _allTokensIndex;
1130 
1131     /**
1132      * @dev See {IERC165-supportsInterface}.
1133      */
1134     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1135         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1136     }
1137 
1138     /**
1139      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1140      */
1141     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1142         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1143         return _ownedTokens[owner][index];
1144     }
1145 
1146     /**
1147      * @dev See {IERC721Enumerable-totalSupply}.
1148      */
1149     function totalSupply() public view virtual override returns (uint256) {
1150         return _allTokens.length;
1151     }
1152 
1153     /**
1154      * @dev See {IERC721Enumerable-tokenByIndex}.
1155      */
1156     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1157         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1158         return _allTokens[index];
1159     }
1160 
1161     /**
1162      * @dev Hook that is called before any token transfer. This includes minting
1163      * and burning.
1164      *
1165      * Calling conditions:
1166      *
1167      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1168      * transferred to `to`.
1169      * - When `from` is zero, `tokenId` will be minted for `to`.
1170      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1171      * - `from` cannot be the zero address.
1172      * - `to` cannot be the zero address.
1173      *
1174      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1175      */
1176     function _beforeTokenTransfer(
1177         address from,
1178         address to,
1179         uint256 tokenId
1180     ) internal virtual override {
1181         super._beforeTokenTransfer(from, to, tokenId);
1182 
1183         if (from == address(0)) {
1184             _addTokenToAllTokensEnumeration(tokenId);
1185         } else if (from != to) {
1186             _removeTokenFromOwnerEnumeration(from, tokenId);
1187         }
1188         if (to == address(0)) {
1189             _removeTokenFromAllTokensEnumeration(tokenId);
1190         } else if (to != from) {
1191             _addTokenToOwnerEnumeration(to, tokenId);
1192         }
1193     }
1194 
1195     /**
1196      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1197      * @param to address representing the new owner of the given token ID
1198      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1199      */
1200     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1201         uint256 length = ERC721.balanceOf(to);
1202         _ownedTokens[to][length] = tokenId;
1203         _ownedTokensIndex[tokenId] = length;
1204     }
1205 
1206     /**
1207      * @dev Private function to add a token to this extension's token tracking data structures.
1208      * @param tokenId uint256 ID of the token to be added to the tokens list
1209      */
1210     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1211         _allTokensIndex[tokenId] = _allTokens.length;
1212         _allTokens.push(tokenId);
1213     }
1214 
1215     /**
1216      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1217      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1218      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1219      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1220      * @param from address representing the previous owner of the given token ID
1221      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1222      */
1223     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1224         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1225         // then delete the last slot (swap and pop).
1226 
1227         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1228         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1229 
1230         // When the token to delete is the last token, the swap operation is unnecessary
1231         if (tokenIndex != lastTokenIndex) {
1232             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1233 
1234             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1235             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1236         }
1237 
1238         // This also deletes the contents at the last position of the array
1239         delete _ownedTokensIndex[tokenId];
1240         delete _ownedTokens[from][lastTokenIndex];
1241     }
1242 
1243     /**
1244      * @dev Private function to remove a token from this extension's token tracking data structures.
1245      * This has O(1) time complexity, but alters the order of the _allTokens array.
1246      * @param tokenId uint256 ID of the token to be removed from the tokens list
1247      */
1248     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1249         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1250         // then delete the last slot (swap and pop).
1251 
1252         uint256 lastTokenIndex = _allTokens.length - 1;
1253         uint256 tokenIndex = _allTokensIndex[tokenId];
1254 
1255         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1256         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1257         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1258         uint256 lastTokenId = _allTokens[lastTokenIndex];
1259 
1260         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1261         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1262 
1263         // This also deletes the contents at the last position of the array
1264         delete _allTokensIndex[tokenId];
1265         _allTokens.pop();
1266     }
1267 }
1268 
1269 
1270 // OpenZeppelin Contracts v4.3.2 (access/AccessControlEnumerable.sol)
1271 
1272 
1273 
1274 
1275 // OpenZeppelin Contracts v4.3.2 (access/IAccessControlEnumerable.sol)
1276 
1277 
1278 
1279 
1280 
1281 /**
1282  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
1283  */
1284 interface IAccessControlEnumerable is IAccessControl {
1285     /**
1286      * @dev Returns one of the accounts that have `role`. `index` must be a
1287      * value between 0 and {getRoleMemberCount}, non-inclusive.
1288      *
1289      * Role bearers are not sorted in any particular way, and their ordering may
1290      * change at any point.
1291      *
1292      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1293      * you perform all queries on the same block. See the following
1294      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1295      * for more information.
1296      */
1297     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
1298 
1299     /**
1300      * @dev Returns the number of accounts that have `role`. Can be used
1301      * together with {getRoleMember} to enumerate all bearers of a role.
1302      */
1303     function getRoleMemberCount(bytes32 role) external view returns (uint256);
1304 }
1305 
1306 
1307 // OpenZeppelin Contracts v4.3.2 (access/AccessControl.sol)
1308 
1309 
1310 
1311 
1312 
1313 
1314 
1315 
1316 /**
1317  * @dev Contract module that allows children to implement role-based access
1318  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1319  * members except through off-chain means by accessing the contract event logs. Some
1320  * applications may benefit from on-chain enumerability, for those cases see
1321  * {AccessControlEnumerable}.
1322  *
1323  * Roles are referred to by their `bytes32` identifier. These should be exposed
1324  * in the external API and be unique. The best way to achieve this is by
1325  * using `public constant` hash digests:
1326  *
1327  * ```
1328  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1329  * ```
1330  *
1331  * Roles can be used to represent a set of permissions. To restrict access to a
1332  * function call, use {hasRole}:
1333  *
1334  * ```
1335  * function foo() public {
1336  *     require(hasRole(MY_ROLE, msg.sender));
1337  *     ...
1338  * }
1339  * ```
1340  *
1341  * Roles can be granted and revoked dynamically via the {grantRole} and
1342  * {revokeRole} functions. Each role has an associated admin role, and only
1343  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1344  *
1345  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1346  * that only accounts with this role will be able to grant or revoke other
1347  * roles. More complex role relationships can be created by using
1348  * {_setRoleAdmin}.
1349  *
1350  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1351  * grant and revoke this role. Extra precautions should be taken to secure
1352  * accounts that have been granted it.
1353  */
1354 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1355     struct RoleData {
1356         mapping(address => bool) members;
1357         bytes32 adminRole;
1358     }
1359 
1360     mapping(bytes32 => RoleData) private _roles;
1361 
1362     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1363 
1364     /**
1365      * @dev Modifier that checks that an account has a specific role. Reverts
1366      * with a standardized message including the required role.
1367      *
1368      * The format of the revert reason is given by the following regular expression:
1369      *
1370      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1371      *
1372      * _Available since v4.1._
1373      */
1374     modifier onlyRole(bytes32 role) {
1375         _checkRole(role, _msgSender());
1376         _;
1377     }
1378 
1379     /**
1380      * @dev See {IERC165-supportsInterface}.
1381      */
1382     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1383         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1384     }
1385 
1386     /**
1387      * @dev Returns `true` if `account` has been granted `role`.
1388      */
1389     function hasRole(bytes32 role, address account) public view override returns (bool) {
1390         return _roles[role].members[account];
1391     }
1392 
1393     /**
1394      * @dev Revert with a standard message if `account` is missing `role`.
1395      *
1396      * The format of the revert reason is given by the following regular expression:
1397      *
1398      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1399      */
1400     function _checkRole(bytes32 role, address account) internal view {
1401         if (!hasRole(role, account)) {
1402             revert(
1403                 string(
1404                     abi.encodePacked(
1405                         "AccessControl: account ",
1406                         Strings.toHexString(uint160(account), 20),
1407                         " is missing role ",
1408                         Strings.toHexString(uint256(role), 32)
1409                     )
1410                 )
1411             );
1412         }
1413     }
1414 
1415     /**
1416      * @dev Returns the admin role that controls `role`. See {grantRole} and
1417      * {revokeRole}.
1418      *
1419      * To change a role's admin, use {_setRoleAdmin}.
1420      */
1421     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1422         return _roles[role].adminRole;
1423     }
1424 
1425     /**
1426      * @dev Grants `role` to `account`.
1427      *
1428      * If `account` had not been already granted `role`, emits a {RoleGranted}
1429      * event.
1430      *
1431      * Requirements:
1432      *
1433      * - the caller must have ``role``'s admin role.
1434      */
1435     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1436         _grantRole(role, account);
1437     }
1438 
1439     /**
1440      * @dev Revokes `role` from `account`.
1441      *
1442      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1443      *
1444      * Requirements:
1445      *
1446      * - the caller must have ``role``'s admin role.
1447      */
1448     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1449         _revokeRole(role, account);
1450     }
1451 
1452     /**
1453      * @dev Revokes `role` from the calling account.
1454      *
1455      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1456      * purpose is to provide a mechanism for accounts to lose their privileges
1457      * if they are compromised (such as when a trusted device is misplaced).
1458      *
1459      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1460      * event.
1461      *
1462      * Requirements:
1463      *
1464      * - the caller must be `account`.
1465      */
1466     function renounceRole(bytes32 role, address account) public virtual override {
1467         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1468 
1469         _revokeRole(role, account);
1470     }
1471 
1472     /**
1473      * @dev Grants `role` to `account`.
1474      *
1475      * If `account` had not been already granted `role`, emits a {RoleGranted}
1476      * event. Note that unlike {grantRole}, this function doesn't perform any
1477      * checks on the calling account.
1478      *
1479      * [WARNING]
1480      * ====
1481      * This function should only be called from the constructor when setting
1482      * up the initial roles for the system.
1483      *
1484      * Using this function in any other way is effectively circumventing the admin
1485      * system imposed by {AccessControl}.
1486      * ====
1487      *
1488      * NOTE: This function is deprecated in favor of {_grantRole}.
1489      */
1490     function _setupRole(bytes32 role, address account) internal virtual {
1491         _grantRole(role, account);
1492     }
1493 
1494     /**
1495      * @dev Sets `adminRole` as ``role``'s admin role.
1496      *
1497      * Emits a {RoleAdminChanged} event.
1498      */
1499     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1500         bytes32 previousAdminRole = getRoleAdmin(role);
1501         _roles[role].adminRole = adminRole;
1502         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1503     }
1504 
1505     /**
1506      * @dev Grants `role` to `account`.
1507      *
1508      * Internal function without access restriction.
1509      */
1510     function _grantRole(bytes32 role, address account) internal virtual {
1511         if (!hasRole(role, account)) {
1512             _roles[role].members[account] = true;
1513             emit RoleGranted(role, account, _msgSender());
1514         }
1515     }
1516 
1517     /**
1518      * @dev Revokes `role` from `account`.
1519      *
1520      * Internal function without access restriction.
1521      */
1522     function _revokeRole(bytes32 role, address account) internal virtual {
1523         if (hasRole(role, account)) {
1524             _roles[role].members[account] = false;
1525             emit RoleRevoked(role, account, _msgSender());
1526         }
1527     }
1528 }
1529 
1530 
1531 // OpenZeppelin Contracts v4.3.2 (utils/structs/EnumerableSet.sol)
1532 
1533 
1534 
1535 /**
1536  * @dev Library for managing
1537  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1538  * types.
1539  *
1540  * Sets have the following properties:
1541  *
1542  * - Elements are added, removed, and checked for existence in constant time
1543  * (O(1)).
1544  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1545  *
1546  * ```
1547  * contract Example {
1548  *     // Add the library methods
1549  *     using EnumerableSet for EnumerableSet.AddressSet;
1550  *
1551  *     // Declare a set state variable
1552  *     EnumerableSet.AddressSet private mySet;
1553  * }
1554  * ```
1555  *
1556  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1557  * and `uint256` (`UintSet`) are supported.
1558  */
1559 library EnumerableSet {
1560     // To implement this library for multiple types with as little code
1561     // repetition as possible, we write it in terms of a generic Set type with
1562     // bytes32 values.
1563     // The Set implementation uses private functions, and user-facing
1564     // implementations (such as AddressSet) are just wrappers around the
1565     // underlying Set.
1566     // This means that we can only create new EnumerableSets for types that fit
1567     // in bytes32.
1568 
1569     struct Set {
1570         // Storage of set values
1571         bytes32[] _values;
1572         // Position of the value in the `values` array, plus 1 because index 0
1573         // means a value is not in the set.
1574         mapping(bytes32 => uint256) _indexes;
1575     }
1576 
1577     /**
1578      * @dev Add a value to a set. O(1).
1579      *
1580      * Returns true if the value was added to the set, that is if it was not
1581      * already present.
1582      */
1583     function _add(Set storage set, bytes32 value) private returns (bool) {
1584         if (!_contains(set, value)) {
1585             set._values.push(value);
1586             // The value is stored at length-1, but we add 1 to all indexes
1587             // and use 0 as a sentinel value
1588             set._indexes[value] = set._values.length;
1589             return true;
1590         } else {
1591             return false;
1592         }
1593     }
1594 
1595     /**
1596      * @dev Removes a value from a set. O(1).
1597      *
1598      * Returns true if the value was removed from the set, that is if it was
1599      * present.
1600      */
1601     function _remove(Set storage set, bytes32 value) private returns (bool) {
1602         // We read and store the value's index to prevent multiple reads from the same storage slot
1603         uint256 valueIndex = set._indexes[value];
1604 
1605         if (valueIndex != 0) {
1606             // Equivalent to contains(set, value)
1607             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1608             // the array, and then remove the last element (sometimes called as 'swap and pop').
1609             // This modifies the order of the array, as noted in {at}.
1610 
1611             uint256 toDeleteIndex = valueIndex - 1;
1612             uint256 lastIndex = set._values.length - 1;
1613 
1614             if (lastIndex != toDeleteIndex) {
1615                 bytes32 lastvalue = set._values[lastIndex];
1616 
1617                 // Move the last value to the index where the value to delete is
1618                 set._values[toDeleteIndex] = lastvalue;
1619                 // Update the index for the moved value
1620                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
1621             }
1622 
1623             // Delete the slot where the moved value was stored
1624             set._values.pop();
1625 
1626             // Delete the index for the deleted slot
1627             delete set._indexes[value];
1628 
1629             return true;
1630         } else {
1631             return false;
1632         }
1633     }
1634 
1635     /**
1636      * @dev Returns true if the value is in the set. O(1).
1637      */
1638     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1639         return set._indexes[value] != 0;
1640     }
1641 
1642     /**
1643      * @dev Returns the number of values on the set. O(1).
1644      */
1645     function _length(Set storage set) private view returns (uint256) {
1646         return set._values.length;
1647     }
1648 
1649     /**
1650      * @dev Returns the value stored at position `index` in the set. O(1).
1651      *
1652      * Note that there are no guarantees on the ordering of values inside the
1653      * array, and it may change when more values are added or removed.
1654      *
1655      * Requirements:
1656      *
1657      * - `index` must be strictly less than {length}.
1658      */
1659     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1660         return set._values[index];
1661     }
1662 
1663     /**
1664      * @dev Return the entire set in an array
1665      *
1666      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1667      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1668      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1669      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1670      */
1671     function _values(Set storage set) private view returns (bytes32[] memory) {
1672         return set._values;
1673     }
1674 
1675     // Bytes32Set
1676 
1677     struct Bytes32Set {
1678         Set _inner;
1679     }
1680 
1681     /**
1682      * @dev Add a value to a set. O(1).
1683      *
1684      * Returns true if the value was added to the set, that is if it was not
1685      * already present.
1686      */
1687     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1688         return _add(set._inner, value);
1689     }
1690 
1691     /**
1692      * @dev Removes a value from a set. O(1).
1693      *
1694      * Returns true if the value was removed from the set, that is if it was
1695      * present.
1696      */
1697     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1698         return _remove(set._inner, value);
1699     }
1700 
1701     /**
1702      * @dev Returns true if the value is in the set. O(1).
1703      */
1704     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1705         return _contains(set._inner, value);
1706     }
1707 
1708     /**
1709      * @dev Returns the number of values in the set. O(1).
1710      */
1711     function length(Bytes32Set storage set) internal view returns (uint256) {
1712         return _length(set._inner);
1713     }
1714 
1715     /**
1716      * @dev Returns the value stored at position `index` in the set. O(1).
1717      *
1718      * Note that there are no guarantees on the ordering of values inside the
1719      * array, and it may change when more values are added or removed.
1720      *
1721      * Requirements:
1722      *
1723      * - `index` must be strictly less than {length}.
1724      */
1725     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1726         return _at(set._inner, index);
1727     }
1728 
1729     /**
1730      * @dev Return the entire set in an array
1731      *
1732      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1733      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1734      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1735      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1736      */
1737     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
1738         return _values(set._inner);
1739     }
1740 
1741     // AddressSet
1742 
1743     struct AddressSet {
1744         Set _inner;
1745     }
1746 
1747     /**
1748      * @dev Add a value to a set. O(1).
1749      *
1750      * Returns true if the value was added to the set, that is if it was not
1751      * already present.
1752      */
1753     function add(AddressSet storage set, address value) internal returns (bool) {
1754         return _add(set._inner, bytes32(uint256(uint160(value))));
1755     }
1756 
1757     /**
1758      * @dev Removes a value from a set. O(1).
1759      *
1760      * Returns true if the value was removed from the set, that is if it was
1761      * present.
1762      */
1763     function remove(AddressSet storage set, address value) internal returns (bool) {
1764         return _remove(set._inner, bytes32(uint256(uint160(value))));
1765     }
1766 
1767     /**
1768      * @dev Returns true if the value is in the set. O(1).
1769      */
1770     function contains(AddressSet storage set, address value) internal view returns (bool) {
1771         return _contains(set._inner, bytes32(uint256(uint160(value))));
1772     }
1773 
1774     /**
1775      * @dev Returns the number of values in the set. O(1).
1776      */
1777     function length(AddressSet storage set) internal view returns (uint256) {
1778         return _length(set._inner);
1779     }
1780 
1781     /**
1782      * @dev Returns the value stored at position `index` in the set. O(1).
1783      *
1784      * Note that there are no guarantees on the ordering of values inside the
1785      * array, and it may change when more values are added or removed.
1786      *
1787      * Requirements:
1788      *
1789      * - `index` must be strictly less than {length}.
1790      */
1791     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1792         return address(uint160(uint256(_at(set._inner, index))));
1793     }
1794 
1795     /**
1796      * @dev Return the entire set in an array
1797      *
1798      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1799      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1800      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1801      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1802      */
1803     function values(AddressSet storage set) internal view returns (address[] memory) {
1804         bytes32[] memory store = _values(set._inner);
1805         address[] memory result;
1806 
1807         assembly {
1808             result := store
1809         }
1810 
1811         return result;
1812     }
1813 
1814     // UintSet
1815 
1816     struct UintSet {
1817         Set _inner;
1818     }
1819 
1820     /**
1821      * @dev Add a value to a set. O(1).
1822      *
1823      * Returns true if the value was added to the set, that is if it was not
1824      * already present.
1825      */
1826     function add(UintSet storage set, uint256 value) internal returns (bool) {
1827         return _add(set._inner, bytes32(value));
1828     }
1829 
1830     /**
1831      * @dev Removes a value from a set. O(1).
1832      *
1833      * Returns true if the value was removed from the set, that is if it was
1834      * present.
1835      */
1836     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1837         return _remove(set._inner, bytes32(value));
1838     }
1839 
1840     /**
1841      * @dev Returns true if the value is in the set. O(1).
1842      */
1843     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1844         return _contains(set._inner, bytes32(value));
1845     }
1846 
1847     /**
1848      * @dev Returns the number of values on the set. O(1).
1849      */
1850     function length(UintSet storage set) internal view returns (uint256) {
1851         return _length(set._inner);
1852     }
1853 
1854     /**
1855      * @dev Returns the value stored at position `index` in the set. O(1).
1856      *
1857      * Note that there are no guarantees on the ordering of values inside the
1858      * array, and it may change when more values are added or removed.
1859      *
1860      * Requirements:
1861      *
1862      * - `index` must be strictly less than {length}.
1863      */
1864     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1865         return uint256(_at(set._inner, index));
1866     }
1867 
1868     /**
1869      * @dev Return the entire set in an array
1870      *
1871      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1872      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1873      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1874      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1875      */
1876     function values(UintSet storage set) internal view returns (uint256[] memory) {
1877         bytes32[] memory store = _values(set._inner);
1878         uint256[] memory result;
1879 
1880         assembly {
1881             result := store
1882         }
1883 
1884         return result;
1885     }
1886 }
1887 
1888 
1889 /**
1890  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1891  */
1892 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1893     using EnumerableSet for EnumerableSet.AddressSet;
1894 
1895     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1896 
1897     /**
1898      * @dev See {IERC165-supportsInterface}.
1899      */
1900     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1901         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
1902     }
1903 
1904     /**
1905      * @dev Returns one of the accounts that have `role`. `index` must be a
1906      * value between 0 and {getRoleMemberCount}, non-inclusive.
1907      *
1908      * Role bearers are not sorted in any particular way, and their ordering may
1909      * change at any point.
1910      *
1911      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1912      * you perform all queries on the same block. See the following
1913      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1914      * for more information.
1915      */
1916     function getRoleMember(bytes32 role, uint256 index) public view override returns (address) {
1917         return _roleMembers[role].at(index);
1918     }
1919 
1920     /**
1921      * @dev Returns the number of accounts that have `role`. Can be used
1922      * together with {getRoleMember} to enumerate all bearers of a role.
1923      */
1924     function getRoleMemberCount(bytes32 role) public view override returns (uint256) {
1925         return _roleMembers[role].length();
1926     }
1927 
1928     /**
1929      * @dev Overload {grantRole} to track enumerable memberships
1930      */
1931     function grantRole(bytes32 role, address account) public virtual override(AccessControl, IAccessControl) {
1932         super.grantRole(role, account);
1933         _roleMembers[role].add(account);
1934     }
1935 
1936     /**
1937      * @dev Overload {revokeRole} to track enumerable memberships
1938      */
1939     function revokeRole(bytes32 role, address account) public virtual override(AccessControl, IAccessControl) {
1940         super.revokeRole(role, account);
1941         _roleMembers[role].remove(account);
1942     }
1943 
1944     /**
1945      * @dev Overload {renounceRole} to track enumerable memberships
1946      */
1947     function renounceRole(bytes32 role, address account) public virtual override(AccessControl, IAccessControl) {
1948         super.renounceRole(role, account);
1949         _roleMembers[role].remove(account);
1950     }
1951 
1952     /**
1953      * @dev Overload {_setupRole} to track enumerable memberships
1954      */
1955     function _setupRole(bytes32 role, address account) internal virtual override {
1956         super._setupRole(role, account);
1957         _roleMembers[role].add(account);
1958     }
1959 }
1960 
1961 
1962 // OpenZeppelin Contracts v4.3.2 (access/Ownable.sol)
1963 
1964 
1965 
1966 
1967 
1968 /**
1969  * @dev Contract module which provides a basic access control mechanism, where
1970  * there is an account (an owner) that can be granted exclusive access to
1971  * specific functions.
1972  *
1973  * By default, the owner account will be the one that deploys the contract. This
1974  * can later be changed with {transferOwnership}.
1975  *
1976  * This module is used through inheritance. It will make available the modifier
1977  * `onlyOwner`, which can be applied to your functions to restrict their use to
1978  * the owner.
1979  */
1980 abstract contract Ownable is Context {
1981     address private _owner;
1982 
1983     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1984 
1985     /**
1986      * @dev Initializes the contract setting the deployer as the initial owner.
1987      */
1988     constructor() {
1989         _transferOwnership(_msgSender());
1990     }
1991 
1992     /**
1993      * @dev Returns the address of the current owner.
1994      */
1995     function owner() public view virtual returns (address) {
1996         return _owner;
1997     }
1998 
1999     /**
2000      * @dev Throws if called by any account other than the owner.
2001      */
2002     modifier onlyOwner() {
2003         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2004         _;
2005     }
2006 
2007     /**
2008      * @dev Leaves the contract without owner. It will not be possible to call
2009      * `onlyOwner` functions anymore. Can only be called by the current owner.
2010      *
2011      * NOTE: Renouncing ownership will leave the contract without an owner,
2012      * thereby removing any functionality that is only available to the owner.
2013      */
2014     function renounceOwnership() public virtual onlyOwner {
2015         _transferOwnership(address(0));
2016     }
2017 
2018     /**
2019      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2020      * Can only be called by the current owner.
2021      */
2022     function transferOwnership(address newOwner) public virtual onlyOwner {
2023         require(newOwner != address(0), "Ownable: new owner is the zero address");
2024         _transferOwnership(newOwner);
2025     }
2026 
2027     /**
2028      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2029      * Internal function without access restriction.
2030      */
2031     function _transferOwnership(address newOwner) internal virtual {
2032         address oldOwner = _owner;
2033         _owner = newOwner;
2034         emit OwnershipTransferred(oldOwner, newOwner);
2035     }
2036 }
2037 
2038 
2039 
2040 // OpenZeppelin Contracts v4.3.2 (utils/cryptography/MerkleProof.sol)
2041 
2042 
2043 
2044 /**
2045  * @dev These functions deal with verification of Merkle Trees proofs.
2046  *
2047  * The proofs can be generated using the JavaScript library
2048  * https://github.com/miguelmota/merkletreejs[merkletreejs].
2049  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
2050  *
2051  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
2052  */
2053 library MerkleProof {
2054     /**
2055      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
2056      * defined by `root`. For this, a `proof` must be provided, containing
2057      * sibling hashes on the branch from the leaf to the root of the tree. Each
2058      * pair of leaves and each pair of pre-images are assumed to be sorted.
2059      */
2060     function verify(
2061         bytes32[] memory proof,
2062         bytes32 root,
2063         bytes32 leaf
2064     ) internal pure returns (bool) {
2065         return processProof(proof, leaf) == root;
2066     }
2067 
2068     /**
2069      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
2070      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
2071      * hash matches the root of the tree. When processing the proof, the pairs
2072      * of leafs & pre-images are assumed to be sorted.
2073      *
2074      * _Available since v4.4._
2075      */
2076     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
2077         bytes32 computedHash = leaf;
2078         for (uint256 i = 0; i < proof.length; i++) {
2079             bytes32 proofElement = proof[i];
2080             if (computedHash <= proofElement) {
2081                 // Hash(current computed hash + current element of the proof)
2082                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
2083             } else {
2084                 // Hash(current element of the proof + current computed hash)
2085                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
2086             }
2087         }
2088         return computedHash;
2089     }
2090 }
2091 
2092 
2093 contract Logarithms is Context, AccessControlEnumerable, ERC721, ERC721Enumerable, Ownable {
2094 
2095   string constant base_uri_head = "https://logarithms.art/metadata/";
2096   string constant base_uri_tail = ".json";
2097 
2098   uint constant public maxTotalSupply = 2500;
2099   uint constant public teamSupply = 125;
2100   uint constant public publicSupply = maxTotalSupply - teamSupply;
2101   uint constant public maxPerCall = 20;
2102   uint constant public whiteListMax = 2;
2103 
2104   uint public pricePerToken = 0.05 ether;
2105   uint public tokensMinted = 0;
2106   uint public tokensBurned = 0;
2107   bool public teamTokensMinted = false;
2108   bool public tradeActive = false;
2109 
2110   enum SaleState{ CLOSED, PRIVATE, PUBLIC }
2111   SaleState public saleState = SaleState.CLOSED;
2112 
2113   bytes32 private merkleRoot;
2114 
2115   constructor() ERC721("Logarithms", "Log") {
2116     _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
2117   }
2118 
2119   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) public override {
2120     require(tradeActive, "Trade is not active");
2121     super.safeTransferFrom(_from, _to, _tokenId, data);
2122   }
2123 
2124   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public override {
2125     require(tradeActive, "Trade is not active");
2126     super.safeTransferFrom(_from, _to, _tokenId);
2127   }
2128 
2129   function transferFrom(address _from, address _to, uint256 _tokenId) public override {
2130     require(tradeActive, "Trade is not active");
2131     super.transferFrom(_from, _to, _tokenId);
2132   }
2133 
2134   function setTradeState(bool tradeState) public {
2135     require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Cannot set trade state");
2136     tradeActive = tradeState;
2137   }
2138 
2139   function setPrice(uint newPrice) public {
2140     require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Cannot set price");
2141     pricePerToken = newPrice;
2142   }
2143 
2144   function mintTeamTokens() public {
2145     require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Cannot mint team tokens");
2146     require(!teamTokensMinted, "Team tokens have already been minted");
2147     for (uint i = 0; i < teamSupply; i++) {
2148       _mint(owner(), tokensMinted+1);
2149       tokensMinted += 1;
2150     }
2151     teamTokensMinted = true;
2152   }
2153 
2154   function setSaleState(SaleState newState) public {
2155     require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Cannot alter sale state");
2156     saleState = newState;
2157   }
2158 
2159   function setMerkleRoot(bytes32 newRoot) public {
2160     require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Cannot set merkle root");
2161     merkleRoot = newRoot;
2162   }
2163 
2164   function withdraw() public {
2165     require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Cannot withdraw");
2166     payable(owner()).call{value: address(this).balance}("");
2167   }
2168 
2169   function mint(uint amount, bytes32[] calldata proof, uint freeAmount) public payable {
2170     require(amount > 0, "Minting 0 tokens is quite useless");
2171     require(amount <= maxPerCall, "Amount is higher than maximum per call");
2172     require (saleState != SaleState.CLOSED, "Sale is closed");
2173 
2174     if (saleState == SaleState.PRIVATE) {
2175       bytes32 userLeaf = keccak256(abi.encodePacked(msg.sender, freeAmount));
2176       require(MerkleProof.verify(proof, merkleRoot, userLeaf), "Provided data is not correct");
2177       require(amount + balanceOf(msg.sender) <= freeAmount + whiteListMax, "Amount is higher than allowed");
2178       if (freeAmount > balanceOf(msg.sender)) {
2179         freeAmount -= balanceOf(msg.sender);
2180         if (freeAmount > amount) {
2181           freeAmount = amount;
2182         }
2183       } else {
2184         freeAmount = 0;
2185       }
2186       if (freeAmount + tokensMinted > _availableSupply()) {
2187         freeAmount = _availableSupply() - tokensMinted;
2188       }
2189       for (uint i = 0; i < freeAmount; i++) {
2190         _mint(_msgSender(), tokensMinted+1);
2191         tokensMinted += 1;
2192       }
2193       amount -= freeAmount;
2194     }
2195 
2196     if (amount + tokensMinted > _availableSupply()) {
2197       amount = _availableSupply() - tokensMinted;
2198     }
2199     uint amountToPay = amount * pricePerToken;
2200     require(amountToPay <= msg.value, "Provided not enough Ether for purchase");
2201     for (uint i = 0; i < amount; i++) {
2202       _mint(_msgSender(), tokensMinted+1);
2203       tokensMinted += 1;
2204     }
2205     if (msg.value > amountToPay) {
2206       payable(_msgSender()).call{value: msg.value - amountToPay}("");
2207     }
2208   }
2209 
2210   function burnMany(uint256[] calldata tokenIds) public {
2211     require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Caller cannot burn");
2212     for (uint i; i < tokenIds.length; i++) {
2213       _burn(tokenIds[i]);
2214     }
2215     tokensBurned += tokenIds.length;
2216   }
2217 
2218   function _availableSupply() private view returns(uint) {
2219     if (teamTokensMinted) {
2220       return maxTotalSupply;
2221     } else {
2222       return publicSupply;
2223     }
2224   }
2225 
2226   function tokenURI(uint256 _tokenId) public pure override returns (string memory) {
2227     return string(abi.encodePacked(base_uri_head, Strings.toString(_tokenId), base_uri_tail));
2228   }
2229 
2230   /** * @dev See {IERC165-supportsInterface}.  */
2231     function supportsInterface(bytes4 interfaceId) public view virtual
2232   override(ERC721, ERC721Enumerable, AccessControlEnumerable) returns (bool)
2233   {
2234     return super.supportsInterface(interfaceId);
2235   }
2236 
2237   function _beforeTokenTransfer( address from, address to, uint256 tokenId) internal virtual override(ERC721, ERC721Enumerable) {
2238     super._beforeTokenTransfer(from, to, tokenId);
2239   }
2240 
2241 }