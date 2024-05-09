1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Counters.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @title Counters
12  * @author Matt Condon (@shrugs)
13  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
14  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
15  *
16  * Include with `using Counters for Counters.Counter;`
17  */
18 library Counters {
19     struct Counter {
20         // This variable should never be directly accessed by users of the library: interactions must be restricted to
21         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
22         // this feature: see https://github.com/ethereum/solidity/issues/4637
23         uint256 _value; // default: 0
24     }
25 
26     function current(Counter storage counter) internal view returns (uint256) {
27         return counter._value;
28     }
29 
30     function increment(Counter storage counter) internal {
31         unchecked {
32             counter._value += 1;
33         }
34     }
35 
36     function decrement(Counter storage counter) internal {
37         uint256 value = counter._value;
38         require(value > 0, "Counter: decrement overflow");
39         unchecked {
40             counter._value = value - 1;
41         }
42     }
43 
44     function reset(Counter storage counter) internal {
45         counter._value = 0;
46     }
47 }
48 
49 // File: @openzeppelin/contracts/access/IAccessControl.sol
50 
51 
52 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
53 
54 pragma solidity ^0.8.0;
55 
56 /**
57  * @dev External interface of AccessControl declared to support ERC165 detection.
58  */
59 interface IAccessControl {
60     /**
61      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
62      *
63      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
64      * {RoleAdminChanged} not being emitted signaling this.
65      *
66      * _Available since v3.1._
67      */
68     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
69 
70     /**
71      * @dev Emitted when `account` is granted `role`.
72      *
73      * `sender` is the account that originated the contract call, an admin role
74      * bearer except when using {AccessControl-_setupRole}.
75      */
76     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
77 
78     /**
79      * @dev Emitted when `account` is revoked `role`.
80      *
81      * `sender` is the account that originated the contract call:
82      *   - if using `revokeRole`, it is the admin role bearer
83      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
84      */
85     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
86 
87     /**
88      * @dev Returns `true` if `account` has been granted `role`.
89      */
90     function hasRole(bytes32 role, address account) external view returns (bool);
91 
92     /**
93      * @dev Returns the admin role that controls `role`. See {grantRole} and
94      * {revokeRole}.
95      *
96      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
97      */
98     function getRoleAdmin(bytes32 role) external view returns (bytes32);
99 
100     /**
101      * @dev Grants `role` to `account`.
102      *
103      * If `account` had not been already granted `role`, emits a {RoleGranted}
104      * event.
105      *
106      * Requirements:
107      *
108      * - the caller must have ``role``'s admin role.
109      */
110     function grantRole(bytes32 role, address account) external;
111 
112     /**
113      * @dev Revokes `role` from `account`.
114      *
115      * If `account` had been granted `role`, emits a {RoleRevoked} event.
116      *
117      * Requirements:
118      *
119      * - the caller must have ``role``'s admin role.
120      */
121     function revokeRole(bytes32 role, address account) external;
122 
123     /**
124      * @dev Revokes `role` from the calling account.
125      *
126      * Roles are often managed via {grantRole} and {revokeRole}: this function's
127      * purpose is to provide a mechanism for accounts to lose their privileges
128      * if they are compromised (such as when a trusted device is misplaced).
129      *
130      * If the calling account had been granted `role`, emits a {RoleRevoked}
131      * event.
132      *
133      * Requirements:
134      *
135      * - the caller must be `account`.
136      */
137     function renounceRole(bytes32 role, address account) external;
138 }
139 
140 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
141 
142 
143 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
144 
145 pragma solidity ^0.8.0;
146 
147 /**
148  * @dev Contract module that helps prevent reentrant calls to a function.
149  *
150  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
151  * available, which can be applied to functions to make sure there are no nested
152  * (reentrant) calls to them.
153  *
154  * Note that because there is a single `nonReentrant` guard, functions marked as
155  * `nonReentrant` may not call one another. This can be worked around by making
156  * those functions `private`, and then adding `external` `nonReentrant` entry
157  * points to them.
158  *
159  * TIP: If you would like to learn more about reentrancy and alternative ways
160  * to protect against it, check out our blog post
161  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
162  */
163 abstract contract ReentrancyGuard {
164     // Booleans are more expensive than uint256 or any type that takes up a full
165     // word because each write operation emits an extra SLOAD to first read the
166     // slot's contents, replace the bits taken up by the boolean, and then write
167     // back. This is the compiler's defense against contract upgrades and
168     // pointer aliasing, and it cannot be disabled.
169 
170     // The values being non-zero value makes deployment a bit more expensive,
171     // but in exchange the refund on every call to nonReentrant will be lower in
172     // amount. Since refunds are capped to a percentage of the total
173     // transaction's gas, it is best to keep them low in cases like this one, to
174     // increase the likelihood of the full refund coming into effect.
175     uint256 private constant _NOT_ENTERED = 1;
176     uint256 private constant _ENTERED = 2;
177 
178     uint256 private _status;
179 
180     constructor() {
181         _status = _NOT_ENTERED;
182     }
183 
184     /**
185      * @dev Prevents a contract from calling itself, directly or indirectly.
186      * Calling a `nonReentrant` function from another `nonReentrant`
187      * function is not supported. It is possible to prevent this from happening
188      * by making the `nonReentrant` function external, and making it call a
189      * `private` function that does the actual work.
190      */
191     modifier nonReentrant() {
192         // On the first call to nonReentrant, _notEntered will be true
193         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
194 
195         // Any calls to nonReentrant after this point will fail
196         _status = _ENTERED;
197 
198         _;
199 
200         // By storing the original value once again, a refund is triggered (see
201         // https://eips.ethereum.org/EIPS/eip-2200)
202         _status = _NOT_ENTERED;
203     }
204 }
205 
206 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
207 
208 
209 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
210 
211 pragma solidity ^0.8.0;
212 
213 /**
214  * @dev These functions deal with verification of Merkle Trees proofs.
215  *
216  * The proofs can be generated using the JavaScript library
217  * https://github.com/miguelmota/merkletreejs[merkletreejs].
218  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
219  *
220  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
221  *
222  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
223  * hashing, or use a hash function other than keccak256 for hashing leaves.
224  * This is because the concatenation of a sorted pair of internal nodes in
225  * the merkle tree could be reinterpreted as a leaf value.
226  */
227 library MerkleProof {
228     /**
229      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
230      * defined by `root`. For this, a `proof` must be provided, containing
231      * sibling hashes on the branch from the leaf to the root of the tree. Each
232      * pair of leaves and each pair of pre-images are assumed to be sorted.
233      */
234     function verify(
235         bytes32[] memory proof,
236         bytes32 root,
237         bytes32 leaf
238     ) internal pure returns (bool) {
239         return processProof(proof, leaf) == root;
240     }
241 
242     /**
243      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
244      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
245      * hash matches the root of the tree. When processing the proof, the pairs
246      * of leafs & pre-images are assumed to be sorted.
247      *
248      * _Available since v4.4._
249      */
250     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
251         bytes32 computedHash = leaf;
252         for (uint256 i = 0; i < proof.length; i++) {
253             bytes32 proofElement = proof[i];
254             if (computedHash <= proofElement) {
255                 // Hash(current computed hash + current element of the proof)
256                 computedHash = _efficientHash(computedHash, proofElement);
257             } else {
258                 // Hash(current element of the proof + current computed hash)
259                 computedHash = _efficientHash(proofElement, computedHash);
260             }
261         }
262         return computedHash;
263     }
264 
265     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
266         assembly {
267             mstore(0x00, a)
268             mstore(0x20, b)
269             value := keccak256(0x00, 0x40)
270         }
271     }
272 }
273 
274 // File: @openzeppelin/contracts/utils/Strings.sol
275 
276 
277 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
278 
279 pragma solidity ^0.8.0;
280 
281 /**
282  * @dev String operations.
283  */
284 library Strings {
285     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
286 
287     /**
288      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
289      */
290     function toString(uint256 value) internal pure returns (string memory) {
291         // Inspired by OraclizeAPI's implementation - MIT licence
292         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
293 
294         if (value == 0) {
295             return "0";
296         }
297         uint256 temp = value;
298         uint256 digits;
299         while (temp != 0) {
300             digits++;
301             temp /= 10;
302         }
303         bytes memory buffer = new bytes(digits);
304         while (value != 0) {
305             digits -= 1;
306             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
307             value /= 10;
308         }
309         return string(buffer);
310     }
311 
312     /**
313      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
314      */
315     function toHexString(uint256 value) internal pure returns (string memory) {
316         if (value == 0) {
317             return "0x00";
318         }
319         uint256 temp = value;
320         uint256 length = 0;
321         while (temp != 0) {
322             length++;
323             temp >>= 8;
324         }
325         return toHexString(value, length);
326     }
327 
328     /**
329      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
330      */
331     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
332         bytes memory buffer = new bytes(2 * length + 2);
333         buffer[0] = "0";
334         buffer[1] = "x";
335         for (uint256 i = 2 * length + 1; i > 1; --i) {
336             buffer[i] = _HEX_SYMBOLS[value & 0xf];
337             value >>= 4;
338         }
339         require(value == 0, "Strings: hex length insufficient");
340         return string(buffer);
341     }
342 }
343 
344 // File: @openzeppelin/contracts/utils/Context.sol
345 
346 
347 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
348 
349 pragma solidity ^0.8.0;
350 
351 /**
352  * @dev Provides information about the current execution context, including the
353  * sender of the transaction and its data. While these are generally available
354  * via msg.sender and msg.data, they should not be accessed in such a direct
355  * manner, since when dealing with meta-transactions the account sending and
356  * paying for execution may not be the actual sender (as far as an application
357  * is concerned).
358  *
359  * This contract is only required for intermediate, library-like contracts.
360  */
361 abstract contract Context {
362     function _msgSender() internal view virtual returns (address) {
363         return msg.sender;
364     }
365 
366     function _msgData() internal view virtual returns (bytes calldata) {
367         return msg.data;
368     }
369 }
370 
371 // File: @openzeppelin/contracts/utils/Address.sol
372 
373 
374 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
375 
376 pragma solidity ^0.8.1;
377 
378 /**
379  * @dev Collection of functions related to the address type
380  */
381 library Address {
382     /**
383      * @dev Returns true if `account` is a contract.
384      *
385      * [IMPORTANT]
386      * ====
387      * It is unsafe to assume that an address for which this function returns
388      * false is an externally-owned account (EOA) and not a contract.
389      *
390      * Among others, `isContract` will return false for the following
391      * types of addresses:
392      *
393      *  - an externally-owned account
394      *  - a contract in construction
395      *  - an address where a contract will be created
396      *  - an address where a contract lived, but was destroyed
397      * ====
398      *
399      * [IMPORTANT]
400      * ====
401      * You shouldn't rely on `isContract` to protect against flash loan attacks!
402      *
403      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
404      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
405      * constructor.
406      * ====
407      */
408     function isContract(address account) internal view returns (bool) {
409         // This method relies on extcodesize/address.code.length, which returns 0
410         // for contracts in construction, since the code is only stored at the end
411         // of the constructor execution.
412 
413         return account.code.length > 0;
414     }
415 
416     /**
417      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
418      * `recipient`, forwarding all available gas and reverting on errors.
419      *
420      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
421      * of certain opcodes, possibly making contracts go over the 2300 gas limit
422      * imposed by `transfer`, making them unable to receive funds via
423      * `transfer`. {sendValue} removes this limitation.
424      *
425      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
426      *
427      * IMPORTANT: because control is transferred to `recipient`, care must be
428      * taken to not create reentrancy vulnerabilities. Consider using
429      * {ReentrancyGuard} or the
430      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
431      */
432     function sendValue(address payable recipient, uint256 amount) internal {
433         require(address(this).balance >= amount, "Address: insufficient balance");
434 
435         (bool success, ) = recipient.call{value: amount}("");
436         require(success, "Address: unable to send value, recipient may have reverted");
437     }
438 
439     /**
440      * @dev Performs a Solidity function call using a low level `call`. A
441      * plain `call` is an unsafe replacement for a function call: use this
442      * function instead.
443      *
444      * If `target` reverts with a revert reason, it is bubbled up by this
445      * function (like regular Solidity function calls).
446      *
447      * Returns the raw returned data. To convert to the expected return value,
448      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
449      *
450      * Requirements:
451      *
452      * - `target` must be a contract.
453      * - calling `target` with `data` must not revert.
454      *
455      * _Available since v3.1._
456      */
457     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
458         return functionCall(target, data, "Address: low-level call failed");
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
463      * `errorMessage` as a fallback revert reason when `target` reverts.
464      *
465      * _Available since v3.1._
466      */
467     function functionCall(
468         address target,
469         bytes memory data,
470         string memory errorMessage
471     ) internal returns (bytes memory) {
472         return functionCallWithValue(target, data, 0, errorMessage);
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
477      * but also transferring `value` wei to `target`.
478      *
479      * Requirements:
480      *
481      * - the calling contract must have an ETH balance of at least `value`.
482      * - the called Solidity function must be `payable`.
483      *
484      * _Available since v3.1._
485      */
486     function functionCallWithValue(
487         address target,
488         bytes memory data,
489         uint256 value
490     ) internal returns (bytes memory) {
491         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
492     }
493 
494     /**
495      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
496      * with `errorMessage` as a fallback revert reason when `target` reverts.
497      *
498      * _Available since v3.1._
499      */
500     function functionCallWithValue(
501         address target,
502         bytes memory data,
503         uint256 value,
504         string memory errorMessage
505     ) internal returns (bytes memory) {
506         require(address(this).balance >= value, "Address: insufficient balance for call");
507         require(isContract(target), "Address: call to non-contract");
508 
509         (bool success, bytes memory returndata) = target.call{value: value}(data);
510         return verifyCallResult(success, returndata, errorMessage);
511     }
512 
513     /**
514      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
515      * but performing a static call.
516      *
517      * _Available since v3.3._
518      */
519     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
520         return functionStaticCall(target, data, "Address: low-level static call failed");
521     }
522 
523     /**
524      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
525      * but performing a static call.
526      *
527      * _Available since v3.3._
528      */
529     function functionStaticCall(
530         address target,
531         bytes memory data,
532         string memory errorMessage
533     ) internal view returns (bytes memory) {
534         require(isContract(target), "Address: static call to non-contract");
535 
536         (bool success, bytes memory returndata) = target.staticcall(data);
537         return verifyCallResult(success, returndata, errorMessage);
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
542      * but performing a delegate call.
543      *
544      * _Available since v3.4._
545      */
546     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
547         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
548     }
549 
550     /**
551      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
552      * but performing a delegate call.
553      *
554      * _Available since v3.4._
555      */
556     function functionDelegateCall(
557         address target,
558         bytes memory data,
559         string memory errorMessage
560     ) internal returns (bytes memory) {
561         require(isContract(target), "Address: delegate call to non-contract");
562 
563         (bool success, bytes memory returndata) = target.delegatecall(data);
564         return verifyCallResult(success, returndata, errorMessage);
565     }
566 
567     /**
568      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
569      * revert reason using the provided one.
570      *
571      * _Available since v4.3._
572      */
573     function verifyCallResult(
574         bool success,
575         bytes memory returndata,
576         string memory errorMessage
577     ) internal pure returns (bytes memory) {
578         if (success) {
579             return returndata;
580         } else {
581             // Look for revert reason and bubble it up if present
582             if (returndata.length > 0) {
583                 // The easiest way to bubble the revert reason is using memory via assembly
584 
585                 assembly {
586                     let returndata_size := mload(returndata)
587                     revert(add(32, returndata), returndata_size)
588                 }
589             } else {
590                 revert(errorMessage);
591             }
592         }
593     }
594 }
595 
596 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
597 
598 
599 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
600 
601 pragma solidity ^0.8.0;
602 
603 /**
604  * @title ERC721 token receiver interface
605  * @dev Interface for any contract that wants to support safeTransfers
606  * from ERC721 asset contracts.
607  */
608 interface IERC721Receiver {
609     /**
610      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
611      * by `operator` from `from`, this function is called.
612      *
613      * It must return its Solidity selector to confirm the token transfer.
614      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
615      *
616      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
617      */
618     function onERC721Received(
619         address operator,
620         address from,
621         uint256 tokenId,
622         bytes calldata data
623     ) external returns (bytes4);
624 }
625 
626 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
627 
628 
629 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
630 
631 pragma solidity ^0.8.0;
632 
633 /**
634  * @dev Interface of the ERC165 standard, as defined in the
635  * https://eips.ethereum.org/EIPS/eip-165[EIP].
636  *
637  * Implementers can declare support of contract interfaces, which can then be
638  * queried by others ({ERC165Checker}).
639  *
640  * For an implementation, see {ERC165}.
641  */
642 interface IERC165 {
643     /**
644      * @dev Returns true if this contract implements the interface defined by
645      * `interfaceId`. See the corresponding
646      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
647      * to learn more about how these ids are created.
648      *
649      * This function call must use less than 30 000 gas.
650      */
651     function supportsInterface(bytes4 interfaceId) external view returns (bool);
652 }
653 
654 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
655 
656 
657 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
658 
659 pragma solidity ^0.8.0;
660 
661 
662 /**
663  * @dev Implementation of the {IERC165} interface.
664  *
665  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
666  * for the additional interface id that will be supported. For example:
667  *
668  * ```solidity
669  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
670  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
671  * }
672  * ```
673  *
674  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
675  */
676 abstract contract ERC165 is IERC165 {
677     /**
678      * @dev See {IERC165-supportsInterface}.
679      */
680     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
681         return interfaceId == type(IERC165).interfaceId;
682     }
683 }
684 
685 // File: @openzeppelin/contracts/access/AccessControl.sol
686 
687 
688 // OpenZeppelin Contracts (last updated v4.6.0) (access/AccessControl.sol)
689 
690 pragma solidity ^0.8.0;
691 
692 
693 
694 
695 
696 /**
697  * @dev Contract module that allows children to implement role-based access
698  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
699  * members except through off-chain means by accessing the contract event logs. Some
700  * applications may benefit from on-chain enumerability, for those cases see
701  * {AccessControlEnumerable}.
702  *
703  * Roles are referred to by their `bytes32` identifier. These should be exposed
704  * in the external API and be unique. The best way to achieve this is by
705  * using `public constant` hash digests:
706  *
707  * ```
708  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
709  * ```
710  *
711  * Roles can be used to represent a set of permissions. To restrict access to a
712  * function call, use {hasRole}:
713  *
714  * ```
715  * function foo() public {
716  *     require(hasRole(MY_ROLE, msg.sender));
717  *     ...
718  * }
719  * ```
720  *
721  * Roles can be granted and revoked dynamically via the {grantRole} and
722  * {revokeRole} functions. Each role has an associated admin role, and only
723  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
724  *
725  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
726  * that only accounts with this role will be able to grant or revoke other
727  * roles. More complex role relationships can be created by using
728  * {_setRoleAdmin}.
729  *
730  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
731  * grant and revoke this role. Extra precautions should be taken to secure
732  * accounts that have been granted it.
733  */
734 abstract contract AccessControl is Context, IAccessControl, ERC165 {
735     struct RoleData {
736         mapping(address => bool) members;
737         bytes32 adminRole;
738     }
739 
740     mapping(bytes32 => RoleData) private _roles;
741 
742     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
743 
744     /**
745      * @dev Modifier that checks that an account has a specific role. Reverts
746      * with a standardized message including the required role.
747      *
748      * The format of the revert reason is given by the following regular expression:
749      *
750      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
751      *
752      * _Available since v4.1._
753      */
754     modifier onlyRole(bytes32 role) {
755         _checkRole(role);
756         _;
757     }
758 
759     /**
760      * @dev See {IERC165-supportsInterface}.
761      */
762     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
763         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
764     }
765 
766     /**
767      * @dev Returns `true` if `account` has been granted `role`.
768      */
769     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
770         return _roles[role].members[account];
771     }
772 
773     /**
774      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
775      * Overriding this function changes the behavior of the {onlyRole} modifier.
776      *
777      * Format of the revert message is described in {_checkRole}.
778      *
779      * _Available since v4.6._
780      */
781     function _checkRole(bytes32 role) internal view virtual {
782         _checkRole(role, _msgSender());
783     }
784 
785     /**
786      * @dev Revert with a standard message if `account` is missing `role`.
787      *
788      * The format of the revert reason is given by the following regular expression:
789      *
790      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
791      */
792     function _checkRole(bytes32 role, address account) internal view virtual {
793         if (!hasRole(role, account)) {
794             revert(
795                 string(
796                     abi.encodePacked(
797                         "AccessControl: account ",
798                         Strings.toHexString(uint160(account), 20),
799                         " is missing role ",
800                         Strings.toHexString(uint256(role), 32)
801                     )
802                 )
803             );
804         }
805     }
806 
807     /**
808      * @dev Returns the admin role that controls `role`. See {grantRole} and
809      * {revokeRole}.
810      *
811      * To change a role's admin, use {_setRoleAdmin}.
812      */
813     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
814         return _roles[role].adminRole;
815     }
816 
817     /**
818      * @dev Grants `role` to `account`.
819      *
820      * If `account` had not been already granted `role`, emits a {RoleGranted}
821      * event.
822      *
823      * Requirements:
824      *
825      * - the caller must have ``role``'s admin role.
826      */
827     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
828         _grantRole(role, account);
829     }
830 
831     /**
832      * @dev Revokes `role` from `account`.
833      *
834      * If `account` had been granted `role`, emits a {RoleRevoked} event.
835      *
836      * Requirements:
837      *
838      * - the caller must have ``role``'s admin role.
839      */
840     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
841         _revokeRole(role, account);
842     }
843 
844     /**
845      * @dev Revokes `role` from the calling account.
846      *
847      * Roles are often managed via {grantRole} and {revokeRole}: this function's
848      * purpose is to provide a mechanism for accounts to lose their privileges
849      * if they are compromised (such as when a trusted device is misplaced).
850      *
851      * If the calling account had been revoked `role`, emits a {RoleRevoked}
852      * event.
853      *
854      * Requirements:
855      *
856      * - the caller must be `account`.
857      */
858     function renounceRole(bytes32 role, address account) public virtual override {
859         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
860 
861         _revokeRole(role, account);
862     }
863 
864     /**
865      * @dev Grants `role` to `account`.
866      *
867      * If `account` had not been already granted `role`, emits a {RoleGranted}
868      * event. Note that unlike {grantRole}, this function doesn't perform any
869      * checks on the calling account.
870      *
871      * [WARNING]
872      * ====
873      * This function should only be called from the constructor when setting
874      * up the initial roles for the system.
875      *
876      * Using this function in any other way is effectively circumventing the admin
877      * system imposed by {AccessControl}.
878      * ====
879      *
880      * NOTE: This function is deprecated in favor of {_grantRole}.
881      */
882     function _setupRole(bytes32 role, address account) internal virtual {
883         _grantRole(role, account);
884     }
885 
886     /**
887      * @dev Sets `adminRole` as ``role``'s admin role.
888      *
889      * Emits a {RoleAdminChanged} event.
890      */
891     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
892         bytes32 previousAdminRole = getRoleAdmin(role);
893         _roles[role].adminRole = adminRole;
894         emit RoleAdminChanged(role, previousAdminRole, adminRole);
895     }
896 
897     /**
898      * @dev Grants `role` to `account`.
899      *
900      * Internal function without access restriction.
901      */
902     function _grantRole(bytes32 role, address account) internal virtual {
903         if (!hasRole(role, account)) {
904             _roles[role].members[account] = true;
905             emit RoleGranted(role, account, _msgSender());
906         }
907     }
908 
909     /**
910      * @dev Revokes `role` from `account`.
911      *
912      * Internal function without access restriction.
913      */
914     function _revokeRole(bytes32 role, address account) internal virtual {
915         if (hasRole(role, account)) {
916             _roles[role].members[account] = false;
917             emit RoleRevoked(role, account, _msgSender());
918         }
919     }
920 }
921 
922 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
923 
924 
925 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
926 
927 pragma solidity ^0.8.0;
928 
929 
930 /**
931  * @dev Required interface of an ERC721 compliant contract.
932  */
933 interface IERC721 is IERC165 {
934     /**
935      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
936      */
937     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
938 
939     /**
940      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
941      */
942     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
943 
944     /**
945      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
946      */
947     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
948 
949     /**
950      * @dev Returns the number of tokens in ``owner``'s account.
951      */
952     function balanceOf(address owner) external view returns (uint256 balance);
953 
954     /**
955      * @dev Returns the owner of the `tokenId` token.
956      *
957      * Requirements:
958      *
959      * - `tokenId` must exist.
960      */
961     function ownerOf(uint256 tokenId) external view returns (address owner);
962 
963     /**
964      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
965      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
966      *
967      * Requirements:
968      *
969      * - `from` cannot be the zero address.
970      * - `to` cannot be the zero address.
971      * - `tokenId` token must exist and be owned by `from`.
972      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
973      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
974      *
975      * Emits a {Transfer} event.
976      */
977     function safeTransferFrom(
978         address from,
979         address to,
980         uint256 tokenId
981     ) external;
982 
983     /**
984      * @dev Transfers `tokenId` token from `from` to `to`.
985      *
986      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
987      *
988      * Requirements:
989      *
990      * - `from` cannot be the zero address.
991      * - `to` cannot be the zero address.
992      * - `tokenId` token must be owned by `from`.
993      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
994      *
995      * Emits a {Transfer} event.
996      */
997     function transferFrom(
998         address from,
999         address to,
1000         uint256 tokenId
1001     ) external;
1002 
1003     /**
1004      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1005      * The approval is cleared when the token is transferred.
1006      *
1007      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1008      *
1009      * Requirements:
1010      *
1011      * - The caller must own the token or be an approved operator.
1012      * - `tokenId` must exist.
1013      *
1014      * Emits an {Approval} event.
1015      */
1016     function approve(address to, uint256 tokenId) external;
1017 
1018     /**
1019      * @dev Returns the account approved for `tokenId` token.
1020      *
1021      * Requirements:
1022      *
1023      * - `tokenId` must exist.
1024      */
1025     function getApproved(uint256 tokenId) external view returns (address operator);
1026 
1027     /**
1028      * @dev Approve or remove `operator` as an operator for the caller.
1029      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1030      *
1031      * Requirements:
1032      *
1033      * - The `operator` cannot be the caller.
1034      *
1035      * Emits an {ApprovalForAll} event.
1036      */
1037     function setApprovalForAll(address operator, bool _approved) external;
1038 
1039     /**
1040      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1041      *
1042      * See {setApprovalForAll}
1043      */
1044     function isApprovedForAll(address owner, address operator) external view returns (bool);
1045 
1046     /**
1047      * @dev Safely transfers `tokenId` token from `from` to `to`.
1048      *
1049      * Requirements:
1050      *
1051      * - `from` cannot be the zero address.
1052      * - `to` cannot be the zero address.
1053      * - `tokenId` token must exist and be owned by `from`.
1054      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1055      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1056      *
1057      * Emits a {Transfer} event.
1058      */
1059     function safeTransferFrom(
1060         address from,
1061         address to,
1062         uint256 tokenId,
1063         bytes calldata data
1064     ) external;
1065 }
1066 
1067 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1068 
1069 
1070 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1071 
1072 pragma solidity ^0.8.0;
1073 
1074 
1075 /**
1076  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1077  * @dev See https://eips.ethereum.org/EIPS/eip-721
1078  */
1079 interface IERC721Enumerable is IERC721 {
1080     /**
1081      * @dev Returns the total amount of tokens stored by the contract.
1082      */
1083     function totalSupply() external view returns (uint256);
1084 
1085     /**
1086      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1087      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1088      */
1089     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1090 
1091     /**
1092      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1093      * Use along with {totalSupply} to enumerate all tokens.
1094      */
1095     function tokenByIndex(uint256 index) external view returns (uint256);
1096 }
1097 
1098 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1099 
1100 
1101 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1102 
1103 pragma solidity ^0.8.0;
1104 
1105 
1106 /**
1107  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1108  * @dev See https://eips.ethereum.org/EIPS/eip-721
1109  */
1110 interface IERC721Metadata is IERC721 {
1111     /**
1112      * @dev Returns the token collection name.
1113      */
1114     function name() external view returns (string memory);
1115 
1116     /**
1117      * @dev Returns the token collection symbol.
1118      */
1119     function symbol() external view returns (string memory);
1120 
1121     /**
1122      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1123      */
1124     function tokenURI(uint256 tokenId) external view returns (string memory);
1125 }
1126 
1127 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1128 
1129 
1130 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
1131 
1132 pragma solidity ^0.8.0;
1133 
1134 
1135 
1136 
1137 
1138 
1139 
1140 
1141 /**
1142  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1143  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1144  * {ERC721Enumerable}.
1145  */
1146 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1147     using Address for address;
1148     using Strings for uint256;
1149 
1150     // Token name
1151     string private _name;
1152 
1153     // Token symbol
1154     string private _symbol;
1155 
1156     // Mapping from token ID to owner address
1157     mapping(uint256 => address) private _owners;
1158 
1159     // Mapping owner address to token count
1160     mapping(address => uint256) private _balances;
1161 
1162     // Mapping from token ID to approved address
1163     mapping(uint256 => address) private _tokenApprovals;
1164 
1165     // Mapping from owner to operator approvals
1166     mapping(address => mapping(address => bool)) private _operatorApprovals;
1167 
1168     /**
1169      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1170      */
1171     constructor(string memory name_, string memory symbol_) {
1172         _name = name_;
1173         _symbol = symbol_;
1174     }
1175 
1176     /**
1177      * @dev See {IERC165-supportsInterface}.
1178      */
1179     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1180         return
1181             interfaceId == type(IERC721).interfaceId ||
1182             interfaceId == type(IERC721Metadata).interfaceId ||
1183             super.supportsInterface(interfaceId);
1184     }
1185 
1186     /**
1187      * @dev See {IERC721-balanceOf}.
1188      */
1189     function balanceOf(address owner) public view virtual override returns (uint256) {
1190         require(owner != address(0), "ERC721: balance query for the zero address");
1191         return _balances[owner];
1192     }
1193 
1194     /**
1195      * @dev See {IERC721-ownerOf}.
1196      */
1197     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1198         address owner = _owners[tokenId];
1199         require(owner != address(0), "ERC721: owner query for nonexistent token");
1200         return owner;
1201     }
1202 
1203     /**
1204      * @dev See {IERC721Metadata-name}.
1205      */
1206     function name() public view virtual override returns (string memory) {
1207         return _name;
1208     }
1209 
1210     /**
1211      * @dev See {IERC721Metadata-symbol}.
1212      */
1213     function symbol() public view virtual override returns (string memory) {
1214         return _symbol;
1215     }
1216 
1217     /**
1218      * @dev See {IERC721Metadata-tokenURI}.
1219      */
1220     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1221         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1222 
1223         string memory baseURI = _baseURI();
1224         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1225     }
1226 
1227     /**
1228      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1229      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1230      * by default, can be overriden in child contracts.
1231      */
1232     function _baseURI() internal view virtual returns (string memory) {
1233         return "";
1234     }
1235 
1236     /**
1237      * @dev See {IERC721-approve}.
1238      */
1239     function approve(address to, uint256 tokenId) public virtual override {
1240         address owner = ERC721.ownerOf(tokenId);
1241         require(to != owner, "ERC721: approval to current owner");
1242 
1243         require(
1244             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1245             "ERC721: approve caller is not owner nor approved for all"
1246         );
1247 
1248         _approve(to, tokenId);
1249     }
1250 
1251     /**
1252      * @dev See {IERC721-getApproved}.
1253      */
1254     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1255         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1256 
1257         return _tokenApprovals[tokenId];
1258     }
1259 
1260     /**
1261      * @dev See {IERC721-setApprovalForAll}.
1262      */
1263     function setApprovalForAll(address operator, bool approved) public virtual override {
1264         _setApprovalForAll(_msgSender(), operator, approved);
1265     }
1266 
1267     /**
1268      * @dev See {IERC721-isApprovedForAll}.
1269      */
1270     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1271         return _operatorApprovals[owner][operator];
1272     }
1273 
1274     /**
1275      * @dev See {IERC721-transferFrom}.
1276      */
1277     function transferFrom(
1278         address from,
1279         address to,
1280         uint256 tokenId
1281     ) public virtual override {
1282         //solhint-disable-next-line max-line-length
1283         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1284 
1285         _transfer(from, to, tokenId);
1286     }
1287 
1288     /**
1289      * @dev See {IERC721-safeTransferFrom}.
1290      */
1291     function safeTransferFrom(
1292         address from,
1293         address to,
1294         uint256 tokenId
1295     ) public virtual override {
1296         safeTransferFrom(from, to, tokenId, "");
1297     }
1298 
1299     /**
1300      * @dev See {IERC721-safeTransferFrom}.
1301      */
1302     function safeTransferFrom(
1303         address from,
1304         address to,
1305         uint256 tokenId,
1306         bytes memory _data
1307     ) public virtual override {
1308         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1309         _safeTransfer(from, to, tokenId, _data);
1310     }
1311 
1312     /**
1313      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1314      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1315      *
1316      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1317      *
1318      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1319      * implement alternative mechanisms to perform token transfer, such as signature-based.
1320      *
1321      * Requirements:
1322      *
1323      * - `from` cannot be the zero address.
1324      * - `to` cannot be the zero address.
1325      * - `tokenId` token must exist and be owned by `from`.
1326      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1327      *
1328      * Emits a {Transfer} event.
1329      */
1330     function _safeTransfer(
1331         address from,
1332         address to,
1333         uint256 tokenId,
1334         bytes memory _data
1335     ) internal virtual {
1336         _transfer(from, to, tokenId);
1337         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1338     }
1339 
1340     /**
1341      * @dev Returns whether `tokenId` exists.
1342      *
1343      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1344      *
1345      * Tokens start existing when they are minted (`_mint`),
1346      * and stop existing when they are burned (`_burn`).
1347      */
1348     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1349         return _owners[tokenId] != address(0);
1350     }
1351 
1352     /**
1353      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1354      *
1355      * Requirements:
1356      *
1357      * - `tokenId` must exist.
1358      */
1359     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1360         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1361         address owner = ERC721.ownerOf(tokenId);
1362         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1363     }
1364 
1365     /**
1366      * @dev Safely mints `tokenId` and transfers it to `to`.
1367      *
1368      * Requirements:
1369      *
1370      * - `tokenId` must not exist.
1371      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1372      *
1373      * Emits a {Transfer} event.
1374      */
1375     function _safeMint(address to, uint256 tokenId) internal virtual {
1376         _safeMint(to, tokenId, "");
1377     }
1378 
1379     /**
1380      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1381      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1382      */
1383     function _safeMint(
1384         address to,
1385         uint256 tokenId,
1386         bytes memory _data
1387     ) internal virtual {
1388         _mint(to, tokenId);
1389         require(
1390             _checkOnERC721Received(address(0), to, tokenId, _data),
1391             "ERC721: transfer to non ERC721Receiver implementer"
1392         );
1393     }
1394 
1395     /**
1396      * @dev Mints `tokenId` and transfers it to `to`.
1397      *
1398      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1399      *
1400      * Requirements:
1401      *
1402      * - `tokenId` must not exist.
1403      * - `to` cannot be the zero address.
1404      *
1405      * Emits a {Transfer} event.
1406      */
1407     function _mint(address to, uint256 tokenId) internal virtual {
1408         require(to != address(0), "ERC721: mint to the zero address");
1409         require(!_exists(tokenId), "ERC721: token already minted");
1410 
1411         _beforeTokenTransfer(address(0), to, tokenId);
1412 
1413         _balances[to] += 1;
1414         _owners[tokenId] = to;
1415 
1416         emit Transfer(address(0), to, tokenId);
1417 
1418         _afterTokenTransfer(address(0), to, tokenId);
1419     }
1420 
1421     /**
1422      * @dev Destroys `tokenId`.
1423      * The approval is cleared when the token is burned.
1424      *
1425      * Requirements:
1426      *
1427      * - `tokenId` must exist.
1428      *
1429      * Emits a {Transfer} event.
1430      */
1431     function _burn(uint256 tokenId) internal virtual {
1432         address owner = ERC721.ownerOf(tokenId);
1433 
1434         _beforeTokenTransfer(owner, address(0), tokenId);
1435 
1436         // Clear approvals
1437         _approve(address(0), tokenId);
1438 
1439         _balances[owner] -= 1;
1440         delete _owners[tokenId];
1441 
1442         emit Transfer(owner, address(0), tokenId);
1443 
1444         _afterTokenTransfer(owner, address(0), tokenId);
1445     }
1446 
1447     /**
1448      * @dev Transfers `tokenId` from `from` to `to`.
1449      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1450      *
1451      * Requirements:
1452      *
1453      * - `to` cannot be the zero address.
1454      * - `tokenId` token must be owned by `from`.
1455      *
1456      * Emits a {Transfer} event.
1457      */
1458     function _transfer(
1459         address from,
1460         address to,
1461         uint256 tokenId
1462     ) internal virtual {
1463         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1464         require(to != address(0), "ERC721: transfer to the zero address");
1465 
1466         _beforeTokenTransfer(from, to, tokenId);
1467 
1468         // Clear approvals from the previous owner
1469         _approve(address(0), tokenId);
1470 
1471         _balances[from] -= 1;
1472         _balances[to] += 1;
1473         _owners[tokenId] = to;
1474 
1475         emit Transfer(from, to, tokenId);
1476 
1477         _afterTokenTransfer(from, to, tokenId);
1478     }
1479 
1480     /**
1481      * @dev Approve `to` to operate on `tokenId`
1482      *
1483      * Emits a {Approval} event.
1484      */
1485     function _approve(address to, uint256 tokenId) internal virtual {
1486         _tokenApprovals[tokenId] = to;
1487         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1488     }
1489 
1490     /**
1491      * @dev Approve `operator` to operate on all of `owner` tokens
1492      *
1493      * Emits a {ApprovalForAll} event.
1494      */
1495     function _setApprovalForAll(
1496         address owner,
1497         address operator,
1498         bool approved
1499     ) internal virtual {
1500         require(owner != operator, "ERC721: approve to caller");
1501         _operatorApprovals[owner][operator] = approved;
1502         emit ApprovalForAll(owner, operator, approved);
1503     }
1504 
1505     /**
1506      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1507      * The call is not executed if the target address is not a contract.
1508      *
1509      * @param from address representing the previous owner of the given token ID
1510      * @param to target address that will receive the tokens
1511      * @param tokenId uint256 ID of the token to be transferred
1512      * @param _data bytes optional data to send along with the call
1513      * @return bool whether the call correctly returned the expected magic value
1514      */
1515     function _checkOnERC721Received(
1516         address from,
1517         address to,
1518         uint256 tokenId,
1519         bytes memory _data
1520     ) private returns (bool) {
1521         if (to.isContract()) {
1522             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1523                 return retval == IERC721Receiver.onERC721Received.selector;
1524             } catch (bytes memory reason) {
1525                 if (reason.length == 0) {
1526                     revert("ERC721: transfer to non ERC721Receiver implementer");
1527                 } else {
1528                     assembly {
1529                         revert(add(32, reason), mload(reason))
1530                     }
1531                 }
1532             }
1533         } else {
1534             return true;
1535         }
1536     }
1537 
1538     /**
1539      * @dev Hook that is called before any token transfer. This includes minting
1540      * and burning.
1541      *
1542      * Calling conditions:
1543      *
1544      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1545      * transferred to `to`.
1546      * - When `from` is zero, `tokenId` will be minted for `to`.
1547      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1548      * - `from` and `to` are never both zero.
1549      *
1550      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1551      */
1552     function _beforeTokenTransfer(
1553         address from,
1554         address to,
1555         uint256 tokenId
1556     ) internal virtual {}
1557 
1558     /**
1559      * @dev Hook that is called after any transfer of tokens. This includes
1560      * minting and burning.
1561      *
1562      * Calling conditions:
1563      *
1564      * - when `from` and `to` are both non-zero.
1565      * - `from` and `to` are never both zero.
1566      *
1567      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1568      */
1569     function _afterTokenTransfer(
1570         address from,
1571         address to,
1572         uint256 tokenId
1573     ) internal virtual {}
1574 }
1575 
1576 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1577 
1578 
1579 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721URIStorage.sol)
1580 
1581 pragma solidity ^0.8.0;
1582 
1583 
1584 /**
1585  * @dev ERC721 token with storage based token URI management.
1586  */
1587 abstract contract ERC721URIStorage is ERC721 {
1588     using Strings for uint256;
1589 
1590     // Optional mapping for token URIs
1591     mapping(uint256 => string) private _tokenURIs;
1592 
1593     /**
1594      * @dev See {IERC721Metadata-tokenURI}.
1595      */
1596     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1597         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1598 
1599         string memory _tokenURI = _tokenURIs[tokenId];
1600         string memory base = _baseURI();
1601 
1602         // If there is no base URI, return the token URI.
1603         if (bytes(base).length == 0) {
1604             return _tokenURI;
1605         }
1606         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1607         if (bytes(_tokenURI).length > 0) {
1608             return string(abi.encodePacked(base, _tokenURI));
1609         }
1610 
1611         return super.tokenURI(tokenId);
1612     }
1613 
1614     /**
1615      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1616      *
1617      * Requirements:
1618      *
1619      * - `tokenId` must exist.
1620      */
1621     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1622         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1623         _tokenURIs[tokenId] = _tokenURI;
1624     }
1625 
1626     /**
1627      * @dev Destroys `tokenId`.
1628      * The approval is cleared when the token is burned.
1629      *
1630      * Requirements:
1631      *
1632      * - `tokenId` must exist.
1633      *
1634      * Emits a {Transfer} event.
1635      */
1636     function _burn(uint256 tokenId) internal virtual override {
1637         super._burn(tokenId);
1638 
1639         if (bytes(_tokenURIs[tokenId]).length != 0) {
1640             delete _tokenURIs[tokenId];
1641         }
1642     }
1643 }
1644 
1645 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1646 
1647 
1648 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1649 
1650 pragma solidity ^0.8.0;
1651 
1652 
1653 
1654 /**
1655  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1656  * enumerability of all the token ids in the contract as well as all token ids owned by each
1657  * account.
1658  */
1659 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1660     // Mapping from owner to list of owned token IDs
1661     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1662 
1663     // Mapping from token ID to index of the owner tokens list
1664     mapping(uint256 => uint256) private _ownedTokensIndex;
1665 
1666     // Array with all token ids, used for enumeration
1667     uint256[] private _allTokens;
1668 
1669     // Mapping from token id to position in the allTokens array
1670     mapping(uint256 => uint256) private _allTokensIndex;
1671 
1672     /**
1673      * @dev See {IERC165-supportsInterface}.
1674      */
1675     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1676         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1677     }
1678 
1679     /**
1680      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1681      */
1682     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1683         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1684         return _ownedTokens[owner][index];
1685     }
1686 
1687     /**
1688      * @dev See {IERC721Enumerable-totalSupply}.
1689      */
1690     function totalSupply() public view virtual override returns (uint256) {
1691         return _allTokens.length;
1692     }
1693 
1694     /**
1695      * @dev See {IERC721Enumerable-tokenByIndex}.
1696      */
1697     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1698         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1699         return _allTokens[index];
1700     }
1701 
1702     /**
1703      * @dev Hook that is called before any token transfer. This includes minting
1704      * and burning.
1705      *
1706      * Calling conditions:
1707      *
1708      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1709      * transferred to `to`.
1710      * - When `from` is zero, `tokenId` will be minted for `to`.
1711      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1712      * - `from` cannot be the zero address.
1713      * - `to` cannot be the zero address.
1714      *
1715      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1716      */
1717     function _beforeTokenTransfer(
1718         address from,
1719         address to,
1720         uint256 tokenId
1721     ) internal virtual override {
1722         super._beforeTokenTransfer(from, to, tokenId);
1723 
1724         if (from == address(0)) {
1725             _addTokenToAllTokensEnumeration(tokenId);
1726         } else if (from != to) {
1727             _removeTokenFromOwnerEnumeration(from, tokenId);
1728         }
1729         if (to == address(0)) {
1730             _removeTokenFromAllTokensEnumeration(tokenId);
1731         } else if (to != from) {
1732             _addTokenToOwnerEnumeration(to, tokenId);
1733         }
1734     }
1735 
1736     /**
1737      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1738      * @param to address representing the new owner of the given token ID
1739      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1740      */
1741     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1742         uint256 length = ERC721.balanceOf(to);
1743         _ownedTokens[to][length] = tokenId;
1744         _ownedTokensIndex[tokenId] = length;
1745     }
1746 
1747     /**
1748      * @dev Private function to add a token to this extension's token tracking data structures.
1749      * @param tokenId uint256 ID of the token to be added to the tokens list
1750      */
1751     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1752         _allTokensIndex[tokenId] = _allTokens.length;
1753         _allTokens.push(tokenId);
1754     }
1755 
1756     /**
1757      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1758      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1759      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1760      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1761      * @param from address representing the previous owner of the given token ID
1762      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1763      */
1764     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1765         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1766         // then delete the last slot (swap and pop).
1767 
1768         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1769         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1770 
1771         // When the token to delete is the last token, the swap operation is unnecessary
1772         if (tokenIndex != lastTokenIndex) {
1773             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1774 
1775             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1776             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1777         }
1778 
1779         // This also deletes the contents at the last position of the array
1780         delete _ownedTokensIndex[tokenId];
1781         delete _ownedTokens[from][lastTokenIndex];
1782     }
1783 
1784     /**
1785      * @dev Private function to remove a token from this extension's token tracking data structures.
1786      * This has O(1) time complexity, but alters the order of the _allTokens array.
1787      * @param tokenId uint256 ID of the token to be removed from the tokens list
1788      */
1789     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1790         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1791         // then delete the last slot (swap and pop).
1792 
1793         uint256 lastTokenIndex = _allTokens.length - 1;
1794         uint256 tokenIndex = _allTokensIndex[tokenId];
1795 
1796         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1797         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1798         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1799         uint256 lastTokenId = _allTokens[lastTokenIndex];
1800 
1801         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1802         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1803 
1804         // This also deletes the contents at the last position of the array
1805         delete _allTokensIndex[tokenId];
1806         _allTokens.pop();
1807     }
1808 }
1809 
1810 // File: contracts/leafdao.sol
1811 
1812 
1813 pragma solidity >=0.7.0 <0.9.0;
1814 
1815 /// ================= Imports ==================
1816 
1817 
1818 
1819 
1820 
1821 
1822 
1823 
1824 
1825 /// @title This is the LazyLion interface.
1826  interface lazyLionI{
1827     function balanceOf(address owner) external view returns (uint256 balance);
1828  }
1829 
1830 //.-.  .-.   .-.   .-. .----. .-. .-. .----.
1831 // \ \/ /    | |   | |/  {}  \|  `| |{ {__  
1832 //  }  {     | `--.| |\      /| |\  |.-._} }
1833 // / /\ \     `----'`-' `----' `-' `-'`----'
1834 
1835 
1836 /// @title XTRA_for_LIONS
1837 /// @notice XTRALIONS claimable by LazyLion owners
1838 /// @dev ERC721 claimable by members of a merkle tree
1839 contract XtraForLions is ERC721, ERC721Enumerable, ReentrancyGuard, AccessControl, ERC721URIStorage {
1840  using Counters for Counters.Counter;
1841 
1842  Counters.Counter private _tokenIdCounter;
1843 
1844      /// ==================== State Variables  =======================
1845 
1846     bytes32 public constant MANAGER_ROLE = keccak256(abi.encodePacked("manager"));
1847 
1848     bool public whitelistState;
1849 
1850     //gnosis safe is one of the admin
1851     address private admin_one;
1852     address private admin_two;
1853     address private admin_three;
1854     address private gnosis_addr;
1855 
1856 
1857     uint256 public MINT_PRICE = 80000000000000000; // 0.08 ether;
1858 
1859     uint public maxMintKingAmount = 10;
1860 
1861     uint public maxMintLazyAmount = 1;
1862 
1863     string public baseURI;
1864 
1865     uint public constant MAX_TOKEN_SUPPLY = 500;
1866 
1867     /// @notice whitelist address inclusion root
1868      bytes32 public  merkleRoot;
1869 
1870      //lazyLion mainnet address
1871     lazyLionI _lazyLion = lazyLionI(0x8943C7bAC1914C9A7ABa750Bf2B6B09Fd21037E0);
1872 
1873 
1874     /// ==================== mappings =======================
1875              mapping(address => bool) public isWhitelisted;
1876 
1877              mapping(address => uint) public lazyTokenMinted;
1878 
1879               mapping(address => uint) public kingTokensMinted;
1880 
1881 
1882 
1883     /// ==================== constructor =======================
1884     /// @dev _merkleRoot must append "0x" prefix with the hash
1885     /// @dev Grants `DEFAULT_ADMIN_ROLE` to the account that deploys the contract.
1886     /// See {ERC20-constructor}.
1887     constructor(
1888       bytes32 _merkleRoot,
1889       address _admin_one, 
1890       address _admin_two,
1891       address _admin_three,
1892       address _gnosis_addr, 
1893       string memory _initBaseURI)ERC721
1894       ("XTRA for LIONS", "XTRALIONS"){
1895             baseURI =_initBaseURI;
1896           admin_one = _admin_one;
1897           admin_two = _admin_two;
1898           admin_three = _admin_three;
1899           gnosis_addr = _gnosis_addr;
1900           merkleRoot = _merkleRoot;
1901       _setRoleAdmin(MANAGER_ROLE, DEFAULT_ADMIN_ROLE);//only default admin can add manager
1902 
1903       _setupRole(DEFAULT_ADMIN_ROLE,admin_one);
1904       _setupRole(DEFAULT_ADMIN_ROLE,admin_two);
1905       _setupRole(DEFAULT_ADMIN_ROLE,admin_three);
1906       _setupRole(DEFAULT_ADMIN_ROLE,gnosis_addr);
1907   
1908     }
1909 
1910 
1911 
1912        /// ====================== events =======================
1913       event UpdatedRoot(bytes32 _newRoot);
1914       event managerAdded(address account);
1915       event mintedLazyEdition(address addr, uint256 _mintAmount);
1916       event mintedKingEdition(address addr, uint256 _mintAmount);
1917 
1918 
1919 
1920     /// ====================== functions ========================
1921      function _baseURI() internal view override returns (string memory) {
1922         return baseURI;
1923     }
1924 
1925      /// @notice Updates the merkleRoot with the given new root
1926     /// @param _newRoot new merkleRoot 
1927   function updateMerkleRoot(bytes32 _newRoot) onlyRole(MANAGER_ROLE) external {
1928     merkleRoot = _newRoot;
1929     emit UpdatedRoot(_newRoot);
1930   }
1931 
1932    /// @notice checks if the address is a member of the tree
1933    /// @dev the proof and root are gotten from the MerkleTree script
1934    /// @param _merkleProof to check if to is part of merkle tree
1935     /// @notice Only whitelisted users can mint
1936     ///@param uri is 1.json and 2.json
1937    function mintLazyEdition(uint _mintAmount, string calldata uri, bytes32[] calldata _merkleProof) nonReentrant external{
1938   //generate a leaf node to verify merkle proof
1939      bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1940 
1941     require(MerkleProof.verify(_merkleProof,merkleRoot,leaf), "Xtralion:invalid merkle proof"); //checks for valid proof
1942                  isWhitelisted[msg.sender] = true;
1943 
1944        require(_mintAmount != 0, "token:Cannot mint 0 tokens");     // Number of tokens can't be 0.
1945 
1946        lazyTokenMinted[msg.sender] += _mintAmount; //update users record
1947 
1948        require(lazyTokenMinted[msg.sender] <= maxMintLazyAmount,"xtralion:you have exceeded mint limit per wallet"); 
1949 
1950                uint256 supply = totalSupply() +_mintAmount;
1951 
1952        require(supply <= 120 && supply <= MAX_TOKEN_SUPPLY,"xtralion:Minting would exceed max. supply"); //make sure supply is still avail to mint
1953 
1954               for(uint256 i = 1; i <= _mintAmount; i++){
1955             uint256 tokenId = _tokenIdCounter.current();
1956              _safeMint(msg.sender, tokenId);// For each token requested, mint one.
1957              _setTokenURI(tokenId, uri);
1958             _tokenIdCounter.increment();
1959         }
1960       
1961         emit mintedLazyEdition(msg.sender, _mintAmount);
1962    }
1963 
1964     /// @notice only whitelisted address can mint if whitelist is disabled
1965     /// @notice members can only mint this edition if they pay the MINT_PRICE
1966     /// @param _mintAmount is the min token amount
1967     /// @param _merkleProof to make sure address is whitelisted
1968      ///@param uri is 1.json and 2.json respectively for the lazy and king collection
1969    function mintKingEdition(uint _mintAmount, string calldata uri, bytes32[] calldata _merkleProof) nonReentrant external payable{
1970      //generate a leaf node to verify merkle proof
1971      bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1972 
1973     require(MerkleProof.verify(_merkleProof,merkleRoot,leaf),"invalid merkle proof");
1974                  isWhitelisted[msg.sender] = true;
1975         if(whitelistState == true){
1976             require(
1977             isWhitelisted[msg.sender] = true,"whitelist Enabled: only whiteListedAddress can mint"
1978            ); 
1979          }else{
1980           (_lazyLion.balanceOf(msg.sender) > 0, "Whitelist disabled:not a lazy lion owner");     
1981          }
1982          // Number of tokens can't be 0.
1983         require(_mintAmount != 0, "Cannot mint 0 tokens");
1984              kingTokensMinted[msg.sender]  += _mintAmount;//update users record
1985 
1986         //check if address has minted
1987         require(kingTokensMinted[msg.sender] <= maxMintKingAmount, "you have exceeded mint limit per wallet");
1988         uint mintIndex = totalSupply() + _mintAmount;
1989         uint pricePerToken = MINT_PRICE * _mintAmount;
1990         // Check that the right amount of Ether was sent.
1991         require(pricePerToken <= msg.value, "Not enough Ether sent."); 
1992 
1993        require(mintIndex <= 380 && mintIndex <= MAX_TOKEN_SUPPLY,"Minting would exceed max. supply"); //make sure supply is still avail to mint
1994                   uint256 tokenId = _tokenIdCounter.current();
1995 
1996               for(uint256 i = 1; i <= _mintAmount; i++){
1997 
1998              _safeMint(msg.sender, tokenId);
1999               _setTokenURI(tokenId, uri);
2000               _tokenIdCounter.increment(); // For each token requested, mint one.
2001               }
2002   
2003                 emit mintedKingEdition(msg.sender, _mintAmount);
2004 
2005    }
2006 
2007 
2008       function changeWhitelistState() public onlyRole(MANAGER_ROLE){
2009        whitelistState = !whitelistState;
2010 
2011         }
2012       function getBalance() onlyRole(MANAGER_ROLE) public view returns(uint256) {
2013         return address(this).balance;
2014         }
2015 
2016        function changeLazyMintAmt(uint256 _newMint) public onlyRole(MANAGER_ROLE) {
2017         maxMintLazyAmount = _newMint;
2018         }
2019        function changeKingMintAmt(uint256 _newMint) public onlyRole(MANAGER_ROLE) {
2020         maxMintKingAmount = _newMint;
2021          }
2022        function changeMintPrice(uint256 _newPrice) public onlyRole(DEFAULT_ADMIN_ROLE) {
2023         MINT_PRICE = _newPrice;
2024         }
2025     ///@notice deposit in gnosis for mulsig to sig
2026     ///@notice admins set at the constructor also needs to be a manager
2027          function withdraw() onlyRole(DEFAULT_ADMIN_ROLE) nonReentrant external returns(bool){
2028                (bool sent,) = payable(gnosis_addr).call{value: getBalance()}("");
2029             require(sent,"Ether not sent:failed transaction");
2030                 return true;
2031          }
2032     /// @dev Add an account to the manager role. Restricted to admins.
2033         function addAsManager(address account) public onlyRole(DEFAULT_ADMIN_ROLE)
2034        {
2035          require(hasRole(MANAGER_ROLE,account) == false,"Already a manager");
2036            grantRole(MANAGER_ROLE, account);
2037 
2038             emit managerAdded(account);
2039        }
2040         
2041       // Create a bool check to see if a account address has the role admin
2042       function isAdmin(address account) public view returns(bool)
2043       {
2044            return hasRole(DEFAULT_ADMIN_ROLE, account);
2045       }
2046         // Create a bool check to see if a account address has the role admin
2047       function isManager(address account) public view returns(bool)
2048       {
2049            return hasRole(MANAGER_ROLE, account);
2050        }
2051 
2052          ///@custom:interface The following functions are overrides required by Solidity.
2053        function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Enumerable, AccessControl,ERC721) returns (bool) {
2054         return super.supportsInterface(interfaceId);
2055        }
2056 
2057 
2058         function _beforeTokenTransfer(address from, address to,uint256 tokenId) internal virtual override(ERC721Enumerable,ERC721) {
2059                   super._beforeTokenTransfer(from, to, tokenId);
2060         }
2061 
2062         function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
2063         super._burn(tokenId);
2064        }
2065 
2066         function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory)
2067        {
2068            return super.tokenURI(tokenId);
2069 
2070         }
2071 }