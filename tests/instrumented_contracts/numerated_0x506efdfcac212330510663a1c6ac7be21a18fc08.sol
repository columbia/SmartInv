1 // SPDX-License-Identifier: MIT
2 
3 /**
4   * @title T.O.T.A Contract by 7K Labs - Props to Chiru Labs for that erc721A goodness
5   *   
6   *   __________________________________________________________ 
7   *  /\____/\\\\\\\\\\\\\\\___/\\\______/\\\_____/\\\___________\
8   *  \/\___\/////////////\\\__\/\\\____/\\\/_____\/\\\___________\
9   *   \/\______________/\\\/___\/\\\__/\\\/_______\/\\\___________\
10   *    \/\____________/\\\/_____\/\\\/\\\/_________\/\\\___________\
11   *     \/\__________/\\\/_______\/\\\\/\\\_________\/\\\___________\
12   *      \/\________/\\\/_________\/\\\\///\\\_______\/\\\___________\
13   *       \/\______/\\\/___________\/\\\__\///\\\_____\/\\\___________\
14   *        \/\____/\\\/_____________\/\\\____\///\\\___\/\\\\\\\\\\\\\_\
15   *         \/\___\///_______________\///_______\///____\/////////////__\
16   *          \/\_________________________________________________________\
17   *           \/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
18   *
19   */
20 
21 
22 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/MerkleProof.sol
23 
24 
25 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
26 
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @dev These functions deal with verification of Merkle Trees proofs.
31  *
32  * The proofs can be generated using the JavaScript library
33  * https://github.com/miguelmota/merkletreejs[merkletreejs].
34  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
35  *
36  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
37  *
38  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
39  * hashing, or use a hash function other than keccak256 for hashing leaves.
40  * This is because the concatenation of a sorted pair of internal nodes in
41  * the merkle tree could be reinterpreted as a leaf value.
42  */
43 library MerkleProof {
44     /**
45      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
46      * defined by `root`. For this, a `proof` must be provided, containing
47      * sibling hashes on the branch from the leaf to the root of the tree. Each
48      * pair of leaves and each pair of pre-images are assumed to be sorted.
49      */
50     function verify(
51         bytes32[] memory proof,
52         bytes32 root,
53         bytes32 leaf
54     ) internal pure returns (bool) {
55         return processProof(proof, leaf) == root;
56     }
57 
58     /**
59      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
60      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
61      * hash matches the root of the tree. When processing the proof, the pairs
62      * of leafs & pre-images are assumed to be sorted.
63      *
64      * _Available since v4.4._
65      */
66     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
67         bytes32 computedHash = leaf;
68         for (uint256 i = 0; i < proof.length; i++) {
69             bytes32 proofElement = proof[i];
70             if (computedHash <= proofElement) {
71                 // Hash(current computed hash + current element of the proof)
72                 computedHash = _efficientHash(computedHash, proofElement);
73             } else {
74                 // Hash(current element of the proof + current computed hash)
75                 computedHash = _efficientHash(proofElement, computedHash);
76             }
77         }
78         return computedHash;
79     }
80 
81     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
82         assembly {
83             mstore(0x00, a)
84             mstore(0x20, b)
85             value := keccak256(0x00, 0x40)
86         }
87     }
88 }
89 
90 // File: @openzeppelin/contracts/utils/Strings.sol
91 
92 
93 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
94 
95 pragma solidity ^0.8.0;
96 
97 /**
98  * @dev String operations.
99  */
100 library Strings {
101     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
102 
103     /**
104      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
105      */
106     function toString(uint256 value) internal pure returns (string memory) {
107         // Inspired by OraclizeAPI's implementation - MIT licence
108         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
109 
110         if (value == 0) {
111             return "0";
112         }
113         uint256 temp = value;
114         uint256 digits;
115         while (temp != 0) {
116             digits++;
117             temp /= 10;
118         }
119         bytes memory buffer = new bytes(digits);
120         while (value != 0) {
121             digits -= 1;
122             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
123             value /= 10;
124         }
125         return string(buffer);
126     }
127 
128     /**
129      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
130      */
131     function toHexString(uint256 value) internal pure returns (string memory) {
132         if (value == 0) {
133             return "0x00";
134         }
135         uint256 temp = value;
136         uint256 length = 0;
137         while (temp != 0) {
138             length++;
139             temp >>= 8;
140         }
141         return toHexString(value, length);
142     }
143 
144     /**
145      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
146      */
147     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
148         bytes memory buffer = new bytes(2 * length + 2);
149         buffer[0] = "0";
150         buffer[1] = "x";
151         for (uint256 i = 2 * length + 1; i > 1; --i) {
152             buffer[i] = _HEX_SYMBOLS[value & 0xf];
153             value >>= 4;
154         }
155         require(value == 0, "Strings: hex length insufficient");
156         return string(buffer);
157     }
158 }
159 
160 // File: @openzeppelin/contracts/utils/Context.sol
161 
162 
163 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
164 
165 pragma solidity ^0.8.0;
166 
167 /**
168  * @dev Provides information about the current execution context, including the
169  * sender of the transaction and its data. While these are generally available
170  * via msg.sender and msg.data, they should not be accessed in such a direct
171  * manner, since when dealing with meta-transactions the account sending and
172  * paying for execution may not be the actual sender (as far as an application
173  * is concerned).
174  *
175  * This contract is only required for intermediate, library-like contracts.
176  */
177 abstract contract Context {
178     function _msgSender() internal view virtual returns (address) {
179         return msg.sender;
180     }
181 
182     function _msgData() internal view virtual returns (bytes calldata) {
183         return msg.data;
184     }
185 }
186 
187 // File: @openzeppelin/contracts/access/Ownable.sol
188 
189 
190 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
191 
192 pragma solidity ^0.8.0;
193 
194 
195 /**
196  * @dev Contract module which provides a basic access control mechanism, where
197  * there is an account (an owner) that can be granted exclusive access to
198  * specific functions.
199  *
200  * By default, the owner account will be the one that deploys the contract. This
201  * can later be changed with {transferOwnership}.
202  *
203  * This module is used through inheritance. It will make available the modifier
204  * `onlyOwner`, which can be applied to your functions to restrict their use to
205  * the owner.
206  */
207 abstract contract Ownable is Context {
208     address private _owner;
209 
210     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
211 
212     /**
213      * @dev Initializes the contract setting the deployer as the initial owner.
214      */
215     constructor() {
216         _transferOwnership(_msgSender());
217     }
218 
219     /**
220      * @dev Returns the address of the current owner.
221      */
222     function owner() public view virtual returns (address) {
223         return _owner;
224     }
225 
226     /**
227      * @dev Throws if called by any account other than the owner.
228      */
229     modifier onlyOwner() {
230         require(owner() == _msgSender(), "Ownable: caller is not the owner");
231         _;
232     }
233 
234     /**
235      * @dev Leaves the contract without owner. It will not be possible to call
236      * `onlyOwner` functions anymore. Can only be called by the current owner.
237      *
238      * NOTE: Renouncing ownership will leave the contract without an owner,
239      * thereby removing any functionality that is only available to the owner.
240      */
241     function renounceOwnership() public virtual onlyOwner {
242         _transferOwnership(address(0));
243     }
244 
245     /**
246      * @dev Transfers ownership of the contract to a new account (`newOwner`).
247      * Can only be called by the current owner.
248      */
249     function transferOwnership(address newOwner) public virtual onlyOwner {
250         require(newOwner != address(0), "Ownable: new owner is the zero address");
251         _transferOwnership(newOwner);
252     }
253 
254     /**
255      * @dev Transfers ownership of the contract to a new account (`newOwner`).
256      * Internal function without access restriction.
257      */
258     function _transferOwnership(address newOwner) internal virtual {
259         address oldOwner = _owner;
260         _owner = newOwner;
261         emit OwnershipTransferred(oldOwner, newOwner);
262     }
263 }
264 
265 // File: @openzeppelin/contracts/utils/Address.sol
266 
267 
268 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
269 
270 pragma solidity ^0.8.1;
271 
272 /**
273  * @dev Collection of functions related to the address type
274  */
275 library Address {
276     /**
277      * @dev Returns true if `account` is a contract.
278      *
279      * [IMPORTANT]
280      * ====
281      * It is unsafe to assume that an address for which this function returns
282      * false is an externally-owned account (EOA) and not a contract.
283      *
284      * Among others, `isContract` will return false for the following
285      * types of addresses:
286      *
287      *  - an externally-owned account
288      *  - a contract in construction
289      *  - an address where a contract will be created
290      *  - an address where a contract lived, but was destroyed
291      * ====
292      *
293      * [IMPORTANT]
294      * ====
295      * You shouldn't rely on `isContract` to protect against flash loan attacks!
296      *
297      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
298      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
299      * constructor.
300      * ====
301      */
302     function isContract(address account) internal view returns (bool) {
303         // This method relies on extcodesize/address.code.length, which returns 0
304         // for contracts in construction, since the code is only stored at the end
305         // of the constructor execution.
306 
307         return account.code.length > 0;
308     }
309 
310     /**
311      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
312      * `recipient`, forwarding all available gas and reverting on errors.
313      *
314      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
315      * of certain opcodes, possibly making contracts go over the 2300 gas limit
316      * imposed by `transfer`, making them unable to receive funds via
317      * `transfer`. {sendValue} removes this limitation.
318      *
319      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
320      *
321      * IMPORTANT: because control is transferred to `recipient`, care must be
322      * taken to not create reentrancy vulnerabilities. Consider using
323      * {ReentrancyGuard} or the
324      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
325      */
326     function sendValue(address payable recipient, uint256 amount) internal {
327         require(address(this).balance >= amount, "Address: insufficient balance");
328 
329         (bool success, ) = recipient.call{value: amount}("");
330         require(success, "Address: unable to send value, recipient may have reverted");
331     }
332 
333     /**
334      * @dev Performs a Solidity function call using a low level `call`. A
335      * plain `call` is an unsafe replacement for a function call: use this
336      * function instead.
337      *
338      * If `target` reverts with a revert reason, it is bubbled up by this
339      * function (like regular Solidity function calls).
340      *
341      * Returns the raw returned data. To convert to the expected return value,
342      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
343      *
344      * Requirements:
345      *
346      * - `target` must be a contract.
347      * - calling `target` with `data` must not revert.
348      *
349      * _Available since v3.1._
350      */
351     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
352         return functionCall(target, data, "Address: low-level call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
357      * `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCall(
362         address target,
363         bytes memory data,
364         string memory errorMessage
365     ) internal returns (bytes memory) {
366         return functionCallWithValue(target, data, 0, errorMessage);
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
371      * but also transferring `value` wei to `target`.
372      *
373      * Requirements:
374      *
375      * - the calling contract must have an ETH balance of at least `value`.
376      * - the called Solidity function must be `payable`.
377      *
378      * _Available since v3.1._
379      */
380     function functionCallWithValue(
381         address target,
382         bytes memory data,
383         uint256 value
384     ) internal returns (bytes memory) {
385         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
390      * with `errorMessage` as a fallback revert reason when `target` reverts.
391      *
392      * _Available since v3.1._
393      */
394     function functionCallWithValue(
395         address target,
396         bytes memory data,
397         uint256 value,
398         string memory errorMessage
399     ) internal returns (bytes memory) {
400         require(address(this).balance >= value, "Address: insufficient balance for call");
401         require(isContract(target), "Address: call to non-contract");
402 
403         (bool success, bytes memory returndata) = target.call{value: value}(data);
404         return verifyCallResult(success, returndata, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but performing a static call.
410      *
411      * _Available since v3.3._
412      */
413     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
414         return functionStaticCall(target, data, "Address: low-level static call failed");
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
419      * but performing a static call.
420      *
421      * _Available since v3.3._
422      */
423     function functionStaticCall(
424         address target,
425         bytes memory data,
426         string memory errorMessage
427     ) internal view returns (bytes memory) {
428         require(isContract(target), "Address: static call to non-contract");
429 
430         (bool success, bytes memory returndata) = target.staticcall(data);
431         return verifyCallResult(success, returndata, errorMessage);
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
436      * but performing a delegate call.
437      *
438      * _Available since v3.4._
439      */
440     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
441         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
446      * but performing a delegate call.
447      *
448      * _Available since v3.4._
449      */
450     function functionDelegateCall(
451         address target,
452         bytes memory data,
453         string memory errorMessage
454     ) internal returns (bytes memory) {
455         require(isContract(target), "Address: delegate call to non-contract");
456 
457         (bool success, bytes memory returndata) = target.delegatecall(data);
458         return verifyCallResult(success, returndata, errorMessage);
459     }
460 
461     /**
462      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
463      * revert reason using the provided one.
464      *
465      * _Available since v4.3._
466      */
467     function verifyCallResult(
468         bool success,
469         bytes memory returndata,
470         string memory errorMessage
471     ) internal pure returns (bytes memory) {
472         if (success) {
473             return returndata;
474         } else {
475             // Look for revert reason and bubble it up if present
476             if (returndata.length > 0) {
477                 // The easiest way to bubble the revert reason is using memory via assembly
478 
479                 assembly {
480                     let returndata_size := mload(returndata)
481                     revert(add(32, returndata), returndata_size)
482                 }
483             } else {
484                 revert(errorMessage);
485             }
486         }
487     }
488 }
489 
490 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
491 
492 
493 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
494 
495 pragma solidity ^0.8.0;
496 
497 /**
498  * @title ERC721 token receiver interface
499  * @dev Interface for any contract that wants to support safeTransfers
500  * from ERC721 asset contracts.
501  */
502 interface IERC721Receiver {
503     /**
504      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
505      * by `operator` from `from`, this function is called.
506      *
507      * It must return its Solidity selector to confirm the token transfer.
508      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
509      *
510      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
511      */
512     function onERC721Received(
513         address operator,
514         address from,
515         uint256 tokenId,
516         bytes calldata data
517     ) external returns (bytes4);
518 }
519 
520 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
521 
522 
523 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
524 
525 pragma solidity ^0.8.0;
526 
527 /**
528  * @dev Interface of the ERC165 standard, as defined in the
529  * https://eips.ethereum.org/EIPS/eip-165[EIP].
530  *
531  * Implementers can declare support of contract interfaces, which can then be
532  * queried by others ({ERC165Checker}).
533  *
534  * For an implementation, see {ERC165}.
535  */
536 interface IERC165 {
537     /**
538      * @dev Returns true if this contract implements the interface defined by
539      * `interfaceId`. See the corresponding
540      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
541      * to learn more about how these ids are created.
542      *
543      * This function call must use less than 30 000 gas.
544      */
545     function supportsInterface(bytes4 interfaceId) external view returns (bool);
546 }
547 
548 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
549 
550 
551 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
552 
553 pragma solidity ^0.8.0;
554 
555 
556 /**
557  * @dev Implementation of the {IERC165} interface.
558  *
559  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
560  * for the additional interface id that will be supported. For example:
561  *
562  * ```solidity
563  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
564  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
565  * }
566  * ```
567  *
568  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
569  */
570 abstract contract ERC165 is IERC165 {
571     /**
572      * @dev See {IERC165-supportsInterface}.
573      */
574     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
575         return interfaceId == type(IERC165).interfaceId;
576     }
577 }
578 
579 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
580 
581 
582 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
583 
584 pragma solidity ^0.8.0;
585 
586 
587 /**
588  * @dev Required interface of an ERC721 compliant contract.
589  */
590 interface IERC721 is IERC165 {
591     /**
592      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
593      */
594     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
595 
596     /**
597      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
598      */
599     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
600 
601     /**
602      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
603      */
604     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
605 
606     /**
607      * @dev Returns the number of tokens in ``owner``'s account.
608      */
609     function balanceOf(address owner) external view returns (uint256 balance);
610 
611     /**
612      * @dev Returns the owner of the `tokenId` token.
613      *
614      * Requirements:
615      *
616      * - `tokenId` must exist.
617      */
618     function ownerOf(uint256 tokenId) external view returns (address owner);
619 
620     /**
621      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
622      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
623      *
624      * Requirements:
625      *
626      * - `from` cannot be the zero address.
627      * - `to` cannot be the zero address.
628      * - `tokenId` token must exist and be owned by `from`.
629      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
630      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
631      *
632      * Emits a {Transfer} event.
633      */
634     function safeTransferFrom(
635         address from,
636         address to,
637         uint256 tokenId
638     ) external;
639 
640     /**
641      * @dev Transfers `tokenId` token from `from` to `to`.
642      *
643      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
644      *
645      * Requirements:
646      *
647      * - `from` cannot be the zero address.
648      * - `to` cannot be the zero address.
649      * - `tokenId` token must be owned by `from`.
650      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
651      *
652      * Emits a {Transfer} event.
653      */
654     function transferFrom(
655         address from,
656         address to,
657         uint256 tokenId
658     ) external;
659 
660     /**
661      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
662      * The approval is cleared when the token is transferred.
663      *
664      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
665      *
666      * Requirements:
667      *
668      * - The caller must own the token or be an approved operator.
669      * - `tokenId` must exist.
670      *
671      * Emits an {Approval} event.
672      */
673     function approve(address to, uint256 tokenId) external;
674 
675     /**
676      * @dev Returns the account approved for `tokenId` token.
677      *
678      * Requirements:
679      *
680      * - `tokenId` must exist.
681      */
682     function getApproved(uint256 tokenId) external view returns (address operator);
683 
684     /**
685      * @dev Approve or remove `operator` as an operator for the caller.
686      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
687      *
688      * Requirements:
689      *
690      * - The `operator` cannot be the caller.
691      *
692      * Emits an {ApprovalForAll} event.
693      */
694     function setApprovalForAll(address operator, bool _approved) external;
695 
696     /**
697      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
698      *
699      * See {setApprovalForAll}
700      */
701     function isApprovedForAll(address owner, address operator) external view returns (bool);
702 
703     /**
704      * @dev Safely transfers `tokenId` token from `from` to `to`.
705      *
706      * Requirements:
707      *
708      * - `from` cannot be the zero address.
709      * - `to` cannot be the zero address.
710      * - `tokenId` token must exist and be owned by `from`.
711      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
712      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
713      *
714      * Emits a {Transfer} event.
715      */
716     function safeTransferFrom(
717         address from,
718         address to,
719         uint256 tokenId,
720         bytes calldata data
721     ) external;
722 }
723 
724 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
725 
726 
727 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
728 
729 pragma solidity ^0.8.0;
730 
731 
732 /**
733  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
734  * @dev See https://eips.ethereum.org/EIPS/eip-721
735  */
736 interface IERC721Enumerable is IERC721 {
737     /**
738      * @dev Returns the total amount of tokens stored by the contract.
739      */
740     function totalSupply() external view returns (uint256);
741 
742     /**
743      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
744      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
745      */
746     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
747 
748     /**
749      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
750      * Use along with {totalSupply} to enumerate all tokens.
751      */
752     function tokenByIndex(uint256 index) external view returns (uint256);
753 }
754 
755 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
756 
757 
758 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
759 
760 pragma solidity ^0.8.0;
761 
762 
763 /**
764  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
765  * @dev See https://eips.ethereum.org/EIPS/eip-721
766  */
767 interface IERC721Metadata is IERC721 {
768     /**
769      * @dev Returns the token collection name.
770      */
771     function name() external view returns (string memory);
772 
773     /**
774      * @dev Returns the token collection symbol.
775      */
776     function symbol() external view returns (string memory);
777 
778     /**
779      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
780      */
781     function tokenURI(uint256 tokenId) external view returns (string memory);
782 }
783 
784 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
785 
786 
787 // Creator: Chiru Labs
788 
789 pragma solidity ^0.8.4;
790 
791 
792 
793 
794 
795 
796 
797 
798 
799 error ApprovalCallerNotOwnerNorApproved();
800 error ApprovalQueryForNonexistentToken();
801 error ApproveToCaller();
802 error ApprovalToCurrentOwner();
803 error BalanceQueryForZeroAddress();
804 error MintedQueryForZeroAddress();
805 error BurnedQueryForZeroAddress();
806 error MintToZeroAddress();
807 error MintZeroQuantity();
808 error OwnerIndexOutOfBounds();
809 error OwnerQueryForNonexistentToken();
810 error TokenIndexOutOfBounds();
811 error TransferCallerNotOwnerNorApproved();
812 error TransferFromIncorrectOwner();
813 error TransferToNonERC721ReceiverImplementer();
814 error TransferToZeroAddress();
815 error URIQueryForNonexistentToken();
816 
817 /**
818  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
819  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
820  *
821  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
822  *
823  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
824  *
825  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
826  */
827 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
828     using Address for address;
829     using Strings for uint256;
830 
831     // Compiler will pack this into a single 256bit word.
832     struct TokenOwnership {
833         // The address of the owner.
834         address addr;
835         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
836         uint64 startTimestamp;
837         // Whether the token has been burned.
838         bool burned;
839     }
840 
841     // Compiler will pack this into a single 256bit word.
842     struct AddressData {
843         // Realistically, 2**64-1 is more than enough.
844         uint64 balance;
845         // Keeps track of mint count with minimal overhead for tokenomics.
846         uint64 numberMinted;
847         // Keeps track of burn count with minimal overhead for tokenomics.
848         uint64 numberBurned;
849     }
850 
851     // The tokenId of the next token to be minted.
852     uint256 internal _currentIndex;
853 
854     // The number of tokens burned.
855     uint256 internal _burnCounter;
856 
857     // Token name
858     string private _name;
859 
860     // Token symbol
861     string private _symbol;
862 
863     // Mapping from token ID to ownership details
864     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
865     mapping(uint256 => TokenOwnership) internal _ownerships;
866 
867     // Mapping owner address to address data
868     mapping(address => AddressData) private _addressData;
869 
870     // Mapping from token ID to approved address
871     mapping(uint256 => address) private _tokenApprovals;
872 
873     // Mapping from owner to operator approvals
874     mapping(address => mapping(address => bool)) private _operatorApprovals;
875 
876     constructor(string memory name_, string memory symbol_) {
877         _name = name_;
878         _symbol = symbol_;
879     }
880 
881     /**
882      * @dev See {IERC721Enumerable-totalSupply}.
883      */
884     function totalSupply() public view override returns (uint256) {
885         // Counter underflow is impossible as _burnCounter cannot be incremented
886         // more than _currentIndex times
887         unchecked {
888             return _currentIndex - _burnCounter;    
889         }
890     }
891 
892     /**
893      * @dev See {IERC721Enumerable-tokenByIndex}.
894      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
895      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
896      */
897     function tokenByIndex(uint256 index) public view override returns (uint256) {
898         uint256 numMintedSoFar = _currentIndex;
899         uint256 tokenIdsIdx;
900 
901         // Counter overflow is impossible as the loop breaks when
902         // uint256 i is equal to another uint256 numMintedSoFar.
903         unchecked {
904             for (uint256 i; i < numMintedSoFar; i++) {
905                 TokenOwnership memory ownership = _ownerships[i];
906                 if (!ownership.burned) {
907                     if (tokenIdsIdx == index) {
908                         return i;
909                     }
910                     tokenIdsIdx++;
911                 }
912             }
913         }
914         revert TokenIndexOutOfBounds();
915     }
916 
917     /**
918      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
919      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
920      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
921      */
922     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
923         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
924         uint256 numMintedSoFar = _currentIndex;
925         uint256 tokenIdsIdx;
926         address currOwnershipAddr;
927 
928         // Counter overflow is impossible as the loop breaks when
929         // uint256 i is equal to another uint256 numMintedSoFar.
930         unchecked {
931             for (uint256 i; i < numMintedSoFar; i++) {
932                 TokenOwnership memory ownership = _ownerships[i];
933                 if (ownership.burned) {
934                     continue;
935                 }
936                 if (ownership.addr != address(0)) {
937                     currOwnershipAddr = ownership.addr;
938                 }
939                 if (currOwnershipAddr == owner) {
940                     if (tokenIdsIdx == index) {
941                         return i;
942                     }
943                     tokenIdsIdx++;
944                 }
945             }
946         }
947 
948         // Execution should never reach this point.
949         revert();
950     }
951 
952     /**
953      * @dev See {IERC165-supportsInterface}.
954      */
955     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
956         return
957             interfaceId == type(IERC721).interfaceId ||
958             interfaceId == type(IERC721Metadata).interfaceId ||
959             interfaceId == type(IERC721Enumerable).interfaceId ||
960             super.supportsInterface(interfaceId);
961     }
962 
963     /**
964      * @dev See {IERC721-balanceOf}.
965      */
966     function balanceOf(address owner) public view override returns (uint256) {
967         if (owner == address(0)) revert BalanceQueryForZeroAddress();
968         return uint256(_addressData[owner].balance);
969     }
970 
971     function _numberMinted(address owner) internal view returns (uint256) {
972         if (owner == address(0)) revert MintedQueryForZeroAddress();
973         return uint256(_addressData[owner].numberMinted);
974     }
975 
976     function _numberBurned(address owner) internal view returns (uint256) {
977         if (owner == address(0)) revert BurnedQueryForZeroAddress();
978         return uint256(_addressData[owner].numberBurned);
979     }
980 
981     /**
982      * Gas spent here starts off proportional to the maximum mint batch size.
983      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
984      */
985     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
986         uint256 curr = tokenId;
987 
988         unchecked {
989             if (curr < _currentIndex) {
990                 TokenOwnership memory ownership = _ownerships[curr];
991                 if (!ownership.burned) {
992                     if (ownership.addr != address(0)) {
993                         return ownership;
994                     }
995                     // Invariant: 
996                     // There will always be an ownership that has an address and is not burned 
997                     // before an ownership that does not have an address and is not burned.
998                     // Hence, curr will not underflow.
999                     while (true) {
1000                         curr--;
1001                         ownership = _ownerships[curr];
1002                         if (ownership.addr != address(0)) {
1003                             return ownership;
1004                         }
1005                     }
1006                 }
1007             }
1008         }
1009         revert OwnerQueryForNonexistentToken();
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-ownerOf}.
1014      */
1015     function ownerOf(uint256 tokenId) public view override returns (address) {
1016         return ownershipOf(tokenId).addr;
1017     }
1018 
1019     /**
1020      * @dev See {IERC721Metadata-name}.
1021      */
1022     function name() public view virtual override returns (string memory) {
1023         return _name;
1024     }
1025 
1026     /**
1027      * @dev See {IERC721Metadata-symbol}.
1028      */
1029     function symbol() public view virtual override returns (string memory) {
1030         return _symbol;
1031     }
1032 
1033     /**
1034      * @dev See {IERC721Metadata-tokenURI}.
1035      */
1036     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1037         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1038 
1039         string memory baseURI = _baseURI();
1040         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1041     }
1042 
1043     /**
1044      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1045      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1046      * by default, can be overriden in child contracts.
1047      */
1048     function _baseURI() internal view virtual returns (string memory) {
1049         return '';
1050     }
1051 
1052     /**
1053      * @dev See {IERC721-approve}.
1054      */
1055     function approve(address to, uint256 tokenId) public override {
1056         address owner = ERC721A.ownerOf(tokenId);
1057         if (to == owner) revert ApprovalToCurrentOwner();
1058 
1059         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1060             revert ApprovalCallerNotOwnerNorApproved();
1061         }
1062 
1063         _approve(to, tokenId, owner);
1064     }
1065 
1066     /**
1067      * @dev See {IERC721-getApproved}.
1068      */
1069     function getApproved(uint256 tokenId) public view override returns (address) {
1070         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1071 
1072         return _tokenApprovals[tokenId];
1073     }
1074 
1075     /**
1076      * @dev See {IERC721-setApprovalForAll}.
1077      */
1078     function setApprovalForAll(address operator, bool approved) public override {
1079         if (operator == _msgSender()) revert ApproveToCaller();
1080 
1081         _operatorApprovals[_msgSender()][operator] = approved;
1082         emit ApprovalForAll(_msgSender(), operator, approved);
1083     }
1084 
1085     /**
1086      * @dev See {IERC721-isApprovedForAll}.
1087      */
1088     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1089         return _operatorApprovals[owner][operator];
1090     }
1091 
1092     /**
1093      * @dev See {IERC721-transferFrom}.
1094      */
1095     function transferFrom(
1096         address from,
1097         address to,
1098         uint256 tokenId
1099     ) public virtual override {
1100         _transfer(from, to, tokenId);
1101     }
1102 
1103     /**
1104      * @dev See {IERC721-safeTransferFrom}.
1105      */
1106     function safeTransferFrom(
1107         address from,
1108         address to,
1109         uint256 tokenId
1110     ) public virtual override {
1111         safeTransferFrom(from, to, tokenId, '');
1112     }
1113 
1114     /**
1115      * @dev See {IERC721-safeTransferFrom}.
1116      */
1117     function safeTransferFrom(
1118         address from,
1119         address to,
1120         uint256 tokenId,
1121         bytes memory _data
1122     ) public virtual override {
1123         _transfer(from, to, tokenId);
1124         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1125             revert TransferToNonERC721ReceiverImplementer();
1126         }
1127     }
1128 
1129     /**
1130      * @dev Returns whether `tokenId` exists.
1131      *
1132      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1133      *
1134      * Tokens start existing when they are minted (`_mint`),
1135      */
1136     function _exists(uint256 tokenId) internal view returns (bool) {
1137         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1138     }
1139 
1140     function _safeMint(address to, uint256 quantity) internal {
1141         _safeMint(to, quantity, '');
1142     }
1143 
1144     /**
1145      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1146      *
1147      * Requirements:
1148      *
1149      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1150      * - `quantity` must be greater than 0.
1151      *
1152      * Emits a {Transfer} event.
1153      */
1154     function _safeMint(
1155         address to,
1156         uint256 quantity,
1157         bytes memory _data
1158     ) internal {
1159         _mint(to, quantity, _data, true);
1160     }
1161 
1162     /**
1163      * @dev Mints `quantity` tokens and transfers them to `to`.
1164      *
1165      * Requirements:
1166      *
1167      * - `to` cannot be the zero address.
1168      * - `quantity` must be greater than 0.
1169      *
1170      * Emits a {Transfer} event.
1171      */
1172     function _mint(
1173         address to,
1174         uint256 quantity,
1175         bytes memory _data,
1176         bool safe
1177     ) internal {
1178         uint256 startTokenId = _currentIndex;
1179         if (to == address(0)) revert MintToZeroAddress();
1180         if (quantity == 0) revert MintZeroQuantity();
1181 
1182         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1183 
1184         // Overflows are incredibly unrealistic.
1185         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1186         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1187         unchecked {
1188             _addressData[to].balance += uint64(quantity);
1189             _addressData[to].numberMinted += uint64(quantity);
1190 
1191             _ownerships[startTokenId].addr = to;
1192             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1193 
1194             uint256 updatedIndex = startTokenId;
1195 
1196             for (uint256 i; i < quantity; i++) {
1197                 emit Transfer(address(0), to, updatedIndex);
1198                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1199                     revert TransferToNonERC721ReceiverImplementer();
1200                 }
1201                 updatedIndex++;
1202             }
1203 
1204             _currentIndex = updatedIndex;
1205         }
1206         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1207     }
1208 
1209     /**
1210      * @dev Transfers `tokenId` from `from` to `to`.
1211      *
1212      * Requirements:
1213      *
1214      * - `to` cannot be the zero address.
1215      * - `tokenId` token must be owned by `from`.
1216      *
1217      * Emits a {Transfer} event.
1218      */
1219     function _transfer(
1220         address from,
1221         address to,
1222         uint256 tokenId
1223     ) private {
1224         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1225 
1226         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1227             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1228             getApproved(tokenId) == _msgSender());
1229 
1230         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1231         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1232         if (to == address(0)) revert TransferToZeroAddress();
1233 
1234         _beforeTokenTransfers(from, to, tokenId, 1);
1235 
1236         // Clear approvals from the previous owner
1237         _approve(address(0), tokenId, prevOwnership.addr);
1238 
1239         // Underflow of the sender's balance is impossible because we check for
1240         // ownership above and the recipient's balance can't realistically overflow.
1241         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1242         unchecked {
1243             _addressData[from].balance -= 1;
1244             _addressData[to].balance += 1;
1245 
1246             _ownerships[tokenId].addr = to;
1247             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1248 
1249             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1250             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1251             uint256 nextTokenId = tokenId + 1;
1252             if (_ownerships[nextTokenId].addr == address(0)) {
1253                 // This will suffice for checking _exists(nextTokenId),
1254                 // as a burned slot cannot contain the zero address.
1255                 if (nextTokenId < _currentIndex) {
1256                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1257                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1258                 }
1259             }
1260         }
1261 
1262         emit Transfer(from, to, tokenId);
1263         _afterTokenTransfers(from, to, tokenId, 1);
1264     }
1265 
1266     /**
1267      * @dev Destroys `tokenId`.
1268      * The approval is cleared when the token is burned.
1269      *
1270      * Requirements:
1271      *
1272      * - `tokenId` must exist.
1273      *
1274      * Emits a {Transfer} event.
1275      */
1276     function _burn(uint256 tokenId) internal virtual {
1277         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1278 
1279         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1280 
1281         // Clear approvals from the previous owner
1282         _approve(address(0), tokenId, prevOwnership.addr);
1283 
1284         // Underflow of the sender's balance is impossible because we check for
1285         // ownership above and the recipient's balance can't realistically overflow.
1286         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1287         unchecked {
1288             _addressData[prevOwnership.addr].balance -= 1;
1289             _addressData[prevOwnership.addr].numberBurned += 1;
1290 
1291             // Keep track of who burned the token, and the timestamp of burning.
1292             _ownerships[tokenId].addr = prevOwnership.addr;
1293             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1294             _ownerships[tokenId].burned = true;
1295 
1296             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1297             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1298             uint256 nextTokenId = tokenId + 1;
1299             if (_ownerships[nextTokenId].addr == address(0)) {
1300                 // This will suffice for checking _exists(nextTokenId),
1301                 // as a burned slot cannot contain the zero address.
1302                 if (nextTokenId < _currentIndex) {
1303                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1304                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1305                 }
1306             }
1307         }
1308 
1309         emit Transfer(prevOwnership.addr, address(0), tokenId);
1310         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1311 
1312         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1313         unchecked { 
1314             _burnCounter++;
1315         }
1316     }
1317 
1318     /**
1319      * @dev Approve `to` to operate on `tokenId`
1320      *
1321      * Emits a {Approval} event.
1322      */
1323     function _approve(
1324         address to,
1325         uint256 tokenId,
1326         address owner
1327     ) private {
1328         _tokenApprovals[tokenId] = to;
1329         emit Approval(owner, to, tokenId);
1330     }
1331 
1332     /**
1333      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1334      * The call is not executed if the target address is not a contract.
1335      *
1336      * @param from address representing the previous owner of the given token ID
1337      * @param to target address that will receive the tokens
1338      * @param tokenId uint256 ID of the token to be transferred
1339      * @param _data bytes optional data to send along with the call
1340      * @return bool whether the call correctly returned the expected magic value
1341      */
1342     function _checkOnERC721Received(
1343         address from,
1344         address to,
1345         uint256 tokenId,
1346         bytes memory _data
1347     ) private returns (bool) {
1348         if (to.isContract()) {
1349             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1350                 return retval == IERC721Receiver(to).onERC721Received.selector;
1351             } catch (bytes memory reason) {
1352                 if (reason.length == 0) {
1353                     revert TransferToNonERC721ReceiverImplementer();
1354                 } else {
1355                     assembly {
1356                         revert(add(32, reason), mload(reason))
1357                     }
1358                 }
1359             }
1360         } else {
1361             return true;
1362         }
1363     }
1364 
1365     /**
1366      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1367      * And also called before burning one token.
1368      *
1369      * startTokenId - the first token id to be transferred
1370      * quantity - the amount to be transferred
1371      *
1372      * Calling conditions:
1373      *
1374      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1375      * transferred to `to`.
1376      * - When `from` is zero, `tokenId` will be minted for `to`.
1377      * - When `to` is zero, `tokenId` will be burned by `from`.
1378      * - `from` and `to` are never both zero.
1379      */
1380     function _beforeTokenTransfers(
1381         address from,
1382         address to,
1383         uint256 startTokenId,
1384         uint256 quantity
1385     ) internal virtual {}
1386 
1387     /**
1388      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1389      * minting.
1390      * And also called after one token has been burned.
1391      *
1392      * startTokenId - the first token id to be transferred
1393      * quantity - the amount to be transferred
1394      *
1395      * Calling conditions:
1396      *
1397      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1398      * transferred to `to`.
1399      * - When `from` is zero, `tokenId` has been minted for `to`.
1400      * - When `to` is zero, `tokenId` has been burned by `from`.
1401      * - `from` and `to` are never both zero.
1402      */
1403     function _afterTokenTransfers(
1404         address from,
1405         address to,
1406         uint256 startTokenId,
1407         uint256 quantity
1408     ) internal virtual {}
1409 }
1410 
1411 
1412 pragma solidity >=0.7.0 <0.9.0;
1413 
1414 contract TribesOfTheAftermathTOTA is ERC721A, Ownable {
1415 
1416     using Strings for uint256;
1417 
1418     string internal contractName = "Tribes of the Aftermath TOTA";
1419     string internal contractAbbr = "TOTA";
1420 
1421     string public uriPrefix = "";
1422     string public uriSuffix = "";
1423     string public hiddenMetadataUri = "ipfs://QmQF6vN693xtnbtGNw4HVT6UdmQKuxvDxe59dG8w3NzaHv/tota.json";
1424     bool public isRevealed = false;
1425     
1426     uint256 public preSaleCost = 0.08 ether;
1427     uint256 public pubSaleCost = 0.08 ether;
1428     
1429     uint256 public maxPreSalePerWallet = 5;
1430     uint256 public maxPubSalePerWallet = 20;
1431     uint256 public maxMintAmountPerTx = 10;
1432 
1433     uint256 public maxSupply = 8888;
1434     uint256 private ownerMintOnDeployment = 1;
1435     uint256 private ownerReserved = 150;
1436 
1437     bool public isSaleActive = false;
1438     bool public isPreSaleActive = true;
1439 
1440     // 0 = bypass, 1 = off-chain, 2 = on-chain
1441     uint256 public preSaleType = 1;
1442     address[] internal whitelistedAddresses;
1443     bytes32 public merkleRoot = 0xc6d7e6e2d994b666611235bdf1714dc30f20b966386a81ce610273f349dedb39;
1444 
1445     // team wallet addresses
1446     address internal raWallet = 0xe23D436Fc2F715d2B4Ec402511965E1474699fc9;
1447     address internal jrWallet = 0x6E035e0Dbd225E97AA171b87902ce6fe8527f16C;
1448     address internal tmWallet = 0xDac0B32df6DCFE658Af3bd1Fdf0c95D2af0b678A;
1449     address internal dgWallet = 0x6d587352dF7e0C377E87983586459609e9baf94e;
1450     address internal scWallet = 0xa130D1133Ef1A84F39B84467b16f5A0DD0577d4A;
1451     address internal spWallet = 0x56df8E01CC2fE2e1e01f6A0ee9B79c5aE54f3560;
1452     address internal devWallet = 0x1C81E289886544A04691936B13570e9B35495746;
1453     address internal teamWallet = 0x1C5b3F89D3Acf80223E2484897D2e38cF61E7c20;
1454 
1455 
1456     constructor() ERC721A(contractName, contractAbbr) {
1457         setHiddenMetadataUri(hiddenMetadataUri);
1458         _safeMint(teamWallet, ownerMintOnDeployment);
1459     }
1460 
1461     /**
1462      * @dev keeps track of the wallets that have minted during the whitelist and how many tokens they have minted
1463      */
1464     struct Minter {
1465         bool exists;
1466         uint256 hasMintedByWhitelist;
1467         uint256 hasMintedInPublicSale;
1468     }
1469     mapping(address => Minter) public minters;
1470 
1471     /**
1472      * @dev public mint function takes in the amount of tokens to mint
1473      */
1474     function mintPubSale(uint256 _mintAmount) public payable {
1475         require(isSaleActive, "Sale is not active!");
1476         require(!isPreSaleActive, "Pre Sale is active!");
1477         require(totalSupply() + _mintAmount <= maxSupply - ownerReserved, "Max supply exceeded!");
1478         require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1479         require(msg.value >= pubSaleCost * _mintAmount, "Insufficient funds!");
1480         require(
1481             minters[msg.sender].hasMintedInPublicSale + _mintAmount <= maxPubSalePerWallet,
1482             "Exceeds per wallet limit."
1483         );
1484         if (!minters[msg.sender].exists) minters[msg.sender].exists = true;
1485         minters[msg.sender].hasMintedInPublicSale = minters[msg.sender].hasMintedInPublicSale + _mintAmount;
1486         _safeMint(msg.sender, _mintAmount);
1487     }
1488 
1489     /**
1490      * @dev presale mint function takes in the amount of tokens to mint and the proof for the merkel tree
1491      *      if the merkle tree is not being used then feed in an empty array ([]) or if doing it from 
1492      *      etherscan feed in 0x0000000000000000000000000000000000000000000000000000000000000000
1493      */
1494     function mintPreSale(uint256 _mintAmount, bytes32[] calldata _markleProof) public payable {
1495         require(isSaleActive, "Sale is not active!");
1496         require(totalSupply() + _mintAmount <= maxSupply - ownerReserved, "Max supply exceeded!");
1497         require(isPreSaleActive, "Pre Sale is not active!");
1498         require(msg.value >= preSaleCost * _mintAmount, "Insufficient funds!");
1499         require(_mintAmount > 0, "Invalid mint amount!");
1500         require(_mintAmount <= maxPreSalePerWallet, "Exceeds per wallet presale limit.");
1501         if (preSaleType == 1) require(isWhitelistedByMerkle(_markleProof, msg.sender), "You are not whitelisted.");
1502         if (preSaleType == 2) require(isWhitelistedByAddress(msg.sender), "You are not whitelisted.");
1503         require(
1504             minters[msg.sender].hasMintedByWhitelist + _mintAmount <= maxPreSalePerWallet,
1505             "Exceeds per wallet presale limit."
1506         );
1507         if (!minters[msg.sender].exists) minters[msg.sender].exists = true;
1508         minters[msg.sender].hasMintedByWhitelist = minters[msg.sender].hasMintedByWhitelist + _mintAmount;
1509         _safeMint(msg.sender, _mintAmount);
1510     }
1511 
1512     /**
1513      * @dev returns an array of token IDs that the wallet owns
1514      */
1515     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1516         uint256 ownerTokenCount = balanceOf(_owner);
1517         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1518         uint256 currentTokenId = 0;
1519         uint256 ownedTokenIndex = 0;
1520         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1521             address currentTokenOwner = ownerOf(currentTokenId);
1522             if (currentTokenOwner == _owner) {
1523                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1524                 ownedTokenIndex++;
1525             }
1526             currentTokenId++;
1527         }
1528         return ownedTokenIds;
1529     }
1530 
1531     /**
1532      * @dev tests whether the wallet address has been whitelisted by the merkle tree by verifying  
1533      *      the proof provided to the function
1534      */
1535     function isWhitelistedByMerkle(bytes32[] calldata _markleProof, address _user) public view returns(bool) {
1536         bytes32 leaf = keccak256(abi.encodePacked(_user));
1537         return MerkleProof.verify(_markleProof, merkleRoot, leaf);
1538     }
1539 
1540     /**
1541      * @dev tests whether the wallet address has been whitelisted by the checking the whitelistedAddresses  
1542      *      array and returning a true/false flag
1543      */
1544     function isWhitelistedByAddress(address _user) public view returns (bool) {
1545         for (uint i = 0; i < whitelistedAddresses.length; i++) {
1546             if (whitelistedAddresses[i] == _user) {
1547                 return true;
1548             }
1549         }
1550         return false;
1551     }
1552 
1553     /**
1554      * @dev a simple `is whitelisted` function which tests the following things
1555      *      1) is the sale is active and the presale not active (public sale is active) - returns true
1556      *      2) presale type is 1 (merkle tree) - calls the isWhitelistedByMerkle() function
1557      *      3) presale type is 2 (standard whitelist) - calls the isWhitelistedByAddress() function
1558      *      4) if the above is not met, then return false
1559      */
1560     function isWhitelisted(bytes32[] calldata _markleProof, address _user) public view returns(bool) {
1561         if (isSaleActive && !isPreSaleActive) {
1562             return true;
1563         }
1564         if (preSaleType == 0) {
1565             return true;
1566         }
1567         if (preSaleType == 1) {
1568             return isWhitelistedByMerkle(_markleProof, _user);
1569         }
1570         if (preSaleType == 2) {
1571             return isWhitelistedByAddress(_user);
1572         }
1573         return false;
1574     }
1575 
1576     /**
1577      * @dev returns all whitelisted addresses in an array
1578      */
1579     function getWhitelistAddresses() public view returns(address[] memory) {
1580         return whitelistedAddresses;
1581     }
1582 
1583     /**
1584      * @dev returns the token URI - will return the hidden metadata if the isRevealed state is false
1585      */
1586     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1587         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1588         if (isRevealed == false) {
1589             return hiddenMetadataUri;
1590         }
1591         string memory currentBaseURI = _baseURI();
1592         return bytes(currentBaseURI).length > 0
1593             ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1594             : "";
1595     }
1596 
1597     /**
1598      * @dev returns the base token sufix
1599      */
1600     function _baseURI() internal view virtual override returns (string memory) {
1601         return uriPrefix;
1602     }
1603 
1604     /**
1605      * @dev returns the remaining public supply
1606      */
1607     function getRemainingPublicSupply() public view returns (uint256) {
1608         return maxSupply - ownerReserved - totalSupply();
1609     }
1610 
1611     /**
1612      * @dev returns the remaining reserved supply
1613      */
1614     function getRemainingReservedSupply() public view returns (uint256) {
1615         return ownerReserved;
1616     }
1617 
1618     // 
1619     // only owner functions
1620 
1621     /**
1622      * @dev sets the presale type - 1 is merkle tree validation and 2 is standard whitelist array
1623      */
1624     function setPreSaleType(uint8 _type) public onlyOwner {
1625         // 0 = bypass whitelist, 1 = merkle tree, 2 = wl addresses
1626         require(_type == 0 || _type == 1 || _type == 2, "Invalid whitelist type.");
1627         preSaleType = _type;
1628     }
1629 
1630     /**
1631      * @dev sets the merkle root for the verification (wl type 1)
1632      */
1633     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1634         merkleRoot = _merkleRoot;
1635     }
1636 
1637     /**
1638      * @dev sets the array for the whitelists (wl type 2) 
1639      *      this will reset the original whitelist with whatever is set here. therefore the entire
1640      *      whitelist needs to be provided again
1641      */
1642     function setWhitelistAddresses(address[] calldata _users) public onlyOwner {
1643         delete whitelistedAddresses;
1644         whitelistedAddresses = _users;
1645     }
1646 
1647     /**
1648      * @dev allows the contract owner to manually mint a set amount to a specified wallet address
1649      *      where only the gas needs to be paid. these tokens come out of the public supply
1650      */
1651     function sendPublicTokenToAddr(uint256 _mintAmount, address _receiver) public onlyOwner {
1652         require(totalSupply() + _mintAmount <= maxSupply - ownerReserved, "Max supply exceeded!");
1653         require(_mintAmount > 0, "Invalid mint amount");
1654         _safeMint(_receiver, _mintAmount);
1655     }
1656 
1657     /**
1658      * @dev allows the contract owner to manually mint a set amount to a specified wallet address
1659      *      where only the gas needs to be paid. these tokens come out of the reserved/non-public supply
1660      */
1661     function sendReservedTokenToAddr(uint256 _mintAmount, address _receiver) public onlyOwner {
1662         require(ownerReserved > 0 && _mintAmount <= ownerReserved, "Exceeds reserved supply!");
1663         require(_mintAmount > 0, "Invalid mint amount");
1664         require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1665         setReservedSupply(ownerReserved - _mintAmount);
1666         _safeMint(_receiver, _mintAmount);
1667     }
1668 
1669     /**
1670      * @dev allows the contract owner to change the amount they have reserved 
1671      */
1672     function setReservedSupply(uint256 _amount) public onlyOwner {
1673         require(_amount >= 0 && _amount <= maxSupply - totalSupply(), "Exceeds remaining supply!");
1674         ownerReserved = _amount;
1675     }
1676 
1677     /**
1678      * @dev flips the revealed state from false to true. it can be flipped back but all metadata on OpenSea 
1679      *      would need to be refresed again.
1680      */
1681     function flipRevealedState() public onlyOwner {
1682         isRevealed = !isRevealed;
1683     }
1684 
1685     /**
1686      * @dev sets the presale price of the token. this has to be sent through in wei and not eth
1687      *      eg 1 eth = 1000000000000000000 wei
1688      */
1689     function setPreSaleCost(uint256 _cost) public onlyOwner {
1690         preSaleCost = _cost;
1691     }
1692 
1693     /**
1694      * @dev sets the public sale price of the token. this has to be sent through in wei and not eth
1695      *      eg 1 eth = 1000000000000000000 wei
1696      */
1697     function setPubSaleCost(uint256 _cost) public onlyOwner {
1698         pubSaleCost = _cost;
1699     }
1700 
1701     /**
1702      * @dev sets the max amount per transaction in the public sale
1703      */
1704     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1705         maxMintAmountPerTx = _maxMintAmountPerTx;
1706     }
1707 
1708     /**
1709      * @dev sets the max amount per wallet in the presale
1710      */
1711     function setMaxPreSalePerWallet(uint256 _maxMintAmount) public onlyOwner {
1712         require(_maxMintAmount > 0, "Must be greater than zero");
1713         maxPreSalePerWallet = _maxMintAmount;
1714     }
1715 
1716     /**
1717      * @dev sets the max amount per wallet in the public sale
1718      */
1719     function setMaxPubSalePerWallet(uint256 _maxMintAmount) public onlyOwner {
1720         require(_maxMintAmount > 0, "Must be greater than zero");
1721         maxPubSalePerWallet = _maxMintAmount;
1722     }
1723 
1724     /**
1725      * @dev sets the not revealed metadata path (if using ipfs if must be entered ipfs://<CID>/hidden.json)
1726      */
1727     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1728         hiddenMetadataUri = _hiddenMetadataUri;
1729     }
1730 
1731     /**
1732      * @dev sets the path to the token (if using ipfs if must be entered ipfs://<CID>/) with the trailing slash
1733      *      an api can just be called as eg https://api.myurl.com/token/
1734      */
1735     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1736         uriPrefix = _uriPrefix;
1737     }
1738 
1739     /**
1740      * @dev sets the uri suffix (ie if the metadata is stored on ipfs this should be set to .json)
1741      */
1742     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1743         uriSuffix = _uriSuffix;
1744     }
1745 
1746     /**
1747      * @dev sets the uri suffix to blank if it has been set and you want to use an api to call your metadata
1748      */
1749     function setUriSuffixToBlank() public onlyOwner {
1750         uriSuffix = "";
1751     }
1752 
1753     /**
1754      * @dev sets the sale state (either true to false or false to true) this must be set to true for any 
1755      *      public minting to occur (even the presale)
1756      */
1757     function flipSaleState() public onlyOwner {
1758         isSaleActive = !isSaleActive;
1759     }
1760 
1761     /**
1762      * @dev sets the presale state (either true to false or false to true) this must be set to true for any 
1763      *      presale functionality to occur)
1764      */
1765     function flipPreSaleState() public onlyOwner {
1766         isPreSaleActive = !isPreSaleActive;
1767     }
1768 
1769     /**
1770      * @dev called to withdraw funds from the contract. this will pay x% to a developer wallet and the remaining balance 
1771      *      to the contract owner. the dev wallet and % are set at the top of this contract
1772      */
1773     function withdraw() public onlyOwner {
1774 
1775         uint256 _balance = address(this).balance;
1776 
1777         (bool ra, ) = payable(raWallet).call{value: _balance * 14 / 100}("");
1778         require(ra);
1779 
1780         (bool jr, ) = payable(jrWallet).call{value: _balance * 28 / 100}("");
1781         require(jr);
1782 
1783         (bool tm, ) = payable(tmWallet).call{value: _balance * 3 / 100}("");
1784         require(tm);
1785 
1786         (bool dg, ) = payable(dgWallet).call{value: _balance * 4 / 100}("");
1787         require(dg);
1788 
1789         (bool sc, ) = payable(scWallet).call{value: _balance * 15 / 100}("");
1790         require(sc);
1791 
1792         (bool sp, ) = payable(spWallet).call{value: _balance * 8 / 100}("");
1793         require(sp);
1794 
1795         (bool dw, ) = payable(devWallet).call{value: _balance * 10 / 100}("");
1796         require(dw);
1797 
1798         (bool tw, ) = payable(teamWallet).call{value: address(this).balance}("");
1799         require(tw);
1800     }
1801 
1802 
1803 }