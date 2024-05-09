1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
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
17 library MerkleProof {
18     /**
19      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
20      * defined by `root`. For this, a `proof` must be provided, containing
21      * sibling hashes on the branch from the leaf to the root of the tree. Each
22      * pair of leaves and each pair of pre-images are assumed to be sorted.
23      */
24     function verify(
25         bytes32[] memory proof,
26         bytes32 root,
27         bytes32 leaf
28     ) internal pure returns (bool) {
29         return processProof(proof, leaf) == root;
30     }
31 
32     /**
33      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
34      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
35      * hash matches the root of the tree. When processing the proof, the pairs
36      * of leafs & pre-images are assumed to be sorted.
37      *
38      * _Available since v4.4._
39      */
40     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
41         bytes32 computedHash = leaf;
42         for (uint256 i = 0; i < proof.length; i++) {
43             bytes32 proofElement = proof[i];
44             if (computedHash <= proofElement) {
45                 // Hash(current computed hash + current element of the proof)
46                 computedHash = _efficientHash(computedHash, proofElement);
47             } else {
48                 // Hash(current element of the proof + current computed hash)
49                 computedHash = _efficientHash(proofElement, computedHash);
50             }
51         }
52         return computedHash;
53     }
54 
55     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
56         assembly {
57             mstore(0x00, a)
58             mstore(0x20, b)
59             value := keccak256(0x00, 0x40)
60         }
61     }
62 }
63 
64 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
65 
66 
67 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
68 
69 pragma solidity ^0.8.0;
70 
71 // CAUTION
72 // This version of SafeMath should only be used with Solidity 0.8 or later,
73 // because it relies on the compiler's built in overflow checks.
74 
75 /**
76  * @dev Wrappers over Solidity's arithmetic operations.
77  *
78  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
79  * now has built in overflow checking.
80  */
81 library SafeMath {
82     /**
83      * @dev Returns the addition of two unsigned integers, with an overflow flag.
84      *
85      * _Available since v3.4._
86      */
87     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
88         unchecked {
89             uint256 c = a + b;
90             if (c < a) return (false, 0);
91             return (true, c);
92         }
93     }
94 
95     /**
96      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
97      *
98      * _Available since v3.4._
99      */
100     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
101         unchecked {
102             if (b > a) return (false, 0);
103             return (true, a - b);
104         }
105     }
106 
107     /**
108      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
109      *
110      * _Available since v3.4._
111      */
112     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
113         unchecked {
114             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
115             // benefit is lost if 'b' is also tested.
116             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
117             if (a == 0) return (true, 0);
118             uint256 c = a * b;
119             if (c / a != b) return (false, 0);
120             return (true, c);
121         }
122     }
123 
124     /**
125      * @dev Returns the division of two unsigned integers, with a division by zero flag.
126      *
127      * _Available since v3.4._
128      */
129     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
130         unchecked {
131             if (b == 0) return (false, 0);
132             return (true, a / b);
133         }
134     }
135 
136     /**
137      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
138      *
139      * _Available since v3.4._
140      */
141     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
142         unchecked {
143             if (b == 0) return (false, 0);
144             return (true, a % b);
145         }
146     }
147 
148     /**
149      * @dev Returns the addition of two unsigned integers, reverting on
150      * overflow.
151      *
152      * Counterpart to Solidity's `+` operator.
153      *
154      * Requirements:
155      *
156      * - Addition cannot overflow.
157      */
158     function add(uint256 a, uint256 b) internal pure returns (uint256) {
159         return a + b;
160     }
161 
162     /**
163      * @dev Returns the subtraction of two unsigned integers, reverting on
164      * overflow (when the result is negative).
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
173         return a - b;
174     }
175 
176     /**
177      * @dev Returns the multiplication of two unsigned integers, reverting on
178      * overflow.
179      *
180      * Counterpart to Solidity's `*` operator.
181      *
182      * Requirements:
183      *
184      * - Multiplication cannot overflow.
185      */
186     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187         return a * b;
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers, reverting on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator.
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b) internal pure returns (uint256) {
201         return a / b;
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * reverting when dividing by zero.
207      *
208      * Counterpart to Solidity's `%` operator. This function uses a `revert`
209      * opcode (which leaves remaining gas untouched) while Solidity uses an
210      * invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
217         return a % b;
218     }
219 
220     /**
221      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
222      * overflow (when the result is negative).
223      *
224      * CAUTION: This function is deprecated because it requires allocating memory for the error
225      * message unnecessarily. For custom revert reasons use {trySub}.
226      *
227      * Counterpart to Solidity's `-` operator.
228      *
229      * Requirements:
230      *
231      * - Subtraction cannot overflow.
232      */
233     function sub(
234         uint256 a,
235         uint256 b,
236         string memory errorMessage
237     ) internal pure returns (uint256) {
238         unchecked {
239             require(b <= a, errorMessage);
240             return a - b;
241         }
242     }
243 
244     /**
245      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
246      * division by zero. The result is rounded towards zero.
247      *
248      * Counterpart to Solidity's `/` operator. Note: this function uses a
249      * `revert` opcode (which leaves remaining gas untouched) while Solidity
250      * uses an invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      *
254      * - The divisor cannot be zero.
255      */
256     function div(
257         uint256 a,
258         uint256 b,
259         string memory errorMessage
260     ) internal pure returns (uint256) {
261         unchecked {
262             require(b > 0, errorMessage);
263             return a / b;
264         }
265     }
266 
267     /**
268      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
269      * reverting with custom message when dividing by zero.
270      *
271      * CAUTION: This function is deprecated because it requires allocating memory for the error
272      * message unnecessarily. For custom revert reasons use {tryMod}.
273      *
274      * Counterpart to Solidity's `%` operator. This function uses a `revert`
275      * opcode (which leaves remaining gas untouched) while Solidity uses an
276      * invalid opcode to revert (consuming all remaining gas).
277      *
278      * Requirements:
279      *
280      * - The divisor cannot be zero.
281      */
282     function mod(
283         uint256 a,
284         uint256 b,
285         string memory errorMessage
286     ) internal pure returns (uint256) {
287         unchecked {
288             require(b > 0, errorMessage);
289             return a % b;
290         }
291     }
292 }
293 
294 // File: @openzeppelin/contracts/utils/Strings.sol
295 
296 
297 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
298 
299 pragma solidity ^0.8.0;
300 
301 /**
302  * @dev String operations.
303  */
304 library Strings {
305     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
306 
307     /**
308      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
309      */
310     function toString(uint256 value) internal pure returns (string memory) {
311         // Inspired by OraclizeAPI's implementation - MIT licence
312         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
313 
314         if (value == 0) {
315             return "0";
316         }
317         uint256 temp = value;
318         uint256 digits;
319         while (temp != 0) {
320             digits++;
321             temp /= 10;
322         }
323         bytes memory buffer = new bytes(digits);
324         while (value != 0) {
325             digits -= 1;
326             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
327             value /= 10;
328         }
329         return string(buffer);
330     }
331 
332     /**
333      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
334      */
335     function toHexString(uint256 value) internal pure returns (string memory) {
336         if (value == 0) {
337             return "0x00";
338         }
339         uint256 temp = value;
340         uint256 length = 0;
341         while (temp != 0) {
342             length++;
343             temp >>= 8;
344         }
345         return toHexString(value, length);
346     }
347 
348     /**
349      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
350      */
351     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
352         bytes memory buffer = new bytes(2 * length + 2);
353         buffer[0] = "0";
354         buffer[1] = "x";
355         for (uint256 i = 2 * length + 1; i > 1; --i) {
356             buffer[i] = _HEX_SYMBOLS[value & 0xf];
357             value >>= 4;
358         }
359         require(value == 0, "Strings: hex length insufficient");
360         return string(buffer);
361     }
362 }
363 
364 // File: @openzeppelin/contracts/utils/Address.sol
365 
366 
367 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
368 
369 pragma solidity ^0.8.1;
370 
371 /**
372  * @dev Collection of functions related to the address type
373  */
374 library Address {
375     /**
376      * @dev Returns true if `account` is a contract.
377      *
378      * [IMPORTANT]
379      * ====
380      * It is unsafe to assume that an address for which this function returns
381      * false is an externally-owned account (EOA) and not a contract.
382      *
383      * Among others, `isContract` will return false for the following
384      * types of addresses:
385      *
386      *  - an externally-owned account
387      *  - a contract in construction
388      *  - an address where a contract will be created
389      *  - an address where a contract lived, but was destroyed
390      * ====
391      *
392      * [IMPORTANT]
393      * ====
394      * You shouldn't rely on `isContract` to protect against flash loan attacks!
395      *
396      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
397      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
398      * constructor.
399      * ====
400      */
401     function isContract(address account) internal view returns (bool) {
402         // This method relies on extcodesize/address.code.length, which returns 0
403         // for contracts in construction, since the code is only stored at the end
404         // of the constructor execution.
405 
406         return account.code.length > 0;
407     }
408 
409     /**
410      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
411      * `recipient`, forwarding all available gas and reverting on errors.
412      *
413      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
414      * of certain opcodes, possibly making contracts go over the 2300 gas limit
415      * imposed by `transfer`, making them unable to receive funds via
416      * `transfer`. {sendValue} removes this limitation.
417      *
418      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
419      *
420      * IMPORTANT: because control is transferred to `recipient`, care must be
421      * taken to not create reentrancy vulnerabilities. Consider using
422      * {ReentrancyGuard} or the
423      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
424      */
425     function sendValue(address payable recipient, uint256 amount) internal {
426         require(address(this).balance >= amount, "Address: insufficient balance");
427 
428         (bool success, ) = recipient.call{value: amount}("");
429         require(success, "Address: unable to send value, recipient may have reverted");
430     }
431 
432     /**
433      * @dev Performs a Solidity function call using a low level `call`. A
434      * plain `call` is an unsafe replacement for a function call: use this
435      * function instead.
436      *
437      * If `target` reverts with a revert reason, it is bubbled up by this
438      * function (like regular Solidity function calls).
439      *
440      * Returns the raw returned data. To convert to the expected return value,
441      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
442      *
443      * Requirements:
444      *
445      * - `target` must be a contract.
446      * - calling `target` with `data` must not revert.
447      *
448      * _Available since v3.1._
449      */
450     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
451         return functionCall(target, data, "Address: low-level call failed");
452     }
453 
454     /**
455      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
456      * `errorMessage` as a fallback revert reason when `target` reverts.
457      *
458      * _Available since v3.1._
459      */
460     function functionCall(
461         address target,
462         bytes memory data,
463         string memory errorMessage
464     ) internal returns (bytes memory) {
465         return functionCallWithValue(target, data, 0, errorMessage);
466     }
467 
468     /**
469      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
470      * but also transferring `value` wei to `target`.
471      *
472      * Requirements:
473      *
474      * - the calling contract must have an ETH balance of at least `value`.
475      * - the called Solidity function must be `payable`.
476      *
477      * _Available since v3.1._
478      */
479     function functionCallWithValue(
480         address target,
481         bytes memory data,
482         uint256 value
483     ) internal returns (bytes memory) {
484         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
485     }
486 
487     /**
488      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
489      * with `errorMessage` as a fallback revert reason when `target` reverts.
490      *
491      * _Available since v3.1._
492      */
493     function functionCallWithValue(
494         address target,
495         bytes memory data,
496         uint256 value,
497         string memory errorMessage
498     ) internal returns (bytes memory) {
499         require(address(this).balance >= value, "Address: insufficient balance for call");
500         require(isContract(target), "Address: call to non-contract");
501 
502         (bool success, bytes memory returndata) = target.call{value: value}(data);
503         return verifyCallResult(success, returndata, errorMessage);
504     }
505 
506     /**
507      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
508      * but performing a static call.
509      *
510      * _Available since v3.3._
511      */
512     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
513         return functionStaticCall(target, data, "Address: low-level static call failed");
514     }
515 
516     /**
517      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
518      * but performing a static call.
519      *
520      * _Available since v3.3._
521      */
522     function functionStaticCall(
523         address target,
524         bytes memory data,
525         string memory errorMessage
526     ) internal view returns (bytes memory) {
527         require(isContract(target), "Address: static call to non-contract");
528 
529         (bool success, bytes memory returndata) = target.staticcall(data);
530         return verifyCallResult(success, returndata, errorMessage);
531     }
532 
533     /**
534      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
535      * but performing a delegate call.
536      *
537      * _Available since v3.4._
538      */
539     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
540         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
541     }
542 
543     /**
544      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
545      * but performing a delegate call.
546      *
547      * _Available since v3.4._
548      */
549     function functionDelegateCall(
550         address target,
551         bytes memory data,
552         string memory errorMessage
553     ) internal returns (bytes memory) {
554         require(isContract(target), "Address: delegate call to non-contract");
555 
556         (bool success, bytes memory returndata) = target.delegatecall(data);
557         return verifyCallResult(success, returndata, errorMessage);
558     }
559 
560     /**
561      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
562      * revert reason using the provided one.
563      *
564      * _Available since v4.3._
565      */
566     function verifyCallResult(
567         bool success,
568         bytes memory returndata,
569         string memory errorMessage
570     ) internal pure returns (bytes memory) {
571         if (success) {
572             return returndata;
573         } else {
574             // Look for revert reason and bubble it up if present
575             if (returndata.length > 0) {
576                 // The easiest way to bubble the revert reason is using memory via assembly
577 
578                 assembly {
579                     let returndata_size := mload(returndata)
580                     revert(add(32, returndata), returndata_size)
581                 }
582             } else {
583                 revert(errorMessage);
584             }
585         }
586     }
587 }
588 
589 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
590 
591 
592 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
593 
594 pragma solidity ^0.8.0;
595 
596 /**
597  * @title ERC721 token receiver interface
598  * @dev Interface for any contract that wants to support safeTransfers
599  * from ERC721 asset contracts.
600  */
601 interface IERC721Receiver {
602     /**
603      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
604      * by `operator` from `from`, this function is called.
605      *
606      * It must return its Solidity selector to confirm the token transfer.
607      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
608      *
609      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
610      */
611     function onERC721Received(
612         address operator,
613         address from,
614         uint256 tokenId,
615         bytes calldata data
616     ) external returns (bytes4);
617 }
618 
619 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
620 
621 
622 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
623 
624 pragma solidity ^0.8.0;
625 
626 /**
627  * @dev Interface of the ERC165 standard, as defined in the
628  * https://eips.ethereum.org/EIPS/eip-165[EIP].
629  *
630  * Implementers can declare support of contract interfaces, which can then be
631  * queried by others ({ERC165Checker}).
632  *
633  * For an implementation, see {ERC165}.
634  */
635 interface IERC165 {
636     /**
637      * @dev Returns true if this contract implements the interface defined by
638      * `interfaceId`. See the corresponding
639      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
640      * to learn more about how these ids are created.
641      *
642      * This function call must use less than 30 000 gas.
643      */
644     function supportsInterface(bytes4 interfaceId) external view returns (bool);
645 }
646 
647 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
648 
649 
650 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
651 
652 pragma solidity ^0.8.0;
653 
654 
655 /**
656  * @dev Implementation of the {IERC165} interface.
657  *
658  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
659  * for the additional interface id that will be supported. For example:
660  *
661  * ```solidity
662  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
663  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
664  * }
665  * ```
666  *
667  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
668  */
669 abstract contract ERC165 is IERC165 {
670     /**
671      * @dev See {IERC165-supportsInterface}.
672      */
673     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
674         return interfaceId == type(IERC165).interfaceId;
675     }
676 }
677 
678 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
679 
680 
681 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
682 
683 pragma solidity ^0.8.0;
684 
685 
686 /**
687  * @dev Required interface of an ERC721 compliant contract.
688  */
689 interface IERC721 is IERC165 {
690     /**
691      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
692      */
693     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
694 
695     /**
696      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
697      */
698     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
699 
700     /**
701      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
702      */
703     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
704 
705     /**
706      * @dev Returns the number of tokens in ``owner``'s account.
707      */
708     function balanceOf(address owner) external view returns (uint256 balance);
709 
710     /**
711      * @dev Returns the owner of the `tokenId` token.
712      *
713      * Requirements:
714      *
715      * - `tokenId` must exist.
716      */
717     function ownerOf(uint256 tokenId) external view returns (address owner);
718 
719     /**
720      * @dev Safely transfers `tokenId` token from `from` to `to`.
721      *
722      * Requirements:
723      *
724      * - `from` cannot be the zero address.
725      * - `to` cannot be the zero address.
726      * - `tokenId` token must exist and be owned by `from`.
727      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
728      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
729      *
730      * Emits a {Transfer} event.
731      */
732     function safeTransferFrom(
733         address from,
734         address to,
735         uint256 tokenId,
736         bytes calldata data
737     ) external;
738 
739     /**
740      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
741      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
742      *
743      * Requirements:
744      *
745      * - `from` cannot be the zero address.
746      * - `to` cannot be the zero address.
747      * - `tokenId` token must exist and be owned by `from`.
748      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
749      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
750      *
751      * Emits a {Transfer} event.
752      */
753     function safeTransferFrom(
754         address from,
755         address to,
756         uint256 tokenId
757     ) external;
758 
759     /**
760      * @dev Transfers `tokenId` token from `from` to `to`.
761      *
762      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
763      *
764      * Requirements:
765      *
766      * - `from` cannot be the zero address.
767      * - `to` cannot be the zero address.
768      * - `tokenId` token must be owned by `from`.
769      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
770      *
771      * Emits a {Transfer} event.
772      */
773     function transferFrom(
774         address from,
775         address to,
776         uint256 tokenId
777     ) external;
778 
779     /**
780      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
781      * The approval is cleared when the token is transferred.
782      *
783      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
784      *
785      * Requirements:
786      *
787      * - The caller must own the token or be an approved operator.
788      * - `tokenId` must exist.
789      *
790      * Emits an {Approval} event.
791      */
792     function approve(address to, uint256 tokenId) external;
793 
794     /**
795      * @dev Approve or remove `operator` as an operator for the caller.
796      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
797      *
798      * Requirements:
799      *
800      * - The `operator` cannot be the caller.
801      *
802      * Emits an {ApprovalForAll} event.
803      */
804     function setApprovalForAll(address operator, bool _approved) external;
805 
806     /**
807      * @dev Returns the account approved for `tokenId` token.
808      *
809      * Requirements:
810      *
811      * - `tokenId` must exist.
812      */
813     function getApproved(uint256 tokenId) external view returns (address operator);
814 
815     /**
816      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
817      *
818      * See {setApprovalForAll}
819      */
820     function isApprovedForAll(address owner, address operator) external view returns (bool);
821 }
822 
823 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
824 
825 
826 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
827 
828 pragma solidity ^0.8.0;
829 
830 
831 /**
832  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
833  * @dev See https://eips.ethereum.org/EIPS/eip-721
834  */
835 interface IERC721Enumerable is IERC721 {
836     /**
837      * @dev Returns the total amount of tokens stored by the contract.
838      */
839     function totalSupply() external view returns (uint256);
840 
841     /**
842      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
843      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
844      */
845     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
846 
847     /**
848      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
849      * Use along with {totalSupply} to enumerate all tokens.
850      */
851     function tokenByIndex(uint256 index) external view returns (uint256);
852 }
853 
854 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
855 
856 
857 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
858 
859 pragma solidity ^0.8.0;
860 
861 
862 /**
863  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
864  * @dev See https://eips.ethereum.org/EIPS/eip-721
865  */
866 interface IERC721Metadata is IERC721 {
867     /**
868      * @dev Returns the token collection name.
869      */
870     function name() external view returns (string memory);
871 
872     /**
873      * @dev Returns the token collection symbol.
874      */
875     function symbol() external view returns (string memory);
876 
877     /**
878      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
879      */
880     function tokenURI(uint256 tokenId) external view returns (string memory);
881 }
882 
883 // File: @openzeppelin/contracts/utils/Context.sol
884 
885 
886 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
887 
888 pragma solidity ^0.8.0;
889 
890 /**
891  * @dev Provides information about the current execution context, including the
892  * sender of the transaction and its data. While these are generally available
893  * via msg.sender and msg.data, they should not be accessed in such a direct
894  * manner, since when dealing with meta-transactions the account sending and
895  * paying for execution may not be the actual sender (as far as an application
896  * is concerned).
897  *
898  * This contract is only required for intermediate, library-like contracts.
899  */
900 abstract contract Context {
901     function _msgSender() internal view virtual returns (address) {
902         return msg.sender;
903     }
904 
905     function _msgData() internal view virtual returns (bytes calldata) {
906         return msg.data;
907     }
908 }
909 
910 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
911 
912 
913 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
914 
915 pragma solidity ^0.8.0;
916 
917 
918 
919 
920 
921 
922 
923 
924 /**
925  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
926  * the Metadata extension, but not including the Enumerable extension, which is available separately as
927  * {ERC721Enumerable}.
928  */
929 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
930     using Address for address;
931     using Strings for uint256;
932 
933     // Token name
934     string private _name;
935 
936     // Token symbol
937     string private _symbol;
938 
939     // Mapping from token ID to owner address
940     mapping(uint256 => address) private _owners;
941 
942     // Mapping owner address to token count
943     mapping(address => uint256) private _balances;
944 
945     // Mapping from token ID to approved address
946     mapping(uint256 => address) private _tokenApprovals;
947 
948     // Mapping from owner to operator approvals
949     mapping(address => mapping(address => bool)) private _operatorApprovals;
950 
951     /**
952      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
953      */
954     constructor(string memory name_, string memory symbol_) {
955         _name = name_;
956         _symbol = symbol_;
957     }
958 
959     /**
960      * @dev See {IERC165-supportsInterface}.
961      */
962     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
963         return
964             interfaceId == type(IERC721).interfaceId ||
965             interfaceId == type(IERC721Metadata).interfaceId ||
966             super.supportsInterface(interfaceId);
967     }
968 
969     /**
970      * @dev See {IERC721-balanceOf}.
971      */
972     function balanceOf(address owner) public view virtual override returns (uint256) {
973         require(owner != address(0), "ERC721: balance query for the zero address");
974         return _balances[owner];
975     }
976 
977     /**
978      * @dev See {IERC721-ownerOf}.
979      */
980     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
981         address owner = _owners[tokenId];
982         require(owner != address(0), "ERC721: owner query for nonexistent token");
983         return owner;
984     }
985 
986     /**
987      * @dev See {IERC721Metadata-name}.
988      */
989     function name() public view virtual override returns (string memory) {
990         return _name;
991     }
992 
993     /**
994      * @dev See {IERC721Metadata-symbol}.
995      */
996     function symbol() public view virtual override returns (string memory) {
997         return _symbol;
998     }
999 
1000     /**
1001      * @dev See {IERC721Metadata-tokenURI}.
1002      */
1003     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1004         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1005 
1006         string memory baseURI = _baseURI();
1007         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1008     }
1009 
1010     /**
1011      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1012      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1013      * by default, can be overridden in child contracts.
1014      */
1015     function _baseURI() internal view virtual returns (string memory) {
1016         return "";
1017     }
1018 
1019     /**
1020      * @dev See {IERC721-approve}.
1021      */
1022     function approve(address to, uint256 tokenId) public virtual override {
1023         address owner = ERC721.ownerOf(tokenId);
1024         require(to != owner, "ERC721: approval to current owner");
1025 
1026         require(
1027             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1028             "ERC721: approve caller is not owner nor approved for all"
1029         );
1030 
1031         _approve(to, tokenId);
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-getApproved}.
1036      */
1037     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1038         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1039 
1040         return _tokenApprovals[tokenId];
1041     }
1042 
1043     /**
1044      * @dev See {IERC721-setApprovalForAll}.
1045      */
1046     function setApprovalForAll(address operator, bool approved) public virtual override {
1047         _setApprovalForAll(_msgSender(), operator, approved);
1048     }
1049 
1050     /**
1051      * @dev See {IERC721-isApprovedForAll}.
1052      */
1053     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1054         return _operatorApprovals[owner][operator];
1055     }
1056 
1057     /**
1058      * @dev See {IERC721-transferFrom}.
1059      */
1060     function transferFrom(
1061         address from,
1062         address to,
1063         uint256 tokenId
1064     ) public virtual override {
1065         //solhint-disable-next-line max-line-length
1066         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1067 
1068         _transfer(from, to, tokenId);
1069     }
1070 
1071     /**
1072      * @dev See {IERC721-safeTransferFrom}.
1073      */
1074     function safeTransferFrom(
1075         address from,
1076         address to,
1077         uint256 tokenId
1078     ) public virtual override {
1079         safeTransferFrom(from, to, tokenId, "");
1080     }
1081 
1082     /**
1083      * @dev See {IERC721-safeTransferFrom}.
1084      */
1085     function safeTransferFrom(
1086         address from,
1087         address to,
1088         uint256 tokenId,
1089         bytes memory _data
1090     ) public virtual override {
1091         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1092         _safeTransfer(from, to, tokenId, _data);
1093     }
1094 
1095     /**
1096      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1097      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1098      *
1099      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1100      *
1101      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1102      * implement alternative mechanisms to perform token transfer, such as signature-based.
1103      *
1104      * Requirements:
1105      *
1106      * - `from` cannot be the zero address.
1107      * - `to` cannot be the zero address.
1108      * - `tokenId` token must exist and be owned by `from`.
1109      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1110      *
1111      * Emits a {Transfer} event.
1112      */
1113     function _safeTransfer(
1114         address from,
1115         address to,
1116         uint256 tokenId,
1117         bytes memory _data
1118     ) internal virtual {
1119         _transfer(from, to, tokenId);
1120         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1121     }
1122 
1123     /**
1124      * @dev Returns whether `tokenId` exists.
1125      *
1126      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1127      *
1128      * Tokens start existing when they are minted (`_mint`),
1129      * and stop existing when they are burned (`_burn`).
1130      */
1131     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1132         return _owners[tokenId] != address(0);
1133     }
1134 
1135     /**
1136      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1137      *
1138      * Requirements:
1139      *
1140      * - `tokenId` must exist.
1141      */
1142     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1143         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1144         address owner = ERC721.ownerOf(tokenId);
1145         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1146     }
1147 
1148     /**
1149      * @dev Safely mints `tokenId` and transfers it to `to`.
1150      *
1151      * Requirements:
1152      *
1153      * - `tokenId` must not exist.
1154      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1155      *
1156      * Emits a {Transfer} event.
1157      */
1158     function _safeMint(address to, uint256 tokenId) internal virtual {
1159         _safeMint(to, tokenId, "");
1160     }
1161 
1162     /**
1163      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1164      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1165      */
1166     function _safeMint(
1167         address to,
1168         uint256 tokenId,
1169         bytes memory _data
1170     ) internal virtual {
1171         _mint(to, tokenId);
1172         require(
1173             _checkOnERC721Received(address(0), to, tokenId, _data),
1174             "ERC721: transfer to non ERC721Receiver implementer"
1175         );
1176     }
1177 
1178     /**
1179      * @dev Mints `tokenId` and transfers it to `to`.
1180      *
1181      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1182      *
1183      * Requirements:
1184      *
1185      * - `tokenId` must not exist.
1186      * - `to` cannot be the zero address.
1187      *
1188      * Emits a {Transfer} event.
1189      */
1190     function _mint(address to, uint256 tokenId) internal virtual {
1191         require(to != address(0), "ERC721: mint to the zero address");
1192         require(!_exists(tokenId), "ERC721: token already minted");
1193 
1194         _beforeTokenTransfer(address(0), to, tokenId);
1195 
1196         _balances[to] += 1;
1197         _owners[tokenId] = to;
1198 
1199         emit Transfer(address(0), to, tokenId);
1200 
1201         _afterTokenTransfer(address(0), to, tokenId);
1202     }
1203 
1204     /**
1205      * @dev Destroys `tokenId`.
1206      * The approval is cleared when the token is burned.
1207      *
1208      * Requirements:
1209      *
1210      * - `tokenId` must exist.
1211      *
1212      * Emits a {Transfer} event.
1213      */
1214     function _burn(uint256 tokenId) internal virtual {
1215         address owner = ERC721.ownerOf(tokenId);
1216 
1217         _beforeTokenTransfer(owner, address(0), tokenId);
1218 
1219         // Clear approvals
1220         _approve(address(0), tokenId);
1221 
1222         _balances[owner] -= 1;
1223         delete _owners[tokenId];
1224 
1225         emit Transfer(owner, address(0), tokenId);
1226 
1227         _afterTokenTransfer(owner, address(0), tokenId);
1228     }
1229 
1230     /**
1231      * @dev Transfers `tokenId` from `from` to `to`.
1232      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1233      *
1234      * Requirements:
1235      *
1236      * - `to` cannot be the zero address.
1237      * - `tokenId` token must be owned by `from`.
1238      *
1239      * Emits a {Transfer} event.
1240      */
1241     function _transfer(
1242         address from,
1243         address to,
1244         uint256 tokenId
1245     ) internal virtual {
1246         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1247         require(to != address(0), "ERC721: transfer to the zero address");
1248 
1249         _beforeTokenTransfer(from, to, tokenId);
1250 
1251         // Clear approvals from the previous owner
1252         _approve(address(0), tokenId);
1253 
1254         _balances[from] -= 1;
1255         _balances[to] += 1;
1256         _owners[tokenId] = to;
1257 
1258         emit Transfer(from, to, tokenId);
1259 
1260         _afterTokenTransfer(from, to, tokenId);
1261     }
1262 
1263     /**
1264      * @dev Approve `to` to operate on `tokenId`
1265      *
1266      * Emits a {Approval} event.
1267      */
1268     function _approve(address to, uint256 tokenId) internal virtual {
1269         _tokenApprovals[tokenId] = to;
1270         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1271     }
1272 
1273     /**
1274      * @dev Approve `operator` to operate on all of `owner` tokens
1275      *
1276      * Emits a {ApprovalForAll} event.
1277      */
1278     function _setApprovalForAll(
1279         address owner,
1280         address operator,
1281         bool approved
1282     ) internal virtual {
1283         require(owner != operator, "ERC721: approve to caller");
1284         _operatorApprovals[owner][operator] = approved;
1285         emit ApprovalForAll(owner, operator, approved);
1286     }
1287 
1288     /**
1289      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1290      * The call is not executed if the target address is not a contract.
1291      *
1292      * @param from address representing the previous owner of the given token ID
1293      * @param to target address that will receive the tokens
1294      * @param tokenId uint256 ID of the token to be transferred
1295      * @param _data bytes optional data to send along with the call
1296      * @return bool whether the call correctly returned the expected magic value
1297      */
1298     function _checkOnERC721Received(
1299         address from,
1300         address to,
1301         uint256 tokenId,
1302         bytes memory _data
1303     ) private returns (bool) {
1304         if (to.isContract()) {
1305             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1306                 return retval == IERC721Receiver.onERC721Received.selector;
1307             } catch (bytes memory reason) {
1308                 if (reason.length == 0) {
1309                     revert("ERC721: transfer to non ERC721Receiver implementer");
1310                 } else {
1311                     assembly {
1312                         revert(add(32, reason), mload(reason))
1313                     }
1314                 }
1315             }
1316         } else {
1317             return true;
1318         }
1319     }
1320 
1321     /**
1322      * @dev Hook that is called before any token transfer. This includes minting
1323      * and burning.
1324      *
1325      * Calling conditions:
1326      *
1327      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1328      * transferred to `to`.
1329      * - When `from` is zero, `tokenId` will be minted for `to`.
1330      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1331      * - `from` and `to` are never both zero.
1332      *
1333      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1334      */
1335     function _beforeTokenTransfer(
1336         address from,
1337         address to,
1338         uint256 tokenId
1339     ) internal virtual {}
1340 
1341     /**
1342      * @dev Hook that is called after any transfer of tokens. This includes
1343      * minting and burning.
1344      *
1345      * Calling conditions:
1346      *
1347      * - when `from` and `to` are both non-zero.
1348      * - `from` and `to` are never both zero.
1349      *
1350      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1351      */
1352     function _afterTokenTransfer(
1353         address from,
1354         address to,
1355         uint256 tokenId
1356     ) internal virtual {}
1357 }
1358 
1359 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1360 
1361 
1362 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1363 
1364 pragma solidity ^0.8.0;
1365 
1366 
1367 
1368 /**
1369  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1370  * enumerability of all the token ids in the contract as well as all token ids owned by each
1371  * account.
1372  */
1373 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1374     // Mapping from owner to list of owned token IDs
1375     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1376 
1377     // Mapping from token ID to index of the owner tokens list
1378     mapping(uint256 => uint256) private _ownedTokensIndex;
1379 
1380     // Array with all token ids, used for enumeration
1381     uint256[] private _allTokens;
1382 
1383     // Mapping from token id to position in the allTokens array
1384     mapping(uint256 => uint256) private _allTokensIndex;
1385 
1386     /**
1387      * @dev See {IERC165-supportsInterface}.
1388      */
1389     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1390         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1391     }
1392 
1393     /**
1394      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1395      */
1396     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1397         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1398         return _ownedTokens[owner][index];
1399     }
1400 
1401     /**
1402      * @dev See {IERC721Enumerable-totalSupply}.
1403      */
1404     function totalSupply() public view virtual override returns (uint256) {
1405         return _allTokens.length;
1406     }
1407 
1408     /**
1409      * @dev See {IERC721Enumerable-tokenByIndex}.
1410      */
1411     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1412         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1413         return _allTokens[index];
1414     }
1415 
1416     /**
1417      * @dev Hook that is called before any token transfer. This includes minting
1418      * and burning.
1419      *
1420      * Calling conditions:
1421      *
1422      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1423      * transferred to `to`.
1424      * - When `from` is zero, `tokenId` will be minted for `to`.
1425      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1426      * - `from` cannot be the zero address.
1427      * - `to` cannot be the zero address.
1428      *
1429      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1430      */
1431     function _beforeTokenTransfer(
1432         address from,
1433         address to,
1434         uint256 tokenId
1435     ) internal virtual override {
1436         super._beforeTokenTransfer(from, to, tokenId);
1437 
1438         if (from == address(0)) {
1439             _addTokenToAllTokensEnumeration(tokenId);
1440         } else if (from != to) {
1441             _removeTokenFromOwnerEnumeration(from, tokenId);
1442         }
1443         if (to == address(0)) {
1444             _removeTokenFromAllTokensEnumeration(tokenId);
1445         } else if (to != from) {
1446             _addTokenToOwnerEnumeration(to, tokenId);
1447         }
1448     }
1449 
1450     /**
1451      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1452      * @param to address representing the new owner of the given token ID
1453      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1454      */
1455     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1456         uint256 length = ERC721.balanceOf(to);
1457         _ownedTokens[to][length] = tokenId;
1458         _ownedTokensIndex[tokenId] = length;
1459     }
1460 
1461     /**
1462      * @dev Private function to add a token to this extension's token tracking data structures.
1463      * @param tokenId uint256 ID of the token to be added to the tokens list
1464      */
1465     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1466         _allTokensIndex[tokenId] = _allTokens.length;
1467         _allTokens.push(tokenId);
1468     }
1469 
1470     /**
1471      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1472      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1473      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1474      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1475      * @param from address representing the previous owner of the given token ID
1476      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1477      */
1478     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1479         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1480         // then delete the last slot (swap and pop).
1481 
1482         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1483         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1484 
1485         // When the token to delete is the last token, the swap operation is unnecessary
1486         if (tokenIndex != lastTokenIndex) {
1487             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1488 
1489             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1490             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1491         }
1492 
1493         // This also deletes the contents at the last position of the array
1494         delete _ownedTokensIndex[tokenId];
1495         delete _ownedTokens[from][lastTokenIndex];
1496     }
1497 
1498     /**
1499      * @dev Private function to remove a token from this extension's token tracking data structures.
1500      * This has O(1) time complexity, but alters the order of the _allTokens array.
1501      * @param tokenId uint256 ID of the token to be removed from the tokens list
1502      */
1503     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1504         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1505         // then delete the last slot (swap and pop).
1506 
1507         uint256 lastTokenIndex = _allTokens.length - 1;
1508         uint256 tokenIndex = _allTokensIndex[tokenId];
1509 
1510         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1511         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1512         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1513         uint256 lastTokenId = _allTokens[lastTokenIndex];
1514 
1515         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1516         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1517 
1518         // This also deletes the contents at the last position of the array
1519         delete _allTokensIndex[tokenId];
1520         _allTokens.pop();
1521     }
1522 }
1523 
1524 // File: @openzeppelin/contracts/security/Pausable.sol
1525 
1526 
1527 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1528 
1529 pragma solidity ^0.8.0;
1530 
1531 
1532 /**
1533  * @dev Contract module which allows children to implement an emergency stop
1534  * mechanism that can be triggered by an authorized account.
1535  *
1536  * This module is used through inheritance. It will make available the
1537  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1538  * the functions of your contract. Note that they will not be pausable by
1539  * simply including this module, only once the modifiers are put in place.
1540  */
1541 abstract contract Pausable is Context {
1542     /**
1543      * @dev Emitted when the pause is triggered by `account`.
1544      */
1545     event Paused(address account);
1546 
1547     /**
1548      * @dev Emitted when the pause is lifted by `account`.
1549      */
1550     event Unpaused(address account);
1551 
1552     bool private _paused;
1553 
1554     /**
1555      * @dev Initializes the contract in unpaused state.
1556      */
1557     constructor() {
1558         _paused = false;
1559     }
1560 
1561     /**
1562      * @dev Returns true if the contract is paused, and false otherwise.
1563      */
1564     function paused() public view virtual returns (bool) {
1565         return _paused;
1566     }
1567 
1568     /**
1569      * @dev Modifier to make a function callable only when the contract is not paused.
1570      *
1571      * Requirements:
1572      *
1573      * - The contract must not be paused.
1574      */
1575     modifier whenNotPaused() {
1576         require(!paused(), "Pausable: paused");
1577         _;
1578     }
1579 
1580     /**
1581      * @dev Modifier to make a function callable only when the contract is paused.
1582      *
1583      * Requirements:
1584      *
1585      * - The contract must be paused.
1586      */
1587     modifier whenPaused() {
1588         require(paused(), "Pausable: not paused");
1589         _;
1590     }
1591 
1592     /**
1593      * @dev Triggers stopped state.
1594      *
1595      * Requirements:
1596      *
1597      * - The contract must not be paused.
1598      */
1599     function _pause() internal virtual whenNotPaused {
1600         _paused = true;
1601         emit Paused(_msgSender());
1602     }
1603 
1604     /**
1605      * @dev Returns to normal state.
1606      *
1607      * Requirements:
1608      *
1609      * - The contract must be paused.
1610      */
1611     function _unpause() internal virtual whenPaused {
1612         _paused = false;
1613         emit Unpaused(_msgSender());
1614     }
1615 }
1616 
1617 // File: @openzeppelin/contracts/access/Ownable.sol
1618 
1619 
1620 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1621 
1622 pragma solidity ^0.8.0;
1623 
1624 
1625 /**
1626  * @dev Contract module which provides a basic access control mechanism, where
1627  * there is an account (an owner) that can be granted exclusive access to
1628  * specific functions.
1629  *
1630  * By default, the owner account will be the one that deploys the contract. This
1631  * can later be changed with {transferOwnership}.
1632  *
1633  * This module is used through inheritance. It will make available the modifier
1634  * `onlyOwner`, which can be applied to your functions to restrict their use to
1635  * the owner.
1636  */
1637 abstract contract Ownable is Context {
1638     address private _owner;
1639 
1640     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1641 
1642     /**
1643      * @dev Initializes the contract setting the deployer as the initial owner.
1644      */
1645     constructor() {
1646         _transferOwnership(_msgSender());
1647     }
1648 
1649     /**
1650      * @dev Returns the address of the current owner.
1651      */
1652     function owner() public view virtual returns (address) {
1653         return _owner;
1654     }
1655 
1656     /**
1657      * @dev Throws if called by any account other than the owner.
1658      */
1659     modifier onlyOwner() {
1660         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1661         _;
1662     }
1663 
1664     /**
1665      * @dev Leaves the contract without owner. It will not be possible to call
1666      * `onlyOwner` functions anymore. Can only be called by the current owner.
1667      *
1668      * NOTE: Renouncing ownership will leave the contract without an owner,
1669      * thereby removing any functionality that is only available to the owner.
1670      */
1671     function renounceOwnership() public virtual onlyOwner {
1672         _transferOwnership(address(0));
1673     }
1674 
1675     /**
1676      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1677      * Can only be called by the current owner.
1678      */
1679     function transferOwnership(address newOwner) public virtual onlyOwner {
1680         require(newOwner != address(0), "Ownable: new owner is the zero address");
1681         _transferOwnership(newOwner);
1682     }
1683 
1684     /**
1685      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1686      * Internal function without access restriction.
1687      */
1688     function _transferOwnership(address newOwner) internal virtual {
1689         address oldOwner = _owner;
1690         _owner = newOwner;
1691         emit OwnershipTransferred(oldOwner, newOwner);
1692     }
1693 }
1694 
1695 // File: contracts/DunkingDucksNFT.sol
1696 
1697 
1698 pragma solidity ^0.8.0;
1699 
1700 
1701 
1702 
1703 
1704 
1705 
1706 contract DunkingDucksNFT is ERC721Enumerable, Ownable, Pausable {
1707   
1708   using Strings for string;
1709   using SafeMath for uint256;
1710   
1711   event PermanentURI(string _value, uint256 indexed _id);
1712   
1713   string private baseUriForClosed;
1714   string private baseUriForOpend;
1715   
1716   uint32 private constant MAX_SUPPLY = 3333;
1717   uint32 private constant MAX_PURCHASE = 15;
1718   uint256 private constant MAX_RESERVE = 320;
1719   
1720   
1721   bool private saleActived = false;
1722   bool private regularSaleActived = false;
1723   bool private revealActived = false;
1724   
1725   uint256 private currentPrice = 0 ether; 
1726   uint256 private price = 0.1 ether;
1727   uint256 private discountPrice = 0.08 ether;
1728   
1729   bytes32 public merkleRoot;
1730   
1731   constructor(
1732     string memory _baseUriForClosed,
1733     string memory _baseUriForOpend,
1734     bytes32 _merkleRoot
1735   )  Ownable() Pausable() ERC721("Dunking Ducks", "Dunking Ducks") {
1736     baseUriForClosed = _baseUriForClosed;
1737     baseUriForOpend = _baseUriForOpend;
1738     merkleRoot = _merkleRoot;
1739   }
1740   
1741   function withdrawPayments() public onlyOwner {
1742     address payable to = payable(_msgSender());
1743     to.transfer(getBalance());
1744   }
1745   
1746   function reserve(
1747   address[] memory _to,
1748     uint256 _quanlity
1749     ) external onlyOwner {
1750       require(!paused(), "DunkingDucksNFT#reserve: Status in paused.");
1751       require(!saleActived, "DunkingDucksNFT#reserve: Out of reserve period");
1752       require(_quanlity == _to.length, "DunkingDucksNFT#reserve: The address and quanlity mismatch.");
1753       require((totalSupply() + _quanlity) <= MAX_RESERVE, "DunkingDucksNFT#reserve: Over reserve amount limit.");
1754       
1755       for (uint256 i=0; i<_quanlity; i++) {
1756         _mintDuck(_to[i]);
1757       }
1758     }
1759   
1760   function batchMint(
1761   bytes32[] calldata _merkleProof,
1762     uint256 _quantity
1763     ) external payable returns(uint256[] memory) {
1764       require(!paused(), "DunkingDucksNFT#batchMint: Status in paused.");
1765       require(saleActived && !revealActived, "DunkingDucksNFT#batchMint: Out of selling period");
1766       require(_quantity > 0 && _quantity <= MAX_PURCHASE, "DunkingDucksNFT#batchMint: Purchase quality must be positive integer in [1,10].");
1767       require(_quantity.add(totalSupply()) <= MAX_SUPPLY, "DunkingDucksNFT#batchMint: Quantitiy illegal.");
1768       require(_quantity.add(balanceOf(_msgSender())) <= MAX_PURCHASE, "DunkingDucksNFT#batchMint: Each account limit 10 ducks.");
1769       
1770       if (regularSaleActived) {
1771         currentPrice = price;
1772       } else {
1773         currentPrice = discountPrice;
1774         bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1775         require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "DunkingDucksNFT#batchMint: The buyer must be in WL.");
1776       }
1777       
1778       uint256 fee = currentPrice.mul(_quantity);
1779       
1780       require(msg.value == fee, "DunkingDucksNFT#batchMint: Transaction value did not equal the mint price."); 
1781       
1782       uint256[] memory _tokenIds = new uint256[](_quantity);
1783       for (uint256 i=0; i<_quantity; i++) {
1784         uint256 tokenId = _mintDuck(_msgSender());
1785         _tokenIds[i] = tokenId;
1786       }
1787       return _tokenIds;
1788     }
1789   
1790   
1791   function _mintDuck(address to) internal returns(uint256) {
1792     uint256 newTokenId = totalSupply() + 1;
1793     _safeMint(to, newTokenId);
1794     return newTokenId;
1795   }
1796   
1797   function _baseURI() internal view virtual override returns(string memory) {
1798     return revealActived ? baseUriForOpend : baseUriForClosed;
1799   }
1800   
1801   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1802     require(_exists(tokenId), "DunkingDucksNFT#tokenURI: URI query for nonexistent token");
1803     
1804     if(!revealActived) {
1805       tokenId = 0;
1806     }
1807     
1808     string memory base = _baseURI();
1809     return bytes(base).length > 0 ? string(abi.encodePacked(base, Strings.toString(tokenId), ".json")) : "";
1810   }
1811   
1812   function enableSaleActived() external onlyOwner {
1813     require(!saleActived, "DunkingDucksNFT#enableSaleActived: Forbid revert sale process!");
1814     saleActived = true;
1815   }
1816   
1817   function getSaleActived() external view returns(bool) {
1818     return saleActived;
1819   }
1820   
1821   function enableRegularSaleActived() external onlyOwner {
1822     require(!regularSaleActived, "DunkingDucksNFT#enableRegularSaleActived: Forbid revert regular sale process!");
1823     regularSaleActived = true;
1824   }
1825   
1826   function getRegularSaleActived() external view returns(bool) {
1827     return regularSaleActived;
1828   }
1829   
1830   function enableRevealActived() external onlyOwner {
1831     require(!revealActived, "DunkingDucksNFT#enableRevealActived :Forbid revert reaveal process!");
1832     revealActived = true;
1833   }
1834   
1835   function getRevealActived() external view returns(bool) {
1836     return revealActived;
1837   }
1838   
1839   function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1840     merkleRoot = _merkleRoot;
1841   }
1842   
1843   function setbaseUriForClosed(string memory _baseUri) public onlyOwner { 
1844     baseUriForOpend = _baseUri;
1845   }
1846   
1847   function setbaseUriForOpend(string memory _baseUri) public onlyOwner { 
1848     baseUriForOpend = _baseUri;
1849   }
1850   
1851   function setPrice(uint256 _price) external onlyOwner {
1852     price = _price;
1853   }
1854   
1855   function getPrice() external view returns (uint256) {
1856     return price;
1857   }
1858   
1859   function setDiscountPrice(uint256 _discountPrice) external onlyOwner {
1860     discountPrice = _discountPrice;
1861   }
1862   
1863   function getDiscountPrice() external view returns (uint256) {
1864     return discountPrice;
1865   }
1866   
1867   function getCurrentPrice() external view returns (uint256) {
1868     return regularSaleActived ? price : discountPrice;
1869   }
1870   
1871   function setMetaFrozen() external onlyOwner {
1872     require(revealActived, "DunkingDucksNFT#setMetaFrozen: Need waiting for revealActived enalbe.");
1873     
1874     uint256 totalSupply =  totalSupply();
1875     for (uint256 id=1; id <= totalSupply; id++) {
1876       emit PermanentURI(string(abi.encodePacked(baseUriForOpend, Strings.toString(id), ".json")), id);
1877     }
1878   }
1879   
1880   function getBalance() public view returns(uint) {
1881     return address(this).balance;
1882   }
1883 }