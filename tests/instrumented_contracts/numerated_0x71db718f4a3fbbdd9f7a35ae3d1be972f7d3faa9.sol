1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
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
16  *
17  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
18  * hashing, or use a hash function other than keccak256 for hashing leaves.
19  * This is because the concatenation of a sorted pair of internal nodes in
20  * the merkle tree could be reinterpreted as a leaf value.
21  */
22 library MerkleProof {
23     /**
24      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
25      * defined by `root`. For this, a `proof` must be provided, containing
26      * sibling hashes on the branch from the leaf to the root of the tree. Each
27      * pair of leaves and each pair of pre-images are assumed to be sorted.
28      */
29     function verify(
30         bytes32[] memory proof,
31         bytes32 root,
32         bytes32 leaf
33     ) internal pure returns (bool) {
34         return processProof(proof, leaf) == root;
35     }
36 
37     /**
38      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
39      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
40      * hash matches the root of the tree. When processing the proof, the pairs
41      * of leafs & pre-images are assumed to be sorted.
42      *
43      * _Available since v4.4._
44      */
45     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
46         bytes32 computedHash = leaf;
47         for (uint256 i = 0; i < proof.length; i++) {
48             bytes32 proofElement = proof[i];
49             if (computedHash <= proofElement) {
50                 // Hash(current computed hash + current element of the proof)
51                 computedHash = _efficientHash(computedHash, proofElement);
52             } else {
53                 // Hash(current element of the proof + current computed hash)
54                 computedHash = _efficientHash(proofElement, computedHash);
55             }
56         }
57         return computedHash;
58     }
59 
60     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
61         assembly {
62             mstore(0x00, a)
63             mstore(0x20, b)
64             value := keccak256(0x00, 0x40)
65         }
66     }
67 }
68 
69 // File: @openzeppelin/contracts/utils/Strings.sol
70 
71 
72 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev String operations.
78  */
79 library Strings {
80     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
81 
82     /**
83      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
84      */
85     function toString(uint256 value) internal pure returns (string memory) {
86         // Inspired by OraclizeAPI's implementation - MIT licence
87         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
88 
89         if (value == 0) {
90             return "0";
91         }
92         uint256 temp = value;
93         uint256 digits;
94         while (temp != 0) {
95             digits++;
96             temp /= 10;
97         }
98         bytes memory buffer = new bytes(digits);
99         while (value != 0) {
100             digits -= 1;
101             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
102             value /= 10;
103         }
104         return string(buffer);
105     }
106 
107     /**
108      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
109      */
110     function toHexString(uint256 value) internal pure returns (string memory) {
111         if (value == 0) {
112             return "0x00";
113         }
114         uint256 temp = value;
115         uint256 length = 0;
116         while (temp != 0) {
117             length++;
118             temp >>= 8;
119         }
120         return toHexString(value, length);
121     }
122 
123     /**
124      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
125      */
126     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
127         bytes memory buffer = new bytes(2 * length + 2);
128         buffer[0] = "0";
129         buffer[1] = "x";
130         for (uint256 i = 2 * length + 1; i > 1; --i) {
131             buffer[i] = _HEX_SYMBOLS[value & 0xf];
132             value >>= 4;
133         }
134         require(value == 0, "Strings: hex length insufficient");
135         return string(buffer);
136     }
137 }
138 
139 // File: @openzeppelin/contracts/utils/Context.sol
140 
141 
142 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
143 
144 pragma solidity ^0.8.0;
145 
146 /**
147  * @dev Provides information about the current execution context, including the
148  * sender of the transaction and its data. While these are generally available
149  * via msg.sender and msg.data, they should not be accessed in such a direct
150  * manner, since when dealing with meta-transactions the account sending and
151  * paying for execution may not be the actual sender (as far as an application
152  * is concerned).
153  *
154  * This contract is only required for intermediate, library-like contracts.
155  */
156 abstract contract Context {
157     function _msgSender() internal view virtual returns (address) {
158         return msg.sender;
159     }
160 
161     function _msgData() internal view virtual returns (bytes calldata) {
162         return msg.data;
163     }
164 }
165 
166 // File: @openzeppelin/contracts/access/Ownable.sol
167 
168 
169 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
170 
171 pragma solidity ^0.8.0;
172 
173 
174 /**
175  * @dev Contract module which provides a basic access control mechanism, where
176  * there is an account (an owner) that can be granted exclusive access to
177  * specific functions.
178  *
179  * By default, the owner account will be the one that deploys the contract. This
180  * can later be changed with {transferOwnership}.
181  *
182  * This module is used through inheritance. It will make available the modifier
183  * `onlyOwner`, which can be applied to your functions to restrict their use to
184  * the owner.
185  */
186 abstract contract Ownable is Context {
187     address private _owner;
188 
189     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
190 
191     /**
192      * @dev Initializes the contract setting the deployer as the initial owner.
193      */
194     constructor() {
195         _transferOwnership(_msgSender());
196     }
197 
198     /**
199      * @dev Returns the address of the current owner.
200      */
201     function owner() public view virtual returns (address) {
202         return _owner;
203     }
204 
205     /**
206      * @dev Throws if called by any account other than the owner.
207      */
208     modifier onlyOwner() {
209         require(owner() == _msgSender(), "Ownable: caller is not the owner");
210         _;
211     }
212 
213     /**
214      * @dev Leaves the contract without owner. It will not be possible to call
215      * `onlyOwner` functions anymore. Can only be called by the current owner.
216      *
217      * NOTE: Renouncing ownership will leave the contract without an owner,
218      * thereby removing any functionality that is only available to the owner.
219      */
220     function renounceOwnership() public virtual onlyOwner {
221         _transferOwnership(address(0));
222     }
223 
224     /**
225      * @dev Transfers ownership of the contract to a new account (`newOwner`).
226      * Can only be called by the current owner.
227      */
228     function transferOwnership(address newOwner) public virtual onlyOwner {
229         require(newOwner != address(0), "Ownable: new owner is the zero address");
230         _transferOwnership(newOwner);
231     }
232 
233     /**
234      * @dev Transfers ownership of the contract to a new account (`newOwner`).
235      * Internal function without access restriction.
236      */
237     function _transferOwnership(address newOwner) internal virtual {
238         address oldOwner = _owner;
239         _owner = newOwner;
240         emit OwnershipTransferred(oldOwner, newOwner);
241     }
242 }
243 
244 // File: @openzeppelin/contracts/utils/Address.sol
245 
246 
247 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
248 
249 pragma solidity ^0.8.1;
250 
251 /**
252  * @dev Collection of functions related to the address type
253  */
254 library Address {
255     /**
256      * @dev Returns true if `account` is a contract.
257      *
258      * [IMPORTANT]
259      * ====
260      * It is unsafe to assume that an address for which this function returns
261      * false is an externally-owned account (EOA) and not a contract.
262      *
263      * Among others, `isContract` will return false for the following
264      * types of addresses:
265      *
266      *  - an externally-owned account
267      *  - a contract in construction
268      *  - an address where a contract will be created
269      *  - an address where a contract lived, but was destroyed
270      * ====
271      *
272      * [IMPORTANT]
273      * ====
274      * You shouldn't rely on `isContract` to protect against flash loan attacks!
275      *
276      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
277      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
278      * constructor.
279      * ====
280      */
281     function isContract(address account) internal view returns (bool) {
282         // This method relies on extcodesize/address.code.length, which returns 0
283         // for contracts in construction, since the code is only stored at the end
284         // of the constructor execution.
285 
286         return account.code.length > 0;
287     }
288 
289     /**
290      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
291      * `recipient`, forwarding all available gas and reverting on errors.
292      *
293      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
294      * of certain opcodes, possibly making contracts go over the 2300 gas limit
295      * imposed by `transfer`, making them unable to receive funds via
296      * `transfer`. {sendValue} removes this limitation.
297      *
298      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
299      *
300      * IMPORTANT: because control is transferred to `recipient`, care must be
301      * taken to not create reentrancy vulnerabilities. Consider using
302      * {ReentrancyGuard} or the
303      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
304      */
305     function sendValue(address payable recipient, uint256 amount) internal {
306         require(address(this).balance >= amount, "Address: insufficient balance");
307 
308         (bool success, ) = recipient.call{value: amount}("");
309         require(success, "Address: unable to send value, recipient may have reverted");
310     }
311 
312     /**
313      * @dev Performs a Solidity function call using a low level `call`. A
314      * plain `call` is an unsafe replacement for a function call: use this
315      * function instead.
316      *
317      * If `target` reverts with a revert reason, it is bubbled up by this
318      * function (like regular Solidity function calls).
319      *
320      * Returns the raw returned data. To convert to the expected return value,
321      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
322      *
323      * Requirements:
324      *
325      * - `target` must be a contract.
326      * - calling `target` with `data` must not revert.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
331         return functionCall(target, data, "Address: low-level call failed");
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
336      * `errorMessage` as a fallback revert reason when `target` reverts.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(
341         address target,
342         bytes memory data,
343         string memory errorMessage
344     ) internal returns (bytes memory) {
345         return functionCallWithValue(target, data, 0, errorMessage);
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
350      * but also transferring `value` wei to `target`.
351      *
352      * Requirements:
353      *
354      * - the calling contract must have an ETH balance of at least `value`.
355      * - the called Solidity function must be `payable`.
356      *
357      * _Available since v3.1._
358      */
359     function functionCallWithValue(
360         address target,
361         bytes memory data,
362         uint256 value
363     ) internal returns (bytes memory) {
364         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
369      * with `errorMessage` as a fallback revert reason when `target` reverts.
370      *
371      * _Available since v3.1._
372      */
373     function functionCallWithValue(
374         address target,
375         bytes memory data,
376         uint256 value,
377         string memory errorMessage
378     ) internal returns (bytes memory) {
379         require(address(this).balance >= value, "Address: insufficient balance for call");
380         require(isContract(target), "Address: call to non-contract");
381 
382         (bool success, bytes memory returndata) = target.call{value: value}(data);
383         return verifyCallResult(success, returndata, errorMessage);
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
388      * but performing a static call.
389      *
390      * _Available since v3.3._
391      */
392     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
393         return functionStaticCall(target, data, "Address: low-level static call failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
398      * but performing a static call.
399      *
400      * _Available since v3.3._
401      */
402     function functionStaticCall(
403         address target,
404         bytes memory data,
405         string memory errorMessage
406     ) internal view returns (bytes memory) {
407         require(isContract(target), "Address: static call to non-contract");
408 
409         (bool success, bytes memory returndata) = target.staticcall(data);
410         return verifyCallResult(success, returndata, errorMessage);
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
415      * but performing a delegate call.
416      *
417      * _Available since v3.4._
418      */
419     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
420         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
425      * but performing a delegate call.
426      *
427      * _Available since v3.4._
428      */
429     function functionDelegateCall(
430         address target,
431         bytes memory data,
432         string memory errorMessage
433     ) internal returns (bytes memory) {
434         require(isContract(target), "Address: delegate call to non-contract");
435 
436         (bool success, bytes memory returndata) = target.delegatecall(data);
437         return verifyCallResult(success, returndata, errorMessage);
438     }
439 
440     /**
441      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
442      * revert reason using the provided one.
443      *
444      * _Available since v4.3._
445      */
446     function verifyCallResult(
447         bool success,
448         bytes memory returndata,
449         string memory errorMessage
450     ) internal pure returns (bytes memory) {
451         if (success) {
452             return returndata;
453         } else {
454             // Look for revert reason and bubble it up if present
455             if (returndata.length > 0) {
456                 // The easiest way to bubble the revert reason is using memory via assembly
457 
458                 assembly {
459                     let returndata_size := mload(returndata)
460                     revert(add(32, returndata), returndata_size)
461                 }
462             } else {
463                 revert(errorMessage);
464             }
465         }
466     }
467 }
468 
469 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
470 
471 
472 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
473 
474 pragma solidity ^0.8.0;
475 
476 /**
477  * @title ERC721 token receiver interface
478  * @dev Interface for any contract that wants to support safeTransfers
479  * from ERC721 asset contracts.
480  */
481 interface IERC721Receiver {
482     /**
483      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
484      * by `operator` from `from`, this function is called.
485      *
486      * It must return its Solidity selector to confirm the token transfer.
487      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
488      *
489      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
490      */
491     function onERC721Received(
492         address operator,
493         address from,
494         uint256 tokenId,
495         bytes calldata data
496     ) external returns (bytes4);
497 }
498 
499 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
500 
501 
502 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
503 
504 pragma solidity ^0.8.0;
505 
506 /**
507  * @dev Interface of the ERC165 standard, as defined in the
508  * https://eips.ethereum.org/EIPS/eip-165[EIP].
509  *
510  * Implementers can declare support of contract interfaces, which can then be
511  * queried by others ({ERC165Checker}).
512  *
513  * For an implementation, see {ERC165}.
514  */
515 interface IERC165 {
516     /**
517      * @dev Returns true if this contract implements the interface defined by
518      * `interfaceId`. See the corresponding
519      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
520      * to learn more about how these ids are created.
521      *
522      * This function call must use less than 30 000 gas.
523      */
524     function supportsInterface(bytes4 interfaceId) external view returns (bool);
525 }
526 
527 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
528 
529 
530 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
531 
532 pragma solidity ^0.8.0;
533 
534 
535 /**
536  * @dev Implementation of the {IERC165} interface.
537  *
538  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
539  * for the additional interface id that will be supported. For example:
540  *
541  * ```solidity
542  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
543  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
544  * }
545  * ```
546  *
547  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
548  */
549 abstract contract ERC165 is IERC165 {
550     /**
551      * @dev See {IERC165-supportsInterface}.
552      */
553     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
554         return interfaceId == type(IERC165).interfaceId;
555     }
556 }
557 
558 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
559 
560 
561 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 
566 /**
567  * @dev Required interface of an ERC721 compliant contract.
568  */
569 interface IERC721 is IERC165 {
570     /**
571      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
572      */
573     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
574 
575     /**
576      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
577      */
578     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
579 
580     /**
581      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
582      */
583     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
584 
585     /**
586      * @dev Returns the number of tokens in ``owner``'s account.
587      */
588     function balanceOf(address owner) external view returns (uint256 balance);
589 
590     /**
591      * @dev Returns the owner of the `tokenId` token.
592      *
593      * Requirements:
594      *
595      * - `tokenId` must exist.
596      */
597     function ownerOf(uint256 tokenId) external view returns (address owner);
598 
599     /**
600      * @dev Safely transfers `tokenId` token from `from` to `to`.
601      *
602      * Requirements:
603      *
604      * - `from` cannot be the zero address.
605      * - `to` cannot be the zero address.
606      * - `tokenId` token must exist and be owned by `from`.
607      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
608      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
609      *
610      * Emits a {Transfer} event.
611      */
612     function safeTransferFrom(
613         address from,
614         address to,
615         uint256 tokenId,
616         bytes calldata data
617     ) external;
618 
619     /**
620      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
621      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
622      *
623      * Requirements:
624      *
625      * - `from` cannot be the zero address.
626      * - `to` cannot be the zero address.
627      * - `tokenId` token must exist and be owned by `from`.
628      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
629      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
630      *
631      * Emits a {Transfer} event.
632      */
633     function safeTransferFrom(
634         address from,
635         address to,
636         uint256 tokenId
637     ) external;
638 
639     /**
640      * @dev Transfers `tokenId` token from `from` to `to`.
641      *
642      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
643      *
644      * Requirements:
645      *
646      * - `from` cannot be the zero address.
647      * - `to` cannot be the zero address.
648      * - `tokenId` token must be owned by `from`.
649      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
650      *
651      * Emits a {Transfer} event.
652      */
653     function transferFrom(
654         address from,
655         address to,
656         uint256 tokenId
657     ) external;
658 
659     /**
660      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
661      * The approval is cleared when the token is transferred.
662      *
663      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
664      *
665      * Requirements:
666      *
667      * - The caller must own the token or be an approved operator.
668      * - `tokenId` must exist.
669      *
670      * Emits an {Approval} event.
671      */
672     function approve(address to, uint256 tokenId) external;
673 
674     /**
675      * @dev Approve or remove `operator` as an operator for the caller.
676      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
677      *
678      * Requirements:
679      *
680      * - The `operator` cannot be the caller.
681      *
682      * Emits an {ApprovalForAll} event.
683      */
684     function setApprovalForAll(address operator, bool _approved) external;
685 
686     /**
687      * @dev Returns the account approved for `tokenId` token.
688      *
689      * Requirements:
690      *
691      * - `tokenId` must exist.
692      */
693     function getApproved(uint256 tokenId) external view returns (address operator);
694 
695     /**
696      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
697      *
698      * See {setApprovalForAll}
699      */
700     function isApprovedForAll(address owner, address operator) external view returns (bool);
701 }
702 
703 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
704 
705 
706 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
707 
708 pragma solidity ^0.8.0;
709 
710 
711 /**
712  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
713  * @dev See https://eips.ethereum.org/EIPS/eip-721
714  */
715 interface IERC721Enumerable is IERC721 {
716     /**
717      * @dev Returns the total amount of tokens stored by the contract.
718      */
719     function totalSupply() external view returns (uint256);
720 
721     /**
722      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
723      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
724      */
725     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
726 
727     /**
728      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
729      * Use along with {totalSupply} to enumerate all tokens.
730      */
731     function tokenByIndex(uint256 index) external view returns (uint256);
732 }
733 
734 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
735 
736 
737 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
738 
739 pragma solidity ^0.8.0;
740 
741 
742 /**
743  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
744  * @dev See https://eips.ethereum.org/EIPS/eip-721
745  */
746 interface IERC721Metadata is IERC721 {
747     /**
748      * @dev Returns the token collection name.
749      */
750     function name() external view returns (string memory);
751 
752     /**
753      * @dev Returns the token collection symbol.
754      */
755     function symbol() external view returns (string memory);
756 
757     /**
758      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
759      */
760     function tokenURI(uint256 tokenId) external view returns (string memory);
761 }
762 
763 // File: mintnft/ERC721A_v2.sol
764 
765 
766 // Creator: Chiru Labs
767 
768 pragma solidity ^0.8.4;
769 
770 
771 
772 
773 
774 
775 
776 
777 
778 error ApprovalCallerNotOwnerNorApproved();
779 error ApprovalQueryForNonexistentToken();
780 error ApproveToCaller();
781 error ApprovalToCurrentOwner();
782 error BalanceQueryForZeroAddress();
783 error MintedQueryForZeroAddress();
784 error MintToZeroAddress();
785 error MintZeroQuantity();
786 error OwnerIndexOutOfBounds();
787 error OwnerQueryForNonexistentToken();
788 error TokenIndexOutOfBounds();
789 error TransferCallerNotOwnerNorApproved();
790 error TransferFromIncorrectOwner();
791 error TransferToNonERC721ReceiverImplementer();
792 error TransferToZeroAddress();
793 error UnableDetermineTokenOwner();
794 error URIQueryForNonexistentToken();
795 
796 /**
797  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
798  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
799  *
800  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
801  *
802  * Does not support burning tokens to address(0).
803  *
804  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
805  */
806 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
807     using Address for address;
808     using Strings for uint256;
809 
810     struct TokenOwnership {
811         address addr;
812         uint64 startTimestamp;
813     }
814 
815     struct AddressData {
816         uint128 balance;
817         uint128 numberMinted;
818     }
819 
820     uint256 internal _currentIndex = 1;
821 
822     // Token name
823     string private _name;
824 
825     // Token symbol
826     string private _symbol;
827 
828     // Mapping from token ID to ownership details
829     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
830     mapping(uint256 => TokenOwnership) internal _ownerships;
831 
832     // Mapping owner address to address data
833     mapping(address => AddressData) private _addressData;
834 
835     // Mapping from token ID to approved address
836     mapping(uint256 => address) private _tokenApprovals;
837 
838     // Mapping from owner to operator approvals
839     mapping(address => mapping(address => bool)) private _operatorApprovals;
840 
841     constructor(string memory name_, string memory symbol_) {
842         _name = name_;
843         _symbol = symbol_;
844     }
845 
846     /**
847      * @dev See {IERC721Enumerable-totalSupply}.
848      */
849     function totalSupply() public view override returns (uint256) {
850         return _currentIndex - 1;
851     }
852 
853     /**
854      * @dev See {IERC721Enumerable-tokenByIndex}.
855      */
856     function tokenByIndex(uint256 index) public view override returns (uint256) {
857         if (index >= totalSupply()) revert TokenIndexOutOfBounds();
858         return index;
859     }
860 
861     /**
862      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
863      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
864      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
865      */
866     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
867         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
868         uint256 numMintedSoFar = totalSupply();
869         uint256 tokenIdsIdx;
870         address currOwnershipAddr;
871 
872         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
873         unchecked {
874             for (uint256 i; i < numMintedSoFar; i++) {
875                 TokenOwnership memory ownership = _ownerships[i];
876                 if (ownership.addr != address(0)) {
877                     currOwnershipAddr = ownership.addr;
878                 }
879                 if (currOwnershipAddr == owner) {
880                     if (tokenIdsIdx == index) {
881                         return i;
882                     }
883                     tokenIdsIdx++;
884                 }
885             }
886         }
887 
888         // Execution should never reach this point.
889         assert(false);
890     }
891 
892     /**
893      * @dev See {IERC165-supportsInterface}.
894      */
895     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
896         return
897             interfaceId == type(IERC721).interfaceId ||
898             interfaceId == type(IERC721Metadata).interfaceId ||
899             interfaceId == type(IERC721Enumerable).interfaceId ||
900             super.supportsInterface(interfaceId);
901     }
902 
903     /**
904      * @dev See {IERC721-balanceOf}.
905      */
906     function balanceOf(address owner) public view override returns (uint256) {
907         if (owner == address(0)) revert BalanceQueryForZeroAddress();
908         return uint256(_addressData[owner].balance);
909     }
910 
911     function _numberMinted(address owner) internal view returns (uint256) {
912         if (owner == address(0)) revert MintedQueryForZeroAddress();
913         return uint256(_addressData[owner].numberMinted);
914     }
915 
916     /**
917      * Gas spent here starts off proportional to the maximum mint batch size.
918      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
919      */
920     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
921         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
922 
923         unchecked {
924             for (uint256 curr = tokenId; curr >= 0; curr--) {
925                 TokenOwnership memory ownership = _ownerships[curr];
926                 if (ownership.addr != address(0)) {
927                     return ownership;
928                 }
929             }
930         }
931 
932         revert UnableDetermineTokenOwner();
933     }
934 
935     /**
936      * @dev See {IERC721-ownerOf}.
937      */
938     function ownerOf(uint256 tokenId) public view override returns (address) {
939         return ownershipOf(tokenId).addr;
940     }
941 
942     /**
943      * @dev See {IERC721Metadata-name}.
944      */
945     function name() public view virtual override returns (string memory) {
946         return _name;
947     }
948 
949     /**
950      * @dev See {IERC721Metadata-symbol}.
951      */
952     function symbol() public view virtual override returns (string memory) {
953         return _symbol;
954     }
955 
956     /**
957      * @dev See {IERC721Metadata-tokenURI}.
958      */
959     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
960         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
961 
962         string memory baseURI = _baseURI();
963         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
964     }
965 
966     /**
967      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
968      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
969      * by default, can be overriden in child contracts.
970      */
971     function _baseURI() internal view virtual returns (string memory) {
972         return '';
973     }
974 
975     /**
976      * @dev See {IERC721-approve}.
977      */
978     function approve(address to, uint256 tokenId) public override {
979         address owner = ERC721A.ownerOf(tokenId);
980         if (to == owner) revert ApprovalToCurrentOwner();
981 
982         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) revert ApprovalCallerNotOwnerNorApproved();
983 
984         _approve(to, tokenId, owner);
985     }
986 
987     /**
988      * @dev See {IERC721-getApproved}.
989      */
990     function getApproved(uint256 tokenId) public view override returns (address) {
991         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
992 
993         return _tokenApprovals[tokenId];
994     }
995 
996     /**
997      * @dev See {IERC721-setApprovalForAll}.
998      */
999     function setApprovalForAll(address operator, bool approved) public override {
1000         if (operator == _msgSender()) revert ApproveToCaller();
1001 
1002         _operatorApprovals[_msgSender()][operator] = approved;
1003         emit ApprovalForAll(_msgSender(), operator, approved);
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-isApprovedForAll}.
1008      */
1009     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1010         return _operatorApprovals[owner][operator];
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-transferFrom}.
1015      */
1016     function transferFrom(
1017         address from,
1018         address to,
1019         uint256 tokenId
1020     ) public virtual override {
1021         _transfer(from, to, tokenId);
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-safeTransferFrom}.
1026      */
1027     function safeTransferFrom(
1028         address from,
1029         address to,
1030         uint256 tokenId
1031     ) public virtual override {
1032         safeTransferFrom(from, to, tokenId, '');
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-safeTransferFrom}.
1037      */
1038     function safeTransferFrom(
1039         address from,
1040         address to,
1041         uint256 tokenId,
1042         bytes memory _data
1043     ) public override {
1044         _transfer(from, to, tokenId);
1045         if (!_checkOnERC721Received(from, to, tokenId, _data)) revert TransferToNonERC721ReceiverImplementer();
1046     }
1047 
1048     /**
1049      * @dev Returns whether `tokenId` exists.
1050      *
1051      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1052      *
1053      * Tokens start existing when they are minted (`_mint`),
1054      */
1055     function _exists(uint256 tokenId) internal view returns (bool) {
1056         return tokenId < _currentIndex;
1057     }
1058 
1059     function _safeMint(address to, uint256 quantity) internal {
1060         _safeMint(to, quantity, '');
1061     }
1062 
1063     /**
1064      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1065      *
1066      * Requirements:
1067      *
1068      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1069      * - `quantity` must be greater than 0.
1070      *
1071      * Emits a {Transfer} event.
1072      */
1073     function _safeMint(
1074         address to,
1075         uint256 quantity,
1076         bytes memory _data
1077     ) internal {
1078         _mint(to, quantity, _data, true);
1079     }
1080 
1081     /**
1082      * @dev Mints `quantity` tokens and transfers them to `to`.
1083      *
1084      * Requirements:
1085      *
1086      * - `to` cannot be the zero address.
1087      * - `quantity` must be greater than 0.
1088      *
1089      * Emits a {Transfer} event.
1090      */
1091     function _mint(
1092         address to,
1093         uint256 quantity,
1094         bytes memory _data,
1095         bool safe
1096     ) internal {
1097         uint256 startTokenId = _currentIndex;
1098         if (to == address(0)) revert MintToZeroAddress();
1099         if (quantity == 0) revert MintZeroQuantity();
1100 
1101         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1102 
1103         // Overflows are incredibly unrealistic.
1104         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1105         // updatedIndex overflows if _currentIndex + quantity > 1.56e77 (2**256) - 1
1106         unchecked {
1107             _addressData[to].balance += uint128(quantity);
1108             _addressData[to].numberMinted += uint128(quantity);
1109 
1110             _ownerships[startTokenId].addr = to;
1111             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1112 
1113             uint256 updatedIndex = startTokenId;
1114 
1115             for (uint256 i; i < quantity; i++) {
1116                 emit Transfer(address(0), to, updatedIndex);
1117                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1118                     revert TransferToNonERC721ReceiverImplementer();
1119                 }
1120 
1121                 updatedIndex++;
1122             }
1123 
1124             _currentIndex = updatedIndex;
1125         }
1126 
1127         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1128     }
1129 
1130     /**
1131      * @dev Transfers `tokenId` from `from` to `to`.
1132      *
1133      * Requirements:
1134      *
1135      * - `to` cannot be the zero address.
1136      * - `tokenId` token must be owned by `from`.
1137      *
1138      * Emits a {Transfer} event.
1139      */
1140     function _transfer(
1141         address from,
1142         address to,
1143         uint256 tokenId
1144     ) private {
1145         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1146 
1147         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1148             getApproved(tokenId) == _msgSender() ||
1149             isApprovedForAll(prevOwnership.addr, _msgSender()));
1150 
1151         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1152         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1153         if (to == address(0)) revert TransferToZeroAddress();
1154 
1155         _beforeTokenTransfers(from, to, tokenId, 1);
1156 
1157         // Clear approvals from the previous owner
1158         _approve(address(0), tokenId, prevOwnership.addr);
1159 
1160         // Underflow of the sender's balance is impossible because we check for
1161         // ownership above and the recipient's balance can't realistically overflow.
1162         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1163         unchecked {
1164             _addressData[from].balance -= 1;
1165             _addressData[to].balance += 1;
1166 
1167             _ownerships[tokenId].addr = to;
1168             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1169 
1170             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1171             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1172             uint256 nextTokenId = tokenId + 1;
1173             if (_ownerships[nextTokenId].addr == address(0)) {
1174                 if (_exists(nextTokenId)) {
1175                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1176                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1177                 }
1178             }
1179         }
1180 
1181         emit Transfer(from, to, tokenId);
1182         _afterTokenTransfers(from, to, tokenId, 1);
1183     }
1184 
1185     /**
1186      * @dev Approve `to` to operate on `tokenId`
1187      *
1188      * Emits a {Approval} event.
1189      */
1190     function _approve(
1191         address to,
1192         uint256 tokenId,
1193         address owner
1194     ) private {
1195         _tokenApprovals[tokenId] = to;
1196         emit Approval(owner, to, tokenId);
1197     }
1198 
1199     /**
1200      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1201      * The call is not executed if the target address is not a contract.
1202      *
1203      * @param from address representing the previous owner of the given token ID
1204      * @param to target address that will receive the tokens
1205      * @param tokenId uint256 ID of the token to be transferred
1206      * @param _data bytes optional data to send along with the call
1207      * @return bool whether the call correctly returned the expected magic value
1208      */
1209     function _checkOnERC721Received(
1210         address from,
1211         address to,
1212         uint256 tokenId,
1213         bytes memory _data
1214     ) private returns (bool) {
1215         if (to.isContract()) {
1216             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1217                 return retval == IERC721Receiver(to).onERC721Received.selector;
1218             } catch (bytes memory reason) {
1219                 if (reason.length == 0) revert TransferToNonERC721ReceiverImplementer();
1220                 else {
1221                     assembly {
1222                         revert(add(32, reason), mload(reason))
1223                     }
1224                 }
1225             }
1226         } else {
1227             return true;
1228         }
1229     }
1230 
1231     /**
1232      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1233      *
1234      * startTokenId - the first token id to be transferred
1235      * quantity - the amount to be transferred
1236      *
1237      * Calling conditions:
1238      *
1239      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1240      * transferred to `to`.
1241      * - When `from` is zero, `tokenId` will be minted for `to`.
1242      */
1243     function _beforeTokenTransfers(
1244         address from,
1245         address to,
1246         uint256 startTokenId,
1247         uint256 quantity
1248     ) internal virtual {}
1249 
1250     /**
1251      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1252      * minting.
1253      *
1254      * startTokenId - the first token id to be transferred
1255      * quantity - the amount to be transferred
1256      *
1257      * Calling conditions:
1258      *
1259      * - when `from` and `to` are both non-zero.
1260      * - `from` and `to` are never both zero.
1261      */
1262     function _afterTokenTransfers(
1263         address from,
1264         address to,
1265         uint256 startTokenId,
1266         uint256 quantity
1267     ) internal virtual {}
1268 }
1269 // File: mintnft/AdventureIsland_v2.sol
1270 
1271 
1272 pragma solidity ^0.8.0;
1273 
1274 
1275 
1276 
1277 contract AdventureIsland is ERC721A, Ownable{
1278     using Strings for uint256;
1279 
1280     uint256 public constant TOTAL_SUPPLY = 1534;
1281     uint256 public constant MAX_ALLOW_PUBLIC_MINT = 5;
1282     uint256 public constant MAX_ALLOW_WHITELIST_MINT = 5;
1283     uint256 public constant PUBLIC_ALLOW_SALE_PRICE = 0;
1284     uint256 public constant WHITELIST_ALLOW_SALE_PRICE = 0;
1285 
1286     string public baseTokenUri;
1287     string public placeholderTokenUri;
1288 
1289     //deploy smart contract, toggle WL, toggle WL when done, toggle publicSale 
1290     //2 days later toggle reveal
1291     bool public isRevealed;
1292     bool public publicSale;
1293     bool public whiteListSale;
1294     bool public teamMinted;
1295 
1296     bytes32 private merkleRoot;
1297 
1298     mapping(address => uint256) public totalPublicMint;
1299     mapping(address => uint256) public totalWhitelistMint;
1300 
1301     constructor() ERC721A("Adventure Island", "BNN"){
1302 
1303     }
1304 
1305     modifier callerIsUser() {
1306         require(tx.origin == msg.sender, "Adventure Island :: Cannot be called by a contract");
1307         _;
1308     }
1309 
1310     function mint(uint256 _quantity) external payable callerIsUser{
1311         require(publicSale, "Adventure Island : Not Yet Active.");
1312         require((totalSupply() + _quantity) <= TOTAL_SUPPLY, "Adventure Island : Beyond Max Supply");
1313         require(_quantity <= MAX_ALLOW_PUBLIC_MINT, "Adventure Island : Max mint is 5");
1314         require((totalPublicMint[msg.sender] +_quantity) <= MAX_ALLOW_PUBLIC_MINT, "Adventure Island : Already minted 3 NFTs!");
1315         require(msg.value >= (PUBLIC_ALLOW_SALE_PRICE * _quantity), "Adventure Island : Below ");
1316 
1317         totalPublicMint[msg.sender] += _quantity;
1318         _safeMint(msg.sender, _quantity);
1319     }
1320 
1321     function whitelistMint(bytes32[] memory _merkleProof, uint256 _quantity) external payable callerIsUser{
1322         //create leaf node
1323         bytes32 sender = keccak256(abi.encodePacked(msg.sender));
1324         require(MerkleProof.verify(_merkleProof, merkleRoot, sender), "Adventure Island : You are not whitelisted");
1325 
1326         require(whiteListSale, "Adventure Island : Minting is on Pause");
1327         require((totalSupply() + _quantity) <= TOTAL_SUPPLY, "Adventure Island : Cannot mint beyond max supply");
1328         require(_quantity <= MAX_ALLOW_WHITELIST_MINT, "Adventure Island : Max mint is 5");
1329         require((totalWhitelistMint[msg.sender] + _quantity) <= MAX_ALLOW_WHITELIST_MINT, "Adventure Island : Cannot mint beyond whitelist max mint!");
1330         require(msg.value >= (WHITELIST_ALLOW_SALE_PRICE * _quantity), "Adventure Island : Payment is below the price");
1331         
1332         totalWhitelistMint[msg.sender] += _quantity;
1333         _safeMint(msg.sender, _quantity);
1334     }
1335 
1336     function teamMint(uint256 _quantity) external onlyOwner{
1337         require(!teamMinted, "Adventure Island : Team already minted");
1338         teamMinted = true;
1339         _safeMint(msg.sender, _quantity);
1340     }
1341 
1342     function _baseURI() internal view virtual override returns (string memory) {
1343         return baseTokenUri;
1344     }
1345 
1346     //return uri for certain token
1347     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1348         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1349 
1350         uint256 trueId = tokenId;
1351 
1352         if(!isRevealed){
1353             return placeholderTokenUri;
1354         }
1355         //string memory baseURI = _baseURI();
1356         return bytes(baseTokenUri).length > 0 ? string(abi.encodePacked(baseTokenUri, trueId.toString(), ".json")) : "";
1357     }
1358 
1359     /// @dev walletOf() function shouldn't be called on-chain due to gas consumption
1360     function walletOf() external view returns(uint256[] memory){
1361         address _owner = msg.sender;
1362         uint256 numberOfOwnedNFT = balanceOf(_owner);
1363         uint256[] memory ownerIds = new uint256[](numberOfOwnedNFT);
1364 
1365         for(uint256 index = 0; index < numberOfOwnedNFT; index++){
1366             ownerIds[index] = tokenOfOwnerByIndex(_owner, index);
1367         }
1368 
1369         return ownerIds;
1370     }
1371 
1372     function setTokenUri(string memory _baseTokenUri) external onlyOwner{
1373         baseTokenUri = _baseTokenUri;
1374     }
1375     function setPlaceHolderUri(string memory _placeholderTokenUri) external onlyOwner{
1376         placeholderTokenUri = _placeholderTokenUri;
1377     }
1378 
1379     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner{
1380         merkleRoot = _merkleRoot;
1381     }
1382 
1383     function getMerkleRoot() external view returns (bytes32){
1384         return merkleRoot;
1385     }
1386 
1387     function toggleWhiteListSale() external onlyOwner{
1388         whiteListSale = !whiteListSale;
1389     }
1390 
1391     function togglePublicSale() external onlyOwner{
1392         publicSale = !publicSale;
1393     }
1394 
1395     function toggleReveal() external onlyOwner{
1396         isRevealed = !isRevealed;
1397     }
1398 
1399     function withdraw() external onlyOwner{
1400         // can split to percentage if needed
1401         payable(0x5A68ffd29a8617A527F6bBd21C39F3A7d8Ec77bf).transfer(address(this).balance);
1402     }
1403 }