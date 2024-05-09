1 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.4.2
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
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
46                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
47             } else {
48                 // Hash(current element of the proof + current computed hash)
49                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
50             }
51         }
52         return computedHash;
53     }
54 }
55 
56 
57 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
58 
59 
60 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
61 
62 
63 
64 /**
65  * @dev Provides information about the current execution context, including the
66  * sender of the transaction and its data. While these are generally available
67  * via msg.sender and msg.data, they should not be accessed in such a direct
68  * manner, since when dealing with meta-transactions the account sending and
69  * paying for execution may not be the actual sender (as far as an application
70  * is concerned).
71  *
72  * This contract is only required for intermediate, library-like contracts.
73  */
74 abstract contract Context {
75     function _msgSender() internal view virtual returns (address) {
76         return msg.sender;
77     }
78 
79     function _msgData() internal view virtual returns (bytes calldata) {
80         return msg.data;
81     }
82 }
83 
84 
85 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
86 
87 
88 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
89 
90 
91 
92 /**
93  * @dev Contract module which provides a basic access control mechanism, where
94  * there is an account (an owner) that can be granted exclusive access to
95  * specific functions.
96  *
97  * By default, the owner account will be the one that deploys the contract. This
98  * can later be changed with {transferOwnership}.
99  *
100  * This module is used through inheritance. It will make available the modifier
101  * `onlyOwner`, which can be applied to your functions to restrict their use to
102  * the owner.
103  */
104 abstract contract Ownable is Context {
105     address private _owner;
106 
107     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
108 
109     /**
110      * @dev Initializes the contract setting the deployer as the initial owner.
111      */
112     constructor() {
113         _transferOwnership(_msgSender());
114     }
115 
116     /**
117      * @dev Returns the address of the current owner.
118      */
119     function owner() public view virtual returns (address) {
120         return _owner;
121     }
122 
123     /**
124      * @dev Throws if called by any account other than the owner.
125      */
126     modifier onlyOwner() {
127         require(owner() == _msgSender(), "Ownable: caller is not the owner");
128         _;
129     }
130 
131     /**
132      * @dev Leaves the contract without owner. It will not be possible to call
133      * `onlyOwner` functions anymore. Can only be called by the current owner.
134      *
135      * NOTE: Renouncing ownership will leave the contract without an owner,
136      * thereby removing any functionality that is only available to the owner.
137      */
138     function renounceOwnership() public virtual onlyOwner {
139         _transferOwnership(address(0));
140     }
141 
142     /**
143      * @dev Transfers ownership of the contract to a new account (`newOwner`).
144      * Can only be called by the current owner.
145      */
146     function transferOwnership(address newOwner) public virtual onlyOwner {
147         require(newOwner != address(0), "Ownable: new owner is the zero address");
148         _transferOwnership(newOwner);
149     }
150 
151     /**
152      * @dev Transfers ownership of the contract to a new account (`newOwner`).
153      * Internal function without access restriction.
154      */
155     function _transferOwnership(address newOwner) internal virtual {
156         address oldOwner = _owner;
157         _owner = newOwner;
158         emit OwnershipTransferred(oldOwner, newOwner);
159     }
160 }
161 
162 
163 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
164 
165 
166 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
167 
168 
169 
170 /**
171  * @dev String operations.
172  */
173 library Strings {
174     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
175 
176     /**
177      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
178      */
179     function toString(uint256 value) internal pure returns (string memory) {
180         // Inspired by OraclizeAPI's implementation - MIT licence
181         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
182 
183         if (value == 0) {
184             return "0";
185         }
186         uint256 temp = value;
187         uint256 digits;
188         while (temp != 0) {
189             digits++;
190             temp /= 10;
191         }
192         bytes memory buffer = new bytes(digits);
193         while (value != 0) {
194             digits -= 1;
195             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
196             value /= 10;
197         }
198         return string(buffer);
199     }
200 
201     /**
202      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
203      */
204     function toHexString(uint256 value) internal pure returns (string memory) {
205         if (value == 0) {
206             return "0x00";
207         }
208         uint256 temp = value;
209         uint256 length = 0;
210         while (temp != 0) {
211             length++;
212             temp >>= 8;
213         }
214         return toHexString(value, length);
215     }
216 
217     /**
218      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
219      */
220     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
221         bytes memory buffer = new bytes(2 * length + 2);
222         buffer[0] = "0";
223         buffer[1] = "x";
224         for (uint256 i = 2 * length + 1; i > 1; --i) {
225             buffer[i] = _HEX_SYMBOLS[value & 0xf];
226             value >>= 4;
227         }
228         require(value == 0, "Strings: hex length insufficient");
229         return string(buffer);
230     }
231 }
232 
233 
234 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
235 
236 
237 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
238 
239 
240 
241 /**
242  * @dev Interface of the ERC165 standard, as defined in the
243  * https://eips.ethereum.org/EIPS/eip-165[EIP].
244  *
245  * Implementers can declare support of contract interfaces, which can then be
246  * queried by others ({ERC165Checker}).
247  *
248  * For an implementation, see {ERC165}.
249  */
250 interface IERC165 {
251     /**
252      * @dev Returns true if this contract implements the interface defined by
253      * `interfaceId`. See the corresponding
254      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
255      * to learn more about how these ids are created.
256      *
257      * This function call must use less than 30 000 gas.
258      */
259     function supportsInterface(bytes4 interfaceId) external view returns (bool);
260 }
261 
262 
263 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
264 
265 
266 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
267 
268 
269 
270 /**
271  * @dev Required interface of an ERC721 compliant contract.
272  */
273 interface IERC721 is IERC165 {
274     /**
275      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
276      */
277     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
278 
279     /**
280      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
281      */
282     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
283 
284     /**
285      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
286      */
287     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
288 
289     /**
290      * @dev Returns the number of tokens in ``owner``'s account.
291      */
292     function balanceOf(address owner) external view returns (uint256 balance);
293 
294     /**
295      * @dev Returns the owner of the `tokenId` token.
296      *
297      * Requirements:
298      *
299      * - `tokenId` must exist.
300      */
301     function ownerOf(uint256 tokenId) external view returns (address owner);
302 
303     /**
304      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
305      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
306      *
307      * Requirements:
308      *
309      * - `from` cannot be the zero address.
310      * - `to` cannot be the zero address.
311      * - `tokenId` token must exist and be owned by `from`.
312      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
313      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
314      *
315      * Emits a {Transfer} event.
316      */
317     function safeTransferFrom(
318         address from,
319         address to,
320         uint256 tokenId
321     ) external;
322 
323     /**
324      * @dev Transfers `tokenId` token from `from` to `to`.
325      *
326      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
327      *
328      * Requirements:
329      *
330      * - `from` cannot be the zero address.
331      * - `to` cannot be the zero address.
332      * - `tokenId` token must be owned by `from`.
333      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
334      *
335      * Emits a {Transfer} event.
336      */
337     function transferFrom(
338         address from,
339         address to,
340         uint256 tokenId
341     ) external;
342 
343     /**
344      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
345      * The approval is cleared when the token is transferred.
346      *
347      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
348      *
349      * Requirements:
350      *
351      * - The caller must own the token or be an approved operator.
352      * - `tokenId` must exist.
353      *
354      * Emits an {Approval} event.
355      */
356     function approve(address to, uint256 tokenId) external;
357 
358     /**
359      * @dev Returns the account approved for `tokenId` token.
360      *
361      * Requirements:
362      *
363      * - `tokenId` must exist.
364      */
365     function getApproved(uint256 tokenId) external view returns (address operator);
366 
367     /**
368      * @dev Approve or remove `operator` as an operator for the caller.
369      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
370      *
371      * Requirements:
372      *
373      * - The `operator` cannot be the caller.
374      *
375      * Emits an {ApprovalForAll} event.
376      */
377     function setApprovalForAll(address operator, bool _approved) external;
378 
379     /**
380      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
381      *
382      * See {setApprovalForAll}
383      */
384     function isApprovedForAll(address owner, address operator) external view returns (bool);
385 
386     /**
387      * @dev Safely transfers `tokenId` token from `from` to `to`.
388      *
389      * Requirements:
390      *
391      * - `from` cannot be the zero address.
392      * - `to` cannot be the zero address.
393      * - `tokenId` token must exist and be owned by `from`.
394      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
395      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
396      *
397      * Emits a {Transfer} event.
398      */
399     function safeTransferFrom(
400         address from,
401         address to,
402         uint256 tokenId,
403         bytes calldata data
404     ) external;
405 }
406 
407 
408 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
409 
410 
411 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
412 
413 
414 
415 /**
416  * @title ERC721 token receiver interface
417  * @dev Interface for any contract that wants to support safeTransfers
418  * from ERC721 asset contracts.
419  */
420 interface IERC721Receiver {
421     /**
422      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
423      * by `operator` from `from`, this function is called.
424      *
425      * It must return its Solidity selector to confirm the token transfer.
426      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
427      *
428      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
429      */
430     function onERC721Received(
431         address operator,
432         address from,
433         uint256 tokenId,
434         bytes calldata data
435     ) external returns (bytes4);
436 }
437 
438 
439 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
440 
441 
442 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
443 
444 
445 
446 /**
447  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
448  * @dev See https://eips.ethereum.org/EIPS/eip-721
449  */
450 interface IERC721Metadata is IERC721 {
451     /**
452      * @dev Returns the token collection name.
453      */
454     function name() external view returns (string memory);
455 
456     /**
457      * @dev Returns the token collection symbol.
458      */
459     function symbol() external view returns (string memory);
460 
461     /**
462      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
463      */
464     function tokenURI(uint256 tokenId) external view returns (string memory);
465 }
466 
467 
468 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.2
469 
470 
471 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
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
489     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
490 
491     /**
492      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
493      * Use along with {totalSupply} to enumerate all tokens.
494      */
495     function tokenByIndex(uint256 index) external view returns (uint256);
496 }
497 
498 
499 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
500 
501 
502 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
503 
504 
505 
506 /**
507  * @dev Collection of functions related to the address type
508  */
509 library Address {
510     /**
511      * @dev Returns true if `account` is a contract.
512      *
513      * [IMPORTANT]
514      * ====
515      * It is unsafe to assume that an address for which this function returns
516      * false is an externally-owned account (EOA) and not a contract.
517      *
518      * Among others, `isContract` will return false for the following
519      * types of addresses:
520      *
521      *  - an externally-owned account
522      *  - a contract in construction
523      *  - an address where a contract will be created
524      *  - an address where a contract lived, but was destroyed
525      * ====
526      */
527     function isContract(address account) internal view returns (bool) {
528         // This method relies on extcodesize, which returns 0 for contracts in
529         // construction, since the code is only stored at the end of the
530         // constructor execution.
531 
532         uint256 size;
533         assembly {
534             size := extcodesize(account)
535         }
536         return size > 0;
537     }
538 
539     /**
540      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
541      * `recipient`, forwarding all available gas and reverting on errors.
542      *
543      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
544      * of certain opcodes, possibly making contracts go over the 2300 gas limit
545      * imposed by `transfer`, making them unable to receive funds via
546      * `transfer`. {sendValue} removes this limitation.
547      *
548      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
549      *
550      * IMPORTANT: because control is transferred to `recipient`, care must be
551      * taken to not create reentrancy vulnerabilities. Consider using
552      * {ReentrancyGuard} or the
553      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
554      */
555     function sendValue(address payable recipient, uint256 amount) internal {
556         require(address(this).balance >= amount, "Address: insufficient balance");
557 
558         (bool success, ) = recipient.call{value: amount}("");
559         require(success, "Address: unable to send value, recipient may have reverted");
560     }
561 
562     /**
563      * @dev Performs a Solidity function call using a low level `call`. A
564      * plain `call` is an unsafe replacement for a function call: use this
565      * function instead.
566      *
567      * If `target` reverts with a revert reason, it is bubbled up by this
568      * function (like regular Solidity function calls).
569      *
570      * Returns the raw returned data. To convert to the expected return value,
571      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
572      *
573      * Requirements:
574      *
575      * - `target` must be a contract.
576      * - calling `target` with `data` must not revert.
577      *
578      * _Available since v3.1._
579      */
580     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
581         return functionCall(target, data, "Address: low-level call failed");
582     }
583 
584     /**
585      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
586      * `errorMessage` as a fallback revert reason when `target` reverts.
587      *
588      * _Available since v3.1._
589      */
590     function functionCall(
591         address target,
592         bytes memory data,
593         string memory errorMessage
594     ) internal returns (bytes memory) {
595         return functionCallWithValue(target, data, 0, errorMessage);
596     }
597 
598     /**
599      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
600      * but also transferring `value` wei to `target`.
601      *
602      * Requirements:
603      *
604      * - the calling contract must have an ETH balance of at least `value`.
605      * - the called Solidity function must be `payable`.
606      *
607      * _Available since v3.1._
608      */
609     function functionCallWithValue(
610         address target,
611         bytes memory data,
612         uint256 value
613     ) internal returns (bytes memory) {
614         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
615     }
616 
617     /**
618      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
619      * with `errorMessage` as a fallback revert reason when `target` reverts.
620      *
621      * _Available since v3.1._
622      */
623     function functionCallWithValue(
624         address target,
625         bytes memory data,
626         uint256 value,
627         string memory errorMessage
628     ) internal returns (bytes memory) {
629         require(address(this).balance >= value, "Address: insufficient balance for call");
630         require(isContract(target), "Address: call to non-contract");
631 
632         (bool success, bytes memory returndata) = target.call{value: value}(data);
633         return verifyCallResult(success, returndata, errorMessage);
634     }
635 
636     /**
637      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
638      * but performing a static call.
639      *
640      * _Available since v3.3._
641      */
642     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
643         return functionStaticCall(target, data, "Address: low-level static call failed");
644     }
645 
646     /**
647      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
648      * but performing a static call.
649      *
650      * _Available since v3.3._
651      */
652     function functionStaticCall(
653         address target,
654         bytes memory data,
655         string memory errorMessage
656     ) internal view returns (bytes memory) {
657         require(isContract(target), "Address: static call to non-contract");
658 
659         (bool success, bytes memory returndata) = target.staticcall(data);
660         return verifyCallResult(success, returndata, errorMessage);
661     }
662 
663     /**
664      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
665      * but performing a delegate call.
666      *
667      * _Available since v3.4._
668      */
669     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
670         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
671     }
672 
673     /**
674      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
675      * but performing a delegate call.
676      *
677      * _Available since v3.4._
678      */
679     function functionDelegateCall(
680         address target,
681         bytes memory data,
682         string memory errorMessage
683     ) internal returns (bytes memory) {
684         require(isContract(target), "Address: delegate call to non-contract");
685 
686         (bool success, bytes memory returndata) = target.delegatecall(data);
687         return verifyCallResult(success, returndata, errorMessage);
688     }
689 
690     /**
691      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
692      * revert reason using the provided one.
693      *
694      * _Available since v4.3._
695      */
696     function verifyCallResult(
697         bool success,
698         bytes memory returndata,
699         string memory errorMessage
700     ) internal pure returns (bytes memory) {
701         if (success) {
702             return returndata;
703         } else {
704             // Look for revert reason and bubble it up if present
705             if (returndata.length > 0) {
706                 // The easiest way to bubble the revert reason is using memory via assembly
707 
708                 assembly {
709                     let returndata_size := mload(returndata)
710                     revert(add(32, returndata), returndata_size)
711                 }
712             } else {
713                 revert(errorMessage);
714             }
715         }
716     }
717 }
718 
719 
720 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
721 
722 
723 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
724 
725 
726 
727 /**
728  * @dev Implementation of the {IERC165} interface.
729  *
730  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
731  * for the additional interface id that will be supported. For example:
732  *
733  * ```solidity
734  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
735  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
736  * }
737  * ```
738  *
739  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
740  */
741 abstract contract ERC165 is IERC165 {
742     /**
743      * @dev See {IERC165-supportsInterface}.
744      */
745     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
746         return interfaceId == type(IERC165).interfaceId;
747     }
748 }
749 
750 
751 // File contracts/ERC721A.sol
752 
753 
754 // Creator: Chiru Labs
755 
756 
757 /**
758  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
759  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
760  *
761  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
762  *
763  * Does not support burning tokens to address(0).
764  *
765  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
766  */
767 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
768     using Address for address;
769     using Strings for uint256;
770 
771     struct TokenOwnership {
772         address addr;
773         uint64 startTimestamp;
774     }
775 
776     struct AddressData {
777         uint128 balance;
778         uint128 numberMinted;
779     }
780 
781     uint256 internal currentIndex = 0;
782 
783     // Token name
784     string private _name;
785 
786     // Token symbol
787     string private _symbol;
788 
789     // Mapping from token ID to ownership details
790     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
791     mapping(uint256 => TokenOwnership) internal _ownerships;
792 
793     // Mapping owner address to address data
794     mapping(address => AddressData) private _addressData;
795 
796     // Mapping from token ID to approved address
797     mapping(uint256 => address) private _tokenApprovals;
798 
799     // Mapping from owner to operator approvals
800     mapping(address => mapping(address => bool)) private _operatorApprovals;
801 
802     constructor(string memory name_, string memory symbol_) {
803         _name = name_;
804         _symbol = symbol_;
805     }
806 
807     /**
808      * @dev See {IERC721Enumerable-totalSupply}.
809      */
810     function totalSupply() public view override returns (uint256) {
811         return currentIndex;
812     }
813 
814     /**
815      * @dev See {IERC721Enumerable-tokenByIndex}.
816      */
817     function tokenByIndex(uint256 index) public view override returns (uint256) {
818         require(index < totalSupply(), 'ERC721A: global index out of bounds');
819         return index;
820     }
821 
822     /**
823      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
824      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
825      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
826      */
827     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
828         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
829         uint256 numMintedSoFar = totalSupply();
830         uint256 tokenIdsIdx = 0;
831         address currOwnershipAddr = address(0);
832         for (uint256 i = 0; i < numMintedSoFar; i++) {
833             TokenOwnership memory ownership = _ownerships[i];
834             if (ownership.addr != address(0)) {
835                 currOwnershipAddr = ownership.addr;
836             }
837             if (currOwnershipAddr == owner) {
838                 if (tokenIdsIdx == index) {
839                     return i;
840                 }
841                 tokenIdsIdx++;
842             }
843         }
844         revert('ERC721A: unable to get token of owner by index');
845     }
846 
847     /**
848      * @dev See {IERC165-supportsInterface}.
849      */
850     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
851         return
852             interfaceId == type(IERC721).interfaceId ||
853             interfaceId == type(IERC721Metadata).interfaceId ||
854             interfaceId == type(IERC721Enumerable).interfaceId ||
855             super.supportsInterface(interfaceId);
856     }
857 
858     /**
859      * @dev See {IERC721-balanceOf}.
860      */
861     function balanceOf(address owner) public view override returns (uint256) {
862         require(owner != address(0), 'ERC721A: balance query for the zero address');
863         return uint256(_addressData[owner].balance);
864     }
865 
866     function _numberMinted(address owner) internal view returns (uint256) {
867         require(owner != address(0), 'ERC721A: number minted query for the zero address');
868         return uint256(_addressData[owner].numberMinted);
869     }
870 
871     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
872         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
873 
874         for (uint256 curr = tokenId; ; curr--) {
875             TokenOwnership memory ownership = _ownerships[curr];
876             if (ownership.addr != address(0)) {
877                 return ownership;
878             }
879         }
880 
881         revert('ERC721A: unable to determine the owner of token');
882     }
883 
884     /**
885      * @dev See {IERC721-ownerOf}.
886      */
887     function ownerOf(uint256 tokenId) public view override returns (address) {
888         return ownershipOf(tokenId).addr;
889     }
890 
891     /**
892      * @dev See {IERC721Metadata-name}.
893      */
894     function name() public view virtual override returns (string memory) {
895         return _name;
896     }
897 
898     /**
899      * @dev See {IERC721Metadata-symbol}.
900      */
901     function symbol() public view virtual override returns (string memory) {
902         return _symbol;
903     }
904 
905     /**
906      * @dev See {IERC721Metadata-tokenURI}.
907      */
908     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
909         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
910 
911         string memory baseURI = _baseURI();
912         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
913     }
914 
915     /**
916      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
917      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
918      * by default, can be overriden in child contracts.
919      */
920     function _baseURI() internal view virtual returns (string memory) {
921         return '';
922     }
923 
924     /**
925      * @dev See {IERC721-approve}.
926      */
927     function approve(address to, uint256 tokenId) public override {
928         address owner = ERC721A.ownerOf(tokenId);
929         require(to != owner, 'ERC721A: approval to current owner');
930 
931         require(
932             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
933             'ERC721A: approve caller is not owner nor approved for all'
934         );
935 
936         _approve(to, tokenId, owner);
937     }
938 
939     /**
940      * @dev See {IERC721-getApproved}.
941      */
942     function getApproved(uint256 tokenId) public view override returns (address) {
943         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
944 
945         return _tokenApprovals[tokenId];
946     }
947 
948     /**
949      * @dev See {IERC721-setApprovalForAll}.
950      */
951     function setApprovalForAll(address operator, bool approved) public override {
952         require(operator != _msgSender(), 'ERC721A: approve to caller');
953 
954         _operatorApprovals[_msgSender()][operator] = approved;
955         emit ApprovalForAll(_msgSender(), operator, approved);
956     }
957 
958     /**
959      * @dev See {IERC721-isApprovedForAll}.
960      */
961     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
962         return _operatorApprovals[owner][operator];
963     }
964 
965     /**
966      * @dev See {IERC721-transferFrom}.
967      */
968     function transferFrom(
969         address from,
970         address to,
971         uint256 tokenId
972     ) public override {
973         _transfer(from, to, tokenId);
974     }
975 
976     /**
977      * @dev See {IERC721-safeTransferFrom}.
978      */
979     function safeTransferFrom(
980         address from,
981         address to,
982         uint256 tokenId
983     ) public override {
984         safeTransferFrom(from, to, tokenId, '');
985     }
986 
987     /**
988      * @dev See {IERC721-safeTransferFrom}.
989      */
990     function safeTransferFrom(
991         address from,
992         address to,
993         uint256 tokenId,
994         bytes memory _data
995     ) public override {
996         _transfer(from, to, tokenId);
997         require(
998             _checkOnERC721Received(from, to, tokenId, _data),
999             'ERC721A: transfer to non ERC721Receiver implementer'
1000         );
1001     }
1002 
1003     /**
1004      * @dev Returns whether `tokenId` exists.
1005      *
1006      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1007      *
1008      * Tokens start existing when they are minted (`_mint`),
1009      */
1010     function _exists(uint256 tokenId) internal view returns (bool) {
1011         return tokenId < currentIndex;
1012     }
1013 
1014     function _safeMint(address to, uint256 quantity) internal {
1015         _safeMint(to, quantity, '');
1016     }
1017 
1018     /**
1019      * @dev Mints `quantity` tokens and transfers them to `to`.
1020      *
1021      * Requirements:
1022      *
1023      * - `to` cannot be the zero address.
1024      * - `quantity` cannot be larger than the max batch size.
1025      *
1026      * Emits a {Transfer} event.
1027      */
1028     function _safeMint(
1029         address to,
1030         uint256 quantity,
1031         bytes memory _data
1032     ) internal {
1033         uint256 startTokenId = currentIndex;
1034         require(to != address(0), 'ERC721A: mint to the zero address');
1035         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1036         require(!_exists(startTokenId), 'ERC721A: token already minted');
1037         require(quantity > 0, 'ERC721A: quantity must be greater 0');
1038 
1039         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1040 
1041         AddressData memory addressData = _addressData[to];
1042         _addressData[to] = AddressData(
1043             addressData.balance + uint128(quantity),
1044             addressData.numberMinted + uint128(quantity)
1045         );
1046         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1047 
1048         uint256 updatedIndex = startTokenId;
1049 
1050         for (uint256 i = 0; i < quantity; i++) {
1051             emit Transfer(address(0), to, updatedIndex);
1052             require(
1053                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1054                 'ERC721A: transfer to non ERC721Receiver implementer'
1055             );
1056             updatedIndex++;
1057         }
1058 
1059         currentIndex = updatedIndex;
1060         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1061     }
1062 
1063     /**
1064      * @dev Transfers `tokenId` from `from` to `to`.
1065      *
1066      * Requirements:
1067      *
1068      * - `to` cannot be the zero address.
1069      * - `tokenId` token must be owned by `from`.
1070      *
1071      * Emits a {Transfer} event.
1072      */
1073     function _transfer(
1074         address from,
1075         address to,
1076         uint256 tokenId
1077     ) private {
1078         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1079 
1080         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1081             getApproved(tokenId) == _msgSender() ||
1082             isApprovedForAll(prevOwnership.addr, _msgSender()));
1083 
1084         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1085 
1086         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1087         require(to != address(0), 'ERC721A: transfer to the zero address');
1088 
1089         _beforeTokenTransfers(from, to, tokenId, 1);
1090 
1091         // Clear approvals from the previous owner
1092         _approve(address(0), tokenId, prevOwnership.addr);
1093 
1094         // Underflow of the sender's balance is impossible because we check for
1095         // ownership above and the recipient's balance can't realistically overflow.
1096         unchecked {
1097             _addressData[from].balance -= 1;
1098             _addressData[to].balance += 1;
1099         }
1100 
1101         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1102 
1103         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1104         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1105         uint256 nextTokenId = tokenId + 1;
1106         if (_ownerships[nextTokenId].addr == address(0)) {
1107             if (_exists(nextTokenId)) {
1108                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1109             }
1110         }
1111 
1112         emit Transfer(from, to, tokenId);
1113         _afterTokenTransfers(from, to, tokenId, 1);
1114     }
1115 
1116     /**
1117      * @dev Approve `to` to operate on `tokenId`
1118      *
1119      * Emits a {Approval} event.
1120      */
1121     function _approve(
1122         address to,
1123         uint256 tokenId,
1124         address owner
1125     ) private {
1126         _tokenApprovals[tokenId] = to;
1127         emit Approval(owner, to, tokenId);
1128     }
1129 
1130     /**
1131      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1132      * The call is not executed if the target address is not a contract.
1133      *
1134      * @param from address representing the previous owner of the given token ID
1135      * @param to target address that will receive the tokens
1136      * @param tokenId uint256 ID of the token to be transferred
1137      * @param _data bytes optional data to send along with the call
1138      * @return bool whether the call correctly returned the expected magic value
1139      */
1140     function _checkOnERC721Received(
1141         address from,
1142         address to,
1143         uint256 tokenId,
1144         bytes memory _data
1145     ) private returns (bool) {
1146         if (to.isContract()) {
1147             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1148                 return retval == IERC721Receiver(to).onERC721Received.selector;
1149             } catch (bytes memory reason) {
1150                 if (reason.length == 0) {
1151                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1152                 } else {
1153                     assembly {
1154                         revert(add(32, reason), mload(reason))
1155                     }
1156                 }
1157             }
1158         } else {
1159             return true;
1160         }
1161     }
1162 
1163     /**
1164      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1165      *
1166      * startTokenId - the first token id to be transferred
1167      * quantity - the amount to be transferred
1168      *
1169      * Calling conditions:
1170      *
1171      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1172      * transferred to `to`.
1173      * - When `from` is zero, `tokenId` will be minted for `to`.
1174      */
1175     function _beforeTokenTransfers(
1176         address from,
1177         address to,
1178         uint256 startTokenId,
1179         uint256 quantity
1180     ) internal virtual {}
1181 
1182     /**
1183      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1184      * minting.
1185      *
1186      * startTokenId - the first token id to be transferred
1187      * quantity - the amount to be transferred
1188      *
1189      * Calling conditions:
1190      *
1191      * - when `from` and `to` are both non-zero.
1192      * - `from` and `to` are never both zero.
1193      */
1194     function _afterTokenTransfers(
1195         address from,
1196         address to,
1197         uint256 startTokenId,
1198         uint256 quantity
1199     ) internal virtual {}
1200 }
1201 
1202 
1203 // File contracts/MeemosWorld.sol
1204 
1205 
1206 /**
1207 $$\      $$\                                           $$\               $$\      $$\                     $$\       $$\
1208 $$$\    $$$ |                                          $  |              $$ | $\  $$ |                    $$ |      $$ |
1209 $$$$\  $$$$ | $$$$$$\   $$$$$$\  $$$$$$\$$$$\   $$$$$$\\_/$$$$$$$\       $$ |$$$\ $$ | $$$$$$\   $$$$$$\  $$ | $$$$$$$ |
1210 $$\$$\$$ $$ |$$  __$$\ $$  __$$\ $$  _$$  _$$\ $$  __$$\ $$  _____|      $$ $$ $$\$$ |$$  __$$\ $$  __$$\ $$ |$$  __$$ |
1211 $$ \$$$  $$ |$$$$$$$$ |$$$$$$$$ |$$ / $$ / $$ |$$ /  $$ |\$$$$$$\        $$$$  _$$$$ |$$ /  $$ |$$ |  \__|$$ |$$ /  $$ |
1212 $$ |\$  /$$ |$$   ____|$$   ____|$$ | $$ | $$ |$$ |  $$ | \____$$\       $$$  / \$$$ |$$ |  $$ |$$ |      $$ |$$ |  $$ |
1213 $$ | \_/ $$ |\$$$$$$$\ \$$$$$$$\ $$ | $$ | $$ |\$$$$$$  |$$$$$$$  |      $$  /   \$$ |\$$$$$$  |$$ |      $$ |\$$$$$$$ |
1214 \__|     \__| \_______| \_______|\__| \__| \__| \______/ \_______/       \__/     \__| \______/ \__|      \__| \_______|
1215 **/
1216 
1217 interface IERC20 {
1218     function balanceOf(address account) external view returns (uint256);
1219     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1220     function transfer(address recipient, uint256 amount) external returns (bool);
1221 }
1222 
1223 contract MeemosWorld is ERC721A, Ownable {
1224 
1225     string public baseURI = "ipfs://QmPy95f9sUv5DcMTy7koxQhDzWLzC2DnkvciJEx167oAws/";
1226     string public contractURI = "ipfs://QmYpYeFLYJzb96RmgvC6Qn8g1Mnh1Vn1NAw4rYUg77TeBo";
1227     string public constant baseExtension = ".json";
1228     bytes32 public merkleRoot = 0x1db1ef3dbf045e962d6d48a27c27b2797cc991082e2037021f68af3b5246f7b5;
1229     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1230     IERC20 public constant SOSContract = IERC20(0x3b484b82567a09e2588A13D54D032153f0c0aEe0);
1231 
1232     uint256 public MAX_SUPPLY = 6666;
1233 
1234     uint256 public constant MAX_PER_TX_WL = 2;
1235     uint256 public constant MAX_PER_TX_PUBLIC = 5;
1236     uint256 public constant MAX_PER_WALLET = 5;
1237     uint256 public price = 0.06 ether;
1238     uint256 public sos_price = 1000000000 ether;
1239     uint256 public DEVS_AIRDROP = 172;
1240 
1241     bool public whiteListSale = false;
1242     bool public publicSale = false;
1243 
1244     constructor() ERC721A("MeemosWorld", "MW") {}
1245 
1246     function mint(uint256 _amount, bool _mintWithEther) external payable {
1247         address _caller = _msgSender();
1248         require(publicSale == true && whiteListSale == false, "Public sale not active");
1249         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1250         require(_amount > 0, "No 0 mints");
1251         require(tx.origin == _caller, "No contracts");
1252         require(MAX_PER_TX_PUBLIC >= _amount , "Excess max per public tx");
1253         require(MAX_PER_WALLET >= _numberMinted(_caller) + _amount, "Max mints per wallet");
1254 
1255         if(_mintWithEther){
1256             require(_amount * price == msg.value, "Invalid funds provided");
1257         }else{
1258             require(SOSContract.transferFrom(_caller, address(this), _amount * sos_price), "Invalid sos funds provided");
1259         }
1260 
1261         _safeMint(_caller, _amount);
1262     }
1263 
1264     function whitelistMint(uint256 _amount, bool _mintWithEther, bytes32[] calldata _merkleProof) external payable {
1265         address _caller = _msgSender();
1266         require(whiteListSale == true, "Whitelist sale not active");
1267         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1268         require(_amount > 0, "No 0 mints");
1269         require(tx.origin == _caller, "No contracts");
1270         require(MAX_PER_TX_WL >= _amount , "Excess max per whitelist tx");
1271         require(MAX_PER_TX_WL >= _numberMinted(_caller) + _amount, "Max mints per whitelist wallet");
1272 
1273         if(_mintWithEther){
1274             require(_amount * price == msg.value, "Invalid funds provided");
1275         }else{
1276             require(SOSContract.transferFrom(_caller, address(this), _amount * sos_price), "Invalid sos funds provided");
1277         }
1278 
1279         bytes32 leaf = keccak256(abi.encodePacked(_caller));
1280         require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Invalid proof");
1281 
1282         _safeMint(_caller, _amount);
1283     }
1284 
1285     function reservedDevsMint(uint256 _amount, address _to) external onlyOwner {
1286         require(DEVS_AIRDROP >= _amount, "Exceeds airdrop for devs");
1287         DEVS_AIRDROP -= _amount;
1288         _safeMint(_to, _amount);
1289     }
1290 
1291     function isApprovedForAll(address owner, address operator)
1292         override
1293         public
1294         view
1295         returns (bool)
1296     {
1297         // Whitelist OpenSea proxy contract for easy trading.
1298         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1299         if (address(proxyRegistry.proxies(owner)) == operator) {
1300             return true;
1301         }
1302 
1303         return super.isApprovedForAll(owner, operator);
1304     }
1305 
1306     function withdraw() external onlyOwner {
1307         uint256 balance = address(this).balance;
1308         (bool success, ) = _msgSender().call{value: balance}("");
1309         require(success, "Failed to send");
1310     }
1311 
1312     function withdrawToken(IERC20 token) external onlyOwner {
1313         uint256 funds = token.balanceOf(address(this));
1314         require(funds > 0, "No balance token");
1315         token.transfer(_msgSender(), funds);
1316     }
1317 
1318     function reduceSupply(uint256 _MAX_SUPPLY) external onlyOwner {
1319         require(_MAX_SUPPLY >= totalSupply(), "Error reducing supply");
1320         MAX_SUPPLY = _MAX_SUPPLY;
1321     }
1322 
1323     function setRoot(bytes32 _merkleRoot) external onlyOwner {
1324         merkleRoot = _merkleRoot;
1325     }
1326 
1327     function setPublicSale(bool _state) external onlyOwner {
1328         publicSale = _state;
1329     }
1330 
1331     function setWhitelistSale(bool _state) external onlyOwner {
1332         whiteListSale = _state;
1333     }
1334 
1335     function setBaseURI(string memory baseURI_) external onlyOwner {
1336         baseURI = baseURI_;
1337     }
1338 
1339     function setContractURI(string memory _contractURI) external onlyOwner {
1340         contractURI = _contractURI;
1341     }
1342 
1343     function setPrice(uint256 _price) external onlyOwner {
1344         price = _price;
1345     }
1346 
1347     function setSOSPrice(uint256 _price) external onlyOwner {
1348         sos_price = _price;
1349     }
1350 
1351     function walletMints(address owner) public view returns(uint256) {
1352        return _numberMinted(owner);
1353     }
1354 
1355     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1356         require(_exists(_tokenId), "Token does not exist.");
1357         return bytes(baseURI).length > 0 ? string(
1358             abi.encodePacked(
1359               baseURI,
1360               Strings.toString(_tokenId),
1361               baseExtension
1362             )
1363         ) : "";
1364     }
1365 }
1366 
1367 contract OwnableDelegateProxy { }
1368 contract ProxyRegistry {
1369     mapping(address => OwnableDelegateProxy) public proxies;
1370 }