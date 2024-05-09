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
27 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
28 
29 
30 
31 /**
32  * @dev String operations.
33  */
34 library Strings {
35     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
36 
37     /**
38      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
39      */
40     function toString(uint256 value) internal pure returns (string memory) {
41         // Inspired by OraclizeAPI's implementation - MIT licence
42         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
43 
44         if (value == 0) {
45             return "0";
46         }
47         uint256 temp = value;
48         uint256 digits;
49         while (temp != 0) {
50             digits++;
51             temp /= 10;
52         }
53         bytes memory buffer = new bytes(digits);
54         while (value != 0) {
55             digits -= 1;
56             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
57             value /= 10;
58         }
59         return string(buffer);
60     }
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
64      */
65     function toHexString(uint256 value) internal pure returns (string memory) {
66         if (value == 0) {
67             return "0x00";
68         }
69         uint256 temp = value;
70         uint256 length = 0;
71         while (temp != 0) {
72             length++;
73             temp >>= 8;
74         }
75         return toHexString(value, length);
76     }
77 
78     /**
79      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
80      */
81     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
82         bytes memory buffer = new bytes(2 * length + 2);
83         buffer[0] = "0";
84         buffer[1] = "x";
85         for (uint256 i = 2 * length + 1; i > 1; --i) {
86             buffer[i] = _HEX_SYMBOLS[value & 0xf];
87             value >>= 4;
88         }
89         require(value == 0, "Strings: hex length insufficient");
90         return string(buffer);
91     }
92 }
93 
94 
95 
96 
97 
98 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
99 
100 
101 
102 
103 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
104 
105 
106 
107 /**
108  * @dev Provides information about the current execution context, including the
109  * sender of the transaction and its data. While these are generally available
110  * via msg.sender and msg.data, they should not be accessed in such a direct
111  * manner, since when dealing with meta-transactions the account sending and
112  * paying for execution may not be the actual sender (as far as an application
113  * is concerned).
114  *
115  * This contract is only required for intermediate, library-like contracts.
116  */
117 abstract contract Context {
118     function _msgSender() internal view virtual returns (address) {
119         return msg.sender;
120     }
121 
122     function _msgData() internal view virtual returns (bytes calldata) {
123         return msg.data;
124     }
125 }
126 
127 
128 /**
129  * @dev Contract module which provides a basic access control mechanism, where
130  * there is an account (an owner) that can be granted exclusive access to
131  * specific functions.
132  *
133  * By default, the owner account will be the one that deploys the contract. This
134  * can later be changed with {transferOwnership}.
135  *
136  * This module is used through inheritance. It will make available the modifier
137  * `onlyOwner`, which can be applied to your functions to restrict their use to
138  * the owner.
139  */
140 abstract contract Ownable is Context {
141     address private _owner;
142 
143     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
144 
145     /**
146      * @dev Initializes the contract setting the deployer as the initial owner.
147      */
148     constructor() {
149         _transferOwnership(_msgSender());
150     }
151 
152     /**
153      * @dev Returns the address of the current owner.
154      */
155     function owner() public view virtual returns (address) {
156         return _owner;
157     }
158 
159     /**
160      * @dev Throws if called by any account other than the owner.
161      */
162     modifier onlyOwner() {
163         require(owner() == _msgSender(), "Ownable: caller is not the owner");
164         _;
165     }
166 
167     /**
168      * @dev Leaves the contract without owner. It will not be possible to call
169      * `onlyOwner` functions anymore. Can only be called by the current owner.
170      *
171      * NOTE: Renouncing ownership will leave the contract without an owner,
172      * thereby removing any functionality that is only available to the owner.
173      */
174     function renounceOwnership() public virtual onlyOwner {
175         _transferOwnership(address(0));
176     }
177 
178     /**
179      * @dev Transfers ownership of the contract to a new account (`newOwner`).
180      * Can only be called by the current owner.
181      */
182     function transferOwnership(address newOwner) public virtual onlyOwner {
183         require(newOwner != address(0), "Ownable: new owner is the zero address");
184         _transferOwnership(newOwner);
185     }
186 
187     /**
188      * @dev Transfers ownership of the contract to a new account (`newOwner`).
189      * Internal function without access restriction.
190      */
191     function _transferOwnership(address newOwner) internal virtual {
192         address oldOwner = _owner;
193         _owner = newOwner;
194         emit OwnershipTransferred(oldOwner, newOwner);
195     }
196 }
197 
198 
199 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
200 
201 
202 
203 /**
204  * @dev These functions deal with verification of Merkle Trees proofs.
205  *
206  * The proofs can be generated using the JavaScript library
207  * https://github.com/miguelmota/merkletreejs[merkletreejs].
208  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
209  *
210  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
211  *
212  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
213  * hashing, or use a hash function other than keccak256 for hashing leaves.
214  * This is because the concatenation of a sorted pair of internal nodes in
215  * the merkle tree could be reinterpreted as a leaf value.
216  */
217 library MerkleProof {
218     /**
219      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
220      * defined by `root`. For this, a `proof` must be provided, containing
221      * sibling hashes on the branch from the leaf to the root of the tree. Each
222      * pair of leaves and each pair of pre-images are assumed to be sorted.
223      */
224     function verify(
225         bytes32[] memory proof,
226         bytes32 root,
227         bytes32 leaf
228     ) internal pure returns (bool) {
229         return processProof(proof, leaf) == root;
230     }
231 
232     /**
233      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
234      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
235      * hash matches the root of the tree. When processing the proof, the pairs
236      * of leafs & pre-images are assumed to be sorted.
237      *
238      * _Available since v4.4._
239      */
240     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
241         bytes32 computedHash = leaf;
242         for (uint256 i = 0; i < proof.length; i++) {
243             bytes32 proofElement = proof[i];
244             if (computedHash <= proofElement) {
245                 // Hash(current computed hash + current element of the proof)
246                 computedHash = _efficientHash(computedHash, proofElement);
247             } else {
248                 // Hash(current element of the proof + current computed hash)
249                 computedHash = _efficientHash(proofElement, computedHash);
250             }
251         }
252         return computedHash;
253     }
254 
255     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
256         assembly {
257             mstore(0x00, a)
258             mstore(0x20, b)
259             value := keccak256(0x00, 0x40)
260         }
261     }
262 }
263 
264 
265 
266 
267 
268 
269 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
270 
271 
272 
273 
274 
275 /**
276  * @dev Required interface of an ERC721 compliant contract.
277  */
278 interface IERC721 is IERC165 {
279     /**
280      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
281      */
282     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
283 
284     /**
285      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
286      */
287     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
288 
289     /**
290      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
291      */
292     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
293 
294     /**
295      * @dev Returns the number of tokens in ``owner``'s account.
296      */
297     function balanceOf(address owner) external view returns (uint256 balance);
298 
299     /**
300      * @dev Returns the owner of the `tokenId` token.
301      *
302      * Requirements:
303      *
304      * - `tokenId` must exist.
305      */
306     function ownerOf(uint256 tokenId) external view returns (address owner);
307 
308     /**
309      * @dev Safely transfers `tokenId` token from `from` to `to`.
310      *
311      * Requirements:
312      *
313      * - `from` cannot be the zero address.
314      * - `to` cannot be the zero address.
315      * - `tokenId` token must exist and be owned by `from`.
316      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
317      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
318      *
319      * Emits a {Transfer} event.
320      */
321     function safeTransferFrom(
322         address from,
323         address to,
324         uint256 tokenId,
325         bytes calldata data
326     ) external;
327 
328     /**
329      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
330      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
331      *
332      * Requirements:
333      *
334      * - `from` cannot be the zero address.
335      * - `to` cannot be the zero address.
336      * - `tokenId` token must exist and be owned by `from`.
337      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
338      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
339      *
340      * Emits a {Transfer} event.
341      */
342     function safeTransferFrom(
343         address from,
344         address to,
345         uint256 tokenId
346     ) external;
347 
348     /**
349      * @dev Transfers `tokenId` token from `from` to `to`.
350      *
351      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
352      *
353      * Requirements:
354      *
355      * - `from` cannot be the zero address.
356      * - `to` cannot be the zero address.
357      * - `tokenId` token must be owned by `from`.
358      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
359      *
360      * Emits a {Transfer} event.
361      */
362     function transferFrom(
363         address from,
364         address to,
365         uint256 tokenId
366     ) external;
367 
368     /**
369      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
370      * The approval is cleared when the token is transferred.
371      *
372      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
373      *
374      * Requirements:
375      *
376      * - The caller must own the token or be an approved operator.
377      * - `tokenId` must exist.
378      *
379      * Emits an {Approval} event.
380      */
381     function approve(address to, uint256 tokenId) external;
382 
383     /**
384      * @dev Approve or remove `operator` as an operator for the caller.
385      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
386      *
387      * Requirements:
388      *
389      * - The `operator` cannot be the caller.
390      *
391      * Emits an {ApprovalForAll} event.
392      */
393     function setApprovalForAll(address operator, bool _approved) external;
394 
395     /**
396      * @dev Returns the account approved for `tokenId` token.
397      *
398      * Requirements:
399      *
400      * - `tokenId` must exist.
401      */
402     function getApproved(uint256 tokenId) external view returns (address operator);
403 
404     /**
405      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
406      *
407      * See {setApprovalForAll}
408      */
409     function isApprovedForAll(address owner, address operator) external view returns (bool);
410 }
411 
412 
413 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
414 
415 
416 
417 /**
418  * @title ERC721 token receiver interface
419  * @dev Interface for any contract that wants to support safeTransfers
420  * from ERC721 asset contracts.
421  */
422 interface IERC721Receiver {
423     /**
424      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
425      * by `operator` from `from`, this function is called.
426      *
427      * It must return its Solidity selector to confirm the token transfer.
428      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
429      *
430      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
431      */
432     function onERC721Received(
433         address operator,
434         address from,
435         uint256 tokenId,
436         bytes calldata data
437     ) external returns (bytes4);
438 }
439 
440 
441 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
442 
443 
444 
445 
446 
447 /**
448  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
449  * @dev See https://eips.ethereum.org/EIPS/eip-721
450  */
451 interface IERC721Metadata is IERC721 {
452     /**
453      * @dev Returns the token collection name.
454      */
455     function name() external view returns (string memory);
456 
457     /**
458      * @dev Returns the token collection symbol.
459      */
460     function symbol() external view returns (string memory);
461 
462     /**
463      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
464      */
465     function tokenURI(uint256 tokenId) external view returns (string memory);
466 }
467 
468 
469 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
470 
471 
472 
473 
474 
475 /**
476  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
477  * @dev See https://eips.ethereum.org/EIPS/eip-721
478  */
479 interface IERC721Enumerable is IERC721 {
480     /**
481      * @dev Returns the total amount of tokens stored by the contract.
482      */
483     function totalSupply() external view returns (uint256);
484 
485     /**
486      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
487      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
488      */
489     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
490 
491     /**
492      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
493      * Use along with {totalSupply} to enumerate all tokens.
494      */
495     function tokenByIndex(uint256 index) external view returns (uint256);
496 }
497 
498 
499 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
500 
501 
502 
503 /**
504  * @dev Collection of functions related to the address type
505  */
506 library Address {
507     /**
508      * @dev Returns true if `account` is a contract.
509      *
510      * [IMPORTANT]
511      * ====
512      * It is unsafe to assume that an address for which this function returns
513      * false is an externally-owned account (EOA) and not a contract.
514      *
515      * Among others, `isContract` will return false for the following
516      * types of addresses:
517      *
518      *  - an externally-owned account
519      *  - a contract in construction
520      *  - an address where a contract will be created
521      *  - an address where a contract lived, but was destroyed
522      * ====
523      *
524      * [IMPORTANT]
525      * ====
526      * You shouldn't rely on `isContract` to protect against flash loan attacks!
527      *
528      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
529      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
530      * constructor.
531      * ====
532      */
533     function isContract(address account) internal view returns (bool) {
534         // This method relies on extcodesize/address.code.length, which returns 0
535         // for contracts in construction, since the code is only stored at the end
536         // of the constructor execution.
537 
538         return account.code.length > 0;
539     }
540 
541     /**
542      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
543      * `recipient`, forwarding all available gas and reverting on errors.
544      *
545      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
546      * of certain opcodes, possibly making contracts go over the 2300 gas limit
547      * imposed by `transfer`, making them unable to receive funds via
548      * `transfer`. {sendValue} removes this limitation.
549      *
550      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
551      *
552      * IMPORTANT: because control is transferred to `recipient`, care must be
553      * taken to not create reentrancy vulnerabilities. Consider using
554      * {ReentrancyGuard} or the
555      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
556      */
557     function sendValue(address payable recipient, uint256 amount) internal {
558         require(address(this).balance >= amount, "Address: insufficient balance");
559 
560         (bool success, ) = recipient.call{value: amount}("");
561         require(success, "Address: unable to send value, recipient may have reverted");
562     }
563 
564     /**
565      * @dev Performs a Solidity function call using a low level `call`. A
566      * plain `call` is an unsafe replacement for a function call: use this
567      * function instead.
568      *
569      * If `target` reverts with a revert reason, it is bubbled up by this
570      * function (like regular Solidity function calls).
571      *
572      * Returns the raw returned data. To convert to the expected return value,
573      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
574      *
575      * Requirements:
576      *
577      * - `target` must be a contract.
578      * - calling `target` with `data` must not revert.
579      *
580      * _Available since v3.1._
581      */
582     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
583         return functionCall(target, data, "Address: low-level call failed");
584     }
585 
586     /**
587      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
588      * `errorMessage` as a fallback revert reason when `target` reverts.
589      *
590      * _Available since v3.1._
591      */
592     function functionCall(
593         address target,
594         bytes memory data,
595         string memory errorMessage
596     ) internal returns (bytes memory) {
597         return functionCallWithValue(target, data, 0, errorMessage);
598     }
599 
600     /**
601      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
602      * but also transferring `value` wei to `target`.
603      *
604      * Requirements:
605      *
606      * - the calling contract must have an ETH balance of at least `value`.
607      * - the called Solidity function must be `payable`.
608      *
609      * _Available since v3.1._
610      */
611     function functionCallWithValue(
612         address target,
613         bytes memory data,
614         uint256 value
615     ) internal returns (bytes memory) {
616         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
617     }
618 
619     /**
620      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
621      * with `errorMessage` as a fallback revert reason when `target` reverts.
622      *
623      * _Available since v3.1._
624      */
625     function functionCallWithValue(
626         address target,
627         bytes memory data,
628         uint256 value,
629         string memory errorMessage
630     ) internal returns (bytes memory) {
631         require(address(this).balance >= value, "Address: insufficient balance for call");
632         require(isContract(target), "Address: call to non-contract");
633 
634         (bool success, bytes memory returndata) = target.call{value: value}(data);
635         return verifyCallResult(success, returndata, errorMessage);
636     }
637 
638     /**
639      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
640      * but performing a static call.
641      *
642      * _Available since v3.3._
643      */
644     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
645         return functionStaticCall(target, data, "Address: low-level static call failed");
646     }
647 
648     /**
649      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
650      * but performing a static call.
651      *
652      * _Available since v3.3._
653      */
654     function functionStaticCall(
655         address target,
656         bytes memory data,
657         string memory errorMessage
658     ) internal view returns (bytes memory) {
659         require(isContract(target), "Address: static call to non-contract");
660 
661         (bool success, bytes memory returndata) = target.staticcall(data);
662         return verifyCallResult(success, returndata, errorMessage);
663     }
664 
665     /**
666      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
667      * but performing a delegate call.
668      *
669      * _Available since v3.4._
670      */
671     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
672         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
673     }
674 
675     /**
676      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
677      * but performing a delegate call.
678      *
679      * _Available since v3.4._
680      */
681     function functionDelegateCall(
682         address target,
683         bytes memory data,
684         string memory errorMessage
685     ) internal returns (bytes memory) {
686         require(isContract(target), "Address: delegate call to non-contract");
687 
688         (bool success, bytes memory returndata) = target.delegatecall(data);
689         return verifyCallResult(success, returndata, errorMessage);
690     }
691 
692     /**
693      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
694      * revert reason using the provided one.
695      *
696      * _Available since v4.3._
697      */
698     function verifyCallResult(
699         bool success,
700         bytes memory returndata,
701         string memory errorMessage
702     ) internal pure returns (bytes memory) {
703         if (success) {
704             return returndata;
705         } else {
706             // Look for revert reason and bubble it up if present
707             if (returndata.length > 0) {
708                 // The easiest way to bubble the revert reason is using memory via assembly
709 
710                 assembly {
711                     let returndata_size := mload(returndata)
712                     revert(add(32, returndata), returndata_size)
713                 }
714             } else {
715                 revert(errorMessage);
716             }
717         }
718     }
719 }
720 
721 
722 
723 
724 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
725 
726 
727 
728 
729 
730 /**
731  * @dev Implementation of the {IERC165} interface.
732  *
733  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
734  * for the additional interface id that will be supported. For example:
735  *
736  * ```solidity
737  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
738  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
739  * }
740  * ```
741  *
742  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
743  */
744 abstract contract ERC165 is IERC165 {
745     /**
746      * @dev See {IERC165-supportsInterface}.
747      */
748     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
749         return interfaceId == type(IERC165).interfaceId;
750     }
751 }
752 
753 
754 /**
755  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
756  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
757  *
758  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
759  *
760  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
761  *
762  * Does not support burning tokens to address(0).
763  */
764 contract ERC721A is
765     Context,
766     ERC165,
767     IERC721,
768     IERC721Metadata,
769     IERC721Enumerable
770 {
771     using Address for address;
772     using Strings for uint256;
773 
774     struct TokenOwnership {
775         address addr;
776         uint64 startTimestamp;
777     }
778 
779     struct AddressData {
780         uint128 balance;
781         uint128 numberMinted;
782     }
783 
784     uint256 private currentIndex = 0;
785 
786     uint256 internal immutable collectionSize;
787     uint256 internal immutable maxBatchSize;
788 
789     // Token name
790     string private _name;
791 
792     // Token symbol
793     string private _symbol;
794 
795     // Mapping from token ID to ownership details
796     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
797     mapping(uint256 => TokenOwnership) private _ownerships;
798 
799     // Mapping owner address to address data
800     mapping(address => AddressData) private _addressData;
801 
802     // Mapping from token ID to approved address
803     mapping(uint256 => address) private _tokenApprovals;
804 
805     // Mapping from owner to operator approvals
806     mapping(address => mapping(address => bool)) private _operatorApprovals;
807 
808     /**
809      * @dev
810      * `maxBatchSize` refers to how much a minter can mint at a time.
811      * `collectionSize_` refers to how many tokens are in the collection.
812      */
813     constructor(
814         string memory name_,
815         string memory symbol_,
816         uint256 maxBatchSize_,
817         uint256 collectionSize_
818     ) {
819         require(
820             collectionSize_ > 0,
821             "ERC721A: collection must have a nonzero supply"
822         );
823         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
824         _name = name_;
825         _symbol = symbol_;
826         maxBatchSize = maxBatchSize_;
827         collectionSize = collectionSize_;
828     }
829 
830     /**
831      * @dev See {IERC721Enumerable-totalSupply}.
832      */
833     function totalSupply() public view override returns (uint256) {
834         return currentIndex;
835     }
836 
837     /**
838      * @dev See {IERC721Enumerable-tokenByIndex}.
839      */
840     function tokenByIndex(uint256 index)
841         public
842         view
843         override
844         returns (uint256)
845     {
846         require(index < totalSupply(), "ERC721A: global index out of bounds");
847         return index;
848     }
849 
850     /**
851      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
852      * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
853      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
854      */
855     function tokenOfOwnerByIndex(address owner, uint256 index)
856         public
857         view
858         override
859         returns (uint256)
860     {
861         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
862         uint256 numMintedSoFar = totalSupply();
863         uint256 tokenIdsIdx = 0;
864         address currOwnershipAddr = address(0);
865         for (uint256 i = 0; i < numMintedSoFar; i++) {
866             TokenOwnership memory ownership = _ownerships[i];
867             if (ownership.addr != address(0)) {
868                 currOwnershipAddr = ownership.addr;
869             }
870             if (currOwnershipAddr == owner) {
871                 if (tokenIdsIdx == index) {
872                     return i;
873                 }
874                 tokenIdsIdx++;
875             }
876         }
877         revert("ERC721A: unable to get token of owner by index");
878     }
879 
880     /**
881      * @dev See {IERC165-supportsInterface}.
882      */
883     function supportsInterface(bytes4 interfaceId)
884         public
885         view
886         virtual
887         override(ERC165, IERC165)
888         returns (bool)
889     {
890         return
891             interfaceId == type(IERC721).interfaceId ||
892             interfaceId == type(IERC721Metadata).interfaceId ||
893             interfaceId == type(IERC721Enumerable).interfaceId ||
894             super.supportsInterface(interfaceId);
895     }
896 
897     /**
898      * @dev See {IERC721-balanceOf}.
899      */
900     function balanceOf(address owner) public view override returns (uint256) {
901         require(
902             owner != address(0),
903             "ERC721A: balance query for the zero address"
904         );
905         return uint256(_addressData[owner].balance);
906     }
907 
908     function _numberMinted(address owner) internal view returns (uint256) {
909         require(
910             owner != address(0),
911             "ERC721A: number minted query for the zero address"
912         );
913         return uint256(_addressData[owner].numberMinted);
914     }
915 
916     function ownershipOf(uint256 tokenId)
917         internal
918         view
919         returns (TokenOwnership memory)
920     {
921         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
922 
923         uint256 lowestTokenToCheck;
924         if (tokenId >= maxBatchSize) {
925             lowestTokenToCheck = tokenId - maxBatchSize + 1;
926         }
927 
928         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
929             TokenOwnership memory ownership = _ownerships[curr];
930             if (ownership.addr != address(0)) {
931                 return ownership;
932             }
933         }
934 
935         revert("ERC721A: unable to determine the owner of token");
936     }
937 
938     /**
939      * @dev See {IERC721-ownerOf}.
940      */
941     function ownerOf(uint256 tokenId) public view override returns (address) {
942         return ownershipOf(tokenId).addr;
943     }
944 
945     /**
946      * @dev See {IERC721Metadata-name}.
947      */
948     function name() public view virtual override returns (string memory) {
949         return _name;
950     }
951 
952     /**
953      * @dev See {IERC721Metadata-symbol}.
954      */
955     function symbol() public view virtual override returns (string memory) {
956         return _symbol;
957     }
958 
959     /**
960      * @dev See {IERC721Metadata-tokenURI}.
961      */
962     function tokenURI(uint256 tokenId)
963         public
964         view
965         virtual
966         override
967         returns (string memory)
968     {
969         require(
970             _exists(tokenId),
971             "ERC721Metadata: URI query for nonexistent token"
972         );
973 
974         string memory baseURI = _baseURI();
975         return
976             bytes(baseURI).length > 0
977                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
978                 : "";
979     }
980 
981     /**
982      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
983      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
984      * by default, can be overriden in child contracts.
985      */
986     function _baseURI() internal view virtual returns (string memory) {
987         return "";
988     }
989 
990     /**
991      * @dev See {IERC721-approve}.
992      */
993     function approve(address to, uint256 tokenId) public override {
994         address owner = ERC721A.ownerOf(tokenId);
995         require(to != owner, "ERC721A: approval to current owner");
996 
997         require(
998             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
999             "ERC721A: approve caller is not owner nor approved for all"
1000         );
1001 
1002         _approve(to, tokenId, owner);
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-getApproved}.
1007      */
1008     function getApproved(uint256 tokenId)
1009         public
1010         view
1011         override
1012         returns (address)
1013     {
1014         require(
1015             _exists(tokenId),
1016             "ERC721A: approved query for nonexistent token"
1017         );
1018 
1019         return _tokenApprovals[tokenId];
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-setApprovalForAll}.
1024      */
1025     function setApprovalForAll(address operator, bool approved)
1026         public
1027         override
1028     {
1029         require(operator != _msgSender(), "ERC721A: approve to caller");
1030 
1031         _operatorApprovals[_msgSender()][operator] = approved;
1032         emit ApprovalForAll(_msgSender(), operator, approved);
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-isApprovedForAll}.
1037      */
1038     function isApprovedForAll(address owner, address operator)
1039         public
1040         view
1041         virtual
1042         override
1043         returns (bool)
1044     {
1045         return _operatorApprovals[owner][operator];
1046     }
1047 
1048     /**
1049      * @dev See {IERC721-transferFrom}.
1050      */
1051     function transferFrom(
1052         address from,
1053         address to,
1054         uint256 tokenId
1055     ) public override {
1056         _transfer(from, to, tokenId);
1057     }
1058 
1059     /**
1060      * @dev See {IERC721-safeTransferFrom}.
1061      */
1062     function safeTransferFrom(
1063         address from,
1064         address to,
1065         uint256 tokenId
1066     ) public override {
1067         safeTransferFrom(from, to, tokenId, "");
1068     }
1069 
1070     /**
1071      * @dev See {IERC721-safeTransferFrom}.
1072      */
1073     function safeTransferFrom(
1074         address from,
1075         address to,
1076         uint256 tokenId,
1077         bytes memory _data
1078     ) public override {
1079         _transfer(from, to, tokenId);
1080         require(
1081             _checkOnERC721Received(from, to, tokenId, _data),
1082             "ERC721A: transfer to non ERC721Receiver implementer"
1083         );
1084     }
1085 
1086     /**
1087      * @dev Returns whether `tokenId` exists.
1088      *
1089      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1090      *
1091      * Tokens start existing when they are minted (`_mint`),
1092      */
1093     function _exists(uint256 tokenId) internal view returns (bool) {
1094         return tokenId < currentIndex;
1095     }
1096 
1097     function _safeMint(address to, uint256 quantity) internal {
1098         _safeMint(to, quantity, "");
1099     }
1100 
1101     /**
1102      * @dev Mints `quantity` tokens and transfers them to `to`.
1103      *
1104      * Requirements:
1105      *
1106      * - there must be `quantity` tokens remaining unminted in the total collection.
1107      * - `to` cannot be the zero address.
1108      * - `quantity` cannot be larger than the max batch size.
1109      *
1110      * Emits a {Transfer} event.
1111      */
1112     function _safeMint(
1113         address to,
1114         uint256 quantity,
1115         bytes memory _data
1116     ) internal {
1117         uint256 startTokenId = currentIndex;
1118         require(to != address(0), "ERC721A: mint to the zero address");
1119         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1120         require(!_exists(startTokenId), "ERC721A: token already minted");
1121         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1122 
1123         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1124 
1125         AddressData memory addressData = _addressData[to];
1126         _addressData[to] = AddressData(
1127             addressData.balance + uint128(quantity),
1128             addressData.numberMinted + uint128(quantity)
1129         );
1130         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1131 
1132         uint256 updatedIndex = startTokenId;
1133 
1134         for (uint256 i = 0; i < quantity; i++) {
1135             emit Transfer(address(0), to, updatedIndex);
1136             require(
1137                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1138                 "ERC721A: transfer to non ERC721Receiver implementer"
1139             );
1140             updatedIndex++;
1141         }
1142 
1143         currentIndex = updatedIndex;
1144         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1145     }
1146 
1147     /**
1148      * @dev Transfers `tokenId` from `from` to `to`.
1149      *
1150      * Requirements:
1151      *
1152      * - `to` cannot be the zero address.
1153      * - `tokenId` token must be owned by `from`.
1154      *
1155      * Emits a {Transfer} event.
1156      */
1157     function _transfer(
1158         address from,
1159         address to,
1160         uint256 tokenId
1161     ) private {
1162         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1163 
1164         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1165             getApproved(tokenId) == _msgSender() ||
1166             isApprovedForAll(prevOwnership.addr, _msgSender()));
1167 
1168         require(
1169             isApprovedOrOwner,
1170             "ERC721A: transfer caller is not owner nor approved"
1171         );
1172 
1173         require(
1174             prevOwnership.addr == from,
1175             "ERC721A: transfer from incorrect owner"
1176         );
1177         require(to != address(0), "ERC721A: transfer to the zero address");
1178 
1179         _beforeTokenTransfers(from, to, tokenId, 1);
1180 
1181         // Clear approvals from the previous owner
1182         _approve(address(0), tokenId, prevOwnership.addr);
1183 
1184         _addressData[from].balance -= 1;
1185         _addressData[to].balance += 1;
1186         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1187 
1188         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1189         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1190         uint256 nextTokenId = tokenId + 1;
1191         if (_ownerships[nextTokenId].addr == address(0)) {
1192             if (_exists(nextTokenId)) {
1193                 _ownerships[nextTokenId] = TokenOwnership(
1194                     prevOwnership.addr,
1195                     prevOwnership.startTimestamp
1196                 );
1197             }
1198         }
1199 
1200         emit Transfer(from, to, tokenId);
1201         _afterTokenTransfers(from, to, tokenId, 1);
1202     }
1203 
1204     /**
1205      * @dev Approve `to` to operate on `tokenId`
1206      *
1207      * Emits a {Approval} event.
1208      */
1209     function _approve(
1210         address to,
1211         uint256 tokenId,
1212         address owner
1213     ) private {
1214         _tokenApprovals[tokenId] = to;
1215         emit Approval(owner, to, tokenId);
1216     }
1217 
1218     uint256 public nextOwnerToExplicitlySet = 0;
1219 
1220     /**
1221      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1222      */
1223     function _setOwnersExplicit(uint256 quantity) internal {
1224         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1225         require(quantity > 0, "quantity must be nonzero");
1226         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1227         if (endIndex > collectionSize - 1) {
1228             endIndex = collectionSize - 1;
1229         }
1230         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1231         require(_exists(endIndex), "not enough minted yet for this cleanup");
1232         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1233             if (_ownerships[i].addr == address(0)) {
1234                 TokenOwnership memory ownership = ownershipOf(i);
1235                 _ownerships[i] = TokenOwnership(
1236                     ownership.addr,
1237                     ownership.startTimestamp
1238                 );
1239             }
1240         }
1241         nextOwnerToExplicitlySet = endIndex + 1;
1242     }
1243 
1244     /**
1245      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1246      * The call is not executed if the target address is not a contract.
1247      *
1248      * @param from address representing the previous owner of the given token ID
1249      * @param to target address that will receive the tokens
1250      * @param tokenId uint256 ID of the token to be transferred
1251      * @param _data bytes optional data to send along with the call
1252      * @return bool whether the call correctly returned the expected magic value
1253      */
1254     function _checkOnERC721Received(
1255         address from,
1256         address to,
1257         uint256 tokenId,
1258         bytes memory _data
1259     ) private returns (bool) {
1260         if (to.isContract()) {
1261             try
1262                 IERC721Receiver(to).onERC721Received(
1263                     _msgSender(),
1264                     from,
1265                     tokenId,
1266                     _data
1267                 )
1268             returns (bytes4 retval) {
1269                 return retval == IERC721Receiver(to).onERC721Received.selector;
1270             } catch (bytes memory reason) {
1271                 if (reason.length == 0) {
1272                     revert(
1273                         "ERC721A: transfer to non ERC721Receiver implementer"
1274                     );
1275                 } else {
1276                     assembly {
1277                         revert(add(32, reason), mload(reason))
1278                     }
1279                 }
1280             }
1281         } else {
1282             return true;
1283         }
1284     }
1285 
1286     /**
1287      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1288      *
1289      * startTokenId - the first token id to be transferred
1290      * quantity - the amount to be transferred
1291      *
1292      * Calling conditions:
1293      *
1294      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1295      * transferred to `to`.
1296      * - When `from` is zero, `tokenId` will be minted for `to`.
1297      */
1298     function _beforeTokenTransfers(
1299         address from,
1300         address to,
1301         uint256 startTokenId,
1302         uint256 quantity
1303     ) internal virtual {}
1304 
1305     /**
1306      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1307      * minting.
1308      *
1309      * startTokenId - the first token id to be transferred
1310      * quantity - the amount to be transferred
1311      *
1312      * Calling conditions:
1313      *
1314      * - when `from` and `to` are both non-zero.
1315      * - `from` and `to` are never both zero.
1316      */
1317     function _afterTokenTransfers(
1318         address from,
1319         address to,
1320         uint256 startTokenId,
1321         uint256 quantity
1322     ) internal virtual {}
1323 }
1324 
1325 
1326 contract MILOCLOAK is ERC721A, Ownable {
1327     using Strings for uint256;
1328 
1329     bool public saleIsActive = false;
1330     bool public publicSaleIsActive = false;
1331     bool public revealed = false;
1332     string private baseURI;
1333     string private notRevealedUri;
1334     bytes32 public saleMerkleRoot;
1335 
1336     uint256 public constant MAX_SUPPLY = 5000;
1337     uint256 public constant MAX_WH_BALANCE = 1;
1338     uint256 public constant MAX_PUB_BALANCE = 5;
1339     uint256 public constant MAX_WH_MINT = 1;
1340     uint256 public constant MAX_PUB_MINT = 5;
1341     uint256 public constant PRICE_WH_TOKEN = 0.08 ether;
1342     uint256 public constant PRICE_PUB_TOKEN = 0.1 ether;
1343 
1344     mapping(address => uint256) public whiteListBuyed;
1345 
1346     constructor(uint256 maxBatchSize_, uint256 collectionSize_)
1347         ERC721A("CLOAK", "CLOAK", maxBatchSize_, collectionSize_)
1348     {}
1349 
1350     modifier isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root) {
1351         require(
1352             MerkleProof.verify(
1353                 merkleProof,
1354                 root,
1355                 keccak256(abi.encodePacked(msg.sender))
1356             ),
1357             "Address does not exist in list"
1358         );
1359         _;
1360     }
1361 
1362     modifier callerIsUser() {
1363         require(tx.origin == msg.sender, "The caller is another contract");
1364         _;
1365     }
1366 
1367     function mintWhiteList(uint8 numberOfTokens, bytes32[] calldata merkleProof)
1368         external
1369         payable
1370         isValidMerkleProof(merkleProof, saleMerkleRoot)
1371         callerIsUser
1372     {
1373         uint256 ts = totalSupply();
1374         require(saleIsActive, "sale is not active");
1375         require(
1376             numberOfTokens <= MAX_WH_MINT,
1377             "Exceeded max available to purchase"
1378         );
1379         require(
1380             ts + numberOfTokens <= MAX_SUPPLY,
1381             "Purchase would exceed max tokens"
1382         );
1383         require(
1384             balanceOf(msg.sender) + numberOfTokens <= MAX_WH_BALANCE,
1385             "Sale would exceed max balance"
1386         );
1387         require(
1388             PRICE_WH_TOKEN * numberOfTokens <= msg.value,
1389             "Ether value sent is not correct"
1390         );
1391         require(
1392             whiteListBuyed[msg.sender] + numberOfTokens <= MAX_WH_BALANCE,
1393             "sender bought enough"
1394         );
1395 
1396         _safeMint(msg.sender, numberOfTokens);
1397         whiteListBuyed[msg.sender]++;
1398     }
1399 
1400     function mint(uint256 numberOfTokens) public payable callerIsUser {
1401         uint256 ts = totalSupply();
1402         require(publicSaleIsActive, "publicSale must be active to mint tokens");
1403         require(numberOfTokens <= MAX_PUB_MINT, "Exceeded max token purchase");
1404         require(
1405             ts + numberOfTokens <= MAX_SUPPLY,
1406             "Purchase would exceed max tokens"
1407         );
1408         require(
1409             balanceOf(msg.sender) + numberOfTokens <= MAX_PUB_BALANCE,
1410             "Sale would exceed max balance"
1411         );
1412         require(
1413             PRICE_PUB_TOKEN * numberOfTokens <= msg.value,
1414             "Ether value sent is not correct"
1415         );
1416 
1417         _safeMint(msg.sender, numberOfTokens);
1418     }
1419 
1420     function mint4owner(uint256 numberOfTokens, address recipient)
1421         public
1422         onlyOwner
1423         callerIsUser
1424     {
1425         uint256 ts = totalSupply();
1426         require(
1427             ts + numberOfTokens <= MAX_SUPPLY,
1428             "Purchase would exceed max tokens"
1429         );
1430 
1431         _safeMint(recipient, numberOfTokens);
1432     }
1433 
1434     function tokenURI(uint256 tokenId)
1435         public
1436         view
1437         virtual
1438         override
1439         returns (string memory)
1440     {
1441         require(
1442             _exists(tokenId),
1443             "ERC721Metadata: URI query for nonexistent token"
1444         );
1445 
1446         if (revealed == false) {
1447             return notRevealedUri;
1448         }
1449 
1450         string memory base = _baseURI();
1451         return string(abi.encodePacked(base, tokenId.toString()));
1452     }
1453 
1454     // internal
1455     function _baseURI() internal view virtual override returns (string memory) {
1456         return baseURI;
1457     }
1458 
1459     //only owner
1460     function flipSaleActive() public onlyOwner {
1461         saleIsActive = !saleIsActive;
1462     }
1463 
1464     function flipPublicSaleActive() public onlyOwner {
1465         publicSaleIsActive = !publicSaleIsActive;
1466     }
1467 
1468     function flipReveal() public onlyOwner {
1469         revealed = !revealed;
1470     }
1471 
1472     function setSaleMerkleRoot(bytes32 merkleRoot) external onlyOwner {
1473         saleMerkleRoot = merkleRoot;
1474     }
1475 
1476     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1477         notRevealedUri = _notRevealedURI;
1478     }
1479 
1480     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1481         baseURI = _newBaseURI;
1482     }
1483 
1484     function withdraw() public onlyOwner {
1485         uint256 balance = address(this).balance;
1486         payable(msg.sender).transfer(balance);
1487     }
1488 }