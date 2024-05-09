1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
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
27 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev Implementation of the {IERC165} interface.
33  *
34  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
35  * for the additional interface id that will be supported. For example:
36  *
37  * ```solidity
38  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
39  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
40  * }
41  * ```
42  *
43  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
44  */
45 abstract contract ERC165 is IERC165 {
46     /**
47      * @dev See {IERC165-supportsInterface}.
48      */
49     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
50         return interfaceId == type(IERC165).interfaceId;
51     }
52 }
53 
54 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
55 
56 pragma solidity ^0.8.0;
57 
58 /**
59  * @dev These functions deal with verification of Merkle Trees proofs.
60  *
61  * The proofs can be generated using the JavaScript library
62  * https://github.com/miguelmota/merkletreejs[merkletreejs].
63  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
64  *
65  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
66  */
67 library MerkleProof {
68     /**
69      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
70      * defined by `root`. For this, a `proof` must be provided, containing
71      * sibling hashes on the branch from the leaf to the root of the tree. Each
72      * pair of leaves and each pair of pre-images are assumed to be sorted.
73      */
74     function verify(
75         bytes32[] memory proof,
76         bytes32 root,
77         bytes32 leaf
78     ) internal pure returns (bool) {
79         return processProof(proof, leaf) == root;
80     }
81 
82     /**
83      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
84      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
85      * hash matches the root of the tree. When processing the proof, the pairs
86      * of leafs & pre-images are assumed to be sorted.
87      *
88      * _Available since v4.4._
89      */
90     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
91         bytes32 computedHash = leaf;
92         for (uint256 i = 0; i < proof.length; i++) {
93             bytes32 proofElement = proof[i];
94             if (computedHash <= proofElement) {
95                 // Hash(current computed hash + current element of the proof)
96                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
97             } else {
98                 // Hash(current element of the proof + current computed hash)
99                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
100             }
101         }
102         return computedHash;
103     }
104 }
105 
106 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
107 
108 pragma solidity ^0.8.0;
109 
110 /**
111  * @dev String operations.
112  */
113 library Strings {
114     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
115 
116     /**
117      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
118      */
119     function toString(uint256 value) internal pure returns (string memory) {
120         // Inspired by OraclizeAPI's implementation - MIT licence
121         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
122 
123         if (value == 0) {
124             return "0";
125         }
126         uint256 temp = value;
127         uint256 digits;
128         while (temp != 0) {
129             digits++;
130             temp /= 10;
131         }
132         bytes memory buffer = new bytes(digits);
133         while (value != 0) {
134             digits -= 1;
135             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
136             value /= 10;
137         }
138         return string(buffer);
139     }
140 
141     /**
142      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
143      */
144     function toHexString(uint256 value) internal pure returns (string memory) {
145         if (value == 0) {
146             return "0x00";
147         }
148         uint256 temp = value;
149         uint256 length = 0;
150         while (temp != 0) {
151             length++;
152             temp >>= 8;
153         }
154         return toHexString(value, length);
155     }
156 
157     /**
158      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
159      */
160     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
161         bytes memory buffer = new bytes(2 * length + 2);
162         buffer[0] = "0";
163         buffer[1] = "x";
164         for (uint256 i = 2 * length + 1; i > 1; --i) {
165             buffer[i] = _HEX_SYMBOLS[value & 0xf];
166             value >>= 4;
167         }
168         require(value == 0, "Strings: hex length insufficient");
169         return string(buffer);
170     }
171 }
172 
173 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
174 
175 pragma solidity ^0.8.0;
176 
177 /**
178  * @title Counters
179  * @author Matt Condon (@shrugs)
180  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
181  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
182  *
183  * Include with `using Counters for Counters.Counter;`
184  */
185 library Counters {
186     struct Counter {
187         // This variable should never be directly accessed by users of the library: interactions must be restricted to
188         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
189         // this feature: see https://github.com/ethereum/solidity/issues/4637
190         uint256 _value; // default: 0
191     }
192 
193     function current(Counter storage counter) internal view returns (uint256) {
194         return counter._value;
195     }
196 
197     function increment(Counter storage counter) internal {
198         unchecked {
199             counter._value += 1;
200         }
201     }
202 
203     function decrement(Counter storage counter) internal {
204         uint256 value = counter._value;
205         require(value > 0, "Counter: decrement overflow");
206         unchecked {
207             counter._value = value - 1;
208         }
209     }
210 
211     function reset(Counter storage counter) internal {
212         counter._value = 0;
213     }
214 }
215 
216 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
217 
218 pragma solidity ^0.8.0;
219 
220 /**
221  * @dev Collection of functions related to the address type
222  */
223 library Address {
224     /**
225      * @dev Returns true if `account` is a contract.
226      *
227      * [IMPORTANT]
228      * ====
229      * It is unsafe to assume that an address for which this function returns
230      * false is an externally-owned account (EOA) and not a contract.
231      *
232      * Among others, `isContract` will return false for the following
233      * types of addresses:
234      *
235      *  - an externally-owned account
236      *  - a contract in construction
237      *  - an address where a contract will be created
238      *  - an address where a contract lived, but was destroyed
239      * ====
240      */
241     function isContract(address account) internal view returns (bool) {
242         // This method relies on extcodesize, which returns 0 for contracts in
243         // construction, since the code is only stored at the end of the
244         // constructor execution.
245 
246         uint256 size;
247         assembly {
248             size := extcodesize(account)
249         }
250         return size > 0;
251     }
252 
253     /**
254      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
255      * `recipient`, forwarding all available gas and reverting on errors.
256      *
257      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
258      * of certain opcodes, possibly making contracts go over the 2300 gas limit
259      * imposed by `transfer`, making them unable to receive funds via
260      * `transfer`. {sendValue} removes this limitation.
261      *
262      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
263      *
264      * IMPORTANT: because control is transferred to `recipient`, care must be
265      * taken to not create reentrancy vulnerabilities. Consider using
266      * {ReentrancyGuard} or the
267      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
268      */
269     function sendValue(address payable recipient, uint256 amount) internal {
270         require(address(this).balance >= amount, "Address: insufficient balance");
271 
272         (bool success, ) = recipient.call{value: amount}("");
273         require(success, "Address: unable to send value, recipient may have reverted");
274     }
275 
276     /**
277      * @dev Performs a Solidity function call using a low level `call`. A
278      * plain `call` is an unsafe replacement for a function call: use this
279      * function instead.
280      *
281      * If `target` reverts with a revert reason, it is bubbled up by this
282      * function (like regular Solidity function calls).
283      *
284      * Returns the raw returned data. To convert to the expected return value,
285      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
286      *
287      * Requirements:
288      *
289      * - `target` must be a contract.
290      * - calling `target` with `data` must not revert.
291      *
292      * _Available since v3.1._
293      */
294     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
295         return functionCall(target, data, "Address: low-level call failed");
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
300      * `errorMessage` as a fallback revert reason when `target` reverts.
301      *
302      * _Available since v3.1._
303      */
304     function functionCall(
305         address target,
306         bytes memory data,
307         string memory errorMessage
308     ) internal returns (bytes memory) {
309         return functionCallWithValue(target, data, 0, errorMessage);
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
314      * but also transferring `value` wei to `target`.
315      *
316      * Requirements:
317      *
318      * - the calling contract must have an ETH balance of at least `value`.
319      * - the called Solidity function must be `payable`.
320      *
321      * _Available since v3.1._
322      */
323     function functionCallWithValue(
324         address target,
325         bytes memory data,
326         uint256 value
327     ) internal returns (bytes memory) {
328         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
333      * with `errorMessage` as a fallback revert reason when `target` reverts.
334      *
335      * _Available since v3.1._
336      */
337     function functionCallWithValue(
338         address target,
339         bytes memory data,
340         uint256 value,
341         string memory errorMessage
342     ) internal returns (bytes memory) {
343         require(address(this).balance >= value, "Address: insufficient balance for call");
344         require(isContract(target), "Address: call to non-contract");
345 
346         (bool success, bytes memory returndata) = target.call{value: value}(data);
347         return verifyCallResult(success, returndata, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but performing a static call.
353      *
354      * _Available since v3.3._
355      */
356     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
357         return functionStaticCall(target, data, "Address: low-level static call failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
362      * but performing a static call.
363      *
364      * _Available since v3.3._
365      */
366     function functionStaticCall(
367         address target,
368         bytes memory data,
369         string memory errorMessage
370     ) internal view returns (bytes memory) {
371         require(isContract(target), "Address: static call to non-contract");
372 
373         (bool success, bytes memory returndata) = target.staticcall(data);
374         return verifyCallResult(success, returndata, errorMessage);
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
379      * but performing a delegate call.
380      *
381      * _Available since v3.4._
382      */
383     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
384         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
389      * but performing a delegate call.
390      *
391      * _Available since v3.4._
392      */
393     function functionDelegateCall(
394         address target,
395         bytes memory data,
396         string memory errorMessage
397     ) internal returns (bytes memory) {
398         require(isContract(target), "Address: delegate call to non-contract");
399 
400         (bool success, bytes memory returndata) = target.delegatecall(data);
401         return verifyCallResult(success, returndata, errorMessage);
402     }
403 
404     /**
405      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
406      * revert reason using the provided one.
407      *
408      * _Available since v4.3._
409      */
410     function verifyCallResult(
411         bool success,
412         bytes memory returndata,
413         string memory errorMessage
414     ) internal pure returns (bytes memory) {
415         if (success) {
416             return returndata;
417         } else {
418             // Look for revert reason and bubble it up if present
419             if (returndata.length > 0) {
420                 // The easiest way to bubble the revert reason is using memory via assembly
421 
422                 assembly {
423                     let returndata_size := mload(returndata)
424                     revert(add(32, returndata), returndata_size)
425                 }
426             } else {
427                 revert(errorMessage);
428             }
429         }
430     }
431 }
432 
433 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
434 
435 pragma solidity ^0.8.0;
436 
437 /**
438  * @dev Required interface of an ERC721 compliant contract.
439  */
440 interface IERC721 is IERC165 {
441     /**
442      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
443      */
444     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
445 
446     /**
447      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
448      */
449     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
450 
451     /**
452      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
453      */
454     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
455 
456     /**
457      * @dev Returns the number of tokens in ``owner``'s account.
458      */
459     function balanceOf(address owner) external view returns (uint256 balance);
460 
461     /**
462      * @dev Returns the owner of the `tokenId` token.
463      *
464      * Requirements:
465      *
466      * - `tokenId` must exist.
467      */
468     function ownerOf(uint256 tokenId) external view returns (address owner);
469 
470     /**
471      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
472      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
473      *
474      * Requirements:
475      *
476      * - `from` cannot be the zero address.
477      * - `to` cannot be the zero address.
478      * - `tokenId` token must exist and be owned by `from`.
479      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
480      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
481      *
482      * Emits a {Transfer} event.
483      */
484     function safeTransferFrom(
485         address from,
486         address to,
487         uint256 tokenId
488     ) external;
489 
490     /**
491      * @dev Transfers `tokenId` token from `from` to `to`.
492      *
493      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
494      *
495      * Requirements:
496      *
497      * - `from` cannot be the zero address.
498      * - `to` cannot be the zero address.
499      * - `tokenId` token must be owned by `from`.
500      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
501      *
502      * Emits a {Transfer} event.
503      */
504     function transferFrom(
505         address from,
506         address to,
507         uint256 tokenId
508     ) external;
509 
510     /**
511      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
512      * The approval is cleared when the token is transferred.
513      *
514      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
515      *
516      * Requirements:
517      *
518      * - The caller must own the token or be an approved operator.
519      * - `tokenId` must exist.
520      *
521      * Emits an {Approval} event.
522      */
523     function approve(address to, uint256 tokenId) external;
524 
525     /**
526      * @dev Returns the account approved for `tokenId` token.
527      *
528      * Requirements:
529      *
530      * - `tokenId` must exist.
531      */
532     function getApproved(uint256 tokenId) external view returns (address operator);
533 
534     /**
535      * @dev Approve or remove `operator` as an operator for the caller.
536      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
537      *
538      * Requirements:
539      *
540      * - The `operator` cannot be the caller.
541      *
542      * Emits an {ApprovalForAll} event.
543      */
544     function setApprovalForAll(address operator, bool _approved) external;
545 
546     /**
547      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
548      *
549      * See {setApprovalForAll}
550      */
551     function isApprovedForAll(address owner, address operator) external view returns (bool);
552 
553     /**
554      * @dev Safely transfers `tokenId` token from `from` to `to`.
555      *
556      * Requirements:
557      *
558      * - `from` cannot be the zero address.
559      * - `to` cannot be the zero address.
560      * - `tokenId` token must exist and be owned by `from`.
561      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
562      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
563      *
564      * Emits a {Transfer} event.
565      */
566     function safeTransferFrom(
567         address from,
568         address to,
569         uint256 tokenId,
570         bytes calldata data
571     ) external;
572 }
573 
574 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
575 
576 pragma solidity ^0.8.0;
577 
578 /**
579  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
580  * @dev See https://eips.ethereum.org/EIPS/eip-721
581  */
582 interface IERC721Metadata is IERC721 {
583     /**
584      * @dev Returns the token collection name.
585      */
586     function name() external view returns (string memory);
587 
588     /**
589      * @dev Returns the token collection symbol.
590      */
591     function symbol() external view returns (string memory);
592 
593     /**
594      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
595      */
596     function tokenURI(uint256 tokenId) external view returns (string memory);
597 }
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
626 
627 
628 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
629 
630 pragma solidity ^0.8.0;
631 
632 /**
633  * @dev Contract module that helps prevent reentrant calls to a function.
634  *
635  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
636  * available, which can be applied to functions to make sure there are no nested
637  * (reentrant) calls to them.
638  *
639  * Note that because there is a single `nonReentrant` guard, functions marked as
640  * `nonReentrant` may not call one another. This can be worked around by making
641  * those functions `private`, and then adding `external` `nonReentrant` entry
642  * points to them.
643  *
644  * TIP: If you would like to learn more about reentrancy and alternative ways
645  * to protect against it, check out our blog post
646  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
647  */
648 abstract contract ReentrancyGuard {
649     // Booleans are more expensive than uint256 or any type that takes up a full
650     // word because each write operation emits an extra SLOAD to first read the
651     // slot's contents, replace the bits taken up by the boolean, and then write
652     // back. This is the compiler's defense against contract upgrades and
653     // pointer aliasing, and it cannot be disabled.
654 
655     // The values being non-zero value makes deployment a bit more expensive,
656     // but in exchange the refund on every call to nonReentrant will be lower in
657     // amount. Since refunds are capped to a percentage of the total
658     // transaction's gas, it is best to keep them low in cases like this one, to
659     // increase the likelihood of the full refund coming into effect.
660     uint256 private constant _NOT_ENTERED = 1;
661     uint256 private constant _ENTERED = 2;
662 
663     uint256 private _status;
664 
665     constructor() {
666         _status = _NOT_ENTERED;
667     }
668 
669     /**
670      * @dev Prevents a contract from calling itself, directly or indirectly.
671      * Calling a `nonReentrant` function from another `nonReentrant`
672      * function is not supported. It is possible to prevent this from happening
673      * by making the `nonReentrant` function external, and making it call a
674      * `private` function that does the actual work.
675      */
676     modifier nonReentrant() {
677         // On the first call to nonReentrant, _notEntered will be true
678         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
679 
680         // Any calls to nonReentrant after this point will fail
681         _status = _ENTERED;
682 
683         _;
684 
685         // By storing the original value once again, a refund is triggered (see
686         // https://eips.ethereum.org/EIPS/eip-2200)
687         _status = _NOT_ENTERED;
688     }
689 }
690 /***
691  *     ██████╗ ██████╗ ███╗   ██╗████████╗███████╗██╗  ██╗████████╗
692  *    ██╔════╝██╔═══██╗████╗  ██║╚══██╔══╝██╔════╝╚██╗██╔╝╚══██╔══╝
693  *    ██║     ██║   ██║██╔██╗ ██║   ██║   █████╗   ╚███╔╝    ██║   
694  *    ██║     ██║   ██║██║╚██╗██║   ██║   ██╔══╝   ██╔██╗    ██║   
695  *    ╚██████╗╚██████╔╝██║ ╚████║   ██║   ███████╗██╔╝ ██╗   ██║   
696  *     ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝   
697  * Re-write of @openzeppelin/contracts/utils/Context.sol
698  * 
699  *
700  * Upgraded stock contract with _msgValue() and _txOrigin() 
701  */
702 
703 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
704 
705 
706 pragma solidity ^0.8.0;
707 
708 /**
709  * @dev Provides information about the current execution context, including the
710  * sender of the transaction and its data. While these are generally available
711  * via msg.sender and msg.data, they should not be accessed in such a direct
712  * manner, since when dealing with meta-transactions the account sending and
713  * paying for execution may not be the actual sender (as far as an application
714  * is concerned).
715  *
716  * This contract is only required for intermediate, library-like contracts.
717  */
718 abstract contract Context {
719     function _msgSender() internal view virtual returns (address) {
720         return msg.sender;
721     }
722 
723     function _msgData() internal view virtual returns (bytes calldata) {
724         return msg.data;
725     }
726 
727     function _msgValue() internal view virtual returns (uint) {
728         return msg.value;
729     }
730 
731     function _txOrigin() internal view virtual returns (address) {
732         return tx.origin;
733     }
734 }
735 
736 // Creator: Chiru Labs
737 
738 pragma solidity ^0.8.4;
739 
740 error ApprovalCallerNotOwnerNorApproved();
741 error ApprovalQueryForNonexistentToken();
742 error ApproveToCaller();
743 error ApprovalToCurrentOwner();
744 error BalanceQueryForZeroAddress();
745 error MintedQueryForZeroAddress();
746 error BurnedQueryForZeroAddress();
747 error AuxQueryForZeroAddress();
748 error MintToZeroAddress();
749 error MintZeroQuantity();
750 error OwnerIndexOutOfBounds();
751 error OwnerQueryForNonexistentToken();
752 error TokenIndexOutOfBounds();
753 error TransferCallerNotOwnerNorApproved();
754 error TransferFromIncorrectOwner();
755 error TransferToNonERC721ReceiverImplementer();
756 error TransferToZeroAddress();
757 error URIQueryForNonexistentToken();
758 
759 /**
760  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
761  * the Metadata extension. Built to optimize for lower gas during batch mints.
762  *
763  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
764  *
765  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
766  *
767  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
768  */
769 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
770     using Address for address;
771     using Strings for uint256;
772 
773     // Compiler will pack this into a single 256bit word.
774     struct TokenOwnership {
775         // The address of the owner.
776         address addr;
777         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
778         uint64 startTimestamp;
779         // Whether the token has been burned.
780         bool burned;
781     }
782 
783     // Compiler will pack this into a single 256bit word.
784     struct AddressData {
785         // Realistically, 2**64-1 is more than enough.
786         uint64 balance;
787         // Keeps track of mint count with minimal overhead for tokenomics.
788         uint64 numberMinted;
789         // Keeps track of burn count with minimal overhead for tokenomics.
790         uint64 numberBurned;
791         // For miscellaneous variable(s) pertaining to the address
792         // (e.g. number of whitelist mint slots used).
793         // If there are multiple variables, please pack them into a uint64.
794         uint64 aux;
795     }
796 
797     // The tokenId of the next token to be minted.
798     uint256 internal _currentIndex;
799 
800     // The number of tokens burned.
801     uint256 internal _burnCounter;
802 
803     // Token name
804     string private _name;
805 
806     // Token symbol
807     string private _symbol;
808 
809     // Mapping from token ID to ownership details
810     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
811     mapping(uint256 => TokenOwnership) internal _ownerships;
812 
813     // Mapping owner address to address data
814     mapping(address => AddressData) private _addressData;
815 
816     // Mapping from token ID to approved address
817     mapping(uint256 => address) private _tokenApprovals;
818 
819     // Mapping from owner to operator approvals
820     mapping(address => mapping(address => bool)) private _operatorApprovals;
821 
822     constructor(string memory name_, string memory symbol_) {
823         _name = name_;
824         _symbol = symbol_;
825         _currentIndex = _startTokenId();
826     }
827 
828     /**
829      * To change the starting tokenId, please override this function.
830      */
831     function _startTokenId() internal view virtual returns (uint256) {
832         return 0;
833     }
834 
835     /**
836      * @dev See {IERC721Enumerable-totalSupply}.
837      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
838      */
839     function totalSupply() public view returns (uint256) {
840         // Counter underflow is impossible as _burnCounter cannot be incremented
841         // more than _currentIndex - _startTokenId() times
842         unchecked {
843             return _currentIndex - _burnCounter - _startTokenId();
844         }
845     }
846 
847     /**
848      * Returns the total amount of tokens minted in the contract.
849      */
850     function _totalMinted() internal view returns (uint256) {
851         // Counter underflow is impossible as _currentIndex does not decrement,
852         // and it is initialized to _startTokenId()
853         unchecked {
854             return _currentIndex - _startTokenId();
855         }
856     }
857 
858     /**
859      * @dev See {IERC165-supportsInterface}.
860      */
861     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
862         return
863             interfaceId == type(IERC721).interfaceId ||
864             interfaceId == type(IERC721Metadata).interfaceId ||
865             super.supportsInterface(interfaceId);
866     }
867 
868     /**
869      * @dev See {IERC721-balanceOf}.
870      */
871     function balanceOf(address owner) public view override returns (uint256) {
872         if (owner == address(0)) revert BalanceQueryForZeroAddress();
873         return uint256(_addressData[owner].balance);
874     }
875 
876     /**
877      * Returns the number of tokens minted by `owner`.
878      */
879     function _numberMinted(address owner) internal view returns (uint256) {
880         if (owner == address(0)) revert MintedQueryForZeroAddress();
881         return uint256(_addressData[owner].numberMinted);
882     }
883 
884     /**
885      * Returns the number of tokens burned by or on behalf of `owner`.
886      */
887     function _numberBurned(address owner) internal view returns (uint256) {
888         if (owner == address(0)) revert BurnedQueryForZeroAddress();
889         return uint256(_addressData[owner].numberBurned);
890     }
891 
892     /**
893      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
894      */
895     function _getAux(address owner) internal view returns (uint64) {
896         if (owner == address(0)) revert AuxQueryForZeroAddress();
897         return _addressData[owner].aux;
898     }
899 
900     /**
901      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
902      * If there are multiple variables, please pack them into a uint64.
903      */
904     function _setAux(address owner, uint64 aux) internal {
905         if (owner == address(0)) revert AuxQueryForZeroAddress();
906         _addressData[owner].aux = aux;
907     }
908 
909     /**
910      * Gas spent here starts off proportional to the maximum mint batch size.
911      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
912      */
913     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
914         uint256 curr = tokenId;
915 
916         unchecked {
917             if (_startTokenId() <= curr && curr < _currentIndex) {
918                 TokenOwnership memory ownership = _ownerships[curr];
919                 if (!ownership.burned) {
920                     if (ownership.addr != address(0)) {
921                         return ownership;
922                     }
923                     // Invariant:
924                     // There will always be an ownership that has an address and is not burned
925                     // before an ownership that does not have an address and is not burned.
926                     // Hence, curr will not underflow.
927                     while (true) {
928                         curr--;
929                         ownership = _ownerships[curr];
930                         if (ownership.addr != address(0)) {
931                             return ownership;
932                         }
933                     }
934                 }
935             }
936         }
937         revert OwnerQueryForNonexistentToken();
938     }
939 
940     /**
941      * @dev See {IERC721-ownerOf}.
942      */
943     function ownerOf(uint256 tokenId) public view override returns (address) {
944         return ownershipOf(tokenId).addr;
945     }
946 
947     /**
948      * @dev See {IERC721Metadata-name}.
949      */
950     function name() public view virtual override returns (string memory) {
951         return _name;
952     }
953 
954     /**
955      * @dev See {IERC721Metadata-symbol}.
956      */
957     function symbol() public view virtual override returns (string memory) {
958         return _symbol;
959     }
960 
961     /**
962      * @dev See {IERC721Metadata-tokenURI}.
963      */
964     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
965         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
966 
967         string memory baseURI = _baseURI();
968         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
969     }
970 
971     /**
972      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
973      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
974      * by default, can be overriden in child contracts.
975      */
976     function _baseURI() internal view virtual returns (string memory) {
977         return '';
978     }
979 
980     /**
981      * @dev See {IERC721-approve}.
982      */
983     function approve(address to, uint256 tokenId) public override {
984         address owner = ERC721A.ownerOf(tokenId);
985         if (to == owner) revert ApprovalToCurrentOwner();
986 
987         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
988             revert ApprovalCallerNotOwnerNorApproved();
989         }
990 
991         _approve(to, tokenId, owner);
992     }
993 
994     /**
995      * @dev See {IERC721-getApproved}.
996      */
997     function getApproved(uint256 tokenId) public view override returns (address) {
998         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
999 
1000         return _tokenApprovals[tokenId];
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-setApprovalForAll}.
1005      */
1006     function setApprovalForAll(address operator, bool approved) public override {
1007         if (operator == _msgSender()) revert ApproveToCaller();
1008 
1009         _operatorApprovals[_msgSender()][operator] = approved;
1010         emit ApprovalForAll(_msgSender(), operator, approved);
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-isApprovedForAll}.
1015      */
1016     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1017         return _operatorApprovals[owner][operator];
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-transferFrom}.
1022      */
1023     function transferFrom(
1024         address from,
1025         address to,
1026         uint256 tokenId
1027     ) public virtual override {
1028         _transfer(from, to, tokenId);
1029     }
1030 
1031     /**
1032      * @dev See {IERC721-safeTransferFrom}.
1033      */
1034     function safeTransferFrom(
1035         address from,
1036         address to,
1037         uint256 tokenId
1038     ) public virtual override {
1039         safeTransferFrom(from, to, tokenId, '');
1040     }
1041 
1042     /**
1043      * @dev See {IERC721-safeTransferFrom}.
1044      */
1045     function safeTransferFrom(
1046         address from,
1047         address to,
1048         uint256 tokenId,
1049         bytes memory _data
1050     ) public virtual override {
1051         _transfer(from, to, tokenId);
1052         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1053             revert TransferToNonERC721ReceiverImplementer();
1054         }
1055     }
1056 
1057     /**
1058      * @dev Returns whether `tokenId` exists.
1059      *
1060      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1061      *
1062      * Tokens start existing when they are minted (`_mint`),
1063      */
1064     function _exists(uint256 tokenId) internal view returns (bool) {
1065         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1066             !_ownerships[tokenId].burned;
1067     }
1068 
1069     function _safeMint(address to, uint256 quantity) internal {
1070         _safeMint(to, quantity, '');
1071     }
1072 
1073     /**
1074      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1075      *
1076      * Requirements:
1077      *
1078      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1079      * - `quantity` must be greater than 0.
1080      *
1081      * Emits a {Transfer} event.
1082      */
1083     function _safeMint(
1084         address to,
1085         uint256 quantity,
1086         bytes memory _data
1087     ) internal {
1088         _mint(to, quantity, _data, true);
1089     }
1090 
1091     /**
1092      * @dev Mints `quantity` tokens and transfers them to `to`.
1093      *
1094      * Requirements:
1095      *
1096      * - `to` cannot be the zero address.
1097      * - `quantity` must be greater than 0.
1098      *
1099      * Emits a {Transfer} event.
1100      */
1101     function _mint(
1102         address to,
1103         uint256 quantity,
1104         bytes memory _data,
1105         bool safe
1106     ) internal {
1107         uint256 startTokenId = _currentIndex;
1108         if (to == address(0)) revert MintToZeroAddress();
1109         if (quantity == 0) revert MintZeroQuantity();
1110 
1111         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1112 
1113         // Overflows are incredibly unrealistic.
1114         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1115         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1116         unchecked {
1117             _addressData[to].balance += uint64(quantity);
1118             _addressData[to].numberMinted += uint64(quantity);
1119 
1120             _ownerships[startTokenId].addr = to;
1121             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1122 
1123             uint256 updatedIndex = startTokenId;
1124             uint256 end = updatedIndex + quantity;
1125 
1126             if (safe && to.isContract()) {
1127                 do {
1128                     emit Transfer(address(0), to, updatedIndex);
1129                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1130                         revert TransferToNonERC721ReceiverImplementer();
1131                     }
1132                 } while (updatedIndex != end);
1133                 // Reentrancy protection
1134                 if (_currentIndex != startTokenId) revert();
1135             } else {
1136                 do {
1137                     emit Transfer(address(0), to, updatedIndex++);
1138                 } while (updatedIndex != end);
1139             }
1140             _currentIndex = updatedIndex;
1141         }
1142         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1143     }
1144 
1145     /**
1146      * @dev Transfers `tokenId` from `from` to `to`.
1147      *
1148      * Requirements:
1149      *
1150      * - `to` cannot be the zero address.
1151      * - `tokenId` token must be owned by `from`.
1152      *
1153      * Emits a {Transfer} event.
1154      */
1155     function _transfer(
1156         address from,
1157         address to,
1158         uint256 tokenId
1159     ) private {
1160         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1161 
1162         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1163             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1164             getApproved(tokenId) == _msgSender());
1165 
1166         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1167         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1168         if (to == address(0)) revert TransferToZeroAddress();
1169 
1170         _beforeTokenTransfers(from, to, tokenId, 1);
1171 
1172         // Clear approvals from the previous owner
1173         _approve(address(0), tokenId, prevOwnership.addr);
1174 
1175         // Underflow of the sender's balance is impossible because we check for
1176         // ownership above and the recipient's balance can't realistically overflow.
1177         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1178         unchecked {
1179             _addressData[from].balance -= 1;
1180             _addressData[to].balance += 1;
1181 
1182             _ownerships[tokenId].addr = to;
1183             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1184 
1185             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1186             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1187             uint256 nextTokenId = tokenId + 1;
1188             if (_ownerships[nextTokenId].addr == address(0)) {
1189                 // This will suffice for checking _exists(nextTokenId),
1190                 // as a burned slot cannot contain the zero address.
1191                 if (nextTokenId < _currentIndex) {
1192                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1193                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1194                 }
1195             }
1196         }
1197 
1198         emit Transfer(from, to, tokenId);
1199         _afterTokenTransfers(from, to, tokenId, 1);
1200     }
1201 
1202     /**
1203      * @dev Destroys `tokenId`.
1204      * The approval is cleared when the token is burned.
1205      *
1206      * Requirements:
1207      *
1208      * - `tokenId` must exist.
1209      *
1210      * Emits a {Transfer} event.
1211      */
1212     function _burn(uint256 tokenId) internal virtual {
1213         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1214 
1215         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1216 
1217         // Clear approvals from the previous owner
1218         _approve(address(0), tokenId, prevOwnership.addr);
1219 
1220         // Underflow of the sender's balance is impossible because we check for
1221         // ownership above and the recipient's balance can't realistically overflow.
1222         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1223         unchecked {
1224             _addressData[prevOwnership.addr].balance -= 1;
1225             _addressData[prevOwnership.addr].numberBurned += 1;
1226 
1227             // Keep track of who burned the token, and the timestamp of burning.
1228             _ownerships[tokenId].addr = prevOwnership.addr;
1229             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1230             _ownerships[tokenId].burned = true;
1231 
1232             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1233             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1234             uint256 nextTokenId = tokenId + 1;
1235             if (_ownerships[nextTokenId].addr == address(0)) {
1236                 // This will suffice for checking _exists(nextTokenId),
1237                 // as a burned slot cannot contain the zero address.
1238                 if (nextTokenId < _currentIndex) {
1239                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1240                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1241                 }
1242             }
1243         }
1244 
1245         emit Transfer(prevOwnership.addr, address(0), tokenId);
1246         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1247 
1248         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1249         unchecked {
1250             _burnCounter++;
1251         }
1252     }
1253 
1254     /**
1255      * @dev Approve `to` to operate on `tokenId`
1256      *
1257      * Emits a {Approval} event.
1258      */
1259     function _approve(
1260         address to,
1261         uint256 tokenId,
1262         address owner
1263     ) private {
1264         _tokenApprovals[tokenId] = to;
1265         emit Approval(owner, to, tokenId);
1266     }
1267 
1268     /**
1269      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1270      *
1271      * @param from address representing the previous owner of the given token ID
1272      * @param to target address that will receive the tokens
1273      * @param tokenId uint256 ID of the token to be transferred
1274      * @param _data bytes optional data to send along with the call
1275      * @return bool whether the call correctly returned the expected magic value
1276      */
1277     function _checkContractOnERC721Received(
1278         address from,
1279         address to,
1280         uint256 tokenId,
1281         bytes memory _data
1282     ) private returns (bool) {
1283         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1284             return retval == IERC721Receiver(to).onERC721Received.selector;
1285         } catch (bytes memory reason) {
1286             if (reason.length == 0) {
1287                 revert TransferToNonERC721ReceiverImplementer();
1288             } else {
1289                 assembly {
1290                     revert(add(32, reason), mload(reason))
1291                 }
1292             }
1293         }
1294     }
1295 
1296     /**
1297      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1298      * And also called before burning one token.
1299      *
1300      * startTokenId - the first token id to be transferred
1301      * quantity - the amount to be transferred
1302      *
1303      * Calling conditions:
1304      *
1305      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1306      * transferred to `to`.
1307      * - When `from` is zero, `tokenId` will be minted for `to`.
1308      * - When `to` is zero, `tokenId` will be burned by `from`.
1309      * - `from` and `to` are never both zero.
1310      */
1311     function _beforeTokenTransfers(
1312         address from,
1313         address to,
1314         uint256 startTokenId,
1315         uint256 quantity
1316     ) internal virtual {}
1317 
1318     /**
1319      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1320      * minting.
1321      * And also called after one token has been burned.
1322      *
1323      * startTokenId - the first token id to be transferred
1324      * quantity - the amount to be transferred
1325      *
1326      * Calling conditions:
1327      *
1328      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1329      * transferred to `to`.
1330      * - When `from` is zero, `tokenId` has been minted for `to`.
1331      * - When `to` is zero, `tokenId` has been burned by `from`.
1332      * - `from` and `to` are never both zero.
1333      */
1334     function _afterTokenTransfers(
1335         address from,
1336         address to,
1337         uint256 startTokenId,
1338         uint256 quantity
1339     ) internal virtual {}
1340 }
1341 /***
1342  *    ██████╗  █████╗ ██╗   ██╗███╗   ███╗███████╗███╗   ██╗████████╗
1343  *    ██╔══██╗██╔══██╗╚██╗ ██╔╝████╗ ████║██╔════╝████╗  ██║╚══██╔══╝
1344  *    ██████╔╝███████║ ╚████╔╝ ██╔████╔██║█████╗  ██╔██╗ ██║   ██║
1345  *    ██╔═══╝ ██╔══██║  ╚██╔╝  ██║╚██╔╝██║██╔══╝  ██║╚██╗██║   ██║
1346  *    ██║     ██║  ██║   ██║   ██║ ╚═╝ ██║███████╗██║ ╚████║   ██║
1347  *    ╚═╝     ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝
1348  *
1349  *    ███████╗██████╗ ██╗     ██╗████████╗████████╗███████╗██████╗
1350  *    ██╔════╝██╔══██╗██║     ██║╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗
1351  *    ███████╗██████╔╝██║     ██║   ██║      ██║   █████╗  ██████╔╝
1352  *    ╚════██║██╔═══╝ ██║     ██║   ██║      ██║   ██╔══╝  ██╔══██╗
1353  *    ███████║██║     ███████╗██║   ██║      ██║   ███████╗██║  ██║
1354  *    ╚══════╝╚═╝     ╚══════╝╚═╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝
1355  * Re-write of @openzeppelin/contracts/finance/PaymentSplitter.sol
1356  *
1357  *
1358  * Edits the release functionality to force release to all addresses added
1359  * as payees.
1360  */
1361 
1362 
1363 
1364 pragma solidity ^0.8.0;
1365 
1366 
1367 
1368 error ZeroBalance();
1369 error AddressAlreadyAssigned();
1370 error InvalidShares();
1371 error SharesToZeroAddress();
1372 
1373 /**
1374  * @title PaymentSplitter
1375  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
1376  * that the Ether will be split in this way, since it is handled transparently by the contract.
1377  *
1378  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
1379  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
1380  * an amount proportional to the percentage of total shares they were assigned.
1381  *
1382  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
1383  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
1384  * function.
1385  */
1386 
1387 abstract contract PaymentSplitter is Context {
1388     using Counters for Counters.Counter;
1389     Counters.Counter private _numPayees;
1390 
1391     event PayeeAdded(address account, uint256 shares);
1392     event PaymentReleased(address to, uint256 amount);
1393     event PaymentReceived(address from, uint256 amount);
1394 
1395     uint256 private _totalShares;
1396     uint256 private _totalReleased;
1397     mapping(address => uint256) private _shares;
1398     mapping(address => uint256) private _released;
1399     address[] private _payees;
1400 
1401     /**
1402      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1403      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1404      * reliability of the events, and not the actual splitting of Ether.
1405      *
1406      * To learn more about this see the Solidity documentation for
1407      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1408      * functions].
1409      *
1410      *  receive() external payable virtual {
1411      *    emit PaymentReceived(_msgSender(), msg.value);
1412      *  }
1413      *
1414      *  // Fallback function is called when msg.data is not empty
1415      *  // Added to PaymentSplitter.sol
1416      *  fallback() external payable {
1417      *    emit PaymentReceived(_msgSender(), msg.value);
1418      *  }
1419      *
1420      * receive() and fallback() to be handled at final contract
1421      */
1422 
1423     /**
1424      * @dev Getter for the total shares held by payees.
1425      */
1426     function totalShares() public view returns (uint256) {
1427         return _totalShares;
1428     }
1429 
1430     /**
1431      * @dev Getter for the total amount of Ether already released.
1432      */
1433     function totalReleased() public view returns (uint256) {
1434         return _totalReleased;
1435     }
1436 
1437     /**
1438      * @dev Getter for the amount of shares held by an account.
1439      */
1440     function shares(address account) public view returns (uint256) {
1441         return _shares[account];
1442     }
1443 
1444     /**
1445      * @dev Getter for the amount of Ether already released to a payee.
1446      */
1447     function released(address account) public view returns (uint256) {
1448         return _released[account];
1449     }
1450 
1451     /**
1452      * @dev Getter for the address of the payee number `index`.
1453      */
1454     function payee(uint256 index) public view returns (address) {
1455         return _payees[index];
1456     }
1457 
1458     /**
1459      * @dev Releases contract balance to the addresses that are owed funds.
1460      */
1461     function _release() internal {
1462         if (address(this).balance == 0) revert ZeroBalance();
1463         for (uint256 i = 0; i < _numPayees.current(); i++) {
1464             address account = payee(i);
1465             uint256 totalReceived = address(this).balance + _totalReleased;
1466             uint256 payment = (totalReceived * _shares[account]) /
1467                 _totalShares -
1468                 _released[account];
1469             _released[account] = _released[account] + payment;
1470             _totalReleased = _totalReleased + payment;
1471             Address.sendValue(payable(account), payment);
1472             emit PaymentReleased(account, payment);
1473         }
1474     }
1475 
1476     /**
1477      * @dev Add a new payee to the contract.
1478      * @param account The address of the payee to add.
1479      * @param shares_ The number of shares to assign the payee.
1480      */
1481     function _addPayee(address account, uint256 shares_) internal {
1482         if (account == address(0)) revert SharesToZeroAddress();
1483         if (shares_ <= 0) revert InvalidShares();
1484         if (_shares[account] != 0) revert AddressAlreadyAssigned();
1485         _numPayees.increment();
1486         _payees.push(account);
1487         _shares[account] = shares_;
1488         _totalShares = _totalShares + shares_;
1489         emit PayeeAdded(account, shares_);
1490     }
1491 }
1492 /***
1493  *    ███████╗██╗██████╗       ██████╗  █████╗  █████╗  ██╗
1494  *    ██╔════╝██║██╔══██╗      ╚════██╗██╔══██╗██╔══██╗███║
1495  *    █████╗  ██║██████╔╝█████╗ █████╔╝╚██████║╚█████╔╝╚██║
1496  *    ██╔══╝  ██║██╔═══╝ ╚════╝██╔═══╝  ╚═══██║██╔══██╗ ██║
1497  *    ███████╗██║██║           ███████╗ █████╔╝╚█████╔╝ ██║
1498  *    ╚══════╝╚═╝╚═╝           ╚══════╝ ╚════╝  ╚════╝  ╚═╝                                                        
1499  * Zach Burks, James Morgan, Blaine Malone, James Seibel,
1500  * "EIP-2981: NFT Royalty Standard,"
1501  * Ethereum Improvement Proposals, no. 2981, September 2020. [Online serial].
1502  * Available: https://eips.ethereum.org/EIPS/eip-2981.
1503  *
1504  */
1505 
1506 
1507 
1508 pragma solidity >=0.8.0 <0.9.0;
1509 
1510 ///
1511 /// @dev Interface for the NFT Royalty Standard
1512 ///
1513 
1514 interface IERC2981 is IERC165 {
1515 
1516   // @notice Called with the sale price to determine how much royalty
1517   //  is owed and to whom.
1518   // @param _tokenId - the NFT asset queried for royalty information
1519   // @param _salePrice - the sale price of the NFT asset specified by _tokenId
1520   // @return receiver - address of who should be sent the royalty payment
1521   // @return royaltyAmount - the royalty payment amount for _salePrice
1522   function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (address receiver, uint256 royaltyAmount);
1523 
1524 }
1525 /***
1526  *    ███████╗██████╗  ██████╗██████╗  █████╗  █████╗  ██╗                            
1527  *    ██╔════╝██╔══██╗██╔════╝╚════██╗██╔══██╗██╔══██╗███║                            
1528  *    █████╗  ██████╔╝██║      █████╔╝╚██████║╚█████╔╝╚██║                            
1529  *    ██╔══╝  ██╔══██╗██║     ██╔═══╝  ╚═══██║██╔══██╗ ██║                            
1530  *    ███████╗██║  ██║╚██████╗███████╗ █████╔╝╚█████╔╝ ██║                            
1531  *    ╚══════╝╚═╝  ╚═╝ ╚═════╝╚══════╝ ╚════╝  ╚════╝  ╚═╝                            
1532  *                                                                                    
1533  *     ██████╗ ██████╗ ██╗     ██╗     ███████╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗
1534  *    ██╔════╝██╔═══██╗██║     ██║     ██╔════╝██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║
1535  *    ██║     ██║   ██║██║     ██║     █████╗  ██║        ██║   ██║██║   ██║██╔██╗ ██║
1536  *    ██║     ██║   ██║██║     ██║     ██╔══╝  ██║        ██║   ██║██║   ██║██║╚██╗██║
1537  *    ╚██████╗╚██████╔╝███████╗███████╗███████╗╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║
1538  *     ╚═════╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
1539  * 
1540  * 
1541  *
1542  * Designed to allow setting a global royalty address along with specified basis points. 
1543  */
1544 
1545 
1546 
1547 pragma solidity >=0.8.0 <0.9.0;
1548 
1549 
1550 abstract contract ERC2981Collection is IERC2981 {
1551 
1552   address private royaltyAddress;
1553   uint256 private royaltyPercent;
1554 
1555   function _setRoyalties(address _receiver, uint256 _percentage) internal {
1556     royaltyAddress = _receiver;
1557     royaltyPercent = _percentage;
1558   }
1559 
1560   // Override for royaltyInfo(uint256, uint256)
1561   function royaltyInfo(
1562     uint256 _tokenId,
1563     uint256 _salePrice
1564   ) external view override(IERC2981) returns (
1565     address receiver,
1566     uint256 royaltyAmount
1567   ) {
1568     receiver = royaltyAddress;
1569 
1570     // This sets percentages by price * percentage / 100
1571     royaltyAmount = _salePrice * royaltyPercent / 100;
1572   }
1573 }
1574 /***
1575  *     ██████╗ ██╗    ██╗███╗   ██╗ █████╗ ██████╗ ██╗     ███████╗
1576  *    ██╔═══██╗██║    ██║████╗  ██║██╔══██╗██╔══██╗██║     ██╔════╝
1577  *    ██║   ██║██║ █╗ ██║██╔██╗ ██║███████║██████╔╝██║     █████╗  
1578  *    ██║   ██║██║███╗██║██║╚██╗██║██╔══██║██╔══██╗██║     ██╔══╝  
1579  *    ╚██████╔╝╚███╔███╔╝██║ ╚████║██║  ██║██████╔╝███████╗███████╗
1580  *     ╚═════╝  ╚══╝╚══╝ ╚═╝  ╚═══╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝
1581  * Re-write of @openzeppelin/contracts/access/Ownable.sol
1582  * 
1583  *
1584  * Upgraded to push/pull and decline compared to original contract
1585  */
1586 
1587 
1588 // OpenZeppelin Contracts v4.4.1
1589 // Rewritten for onlyOwner modifier
1590 
1591 pragma solidity ^0.8.0;
1592 
1593 
1594 /**
1595  * @dev Contract module which provides a basic access control mechanism, where
1596  * there is an account (a owner) that can be granted exclusive access to
1597  * specific functions.
1598  *
1599  * By default, the Owner account will be the one that deploys the contract. This
1600  * can later be changed with {transferOwner}.
1601  *
1602  * This module is used through inheritance. It will make available the modifier
1603  * `onlyOwner`, which can be applied to your functions to restrict their use to
1604  * the Owner.
1605  */
1606 
1607 abstract contract Ownable is Context {
1608 
1609     address private _Owner;
1610     address private _newOwner;
1611 
1612     event OwnerTransferred(address indexed previousOwner, address indexed newOwner);
1613 
1614     /**
1615      * @dev Initializes the contract setting the deployer as the initial Owner.
1616      */
1617     constructor() {
1618         _transferOwner(_msgSender());
1619     }
1620 
1621     /**
1622      * @dev Returns the address of the current Owner.
1623      */
1624     function owner() public view virtual returns (address) {
1625         return _Owner;
1626     }
1627 
1628     /**
1629      * @dev Throws if called by any account other than the Owner.
1630      */
1631     modifier onlyOwner() {
1632         require(owner() == _msgSender(), "Owner: caller is not the Owner");
1633         _;
1634     }
1635 
1636     /**
1637      * @dev Leaves the contract without Owner. It will not be possible to call
1638      * `onlyOwner` functions anymore. Can only be called by the current Owner.
1639      *
1640      * NOTE: Renouncing Ownership will leave the contract without an Owner,
1641      * thereby removing any functionality that is only available to the Owner.
1642      */
1643     function renounceOwner() public virtual onlyOwner {
1644         _transferOwner(address(0));
1645     }
1646 
1647     /**
1648      * @dev Transfers Owner of the contract to a new account (`newOwner`).
1649      * Can only be called by the current Owner. Now push/pull.
1650      */
1651     function transferOwner(address newOwner) public virtual onlyOwner {
1652         require(newOwner != address(0), "Owner: new Owner is the zero address");
1653         _newOwner = newOwner;
1654     }
1655 
1656     /**
1657      * @dev Accepts Transfer Owner of the contract to a new account (`newOwner`).
1658      * Can only be called by the new Owner. Pull Accepted.
1659      */
1660     function acceptOwner() public virtual {
1661         require(_newOwner == _msgSender(), "New Owner: new Owner is the only caller");
1662         _transferOwner(_newOwner);
1663     }
1664 
1665     /**
1666      * @dev Declines Transfer Owner of the contract to a new account (`newOwner`).
1667      * Can only be called by the new Owner. Pull Declined.
1668      */
1669     function declineOwner() public virtual {
1670         require(_newOwner == _msgSender(), "New Owner: new Owner is the only caller");
1671         _newOwner = address(0);
1672     }
1673 
1674     /**
1675      * @dev Transfers Owner of the contract to a new account (`newOwner`).
1676      * Can only be called by the current Owner. Now push only. Orginal V1 style
1677      */
1678     function pushOwner(address newOwner) public virtual onlyOwner {
1679         require(newOwner != address(0), "Owner: new Owner is the zero address");
1680         _transferOwner(newOwner);
1681     }
1682 
1683     /**
1684      * @dev Transfers Owner of the contract to a new account (`newOwner`).
1685      * Internal function without access restriction.
1686      */
1687     function _transferOwner(address newOwner) internal virtual {
1688         address oldOwner = _Owner;
1689         _Owner = newOwner;
1690         emit OwnerTransferred(oldOwner, newOwner);
1691     }
1692 }
1693 /***
1694  *    ░█████╗░░█████╗░███╗░░██╗██████╗░██╗░░░██╗  ░█████╗░██████╗░███████╗░█████╗░████████╗░█████╗░██████╗░
1695  *    ██╔══██╗██╔══██╗████╗░██║██╔══██╗╚██╗░██╔╝  ██╔══██╗██╔══██╗██╔════╝██╔══██╗╚══██╔══╝██╔══██╗██╔══██╗
1696  *    ██║░░╚═╝███████║██╔██╗██║██║░░██║░╚████╔╝░  ██║░░╚═╝██████╔╝█████╗░░███████║░░░██║░░░██║░░██║██████╔╝
1697  *    ██║░░██╗██╔══██║██║╚████║██║░░██║░░╚██╔╝░░  ██║░░██╗██╔══██╗██╔══╝░░██╔══██║░░░██║░░░██║░░██║██╔══██╗
1698  *    ╚█████╔╝██║░░██║██║░╚███║██████╔╝░░░██║░░░  ╚█████╔╝██║░░██║███████╗██║░░██║░░░██║░░░╚█████╔╝██║░░██║
1699  *    ░╚════╝░╚═╝░░╚═╝╚═╝░░╚══╝╚═════╝░░░░╚═╝░░░  ░╚════╝░╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝░░░╚═╝░░░░╚════╝░╚═╝░░╚═╝
1700  *
1701  *
1702  *
1703  *
1704  *  “Growing up, I slowly had this process of realizing that all the things around me that people had told me
1705  *  were just the natural way things were, the way things always would be, they weren’t natural at all.
1706  *  They were things that could be changed, and they were things that, more importantly, were wrong and should change,
1707  *  and once I realized that, there was really no going back.”
1708  *
1709  *    ― Aaron Swartz (1986-2013)
1710  *
1711  *
1712  * Version: VARIANT_BASE_NOTPROV_NOTAIRDROP_ERC721A_NOTENUMERABLE_CONTEXTV2
1713  *          v2.0
1714  *
1715  * Purpose: ERC-721 template for no-code users.
1716  *          Placeholder for pre-reveal information.
1717  *          Guaranteed mint royalties with PaymentSplitter.
1718  *          EIP-2981 compliant secondary sale royalty information.
1719  *          Whitelist functionality. Caps whitelist users and invalidates whitelist users after mint.
1720  *          Deployable to ETH, AVAX, BNB, MATIC, FANTOM chains.
1721  *
1722  */
1723 
1724 
1725 
1726 pragma solidity >=0.8.4 <0.9.0;
1727 
1728 
1729 
1730 error MintingNotActive();
1731 error MintingActive();
1732 error WouldExceedMintSize();
1733 error ExceedsMaxTransactionMints();
1734 error NonExistentToken();
1735 error WhitelistNotRequired();
1736 error WhitelistRequired();
1737 error NotWhitelisted();
1738 error NotEnoughWhitelistSlots();
1739 error ExceedsMaxWhitelistMints();
1740 error WrongPayment();
1741 error InvalidMintSize();
1742 
1743 contract CandyCreatorV1A is
1744     ERC721A,
1745     ERC2981Collection,
1746     PaymentSplitter,
1747     Ownable
1748 {
1749     // @notice basic state variables
1750     string private base;
1751     bool private mintingActive;
1752     bool private lockedPayees;
1753     uint256 private maxPublicMints;
1754     uint256 private mintPrice;
1755     uint256 private mintSize;
1756     string private placeholderURI;
1757 
1758     // @notice Whitelist functionality
1759     bool private whitelistActive;
1760     bytes32 public whitelistMerkleRoot;
1761     uint64 private maxWhitelistMints;
1762 
1763     event UpdatedMintPrice(uint256 _old, uint256 _new);
1764     event UpdatedMintSize(uint256 _old, uint256 _new);
1765     event UpdatedMaxWhitelistMints(uint256 _old, uint256 _new);
1766     event UpdatedMaxPublicMints(uint256 _old, uint256 _new);
1767     event UpdatedMintStatus(bool _old, bool _new);
1768     event UpdatedRoyalties(address newRoyaltyAddress, uint256 newPercentage);
1769     event UpdatedWhitelistStatus(bool _old, bool _new);
1770     event UpdatedPresaleEnd(uint256 _old, uint256 _new);
1771     event PayeesLocked(bool _status);
1772     event UpdatedWhitelist(bytes32 _old, bytes32 _new);
1773 
1774     // @notice Contract constructor requires as much information
1775     // about the contract as possible to avoid unnecessary function calls
1776     // on the contract post-deployment.
1777     constructor(
1778         string memory name,
1779         string memory symbol,
1780         string memory _placeholderURI,
1781         uint256 _mintPrice,
1782         uint256 _mintSize,
1783         address _candyWallet,
1784         bool _multi,
1785         address[] memory splitAddresses,
1786         uint256[] memory splitShares,
1787         bytes32 _whitelistMerkleRoot
1788     ) ERC721A(name, symbol) {
1789         placeholderURI = _placeholderURI;
1790         maxWhitelistMints = 2;
1791         maxPublicMints = 2;
1792         mintPrice = _mintPrice;
1793         mintSize = _mintSize;
1794         
1795         if (_whitelistMerkleRoot != 0) {
1796             whitelistMerkleRoot = _whitelistMerkleRoot;
1797             enableWhitelist();
1798         }
1799         
1800         addPayee(_candyWallet, 500);
1801         if (!_multi) {
1802             addPayee(_msgSender(), 9500);
1803             lockPayees();
1804         } else {
1805             for (uint256 i = 0; i < splitAddresses.length; i++) {
1806                 addPayee(splitAddresses[i], splitShares[i]);
1807             }
1808             lockPayees();
1809         }
1810     }
1811 
1812     /***
1813      *    ███╗   ███╗██╗███╗   ██╗████████╗
1814      *    ████╗ ████║██║████╗  ██║╚══██╔══╝
1815      *    ██╔████╔██║██║██╔██╗ ██║   ██║
1816      *    ██║╚██╔╝██║██║██║╚██╗██║   ██║
1817      *    ██║ ╚═╝ ██║██║██║ ╚████║   ██║
1818      *    ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝   ╚═╝
1819      */
1820 
1821     // @notice this is the mint function, mint Fees in ERC20,
1822     //  requires amount * mintPrice to be sent by caller
1823     // @param uint amount - number of tokens minted
1824     function whitelistMint(bytes32[] calldata merkleProof, uint64 amount)
1825         external
1826         payable
1827     {
1828         // @notice using Checks-Effects-Interactions
1829         if (!mintingActive) revert MintingNotActive();
1830         if (!whitelistActive) revert WhitelistNotRequired();
1831         if (_msgValue() != mintPrice * amount) revert WrongPayment();
1832         if (totalSupply() + amount > mintSize) revert WouldExceedMintSize();
1833         if (amount > maxWhitelistMints) revert ExceedsMaxWhitelistMints();
1834         if (
1835             !MerkleProof.verify(
1836                 merkleProof,
1837                 whitelistMerkleRoot,
1838                 keccak256(abi.encodePacked(_msgSender()))
1839             )
1840         ) revert NotWhitelisted();
1841         uint64 numWhitelistMinted = _getAux(_msgSender()) + amount;
1842         if (numWhitelistMinted > maxWhitelistMints)
1843             revert NotEnoughWhitelistSlots();
1844         _safeMint(_msgSender(), amount);
1845         _setAux(_msgSender(), numWhitelistMinted);
1846     }
1847 
1848     // @notice this is the mint function, mint Fees in ERC20,
1849     //  requires amount * mintPrice to be sent by caller
1850     // @param uint amount - number of tokens minted
1851     function publicMint(uint256 amount) external payable {
1852         if (whitelistActive) revert WhitelistRequired();
1853         if (!mintingActive) revert MintingNotActive();
1854         if (_msgValue() != mintPrice * amount) revert WrongPayment();
1855         if (totalSupply() + amount > mintSize) revert WouldExceedMintSize();
1856         if (amount > maxPublicMints) revert ExceedsMaxTransactionMints();
1857         _safeMint(_msgSender(), amount);
1858     }
1859 
1860     /***
1861      *    ██████╗░░█████╗░██╗░░░██╗███╗░░░███╗███████╗███╗░░██╗████████╗
1862      *    ██╔══██╗██╔══██╗╚██╗░██╔╝████╗░████║██╔════╝████╗░██║╚══██╔══╝
1863      *    ██████╔╝███████║░╚████╔╝░██╔████╔██║█████╗░░██╔██╗██║░░░██║░░░
1864      *    ██╔═══╝░██╔══██║░░╚██╔╝░░██║╚██╔╝██║██╔══╝░░██║╚████║░░░██║░░░
1865      *    ██║░░░░░██║░░██║░░░██║░░░██║░╚═╝░██║███████╗██║░╚███║░░░██║░░░
1866      *    ╚═╝░░░░░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░░░░╚═╝╚══════╝╚═╝░░╚══╝░░░╚═╝░░░
1867      * This section pertains to mint fees, royalties, and fund release.
1868      */
1869 
1870     // Function to receive ether, msg.data must be empty
1871     receive() external payable {
1872         // From PaymentSplitter.sol
1873         emit PaymentReceived(_msgSender(), _msgValue());
1874     }
1875 
1876     // Function to receive ether, msg.data is not empty
1877     fallback() external payable {
1878         // From PaymentSplitter.sol
1879         emit PaymentReceived(_msgSender(), _msgValue());
1880     }
1881 
1882     // @notice will release funds from the contract to the addresses
1883     // owed funds as passed to constructor
1884     function release() external onlyOwner {
1885         _release();
1886     }
1887 
1888     // @notice this will use internal functions to set EIP 2981
1889     //  found in IERC2981.sol and used by ERC2981Collections.sol
1890     // @param address _royaltyAddress - Address for all royalties to go to
1891     // @param uint256 _percentage - Precentage in whole number of comission
1892     //  of secondary sales
1893     function setRoyaltyInfo(address _royaltyAddress, uint256 _percentage)
1894         public
1895         onlyOwner
1896     {
1897         _setRoyalties(_royaltyAddress, _percentage);
1898         emit UpdatedRoyalties(_royaltyAddress, _percentage);
1899     }
1900 
1901     // @notice this will set the fees required to mint using
1902     //  publicMint(), must enter in wei. So 1 ETH = 10**18.
1903     // @param uint256 _newFee - fee you set, if ETH 10**18, if
1904     //  an ERC20 use token's decimals in calculation
1905     function setMintPrice(uint256 _newFee) public onlyOwner {
1906         uint256 oldFee = mintPrice;
1907         mintPrice = _newFee;
1908         emit UpdatedMintPrice(oldFee, mintPrice);
1909     }
1910 
1911     // @notice will add an address to PaymentSplitter by owner role
1912     // @param address newAddy - address to recieve payments
1913     // @param uint newShares - number of shares they recieve
1914     function addPayee(address newAddy, uint256 newShares) private {
1915         require(!lockedPayees, "Can not set, payees locked");
1916         _addPayee(newAddy, newShares);
1917     }
1918 
1919     // @notice Will lock the ability to add further payees on PaymentSplitter.sol
1920     function lockPayees() private {
1921         require(!lockedPayees, "Can not set, payees locked");
1922         lockedPayees = true;
1923         emit PayeesLocked(lockedPayees);
1924     }
1925 
1926     /***
1927      *
1928      *    ░█████╗░██████╗░███╗░░░███╗██╗███╗░░██╗
1929      *    ██╔══██╗██╔══██╗████╗░████║██║████╗░██║
1930      *    ███████║██║░░██║██╔████╔██║██║██╔██╗██║
1931      *    ██╔══██║██║░░██║██║╚██╔╝██║██║██║╚████║
1932      *    ██║░░██║██████╔╝██║░╚═╝░██║██║██║░╚███║
1933      *    ╚═╝░░╚═╝╚═════╝░╚═╝░░░░░╚═╝╚═╝╚═╝░░╚══╝
1934      * This section pertains to to basic contract administration tasks.
1935      */
1936 
1937     // @notice this will enable publicMint()
1938     function enableMinting() external onlyOwner {
1939         if (mintingActive) revert MintingActive();
1940         bool old = mintingActive;
1941         mintingActive = true;
1942         emit UpdatedMintStatus(old, mintingActive);
1943     }
1944 
1945     // @notice this will disable publicMint()
1946     function disableMinting() external onlyOwner {
1947         if (!mintingActive) revert MintingNotActive();
1948         bool old = mintingActive;
1949         mintingActive = false;
1950         emit UpdatedMintStatus(old, mintingActive);
1951     }
1952 
1953     // @notice this will enable whitelist or "if" in publicMint()
1954     function enableWhitelist() public onlyOwner {
1955         if (whitelistActive) revert WhitelistRequired();
1956         bool old = whitelistActive;
1957         whitelistActive = true;
1958         emit UpdatedWhitelistStatus(old, whitelistActive);
1959     }
1960 
1961     // @notice this will disable whitelist or "else" in publicMint()
1962     function disableWhitelist() external onlyOwner {
1963         if (!whitelistActive) revert WhitelistNotRequired();
1964         bool old = whitelistActive;
1965         whitelistActive = false;
1966         emit UpdatedWhitelistStatus(old, whitelistActive);
1967     }
1968 
1969     // @notice this will set a new Merkle root used to verify whitelist membership
1970     // together with a proof submitted to the mint function
1971     // @param bytes32 _merkleRoot - generated merkleRoot hash
1972     function setWhitelistMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1973         bytes32 old = whitelistMerkleRoot;
1974         whitelistMerkleRoot = _merkleRoot;
1975         emit UpdatedWhitelist(old, whitelistMerkleRoot);
1976     }
1977 
1978     // @notice this will set the maximum number of tokens a whitelisted user can mint.
1979     // @param uint256 _amount - max amount of tokens
1980     function setMaxWhitelistMints(uint64 _amount) public onlyOwner {
1981         uint256 oldAmount = maxWhitelistMints;
1982         maxWhitelistMints = _amount;
1983         emit UpdatedMaxWhitelistMints(oldAmount, maxWhitelistMints);
1984     }
1985 
1986     // @notice this will set the maximum number of tokens a single address can mint at a time
1987     // during the public mint period. Keep in mind that user will be able to transfer their tokens
1988     // to a different address, and continue minting this amount of tokens on each transaction.
1989     // If you wish to prevent this, use the whitelist.
1990     // @param uint256 _amount - max amount of tokens
1991     function setMaxPublicMints(uint256 _amount) public onlyOwner {
1992         uint256 oldAmount = maxPublicMints;
1993         maxPublicMints = _amount;
1994         emit UpdatedMaxPublicMints(oldAmount, maxWhitelistMints);
1995     }
1996 
1997     // @notice this updates the base URI for the token metadata
1998     // it does not emit an event so that it can be set invisibly to purchasers
1999     // and avoid token sniping
2000     // @param string _ - max amount of tokens
2001     function setBaseURI(string memory baseURI) public onlyOwner {
2002         base = baseURI;
2003     }
2004 
2005     // @notice will set mint size by owner role
2006     // @param uint256 _amount - set number to mint
2007     function setMintSize(uint256 _amount) public onlyOwner {
2008         if (_amount < totalSupply()) revert InvalidMintSize();
2009         uint256 old = mintSize;
2010         mintSize = _amount;
2011         emit UpdatedMintSize(old, mintSize);
2012     }
2013 
2014     /***
2015      *    ██████╗░██╗░░░██╗██████╗░██╗░░░░░██╗░█████╗░  ██╗░░░██╗██╗███████╗░██╗░░░░░░░██╗░██████╗
2016      *    ██╔══██╗██║░░░██║██╔══██╗██║░░░░░██║██╔══██╗  ██║░░░██║██║██╔════╝░██║░░██╗░░██║██╔════╝
2017      *    ██████╔╝██║░░░██║██████╦╝██║░░░░░██║██║░░╚═╝  ╚██╗░██╔╝██║█████╗░░░╚██╗████╗██╔╝╚█████╗░
2018      *    ██╔═══╝░██║░░░██║██╔══██╗██║░░░░░██║██║░░██╗  ░╚████╔╝░██║██╔══╝░░░░████╔═████║░░╚═══██╗
2019      *    ██║░░░░░╚██████╔╝██████╦╝███████╗██║╚█████╔╝  ░░╚██╔╝░░██║███████╗░░╚██╔╝░╚██╔╝░██████╔╝
2020      *    ╚═╝░░░░░░╚═════╝░╚═════╝░╚══════╝╚═╝░╚════╝░  ░░░╚═╝░░░╚═╝╚══════╝░░░╚═╝░░░╚═╝░░╚═════╝░
2021      */
2022     // @notice will return whether minting is enabled
2023     function mintStatus() external view returns (bool) {
2024         return mintingActive;
2025     }
2026 
2027     // @notice will return whitelist status of Minter
2028     function whitelistStatus() external view returns (bool) {
2029         return whitelistActive;
2030     }
2031 
2032     // @notice will return minting fees
2033     function mintingFee() external view returns (uint256) {
2034         return mintPrice;
2035     }
2036 
2037     // @notice will return whitelist status of Minter
2038     function whitelistMaxMints() external view returns (uint256) {
2039         return maxWhitelistMints;
2040     }
2041 
2042     // @notice will return maximum tokens that are allowed to be minted during a single transaction
2043     // during the whitelist period
2044     function publicMaxMints() external view returns (uint256) {
2045         return maxPublicMints;
2046     }
2047 
2048     // @notice this is a public getter for ETH balance on contract
2049     function getBalance() external view returns (uint256) {
2050         return address(this).balance;
2051     }
2052 
2053     // @notice will return the planned size of the collection
2054     function collectionSize() external view returns (uint256) {
2055         return mintSize;
2056     }
2057 
2058     /***
2059      *    ░█████╗░██╗░░░██╗███████╗██████╗░██████╗░██╗██████╗░███████╗
2060      *    ██╔══██╗██║░░░██║██╔════╝██╔══██╗██╔══██╗██║██╔══██╗██╔════╝
2061      *    ██║░░██║╚██╗░██╔╝█████╗░░██████╔╝██████╔╝██║██║░░██║█████╗░░
2062      *    ██║░░██║░╚████╔╝░██╔══╝░░██╔══██╗██╔══██╗██║██║░░██║██╔══╝░░
2063      *    ╚█████╔╝░░╚██╔╝░░███████╗██║░░██║██║░░██║██║██████╔╝███████╗
2064      *    ░╚════╝░░░░╚═╝░░░╚══════╝╚═╝░░╚═╝╚═╝░░╚═╝╚═╝╚═════╝░╚══════╝
2065      */
2066 
2067     // @notice Solidity required override for _baseURI(), if you wish to
2068     //  be able to set from API -> IPFS or vice versa using setBaseURI(string)
2069     function _baseURI() internal view override returns (string memory) {
2070         return base;
2071     }
2072 
2073     // @notice Override for ERC721A _startTokenId to change from default 0 -> 1
2074     function _startTokenId() internal pure override returns (uint256) {
2075         return 1;
2076     }
2077 
2078     // @notice Override for ERC721A tokenURI
2079     function tokenURI(uint256 tokenId)
2080         public
2081         view
2082         virtual
2083         override
2084         returns (string memory)
2085     {
2086         if (!_exists(tokenId)) revert NonExistentToken();
2087         string memory baseURI = _baseURI();
2088         return
2089             bytes(baseURI).length > 0
2090                 ? string(
2091                     abi.encodePacked(
2092                         baseURI,
2093                         "/",
2094                         Strings.toString(tokenId),
2095                         ".json"
2096                     )
2097                 )
2098                 : placeholderURI;
2099     }
2100 
2101     // @notice solidity required override for supportsInterface(bytes4)
2102     // @param bytes4 interfaceId - bytes4 id per interface or contract
2103     // calculated by ERC165 standards automatically
2104     function supportsInterface(bytes4 interfaceId)
2105         public
2106         view
2107         override(ERC721A, IERC165)
2108         returns (bool)
2109     {
2110         return (interfaceId == type(ERC2981Collection).interfaceId ||
2111             interfaceId == type(PaymentSplitter).interfaceId ||
2112             interfaceId == type(Ownable).interfaceId ||
2113             super.supportsInterface(interfaceId));
2114     }
2115 }