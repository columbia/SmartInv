1 // File: pixelsaurus_flat.sol
2 
3 
4 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
5 
6 
7 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev These functions deal with verification of Merkle Trees proofs.
13  *
14  * The proofs can be generated using the JavaScript library
15  * https://github.com/miguelmota/merkletreejs[merkletreejs].
16  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
17  *
18  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
19  */
20 library MerkleProof {
21     /**
22      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
23      * defined by `root`. For this, a `proof` must be provided, containing
24      * sibling hashes on the branch from the leaf to the root of the tree. Each
25      * pair of leaves and each pair of pre-images are assumed to be sorted.
26      */
27     function verify(
28         bytes32[] memory proof,
29         bytes32 root,
30         bytes32 leaf
31     ) internal pure returns (bool) {
32         return processProof(proof, leaf) == root;
33     }
34 
35     /**
36      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
37      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
38      * hash matches the root of the tree. When processing the proof, the pairs
39      * of leafs & pre-images are assumed to be sorted.
40      *
41      * _Available since v4.4._
42      */
43     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
44         bytes32 computedHash = leaf;
45         for (uint256 i = 0; i < proof.length; i++) {
46             bytes32 proofElement = proof[i];
47             if (computedHash <= proofElement) {
48                 // Hash(current computed hash + current element of the proof)
49                 computedHash = _efficientHash(computedHash, proofElement);
50             } else {
51                 // Hash(current element of the proof + current computed hash)
52                 computedHash = _efficientHash(proofElement, computedHash);
53             }
54         }
55         return computedHash;
56     }
57 
58     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
59         assembly {
60             mstore(0x00, a)
61             mstore(0x20, b)
62             value := keccak256(0x00, 0x40)
63         }
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/Strings.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev String operations.
76  */
77 library Strings {
78     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
79 
80     /**
81      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
82      */
83     function toString(uint256 value) internal pure returns (string memory) {
84         // Inspired by OraclizeAPI's implementation - MIT licence
85         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
86 
87         if (value == 0) {
88             return "0";
89         }
90         uint256 temp = value;
91         uint256 digits;
92         while (temp != 0) {
93             digits++;
94             temp /= 10;
95         }
96         bytes memory buffer = new bytes(digits);
97         while (value != 0) {
98             digits -= 1;
99             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
100             value /= 10;
101         }
102         return string(buffer);
103     }
104 
105     /**
106      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
107      */
108     function toHexString(uint256 value) internal pure returns (string memory) {
109         if (value == 0) {
110             return "0x00";
111         }
112         uint256 temp = value;
113         uint256 length = 0;
114         while (temp != 0) {
115             length++;
116             temp >>= 8;
117         }
118         return toHexString(value, length);
119     }
120 
121     /**
122      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
123      */
124     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
125         bytes memory buffer = new bytes(2 * length + 2);
126         buffer[0] = "0";
127         buffer[1] = "x";
128         for (uint256 i = 2 * length + 1; i > 1; --i) {
129             buffer[i] = _HEX_SYMBOLS[value & 0xf];
130             value >>= 4;
131         }
132         require(value == 0, "Strings: hex length insufficient");
133         return string(buffer);
134     }
135 }
136 
137 // File: @openzeppelin/contracts/utils/Context.sol
138 
139 
140 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
141 
142 pragma solidity ^0.8.0;
143 
144 /**
145  * @dev Provides information about the current execution context, including the
146  * sender of the transaction and its data. While these are generally available
147  * via msg.sender and msg.data, they should not be accessed in such a direct
148  * manner, since when dealing with meta-transactions the account sending and
149  * paying for execution may not be the actual sender (as far as an application
150  * is concerned).
151  *
152  * This contract is only required for intermediate, library-like contracts.
153  */
154 abstract contract Context {
155     function _msgSender() internal view virtual returns (address) {
156         return msg.sender;
157     }
158 
159     function _msgData() internal view virtual returns (bytes calldata) {
160         return msg.data;
161     }
162 }
163 
164 // File: @openzeppelin/contracts/access/Ownable.sol
165 
166 
167 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
168 
169 pragma solidity ^0.8.0;
170 
171 
172 /**
173  * @dev Contract module which provides a basic access control mechanism, where
174  * there is an account (an owner) that can be granted exclusive access to
175  * specific functions.
176  *
177  * By default, the owner account will be the one that deploys the contract. This
178  * can later be changed with {transferOwnership}.
179  *
180  * This module is used through inheritance. It will make available the modifier
181  * `onlyOwner`, which can be applied to your functions to restrict their use to
182  * the owner.
183  */
184 abstract contract Ownable is Context {
185     address private _owner;
186 
187     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
188 
189     /**
190      * @dev Initializes the contract setting the deployer as the initial owner.
191      */
192     constructor() {
193         _transferOwnership(_msgSender());
194     }
195 
196     /**
197      * @dev Returns the address of the current owner.
198      */
199     function owner() public view virtual returns (address) {
200         return _owner;
201     }
202 
203     /**
204      * @dev Throws if called by any account other than the owner.
205      */
206     modifier onlyOwner() {
207         require(owner() == _msgSender(), "Ownable: caller is not the owner");
208         _;
209     }
210 
211     /**
212      * @dev Leaves the contract without owner. It will not be possible to call
213      * `onlyOwner` functions anymore. Can only be called by the current owner.
214      *
215      * NOTE: Renouncing ownership will leave the contract without an owner,
216      * thereby removing any functionality that is only available to the owner.
217      */
218     function renounceOwnership() public virtual onlyOwner {
219         _transferOwnership(address(0));
220     }
221 
222     /**
223      * @dev Transfers ownership of the contract to a new account (`newOwner`).
224      * Can only be called by the current owner.
225      */
226     function transferOwnership(address newOwner) public virtual onlyOwner {
227         require(newOwner != address(0), "Ownable: new owner is the zero address");
228         _transferOwnership(newOwner);
229     }
230 
231     /**
232      * @dev Transfers ownership of the contract to a new account (`newOwner`).
233      * Internal function without access restriction.
234      */
235     function _transferOwnership(address newOwner) internal virtual {
236         address oldOwner = _owner;
237         _owner = newOwner;
238         emit OwnershipTransferred(oldOwner, newOwner);
239     }
240 }
241 
242 // File: @openzeppelin/contracts/utils/Address.sol
243 
244 
245 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
246 
247 pragma solidity ^0.8.1;
248 
249 /**
250  * @dev Collection of functions related to the address type
251  */
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [IMPORTANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      *
270      * [IMPORTANT]
271      * ====
272      * You shouldn't rely on `isContract` to protect against flash loan attacks!
273      *
274      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
275      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
276      * constructor.
277      * ====
278      */
279     function isContract(address account) internal view returns (bool) {
280         // This method relies on extcodesize/address.code.length, which returns 0
281         // for contracts in construction, since the code is only stored at the end
282         // of the constructor execution.
283 
284         return account.code.length > 0;
285     }
286 
287     /**
288      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
289      * `recipient`, forwarding all available gas and reverting on errors.
290      *
291      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
292      * of certain opcodes, possibly making contracts go over the 2300 gas limit
293      * imposed by `transfer`, making them unable to receive funds via
294      * `transfer`. {sendValue} removes this limitation.
295      *
296      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
297      *
298      * IMPORTANT: because control is transferred to `recipient`, care must be
299      * taken to not create reentrancy vulnerabilities. Consider using
300      * {ReentrancyGuard} or the
301      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
302      */
303     function sendValue(address payable recipient, uint256 amount) internal {
304         require(address(this).balance >= amount, "Address: insufficient balance");
305 
306         (bool success, ) = recipient.call{value: amount}("");
307         require(success, "Address: unable to send value, recipient may have reverted");
308     }
309 
310     /**
311      * @dev Performs a Solidity function call using a low level `call`. A
312      * plain `call` is an unsafe replacement for a function call: use this
313      * function instead.
314      *
315      * If `target` reverts with a revert reason, it is bubbled up by this
316      * function (like regular Solidity function calls).
317      *
318      * Returns the raw returned data. To convert to the expected return value,
319      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
320      *
321      * Requirements:
322      *
323      * - `target` must be a contract.
324      * - calling `target` with `data` must not revert.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
329         return functionCall(target, data, "Address: low-level call failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
334      * `errorMessage` as a fallback revert reason when `target` reverts.
335      *
336      * _Available since v3.1._
337      */
338     function functionCall(
339         address target,
340         bytes memory data,
341         string memory errorMessage
342     ) internal returns (bytes memory) {
343         return functionCallWithValue(target, data, 0, errorMessage);
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
348      * but also transferring `value` wei to `target`.
349      *
350      * Requirements:
351      *
352      * - the calling contract must have an ETH balance of at least `value`.
353      * - the called Solidity function must be `payable`.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(
358         address target,
359         bytes memory data,
360         uint256 value
361     ) internal returns (bytes memory) {
362         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
367      * with `errorMessage` as a fallback revert reason when `target` reverts.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(
372         address target,
373         bytes memory data,
374         uint256 value,
375         string memory errorMessage
376     ) internal returns (bytes memory) {
377         require(address(this).balance >= value, "Address: insufficient balance for call");
378         require(isContract(target), "Address: call to non-contract");
379 
380         (bool success, bytes memory returndata) = target.call{value: value}(data);
381         return verifyCallResult(success, returndata, errorMessage);
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
386      * but performing a static call.
387      *
388      * _Available since v3.3._
389      */
390     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
391         return functionStaticCall(target, data, "Address: low-level static call failed");
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
396      * but performing a static call.
397      *
398      * _Available since v3.3._
399      */
400     function functionStaticCall(
401         address target,
402         bytes memory data,
403         string memory errorMessage
404     ) internal view returns (bytes memory) {
405         require(isContract(target), "Address: static call to non-contract");
406 
407         (bool success, bytes memory returndata) = target.staticcall(data);
408         return verifyCallResult(success, returndata, errorMessage);
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
413      * but performing a delegate call.
414      *
415      * _Available since v3.4._
416      */
417     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
418         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
423      * but performing a delegate call.
424      *
425      * _Available since v3.4._
426      */
427     function functionDelegateCall(
428         address target,
429         bytes memory data,
430         string memory errorMessage
431     ) internal returns (bytes memory) {
432         require(isContract(target), "Address: delegate call to non-contract");
433 
434         (bool success, bytes memory returndata) = target.delegatecall(data);
435         return verifyCallResult(success, returndata, errorMessage);
436     }
437 
438     /**
439      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
440      * revert reason using the provided one.
441      *
442      * _Available since v4.3._
443      */
444     function verifyCallResult(
445         bool success,
446         bytes memory returndata,
447         string memory errorMessage
448     ) internal pure returns (bytes memory) {
449         if (success) {
450             return returndata;
451         } else {
452             // Look for revert reason and bubble it up if present
453             if (returndata.length > 0) {
454                 // The easiest way to bubble the revert reason is using memory via assembly
455 
456                 assembly {
457                     let returndata_size := mload(returndata)
458                     revert(add(32, returndata), returndata_size)
459                 }
460             } else {
461                 revert(errorMessage);
462             }
463         }
464     }
465 }
466 
467 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
468 
469 
470 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
471 
472 pragma solidity ^0.8.0;
473 
474 /**
475  * @title ERC721 token receiver interface
476  * @dev Interface for any contract that wants to support safeTransfers
477  * from ERC721 asset contracts.
478  */
479 interface IERC721Receiver {
480     /**
481      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
482      * by `operator` from `from`, this function is called.
483      *
484      * It must return its Solidity selector to confirm the token transfer.
485      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
486      *
487      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
488      */
489     function onERC721Received(
490         address operator,
491         address from,
492         uint256 tokenId,
493         bytes calldata data
494     ) external returns (bytes4);
495 }
496 
497 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
498 
499 
500 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
501 
502 pragma solidity ^0.8.0;
503 
504 /**
505  * @dev Interface of the ERC165 standard, as defined in the
506  * https://eips.ethereum.org/EIPS/eip-165[EIP].
507  *
508  * Implementers can declare support of contract interfaces, which can then be
509  * queried by others ({ERC165Checker}).
510  *
511  * For an implementation, see {ERC165}.
512  */
513 interface IERC165 {
514     /**
515      * @dev Returns true if this contract implements the interface defined by
516      * `interfaceId`. See the corresponding
517      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
518      * to learn more about how these ids are created.
519      *
520      * This function call must use less than 30 000 gas.
521      */
522     function supportsInterface(bytes4 interfaceId) external view returns (bool);
523 }
524 
525 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
526 
527 
528 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
529 
530 pragma solidity ^0.8.0;
531 
532 
533 /**
534  * @dev Implementation of the {IERC165} interface.
535  *
536  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
537  * for the additional interface id that will be supported. For example:
538  *
539  * ```solidity
540  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
541  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
542  * }
543  * ```
544  *
545  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
546  */
547 abstract contract ERC165 is IERC165 {
548     /**
549      * @dev See {IERC165-supportsInterface}.
550      */
551     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
552         return interfaceId == type(IERC165).interfaceId;
553     }
554 }
555 
556 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
557 
558 
559 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
560 
561 pragma solidity ^0.8.0;
562 
563 
564 /**
565  * @dev Required interface of an ERC721 compliant contract.
566  */
567 interface IERC721 is IERC165 {
568     /**
569      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
570      */
571     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
572 
573     /**
574      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
575      */
576     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
577 
578     /**
579      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
580      */
581     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
582 
583     /**
584      * @dev Returns the number of tokens in ``owner``'s account.
585      */
586     function balanceOf(address owner) external view returns (uint256 balance);
587 
588     /**
589      * @dev Returns the owner of the `tokenId` token.
590      *
591      * Requirements:
592      *
593      * - `tokenId` must exist.
594      */
595     function ownerOf(uint256 tokenId) external view returns (address owner);
596 
597     /**
598      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
599      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
600      *
601      * Requirements:
602      *
603      * - `from` cannot be the zero address.
604      * - `to` cannot be the zero address.
605      * - `tokenId` token must exist and be owned by `from`.
606      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
607      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
608      *
609      * Emits a {Transfer} event.
610      */
611     function safeTransferFrom(
612         address from,
613         address to,
614         uint256 tokenId
615     ) external;
616 
617     /**
618      * @dev Transfers `tokenId` token from `from` to `to`.
619      *
620      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
621      *
622      * Requirements:
623      *
624      * - `from` cannot be the zero address.
625      * - `to` cannot be the zero address.
626      * - `tokenId` token must be owned by `from`.
627      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
628      *
629      * Emits a {Transfer} event.
630      */
631     function transferFrom(
632         address from,
633         address to,
634         uint256 tokenId
635     ) external;
636 
637     /**
638      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
639      * The approval is cleared when the token is transferred.
640      *
641      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
642      *
643      * Requirements:
644      *
645      * - The caller must own the token or be an approved operator.
646      * - `tokenId` must exist.
647      *
648      * Emits an {Approval} event.
649      */
650     function approve(address to, uint256 tokenId) external;
651 
652     /**
653      * @dev Returns the account approved for `tokenId` token.
654      *
655      * Requirements:
656      *
657      * - `tokenId` must exist.
658      */
659     function getApproved(uint256 tokenId) external view returns (address operator);
660 
661     /**
662      * @dev Approve or remove `operator` as an operator for the caller.
663      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
664      *
665      * Requirements:
666      *
667      * - The `operator` cannot be the caller.
668      *
669      * Emits an {ApprovalForAll} event.
670      */
671     function setApprovalForAll(address operator, bool _approved) external;
672 
673     /**
674      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
675      *
676      * See {setApprovalForAll}
677      */
678     function isApprovedForAll(address owner, address operator) external view returns (bool);
679 
680     /**
681      * @dev Safely transfers `tokenId` token from `from` to `to`.
682      *
683      * Requirements:
684      *
685      * - `from` cannot be the zero address.
686      * - `to` cannot be the zero address.
687      * - `tokenId` token must exist and be owned by `from`.
688      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
689      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
690      *
691      * Emits a {Transfer} event.
692      */
693     function safeTransferFrom(
694         address from,
695         address to,
696         uint256 tokenId,
697         bytes calldata data
698     ) external;
699 }
700 
701 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
702 
703 
704 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
705 
706 pragma solidity ^0.8.0;
707 
708 
709 /**
710  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
711  * @dev See https://eips.ethereum.org/EIPS/eip-721
712  */
713 interface IERC721Enumerable is IERC721 {
714     /**
715      * @dev Returns the total amount of tokens stored by the contract.
716      */
717     function totalSupply() external view returns (uint256);
718 
719     /**
720      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
721      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
722      */
723     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
724 
725     /**
726      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
727      * Use along with {totalSupply} to enumerate all tokens.
728      */
729     function tokenByIndex(uint256 index) external view returns (uint256);
730 }
731 
732 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
733 
734 
735 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
736 
737 pragma solidity ^0.8.0;
738 
739 
740 /**
741  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
742  * @dev See https://eips.ethereum.org/EIPS/eip-721
743  */
744 interface IERC721Metadata is IERC721 {
745     /**
746      * @dev Returns the token collection name.
747      */
748     function name() external view returns (string memory);
749 
750     /**
751      * @dev Returns the token collection symbol.
752      */
753     function symbol() external view returns (string memory);
754 
755     /**
756      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
757      */
758     function tokenURI(uint256 tokenId) external view returns (string memory);
759 }
760 
761 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
762 
763 
764 // Creator: Chiru Labs
765 
766 pragma solidity ^0.8.4;
767 
768 
769 
770 
771 
772 
773 
774 
775 
776 error ApprovalCallerNotOwnerNorApproved();
777 error ApprovalQueryForNonexistentToken();
778 error ApproveToCaller();
779 error ApprovalToCurrentOwner();
780 error BalanceQueryForZeroAddress();
781 error MintedQueryForZeroAddress();
782 error BurnedQueryForZeroAddress();
783 error AuxQueryForZeroAddress();
784 error MintToZeroAddress();
785 error MintZeroQuantity();
786 error OwnerIndexOutOfBounds();
787 error OwnerQueryForNonexistentToken();
788 error TokenIndexOutOfBounds();
789 error TransferCallerNotOwnerNorApproved();
790 error TransferFromIncorrectOwner();
791 error TransferToNonERC721ReceiverImplementer();
792 error TransferToZeroAddress();
793 error URIQueryForNonexistentToken();
794 
795 /**
796  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
797  * the Metadata extension. Built to optimize for lower gas during batch mints.
798  *
799  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
800  *
801  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
802  *
803  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
804  */
805 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
806     using Address for address;
807     using Strings for uint256;
808 
809     // Compiler will pack this into a single 256bit word.
810     struct TokenOwnership {
811         // The address of the owner.
812         address addr;
813         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
814         uint64 startTimestamp;
815         // Whether the token has been burned.
816         bool burned;
817     }
818 
819     // Compiler will pack this into a single 256bit word.
820     struct AddressData {
821         // Realistically, 2**64-1 is more than enough.
822         uint64 balance;
823         // Keeps track of mint count with minimal overhead for tokenomics.
824         uint64 numberMinted;
825         // Keeps track of burn count with minimal overhead for tokenomics.
826         uint64 numberBurned;
827         // For miscellaneous variable(s) pertaining to the address
828         // (e.g. number of whitelist mint slots used). 
829         // If there are multiple variables, please pack them into a uint64.
830         uint64 aux;
831     }
832 
833     // The tokenId of the next token to be minted.
834     uint256 internal _currentIndex;
835 
836     // The number of tokens burned.
837     uint256 internal _burnCounter;
838 
839     // Token name
840     string private _name;
841 
842     // Token symbol
843     string private _symbol;
844 
845     // Mapping from token ID to ownership details
846     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
847     mapping(uint256 => TokenOwnership) internal _ownerships;
848 
849     // Mapping owner address to address data
850     mapping(address => AddressData) private _addressData;
851 
852     // Mapping from token ID to approved address
853     mapping(uint256 => address) private _tokenApprovals;
854 
855     // Mapping from owner to operator approvals
856     mapping(address => mapping(address => bool)) private _operatorApprovals;
857 
858     constructor(string memory name_, string memory symbol_) {
859         _name = name_;
860         _symbol = symbol_;
861     }
862 
863     /**
864      * @dev See {IERC721Enumerable-totalSupply}.
865      */
866     function totalSupply() public view returns (uint256) {
867         // Counter underflow is impossible as _burnCounter cannot be incremented
868         // more than _currentIndex times
869         unchecked {
870             return _currentIndex - _burnCounter;    
871         }
872     }
873 
874     /**
875      * @dev See {IERC165-supportsInterface}.
876      */
877     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
878         return
879             interfaceId == type(IERC721).interfaceId ||
880             interfaceId == type(IERC721Metadata).interfaceId ||
881             super.supportsInterface(interfaceId);
882     }
883 
884     /**
885      * @dev See {IERC721-balanceOf}.
886      */
887     function balanceOf(address owner) public view override returns (uint256) {
888         if (owner == address(0)) revert BalanceQueryForZeroAddress();
889         return uint256(_addressData[owner].balance);
890     }
891 
892     /**
893      * Returns the number of tokens minted by `owner`.
894      */
895     function _numberMinted(address owner) internal view returns (uint256) {
896         if (owner == address(0)) revert MintedQueryForZeroAddress();
897         return uint256(_addressData[owner].numberMinted);
898     }
899 
900     /**
901      * Returns the number of tokens burned by or on behalf of `owner`.
902      */
903     function _numberBurned(address owner) internal view returns (uint256) {
904         if (owner == address(0)) revert BurnedQueryForZeroAddress();
905         return uint256(_addressData[owner].numberBurned);
906     }
907 
908     /**
909      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
910      */
911     function _getAux(address owner) internal view returns (uint64) {
912         if (owner == address(0)) revert AuxQueryForZeroAddress();
913         return _addressData[owner].aux;
914     }
915 
916     /**
917      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
918      * If there are multiple variables, please pack them into a uint64.
919      */
920     function _setAux(address owner, uint64 aux) internal {
921         if (owner == address(0)) revert AuxQueryForZeroAddress();
922         _addressData[owner].aux = aux;
923     }
924 
925     /**
926      * Gas spent here starts off proportional to the maximum mint batch size.
927      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
928      */
929     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
930         uint256 curr = tokenId;
931 
932         unchecked {
933             if (curr < _currentIndex) {
934                 TokenOwnership memory ownership = _ownerships[curr];
935                 if (!ownership.burned) {
936                     if (ownership.addr != address(0)) {
937                         return ownership;
938                     }
939                     // Invariant: 
940                     // There will always be an ownership that has an address and is not burned 
941                     // before an ownership that does not have an address and is not burned.
942                     // Hence, curr will not underflow.
943                     while (true) {
944                         curr--;
945                         ownership = _ownerships[curr];
946                         if (ownership.addr != address(0)) {
947                             return ownership;
948                         }
949                     }
950                 }
951             }
952         }
953         revert OwnerQueryForNonexistentToken();
954     }
955 
956     /**
957      * @dev See {IERC721-ownerOf}.
958      */
959     function ownerOf(uint256 tokenId) public view override returns (address) {
960         return ownershipOf(tokenId).addr;
961     }
962 
963     /**
964      * @dev See {IERC721Metadata-name}.
965      */
966     function name() public view virtual override returns (string memory) {
967         return _name;
968     }
969 
970     /**
971      * @dev See {IERC721Metadata-symbol}.
972      */
973     function symbol() public view virtual override returns (string memory) {
974         return _symbol;
975     }
976 
977     /**
978      * @dev See {IERC721Metadata-tokenURI}.
979      */
980     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
981         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
982 
983         string memory baseURI = _baseURI();
984         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
985     }
986 
987     /**
988      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
989      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
990      * by default, can be overriden in child contracts.
991      */
992     function _baseURI() internal view virtual returns (string memory) {
993         return '';
994     }
995 
996     /**
997      * @dev See {IERC721-approve}.
998      */
999     function approve(address to, uint256 tokenId) public override {
1000         address owner = ERC721A.ownerOf(tokenId);
1001         if (to == owner) revert ApprovalToCurrentOwner();
1002 
1003         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1004             revert ApprovalCallerNotOwnerNorApproved();
1005         }
1006 
1007         _approve(to, tokenId, owner);
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-getApproved}.
1012      */
1013     function getApproved(uint256 tokenId) public view override returns (address) {
1014         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1015 
1016         return _tokenApprovals[tokenId];
1017     }
1018 
1019     /**
1020      * @dev See {IERC721-setApprovalForAll}.
1021      */
1022     function setApprovalForAll(address operator, bool approved) public override {
1023         if (operator == _msgSender()) revert ApproveToCaller();
1024 
1025         _operatorApprovals[_msgSender()][operator] = approved;
1026         emit ApprovalForAll(_msgSender(), operator, approved);
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-isApprovedForAll}.
1031      */
1032     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1033         return _operatorApprovals[owner][operator];
1034     }
1035 
1036     /**
1037      * @dev See {IERC721-transferFrom}.
1038      */
1039     function transferFrom(
1040         address from,
1041         address to,
1042         uint256 tokenId
1043     ) public virtual override {
1044         _transfer(from, to, tokenId);
1045     }
1046 
1047     /**
1048      * @dev See {IERC721-safeTransferFrom}.
1049      */
1050     function safeTransferFrom(
1051         address from,
1052         address to,
1053         uint256 tokenId
1054     ) public virtual override {
1055         safeTransferFrom(from, to, tokenId, '');
1056     }
1057 
1058     /**
1059      * @dev See {IERC721-safeTransferFrom}.
1060      */
1061     function safeTransferFrom(
1062         address from,
1063         address to,
1064         uint256 tokenId,
1065         bytes memory _data
1066     ) public virtual override {
1067         _transfer(from, to, tokenId);
1068         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1069             revert TransferToNonERC721ReceiverImplementer();
1070         }
1071     }
1072 
1073     /**
1074      * @dev Returns whether `tokenId` exists.
1075      *
1076      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1077      *
1078      * Tokens start existing when they are minted (`_mint`),
1079      */
1080     function _exists(uint256 tokenId) internal view returns (bool) {
1081         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1082     }
1083 
1084     function _safeMint(address to, uint256 quantity) internal {
1085         _safeMint(to, quantity, '');
1086     }
1087 
1088     /**
1089      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1090      *
1091      * Requirements:
1092      *
1093      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1094      * - `quantity` must be greater than 0.
1095      *
1096      * Emits a {Transfer} event.
1097      */
1098     function _safeMint(
1099         address to,
1100         uint256 quantity,
1101         bytes memory _data
1102     ) internal {
1103         _mint(to, quantity, _data, true);
1104     }
1105 
1106     /**
1107      * @dev Mints `quantity` tokens and transfers them to `to`.
1108      *
1109      * Requirements:
1110      *
1111      * - `to` cannot be the zero address.
1112      * - `quantity` must be greater than 0.
1113      *
1114      * Emits a {Transfer} event.
1115      */
1116     function _mint(
1117         address to,
1118         uint256 quantity,
1119         bytes memory _data,
1120         bool safe
1121     ) internal {
1122         uint256 startTokenId = _currentIndex;
1123         if (to == address(0)) revert MintToZeroAddress();
1124         if (quantity == 0) revert MintZeroQuantity();
1125 
1126         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1127 
1128         // Overflows are incredibly unrealistic.
1129         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1130         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1131         unchecked {
1132             _addressData[to].balance += uint64(quantity);
1133             _addressData[to].numberMinted += uint64(quantity);
1134 
1135             _ownerships[startTokenId].addr = to;
1136             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1137 
1138             uint256 updatedIndex = startTokenId;
1139 
1140             for (uint256 i; i < quantity; i++) {
1141                 emit Transfer(address(0), to, updatedIndex);
1142                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1143                     revert TransferToNonERC721ReceiverImplementer();
1144                 }
1145                 updatedIndex++;
1146             }
1147 
1148             _currentIndex = updatedIndex;
1149         }
1150         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1151     }
1152 
1153     /**
1154      * @dev Transfers `tokenId` from `from` to `to`.
1155      *
1156      * Requirements:
1157      *
1158      * - `to` cannot be the zero address.
1159      * - `tokenId` token must be owned by `from`.
1160      *
1161      * Emits a {Transfer} event.
1162      */
1163     function _transfer(
1164         address from,
1165         address to,
1166         uint256 tokenId
1167     ) private {
1168         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1169 
1170         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1171             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1172             getApproved(tokenId) == _msgSender());
1173 
1174         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1175         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1176         if (to == address(0)) revert TransferToZeroAddress();
1177 
1178         _beforeTokenTransfers(from, to, tokenId, 1);
1179 
1180         // Clear approvals from the previous owner
1181         _approve(address(0), tokenId, prevOwnership.addr);
1182 
1183         // Underflow of the sender's balance is impossible because we check for
1184         // ownership above and the recipient's balance can't realistically overflow.
1185         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1186         unchecked {
1187             _addressData[from].balance -= 1;
1188             _addressData[to].balance += 1;
1189 
1190             _ownerships[tokenId].addr = to;
1191             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1192 
1193             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1194             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1195             uint256 nextTokenId = tokenId + 1;
1196             if (_ownerships[nextTokenId].addr == address(0)) {
1197                 // This will suffice for checking _exists(nextTokenId),
1198                 // as a burned slot cannot contain the zero address.
1199                 if (nextTokenId < _currentIndex) {
1200                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1201                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1202                 }
1203             }
1204         }
1205 
1206         emit Transfer(from, to, tokenId);
1207         _afterTokenTransfers(from, to, tokenId, 1);
1208     }
1209 
1210     /**
1211      * @dev Destroys `tokenId`.
1212      * The approval is cleared when the token is burned.
1213      *
1214      * Requirements:
1215      *
1216      * - `tokenId` must exist.
1217      *
1218      * Emits a {Transfer} event.
1219      */
1220     function _burn(uint256 tokenId) internal virtual {
1221         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1222 
1223         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1224 
1225         // Clear approvals from the previous owner
1226         _approve(address(0), tokenId, prevOwnership.addr);
1227 
1228         // Underflow of the sender's balance is impossible because we check for
1229         // ownership above and the recipient's balance can't realistically overflow.
1230         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1231         unchecked {
1232             _addressData[prevOwnership.addr].balance -= 1;
1233             _addressData[prevOwnership.addr].numberBurned += 1;
1234 
1235             // Keep track of who burned the token, and the timestamp of burning.
1236             _ownerships[tokenId].addr = prevOwnership.addr;
1237             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1238             _ownerships[tokenId].burned = true;
1239 
1240             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1241             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1242             uint256 nextTokenId = tokenId + 1;
1243             if (_ownerships[nextTokenId].addr == address(0)) {
1244                 // This will suffice for checking _exists(nextTokenId),
1245                 // as a burned slot cannot contain the zero address.
1246                 if (nextTokenId < _currentIndex) {
1247                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1248                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1249                 }
1250             }
1251         }
1252 
1253         emit Transfer(prevOwnership.addr, address(0), tokenId);
1254         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1255 
1256         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1257         unchecked { 
1258             _burnCounter++;
1259         }
1260     }
1261 
1262     /**
1263      * @dev Approve `to` to operate on `tokenId`
1264      *
1265      * Emits a {Approval} event.
1266      */
1267     function _approve(
1268         address to,
1269         uint256 tokenId,
1270         address owner
1271     ) private {
1272         _tokenApprovals[tokenId] = to;
1273         emit Approval(owner, to, tokenId);
1274     }
1275 
1276     /**
1277      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1278      * The call is not executed if the target address is not a contract.
1279      *
1280      * @param from address representing the previous owner of the given token ID
1281      * @param to target address that will receive the tokens
1282      * @param tokenId uint256 ID of the token to be transferred
1283      * @param _data bytes optional data to send along with the call
1284      * @return bool whether the call correctly returned the expected magic value
1285      */
1286     function _checkOnERC721Received(
1287         address from,
1288         address to,
1289         uint256 tokenId,
1290         bytes memory _data
1291     ) private returns (bool) {
1292         if (to.isContract()) {
1293             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1294                 return retval == IERC721Receiver(to).onERC721Received.selector;
1295             } catch (bytes memory reason) {
1296                 if (reason.length == 0) {
1297                     revert TransferToNonERC721ReceiverImplementer();
1298                 } else {
1299                     assembly {
1300                         revert(add(32, reason), mload(reason))
1301                     }
1302                 }
1303             }
1304         } else {
1305             return true;
1306         }
1307     }
1308 
1309     /**
1310      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1311      * And also called before burning one token.
1312      *
1313      * startTokenId - the first token id to be transferred
1314      * quantity - the amount to be transferred
1315      *
1316      * Calling conditions:
1317      *
1318      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1319      * transferred to `to`.
1320      * - When `from` is zero, `tokenId` will be minted for `to`.
1321      * - When `to` is zero, `tokenId` will be burned by `from`.
1322      * - `from` and `to` are never both zero.
1323      */
1324     function _beforeTokenTransfers(
1325         address from,
1326         address to,
1327         uint256 startTokenId,
1328         uint256 quantity
1329     ) internal virtual {}
1330 
1331     /**
1332      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1333      * minting.
1334      * And also called after one token has been burned.
1335      *
1336      * startTokenId - the first token id to be transferred
1337      * quantity - the amount to be transferred
1338      *
1339      * Calling conditions:
1340      *
1341      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1342      * transferred to `to`.
1343      * - When `from` is zero, `tokenId` has been minted for `to`.
1344      * - When `to` is zero, `tokenId` has been burned by `from`.
1345      * - `from` and `to` are never both zero.
1346      */
1347     function _afterTokenTransfers(
1348         address from,
1349         address to,
1350         uint256 startTokenId,
1351         uint256 quantity
1352     ) internal virtual {}
1353 }
1354 
1355 // File: contracts/pixelsaurus.sol
1356 
1357 
1358 pragma solidity ^0.8.7;
1359 
1360 /*
1361 
1362 ██████╗░██╗██╗░░██╗███████╗██╗░░░░░░██████╗░█████╗░██╗░░░██╗██████╗░██╗░░░██╗░██████╗
1363 ██╔══██╗██║╚██╗██╔╝██╔════╝██║░░░░░██╔════╝██╔══██╗██║░░░██║██╔══██╗██║░░░██║██╔════╝
1364 ██████╔╝██║░╚███╔╝░█████╗░░██║░░░░░╚█████╗░███████║██║░░░██║██████╔╝██║░░░██║╚█████╗░
1365 ██╔═══╝░██║░██╔██╗░██╔══╝░░██║░░░░░░╚═══██╗██╔══██║██║░░░██║██╔══██╗██║░░░██║░╚═══██╗
1366 ██║░░░░░██║██╔╝╚██╗███████╗███████╗██████╔╝██║░░██║╚██████╔╝██║░░██║╚██████╔╝██████╔╝
1367 ╚═╝░░░░░╚═╝╚═╝░░╚═╝╚══════╝╚══════╝╚═════╝░╚═╝░░╚═╝░╚═════╝░╚═╝░░╚═╝░╚═════╝░╚═════╝░
1368 
1369 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1370 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKkkkkkk0WMMMMMMMMMMMMMMMMMMMMMMMMMM
1371 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNl  ..  ,OXXXNWMMMMMMMMMMMMMMMMMMMMM
1372 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWWXc .dx,  ....lXWWWWWWMMMMMMMMMMMMMMM
1373 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWk:;,;,.  ',;:cccc::;;;;,,cKMMMMMMMMMMMMMM
1374 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWl. .;:.  ',,;;,;oxo;'. .:cllOWMMMMMMMMMMM
1375 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWl. .co' .od'  ',;clxo. ;KO' cNMMMMMMMMMMM
1376 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWl.  ..  .ld' 'O0; 'oo. ;KO' cNMMMMMMMMMMM
1377 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWl. .ok, .od' ,00; 'oo' ;0k' cNMMMMMMMMMMM
1378 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWl.  .'. .ld' ,00; 'oxlc;,.  cNMMMMMMMMMMM
1379 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWl. .;c. .ld' .;:;;cdxxxo:'. .:dXWOlcclOWM
1380 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWl. .co' .ld:''',lxoc:::lxd;'. .cdl;'  oWM
1381 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWd,'.   .'cldxxxxxx:. .':dxxd;  ..oXk. oWM
1382 MMMMMMMMMMMMMMMMMMMWNNNNNNNNNNNNNNNNNNNXKKd. :ko..;ddxxxx:..o0Oxxxx:..oO0Kx. oWM
1383 MMMMMMMMMMMMMMMMMMMO;'''''''''''''''''''''.  ...   .,oxxx:  .':dxxxol:,'.'.  oWM
1384 MMMMMMMMMMMMMMKoccc'       .,.    .,'      ',. .:c. .lxxd:    'oxxxxxdc;. .:d0WM
1385 MMMMMMMMMMMW0d:.    ..     ;o,    'oc.    .co' .cl. .ldddl,''':dxxxl:::;,.,lxKMM
1386 MMMMMMMMMNKk;     .'cc.  ..:o,   .,oc.  ..'lo;..  ..,:loddddlcoddlc'  ..;o:. oWM
1387 MMMMMMMWNk'      .:clc. .:lll,..;lloc. 'ccooool;. :Ol..:dddl' 'lc.   .;clo:. oWM
1388 MMMMMMWd'.        .'cl::cllllc::looolc:looooooo:. ...  ;oddl.  ..  .:;..;o:. oWM
1389 MMMMXo;.  .''''''',;cllllllllllllllooloooooooool;,,,,;,'....  .ol.  .,ld:',lxKWM
1390 MW0d:.    .';cccccccclllllllllllllllllllllloooooooooool. .:ccckWNxcccoXWOcdXMMMM
1391 MWo         .,;cccccccccccclllllllllllllllllllloooooooc. ;XMMMMMMMMMMMMMMMMMMMMM
1392 MWo           .;cccccccccccccccclllllllllllcclllllllloc. ;XMMMMMMMMMMMMMMMMMMMMM
1393 MWo    .,,;;;;;:ccccccccccccccccccccccllll:..,clllllllc. ;XMMMMMMMMMMMMMMMMMMMMM
1394 MWo     ..;ccccccccccccccccccccccccccccccc:;,.....;lllc. ;XMMMMMMMMMMMMMMMMMMMMM
1395 MWo     .';:,'..';cccccccccccccccccccccccc:,';c,  'cllc,.,ldKMMMMMMMMMMMMMMMMMMM
1396 MWo    .',,,,,,,,,,;:ccccc:;,,,,,,,,,,,,,,,,;kWk. 'cccclc, .ckKWMMMMMMMMMMMMMMMM
1397 MWo       ..dNWWXl..;;:ccc;.    ..........;0WNXd..,cccc::'.  .:0XWMMMMMMMMMMMMMM
1398 MWo      'xKNMMMWXKo..,ccc::;. .dKKKKKKKKKXNNo..,;:ccc:...;;;;,.,OMMMMMMMMMMMMMM
1399 MWo    ,x0NMMMMMMMMx. ':cccc:' .kMMMMMMMMMKl,,',:ccc;..  .:ccc' .kMMMMMMMMMMMMMM
1400 MW0ollo0WMMMMMMMWOl:'';ccc:,.,cdXMMMMMMMMMO. .:ccccc,  ,l:'...,cdKMMMMMMMMMMMMMM
1401 MMMMMMMMMMMMMMMMX: .;ccccc;. :NMMMMMMMMMMMO. .:cc:;',,:OM0c,;;xNMMMMMMMMMMMMMMMM
1402 MMMMMMMMMMMMMMMMNl..,;;;;;,. :NMMMMMMMMMMM0;.';;;;'.cKWMMMWWWWWMMMMMMMMMMMMMMMMM
1403 MMMMMMMMMMMMMMMMMNXd......   cNMMMMMMMMMMMWX0c....oKNWMMMMMMMMMMMMMMMMMMMMMMMMMM
1404 MMMMMMMMMMMMMMMMMMMNOkkkkkkkkKWMMMMMMMMMMMMMWKkkkOXMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1405 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1406 */
1407 
1408 
1409 
1410 
1411 contract PixelSaurus is ERC721A, Ownable {
1412     using Strings for uint256;
1413     event Minted(address indexed _from, uint _amount, uint _value);
1414 
1415     address extendingContract;
1416 
1417 
1418     string public baseApiURI;
1419     
1420      //Utility
1421     bool public paused = false;
1422     bool public whiteListingSale = true;
1423 
1424     //General Settings
1425     uint16 public maxMintAmountPerTransaction = 10;
1426     uint16 public maxMintAmountPerWallet = 500;
1427 
1428     
1429    
1430 
1431     //Inventory
1432     uint256 public maxSupply = 1100;
1433 
1434     //Prices
1435     uint256 public cost = 0.05 ether;
1436     //greenlist 1 cost
1437     uint256 public whitelistCost1 = 0.04 ether;
1438     //greenlist 2 cost 
1439     uint256 public whitelistCost2 = 0.05 ether;
1440 
1441     //Merkle Tree Roots
1442     bytes32 private whitelistRoot1;
1443     bytes32 private whitelistRoot2;
1444 
1445    
1446 
1447     
1448 
1449     constructor(string memory _baseUrl) ERC721A("PixelSaurus", "PXLS") {
1450         baseApiURI = _baseUrl;
1451     }
1452 
1453     //This function will be used to extend the project with more capabilities 
1454     function setExternalContract(address _bAddress) public onlyOwner {
1455         extendingContract = _bAddress;
1456     }
1457 
1458 
1459     //this function can be called only from the extending contract
1460     function mintExternal(address _address, uint256 _mintAmount) external {
1461         require(
1462             msg.sender == extendingContract,
1463             "Sorry you don't have permission to mint"
1464         );
1465         _safeMint(_address, _mintAmount);
1466     }
1467 
1468     function setWhitelistingRoot(bool iswWhitelist1, bytes32 _root) public onlyOwner {
1469        if(iswWhitelist1){
1470             whitelistRoot1 = _root;
1471        }else{
1472             whitelistRoot2 = _root;
1473        }
1474     }
1475 
1476    
1477 
1478  
1479     // Verify that a given leaf is in the tree.
1480     function _verify(
1481         bool isWhitelist1,
1482         bytes32 _leafNode,
1483         bytes32[] memory proof
1484     ) internal view returns (bool) {
1485        if(isWhitelist1){
1486             return MerkleProof.verify(proof, whitelistRoot1, _leafNode);
1487        }else{
1488             return MerkleProof.verify(proof, whitelistRoot2, _leafNode);
1489        }
1490     }
1491 
1492     // Generate the leaf node (just the hash of tokenID concatenated with the account address)
1493     function _leaf(address account) internal pure returns (bytes32) {
1494         return keccak256(abi.encodePacked(account));
1495     }
1496 
1497     //whitelist mint
1498     function mintWhitelist(
1499         bool isWhitelist1,
1500         bytes32[] calldata proof,
1501         uint256 _mintAmount
1502     ) public payable {
1503      
1504      
1505                 // WL Verifications
1506                 //1 
1507                  if(isWhitelist1){
1508                      require(
1509                     _verify(true,_leaf(msg.sender), proof),
1510                     "Invalid proof"
1511                 );
1512                
1513                 require(
1514                     msg.value >= (whitelistCost1 * _mintAmount),
1515                     "Insuffient funds"
1516                 );
1517                  }else{
1518                      require(
1519                     _verify(false, _leaf(msg.sender), proof),
1520                     "Invalid proof"
1521                 );
1522                 require(
1523                     msg.value >= (whitelistCost2 * _mintAmount),
1524                     "Insuffient funds"
1525                 );
1526 
1527                 
1528                  }
1529 
1530                 require(
1531                 _mintAmount <= maxMintAmountPerTransaction,
1532                 "Sorry you cannot mint this many at once!"
1533             );
1534 
1535                 //END WL Verifications
1536 
1537                 //Mint
1538                 _mintLoop(msg.sender, _mintAmount);
1539                  
1540 
1541                 emit Minted(msg.sender,  _mintAmount, msg.value);
1542              
1543     }
1544 
1545     function numberMinted(address owner) public view returns (uint256) {
1546         return _numberMinted(owner);
1547     }
1548 
1549     // public
1550     function mint(uint256 _mintAmount) public payable {
1551         if (msg.sender != owner()) {
1552             uint256 ownerTokenCount = balanceOf(msg.sender);
1553 
1554             require(!paused);
1555             require(!whiteListingSale, "You cant mint on Presale");
1556             require(_mintAmount > 0, "Mint amount should be greater than 0");
1557             require(
1558                 _mintAmount <= maxMintAmountPerTransaction,
1559                 "Sorry you cant mint this amount at once"
1560             );
1561             require(
1562                 totalSupply() + _mintAmount <= maxSupply,
1563                 "Exceeds Max Supply"
1564             );
1565             require(
1566                 (ownerTokenCount + _mintAmount) <= maxMintAmountPerWallet,
1567                 "Sorry you cant mint more"
1568             );
1569 
1570             require(msg.value >= cost * _mintAmount, "Insuffient funds");
1571         }
1572 
1573         _mintLoop(msg.sender, _mintAmount);
1574          emit Minted(msg.sender,  _mintAmount, msg.value);
1575     }
1576 
1577     function gift(address _to, uint256 _mintAmount) public onlyOwner {
1578         _mintLoop(_to, _mintAmount);
1579     }
1580 
1581     function airdrop(address[] memory _airdropAddresses) public onlyOwner {
1582         for (uint256 i = 0; i < _airdropAddresses.length; i++) {
1583             address to = _airdropAddresses[i];
1584             _mintLoop(to, 1);
1585         }
1586     }
1587 
1588     function _baseURI() internal view virtual override returns (string memory) {
1589         return baseApiURI;
1590     }
1591 
1592     function tokenURI(uint256 tokenId)
1593         public
1594         view
1595         virtual
1596         override
1597         returns (string memory)
1598     {
1599         require(
1600             _exists(tokenId),
1601             "ERC721Metadata: URI query for nonexistent token"
1602         );
1603         string memory currentBaseURI = _baseURI();
1604         return
1605             bytes(currentBaseURI).length > 0
1606                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
1607                 : "";
1608     }
1609 
1610     function setCost( uint256 _newCost) public onlyOwner {
1611         cost = _newCost;
1612     }
1613 
1614     function setWhitelistingCost(bool isWhitelist1, uint256 _newCost) public onlyOwner {
1615        if(isWhitelist1){
1616             whitelistCost1 = _newCost;
1617        }else{
1618             whitelistCost2 = _newCost;
1619        }
1620     }
1621 
1622     function setmaxMintAmountPerTransaction(uint16 _amount) public onlyOwner {
1623         maxMintAmountPerTransaction = _amount;
1624     }
1625 
1626     function setMaxMintAmountPerWallet(uint16 _amount) public onlyOwner {
1627         maxMintAmountPerWallet = _amount;
1628     }
1629 
1630   
1631 
1632     function setMaxSupply(uint256 _supply) public onlyOwner {
1633         maxSupply = _supply;
1634     }
1635 
1636     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1637         baseApiURI = _newBaseURI;
1638     }
1639 
1640     function togglePause() public onlyOwner {
1641         paused = !paused;
1642     }
1643 
1644     function toggleWhiteSale() public onlyOwner {
1645         whiteListingSale = !whiteListingSale;
1646     }
1647 
1648     function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1649         _safeMint(_receiver, _mintAmount);
1650     }
1651 
1652     function getOwnershipData(uint256 tokenId)
1653         external
1654         view
1655         returns (TokenOwnership memory)
1656     {
1657         return ownershipOf(tokenId);
1658     }
1659 
1660     function withdraw() public payable onlyOwner {
1661         (bool hq, ) = payable(owner()).call{value: address(this).balance}("");
1662         require(hq);
1663 
1664     }
1665 }