1 // File: @openzeppelin/contracts/access/IAccessControl.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev External interface of AccessControl declared to support ERC165 detection.
10  */
11 interface IAccessControl {
12     /**
13      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
14      *
15      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
16      * {RoleAdminChanged} not being emitted signaling this.
17      *
18      * _Available since v3.1._
19      */
20     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
21 
22     /**
23      * @dev Emitted when `account` is granted `role`.
24      *
25      * `sender` is the account that originated the contract call, an admin role
26      * bearer except when using {AccessControl-_setupRole}.
27      */
28     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
29 
30     /**
31      * @dev Emitted when `account` is revoked `role`.
32      *
33      * `sender` is the account that originated the contract call:
34      *   - if using `revokeRole`, it is the admin role bearer
35      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
36      */
37     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
38 
39     /**
40      * @dev Returns `true` if `account` has been granted `role`.
41      */
42     function hasRole(bytes32 role, address account) external view returns (bool);
43 
44     /**
45      * @dev Returns the admin role that controls `role`. See {grantRole} and
46      * {revokeRole}.
47      *
48      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
49      */
50     function getRoleAdmin(bytes32 role) external view returns (bytes32);
51 
52     /**
53      * @dev Grants `role` to `account`.
54      *
55      * If `account` had not been already granted `role`, emits a {RoleGranted}
56      * event.
57      *
58      * Requirements:
59      *
60      * - the caller must have ``role``'s admin role.
61      */
62     function grantRole(bytes32 role, address account) external;
63 
64     /**
65      * @dev Revokes `role` from `account`.
66      *
67      * If `account` had been granted `role`, emits a {RoleRevoked} event.
68      *
69      * Requirements:
70      *
71      * - the caller must have ``role``'s admin role.
72      */
73     function revokeRole(bytes32 role, address account) external;
74 
75     /**
76      * @dev Revokes `role` from the calling account.
77      *
78      * Roles are often managed via {grantRole} and {revokeRole}: this function's
79      * purpose is to provide a mechanism for accounts to lose their privileges
80      * if they are compromised (such as when a trusted device is misplaced).
81      *
82      * If the calling account had been granted `role`, emits a {RoleRevoked}
83      * event.
84      *
85      * Requirements:
86      *
87      * - the caller must be `account`.
88      */
89     function renounceRole(bytes32 role, address account) external;
90 }
91 
92 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
93 
94 
95 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
96 
97 pragma solidity ^0.8.0;
98 
99 /**
100  * @dev These functions deal with verification of Merkle Trees proofs.
101  *
102  * The proofs can be generated using the JavaScript library
103  * https://github.com/miguelmota/merkletreejs[merkletreejs].
104  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
105  *
106  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
107  *
108  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
109  * hashing, or use a hash function other than keccak256 for hashing leaves.
110  * This is because the concatenation of a sorted pair of internal nodes in
111  * the merkle tree could be reinterpreted as a leaf value.
112  */
113 library MerkleProof {
114     /**
115      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
116      * defined by `root`. For this, a `proof` must be provided, containing
117      * sibling hashes on the branch from the leaf to the root of the tree. Each
118      * pair of leaves and each pair of pre-images are assumed to be sorted.
119      */
120     function verify(
121         bytes32[] memory proof,
122         bytes32 root,
123         bytes32 leaf
124     ) internal pure returns (bool) {
125         return processProof(proof, leaf) == root;
126     }
127 
128     /**
129      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
130      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
131      * hash matches the root of the tree. When processing the proof, the pairs
132      * of leafs & pre-images are assumed to be sorted.
133      *
134      * _Available since v4.4._
135      */
136     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
137         bytes32 computedHash = leaf;
138         for (uint256 i = 0; i < proof.length; i++) {
139             bytes32 proofElement = proof[i];
140             if (computedHash <= proofElement) {
141                 // Hash(current computed hash + current element of the proof)
142                 computedHash = _efficientHash(computedHash, proofElement);
143             } else {
144                 // Hash(current element of the proof + current computed hash)
145                 computedHash = _efficientHash(proofElement, computedHash);
146             }
147         }
148         return computedHash;
149     }
150 
151     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
152         assembly {
153             mstore(0x00, a)
154             mstore(0x20, b)
155             value := keccak256(0x00, 0x40)
156         }
157     }
158 }
159 
160 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
161 
162 
163 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
164 
165 pragma solidity ^0.8.0;
166 
167 /**
168  * @dev Contract module that helps prevent reentrant calls to a function.
169  *
170  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
171  * available, which can be applied to functions to make sure there are no nested
172  * (reentrant) calls to them.
173  *
174  * Note that because there is a single `nonReentrant` guard, functions marked as
175  * `nonReentrant` may not call one another. This can be worked around by making
176  * those functions `private`, and then adding `external` `nonReentrant` entry
177  * points to them.
178  *
179  * TIP: If you would like to learn more about reentrancy and alternative ways
180  * to protect against it, check out our blog post
181  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
182  */
183 abstract contract ReentrancyGuard {
184     // Booleans are more expensive than uint256 or any type that takes up a full
185     // word because each write operation emits an extra SLOAD to first read the
186     // slot's contents, replace the bits taken up by the boolean, and then write
187     // back. This is the compiler's defense against contract upgrades and
188     // pointer aliasing, and it cannot be disabled.
189 
190     // The values being non-zero value makes deployment a bit more expensive,
191     // but in exchange the refund on every call to nonReentrant will be lower in
192     // amount. Since refunds are capped to a percentage of the total
193     // transaction's gas, it is best to keep them low in cases like this one, to
194     // increase the likelihood of the full refund coming into effect.
195     uint256 private constant _NOT_ENTERED = 1;
196     uint256 private constant _ENTERED = 2;
197 
198     uint256 private _status;
199 
200     constructor() {
201         _status = _NOT_ENTERED;
202     }
203 
204     /**
205      * @dev Prevents a contract from calling itself, directly or indirectly.
206      * Calling a `nonReentrant` function from another `nonReentrant`
207      * function is not supported. It is possible to prevent this from happening
208      * by making the `nonReentrant` function external, and making it call a
209      * `private` function that does the actual work.
210      */
211     modifier nonReentrant() {
212         // On the first call to nonReentrant, _notEntered will be true
213         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
214 
215         // Any calls to nonReentrant after this point will fail
216         _status = _ENTERED;
217 
218         _;
219 
220         // By storing the original value once again, a refund is triggered (see
221         // https://eips.ethereum.org/EIPS/eip-2200)
222         _status = _NOT_ENTERED;
223     }
224 }
225 
226 // File: @openzeppelin/contracts/utils/Strings.sol
227 
228 
229 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @dev String operations.
235  */
236 library Strings {
237     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
238 
239     /**
240      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
241      */
242     function toString(uint256 value) internal pure returns (string memory) {
243         // Inspired by OraclizeAPI's implementation - MIT licence
244         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
245 
246         if (value == 0) {
247             return "0";
248         }
249         uint256 temp = value;
250         uint256 digits;
251         while (temp != 0) {
252             digits++;
253             temp /= 10;
254         }
255         bytes memory buffer = new bytes(digits);
256         while (value != 0) {
257             digits -= 1;
258             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
259             value /= 10;
260         }
261         return string(buffer);
262     }
263 
264     /**
265      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
266      */
267     function toHexString(uint256 value) internal pure returns (string memory) {
268         if (value == 0) {
269             return "0x00";
270         }
271         uint256 temp = value;
272         uint256 length = 0;
273         while (temp != 0) {
274             length++;
275             temp >>= 8;
276         }
277         return toHexString(value, length);
278     }
279 
280     /**
281      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
282      */
283     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
284         bytes memory buffer = new bytes(2 * length + 2);
285         buffer[0] = "0";
286         buffer[1] = "x";
287         for (uint256 i = 2 * length + 1; i > 1; --i) {
288             buffer[i] = _HEX_SYMBOLS[value & 0xf];
289             value >>= 4;
290         }
291         require(value == 0, "Strings: hex length insufficient");
292         return string(buffer);
293     }
294 }
295 
296 // File: @openzeppelin/contracts/utils/Context.sol
297 
298 
299 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
300 
301 pragma solidity ^0.8.0;
302 
303 /**
304  * @dev Provides information about the current execution context, including the
305  * sender of the transaction and its data. While these are generally available
306  * via msg.sender and msg.data, they should not be accessed in such a direct
307  * manner, since when dealing with meta-transactions the account sending and
308  * paying for execution may not be the actual sender (as far as an application
309  * is concerned).
310  *
311  * This contract is only required for intermediate, library-like contracts.
312  */
313 abstract contract Context {
314     function _msgSender() internal view virtual returns (address) {
315         return msg.sender;
316     }
317 
318     function _msgData() internal view virtual returns (bytes calldata) {
319         return msg.data;
320     }
321 }
322 
323 // File: @openzeppelin/contracts/utils/Address.sol
324 
325 
326 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
327 
328 pragma solidity ^0.8.1;
329 
330 /**
331  * @dev Collection of functions related to the address type
332  */
333 library Address {
334     /**
335      * @dev Returns true if `account` is a contract.
336      *
337      * [IMPORTANT]
338      * ====
339      * It is unsafe to assume that an address for which this function returns
340      * false is an externally-owned account (EOA) and not a contract.
341      *
342      * Among others, `isContract` will return false for the following
343      * types of addresses:
344      *
345      *  - an externally-owned account
346      *  - a contract in construction
347      *  - an address where a contract will be created
348      *  - an address where a contract lived, but was destroyed
349      * ====
350      *
351      * [IMPORTANT]
352      * ====
353      * You shouldn't rely on `isContract` to protect against flash loan attacks!
354      *
355      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
356      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
357      * constructor.
358      * ====
359      */
360     function isContract(address account) internal view returns (bool) {
361         // This method relies on extcodesize/address.code.length, which returns 0
362         // for contracts in construction, since the code is only stored at the end
363         // of the constructor execution.
364 
365         return account.code.length > 0;
366     }
367 
368     /**
369      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
370      * `recipient`, forwarding all available gas and reverting on errors.
371      *
372      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
373      * of certain opcodes, possibly making contracts go over the 2300 gas limit
374      * imposed by `transfer`, making them unable to receive funds via
375      * `transfer`. {sendValue} removes this limitation.
376      *
377      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
378      *
379      * IMPORTANT: because control is transferred to `recipient`, care must be
380      * taken to not create reentrancy vulnerabilities. Consider using
381      * {ReentrancyGuard} or the
382      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
383      */
384     function sendValue(address payable recipient, uint256 amount) internal {
385         require(address(this).balance >= amount, "Address: insufficient balance");
386 
387         (bool success, ) = recipient.call{value: amount}("");
388         require(success, "Address: unable to send value, recipient may have reverted");
389     }
390 
391     /**
392      * @dev Performs a Solidity function call using a low level `call`. A
393      * plain `call` is an unsafe replacement for a function call: use this
394      * function instead.
395      *
396      * If `target` reverts with a revert reason, it is bubbled up by this
397      * function (like regular Solidity function calls).
398      *
399      * Returns the raw returned data. To convert to the expected return value,
400      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
401      *
402      * Requirements:
403      *
404      * - `target` must be a contract.
405      * - calling `target` with `data` must not revert.
406      *
407      * _Available since v3.1._
408      */
409     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
410         return functionCall(target, data, "Address: low-level call failed");
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
415      * `errorMessage` as a fallback revert reason when `target` reverts.
416      *
417      * _Available since v3.1._
418      */
419     function functionCall(
420         address target,
421         bytes memory data,
422         string memory errorMessage
423     ) internal returns (bytes memory) {
424         return functionCallWithValue(target, data, 0, errorMessage);
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
429      * but also transferring `value` wei to `target`.
430      *
431      * Requirements:
432      *
433      * - the calling contract must have an ETH balance of at least `value`.
434      * - the called Solidity function must be `payable`.
435      *
436      * _Available since v3.1._
437      */
438     function functionCallWithValue(
439         address target,
440         bytes memory data,
441         uint256 value
442     ) internal returns (bytes memory) {
443         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
448      * with `errorMessage` as a fallback revert reason when `target` reverts.
449      *
450      * _Available since v3.1._
451      */
452     function functionCallWithValue(
453         address target,
454         bytes memory data,
455         uint256 value,
456         string memory errorMessage
457     ) internal returns (bytes memory) {
458         require(address(this).balance >= value, "Address: insufficient balance for call");
459         require(isContract(target), "Address: call to non-contract");
460 
461         (bool success, bytes memory returndata) = target.call{value: value}(data);
462         return verifyCallResult(success, returndata, errorMessage);
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
467      * but performing a static call.
468      *
469      * _Available since v3.3._
470      */
471     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
472         return functionStaticCall(target, data, "Address: low-level static call failed");
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
477      * but performing a static call.
478      *
479      * _Available since v3.3._
480      */
481     function functionStaticCall(
482         address target,
483         bytes memory data,
484         string memory errorMessage
485     ) internal view returns (bytes memory) {
486         require(isContract(target), "Address: static call to non-contract");
487 
488         (bool success, bytes memory returndata) = target.staticcall(data);
489         return verifyCallResult(success, returndata, errorMessage);
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
494      * but performing a delegate call.
495      *
496      * _Available since v3.4._
497      */
498     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
499         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
504      * but performing a delegate call.
505      *
506      * _Available since v3.4._
507      */
508     function functionDelegateCall(
509         address target,
510         bytes memory data,
511         string memory errorMessage
512     ) internal returns (bytes memory) {
513         require(isContract(target), "Address: delegate call to non-contract");
514 
515         (bool success, bytes memory returndata) = target.delegatecall(data);
516         return verifyCallResult(success, returndata, errorMessage);
517     }
518 
519     /**
520      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
521      * revert reason using the provided one.
522      *
523      * _Available since v4.3._
524      */
525     function verifyCallResult(
526         bool success,
527         bytes memory returndata,
528         string memory errorMessage
529     ) internal pure returns (bytes memory) {
530         if (success) {
531             return returndata;
532         } else {
533             // Look for revert reason and bubble it up if present
534             if (returndata.length > 0) {
535                 // The easiest way to bubble the revert reason is using memory via assembly
536 
537                 assembly {
538                     let returndata_size := mload(returndata)
539                     revert(add(32, returndata), returndata_size)
540                 }
541             } else {
542                 revert(errorMessage);
543             }
544         }
545     }
546 }
547 
548 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
549 
550 
551 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
552 
553 pragma solidity ^0.8.0;
554 
555 /**
556  * @title ERC721 token receiver interface
557  * @dev Interface for any contract that wants to support safeTransfers
558  * from ERC721 asset contracts.
559  */
560 interface IERC721Receiver {
561     /**
562      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
563      * by `operator` from `from`, this function is called.
564      *
565      * It must return its Solidity selector to confirm the token transfer.
566      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
567      *
568      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
569      */
570     function onERC721Received(
571         address operator,
572         address from,
573         uint256 tokenId,
574         bytes calldata data
575     ) external returns (bytes4);
576 }
577 
578 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
579 
580 
581 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
582 
583 pragma solidity ^0.8.0;
584 
585 /**
586  * @dev Interface of the ERC165 standard, as defined in the
587  * https://eips.ethereum.org/EIPS/eip-165[EIP].
588  *
589  * Implementers can declare support of contract interfaces, which can then be
590  * queried by others ({ERC165Checker}).
591  *
592  * For an implementation, see {ERC165}.
593  */
594 interface IERC165 {
595     /**
596      * @dev Returns true if this contract implements the interface defined by
597      * `interfaceId`. See the corresponding
598      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
599      * to learn more about how these ids are created.
600      *
601      * This function call must use less than 30 000 gas.
602      */
603     function supportsInterface(bytes4 interfaceId) external view returns (bool);
604 }
605 
606 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
607 
608 
609 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
610 
611 pragma solidity ^0.8.0;
612 
613 
614 /**
615  * @dev Implementation of the {IERC165} interface.
616  *
617  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
618  * for the additional interface id that will be supported. For example:
619  *
620  * ```solidity
621  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
622  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
623  * }
624  * ```
625  *
626  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
627  */
628 abstract contract ERC165 is IERC165 {
629     /**
630      * @dev See {IERC165-supportsInterface}.
631      */
632     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
633         return interfaceId == type(IERC165).interfaceId;
634     }
635 }
636 
637 // File: @openzeppelin/contracts/access/AccessControl.sol
638 
639 
640 // OpenZeppelin Contracts (last updated v4.6.0) (access/AccessControl.sol)
641 
642 pragma solidity ^0.8.0;
643 
644 
645 
646 
647 
648 /**
649  * @dev Contract module that allows children to implement role-based access
650  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
651  * members except through off-chain means by accessing the contract event logs. Some
652  * applications may benefit from on-chain enumerability, for those cases see
653  * {AccessControlEnumerable}.
654  *
655  * Roles are referred to by their `bytes32` identifier. These should be exposed
656  * in the external API and be unique. The best way to achieve this is by
657  * using `public constant` hash digests:
658  *
659  * ```
660  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
661  * ```
662  *
663  * Roles can be used to represent a set of permissions. To restrict access to a
664  * function call, use {hasRole}:
665  *
666  * ```
667  * function foo() public {
668  *     require(hasRole(MY_ROLE, msg.sender));
669  *     ...
670  * }
671  * ```
672  *
673  * Roles can be granted and revoked dynamically via the {grantRole} and
674  * {revokeRole} functions. Each role has an associated admin role, and only
675  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
676  *
677  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
678  * that only accounts with this role will be able to grant or revoke other
679  * roles. More complex role relationships can be created by using
680  * {_setRoleAdmin}.
681  *
682  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
683  * grant and revoke this role. Extra precautions should be taken to secure
684  * accounts that have been granted it.
685  */
686 abstract contract AccessControl is Context, IAccessControl, ERC165 {
687     struct RoleData {
688         mapping(address => bool) members;
689         bytes32 adminRole;
690     }
691 
692     mapping(bytes32 => RoleData) private _roles;
693 
694     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
695 
696     /**
697      * @dev Modifier that checks that an account has a specific role. Reverts
698      * with a standardized message including the required role.
699      *
700      * The format of the revert reason is given by the following regular expression:
701      *
702      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
703      *
704      * _Available since v4.1._
705      */
706     modifier onlyRole(bytes32 role) {
707         _checkRole(role);
708         _;
709     }
710 
711     /**
712      * @dev See {IERC165-supportsInterface}.
713      */
714     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
715         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
716     }
717 
718     /**
719      * @dev Returns `true` if `account` has been granted `role`.
720      */
721     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
722         return _roles[role].members[account];
723     }
724 
725     /**
726      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
727      * Overriding this function changes the behavior of the {onlyRole} modifier.
728      *
729      * Format of the revert message is described in {_checkRole}.
730      *
731      * _Available since v4.6._
732      */
733     function _checkRole(bytes32 role) internal view virtual {
734         _checkRole(role, _msgSender());
735     }
736 
737     /**
738      * @dev Revert with a standard message if `account` is missing `role`.
739      *
740      * The format of the revert reason is given by the following regular expression:
741      *
742      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
743      */
744     function _checkRole(bytes32 role, address account) internal view virtual {
745         if (!hasRole(role, account)) {
746             revert(
747                 string(
748                     abi.encodePacked(
749                         "AccessControl: account ",
750                         Strings.toHexString(uint160(account), 20),
751                         " is missing role ",
752                         Strings.toHexString(uint256(role), 32)
753                     )
754                 )
755             );
756         }
757     }
758 
759     /**
760      * @dev Returns the admin role that controls `role`. See {grantRole} and
761      * {revokeRole}.
762      *
763      * To change a role's admin, use {_setRoleAdmin}.
764      */
765     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
766         return _roles[role].adminRole;
767     }
768 
769     /**
770      * @dev Grants `role` to `account`.
771      *
772      * If `account` had not been already granted `role`, emits a {RoleGranted}
773      * event.
774      *
775      * Requirements:
776      *
777      * - the caller must have ``role``'s admin role.
778      */
779     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
780         _grantRole(role, account);
781     }
782 
783     /**
784      * @dev Revokes `role` from `account`.
785      *
786      * If `account` had been granted `role`, emits a {RoleRevoked} event.
787      *
788      * Requirements:
789      *
790      * - the caller must have ``role``'s admin role.
791      */
792     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
793         _revokeRole(role, account);
794     }
795 
796     /**
797      * @dev Revokes `role` from the calling account.
798      *
799      * Roles are often managed via {grantRole} and {revokeRole}: this function's
800      * purpose is to provide a mechanism for accounts to lose their privileges
801      * if they are compromised (such as when a trusted device is misplaced).
802      *
803      * If the calling account had been revoked `role`, emits a {RoleRevoked}
804      * event.
805      *
806      * Requirements:
807      *
808      * - the caller must be `account`.
809      */
810     function renounceRole(bytes32 role, address account) public virtual override {
811         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
812 
813         _revokeRole(role, account);
814     }
815 
816     /**
817      * @dev Grants `role` to `account`.
818      *
819      * If `account` had not been already granted `role`, emits a {RoleGranted}
820      * event. Note that unlike {grantRole}, this function doesn't perform any
821      * checks on the calling account.
822      *
823      * [WARNING]
824      * ====
825      * This function should only be called from the constructor when setting
826      * up the initial roles for the system.
827      *
828      * Using this function in any other way is effectively circumventing the admin
829      * system imposed by {AccessControl}.
830      * ====
831      *
832      * NOTE: This function is deprecated in favor of {_grantRole}.
833      */
834     function _setupRole(bytes32 role, address account) internal virtual {
835         _grantRole(role, account);
836     }
837 
838     /**
839      * @dev Sets `adminRole` as ``role``'s admin role.
840      *
841      * Emits a {RoleAdminChanged} event.
842      */
843     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
844         bytes32 previousAdminRole = getRoleAdmin(role);
845         _roles[role].adminRole = adminRole;
846         emit RoleAdminChanged(role, previousAdminRole, adminRole);
847     }
848 
849     /**
850      * @dev Grants `role` to `account`.
851      *
852      * Internal function without access restriction.
853      */
854     function _grantRole(bytes32 role, address account) internal virtual {
855         if (!hasRole(role, account)) {
856             _roles[role].members[account] = true;
857             emit RoleGranted(role, account, _msgSender());
858         }
859     }
860 
861     /**
862      * @dev Revokes `role` from `account`.
863      *
864      * Internal function without access restriction.
865      */
866     function _revokeRole(bytes32 role, address account) internal virtual {
867         if (hasRole(role, account)) {
868             _roles[role].members[account] = false;
869             emit RoleRevoked(role, account, _msgSender());
870         }
871     }
872 }
873 
874 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
875 
876 
877 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
878 
879 pragma solidity ^0.8.0;
880 
881 
882 /**
883  * @dev Required interface of an ERC721 compliant contract.
884  */
885 interface IERC721 is IERC165 {
886     /**
887      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
888      */
889     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
890 
891     /**
892      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
893      */
894     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
895 
896     /**
897      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
898      */
899     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
900 
901     /**
902      * @dev Returns the number of tokens in ``owner``'s account.
903      */
904     function balanceOf(address owner) external view returns (uint256 balance);
905 
906     /**
907      * @dev Returns the owner of the `tokenId` token.
908      *
909      * Requirements:
910      *
911      * - `tokenId` must exist.
912      */
913     function ownerOf(uint256 tokenId) external view returns (address owner);
914 
915     /**
916      * @dev Safely transfers `tokenId` token from `from` to `to`.
917      *
918      * Requirements:
919      *
920      * - `from` cannot be the zero address.
921      * - `to` cannot be the zero address.
922      * - `tokenId` token must exist and be owned by `from`.
923      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
924      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
925      *
926      * Emits a {Transfer} event.
927      */
928     function safeTransferFrom(
929         address from,
930         address to,
931         uint256 tokenId,
932         bytes calldata data
933     ) external;
934 
935     /**
936      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
937      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
938      *
939      * Requirements:
940      *
941      * - `from` cannot be the zero address.
942      * - `to` cannot be the zero address.
943      * - `tokenId` token must exist and be owned by `from`.
944      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
945      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
946      *
947      * Emits a {Transfer} event.
948      */
949     function safeTransferFrom(
950         address from,
951         address to,
952         uint256 tokenId
953     ) external;
954 
955     /**
956      * @dev Transfers `tokenId` token from `from` to `to`.
957      *
958      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
959      *
960      * Requirements:
961      *
962      * - `from` cannot be the zero address.
963      * - `to` cannot be the zero address.
964      * - `tokenId` token must be owned by `from`.
965      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
966      *
967      * Emits a {Transfer} event.
968      */
969     function transferFrom(
970         address from,
971         address to,
972         uint256 tokenId
973     ) external;
974 
975     /**
976      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
977      * The approval is cleared when the token is transferred.
978      *
979      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
980      *
981      * Requirements:
982      *
983      * - The caller must own the token or be an approved operator.
984      * - `tokenId` must exist.
985      *
986      * Emits an {Approval} event.
987      */
988     function approve(address to, uint256 tokenId) external;
989 
990     /**
991      * @dev Approve or remove `operator` as an operator for the caller.
992      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
993      *
994      * Requirements:
995      *
996      * - The `operator` cannot be the caller.
997      *
998      * Emits an {ApprovalForAll} event.
999      */
1000     function setApprovalForAll(address operator, bool _approved) external;
1001 
1002     /**
1003      * @dev Returns the account approved for `tokenId` token.
1004      *
1005      * Requirements:
1006      *
1007      * - `tokenId` must exist.
1008      */
1009     function getApproved(uint256 tokenId) external view returns (address operator);
1010 
1011     /**
1012      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1013      *
1014      * See {setApprovalForAll}
1015      */
1016     function isApprovedForAll(address owner, address operator) external view returns (bool);
1017 }
1018 
1019 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1020 
1021 
1022 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1023 
1024 pragma solidity ^0.8.0;
1025 
1026 
1027 /**
1028  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1029  * @dev See https://eips.ethereum.org/EIPS/eip-721
1030  */
1031 interface IERC721Metadata is IERC721 {
1032     /**
1033      * @dev Returns the token collection name.
1034      */
1035     function name() external view returns (string memory);
1036 
1037     /**
1038      * @dev Returns the token collection symbol.
1039      */
1040     function symbol() external view returns (string memory);
1041 
1042     /**
1043      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1044      */
1045     function tokenURI(uint256 tokenId) external view returns (string memory);
1046 }
1047 
1048 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1049 
1050 
1051 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1052 
1053 pragma solidity ^0.8.0;
1054 
1055 
1056 
1057 
1058 
1059 
1060 
1061 
1062 /**
1063  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1064  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1065  * {ERC721Enumerable}.
1066  */
1067 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1068     using Address for address;
1069     using Strings for uint256;
1070 
1071     // Token name
1072     string private _name;
1073 
1074     // Token symbol
1075     string private _symbol;
1076 
1077     // Mapping from token ID to owner address
1078     mapping(uint256 => address) private _owners;
1079 
1080     // Mapping owner address to token count
1081     mapping(address => uint256) private _balances;
1082 
1083     // Mapping from token ID to approved address
1084     mapping(uint256 => address) private _tokenApprovals;
1085 
1086     // Mapping from owner to operator approvals
1087     mapping(address => mapping(address => bool)) private _operatorApprovals;
1088 
1089     /**
1090      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1091      */
1092     constructor(string memory name_, string memory symbol_) {
1093         _name = name_;
1094         _symbol = symbol_;
1095     }
1096 
1097     /**
1098      * @dev See {IERC165-supportsInterface}.
1099      */
1100     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1101         return
1102             interfaceId == type(IERC721).interfaceId ||
1103             interfaceId == type(IERC721Metadata).interfaceId ||
1104             super.supportsInterface(interfaceId);
1105     }
1106 
1107     /**
1108      * @dev See {IERC721-balanceOf}.
1109      */
1110     function balanceOf(address owner) public view virtual override returns (uint256) {
1111         require(owner != address(0), "ERC721: balance query for the zero address");
1112         return _balances[owner];
1113     }
1114 
1115     /**
1116      * @dev See {IERC721-ownerOf}.
1117      */
1118     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1119         address owner = _owners[tokenId];
1120         require(owner != address(0), "ERC721: owner query for nonexistent token");
1121         return owner;
1122     }
1123 
1124     /**
1125      * @dev See {IERC721Metadata-name}.
1126      */
1127     function name() public view virtual override returns (string memory) {
1128         return _name;
1129     }
1130 
1131     /**
1132      * @dev See {IERC721Metadata-symbol}.
1133      */
1134     function symbol() public view virtual override returns (string memory) {
1135         return _symbol;
1136     }
1137 
1138     /**
1139      * @dev See {IERC721Metadata-tokenURI}.
1140      */
1141     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1142         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1143 
1144         string memory baseURI = _baseURI();
1145         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1146     }
1147 
1148     /**
1149      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1150      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1151      * by default, can be overridden in child contracts.
1152      */
1153     function _baseURI() internal view virtual returns (string memory) {
1154         return "";
1155     }
1156 
1157     /**
1158      * @dev See {IERC721-approve}.
1159      */
1160     function approve(address to, uint256 tokenId) public virtual override {
1161         address owner = ERC721.ownerOf(tokenId);
1162         require(to != owner, "ERC721: approval to current owner");
1163 
1164         require(
1165             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1166             "ERC721: approve caller is not owner nor approved for all"
1167         );
1168 
1169         _approve(to, tokenId);
1170     }
1171 
1172     /**
1173      * @dev See {IERC721-getApproved}.
1174      */
1175     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1176         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1177 
1178         return _tokenApprovals[tokenId];
1179     }
1180 
1181     /**
1182      * @dev See {IERC721-setApprovalForAll}.
1183      */
1184     function setApprovalForAll(address operator, bool approved) public virtual override {
1185         _setApprovalForAll(_msgSender(), operator, approved);
1186     }
1187 
1188     /**
1189      * @dev See {IERC721-isApprovedForAll}.
1190      */
1191     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1192         return _operatorApprovals[owner][operator];
1193     }
1194 
1195     /**
1196      * @dev See {IERC721-transferFrom}.
1197      */
1198     function transferFrom(
1199         address from,
1200         address to,
1201         uint256 tokenId
1202     ) public virtual override {
1203         //solhint-disable-next-line max-line-length
1204         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1205 
1206         _transfer(from, to, tokenId);
1207     }
1208 
1209     /**
1210      * @dev See {IERC721-safeTransferFrom}.
1211      */
1212     function safeTransferFrom(
1213         address from,
1214         address to,
1215         uint256 tokenId
1216     ) public virtual override {
1217         safeTransferFrom(from, to, tokenId, "");
1218     }
1219 
1220     /**
1221      * @dev See {IERC721-safeTransferFrom}.
1222      */
1223     function safeTransferFrom(
1224         address from,
1225         address to,
1226         uint256 tokenId,
1227         bytes memory _data
1228     ) public virtual override {
1229         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1230         _safeTransfer(from, to, tokenId, _data);
1231     }
1232 
1233     /**
1234      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1235      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1236      *
1237      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1238      *
1239      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1240      * implement alternative mechanisms to perform token transfer, such as signature-based.
1241      *
1242      * Requirements:
1243      *
1244      * - `from` cannot be the zero address.
1245      * - `to` cannot be the zero address.
1246      * - `tokenId` token must exist and be owned by `from`.
1247      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1248      *
1249      * Emits a {Transfer} event.
1250      */
1251     function _safeTransfer(
1252         address from,
1253         address to,
1254         uint256 tokenId,
1255         bytes memory _data
1256     ) internal virtual {
1257         _transfer(from, to, tokenId);
1258         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1259     }
1260 
1261     /**
1262      * @dev Returns whether `tokenId` exists.
1263      *
1264      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1265      *
1266      * Tokens start existing when they are minted (`_mint`),
1267      * and stop existing when they are burned (`_burn`).
1268      */
1269     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1270         return _owners[tokenId] != address(0);
1271     }
1272 
1273     /**
1274      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1275      *
1276      * Requirements:
1277      *
1278      * - `tokenId` must exist.
1279      */
1280     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1281         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1282         address owner = ERC721.ownerOf(tokenId);
1283         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1284     }
1285 
1286     /**
1287      * @dev Safely mints `tokenId` and transfers it to `to`.
1288      *
1289      * Requirements:
1290      *
1291      * - `tokenId` must not exist.
1292      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1293      *
1294      * Emits a {Transfer} event.
1295      */
1296     function _safeMint(address to, uint256 tokenId) internal virtual {
1297         _safeMint(to, tokenId, "");
1298     }
1299 
1300     /**
1301      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1302      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1303      */
1304     function _safeMint(
1305         address to,
1306         uint256 tokenId,
1307         bytes memory _data
1308     ) internal virtual {
1309         _mint(to, tokenId);
1310         require(
1311             _checkOnERC721Received(address(0), to, tokenId, _data),
1312             "ERC721: transfer to non ERC721Receiver implementer"
1313         );
1314     }
1315 
1316     /**
1317      * @dev Mints `tokenId` and transfers it to `to`.
1318      *
1319      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1320      *
1321      * Requirements:
1322      *
1323      * - `tokenId` must not exist.
1324      * - `to` cannot be the zero address.
1325      *
1326      * Emits a {Transfer} event.
1327      */
1328     function _mint(address to, uint256 tokenId) internal virtual {
1329         require(to != address(0), "ERC721: mint to the zero address");
1330         require(!_exists(tokenId), "ERC721: token already minted");
1331 
1332         _beforeTokenTransfer(address(0), to, tokenId);
1333 
1334         _balances[to] += 1;
1335         _owners[tokenId] = to;
1336 
1337         emit Transfer(address(0), to, tokenId);
1338 
1339         _afterTokenTransfer(address(0), to, tokenId);
1340     }
1341 
1342     /**
1343      * @dev Destroys `tokenId`.
1344      * The approval is cleared when the token is burned.
1345      *
1346      * Requirements:
1347      *
1348      * - `tokenId` must exist.
1349      *
1350      * Emits a {Transfer} event.
1351      */
1352     function _burn(uint256 tokenId) internal virtual {
1353         address owner = ERC721.ownerOf(tokenId);
1354 
1355         _beforeTokenTransfer(owner, address(0), tokenId);
1356 
1357         // Clear approvals
1358         _approve(address(0), tokenId);
1359 
1360         _balances[owner] -= 1;
1361         delete _owners[tokenId];
1362 
1363         emit Transfer(owner, address(0), tokenId);
1364 
1365         _afterTokenTransfer(owner, address(0), tokenId);
1366     }
1367 
1368     /**
1369      * @dev Transfers `tokenId` from `from` to `to`.
1370      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1371      *
1372      * Requirements:
1373      *
1374      * - `to` cannot be the zero address.
1375      * - `tokenId` token must be owned by `from`.
1376      *
1377      * Emits a {Transfer} event.
1378      */
1379     function _transfer(
1380         address from,
1381         address to,
1382         uint256 tokenId
1383     ) internal virtual {
1384         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1385         require(to != address(0), "ERC721: transfer to the zero address");
1386 
1387         _beforeTokenTransfer(from, to, tokenId);
1388 
1389         // Clear approvals from the previous owner
1390         _approve(address(0), tokenId);
1391 
1392         _balances[from] -= 1;
1393         _balances[to] += 1;
1394         _owners[tokenId] = to;
1395 
1396         emit Transfer(from, to, tokenId);
1397 
1398         _afterTokenTransfer(from, to, tokenId);
1399     }
1400 
1401     /**
1402      * @dev Approve `to` to operate on `tokenId`
1403      *
1404      * Emits a {Approval} event.
1405      */
1406     function _approve(address to, uint256 tokenId) internal virtual {
1407         _tokenApprovals[tokenId] = to;
1408         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1409     }
1410 
1411     /**
1412      * @dev Approve `operator` to operate on all of `owner` tokens
1413      *
1414      * Emits a {ApprovalForAll} event.
1415      */
1416     function _setApprovalForAll(
1417         address owner,
1418         address operator,
1419         bool approved
1420     ) internal virtual {
1421         require(owner != operator, "ERC721: approve to caller");
1422         _operatorApprovals[owner][operator] = approved;
1423         emit ApprovalForAll(owner, operator, approved);
1424     }
1425 
1426     /**
1427      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1428      * The call is not executed if the target address is not a contract.
1429      *
1430      * @param from address representing the previous owner of the given token ID
1431      * @param to target address that will receive the tokens
1432      * @param tokenId uint256 ID of the token to be transferred
1433      * @param _data bytes optional data to send along with the call
1434      * @return bool whether the call correctly returned the expected magic value
1435      */
1436     function _checkOnERC721Received(
1437         address from,
1438         address to,
1439         uint256 tokenId,
1440         bytes memory _data
1441     ) private returns (bool) {
1442         if (to.isContract()) {
1443             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1444                 return retval == IERC721Receiver.onERC721Received.selector;
1445             } catch (bytes memory reason) {
1446                 if (reason.length == 0) {
1447                     revert("ERC721: transfer to non ERC721Receiver implementer");
1448                 } else {
1449                     assembly {
1450                         revert(add(32, reason), mload(reason))
1451                     }
1452                 }
1453             }
1454         } else {
1455             return true;
1456         }
1457     }
1458 
1459     /**
1460      * @dev Hook that is called before any token transfer. This includes minting
1461      * and burning.
1462      *
1463      * Calling conditions:
1464      *
1465      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1466      * transferred to `to`.
1467      * - When `from` is zero, `tokenId` will be minted for `to`.
1468      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1469      * - `from` and `to` are never both zero.
1470      *
1471      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1472      */
1473     function _beforeTokenTransfer(
1474         address from,
1475         address to,
1476         uint256 tokenId
1477     ) internal virtual {}
1478 
1479     /**
1480      * @dev Hook that is called after any transfer of tokens. This includes
1481      * minting and burning.
1482      *
1483      * Calling conditions:
1484      *
1485      * - when `from` and `to` are both non-zero.
1486      * - `from` and `to` are never both zero.
1487      *
1488      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1489      */
1490     function _afterTokenTransfer(
1491         address from,
1492         address to,
1493         uint256 tokenId
1494     ) internal virtual {}
1495 }
1496 
1497 // File: contracts/Base64.sol
1498 
1499 
1500 pragma solidity ^0.8.0;
1501 
1502 /// @title Base64
1503 /// @notice Provides a function for encoding some bytes in base64
1504 /// @author Brecht Devos <brecht@loopring.org>
1505 library Base64 {
1506     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1507 
1508     /// @notice Encodes some bytes to the base64 representation
1509     function encode(bytes memory data) internal pure returns (string memory) {
1510         uint256 len = data.length;
1511         if (len == 0) return "";
1512 
1513         // multiply by 4/3 rounded up
1514         uint256 encodedLen = 4 * ((len + 2) / 3);
1515 
1516         // Add some extra buffer at the end
1517         bytes memory result = new bytes(encodedLen + 32);
1518 
1519         bytes memory table = TABLE;
1520 
1521         assembly {
1522             let tablePtr := add(table, 1)
1523             let resultPtr := add(result, 32)
1524 
1525             for {
1526                 let i := 0
1527             } lt(i, len) {
1528 
1529             } {
1530                 i := add(i, 3)
1531                 let input := and(mload(add(data, i)), 0xffffff)
1532 
1533                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1534                 out := shl(8, out)
1535                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
1536                 out := shl(8, out)
1537                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
1538                 out := shl(8, out)
1539                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
1540                 out := shl(224, out)
1541 
1542                 mstore(resultPtr, out)
1543 
1544                 resultPtr := add(resultPtr, 4)
1545             }
1546 
1547             switch mod(len, 3)
1548             case 1 {
1549                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1550             }
1551             case 2 {
1552                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1553             }
1554 
1555             mstore(result, encodedLen)
1556         }
1557 
1558         return string(result);
1559     }
1560 }
1561 
1562 // File: contracts/Ownable.sol
1563 
1564 
1565 pragma solidity ^0.8.0;
1566 
1567 contract Ownable {
1568     address private _convenienceOwner;
1569 
1570     event OwnershipSet(address indexed previousOwner, address indexed newOwner);
1571 
1572     /// @notice returns the address of the current _convenienceOwner
1573     /// @dev not used for access control, used by services that require a single owner account
1574     /// @return _convenienceOwner address
1575     function owner() public view virtual returns (address) {
1576         return _convenienceOwner;
1577     }
1578 
1579     /// @notice Set the _convenienceOwner address
1580     /// @dev not used for access control, used by services that require a single owner account
1581     /// @param newOwner address of the new _convenienceOwner
1582     function _setOwnership(address newOwner) internal virtual {
1583         address oldOwner = _convenienceOwner;
1584         _convenienceOwner = newOwner;
1585         emit OwnershipSet(oldOwner, newOwner);
1586     }
1587 
1588     /// @notice This empty reserved space is put in place to allow future versions to add new
1589     /// variables without shifting down storage in the inheritance chain.
1590     /// See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
1591     uint256[100] private __gap;
1592 }
1593 
1594 // File: contracts/Errors.sol
1595 
1596 
1597 pragma solidity ^0.8.0;
1598 
1599 error MaxSupplyReached();
1600 error AlreadyMinted();
1601 error ProofInvalidOrNotInAllowlist();
1602 error CannotMintFromContract();
1603 
1604 // File: contracts/Golid_Decal.sol
1605 
1606 
1607 pragma solidity ^0.8.0;
1608 
1609 
1610 
1611 
1612 
1613 
1614 
1615 
1616 
1617 
1618 /// @author @0x__jj, @llio (Deca)
1619 contract Golid_Decal is ERC721, ReentrancyGuard, AccessControl, Ownable {
1620   using Address for address;
1621   using Strings for *;
1622 
1623   mapping(address => bool) public minted;
1624 
1625   uint256 public totalSupply = 0;
1626 
1627   uint256 public constant MAX_SUPPLY = 100;
1628 
1629   bytes32 public merkleRoot;
1630 
1631   string public baseUri;
1632 
1633   constructor(string memory _baseUri, address[] memory _admins)
1634     ERC721("Decal by Kjetil Golid", "DECAL")
1635   {
1636     _setOwnership(msg.sender);
1637     _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
1638     for (uint256 i = 0; i < _admins.length; i++) {
1639       _grantRole(DEFAULT_ADMIN_ROLE, _admins[i]);
1640     }
1641     baseUri = _baseUri;
1642   }
1643 
1644   function setMerkleRoot(bytes32 _merkleRoot)
1645     external
1646     onlyRole(DEFAULT_ADMIN_ROLE)
1647   {
1648     merkleRoot = _merkleRoot;
1649   }
1650 
1651   function setOwnership(address _newOwner)
1652     external
1653     onlyRole(DEFAULT_ADMIN_ROLE)
1654   {
1655     _setOwnership(_newOwner);
1656   }
1657 
1658   function setBaseUri(string memory _newBaseUri)
1659     external
1660     onlyRole(DEFAULT_ADMIN_ROLE)
1661   {
1662     baseUri = _newBaseUri;
1663   }
1664 
1665   function mint(bytes32[] calldata _merkleProof)
1666     external
1667     nonReentrant
1668     returns (uint256)
1669   {
1670     if (totalSupply >= MAX_SUPPLY) revert MaxSupplyReached();
1671     if (minted[msg.sender]) revert AlreadyMinted();
1672     if (msg.sender.isContract()) revert CannotMintFromContract();
1673     bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1674     if (!MerkleProof.verify(_merkleProof, merkleRoot, leaf))
1675       revert ProofInvalidOrNotInAllowlist();
1676 
1677     uint256 tokenId = totalSupply;
1678     totalSupply++;
1679     minted[msg.sender] = true;
1680     _safeMint(msg.sender, tokenId);
1681     return tokenId;
1682   }
1683 
1684   function tokenURI(uint256 _tokenId)
1685     public
1686     view
1687     override(ERC721)
1688     returns (string memory)
1689   {
1690     require(_exists(_tokenId), "DECAL: URI query for nonexistent token");
1691     string memory baseURI = _baseURI();
1692     require(bytes(baseURI).length > 0, "baseURI not set");
1693     return string(abi.encodePacked(baseURI, _tokenId.toString()));
1694   }
1695 
1696   function getTokensOfOwner(address _owner)
1697     public
1698     view
1699     returns (uint256[] memory)
1700   {
1701     uint256 tokenCount = balanceOf(_owner);
1702     uint256[] memory tokenIds = new uint256[](tokenCount);
1703     uint256 seen = 0;
1704     for (uint256 i; i < totalSupply; i++) {
1705       if (ownerOf(i) == _owner) {
1706         tokenIds[seen] = i;
1707         seen++;
1708       }
1709       if (seen == tokenCount) break;
1710     }
1711     return tokenIds;
1712   }
1713 
1714   /**
1715    * @dev See {IERC165-supportsInterface}.
1716    */
1717   function supportsInterface(bytes4 interfaceId)
1718     public
1719     view
1720     virtual
1721     override(ERC721, AccessControl)
1722     returns (bool)
1723   {
1724     return super.supportsInterface(interfaceId);
1725   }
1726 
1727   function _baseURI() internal view override(ERC721) returns (string memory) {
1728     return baseUri;
1729   }
1730 }