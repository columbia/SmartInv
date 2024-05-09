1 // SPDX-License-Identifier: GPL-3.0
2 
3 
4 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 // CAUTION
12 // This version of SafeMath should only be used with Solidity 0.8 or later,
13 // because it relies on the compiler's built in overflow checks.
14 
15 /**
16  * @dev Wrappers over Solidity's arithmetic operations.
17  *
18  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
19  * now has built in overflow checking.
20  */
21 library SafeMath {
22     /**
23      * @dev Returns the addition of two unsigned integers, with an overflow flag.
24      *
25      * _Available since v3.4._
26      */
27     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
28         unchecked {
29             uint256 c = a + b;
30             if (c < a) return (false, 0);
31             return (true, c);
32         }
33     }
34 
35     /**
36      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
37      *
38      * _Available since v3.4._
39      */
40     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
41         unchecked {
42             if (b > a) return (false, 0);
43             return (true, a - b);
44         }
45     }
46 
47     /**
48      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
49      *
50      * _Available since v3.4._
51      */
52     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
53         unchecked {
54             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
55             // benefit is lost if 'b' is also tested.
56             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
57             if (a == 0) return (true, 0);
58             uint256 c = a * b;
59             if (c / a != b) return (false, 0);
60             return (true, c);
61         }
62     }
63 
64     /**
65      * @dev Returns the division of two unsigned integers, with a division by zero flag.
66      *
67      * _Available since v3.4._
68      */
69     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
70         unchecked {
71             if (b == 0) return (false, 0);
72             return (true, a / b);
73         }
74     }
75 
76     /**
77      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
78      *
79      * _Available since v3.4._
80      */
81     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
82         unchecked {
83             if (b == 0) return (false, 0);
84             return (true, a % b);
85         }
86     }
87 
88     /**
89      * @dev Returns the addition of two unsigned integers, reverting on
90      * overflow.
91      *
92      * Counterpart to Solidity's `+` operator.
93      *
94      * Requirements:
95      *
96      * - Addition cannot overflow.
97      */
98     function add(uint256 a, uint256 b) internal pure returns (uint256) {
99         return a + b;
100     }
101 
102     /**
103      * @dev Returns the subtraction of two unsigned integers, reverting on
104      * overflow (when the result is negative).
105      *
106      * Counterpart to Solidity's `-` operator.
107      *
108      * Requirements:
109      *
110      * - Subtraction cannot overflow.
111      */
112     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113         return a - b;
114     }
115 
116     /**
117      * @dev Returns the multiplication of two unsigned integers, reverting on
118      * overflow.
119      *
120      * Counterpart to Solidity's `*` operator.
121      *
122      * Requirements:
123      *
124      * - Multiplication cannot overflow.
125      */
126     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
127         return a * b;
128     }
129 
130     /**
131      * @dev Returns the integer division of two unsigned integers, reverting on
132      * division by zero. The result is rounded towards zero.
133      *
134      * Counterpart to Solidity's `/` operator.
135      *
136      * Requirements:
137      *
138      * - The divisor cannot be zero.
139      */
140     function div(uint256 a, uint256 b) internal pure returns (uint256) {
141         return a / b;
142     }
143 
144     /**
145      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
146      * reverting when dividing by zero.
147      *
148      * Counterpart to Solidity's `%` operator. This function uses a `revert`
149      * opcode (which leaves remaining gas untouched) while Solidity uses an
150      * invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      *
154      * - The divisor cannot be zero.
155      */
156     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
157         return a % b;
158     }
159 
160     /**
161      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
162      * overflow (when the result is negative).
163      *
164      * CAUTION: This function is deprecated because it requires allocating memory for the error
165      * message unnecessarily. For custom revert reasons use {trySub}.
166      *
167      * Counterpart to Solidity's `-` operator.
168      *
169      * Requirements:
170      *
171      * - Subtraction cannot overflow.
172      */
173     function sub(
174         uint256 a,
175         uint256 b,
176         string memory errorMessage
177     ) internal pure returns (uint256) {
178         unchecked {
179             require(b <= a, errorMessage);
180             return a - b;
181         }
182     }
183 
184     /**
185      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
186      * division by zero. The result is rounded towards zero.
187      *
188      * Counterpart to Solidity's `/` operator. Note: this function uses a
189      * `revert` opcode (which leaves remaining gas untouched) while Solidity
190      * uses an invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      *
194      * - The divisor cannot be zero.
195      */
196     function div(
197         uint256 a,
198         uint256 b,
199         string memory errorMessage
200     ) internal pure returns (uint256) {
201         unchecked {
202             require(b > 0, errorMessage);
203             return a / b;
204         }
205     }
206 
207     /**
208      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
209      * reverting with custom message when dividing by zero.
210      *
211      * CAUTION: This function is deprecated because it requires allocating memory for the error
212      * message unnecessarily. For custom revert reasons use {tryMod}.
213      *
214      * Counterpart to Solidity's `%` operator. This function uses a `revert`
215      * opcode (which leaves remaining gas untouched) while Solidity uses an
216      * invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function mod(
223         uint256 a,
224         uint256 b,
225         string memory errorMessage
226     ) internal pure returns (uint256) {
227         unchecked {
228             require(b > 0, errorMessage);
229             return a % b;
230         }
231     }
232 }
233 
234 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
235 
236 
237 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
238 
239 pragma solidity ^0.8.0;
240 
241 /**
242  * @dev These functions deal with verification of Merkle Trees proofs.
243  *
244  * The proofs can be generated using the JavaScript library
245  * https://github.com/miguelmota/merkletreejs[merkletreejs].
246  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
247  *
248  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
249  */
250 library MerkleProof {
251     /**
252      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
253      * defined by `root`. For this, a `proof` must be provided, containing
254      * sibling hashes on the branch from the leaf to the root of the tree. Each
255      * pair of leaves and each pair of pre-images are assumed to be sorted.
256      */
257     function verify(
258         bytes32[] memory proof,
259         bytes32 root,
260         bytes32 leaf
261     ) internal pure returns (bool) {
262         return processProof(proof, leaf) == root;
263     }
264 
265     /**
266      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
267      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
268      * hash matches the root of the tree. When processing the proof, the pairs
269      * of leafs & pre-images are assumed to be sorted.
270      *
271      * _Available since v4.4._
272      */
273     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
274         bytes32 computedHash = leaf;
275         for (uint256 i = 0; i < proof.length; i++) {
276             bytes32 proofElement = proof[i];
277             if (computedHash <= proofElement) {
278                 // Hash(current computed hash + current element of the proof)
279                 computedHash = _efficientHash(computedHash, proofElement);
280             } else {
281                 // Hash(current element of the proof + current computed hash)
282                 computedHash = _efficientHash(proofElement, computedHash);
283             }
284         }
285         return computedHash;
286     }
287 
288     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
289         assembly {
290             mstore(0x00, a)
291             mstore(0x20, b)
292             value := keccak256(0x00, 0x40)
293         }
294     }
295 }
296 
297 // File: @openzeppelin/contracts/utils/Strings.sol
298 
299 
300 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
301 
302 pragma solidity ^0.8.0;
303 
304 /**
305  * @dev String operations.
306  */
307 library Strings {
308     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
309 
310     /**
311      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
312      */
313     function toString(uint256 value) internal pure returns (string memory) {
314         // Inspired by OraclizeAPI's implementation - MIT licence
315         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
316 
317         if (value == 0) {
318             return "0";
319         }
320         uint256 temp = value;
321         uint256 digits;
322         while (temp != 0) {
323             digits++;
324             temp /= 10;
325         }
326         bytes memory buffer = new bytes(digits);
327         while (value != 0) {
328             digits -= 1;
329             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
330             value /= 10;
331         }
332         return string(buffer);
333     }
334 
335     /**
336      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
337      */
338     function toHexString(uint256 value) internal pure returns (string memory) {
339         if (value == 0) {
340             return "0x00";
341         }
342         uint256 temp = value;
343         uint256 length = 0;
344         while (temp != 0) {
345             length++;
346             temp >>= 8;
347         }
348         return toHexString(value, length);
349     }
350 
351     /**
352      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
353      */
354     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
355         bytes memory buffer = new bytes(2 * length + 2);
356         buffer[0] = "0";
357         buffer[1] = "x";
358         for (uint256 i = 2 * length + 1; i > 1; --i) {
359             buffer[i] = _HEX_SYMBOLS[value & 0xf];
360             value >>= 4;
361         }
362         require(value == 0, "Strings: hex length insufficient");
363         return string(buffer);
364     }
365 }
366 
367 // File: @openzeppelin/contracts/utils/Address.sol
368 
369 
370 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
371 
372 pragma solidity ^0.8.1;
373 
374 /**
375  * @dev Collection of functions related to the address type
376  */
377 library Address {
378     /**
379      * @dev Returns true if `account` is a contract.
380      *
381      * [IMPORTANT]
382      * ====
383      * It is unsafe to assume that an address for which this function returns
384      * false is an externally-owned account (EOA) and not a contract.
385      *
386      * Among others, `isContract` will return false for the following
387      * types of addresses:
388      *
389      *  - an externally-owned account
390      *  - a contract in construction
391      *  - an address where a contract will be created
392      *  - an address where a contract lived, but was destroyed
393      * ====
394      *
395      * [IMPORTANT]
396      * ====
397      * You shouldn't rely on `isContract` to protect against flash loan attacks!
398      *
399      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
400      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
401      * constructor.
402      * ====
403      */
404     function isContract(address account) internal view returns (bool) {
405         // This method relies on extcodesize/address.code.length, which returns 0
406         // for contracts in construction, since the code is only stored at the end
407         // of the constructor execution.
408 
409         return account.code.length > 0;
410     }
411 
412     /**
413      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
414      * `recipient`, forwarding all available gas and reverting on errors.
415      *
416      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
417      * of certain opcodes, possibly making contracts go over the 2300 gas limit
418      * imposed by `transfer`, making them unable to receive funds via
419      * `transfer`. {sendValue} removes this limitation.
420      *
421      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
422      *
423      * IMPORTANT: because control is transferred to `recipient`, care must be
424      * taken to not create reentrancy vulnerabilities. Consider using
425      * {ReentrancyGuard} or the
426      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
427      */
428     function sendValue(address payable recipient, uint256 amount) internal {
429         require(address(this).balance >= amount, "Address: insufficient balance");
430 
431         (bool success, ) = recipient.call{value: amount}("");
432         require(success, "Address: unable to send value, recipient may have reverted");
433     }
434 
435     /**
436      * @dev Performs a Solidity function call using a low level `call`. A
437      * plain `call` is an unsafe replacement for a function call: use this
438      * function instead.
439      *
440      * If `target` reverts with a revert reason, it is bubbled up by this
441      * function (like regular Solidity function calls).
442      *
443      * Returns the raw returned data. To convert to the expected return value,
444      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
445      *
446      * Requirements:
447      *
448      * - `target` must be a contract.
449      * - calling `target` with `data` must not revert.
450      *
451      * _Available since v3.1._
452      */
453     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
454         return functionCall(target, data, "Address: low-level call failed");
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
459      * `errorMessage` as a fallback revert reason when `target` reverts.
460      *
461      * _Available since v3.1._
462      */
463     function functionCall(
464         address target,
465         bytes memory data,
466         string memory errorMessage
467     ) internal returns (bytes memory) {
468         return functionCallWithValue(target, data, 0, errorMessage);
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
473      * but also transferring `value` wei to `target`.
474      *
475      * Requirements:
476      *
477      * - the calling contract must have an ETH balance of at least `value`.
478      * - the called Solidity function must be `payable`.
479      *
480      * _Available since v3.1._
481      */
482     function functionCallWithValue(
483         address target,
484         bytes memory data,
485         uint256 value
486     ) internal returns (bytes memory) {
487         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
492      * with `errorMessage` as a fallback revert reason when `target` reverts.
493      *
494      * _Available since v3.1._
495      */
496     function functionCallWithValue(
497         address target,
498         bytes memory data,
499         uint256 value,
500         string memory errorMessage
501     ) internal returns (bytes memory) {
502         require(address(this).balance >= value, "Address: insufficient balance for call");
503         require(isContract(target), "Address: call to non-contract");
504 
505         (bool success, bytes memory returndata) = target.call{value: value}(data);
506         return verifyCallResult(success, returndata, errorMessage);
507     }
508 
509     /**
510      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
511      * but performing a static call.
512      *
513      * _Available since v3.3._
514      */
515     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
516         return functionStaticCall(target, data, "Address: low-level static call failed");
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
521      * but performing a static call.
522      *
523      * _Available since v3.3._
524      */
525     function functionStaticCall(
526         address target,
527         bytes memory data,
528         string memory errorMessage
529     ) internal view returns (bytes memory) {
530         require(isContract(target), "Address: static call to non-contract");
531 
532         (bool success, bytes memory returndata) = target.staticcall(data);
533         return verifyCallResult(success, returndata, errorMessage);
534     }
535 
536     /**
537      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
538      * but performing a delegate call.
539      *
540      * _Available since v3.4._
541      */
542     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
543         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
544     }
545 
546     /**
547      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
548      * but performing a delegate call.
549      *
550      * _Available since v3.4._
551      */
552     function functionDelegateCall(
553         address target,
554         bytes memory data,
555         string memory errorMessage
556     ) internal returns (bytes memory) {
557         require(isContract(target), "Address: delegate call to non-contract");
558 
559         (bool success, bytes memory returndata) = target.delegatecall(data);
560         return verifyCallResult(success, returndata, errorMessage);
561     }
562 
563     /**
564      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
565      * revert reason using the provided one.
566      *
567      * _Available since v4.3._
568      */
569     function verifyCallResult(
570         bool success,
571         bytes memory returndata,
572         string memory errorMessage
573     ) internal pure returns (bytes memory) {
574         if (success) {
575             return returndata;
576         } else {
577             // Look for revert reason and bubble it up if present
578             if (returndata.length > 0) {
579                 // The easiest way to bubble the revert reason is using memory via assembly
580 
581                 assembly {
582                     let returndata_size := mload(returndata)
583                     revert(add(32, returndata), returndata_size)
584                 }
585             } else {
586                 revert(errorMessage);
587             }
588         }
589     }
590 }
591 
592 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
593 
594 
595 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
596 
597 pragma solidity ^0.8.0;
598 
599 /**
600  * @title ERC721 token receiver interface
601  * @dev Interface for any contract that wants to support safeTransfers
602  * from ERC721 asset contracts.
603  */
604 interface IERC721Receiver {
605     /**
606      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
607      * by `operator` from `from`, this function is called.
608      *
609      * It must return its Solidity selector to confirm the token transfer.
610      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
611      *
612      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
613      */
614     function onERC721Received(
615         address operator,
616         address from,
617         uint256 tokenId,
618         bytes calldata data
619     ) external returns (bytes4);
620 }
621 
622 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
623 
624 
625 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
626 
627 pragma solidity ^0.8.0;
628 
629 /**
630  * @dev Interface of the ERC165 standard, as defined in the
631  * https://eips.ethereum.org/EIPS/eip-165[EIP].
632  *
633  * Implementers can declare support of contract interfaces, which can then be
634  * queried by others ({ERC165Checker}).
635  *
636  * For an implementation, see {ERC165}.
637  */
638 interface IERC165 {
639     /**
640      * @dev Returns true if this contract implements the interface defined by
641      * `interfaceId`. See the corresponding
642      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
643      * to learn more about how these ids are created.
644      *
645      * This function call must use less than 30 000 gas.
646      */
647     function supportsInterface(bytes4 interfaceId) external view returns (bool);
648 }
649 
650 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
651 
652 
653 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
654 
655 pragma solidity ^0.8.0;
656 
657 
658 /**
659  * @dev Implementation of the {IERC165} interface.
660  *
661  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
662  * for the additional interface id that will be supported. For example:
663  *
664  * ```solidity
665  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
666  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
667  * }
668  * ```
669  *
670  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
671  */
672 abstract contract ERC165 is IERC165 {
673     /**
674      * @dev See {IERC165-supportsInterface}.
675      */
676     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
677         return interfaceId == type(IERC165).interfaceId;
678     }
679 }
680 
681 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
682 
683 
684 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
685 
686 pragma solidity ^0.8.0;
687 
688 
689 /**
690  * @dev Required interface of an ERC721 compliant contract.
691  */
692 interface IERC721 is IERC165 {
693     /**
694      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
695      */
696     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
697 
698     /**
699      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
700      */
701     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
702 
703     /**
704      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
705      */
706     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
707 
708     /**
709      * @dev Returns the number of tokens in ``owner``'s account.
710      */
711     function balanceOf(address owner) external view returns (uint256 balance);
712 
713     /**
714      * @dev Returns the owner of the `tokenId` token.
715      *
716      * Requirements:
717      *
718      * - `tokenId` must exist.
719      */
720     function ownerOf(uint256 tokenId) external view returns (address owner);
721 
722     /**
723      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
724      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
725      *
726      * Requirements:
727      *
728      * - `from` cannot be the zero address.
729      * - `to` cannot be the zero address.
730      * - `tokenId` token must exist and be owned by `from`.
731      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
732      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
733      *
734      * Emits a {Transfer} event.
735      */
736     function safeTransferFrom(
737         address from,
738         address to,
739         uint256 tokenId
740     ) external;
741 
742     /**
743      * @dev Transfers `tokenId` token from `from` to `to`.
744      *
745      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
746      *
747      * Requirements:
748      *
749      * - `from` cannot be the zero address.
750      * - `to` cannot be the zero address.
751      * - `tokenId` token must be owned by `from`.
752      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
753      *
754      * Emits a {Transfer} event.
755      */
756     function transferFrom(
757         address from,
758         address to,
759         uint256 tokenId
760     ) external;
761 
762     /**
763      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
764      * The approval is cleared when the token is transferred.
765      *
766      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
767      *
768      * Requirements:
769      *
770      * - The caller must own the token or be an approved operator.
771      * - `tokenId` must exist.
772      *
773      * Emits an {Approval} event.
774      */
775     function approve(address to, uint256 tokenId) external;
776 
777     /**
778      * @dev Returns the account approved for `tokenId` token.
779      *
780      * Requirements:
781      *
782      * - `tokenId` must exist.
783      */
784     function getApproved(uint256 tokenId) external view returns (address operator);
785 
786     /**
787      * @dev Approve or remove `operator` as an operator for the caller.
788      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
789      *
790      * Requirements:
791      *
792      * - The `operator` cannot be the caller.
793      *
794      * Emits an {ApprovalForAll} event.
795      */
796     function setApprovalForAll(address operator, bool _approved) external;
797 
798     /**
799      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
800      *
801      * See {setApprovalForAll}
802      */
803     function isApprovedForAll(address owner, address operator) external view returns (bool);
804 
805     /**
806      * @dev Safely transfers `tokenId` token from `from` to `to`.
807      *
808      * Requirements:
809      *
810      * - `from` cannot be the zero address.
811      * - `to` cannot be the zero address.
812      * - `tokenId` token must exist and be owned by `from`.
813      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
814      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
815      *
816      * Emits a {Transfer} event.
817      */
818     function safeTransferFrom(
819         address from,
820         address to,
821         uint256 tokenId,
822         bytes calldata data
823     ) external;
824 }
825 
826 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
827 
828 
829 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
830 
831 pragma solidity ^0.8.0;
832 
833 
834 /**
835  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
836  * @dev See https://eips.ethereum.org/EIPS/eip-721
837  */
838 interface IERC721Enumerable is IERC721 {
839     /**
840      * @dev Returns the total amount of tokens stored by the contract.
841      */
842     function totalSupply() external view returns (uint256);
843 
844     /**
845      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
846      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
847      */
848     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
849 
850     /**
851      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
852      * Use along with {totalSupply} to enumerate all tokens.
853      */
854     function tokenByIndex(uint256 index) external view returns (uint256);
855 }
856 
857 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
858 
859 
860 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
861 
862 pragma solidity ^0.8.0;
863 
864 
865 /**
866  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
867  * @dev See https://eips.ethereum.org/EIPS/eip-721
868  */
869 interface IERC721Metadata is IERC721 {
870     /**
871      * @dev Returns the token collection name.
872      */
873     function name() external view returns (string memory);
874 
875     /**
876      * @dev Returns the token collection symbol.
877      */
878     function symbol() external view returns (string memory);
879 
880     /**
881      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
882      */
883     function tokenURI(uint256 tokenId) external view returns (string memory);
884 }
885 
886 // File: @openzeppelin/contracts/utils/Context.sol
887 
888 
889 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
890 
891 pragma solidity ^0.8.0;
892 
893 /**
894  * @dev Provides information about the current execution context, including the
895  * sender of the transaction and its data. While these are generally available
896  * via msg.sender and msg.data, they should not be accessed in such a direct
897  * manner, since when dealing with meta-transactions the account sending and
898  * paying for execution may not be the actual sender (as far as an application
899  * is concerned).
900  *
901  * This contract is only required for intermediate, library-like contracts.
902  */
903 abstract contract Context {
904     function _msgSender() internal view virtual returns (address) {
905         return msg.sender;
906     }
907 
908     function _msgData() internal view virtual returns (bytes calldata) {
909         return msg.data;
910     }
911 }
912 
913 // File: contracts/ERC721A.sol
914 
915 
916 
917 pragma solidity ^0.8.0;
918 
919 
920 
921 
922 
923 
924 
925 
926 
927 /**
928  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
929  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
930  *
931  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
932  *
933  * Does not support burning tokens to address(0).
934  *
935  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
936  */
937 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
938     using Address for address;
939     using Strings for uint256;
940 
941     struct TokenOwnership {
942         address addr;
943         uint64 startTimestamp;
944     }
945 
946     struct AddressData {
947         uint128 balance;
948         uint128 numberMinted;
949     }
950 
951     uint256 internal currentIndex;
952 
953     // Token name
954     string private _name;
955 
956     // Token symbol
957     string private _symbol;
958 
959     // Mapping from token ID to ownership details
960     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
961     mapping(uint256 => TokenOwnership) internal _ownerships;
962 
963     // Mapping owner address to address data
964     mapping(address => AddressData) private _addressData;
965 
966     // Mapping from token ID to approved address
967     mapping(uint256 => address) private _tokenApprovals;
968 
969     // Mapping from owner to operator approvals
970     mapping(address => mapping(address => bool)) private _operatorApprovals;
971 
972     constructor(string memory name_, string memory symbol_) {
973         _name = name_;
974         _symbol = symbol_;
975     }
976 
977     /**
978      * @dev See {IERC721Enumerable-totalSupply}.
979      */
980     function totalSupply() public view override returns (uint256) {
981         return currentIndex;
982     }
983 
984     /**
985      * @dev See {IERC721Enumerable-tokenByIndex}.
986      */
987     function tokenByIndex(uint256 index) public view override returns (uint256) {
988         require(index < totalSupply(), 'ERC721A: global index out of bounds');
989         return index;
990     }
991 
992     /**
993      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
994      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
995      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
996      */
997     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
998         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
999         uint256 numMintedSoFar = totalSupply();
1000         uint256 tokenIdsIdx;
1001         address currOwnershipAddr;
1002 
1003         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1004         unchecked {
1005             for (uint256 i; i < numMintedSoFar; i++) {
1006                 TokenOwnership memory ownership = _ownerships[i];
1007                 if (ownership.addr != address(0)) {
1008                     currOwnershipAddr = ownership.addr;
1009                 }
1010                 if (currOwnershipAddr == owner) {
1011                     if (tokenIdsIdx == index) {
1012                         return i;
1013                     }
1014                     tokenIdsIdx++;
1015                 }
1016             }
1017         }
1018 
1019         revert('ERC721A: unable to get token of owner by index');
1020     }
1021 
1022     /**
1023      * @dev See {IERC165-supportsInterface}.
1024      */
1025     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1026         return
1027             interfaceId == type(IERC721).interfaceId ||
1028             interfaceId == type(IERC721Metadata).interfaceId ||
1029             interfaceId == type(IERC721Enumerable).interfaceId ||
1030             super.supportsInterface(interfaceId);
1031     }
1032 
1033     /**
1034      * @dev See {IERC721-balanceOf}.
1035      */
1036     function balanceOf(address owner) public view override returns (uint256) {
1037         require(owner != address(0), 'ERC721A: balance query for the zero address');
1038         return uint256(_addressData[owner].balance);
1039     }
1040 
1041     function _numberMinted(address owner) internal view returns (uint256) {
1042         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1043         return uint256(_addressData[owner].numberMinted);
1044     }
1045 
1046     /**
1047      * Gas spent here starts off proportional to the maximum mint batch size.
1048      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1049      */
1050     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1051         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1052 
1053         unchecked {
1054             for (uint256 curr = tokenId; curr >= 0; curr--) {
1055                 TokenOwnership memory ownership = _ownerships[curr];
1056                 if (ownership.addr != address(0)) {
1057                     return ownership;
1058                 }
1059             }
1060         }
1061 
1062         revert('ERC721A: unable to determine the owner of token');
1063     }
1064 
1065     /**
1066      * @dev See {IERC721-ownerOf}.
1067      */
1068     function ownerOf(uint256 tokenId) public view override returns (address) {
1069         return ownershipOf(tokenId).addr;
1070     }
1071 
1072     /**
1073      * @dev See {IERC721Metadata-name}.
1074      */
1075     function name() public view virtual override returns (string memory) {
1076         return _name;
1077     }
1078 
1079     /**
1080      * @dev See {IERC721Metadata-symbol}.
1081      */
1082     function symbol() public view virtual override returns (string memory) {
1083         return _symbol;
1084     }
1085 
1086     /**
1087      * @dev See {IERC721Metadata-tokenURI}.
1088      */
1089     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1090         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1091 
1092         string memory baseURI = _baseURI();
1093         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1094     }
1095 
1096     /**
1097      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1098      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1099      * by default, can be overriden in child contracts.
1100      */
1101     function _baseURI() internal view virtual returns (string memory) {
1102         return '';
1103     }
1104 
1105     /**
1106      * @dev See {IERC721-approve}.
1107      */
1108     function approve(address to, uint256 tokenId) public override {
1109         address owner = ERC721A.ownerOf(tokenId);
1110         require(to != owner, 'ERC721A: approval to current owner');
1111 
1112         require(
1113             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1114             'ERC721A: approve caller is not owner nor approved for all'
1115         );
1116 
1117         _approve(to, tokenId, owner);
1118     }
1119 
1120     /**
1121      * @dev See {IERC721-getApproved}.
1122      */
1123     function getApproved(uint256 tokenId) public view override returns (address) {
1124         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1125 
1126         return _tokenApprovals[tokenId];
1127     }
1128 
1129     /**
1130      * @dev See {IERC721-setApprovalForAll}.
1131      */
1132     function setApprovalForAll(address operator, bool approved) public override {
1133         require(operator != _msgSender(), 'ERC721A: approve to caller');
1134 
1135         _operatorApprovals[_msgSender()][operator] = approved;
1136         emit ApprovalForAll(_msgSender(), operator, approved);
1137     }
1138 
1139     /**
1140      * @dev See {IERC721-isApprovedForAll}.
1141      */
1142     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1143         return _operatorApprovals[owner][operator];
1144     }
1145 
1146     /**
1147      * @dev See {IERC721-transferFrom}.
1148      */
1149     function transferFrom(
1150         address from,
1151         address to,
1152         uint256 tokenId
1153     ) public override {
1154         _transfer(from, to, tokenId);
1155     }
1156 
1157     /**
1158      * @dev See {IERC721-safeTransferFrom}.
1159      */
1160     function safeTransferFrom(
1161         address from,
1162         address to,
1163         uint256 tokenId
1164     ) public override {
1165         safeTransferFrom(from, to, tokenId, '');
1166     }
1167 
1168     /**
1169      * @dev See {IERC721-safeTransferFrom}.
1170      */
1171     function safeTransferFrom(
1172         address from,
1173         address to,
1174         uint256 tokenId,
1175         bytes memory _data
1176     ) public override {
1177         _transfer(from, to, tokenId);
1178         require(
1179             _checkOnERC721Received(from, to, tokenId, _data),
1180             'ERC721A: transfer to non ERC721Receiver implementer'
1181         );
1182     }
1183 
1184     /**
1185      * @dev Returns whether `tokenId` exists.
1186      *
1187      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1188      *
1189      * Tokens start existing when they are minted (`_mint`),
1190      */
1191     function _exists(uint256 tokenId) internal view returns (bool) {
1192         return tokenId < currentIndex;
1193     }
1194 
1195     function _safeMint(address to, uint256 quantity) internal {
1196         _safeMint(to, quantity, '');
1197     }
1198 
1199     /**
1200      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1201      *
1202      * Requirements:
1203      *
1204      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1205      * - `quantity` must be greater than 0.
1206      *
1207      * Emits a {Transfer} event.
1208      */
1209     function _safeMint(
1210         address to,
1211         uint256 quantity,
1212         bytes memory _data
1213     ) internal {
1214         _mint(to, quantity, _data, true);
1215     }
1216 
1217     /**
1218      * @dev Mints `quantity` tokens and transfers them to `to`.
1219      *
1220      * Requirements:
1221      *
1222      * - `to` cannot be the zero address.
1223      * - `quantity` must be greater than 0.
1224      *
1225      * Emits a {Transfer} event.
1226      */
1227     function _mint(
1228         address to,
1229         uint256 quantity,
1230         bytes memory _data,
1231         bool safe
1232     ) internal {
1233         uint256 startTokenId = currentIndex;
1234         require(to != address(0), 'ERC721A: mint to the zero address');
1235         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1236 
1237         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1238 
1239         // Overflows are incredibly unrealistic.
1240         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1241         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1242         unchecked {
1243             _addressData[to].balance += uint128(quantity);
1244             _addressData[to].numberMinted += uint128(quantity);
1245 
1246             _ownerships[startTokenId].addr = to;
1247             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1248 
1249             uint256 updatedIndex = startTokenId;
1250 
1251             for (uint256 i; i < quantity; i++) {
1252                 emit Transfer(address(0), to, updatedIndex);
1253                 if (safe) {
1254                     require(
1255                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1256                         'ERC721A: transfer to non ERC721Receiver implementer'
1257                     );
1258                 }
1259 
1260                 updatedIndex++;
1261             }
1262 
1263             currentIndex = updatedIndex;
1264         }
1265 
1266         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1267     }
1268 
1269     /**
1270      * @dev Transfers `tokenId` from `from` to `to`.
1271      *
1272      * Requirements:
1273      *
1274      * - `to` cannot be the zero address.
1275      * - `tokenId` token must be owned by `from`.
1276      *
1277      * Emits a {Transfer} event.
1278      */
1279     function _transfer(
1280         address from,
1281         address to,
1282         uint256 tokenId
1283     ) private {
1284         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1285 
1286         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1287             getApproved(tokenId) == _msgSender() ||
1288             isApprovedForAll(prevOwnership.addr, _msgSender()));
1289 
1290         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1291 
1292         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1293         require(to != address(0), 'ERC721A: transfer to the zero address');
1294 
1295         _beforeTokenTransfers(from, to, tokenId, 1);
1296 
1297         // Clear approvals from the previous owner
1298         _approve(address(0), tokenId, prevOwnership.addr);
1299 
1300         // Underflow of the sender's balance is impossible because we check for
1301         // ownership above and the recipient's balance can't realistically overflow.
1302         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1303         unchecked {
1304             _addressData[from].balance -= 1;
1305             _addressData[to].balance += 1;
1306 
1307             _ownerships[tokenId].addr = to;
1308             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1309 
1310             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1311             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1312             uint256 nextTokenId = tokenId + 1;
1313             if (_ownerships[nextTokenId].addr == address(0)) {
1314                 if (_exists(nextTokenId)) {
1315                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1316                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1317                 }
1318             }
1319         }
1320 
1321         emit Transfer(from, to, tokenId);
1322         _afterTokenTransfers(from, to, tokenId, 1);
1323     }
1324 
1325     /**
1326      * @dev Approve `to` to operate on `tokenId`
1327      *
1328      * Emits a {Approval} event.
1329      */
1330     function _approve(
1331         address to,
1332         uint256 tokenId,
1333         address owner
1334     ) private {
1335         _tokenApprovals[tokenId] = to;
1336         emit Approval(owner, to, tokenId);
1337     }
1338 
1339     /**
1340      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1341      * The call is not executed if the target address is not a contract.
1342      *
1343      * @param from address representing the previous owner of the given token ID
1344      * @param to target address that will receive the tokens
1345      * @param tokenId uint256 ID of the token to be transferred
1346      * @param _data bytes optional data to send along with the call
1347      * @return bool whether the call correctly returned the expected magic value
1348      */
1349     function _checkOnERC721Received(
1350         address from,
1351         address to,
1352         uint256 tokenId,
1353         bytes memory _data
1354     ) private returns (bool) {
1355         if (to.isContract()) {
1356             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1357                 return retval == IERC721Receiver(to).onERC721Received.selector;
1358             } catch (bytes memory reason) {
1359                 if (reason.length == 0) {
1360                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1361                 } else {
1362                     assembly {
1363                         revert(add(32, reason), mload(reason))
1364                     }
1365                 }
1366             }
1367         } else {
1368             return true;
1369         }
1370     }
1371 
1372     /**
1373      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1374      *
1375      * startTokenId - the first token id to be transferred
1376      * quantity - the amount to be transferred
1377      *
1378      * Calling conditions:
1379      *
1380      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1381      * transferred to `to`.
1382      * - When `from` is zero, `tokenId` will be minted for `to`.
1383      */
1384     function _beforeTokenTransfers(
1385         address from,
1386         address to,
1387         uint256 startTokenId,
1388         uint256 quantity
1389     ) internal virtual {}
1390 
1391     /**
1392      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1393      * minting.
1394      *
1395      * startTokenId - the first token id to be transferred
1396      * quantity - the amount to be transferred
1397      *
1398      * Calling conditions:
1399      *
1400      * - when `from` and `to` are both non-zero.
1401      * - `from` and `to` are never both zero.
1402      */
1403     function _afterTokenTransfers(
1404         address from,
1405         address to,
1406         uint256 startTokenId,
1407         uint256 quantity
1408     ) internal virtual {}
1409 }
1410 // File: @openzeppelin/contracts/access/Ownable.sol
1411 
1412 
1413 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1414 
1415 pragma solidity ^0.8.0;
1416 
1417 
1418 /**
1419  * @dev Contract module which provides a basic access control mechanism, where
1420  * there is an account (an owner) that can be granted exclusive access to
1421  * specific functions.
1422  *
1423  * By default, the owner account will be the one that deploys the contract. This
1424  * can later be changed with {transferOwnership}.
1425  *
1426  * This module is used through inheritance. It will make available the modifier
1427  * `onlyOwner`, which can be applied to your functions to restrict their use to
1428  * the owner.
1429  */
1430 abstract contract Ownable is Context {
1431     address private _owner;
1432 
1433     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1434 
1435     /**
1436      * @dev Initializes the contract setting the deployer as the initial owner.
1437      */
1438     constructor() {
1439         _transferOwnership(_msgSender());
1440     }
1441 
1442     /**
1443      * @dev Returns the address of the current owner.
1444      */
1445     function owner() public view virtual returns (address) {
1446         return _owner;
1447     }
1448 
1449     /**
1450      * @dev Throws if called by any account other than the owner.
1451      */
1452     modifier onlyOwner() {
1453         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1454         _;
1455     }
1456 
1457     /**
1458      * @dev Leaves the contract without owner. It will not be possible to call
1459      * `onlyOwner` functions anymore. Can only be called by the current owner.
1460      *
1461      * NOTE: Renouncing ownership will leave the contract without an owner,
1462      * thereby removing any functionality that is only available to the owner.
1463      */
1464     function renounceOwnership() public virtual onlyOwner {
1465         _transferOwnership(address(0));
1466     }
1467 
1468     /**
1469      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1470      * Can only be called by the current owner.
1471      */
1472     function transferOwnership(address newOwner) public virtual onlyOwner {
1473         require(newOwner != address(0), "Ownable: new owner is the zero address");
1474         _transferOwnership(newOwner);
1475     }
1476 
1477     /**
1478      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1479      * Internal function without access restriction.
1480      */
1481     function _transferOwnership(address newOwner) internal virtual {
1482         address oldOwner = _owner;
1483         _owner = newOwner;
1484         emit OwnershipTransferred(oldOwner, newOwner);
1485     }
1486 }
1487 
1488 // File: contracts/3_Ballot.sol
1489 
1490 
1491 
1492 pragma solidity ^0.8.0;
1493 
1494 
1495 
1496 
1497 
1498 
1499 contract AkiStory is ERC721A, Ownable {
1500 
1501   using SafeMath for uint256;
1502   using Strings for uint256;
1503   string private _baseUri;
1504   string private _notRevealURI; 
1505   bool public RevealedActive = false;
1506   uint256 public Price = 0.07 ether;
1507   uint256 public MaxToken = 5555;
1508   uint256 public TokenIndex = 0;
1509   event TokenMinted(uint256 supply);
1510   enum Steps {Launch, WLMints, Allowlist, Sale, SoldOut}
1511   Steps public sellingStep;
1512   mapping (address => uint256) public MaxOgMint;
1513   mapping (address => uint256) public MaxWlMint;
1514   mapping (address => uint256) public MaxAllowListMint;
1515   mapping (address => uint256) public MaxPublicMint;
1516   bytes32 public merkleRootOG;
1517   bytes32 public merkleRootNormalWL;
1518   bytes32 public merkleRootAllowList;
1519 
1520   constructor() ERC721A("Aki Story", "AS") {sellingStep = Steps.Launch;}
1521 
1522   function _baseURI() internal view virtual override returns (string memory) { return _baseUri; }
1523 
1524   function tokenURI(uint256 tokenId) public view virtual override returns (string memory a) {
1525     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1526     if (totalSupply() >= MaxToken || RevealedActive == true) {
1527       if (tokenId < MaxToken) {
1528         uint256 offsetId = tokenId.add(MaxToken.sub(TokenIndex)).mod(MaxToken);
1529         return string(abi.encodePacked(_baseURI(), "akistory-", offsetId.toString(), ".json"));
1530       }
1531     } else { return _notRevealURI; }
1532   }
1533 
1534   function mintOG(uint8 mintAmount, address _account, bytes32[] calldata _proof) public payable {
1535     require(sellingStep == Steps.WLMints, "WLMints has not started");
1536     require(totalSupply().add(mintAmount) <= MaxToken, "Sold Out");
1537     require(isOGWhitelisted(_account, _proof), "Not Whitelisted");
1538     require(MaxOgMint[msg.sender] + mintAmount <= 3, "Max NFTs Reached");
1539     require(mintAmount > 0, "At least one should be minted");
1540     MaxOgMint[msg.sender] += mintAmount;
1541     require(Price * mintAmount <= msg.value, "Not enough funds");
1542     if(totalSupply() + mintAmount == MaxToken) { sellingStep = Steps.SoldOut; }
1543     _mint(msg.sender, mintAmount);
1544     emit TokenMinted(totalSupply());
1545   }
1546 
1547   function mintWL(uint8 mintAmount, address _account, bytes32[] calldata _proof) public payable {
1548     require(sellingStep == Steps.WLMints, "WLMints has not started");
1549     require(totalSupply().add(mintAmount) <= MaxToken, "Sold Out");
1550     require(isWalletWhiteListed(_account, _proof), "Not Whitelisted");
1551     require(mintAmount > 0, "At least one should be minted");
1552     require(MaxWlMint[msg.sender] + mintAmount <= 2, "Max NFTs Reached");
1553     MaxWlMint[msg.sender] += mintAmount;
1554     require(Price * mintAmount <= msg.value, "Not enough funds");
1555     if(totalSupply() + mintAmount == MaxToken) { sellingStep = Steps.SoldOut; }
1556     _mint(msg.sender, mintAmount);
1557     emit TokenMinted(totalSupply());
1558   }
1559 
1560   function mintAllowList(uint8 mintAmount, address _account, bytes32[] calldata _proof) public payable {
1561     require(sellingStep == Steps.Allowlist, "Allow List has not started");
1562     require(totalSupply().add(mintAmount) <= MaxToken, "Sold Out");
1563     require(isAllowList(_account, _proof), "Not Whitelisted");
1564     require(mintAmount > 0, "At least one should be minted");
1565     require(MaxAllowListMint[msg.sender] + mintAmount <= 2, "Max NFTs Reached");
1566     MaxAllowListMint[msg.sender] += mintAmount;
1567     require(Price * mintAmount <= msg.value, "Not enough funds");
1568     if(totalSupply() + mintAmount == MaxToken) { sellingStep = Steps.SoldOut; }
1569     _mint(msg.sender, mintAmount);
1570     emit TokenMinted(totalSupply());
1571   }
1572 
1573   function mint(uint8 mintAmount) public payable {
1574     require(sellingStep != Steps.SoldOut, "Sold Out");
1575     require(sellingStep == Steps.Sale, "Public Sale has not started");
1576     require(totalSupply().add(mintAmount) <= MaxToken, "Sold Out");    
1577     require(mintAmount > 0, "At least one should be minted");                                                          
1578     require(MaxPublicMint[msg.sender] + mintAmount <= 5, "Max NFTs Reached");
1579     MaxPublicMint[msg.sender] += mintAmount;
1580     require(Price * mintAmount <= msg.value, "Not enough funds"); 
1581     if(totalSupply() + mintAmount == MaxToken) { sellingStep = Steps.SoldOut; }
1582     _mint(msg.sender, mintAmount);
1583     emit TokenMinted(totalSupply());
1584   }
1585 
1586   function _mint(address recipient, uint256 quantity) internal {
1587     _safeMint(recipient, quantity);
1588   }
1589 
1590   function OwnerMint(uint256 num) public onlyOwner {
1591     require(totalSupply().add(num) <= MaxToken, "Sold Out");
1592     if(totalSupply().add(num) == MaxToken) { sellingStep = Steps.SoldOut; }    
1593     _mint(msg.sender, num);
1594     emit TokenMinted(totalSupply());
1595   }
1596 
1597   function Airdrop(uint256 num, address recipient) public onlyOwner {
1598     require(totalSupply().add(num) <= MaxToken, "Sold Out");
1599     if(totalSupply().add(num) == MaxToken) { sellingStep = Steps.SoldOut; }    
1600     _mint(recipient, num);
1601     emit TokenMinted(totalSupply());
1602   }
1603 
1604   function AirdropGroup(address[] memory receivers) external onlyOwner {
1605     require(totalSupply().add(receivers.length) <= MaxToken, "Sold Out");
1606     if(totalSupply().add(receivers.length) == MaxToken) { sellingStep = Steps.SoldOut; }    
1607     for (uint256 i = 0; i < receivers.length; i++) {
1608       Airdrop(1, receivers[i]);
1609     }
1610   }
1611 
1612   function setWL() external onlyOwner {
1613     sellingStep = Steps.WLMints;
1614   }
1615 
1616   function setAllowList() external onlyOwner {
1617     require(sellingStep == Steps.WLMints, "Active WLMints Selling Step at first");
1618     sellingStep = Steps.Allowlist;
1619   }
1620 
1621   function setSale() external onlyOwner {
1622     require(sellingStep == Steps.Allowlist, "Active Allowlist Selling Step at first");
1623     sellingStep = Steps.Sale;
1624   }
1625 
1626   function setBaseURI(string calldata baseURI) external onlyOwner {
1627     _baseUri = baseURI;
1628   }
1629 
1630   function setNotRevealURI(string memory preRevealURI) external onlyOwner {
1631     _notRevealURI = preRevealURI;
1632   }
1633 
1634   function setPrice(uint256 _newPrice) public onlyOwner {
1635     Price = _newPrice;
1636   }
1637 
1638   
1639   function _leaf(address account) internal pure returns(bytes32) {
1640     return keccak256(abi.encodePacked(account));
1641   }
1642 
1643   //// OG WHITELIST WALLETS
1644   function isOGWhitelisted(address account, bytes32[] calldata proof) internal view returns(bool) {
1645     return _verify(_leaf(account), proof);
1646   }
1647 
1648   function _verify(bytes32 leaf, bytes32[] memory proof) internal view returns(bool) {
1649     return MerkleProof.verify(proof, merkleRootOG, leaf);
1650   }
1651 
1652   function changeMerkleRootOG(bytes32 _newMerkleRootOG) external onlyOwner {
1653     merkleRootOG = _newMerkleRootOG;
1654   }
1655 
1656   //NORMAL WHITELIST WALLETS
1657   function isWalletWhiteListed(address account, bytes32[] calldata proof) internal view returns(bool) {
1658     return _verifyWL(_leaf(account), proof);
1659   }
1660 
1661   function _verifyWL(bytes32 leaf, bytes32[] memory proof) internal view returns(bool) {
1662         return MerkleProof.verify(proof, merkleRootNormalWL, leaf);
1663   }
1664 
1665   function changeMerkleRootNormalWL(bytes32 _newmerkleRootNormalWL) external onlyOwner {
1666       merkleRootNormalWL = _newmerkleRootNormalWL;
1667   }
1668 
1669   //ALLOWLIST WALLETS
1670   function isAllowList(address account, bytes32[] calldata proof) internal view returns(bool) {
1671     return _verifyAllowList(_leaf(account), proof);
1672   }
1673 
1674   function _verifyAllowList(bytes32 leaf, bytes32[] memory proof) internal view returns(bool) {
1675     return MerkleProof.verify(proof, merkleRootAllowList, leaf);
1676   }
1677 
1678   function changeMerkleRootAllowList(bytes32 _newmerkleRootAllowList) external onlyOwner {
1679     merkleRootAllowList = _newmerkleRootAllowList;
1680   }
1681   ////////////////////
1682 
1683   function getTokenByOwner(address _owner) public view returns (uint256[] memory) {
1684     uint256 tokenCount = balanceOf(_owner);
1685     uint256[] memory tokenIds = new uint256[](tokenCount);
1686     for (uint256 i; i < tokenCount; i++) {
1687       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1688     }
1689     return tokenIds;
1690   }
1691 
1692   function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1693     return ownershipOf(tokenId);
1694   }
1695 
1696   function numberMinted(address owner) public view returns (uint256) {
1697     return _numberMinted(owner);
1698   }
1699 
1700   function TurnRevealMode() public onlyOwner {
1701     RevealedActive = true;
1702   }
1703 
1704   function withdraw() public payable onlyOwner {
1705     (bool mod, ) = payable(owner()).call{value: address(this).balance}("");
1706     require(mod);
1707   }
1708   
1709 }