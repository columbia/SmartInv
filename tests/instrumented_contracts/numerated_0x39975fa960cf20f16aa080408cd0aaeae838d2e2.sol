1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 // CAUTION
10 // This version of SafeMath should only be used with Solidity 0.8 or later,
11 // because it relies on the compiler's built in overflow checks.
12 
13 /**
14  * @dev Wrappers over Solidity's arithmetic operations.
15  *
16  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
17  * now has built in overflow checking.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, with an overflow flag.
22      *
23      * _Available since v3.4._
24      */
25     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
26         unchecked {
27             uint256 c = a + b;
28             if (c < a) return (false, 0);
29             return (true, c);
30         }
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
35      *
36      * _Available since v3.4._
37      */
38     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
39         unchecked {
40             if (b > a) return (false, 0);
41             return (true, a - b);
42         }
43     }
44 
45     /**
46      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
47      *
48      * _Available since v3.4._
49      */
50     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
51         unchecked {
52             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
53             // benefit is lost if 'b' is also tested.
54             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
55             if (a == 0) return (true, 0);
56             uint256 c = a * b;
57             if (c / a != b) return (false, 0);
58             return (true, c);
59         }
60     }
61 
62     /**
63      * @dev Returns the division of two unsigned integers, with a division by zero flag.
64      *
65      * _Available since v3.4._
66      */
67     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
68         unchecked {
69             if (b == 0) return (false, 0);
70             return (true, a / b);
71         }
72     }
73 
74     /**
75      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
76      *
77      * _Available since v3.4._
78      */
79     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
80         unchecked {
81             if (b == 0) return (false, 0);
82             return (true, a % b);
83         }
84     }
85 
86     /**
87      * @dev Returns the addition of two unsigned integers, reverting on
88      * overflow.
89      *
90      * Counterpart to Solidity's `+` operator.
91      *
92      * Requirements:
93      *
94      * - Addition cannot overflow.
95      */
96     function add(uint256 a, uint256 b) internal pure returns (uint256) {
97         return a + b;
98     }
99 
100     /**
101      * @dev Returns the subtraction of two unsigned integers, reverting on
102      * overflow (when the result is negative).
103      *
104      * Counterpart to Solidity's `-` operator.
105      *
106      * Requirements:
107      *
108      * - Subtraction cannot overflow.
109      */
110     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
111         return a - b;
112     }
113 
114     /**
115      * @dev Returns the multiplication of two unsigned integers, reverting on
116      * overflow.
117      *
118      * Counterpart to Solidity's `*` operator.
119      *
120      * Requirements:
121      *
122      * - Multiplication cannot overflow.
123      */
124     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
125         return a * b;
126     }
127 
128     /**
129      * @dev Returns the integer division of two unsigned integers, reverting on
130      * division by zero. The result is rounded towards zero.
131      *
132      * Counterpart to Solidity's `/` operator.
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function div(uint256 a, uint256 b) internal pure returns (uint256) {
139         return a / b;
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * reverting when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         return a % b;
156     }
157 
158     /**
159      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
160      * overflow (when the result is negative).
161      *
162      * CAUTION: This function is deprecated because it requires allocating memory for the error
163      * message unnecessarily. For custom revert reasons use {trySub}.
164      *
165      * Counterpart to Solidity's `-` operator.
166      *
167      * Requirements:
168      *
169      * - Subtraction cannot overflow.
170      */
171     function sub(
172         uint256 a,
173         uint256 b,
174         string memory errorMessage
175     ) internal pure returns (uint256) {
176         unchecked {
177             require(b <= a, errorMessage);
178             return a - b;
179         }
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(
195         uint256 a,
196         uint256 b,
197         string memory errorMessage
198     ) internal pure returns (uint256) {
199         unchecked {
200             require(b > 0, errorMessage);
201             return a / b;
202         }
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * reverting with custom message when dividing by zero.
208      *
209      * CAUTION: This function is deprecated because it requires allocating memory for the error
210      * message unnecessarily. For custom revert reasons use {tryMod}.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(
221         uint256 a,
222         uint256 b,
223         string memory errorMessage
224     ) internal pure returns (uint256) {
225         unchecked {
226             require(b > 0, errorMessage);
227             return a % b;
228         }
229     }
230 }
231 
232 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
233 
234 
235 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
236 
237 pragma solidity ^0.8.0;
238 
239 /**
240  * @dev These functions deal with verification of Merkle Trees proofs.
241  *
242  * The proofs can be generated using the JavaScript library
243  * https://github.com/miguelmota/merkletreejs[merkletreejs].
244  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
245  *
246  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
247  *
248  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
249  * hashing, or use a hash function other than keccak256 for hashing leaves.
250  * This is because the concatenation of a sorted pair of internal nodes in
251  * the merkle tree could be reinterpreted as a leaf value.
252  */
253 library MerkleProof {
254     /**
255      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
256      * defined by `root`. For this, a `proof` must be provided, containing
257      * sibling hashes on the branch from the leaf to the root of the tree. Each
258      * pair of leaves and each pair of pre-images are assumed to be sorted.
259      */
260     function verify(
261         bytes32[] memory proof,
262         bytes32 root,
263         bytes32 leaf
264     ) internal pure returns (bool) {
265         return processProof(proof, leaf) == root;
266     }
267 
268     /**
269      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
270      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
271      * hash matches the root of the tree. When processing the proof, the pairs
272      * of leafs & pre-images are assumed to be sorted.
273      *
274      * _Available since v4.4._
275      */
276     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
277         bytes32 computedHash = leaf;
278         for (uint256 i = 0; i < proof.length; i++) {
279             bytes32 proofElement = proof[i];
280             if (computedHash <= proofElement) {
281                 // Hash(current computed hash + current element of the proof)
282                 computedHash = _efficientHash(computedHash, proofElement);
283             } else {
284                 // Hash(current element of the proof + current computed hash)
285                 computedHash = _efficientHash(proofElement, computedHash);
286             }
287         }
288         return computedHash;
289     }
290 
291     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
292         assembly {
293             mstore(0x00, a)
294             mstore(0x20, b)
295             value := keccak256(0x00, 0x40)
296         }
297     }
298 }
299 
300 // File: @openzeppelin/contracts/utils/Strings.sol
301 
302 
303 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
304 
305 pragma solidity ^0.8.0;
306 
307 /**
308  * @dev String operations.
309  */
310 library Strings {
311     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
312 
313     /**
314      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
315      */
316     function toString(uint256 value) internal pure returns (string memory) {
317         // Inspired by OraclizeAPI's implementation - MIT licence
318         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
319 
320         if (value == 0) {
321             return "0";
322         }
323         uint256 temp = value;
324         uint256 digits;
325         while (temp != 0) {
326             digits++;
327             temp /= 10;
328         }
329         bytes memory buffer = new bytes(digits);
330         while (value != 0) {
331             digits -= 1;
332             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
333             value /= 10;
334         }
335         return string(buffer);
336     }
337 
338     /**
339      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
340      */
341     function toHexString(uint256 value) internal pure returns (string memory) {
342         if (value == 0) {
343             return "0x00";
344         }
345         uint256 temp = value;
346         uint256 length = 0;
347         while (temp != 0) {
348             length++;
349             temp >>= 8;
350         }
351         return toHexString(value, length);
352     }
353 
354     /**
355      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
356      */
357     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
358         bytes memory buffer = new bytes(2 * length + 2);
359         buffer[0] = "0";
360         buffer[1] = "x";
361         for (uint256 i = 2 * length + 1; i > 1; --i) {
362             buffer[i] = _HEX_SYMBOLS[value & 0xf];
363             value >>= 4;
364         }
365         require(value == 0, "Strings: hex length insufficient");
366         return string(buffer);
367     }
368 }
369 
370 // File: @openzeppelin/contracts/utils/Address.sol
371 
372 
373 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
374 
375 pragma solidity ^0.8.1;
376 
377 /**
378  * @dev Collection of functions related to the address type
379  */
380 library Address {
381     /**
382      * @dev Returns true if `account` is a contract.
383      *
384      * [IMPORTANT]
385      * ====
386      * It is unsafe to assume that an address for which this function returns
387      * false is an externally-owned account (EOA) and not a contract.
388      *
389      * Among others, `isContract` will return false for the following
390      * types of addresses:
391      *
392      *  - an externally-owned account
393      *  - a contract in construction
394      *  - an address where a contract will be created
395      *  - an address where a contract lived, but was destroyed
396      * ====
397      *
398      * [IMPORTANT]
399      * ====
400      * You shouldn't rely on `isContract` to protect against flash loan attacks!
401      *
402      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
403      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
404      * constructor.
405      * ====
406      */
407     function isContract(address account) internal view returns (bool) {
408         // This method relies on extcodesize/address.code.length, which returns 0
409         // for contracts in construction, since the code is only stored at the end
410         // of the constructor execution.
411 
412         return account.code.length > 0;
413     }
414 
415     /**
416      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
417      * `recipient`, forwarding all available gas and reverting on errors.
418      *
419      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
420      * of certain opcodes, possibly making contracts go over the 2300 gas limit
421      * imposed by `transfer`, making them unable to receive funds via
422      * `transfer`. {sendValue} removes this limitation.
423      *
424      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
425      *
426      * IMPORTANT: because control is transferred to `recipient`, care must be
427      * taken to not create reentrancy vulnerabilities. Consider using
428      * {ReentrancyGuard} or the
429      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
430      */
431     function sendValue(address payable recipient, uint256 amount) internal {
432         require(address(this).balance >= amount, "Address: insufficient balance");
433 
434         (bool success, ) = recipient.call{value: amount}("");
435         require(success, "Address: unable to send value, recipient may have reverted");
436     }
437 
438     /**
439      * @dev Performs a Solidity function call using a low level `call`. A
440      * plain `call` is an unsafe replacement for a function call: use this
441      * function instead.
442      *
443      * If `target` reverts with a revert reason, it is bubbled up by this
444      * function (like regular Solidity function calls).
445      *
446      * Returns the raw returned data. To convert to the expected return value,
447      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
448      *
449      * Requirements:
450      *
451      * - `target` must be a contract.
452      * - calling `target` with `data` must not revert.
453      *
454      * _Available since v3.1._
455      */
456     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
457         return functionCall(target, data, "Address: low-level call failed");
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
462      * `errorMessage` as a fallback revert reason when `target` reverts.
463      *
464      * _Available since v3.1._
465      */
466     function functionCall(
467         address target,
468         bytes memory data,
469         string memory errorMessage
470     ) internal returns (bytes memory) {
471         return functionCallWithValue(target, data, 0, errorMessage);
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
476      * but also transferring `value` wei to `target`.
477      *
478      * Requirements:
479      *
480      * - the calling contract must have an ETH balance of at least `value`.
481      * - the called Solidity function must be `payable`.
482      *
483      * _Available since v3.1._
484      */
485     function functionCallWithValue(
486         address target,
487         bytes memory data,
488         uint256 value
489     ) internal returns (bytes memory) {
490         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
495      * with `errorMessage` as a fallback revert reason when `target` reverts.
496      *
497      * _Available since v3.1._
498      */
499     function functionCallWithValue(
500         address target,
501         bytes memory data,
502         uint256 value,
503         string memory errorMessage
504     ) internal returns (bytes memory) {
505         require(address(this).balance >= value, "Address: insufficient balance for call");
506         require(isContract(target), "Address: call to non-contract");
507 
508         (bool success, bytes memory returndata) = target.call{value: value}(data);
509         return verifyCallResult(success, returndata, errorMessage);
510     }
511 
512     /**
513      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
514      * but performing a static call.
515      *
516      * _Available since v3.3._
517      */
518     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
519         return functionStaticCall(target, data, "Address: low-level static call failed");
520     }
521 
522     /**
523      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
524      * but performing a static call.
525      *
526      * _Available since v3.3._
527      */
528     function functionStaticCall(
529         address target,
530         bytes memory data,
531         string memory errorMessage
532     ) internal view returns (bytes memory) {
533         require(isContract(target), "Address: static call to non-contract");
534 
535         (bool success, bytes memory returndata) = target.staticcall(data);
536         return verifyCallResult(success, returndata, errorMessage);
537     }
538 
539     /**
540      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
541      * but performing a delegate call.
542      *
543      * _Available since v3.4._
544      */
545     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
546         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
551      * but performing a delegate call.
552      *
553      * _Available since v3.4._
554      */
555     function functionDelegateCall(
556         address target,
557         bytes memory data,
558         string memory errorMessage
559     ) internal returns (bytes memory) {
560         require(isContract(target), "Address: delegate call to non-contract");
561 
562         (bool success, bytes memory returndata) = target.delegatecall(data);
563         return verifyCallResult(success, returndata, errorMessage);
564     }
565 
566     /**
567      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
568      * revert reason using the provided one.
569      *
570      * _Available since v4.3._
571      */
572     function verifyCallResult(
573         bool success,
574         bytes memory returndata,
575         string memory errorMessage
576     ) internal pure returns (bytes memory) {
577         if (success) {
578             return returndata;
579         } else {
580             // Look for revert reason and bubble it up if present
581             if (returndata.length > 0) {
582                 // The easiest way to bubble the revert reason is using memory via assembly
583 
584                 assembly {
585                     let returndata_size := mload(returndata)
586                     revert(add(32, returndata), returndata_size)
587                 }
588             } else {
589                 revert(errorMessage);
590             }
591         }
592     }
593 }
594 
595 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
596 
597 
598 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
599 
600 pragma solidity ^0.8.0;
601 
602 /**
603  * @title ERC721 token receiver interface
604  * @dev Interface for any contract that wants to support safeTransfers
605  * from ERC721 asset contracts.
606  */
607 interface IERC721Receiver {
608     /**
609      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
610      * by `operator` from `from`, this function is called.
611      *
612      * It must return its Solidity selector to confirm the token transfer.
613      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
614      *
615      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
616      */
617     function onERC721Received(
618         address operator,
619         address from,
620         uint256 tokenId,
621         bytes calldata data
622     ) external returns (bytes4);
623 }
624 
625 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
626 
627 
628 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
629 
630 pragma solidity ^0.8.0;
631 
632 /**
633  * @dev Interface of the ERC165 standard, as defined in the
634  * https://eips.ethereum.org/EIPS/eip-165[EIP].
635  *
636  * Implementers can declare support of contract interfaces, which can then be
637  * queried by others ({ERC165Checker}).
638  *
639  * For an implementation, see {ERC165}.
640  */
641 interface IERC165 {
642     /**
643      * @dev Returns true if this contract implements the interface defined by
644      * `interfaceId`. See the corresponding
645      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
646      * to learn more about how these ids are created.
647      *
648      * This function call must use less than 30 000 gas.
649      */
650     function supportsInterface(bytes4 interfaceId) external view returns (bool);
651 }
652 
653 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
654 
655 
656 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
657 
658 pragma solidity ^0.8.0;
659 
660 
661 /**
662  * @dev Implementation of the {IERC165} interface.
663  *
664  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
665  * for the additional interface id that will be supported. For example:
666  *
667  * ```solidity
668  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
669  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
670  * }
671  * ```
672  *
673  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
674  */
675 abstract contract ERC165 is IERC165 {
676     /**
677      * @dev See {IERC165-supportsInterface}.
678      */
679     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
680         return interfaceId == type(IERC165).interfaceId;
681     }
682 }
683 
684 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
685 
686 
687 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
688 
689 pragma solidity ^0.8.0;
690 
691 
692 /**
693  * @dev Required interface of an ERC721 compliant contract.
694  */
695 interface IERC721 is IERC165 {
696     /**
697      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
698      */
699     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
700 
701     /**
702      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
703      */
704     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
705 
706     /**
707      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
708      */
709     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
710 
711     /**
712      * @dev Returns the number of tokens in ``owner``'s account.
713      */
714     function balanceOf(address owner) external view returns (uint256 balance);
715 
716     /**
717      * @dev Returns the owner of the `tokenId` token.
718      *
719      * Requirements:
720      *
721      * - `tokenId` must exist.
722      */
723     function ownerOf(uint256 tokenId) external view returns (address owner);
724 
725     /**
726      * @dev Safely transfers `tokenId` token from `from` to `to`.
727      *
728      * Requirements:
729      *
730      * - `from` cannot be the zero address.
731      * - `to` cannot be the zero address.
732      * - `tokenId` token must exist and be owned by `from`.
733      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
734      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
735      *
736      * Emits a {Transfer} event.
737      */
738     function safeTransferFrom(
739         address from,
740         address to,
741         uint256 tokenId,
742         bytes calldata data
743     ) external;
744 
745     /**
746      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
747      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
748      *
749      * Requirements:
750      *
751      * - `from` cannot be the zero address.
752      * - `to` cannot be the zero address.
753      * - `tokenId` token must exist and be owned by `from`.
754      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
755      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
756      *
757      * Emits a {Transfer} event.
758      */
759     function safeTransferFrom(
760         address from,
761         address to,
762         uint256 tokenId
763     ) external;
764 
765     /**
766      * @dev Transfers `tokenId` token from `from` to `to`.
767      *
768      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
769      *
770      * Requirements:
771      *
772      * - `from` cannot be the zero address.
773      * - `to` cannot be the zero address.
774      * - `tokenId` token must be owned by `from`.
775      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
776      *
777      * Emits a {Transfer} event.
778      */
779     function transferFrom(
780         address from,
781         address to,
782         uint256 tokenId
783     ) external;
784 
785     /**
786      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
787      * The approval is cleared when the token is transferred.
788      *
789      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
790      *
791      * Requirements:
792      *
793      * - The caller must own the token or be an approved operator.
794      * - `tokenId` must exist.
795      *
796      * Emits an {Approval} event.
797      */
798     function approve(address to, uint256 tokenId) external;
799 
800     /**
801      * @dev Approve or remove `operator` as an operator for the caller.
802      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
803      *
804      * Requirements:
805      *
806      * - The `operator` cannot be the caller.
807      *
808      * Emits an {ApprovalForAll} event.
809      */
810     function setApprovalForAll(address operator, bool _approved) external;
811 
812     /**
813      * @dev Returns the account approved for `tokenId` token.
814      *
815      * Requirements:
816      *
817      * - `tokenId` must exist.
818      */
819     function getApproved(uint256 tokenId) external view returns (address operator);
820 
821     /**
822      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
823      *
824      * See {setApprovalForAll}
825      */
826     function isApprovedForAll(address owner, address operator) external view returns (bool);
827 }
828 
829 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
830 
831 
832 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
833 
834 pragma solidity ^0.8.0;
835 
836 
837 /**
838  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
839  * @dev See https://eips.ethereum.org/EIPS/eip-721
840  */
841 interface IERC721Metadata is IERC721 {
842     /**
843      * @dev Returns the token collection name.
844      */
845     function name() external view returns (string memory);
846 
847     /**
848      * @dev Returns the token collection symbol.
849      */
850     function symbol() external view returns (string memory);
851 
852     /**
853      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
854      */
855     function tokenURI(uint256 tokenId) external view returns (string memory);
856 }
857 
858 // File: @openzeppelin/contracts/utils/Context.sol
859 
860 
861 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
862 
863 pragma solidity ^0.8.0;
864 
865 /**
866  * @dev Provides information about the current execution context, including the
867  * sender of the transaction and its data. While these are generally available
868  * via msg.sender and msg.data, they should not be accessed in such a direct
869  * manner, since when dealing with meta-transactions the account sending and
870  * paying for execution may not be the actual sender (as far as an application
871  * is concerned).
872  *
873  * This contract is only required for intermediate, library-like contracts.
874  */
875 abstract contract Context {
876     function _msgSender() internal view virtual returns (address) {
877         return msg.sender;
878     }
879 
880     function _msgData() internal view virtual returns (bytes calldata) {
881         return msg.data;
882     }
883 }
884 
885 // File: erc721a/contracts/ERC721A.sol
886 
887 
888 // Creator: Chiru Labs
889 
890 pragma solidity ^0.8.4;
891 
892 
893 
894 
895 
896 
897 
898 
899 error ApprovalCallerNotOwnerNorApproved();
900 error ApprovalQueryForNonexistentToken();
901 error ApproveToCaller();
902 error ApprovalToCurrentOwner();
903 error BalanceQueryForZeroAddress();
904 error MintToZeroAddress();
905 error MintZeroQuantity();
906 error OwnerQueryForNonexistentToken();
907 error TransferCallerNotOwnerNorApproved();
908 error TransferFromIncorrectOwner();
909 error TransferToNonERC721ReceiverImplementer();
910 error TransferToZeroAddress();
911 error URIQueryForNonexistentToken();
912 
913 /**
914  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
915  * the Metadata extension. Built to optimize for lower gas during batch mints.
916  *
917  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
918  *
919  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
920  *
921  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
922  */
923 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
924     using Address for address;
925     using Strings for uint256;
926 
927     // Compiler will pack this into a single 256bit word.
928     struct TokenOwnership {
929         // The address of the owner.
930         address addr;
931         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
932         uint64 startTimestamp;
933         // Whether the token has been burned.
934         bool burned;
935     }
936 
937     // Compiler will pack this into a single 256bit word.
938     struct AddressData {
939         // Realistically, 2**64-1 is more than enough.
940         uint64 balance;
941         // Keeps track of mint count with minimal overhead for tokenomics.
942         uint64 numberMinted;
943         // Keeps track of burn count with minimal overhead for tokenomics.
944         uint64 numberBurned;
945         // For miscellaneous variable(s) pertaining to the address
946         // (e.g. number of whitelist mint slots used).
947         // If there are multiple variables, please pack them into a uint64.
948         uint64 aux;
949     }
950 
951     // The tokenId of the next token to be minted.
952     uint256 internal _currentIndex;
953 
954     // The number of tokens burned.
955     uint256 internal _burnCounter;
956 
957     // Token name
958     string private _name;
959 
960     // Token symbol
961     string private _symbol;
962 
963     // Mapping from token ID to ownership details
964     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
965     mapping(uint256 => TokenOwnership) internal _ownerships;
966 
967     // Mapping owner address to address data
968     mapping(address => AddressData) private _addressData;
969 
970     // Mapping from token ID to approved address
971     mapping(uint256 => address) private _tokenApprovals;
972 
973     // Mapping from owner to operator approvals
974     mapping(address => mapping(address => bool)) private _operatorApprovals;
975 
976     constructor(string memory name_, string memory symbol_) {
977         _name = name_;
978         _symbol = symbol_;
979         _currentIndex = _startTokenId();
980     }
981 
982     /**
983      * To change the starting tokenId, please override this function.
984      */
985     function _startTokenId() internal view virtual returns (uint256) {
986         return 0;
987     }
988 
989     /**
990      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
991      */
992     function totalSupply() public view returns (uint256) {
993         // Counter underflow is impossible as _burnCounter cannot be incremented
994         // more than _currentIndex - _startTokenId() times
995         unchecked {
996             return _currentIndex - _burnCounter - _startTokenId();
997         }
998     }
999 
1000     /**
1001      * Returns the total amount of tokens minted in the contract.
1002      */
1003     function _totalMinted() internal view returns (uint256) {
1004         // Counter underflow is impossible as _currentIndex does not decrement,
1005         // and it is initialized to _startTokenId()
1006         unchecked {
1007             return _currentIndex - _startTokenId();
1008         }
1009     }
1010 
1011     /**
1012      * @dev See {IERC165-supportsInterface}.
1013      */
1014     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1015         return
1016             interfaceId == type(IERC721).interfaceId ||
1017             interfaceId == type(IERC721Metadata).interfaceId ||
1018             super.supportsInterface(interfaceId);
1019     }
1020 
1021     /**
1022      * @dev See {IERC721-balanceOf}.
1023      */
1024     function balanceOf(address owner) public view override returns (uint256) {
1025         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1026         return uint256(_addressData[owner].balance);
1027     }
1028 
1029     /**
1030      * Returns the number of tokens minted by `owner`.
1031      */
1032     function _numberMinted(address owner) internal view returns (uint256) {
1033         return uint256(_addressData[owner].numberMinted);
1034     }
1035 
1036     /**
1037      * Returns the number of tokens burned by or on behalf of `owner`.
1038      */
1039     function _numberBurned(address owner) internal view returns (uint256) {
1040         return uint256(_addressData[owner].numberBurned);
1041     }
1042 
1043     /**
1044      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1045      */
1046     function _getAux(address owner) internal view returns (uint64) {
1047         return _addressData[owner].aux;
1048     }
1049 
1050     /**
1051      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1052      * If there are multiple variables, please pack them into a uint64.
1053      */
1054     function _setAux(address owner, uint64 aux) internal {
1055         _addressData[owner].aux = aux;
1056     }
1057 
1058     /**
1059      * Gas spent here starts off proportional to the maximum mint batch size.
1060      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1061      */
1062     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1063         uint256 curr = tokenId;
1064 
1065         unchecked {
1066             if (_startTokenId() <= curr && curr < _currentIndex) {
1067                 TokenOwnership memory ownership = _ownerships[curr];
1068                 if (!ownership.burned) {
1069                     if (ownership.addr != address(0)) {
1070                         return ownership;
1071                     }
1072                     // Invariant:
1073                     // There will always be an ownership that has an address and is not burned
1074                     // before an ownership that does not have an address and is not burned.
1075                     // Hence, curr will not underflow.
1076                     while (true) {
1077                         curr--;
1078                         ownership = _ownerships[curr];
1079                         if (ownership.addr != address(0)) {
1080                             return ownership;
1081                         }
1082                     }
1083                 }
1084             }
1085         }
1086         revert OwnerQueryForNonexistentToken();
1087     }
1088 
1089     /**
1090      * @dev See {IERC721-ownerOf}.
1091      */
1092     function ownerOf(uint256 tokenId) public view override returns (address) {
1093         return _ownershipOf(tokenId).addr;
1094     }
1095 
1096     /**
1097      * @dev See {IERC721Metadata-name}.
1098      */
1099     function name() public view virtual override returns (string memory) {
1100         return _name;
1101     }
1102 
1103     /**
1104      * @dev See {IERC721Metadata-symbol}.
1105      */
1106     function symbol() public view virtual override returns (string memory) {
1107         return _symbol;
1108     }
1109 
1110     /**
1111      * @dev See {IERC721Metadata-tokenURI}.
1112      */
1113     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1114         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1115 
1116         string memory baseURI = _baseURI();
1117         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1118     }
1119 
1120     /**
1121      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1122      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1123      * by default, can be overriden in child contracts.
1124      */
1125     function _baseURI() internal view virtual returns (string memory) {
1126         return '';
1127     }
1128 
1129     /**
1130      * @dev See {IERC721-approve}.
1131      */
1132     function approve(address to, uint256 tokenId) public override {
1133         address owner = ERC721A.ownerOf(tokenId);
1134         if (to == owner) revert ApprovalToCurrentOwner();
1135 
1136         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1137             revert ApprovalCallerNotOwnerNorApproved();
1138         }
1139 
1140         _approve(to, tokenId, owner);
1141     }
1142 
1143     /**
1144      * @dev See {IERC721-getApproved}.
1145      */
1146     function getApproved(uint256 tokenId) public view override returns (address) {
1147         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1148 
1149         return _tokenApprovals[tokenId];
1150     }
1151 
1152     /**
1153      * @dev See {IERC721-setApprovalForAll}.
1154      */
1155     function setApprovalForAll(address operator, bool approved) public virtual override {
1156         if (operator == _msgSender()) revert ApproveToCaller();
1157 
1158         _operatorApprovals[_msgSender()][operator] = approved;
1159         emit ApprovalForAll(_msgSender(), operator, approved);
1160     }
1161 
1162     /**
1163      * @dev See {IERC721-isApprovedForAll}.
1164      */
1165     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1166         return _operatorApprovals[owner][operator];
1167     }
1168 
1169     /**
1170      * @dev See {IERC721-transferFrom}.
1171      */
1172     function transferFrom(
1173         address from,
1174         address to,
1175         uint256 tokenId
1176     ) public virtual override {
1177         _transfer(from, to, tokenId);
1178     }
1179 
1180     /**
1181      * @dev See {IERC721-safeTransferFrom}.
1182      */
1183     function safeTransferFrom(
1184         address from,
1185         address to,
1186         uint256 tokenId
1187     ) public virtual override {
1188         safeTransferFrom(from, to, tokenId, '');
1189     }
1190 
1191     /**
1192      * @dev See {IERC721-safeTransferFrom}.
1193      */
1194     function safeTransferFrom(
1195         address from,
1196         address to,
1197         uint256 tokenId,
1198         bytes memory _data
1199     ) public virtual override {
1200         _transfer(from, to, tokenId);
1201         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1202             revert TransferToNonERC721ReceiverImplementer();
1203         }
1204     }
1205 
1206     /**
1207      * @dev Returns whether `tokenId` exists.
1208      *
1209      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1210      *
1211      * Tokens start existing when they are minted (`_mint`),
1212      */
1213     function _exists(uint256 tokenId) internal view returns (bool) {
1214         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1215     }
1216 
1217     function _safeMint(address to, uint256 quantity) internal {
1218         _safeMint(to, quantity, '');
1219     }
1220 
1221     /**
1222      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1223      *
1224      * Requirements:
1225      *
1226      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1227      * - `quantity` must be greater than 0.
1228      *
1229      * Emits a {Transfer} event.
1230      */
1231     function _safeMint(
1232         address to,
1233         uint256 quantity,
1234         bytes memory _data
1235     ) internal {
1236         _mint(to, quantity, _data, true);
1237     }
1238 
1239     /**
1240      * @dev Mints `quantity` tokens and transfers them to `to`.
1241      *
1242      * Requirements:
1243      *
1244      * - `to` cannot be the zero address.
1245      * - `quantity` must be greater than 0.
1246      *
1247      * Emits a {Transfer} event.
1248      */
1249     function _mint(
1250         address to,
1251         uint256 quantity,
1252         bytes memory _data,
1253         bool safe
1254     ) internal {
1255         uint256 startTokenId = _currentIndex;
1256         if (to == address(0)) revert MintToZeroAddress();
1257         if (quantity == 0) revert MintZeroQuantity();
1258 
1259         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1260 
1261         // Overflows are incredibly unrealistic.
1262         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1263         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1264         unchecked {
1265             _addressData[to].balance += uint64(quantity);
1266             _addressData[to].numberMinted += uint64(quantity);
1267 
1268             _ownerships[startTokenId].addr = to;
1269             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1270 
1271             uint256 updatedIndex = startTokenId;
1272             uint256 end = updatedIndex + quantity;
1273 
1274             if (safe && to.isContract()) {
1275                 do {
1276                     emit Transfer(address(0), to, updatedIndex);
1277                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1278                         revert TransferToNonERC721ReceiverImplementer();
1279                     }
1280                 } while (updatedIndex != end);
1281                 // Reentrancy protection
1282                 if (_currentIndex != startTokenId) revert();
1283             } else {
1284                 do {
1285                     emit Transfer(address(0), to, updatedIndex++);
1286                 } while (updatedIndex != end);
1287             }
1288             _currentIndex = updatedIndex;
1289         }
1290         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1291     }
1292 
1293     /**
1294      * @dev Transfers `tokenId` from `from` to `to`.
1295      *
1296      * Requirements:
1297      *
1298      * - `to` cannot be the zero address.
1299      * - `tokenId` token must be owned by `from`.
1300      *
1301      * Emits a {Transfer} event.
1302      */
1303     function _transfer(
1304         address from,
1305         address to,
1306         uint256 tokenId
1307     ) private {
1308         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1309 
1310         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1311 
1312         bool isApprovedOrOwner = (_msgSender() == from ||
1313             isApprovedForAll(from, _msgSender()) ||
1314             getApproved(tokenId) == _msgSender());
1315 
1316         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1317         if (to == address(0)) revert TransferToZeroAddress();
1318 
1319         _beforeTokenTransfers(from, to, tokenId, 1);
1320 
1321         // Clear approvals from the previous owner
1322         _approve(address(0), tokenId, from);
1323 
1324         // Underflow of the sender's balance is impossible because we check for
1325         // ownership above and the recipient's balance can't realistically overflow.
1326         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1327         unchecked {
1328             _addressData[from].balance -= 1;
1329             _addressData[to].balance += 1;
1330 
1331             TokenOwnership storage currSlot = _ownerships[tokenId];
1332             currSlot.addr = to;
1333             currSlot.startTimestamp = uint64(block.timestamp);
1334 
1335             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1336             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1337             uint256 nextTokenId = tokenId + 1;
1338             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1339             if (nextSlot.addr == address(0)) {
1340                 // This will suffice for checking _exists(nextTokenId),
1341                 // as a burned slot cannot contain the zero address.
1342                 if (nextTokenId != _currentIndex) {
1343                     nextSlot.addr = from;
1344                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1345                 }
1346             }
1347         }
1348 
1349         emit Transfer(from, to, tokenId);
1350         _afterTokenTransfers(from, to, tokenId, 1);
1351     }
1352 
1353     /**
1354      * @dev This is equivalent to _burn(tokenId, false)
1355      */
1356     function _burn(uint256 tokenId) internal virtual {
1357         _burn(tokenId, false);
1358     }
1359 
1360     /**
1361      * @dev Destroys `tokenId`.
1362      * The approval is cleared when the token is burned.
1363      *
1364      * Requirements:
1365      *
1366      * - `tokenId` must exist.
1367      *
1368      * Emits a {Transfer} event.
1369      */
1370     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1371         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1372 
1373         address from = prevOwnership.addr;
1374 
1375         if (approvalCheck) {
1376             bool isApprovedOrOwner = (_msgSender() == from ||
1377                 isApprovedForAll(from, _msgSender()) ||
1378                 getApproved(tokenId) == _msgSender());
1379 
1380             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1381         }
1382 
1383         _beforeTokenTransfers(from, address(0), tokenId, 1);
1384 
1385         // Clear approvals from the previous owner
1386         _approve(address(0), tokenId, from);
1387 
1388         // Underflow of the sender's balance is impossible because we check for
1389         // ownership above and the recipient's balance can't realistically overflow.
1390         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1391         unchecked {
1392             AddressData storage addressData = _addressData[from];
1393             addressData.balance -= 1;
1394             addressData.numberBurned += 1;
1395 
1396             // Keep track of who burned the token, and the timestamp of burning.
1397             TokenOwnership storage currSlot = _ownerships[tokenId];
1398             currSlot.addr = from;
1399             currSlot.startTimestamp = uint64(block.timestamp);
1400             currSlot.burned = true;
1401 
1402             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1403             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1404             uint256 nextTokenId = tokenId + 1;
1405             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1406             if (nextSlot.addr == address(0)) {
1407                 // This will suffice for checking _exists(nextTokenId),
1408                 // as a burned slot cannot contain the zero address.
1409                 if (nextTokenId != _currentIndex) {
1410                     nextSlot.addr = from;
1411                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1412                 }
1413             }
1414         }
1415 
1416         emit Transfer(from, address(0), tokenId);
1417         _afterTokenTransfers(from, address(0), tokenId, 1);
1418 
1419         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1420         unchecked {
1421             _burnCounter++;
1422         }
1423     }
1424 
1425     /**
1426      * @dev Approve `to` to operate on `tokenId`
1427      *
1428      * Emits a {Approval} event.
1429      */
1430     function _approve(
1431         address to,
1432         uint256 tokenId,
1433         address owner
1434     ) private {
1435         _tokenApprovals[tokenId] = to;
1436         emit Approval(owner, to, tokenId);
1437     }
1438 
1439     /**
1440      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1441      *
1442      * @param from address representing the previous owner of the given token ID
1443      * @param to target address that will receive the tokens
1444      * @param tokenId uint256 ID of the token to be transferred
1445      * @param _data bytes optional data to send along with the call
1446      * @return bool whether the call correctly returned the expected magic value
1447      */
1448     function _checkContractOnERC721Received(
1449         address from,
1450         address to,
1451         uint256 tokenId,
1452         bytes memory _data
1453     ) private returns (bool) {
1454         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1455             return retval == IERC721Receiver(to).onERC721Received.selector;
1456         } catch (bytes memory reason) {
1457             if (reason.length == 0) {
1458                 revert TransferToNonERC721ReceiverImplementer();
1459             } else {
1460                 assembly {
1461                     revert(add(32, reason), mload(reason))
1462                 }
1463             }
1464         }
1465     }
1466 
1467     /**
1468      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1469      * And also called before burning one token.
1470      *
1471      * startTokenId - the first token id to be transferred
1472      * quantity - the amount to be transferred
1473      *
1474      * Calling conditions:
1475      *
1476      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1477      * transferred to `to`.
1478      * - When `from` is zero, `tokenId` will be minted for `to`.
1479      * - When `to` is zero, `tokenId` will be burned by `from`.
1480      * - `from` and `to` are never both zero.
1481      */
1482     function _beforeTokenTransfers(
1483         address from,
1484         address to,
1485         uint256 startTokenId,
1486         uint256 quantity
1487     ) internal virtual {}
1488 
1489     /**
1490      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1491      * minting.
1492      * And also called after one token has been burned.
1493      *
1494      * startTokenId - the first token id to be transferred
1495      * quantity - the amount to be transferred
1496      *
1497      * Calling conditions:
1498      *
1499      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1500      * transferred to `to`.
1501      * - When `from` is zero, `tokenId` has been minted for `to`.
1502      * - When `to` is zero, `tokenId` has been burned by `from`.
1503      * - `from` and `to` are never both zero.
1504      */
1505     function _afterTokenTransfers(
1506         address from,
1507         address to,
1508         uint256 startTokenId,
1509         uint256 quantity
1510     ) internal virtual {}
1511 }
1512 
1513 // File: @openzeppelin/contracts/access/Ownable.sol
1514 
1515 
1516 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1517 
1518 pragma solidity ^0.8.0;
1519 
1520 
1521 /**
1522  * @dev Contract module which provides a basic access control mechanism, where
1523  * there is an account (an owner) that can be granted exclusive access to
1524  * specific functions.
1525  *
1526  * By default, the owner account will be the one that deploys the contract. This
1527  * can later be changed with {transferOwnership}.
1528  *
1529  * This module is used through inheritance. It will make available the modifier
1530  * `onlyOwner`, which can be applied to your functions to restrict their use to
1531  * the owner.
1532  */
1533 abstract contract Ownable is Context {
1534     address private _owner;
1535 
1536     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1537 
1538     /**
1539      * @dev Initializes the contract setting the deployer as the initial owner.
1540      */
1541     constructor() {
1542         _transferOwnership(_msgSender());
1543     }
1544 
1545     /**
1546      * @dev Returns the address of the current owner.
1547      */
1548     function owner() public view virtual returns (address) {
1549         return _owner;
1550     }
1551 
1552     /**
1553      * @dev Throws if called by any account other than the owner.
1554      */
1555     modifier onlyOwner() {
1556         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1557         _;
1558     }
1559 
1560     /**
1561      * @dev Leaves the contract without owner. It will not be possible to call
1562      * `onlyOwner` functions anymore. Can only be called by the current owner.
1563      *
1564      * NOTE: Renouncing ownership will leave the contract without an owner,
1565      * thereby removing any functionality that is only available to the owner.
1566      */
1567     function renounceOwnership() public virtual onlyOwner {
1568         _transferOwnership(address(0));
1569     }
1570 
1571     /**
1572      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1573      * Can only be called by the current owner.
1574      */
1575     function transferOwnership(address newOwner) public virtual onlyOwner {
1576         require(newOwner != address(0), "Ownable: new owner is the zero address");
1577         _transferOwnership(newOwner);
1578     }
1579 
1580     /**
1581      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1582      * Internal function without access restriction.
1583      */
1584     function _transferOwnership(address newOwner) internal virtual {
1585         address oldOwner = _owner;
1586         _owner = newOwner;
1587         emit OwnershipTransferred(oldOwner, newOwner);
1588     }
1589 }
1590 
1591 // File: contracts/CryptoBozos.sol
1592 
1593 
1594 
1595 pragma solidity ^0.8.0;
1596 
1597 
1598 
1599 
1600 
1601 
1602 contract CryptoBozosNFT is ERC721A, Ownable {
1603 
1604   using SafeMath for uint256;
1605   using Strings for uint256;
1606   string private _baseUri;
1607   string private _notRevealURI; 
1608   bool public RevealedActive = false;
1609   uint256 public PriceGenesis = 0.08 ether;
1610   uint256 public PricePresale = 0.1 ether;
1611   uint256 public PricePresale2 = 0.12 ether;
1612   uint256 public PricePublic = 0.13 ether;
1613   uint256 public MaxToken = 7777;
1614 
1615   uint256 public TokenIndex = 0;
1616   event TokenMinted(uint256 supply);
1617   enum Steps {Launch, Genesis, Presale, Presale2, PublicSale, SoldOut}
1618   Steps public sellingStep;
1619 
1620   mapping (address => uint256) public MaxperWallet;
1621 
1622   bytes32 public merkleRootPresale;
1623   bytes32 public merkleRootPresale2WL;
1624   bytes32 public merkleRootGenesisWL;
1625 
1626   constructor() ERC721A("Crypto Bozos NFT", "CB") {sellingStep = Steps.Launch;}
1627 
1628   function _baseURI() internal view virtual override returns (string memory) { return _baseUri; }
1629 
1630   function tokenURI(uint256 tokenId) public view virtual override returns (string memory a) {
1631     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1632     if (totalSupply() >= MaxToken || RevealedActive == true) {
1633       if (tokenId < MaxToken) {
1634         uint256 offsetId = tokenId.add(MaxToken.sub(TokenIndex)).mod(MaxToken);
1635         return string(abi.encodePacked(_baseURI(), offsetId.toString(), ".json"));
1636       }
1637     } else { return _notRevealURI; }
1638   }
1639 
1640   function mintGenesis(uint8 mintAmount, address _account, bytes32[] calldata _proof) public payable {
1641     require(sellingStep == Steps.Genesis, "Genesis has not started yet.");
1642     require(totalSupply().add(mintAmount) <= 777, "Genesis Sold Out");
1643     require(isGenesisWL(_account, _proof), "Not on the whitelist");
1644     require(MaxperWallet[msg.sender] + mintAmount <= 3, "Max NFTs Reached");
1645     MaxperWallet[msg.sender] += mintAmount;
1646     require(mintAmount > 0, "At least one should be minted");
1647     require(PriceGenesis * mintAmount <= msg.value, "Not enough funds");
1648     if(totalSupply() + mintAmount == 777) { RevealedActive = true; }
1649     _mint(msg.sender, mintAmount);
1650     emit TokenMinted(totalSupply());
1651   }
1652 
1653   function mintPresale(uint8 mintAmount, address _account, bytes32[] calldata _proof) public payable {
1654     require(sellingStep == Steps.Presale, "Presale has not started yet.");
1655     require(totalSupply().add(mintAmount) <= 2277, "Presale Sold Out");
1656     require(isPresale(_account, _proof), "Not on the whitelist");
1657     require(MaxperWallet[msg.sender] + mintAmount <= 5, "Max NFTs Reached");
1658     MaxperWallet[msg.sender] += mintAmount;
1659     require(mintAmount > 0, "At least one should be minted");
1660     require(PricePresale * mintAmount <= msg.value, "Not enough funds");
1661     if(totalSupply() + mintAmount == 2277) { RevealedActive = true; }
1662     _mint(msg.sender, mintAmount);
1663     emit TokenMinted(totalSupply());
1664   }
1665 
1666   function mintPresale2(uint8 mintAmount, address _account, bytes32[] calldata _proof) public payable {
1667     require(sellingStep == Steps.Presale2, "Presale2 has not started yet.");
1668     require(totalSupply().add(mintAmount) <= 4277, "Presale2 Sold Out");
1669     require(isPresale2WL(_account, _proof), "Not on the whitelist");
1670     require(MaxperWallet[msg.sender] + mintAmount <= 7, "Max NFTs Reached");
1671     MaxperWallet[msg.sender] += mintAmount;    
1672     require(mintAmount > 0, "At least one should be minted");
1673     require(PricePresale2 * mintAmount <= msg.value, "Not enough funds");
1674     if(totalSupply() + mintAmount == 4277) { RevealedActive = true; }
1675     _mint(msg.sender, mintAmount);
1676     emit TokenMinted(totalSupply());
1677   }
1678 
1679   function mint(uint8 mintAmount) public payable {
1680     require(sellingStep != Steps.SoldOut, "Sold Out");
1681     require(sellingStep == Steps.PublicSale, "Sorry, public sale has not started yet.");
1682     require(totalSupply().add(mintAmount) <= MaxToken, "Sold Out");                                                               
1683     require(MaxperWallet[msg.sender] + mintAmount <= 50, "Max NFTs Reached");
1684     MaxperWallet[msg.sender] += mintAmount;
1685     require(mintAmount > 0, "At least one should be minted");
1686     require(PricePublic * mintAmount <= msg.value, "Not enough funds"); 
1687     if(totalSupply() + mintAmount == MaxToken) { sellingStep = Steps.SoldOut; }
1688     _mint(msg.sender, mintAmount);
1689     emit TokenMinted(totalSupply());
1690   }
1691 
1692   function _mint(address recipient, uint256 quantity) internal {
1693     _safeMint(recipient, quantity);
1694   }
1695 
1696   function OwnerMint(uint256 num) public onlyOwner {
1697     require(totalSupply().add(num) <= MaxToken, "Sold Out");
1698     if(totalSupply().add(num) == MaxToken) { sellingStep = Steps.SoldOut; }    
1699     _mint(msg.sender, num);
1700     emit TokenMinted(totalSupply());
1701   }
1702 
1703   function Airdrop(uint256 num, address recipient) public onlyOwner {
1704     require(totalSupply().add(num) <= MaxToken, "Sold Out");
1705     if(totalSupply().add(num) == MaxToken) { sellingStep = Steps.SoldOut; }    
1706     _mint(recipient, num);
1707     emit TokenMinted(totalSupply());
1708   }
1709 
1710   function AirdropGroup(address[] memory receivers) external onlyOwner {
1711     require(totalSupply().add(receivers.length) <= MaxToken, "Sold Out");
1712     if(totalSupply().add(receivers.length) == MaxToken) { sellingStep = Steps.SoldOut; }    
1713     for (uint256 i = 0; i < receivers.length; i++) {
1714       Airdrop(1, receivers[i]);
1715     }
1716   }
1717 
1718   function setGenesis() external onlyOwner {
1719     sellingStep = Steps.Genesis;
1720   }
1721 
1722   function setPresale() external onlyOwner {
1723     require(sellingStep == Steps.Genesis, "Active Genesis Selling Step at first");
1724     sellingStep = Steps.Presale;
1725   }
1726 
1727   function setPresale2() external onlyOwner {
1728     require(sellingStep == Steps.Presale, "Active Presale Selling Step at first");
1729     sellingStep = Steps.Presale2;
1730   }
1731 
1732   function setPublicSale() external onlyOwner {
1733     require(sellingStep == Steps.Presale2, "Active Presale2 Selling Step at first");
1734     sellingStep = Steps.PublicSale;
1735   }
1736 
1737   function setBaseURI(string calldata baseURI) external onlyOwner {
1738     _baseUri = baseURI;
1739   }
1740 
1741   function setNotRevealURI(string memory preRevealURI) external onlyOwner {
1742     _notRevealURI = preRevealURI;
1743   }
1744 
1745   function setPricePublic(uint256 _newPricePublic) public onlyOwner {
1746     PricePublic = _newPricePublic;
1747   }
1748 
1749   function setPriceGenesis(uint256 _newPriceGenesis) public onlyOwner {
1750     PriceGenesis = _newPriceGenesis;
1751   }
1752 
1753   function setPricePresale(uint256 _newPricePresale) public onlyOwner {
1754     PricePresale = _newPricePresale;
1755   }
1756 
1757   function setPricePresale2(uint256 _newPricePresale2) public onlyOwner {
1758     PricePresale2 = _newPricePresale2;
1759   }
1760 
1761   function isPresale(address account, bytes32[] calldata proof) internal view returns(bool) {
1762     return _verify(_leaf(account), proof);
1763   }
1764 
1765   function _leaf(address account) internal pure returns(bytes32) {
1766     return keccak256(abi.encodePacked(account));
1767   }
1768 
1769   function _verify(bytes32 leaf, bytes32[] memory proof) internal view returns(bool) {
1770     return MerkleProof.verify(proof, merkleRootPresale, leaf);
1771   }
1772 
1773   function changeMerkleRootPresale(bytes32 _newMerkleRootPresale) external onlyOwner {
1774     merkleRootPresale = _newMerkleRootPresale;
1775   }
1776 
1777   function isGenesisWL(address account, bytes32[] calldata proof) internal view returns(bool) {
1778     return _verifyGenesisWL(_leaf(account), proof);
1779   }
1780   
1781   function _verifyGenesisWL(bytes32 leaf, bytes32[] memory proof) internal view returns(bool) {
1782     return MerkleProof.verify(proof, merkleRootGenesisWL, leaf);
1783   }
1784 
1785   function changeMerkleRootGenesisWL(bytes32 _newmerkleRootGenesisWL) external onlyOwner {
1786     merkleRootGenesisWL = _newmerkleRootGenesisWL;
1787   }
1788 
1789   function isPresale2WL(address account, bytes32[] calldata proof) internal view returns(bool) {
1790     return _verifyPresale2WL(_leaf(account), proof);
1791   }
1792 
1793   function _verifyPresale2WL(bytes32 leaf, bytes32[] memory proof) internal view returns(bool) {
1794         return MerkleProof.verify(proof, merkleRootPresale2WL, leaf);
1795   }
1796 
1797   function changeMerkleRootPresale2WL(bytes32 _newmerkleRootPresale2WL) external onlyOwner {
1798       merkleRootPresale2WL = _newmerkleRootPresale2WL;
1799   }
1800 
1801   function numberMinted(address owner) public view returns (uint256) {
1802     return _numberMinted(owner);
1803   }
1804 
1805   function TurnRevealMode() public onlyOwner {
1806     RevealedActive = true;
1807   }
1808 
1809   function withdraw() public payable onlyOwner {
1810     (bool mod, ) = payable(owner()).call{value: address(this).balance}("");
1811     require(mod);
1812   }
1813   
1814 }