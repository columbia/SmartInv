1 // SPDX-License-Identifier: MIT
2 
3 /*
4      ██████       ██    ██      ██████
5     ██    ███     ██    ██      ██    ██
6     ██            ██    ██      ██████
7     ██    ███     ██    ██      ██    ██
8      ██████   ██   ██████   ██  ██████   ██
9 */
10 
11 
12 
13 pragma solidity ^0.8.0;
14 
15 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/MerkleProof.sol
16 
17 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
18 
19 /**
20  * @dev These functions deal with verification of Merkle Trees proofs.
21  *
22  * The proofs can be generated using the JavaScript library
23  * https://github.com/miguelmota/merkletreejs[merkletreejs].
24  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
25  *
26  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
27  *
28  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
29  * hashing, or use a hash function other than keccak256 for hashing leaves.
30  * This is because the concatenation of a sorted pair of internal nodes in
31  * the merkle tree could be reinterpreted as a leaf value.
32  */
33 library MerkleProof {
34     /**
35      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
36      * defined by `root`. For this, a `proof` must be provided, containing
37      * sibling hashes on the branch from the leaf to the root of the tree. Each
38      * pair of leaves and each pair of pre-images are assumed to be sorted.
39      */
40     function verify(
41         bytes32[] memory proof,
42         bytes32 root,
43         bytes32 leaf
44     ) internal pure returns (bool) {
45         return processProof(proof, leaf) == root;
46     }
47 
48     /**
49      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
50      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
51      * hash matches the root of the tree. When processing the proof, the pairs
52      * of leafs & pre-images are assumed to be sorted.
53      *
54      * _Available since v4.4._
55      */
56     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
57         bytes32 computedHash = leaf;
58         for (uint256 i = 0; i < proof.length; i++) {
59             bytes32 proofElement = proof[i];
60             if (computedHash <= proofElement) {
61                 // Hash(current computed hash + current element of the proof)
62                 computedHash = _efficientHash(computedHash, proofElement);
63             } else {
64                 // Hash(current element of the proof + current computed hash)
65                 computedHash = _efficientHash(proofElement, computedHash);
66             }
67         }
68         return computedHash;
69     }
70 
71     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
72         assembly {
73             mstore(0x00, a)
74             mstore(0x20, b)
75             value := keccak256(0x00, 0x40)
76         }
77     }
78 }
79 
80 // File: contracts/Tiny_Frens.sol
81 
82 
83 // File: @openzeppelin/contracts/utils/Counters.sol
84 
85 
86 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
87 
88 pragma solidity ^0.8.0;
89 
90 /**
91  * @title Counters
92  * @author Matt Condon (@shrugs)
93  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
94  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
95  *
96  * Include with `using Counters for Counters.Counter;`
97  */
98 library Counters {
99     struct Counter {
100         // This variable should never be directly accessed by users of the library: interactions must be restricted to
101         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
102         // this feature: see https://github.com/ethereum/solidity/issues/4637
103         uint256 _value; // default: 0
104     }
105 
106     function current(Counter storage counter) internal view returns (uint256) {
107         return counter._value;
108     }
109 
110     function increment(Counter storage counter) internal {
111         unchecked {
112             counter._value += 1;
113         }
114     }
115 
116     function decrement(Counter storage counter) internal {
117         uint256 value = counter._value;
118         require(value > 0, "Counter: decrement overflow");
119         unchecked {
120             counter._value = value - 1;
121         }
122     }
123 
124     function reset(Counter storage counter) internal {
125         counter._value = 0;
126     }
127 }
128 
129 // File: @openzeppelin/contracts/utils/Strings.sol
130 
131 
132 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
133 
134 pragma solidity ^0.8.0;
135 
136 /**
137  * @dev String operations.
138  */
139 library Strings {
140     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
141 
142     /**
143      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
144      */
145     function toString(uint256 value) internal pure returns (string memory) {
146         // Inspired by OraclizeAPI's implementation - MIT licence
147         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
148 
149         if (value == 0) {
150             return "0";
151         }
152         uint256 temp = value;
153         uint256 digits;
154         while (temp != 0) {
155             digits++;
156             temp /= 10;
157         }
158         bytes memory buffer = new bytes(digits);
159         while (value != 0) {
160             digits -= 1;
161             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
162             value /= 10;
163         }
164         return string(buffer);
165     }
166 
167     /**
168      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
169      */
170     function toHexString(uint256 value) internal pure returns (string memory) {
171         if (value == 0) {
172             return "0x00";
173         }
174         uint256 temp = value;
175         uint256 length = 0;
176         while (temp != 0) {
177             length++;
178             temp >>= 8;
179         }
180         return toHexString(value, length);
181     }
182 
183     /**
184      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
185      */
186     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
187         bytes memory buffer = new bytes(2 * length + 2);
188         buffer[0] = "0";
189         buffer[1] = "x";
190         for (uint256 i = 2 * length + 1; i > 1; --i) {
191             buffer[i] = _HEX_SYMBOLS[value & 0xf];
192             value >>= 4;
193         }
194         require(value == 0, "Strings: hex length insufficient");
195         return string(buffer);
196     }
197 }
198 
199 // File: @openzeppelin/contracts/utils/Context.sol
200 
201 
202 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
203 
204 pragma solidity ^0.8.0;
205 
206 /**
207  * @dev Provides information about the current execution context, including the
208  * sender of the transaction and its data. While these are generally available
209  * via msg.sender and msg.data, they should not be accessed in such a direct
210  * manner, since when dealing with meta-transactions the account sending and
211  * paying for execution may not be the actual sender (as far as an application
212  * is concerned).
213  *
214  * This contract is only required for intermediate, library-like contracts.
215  */
216 abstract contract Context {
217     function _msgSender() internal view virtual returns (address) {
218         return msg.sender;
219     }
220 
221     function _msgData() internal view virtual returns (bytes calldata) {
222         return msg.data;
223     }
224 }
225 
226 // File: @openzeppelin/contracts/access/Ownable.sol
227 
228 
229 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 
234 /**
235  * @dev Contract module which provides a basic access control mechanism, where
236  * there is an account (an owner) that can be granted exclusive access to
237  * specific functions.
238  *
239  * By default, the owner account will be the one that deploys the contract. This
240  * can later be changed with {transferOwnership}.
241  *
242  * This module is used through inheritance. It will make available the modifier
243  * `onlyOwner`, which can be applied to your functions to restrict their use to
244  * the owner.
245  */
246 abstract contract Ownable is Context {
247     address private _owner;
248 
249     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
250 
251     /**
252      * @dev Initializes the contract setting the deployer as the initial owner.
253      */
254     constructor() {
255         _transferOwnership(_msgSender());
256     }
257 
258     /**
259      * @dev Returns the address of the current owner.
260      */
261     function owner() public view virtual returns (address) {
262         return _owner;
263     }
264 
265     /**
266      * @dev Throws if called by any account other than the owner.
267      */
268     modifier onlyOwner() {
269         require(owner() == _msgSender(), "Ownable: caller is not the owner");
270         _;
271     }
272 
273     /**
274      * @dev Leaves the contract without owner. It will not be possible to call
275      * `onlyOwner` functions anymore. Can only be called by the current owner.
276      *
277      * NOTE: Renouncing ownership will leave the contract without an owner,
278      * thereby removing any functionality that is only available to the owner.
279      */
280     function renounceOwnership() public virtual onlyOwner {
281         _transferOwnership(address(0));
282     }
283 
284     /**
285      * @dev Transfers ownership of the contract to a new account (`newOwner`).
286      * Can only be called by the current owner.
287      */
288     function transferOwnership(address newOwner) public virtual onlyOwner {
289         require(newOwner != address(0), "Ownable: new owner is the zero address");
290         _transferOwnership(newOwner);
291     }
292 
293     /**
294      * @dev Transfers ownership of the contract to a new account (`newOwner`).
295      * Internal function without access restriction.
296      */
297     function _transferOwnership(address newOwner) internal virtual {
298         address oldOwner = _owner;
299         _owner = newOwner;
300         emit OwnershipTransferred(oldOwner, newOwner);
301     }
302 }
303 
304 // File: @openzeppelin/contracts/utils/Address.sol
305 
306 
307 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
308 
309 pragma solidity ^0.8.0;
310 
311 /**
312  * @dev Collection of functions related to the address type
313  */
314 library Address {
315     /**
316      * @dev Returns true if `account` is a contract.
317      *
318      * [IMPORTANT]
319      * ====
320      * It is unsafe to assume that an address for which this function returns
321      * false is an externally-owned account (EOA) and not a contract.
322      *
323      * Among others, `isContract` will return false for the following
324      * types of addresses:
325      *
326      *  - an externally-owned account
327      *  - a contract in construction
328      *  - an address where a contract will be created
329      *  - an address where a contract lived, but was destroyed
330      * ====
331      */
332     function isContract(address account) internal view returns (bool) {
333         // This method relies on extcodesize, which returns 0 for contracts in
334         // construction, since the code is only stored at the end of the
335         // constructor execution.
336 
337         uint256 size;
338         assembly {
339             size := extcodesize(account)
340         }
341         return size > 0;
342     }
343 
344     /**
345      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
346      * `recipient`, forwarding all available gas and reverting on errors.
347      *
348      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
349      * of certain opcodes, possibly making contracts go over the 2300 gas limit
350      * imposed by `transfer`, making them unable to receive funds via
351      * `transfer`. {sendValue} removes this limitation.
352      *
353      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
354      *
355      * IMPORTANT: because control is transferred to `recipient`, care must be
356      * taken to not create reentrancy vulnerabilities. Consider using
357      * {ReentrancyGuard} or the
358      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
359      */
360     function sendValue(address payable recipient, uint256 amount) internal {
361         require(address(this).balance >= amount, "Address: insufficient balance");
362 
363         (bool success, ) = recipient.call{value: amount}("");
364         require(success, "Address: unable to send value, recipient may have reverted");
365     }
366 
367     /**
368      * @dev Performs a Solidity function call using a low level `call`. A
369      * plain `call` is an unsafe replacement for a function call: use this
370      * function instead.
371      *
372      * If `target` reverts with a revert reason, it is bubbled up by this
373      * function (like regular Solidity function calls).
374      *
375      * Returns the raw returned data. To convert to the expected return value,
376      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
377      *
378      * Requirements:
379      *
380      * - `target` must be a contract.
381      * - calling `target` with `data` must not revert.
382      *
383      * _Available since v3.1._
384      */
385     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
386         return functionCall(target, data, "Address: low-level call failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
391      * `errorMessage` as a fallback revert reason when `target` reverts.
392      *
393      * _Available since v3.1._
394      */
395     function functionCall(
396         address target,
397         bytes memory data,
398         string memory errorMessage
399     ) internal returns (bytes memory) {
400         return functionCallWithValue(target, data, 0, errorMessage);
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
405      * but also transferring `value` wei to `target`.
406      *
407      * Requirements:
408      *
409      * - the calling contract must have an ETH balance of at least `value`.
410      * - the called Solidity function must be `payable`.
411      *
412      * _Available since v3.1._
413      */
414     function functionCallWithValue(
415         address target,
416         bytes memory data,
417         uint256 value
418     ) internal returns (bytes memory) {
419         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
424      * with `errorMessage` as a fallback revert reason when `target` reverts.
425      *
426      * _Available since v3.1._
427      */
428     function functionCallWithValue(
429         address target,
430         bytes memory data,
431         uint256 value,
432         string memory errorMessage
433     ) internal returns (bytes memory) {
434         require(address(this).balance >= value, "Address: insufficient balance for call");
435         require(isContract(target), "Address: call to non-contract");
436 
437         (bool success, bytes memory returndata) = target.call{value: value}(data);
438         return verifyCallResult(success, returndata, errorMessage);
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
443      * but performing a static call.
444      *
445      * _Available since v3.3._
446      */
447     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
448         return functionStaticCall(target, data, "Address: low-level static call failed");
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
453      * but performing a static call.
454      *
455      * _Available since v3.3._
456      */
457     function functionStaticCall(
458         address target,
459         bytes memory data,
460         string memory errorMessage
461     ) internal view returns (bytes memory) {
462         require(isContract(target), "Address: static call to non-contract");
463 
464         (bool success, bytes memory returndata) = target.staticcall(data);
465         return verifyCallResult(success, returndata, errorMessage);
466     }
467 
468     /**
469      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
470      * but performing a delegate call.
471      *
472      * _Available since v3.4._
473      */
474     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
475         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
480      * but performing a delegate call.
481      *
482      * _Available since v3.4._
483      */
484     function functionDelegateCall(
485         address target,
486         bytes memory data,
487         string memory errorMessage
488     ) internal returns (bytes memory) {
489         require(isContract(target), "Address: delegate call to non-contract");
490 
491         (bool success, bytes memory returndata) = target.delegatecall(data);
492         return verifyCallResult(success, returndata, errorMessage);
493     }
494 
495     /**
496      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
497      * revert reason using the provided one.
498      *
499      * _Available since v4.3._
500      */
501     function verifyCallResult(
502         bool success,
503         bytes memory returndata,
504         string memory errorMessage
505     ) internal pure returns (bytes memory) {
506         if (success) {
507             return returndata;
508         } else {
509             // Look for revert reason and bubble it up if present
510             if (returndata.length > 0) {
511                 // The easiest way to bubble the revert reason is using memory via assembly
512 
513                 assembly {
514                     let returndata_size := mload(returndata)
515                     revert(add(32, returndata), returndata_size)
516                 }
517             } else {
518                 revert(errorMessage);
519             }
520         }
521     }
522 }
523 
524 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
525 
526 
527 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
528 
529 pragma solidity ^0.8.0;
530 
531 /**
532  * @title ERC721 token receiver interface
533  * @dev Interface for any contract that wants to support safeTransfers
534  * from ERC721 asset contracts.
535  */
536 interface IERC721Receiver {
537     /**
538      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
539      * by `operator` from `from`, this function is called.
540      *
541      * It must return its Solidity selector to confirm the token transfer.
542      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
543      *
544      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
545      */
546     function onERC721Received(
547         address operator,
548         address from,
549         uint256 tokenId,
550         bytes calldata data
551     ) external returns (bytes4);
552 }
553 
554 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
555 
556 
557 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
558 
559 pragma solidity ^0.8.0;
560 
561 /**
562  * @dev Interface of the ERC165 standard, as defined in the
563  * https://eips.ethereum.org/EIPS/eip-165[EIP].
564  *
565  * Implementers can declare support of contract interfaces, which can then be
566  * queried by others ({ERC165Checker}).
567  *
568  * For an implementation, see {ERC165}.
569  */
570 interface IERC165 {
571     /**
572      * @dev Returns true if this contract implements the interface defined by
573      * `interfaceId`. See the corresponding
574      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
575      * to learn more about how these ids are created.
576      *
577      * This function call must use less than 30 000 gas.
578      */
579     function supportsInterface(bytes4 interfaceId) external view returns (bool);
580 }
581 
582 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
583 
584 
585 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
586 
587 pragma solidity ^0.8.0;
588 
589 
590 /**
591  * @dev Implementation of the {IERC165} interface.
592  *
593  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
594  * for the additional interface id that will be supported. For example:
595  *
596  * ```solidity
597  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
598  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
599  * }
600  * ```
601  *
602  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
603  */
604 abstract contract ERC165 is IERC165 {
605     /**
606      * @dev See {IERC165-supportsInterface}.
607      */
608     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
609         return interfaceId == type(IERC165).interfaceId;
610     }
611 }
612 
613 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
614 
615 
616 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
617 
618 pragma solidity ^0.8.0;
619 
620 
621 /**
622  * @dev Required interface of an ERC721 compliant contract.
623  */
624 interface IERC721 is IERC165 {
625     /**
626      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
627      */
628     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
629 
630     /**
631      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
632      */
633     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
634 
635     /**
636      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
637      */
638     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
639 
640     /**
641      * @dev Returns the number of tokens in ``owner``'s account.
642      */
643     function balanceOf(address owner) external view returns (uint256 balance);
644 
645     /**
646      * @dev Returns the owner of the `tokenId` token.
647      *
648      * Requirements:
649      *
650      * - `tokenId` must exist.
651      */
652     function ownerOf(uint256 tokenId) external view returns (address owner);
653 
654     /**
655      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
656      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
657      *
658      * Requirements:
659      *
660      * - `from` cannot be the zero address.
661      * - `to` cannot be the zero address.
662      * - `tokenId` token must exist and be owned by `from`.
663      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
664      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
665      *
666      * Emits a {Transfer} event.
667      */
668     function safeTransferFrom(
669         address from,
670         address to,
671         uint256 tokenId
672     ) external;
673 
674     /**
675      * @dev Transfers `tokenId` token from `from` to `to`.
676      *
677      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
678      *
679      * Requirements:
680      *
681      * - `from` cannot be the zero address.
682      * - `to` cannot be the zero address.
683      * - `tokenId` token must be owned by `from`.
684      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
685      *
686      * Emits a {Transfer} event.
687      */
688     function transferFrom(
689         address from,
690         address to,
691         uint256 tokenId
692     ) external;
693 
694     /**
695      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
696      * The approval is cleared when the token is transferred.
697      *
698      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
699      *
700      * Requirements:
701      *
702      * - The caller must own the token or be an approved operator.
703      * - `tokenId` must exist.
704      *
705      * Emits an {Approval} event.
706      */
707     function approve(address to, uint256 tokenId) external;
708 
709     /**
710      * @dev Returns the account approved for `tokenId` token.
711      *
712      * Requirements:
713      *
714      * - `tokenId` must exist.
715      */
716     function getApproved(uint256 tokenId) external view returns (address operator);
717 
718     /**
719      * @dev Approve or remove `operator` as an operator for the caller.
720      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
721      *
722      * Requirements:
723      *
724      * - The `operator` cannot be the caller.
725      *
726      * Emits an {ApprovalForAll} event.
727      */
728     function setApprovalForAll(address operator, bool _approved) external;
729 
730     /**
731      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
732      *
733      * See {setApprovalForAll}
734      */
735     function isApprovedForAll(address owner, address operator) external view returns (bool);
736 
737     /**
738      * @dev Safely transfers `tokenId` token from `from` to `to`.
739      *
740      * Requirements:
741      *
742      * - `from` cannot be the zero address.
743      * - `to` cannot be the zero address.
744      * - `tokenId` token must exist and be owned by `from`.
745      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
746      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
747      *
748      * Emits a {Transfer} event.
749      */
750     function safeTransferFrom(
751         address from,
752         address to,
753         uint256 tokenId,
754         bytes calldata data
755     ) external;
756 }
757 
758 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
759 
760 
761 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
762 
763 pragma solidity ^0.8.0;
764 
765 
766 /**
767  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
768  * @dev See https://eips.ethereum.org/EIPS/eip-721
769  */
770 interface IERC721Metadata is IERC721 {
771     /**
772      * @dev Returns the token collection name.
773      */
774     function name() external view returns (string memory);
775 
776     /**
777      * @dev Returns the token collection symbol.
778      */
779     function symbol() external view returns (string memory);
780 
781     /**
782      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
783      */
784     function tokenURI(uint256 tokenId) external view returns (string memory);
785 }
786 
787 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
788 
789 
790 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
791 
792 pragma solidity ^0.8.0;
793 
794 
795 
796 
797 
798 
799 
800 
801 /**
802  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
803  * the Metadata extension, but not including the Enumerable extension, which is available separately as
804  * {ERC721Enumerable}.
805  */
806 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
807     using Address for address;
808     using Strings for uint256;
809 
810     // Token name
811     string private _name;
812 
813     // Token symbol
814     string private _symbol;
815 
816     // Mapping from token ID to owner address
817     mapping(uint256 => address) private _owners;
818 
819     // Mapping owner address to token count
820     mapping(address => uint256) private _balances;
821 
822     // Mapping from token ID to approved address
823     mapping(uint256 => address) private _tokenApprovals;
824 
825     // Mapping from owner to operator approvals
826     mapping(address => mapping(address => bool)) private _operatorApprovals;
827 
828     /**
829      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
830      */
831     constructor(string memory name_, string memory symbol_) {
832         _name = name_;
833         _symbol = symbol_;
834     }
835 
836     /**
837      * @dev See {IERC165-supportsInterface}.
838      */
839     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
840         return
841             interfaceId == type(IERC721).interfaceId ||
842             interfaceId == type(IERC721Metadata).interfaceId ||
843             super.supportsInterface(interfaceId);
844     }
845 
846     /**
847      * @dev See {IERC721-balanceOf}.
848      */
849     function balanceOf(address owner) public view virtual override returns (uint256) {
850         require(owner != address(0), "ERC721: balance query for the zero address");
851         return _balances[owner];
852     }
853 
854     /**
855      * @dev See {IERC721-ownerOf}.
856      */
857     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
858         address owner = _owners[tokenId];
859         require(owner != address(0), "ERC721: owner query for nonexistent token");
860         return owner;
861     }
862 
863     /**
864      * @dev See {IERC721Metadata-name}.
865      */
866     function name() public view virtual override returns (string memory) {
867         return _name;
868     }
869 
870     /**
871      * @dev See {IERC721Metadata-symbol}.
872      */
873     function symbol() public view virtual override returns (string memory) {
874         return _symbol;
875     }
876 
877     /**
878      * @dev See {IERC721Metadata-tokenURI}.
879      */
880     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
881         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
882 
883         string memory baseURI = _baseURI();
884         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
885     }
886 
887     /**
888      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
889      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
890      * by default, can be overriden in child contracts.
891      */
892     function _baseURI() internal view virtual returns (string memory) {
893         return "";
894     }
895 
896     /**
897      * @dev See {IERC721-approve}.
898      */
899     function approve(address to, uint256 tokenId) public virtual override {
900         address owner = ERC721.ownerOf(tokenId);
901         require(to != owner, "ERC721: approval to current owner");
902 
903         require(
904             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
905             "ERC721: approve caller is not owner nor approved for all"
906         );
907 
908         _approve(to, tokenId);
909     }
910 
911     /**
912      * @dev See {IERC721-getApproved}.
913      */
914     function getApproved(uint256 tokenId) public view virtual override returns (address) {
915         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
916 
917         return _tokenApprovals[tokenId];
918     }
919 
920     /**
921      * @dev See {IERC721-setApprovalForAll}.
922      */
923     function setApprovalForAll(address operator, bool approved) public virtual override {
924         _setApprovalForAll(_msgSender(), operator, approved);
925     }
926 
927     /**
928      * @dev See {IERC721-isApprovedForAll}.
929      */
930     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
931         return _operatorApprovals[owner][operator];
932     }
933 
934     /**
935      * @dev See {IERC721-transferFrom}.
936      */
937     function transferFrom(
938         address from,
939         address to,
940         uint256 tokenId
941     ) public virtual override {
942         //solhint-disable-next-line max-line-length
943         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
944 
945         _transfer(from, to, tokenId);
946     }
947 
948     /**
949      * @dev See {IERC721-safeTransferFrom}.
950      */
951     function safeTransferFrom(
952         address from,
953         address to,
954         uint256 tokenId
955     ) public virtual override {
956         safeTransferFrom(from, to, tokenId, "");
957     }
958 
959     /**
960      * @dev See {IERC721-safeTransferFrom}.
961      */
962     function safeTransferFrom(
963         address from,
964         address to,
965         uint256 tokenId,
966         bytes memory _data
967     ) public virtual override {
968         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
969         _safeTransfer(from, to, tokenId, _data);
970     }
971 
972     /**
973      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
974      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
975      *
976      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
977      *
978      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
979      * implement alternative mechanisms to perform token transfer, such as signature-based.
980      *
981      * Requirements:
982      *
983      * - `from` cannot be the zero address.
984      * - `to` cannot be the zero address.
985      * - `tokenId` token must exist and be owned by `from`.
986      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
987      *
988      * Emits a {Transfer} event.
989      */
990     function _safeTransfer(
991         address from,
992         address to,
993         uint256 tokenId,
994         bytes memory _data
995     ) internal virtual {
996         _transfer(from, to, tokenId);
997         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
998     }
999 
1000     /**
1001      * @dev Returns whether `tokenId` exists.
1002      *
1003      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1004      *
1005      * Tokens start existing when they are minted (`_mint`),
1006      * and stop existing when they are burned (`_burn`).
1007      */
1008     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1009         return _owners[tokenId] != address(0);
1010     }
1011 
1012     /**
1013      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1014      *
1015      * Requirements:
1016      *
1017      * - `tokenId` must exist.
1018      */
1019     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1020         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1021         address owner = ERC721.ownerOf(tokenId);
1022         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1023     }
1024 
1025     /**
1026      * @dev Safely mints `tokenId` and transfers it to `to`.
1027      *
1028      * Requirements:
1029      *
1030      * - `tokenId` must not exist.
1031      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1032      *
1033      * Emits a {Transfer} event.
1034      */
1035     function _safeMint(address to, uint256 tokenId) internal virtual {
1036         _safeMint(to, tokenId, "");
1037     }
1038 
1039     /**
1040      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1041      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1042      */
1043     function _safeMint(
1044         address to,
1045         uint256 tokenId,
1046         bytes memory _data
1047     ) internal virtual {
1048         _mint(to, tokenId);
1049         require(
1050             _checkOnERC721Received(address(0), to, tokenId, _data),
1051             "ERC721: transfer to non ERC721Receiver implementer"
1052         );
1053     }
1054 
1055     /**
1056      * @dev Mints `tokenId` and transfers it to `to`.
1057      *
1058      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1059      *
1060      * Requirements:
1061      *
1062      * - `tokenId` must not exist.
1063      * - `to` cannot be the zero address.
1064      *
1065      * Emits a {Transfer} event.
1066      */
1067     function _mint(address to, uint256 tokenId) internal virtual {
1068         require(to != address(0), "ERC721: mint to the zero address");
1069         require(!_exists(tokenId), "ERC721: token already minted");
1070 
1071         _beforeTokenTransfer(address(0), to, tokenId);
1072 
1073         _balances[to] += 1;
1074         _owners[tokenId] = to;
1075 
1076         emit Transfer(address(0), to, tokenId);
1077     }
1078 
1079     /**
1080      * @dev Destroys `tokenId`.
1081      * The approval is cleared when the token is burned.
1082      *
1083      * Requirements:
1084      *
1085      * - `tokenId` must exist.
1086      *
1087      * Emits a {Transfer} event.
1088      */
1089     function _burn(uint256 tokenId) internal virtual {
1090         address owner = ERC721.ownerOf(tokenId);
1091 
1092         _beforeTokenTransfer(owner, address(0), tokenId);
1093 
1094         // Clear approvals
1095         _approve(address(0), tokenId);
1096 
1097         _balances[owner] -= 1;
1098         delete _owners[tokenId];
1099 
1100         emit Transfer(owner, address(0), tokenId);
1101     }
1102 
1103     /**
1104      * @dev Transfers `tokenId` from `from` to `to`.
1105      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1106      *
1107      * Requirements:
1108      *
1109      * - `to` cannot be the zero address.
1110      * - `tokenId` token must be owned by `from`.
1111      *
1112      * Emits a {Transfer} event.
1113      */
1114     function _transfer(
1115         address from,
1116         address to,
1117         uint256 tokenId
1118     ) internal virtual {
1119         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1120         require(to != address(0), "ERC721: transfer to the zero address");
1121 
1122         _beforeTokenTransfer(from, to, tokenId);
1123 
1124         // Clear approvals from the previous owner
1125         _approve(address(0), tokenId);
1126 
1127         _balances[from] -= 1;
1128         _balances[to] += 1;
1129         _owners[tokenId] = to;
1130 
1131         emit Transfer(from, to, tokenId);
1132     }
1133 
1134     /**
1135      * @dev Approve `to` to operate on `tokenId`
1136      *
1137      * Emits a {Approval} event.
1138      */
1139     function _approve(address to, uint256 tokenId) internal virtual {
1140         _tokenApprovals[tokenId] = to;
1141         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1142     }
1143 
1144     /**
1145      * @dev Approve `operator` to operate on all of `owner` tokens
1146      *
1147      * Emits a {ApprovalForAll} event.
1148      */
1149     function _setApprovalForAll(
1150         address owner,
1151         address operator,
1152         bool approved
1153     ) internal virtual {
1154         require(owner != operator, "ERC721: approve to caller");
1155         _operatorApprovals[owner][operator] = approved;
1156         emit ApprovalForAll(owner, operator, approved);
1157     }
1158 
1159     /**
1160      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1161      * The call is not executed if the target address is not a contract.
1162      *
1163      * @param from address representing the previous owner of the given token ID
1164      * @param to target address that will receive the tokens
1165      * @param tokenId uint256 ID of the token to be transferred
1166      * @param _data bytes optional data to send along with the call
1167      * @return bool whether the call correctly returned the expected magic value
1168      */
1169     function _checkOnERC721Received(
1170         address from,
1171         address to,
1172         uint256 tokenId,
1173         bytes memory _data
1174     ) private returns (bool) {
1175         if (to.isContract()) {
1176             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1177                 return retval == IERC721Receiver.onERC721Received.selector;
1178             } catch (bytes memory reason) {
1179                 if (reason.length == 0) {
1180                     revert("ERC721: transfer to non ERC721Receiver implementer");
1181                 } else {
1182                     assembly {
1183                         revert(add(32, reason), mload(reason))
1184                     }
1185                 }
1186             }
1187         } else {
1188             return true;
1189         }
1190     }
1191 
1192     /**
1193      * @dev Hook that is called before any token transfer. This includes minting
1194      * and burning.
1195      *
1196      * Calling conditions:
1197      *
1198      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1199      * transferred to `to`.
1200      * - When `from` is zero, `tokenId` will be minted for `to`.
1201      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1202      * - `from` and `to` are never both zero.
1203      *
1204      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1205      */
1206     function _beforeTokenTransfer(
1207         address from,
1208         address to,
1209         uint256 tokenId
1210     ) internal virtual {}
1211 }
1212 
1213 // File: contracts/contract.sol
1214 
1215 
1216 
1217 
1218 
1219 pragma solidity >=0.7.0 <0.9.0;
1220 
1221 
1222 contract CubKingdom is ERC721, Ownable {
1223   using Strings for uint256;
1224   using Counters for Counters.Counter;
1225 
1226   Counters.Counter private supply;
1227 
1228   string public uriPrefix = "";
1229   
1230   uint256 public OGSaleCost = 0.1 ether;
1231   uint256 public WLSaleCost = 0.15 ether;
1232   uint256 public publicSaleCost = 0.2 ether;
1233 
1234   uint256 public maxSupply = 8888;
1235   uint256 public maxMintAmountPerTransaction = 20;
1236   uint256 public maxMintAmountPerWLAccount = 10;
1237   uint256 public maxMintAmountPerOGAccount = 5;
1238 
1239   bool public paused = true;
1240   bool public OGSaleActive=true;
1241   bool public WLSaleActive=false;
1242 
1243   bytes32 public merkleRoot= 0x0de6c9f4b501d88b442db96c4f3653e394ef2ce0c67fc9d33527d625663f633c;
1244 
1245   constructor() ERC721("Cub Kingdom", "C.U.B.") {
1246     
1247     _mintLoop(msg.sender, 100);
1248 
1249   }
1250 
1251   modifier mintCompliance(uint256 _mintAmount) {
1252     require(_mintAmount > 0, "Invalid mint amount!");
1253     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1254     _;
1255   }
1256 
1257   function totalSupply() public view returns (uint256) {
1258     return supply.current();
1259   }
1260 
1261   function mint(bytes32[] calldata _merkleProof, uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1262     require(!paused, "The contract is paused!");
1263     if(OGSaleActive==true){
1264       require(msg.value >= OGSaleCost * _mintAmount, "Insufficient funds!");
1265       require(balanceOf(msg.sender) + _mintAmount <= maxMintAmountPerOGAccount, "Mint limit exceeded." );
1266 
1267       //verify the provided _merkleProof
1268       bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1269       require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Not part of the VIP whitelist.");
1270     }
1271     else if(WLSaleActive==true){
1272       require(msg.value >= WLSaleCost * _mintAmount, "Insufficient funds!");
1273       require(balanceOf(msg.sender) + _mintAmount <= maxMintAmountPerWLAccount, "Mint limit exceeded." );
1274 
1275       //verify the provided _merkleProof
1276       bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1277       require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Not part of the Presale whitelist.");
1278     }
1279     else{
1280       require(msg.value >= publicSaleCost * _mintAmount, "Insufficient funds!");
1281       require(_mintAmount <= maxMintAmountPerTransaction, "Mint limit exceeded." );
1282     }
1283     _mintLoop(msg.sender, _mintAmount);
1284   }
1285 
1286   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1287     _mintLoop(_receiver, _mintAmount);
1288   }
1289 
1290   function walletOfOwner(address _owner)
1291     public
1292     view
1293     returns (uint256[] memory)
1294   {
1295     uint256 ownerTokenCount = balanceOf(_owner);
1296     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1297     uint256 currentTokenId = 1;
1298     uint256 ownedTokenIndex = 0;
1299 
1300     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1301       address currentTokenOwner = ownerOf(currentTokenId);
1302 
1303       if (currentTokenOwner == _owner) {
1304         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1305 
1306         ownedTokenIndex++;
1307       }
1308 
1309       currentTokenId++;
1310     }
1311 
1312     return ownedTokenIds;
1313   }
1314 
1315   function tokenURI(uint256 _tokenId)
1316     public
1317     view
1318     virtual
1319     override
1320     returns (string memory)
1321   {
1322     require(
1323       _exists(_tokenId),
1324       "ERC721Metadata: URI query for nonexistent token"
1325     );
1326 
1327     string memory currentBaseURI = _baseURI();
1328     return bytes(currentBaseURI).length > 0
1329         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json"))
1330         : "";
1331   }
1332 
1333   function setPublicSaleCost(uint256 _publicSaleCost) public onlyOwner {
1334     publicSaleCost = _publicSaleCost;
1335   }
1336 
1337   function setWLSaleCost(uint256 _WLSaleCost) public onlyOwner {
1338     WLSaleCost = _WLSaleCost;
1339   }
1340 
1341   function setOGSaleCost(uint256 _OGSaleCost) public onlyOwner {
1342     OGSaleCost = _OGSaleCost;
1343   }
1344 
1345 
1346   function setMaxMintPerOGAccount(uint256 _maxMintPerOGAccount) public onlyOwner {
1347     maxMintAmountPerOGAccount = _maxMintPerOGAccount;
1348   }
1349 
1350   function setMaxMintPerWLAccount(uint256 _maxMintPerWLAccount) public onlyOwner {
1351     maxMintAmountPerWLAccount = _maxMintPerWLAccount;
1352   }
1353    
1354   function setMaxMintPerTransaction(uint256 _maxMintPerTransaction) public onlyOwner {
1355     maxMintAmountPerTransaction = _maxMintPerTransaction;
1356   }
1357 
1358   function endOGSale() public onlyOwner {
1359     OGSaleActive = false;
1360     WLSaleActive = true;
1361     paused=true;
1362   }
1363 
1364   function endWLSale() public onlyOwner {
1365     require(OGSaleActive==false);
1366     WLSaleActive=false;
1367     paused=true;
1368   }
1369 
1370   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1371     uriPrefix = _uriPrefix;
1372   }
1373 
1374   function setPaused(bool _state) public onlyOwner {
1375     paused = _state;
1376   }
1377 
1378   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1379     merkleRoot = _merkleRoot;
1380   }
1381 
1382   function withdraw() public onlyOwner {
1383    
1384     // This will transfer the remaining contract balance to the owner.
1385     // Do not remove this otherwise you will not be able to withdraw the funds.
1386     // =============================================================================
1387     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1388     require(os);
1389     // =============================================================================
1390   }
1391 
1392   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1393     for (uint256 i = 0; i < _mintAmount; i++) {
1394       supply.increment();
1395       _safeMint(_receiver, supply.current());
1396     }
1397   }
1398 
1399   function _baseURI() internal view virtual override returns (string memory) {
1400     return uriPrefix;
1401   }
1402 }