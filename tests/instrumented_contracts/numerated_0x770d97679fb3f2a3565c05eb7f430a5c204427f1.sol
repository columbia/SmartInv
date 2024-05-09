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
763 // File: contracts/ERC721A.sol
764 
765 
766 
767 pragma solidity ^0.8.0;
768 
769 
770 
771 
772 
773 
774 
775 
776 
777 /**
778  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
779  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
780  *
781  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
782  *
783  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
784  *
785  * Does not support burning tokens to address(0).
786  */
787 contract ERC721A is
788   Context,
789   ERC165,
790   IERC721,
791   IERC721Metadata,
792   IERC721Enumerable
793 {
794   using Address for address;
795   using Strings for uint256;
796 
797   struct TokenOwnership {
798     address addr;
799     uint64 startTimestamp;
800   }
801 
802   struct AddressData {
803     uint128 balance;
804     uint128 numberMinted;
805   }
806 
807   uint256 private currentIndex = 0;
808 
809   uint256 internal immutable collectionSize;
810   uint256 internal immutable maxBatchSize;
811 
812   // Token name
813   string private _name;
814 
815   // Token symbol
816   string private _symbol;
817 
818   // Mapping from token ID to ownership details
819   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
820   mapping(uint256 => TokenOwnership) private _ownerships;
821 
822   // Mapping owner address to address data
823   mapping(address => AddressData) private _addressData;
824 
825   // Mapping from token ID to approved address
826   mapping(uint256 => address) private _tokenApprovals;
827 
828   // Mapping from owner to operator approvals
829   mapping(address => mapping(address => bool)) private _operatorApprovals;
830 
831   /**
832    * @dev
833    * `maxBatchSize` refers to how much a minter can mint at a time.
834    * `collectionSize_` refers to how many tokens are in the collection.
835    */
836   constructor(
837     string memory name_,
838     string memory symbol_,
839     uint256 maxBatchSize_,
840     uint256 collectionSize_
841   ) {
842     require(
843       collectionSize_ > 0,
844       "ERC721A: collection must have a nonzero supply"
845     );
846     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
847     _name = name_;
848     _symbol = symbol_;
849     maxBatchSize = maxBatchSize_;
850     collectionSize = collectionSize_;
851   }
852 
853   /**
854    * @dev See {IERC721Enumerable-totalSupply}.
855    */
856   function totalSupply() public view override returns (uint256) {
857     return currentIndex;
858   }
859 
860   /**
861    * @dev See {IERC721Enumerable-tokenByIndex}.
862    */
863   function tokenByIndex(uint256 index) public view override returns (uint256) {
864     require(index < totalSupply(), "ERC721A: global index out of bounds");
865     return index;
866   }
867 
868   /**
869    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
870    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
871    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
872    */
873   function tokenOfOwnerByIndex(address owner, uint256 index)
874     public
875     view
876     override
877     returns (uint256)
878   {
879     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
880     uint256 numMintedSoFar = totalSupply();
881     uint256 tokenIdsIdx = 0;
882     address currOwnershipAddr = address(0);
883     for (uint256 i = 0; i < numMintedSoFar; i++) {
884       TokenOwnership memory ownership = _ownerships[i];
885       if (ownership.addr != address(0)) {
886         currOwnershipAddr = ownership.addr;
887       }
888       if (currOwnershipAddr == owner) {
889         if (tokenIdsIdx == index) {
890           return i;
891         }
892         tokenIdsIdx++;
893       }
894     }
895     revert("ERC721A: unable to get token of owner by index");
896   }
897 
898   /**
899    * @dev See {IERC165-supportsInterface}.
900    */
901   function supportsInterface(bytes4 interfaceId)
902     public
903     view
904     virtual
905     override(ERC165, IERC165)
906     returns (bool)
907   {
908     return
909       interfaceId == type(IERC721).interfaceId ||
910       interfaceId == type(IERC721Metadata).interfaceId ||
911       interfaceId == type(IERC721Enumerable).interfaceId ||
912       super.supportsInterface(interfaceId);
913   }
914 
915   /**
916    * @dev See {IERC721-balanceOf}.
917    */
918   function balanceOf(address owner) public view override returns (uint256) {
919     require(owner != address(0), "ERC721A: balance query for the zero address");
920     return uint256(_addressData[owner].balance);
921   }
922 
923   function _numberMinted(address owner) internal view returns (uint256) {
924     require(
925       owner != address(0),
926       "ERC721A: number minted query for the zero address"
927     );
928     return uint256(_addressData[owner].numberMinted);
929   }
930 
931   function ownershipOf(uint256 tokenId)
932     internal
933     view
934     returns (TokenOwnership memory)
935   {
936     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
937 
938     uint256 lowestTokenToCheck;
939     if (tokenId >= maxBatchSize) {
940       lowestTokenToCheck = tokenId - maxBatchSize + 1;
941     }
942 
943     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
944       TokenOwnership memory ownership = _ownerships[curr];
945       if (ownership.addr != address(0)) {
946         return ownership;
947       }
948     }
949 
950     revert("ERC721A: unable to determine the owner of token");
951   }
952 
953   /**
954    * @dev See {IERC721-ownerOf}.
955    */
956   function ownerOf(uint256 tokenId) public view override returns (address) {
957     return ownershipOf(tokenId).addr;
958   }
959 
960   /**
961    * @dev See {IERC721Metadata-name}.
962    */
963   function name() public view virtual override returns (string memory) {
964     return _name;
965   }
966 
967   /**
968    * @dev See {IERC721Metadata-symbol}.
969    */
970   function symbol() public view virtual override returns (string memory) {
971     return _symbol;
972   }
973 
974   /**
975    * @dev See {IERC721Metadata-tokenURI}.
976    */
977   function tokenURI(uint256 tokenId)
978     public
979     view
980     virtual
981     override
982     returns (string memory)
983   {
984     require(
985       _exists(tokenId),
986       "ERC721Metadata: URI query for nonexistent token"
987     );
988 
989     string memory baseURI = _baseURI();
990     return
991       bytes(baseURI).length > 0
992         ? string(abi.encodePacked(baseURI, tokenId.toString()))
993         : "";
994   }
995 
996   /**
997    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
998    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
999    * by default, can be overriden in child contracts.
1000    */
1001   function _baseURI() internal view virtual returns (string memory) {
1002     return "";
1003   }
1004 
1005   /**
1006    * @dev See {IERC721-approve}.
1007    */
1008   function approve(address to, uint256 tokenId) public override {
1009     address owner = ERC721A.ownerOf(tokenId);
1010     require(to != owner, "ERC721A: approval to current owner");
1011 
1012     require(
1013       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1014       "ERC721A: approve caller is not owner nor approved for all"
1015     );
1016 
1017     _approve(to, tokenId, owner);
1018   }
1019 
1020   /**
1021    * @dev See {IERC721-getApproved}.
1022    */
1023   function getApproved(uint256 tokenId) public view override returns (address) {
1024     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1025 
1026     return _tokenApprovals[tokenId];
1027   }
1028 
1029   /**
1030    * @dev See {IERC721-setApprovalForAll}.
1031    */
1032   function setApprovalForAll(address operator, bool approved) public override {
1033     require(operator != _msgSender(), "ERC721A: approve to caller");
1034 
1035     _operatorApprovals[_msgSender()][operator] = approved;
1036     emit ApprovalForAll(_msgSender(), operator, approved);
1037   }
1038 
1039   /**
1040    * @dev See {IERC721-isApprovedForAll}.
1041    */
1042   function isApprovedForAll(address owner, address operator)
1043     public
1044     view
1045     virtual
1046     override
1047     returns (bool)
1048   {
1049     return _operatorApprovals[owner][operator];
1050   }
1051 
1052   /**
1053    * @dev See {IERC721-transferFrom}.
1054    */
1055   function transferFrom(
1056     address from,
1057     address to,
1058     uint256 tokenId
1059   ) public override {
1060     _transfer(from, to, tokenId);
1061   }
1062 
1063   /**
1064    * @dev See {IERC721-safeTransferFrom}.
1065    */
1066   function safeTransferFrom(
1067     address from,
1068     address to,
1069     uint256 tokenId
1070   ) public override {
1071     safeTransferFrom(from, to, tokenId, "");
1072   }
1073 
1074   /**
1075    * @dev See {IERC721-safeTransferFrom}.
1076    */
1077   function safeTransferFrom(
1078     address from,
1079     address to,
1080     uint256 tokenId,
1081     bytes memory _data
1082   ) public override {
1083     _transfer(from, to, tokenId);
1084     require(
1085       _checkOnERC721Received(from, to, tokenId, _data),
1086       "ERC721A: transfer to non ERC721Receiver implementer"
1087     );
1088   }
1089 
1090   /**
1091    * @dev Returns whether `tokenId` exists.
1092    *
1093    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1094    *
1095    * Tokens start existing when they are minted (`_mint`),
1096    */
1097   function _exists(uint256 tokenId) internal view returns (bool) {
1098     return tokenId < currentIndex;
1099   }
1100 
1101   function _safeMint(address to, uint256 quantity) internal {
1102     _safeMint(to, quantity, "");
1103   }
1104 
1105   /**
1106    * @dev Mints `quantity` tokens and transfers them to `to`.
1107    *
1108    * Requirements:
1109    *
1110    * - there must be `quantity` tokens remaining unminted in the total collection.
1111    * - `to` cannot be the zero address.
1112    * - `quantity` cannot be larger than the max batch size.
1113    *
1114    * Emits a {Transfer} event.
1115    */
1116   function _safeMint(
1117     address to,
1118     uint256 quantity,
1119     bytes memory _data
1120   ) internal {
1121     uint256 startTokenId = currentIndex;
1122     require(to != address(0), "ERC721A: mint to the zero address");
1123     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1124     require(!_exists(startTokenId), "ERC721A: token already minted");
1125     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1126 
1127     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1128 
1129     AddressData memory addressData = _addressData[to];
1130     _addressData[to] = AddressData(
1131       addressData.balance + uint128(quantity),
1132       addressData.numberMinted + uint128(quantity)
1133     );
1134     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1135 
1136     uint256 updatedIndex = startTokenId;
1137 
1138     for (uint256 i = 0; i < quantity; i++) {
1139       emit Transfer(address(0), to, updatedIndex);
1140       require(
1141         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1142         "ERC721A: transfer to non ERC721Receiver implementer"
1143       );
1144       updatedIndex++;
1145     }
1146 
1147     currentIndex = updatedIndex;
1148     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1149   }
1150 
1151   /**
1152    * @dev Transfers `tokenId` from `from` to `to`.
1153    *
1154    * Requirements:
1155    *
1156    * - `to` cannot be the zero address.
1157    * - `tokenId` token must be owned by `from`.
1158    *
1159    * Emits a {Transfer} event.
1160    */
1161   function _transfer(
1162     address from,
1163     address to,
1164     uint256 tokenId
1165   ) private {
1166     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1167 
1168     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1169       getApproved(tokenId) == _msgSender() ||
1170       isApprovedForAll(prevOwnership.addr, _msgSender()));
1171 
1172     require(
1173       isApprovedOrOwner,
1174       "ERC721A: transfer caller is not owner nor approved"
1175     );
1176 
1177     require(
1178       prevOwnership.addr == from,
1179       "ERC721A: transfer from incorrect owner"
1180     );
1181     require(to != address(0), "ERC721A: transfer to the zero address");
1182 
1183     _beforeTokenTransfers(from, to, tokenId, 1);
1184 
1185     // Clear approvals from the previous owner
1186     _approve(address(0), tokenId, prevOwnership.addr);
1187 
1188     _addressData[from].balance -= 1;
1189     _addressData[to].balance += 1;
1190     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1191 
1192     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1193     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1194     uint256 nextTokenId = tokenId + 1;
1195     if (_ownerships[nextTokenId].addr == address(0)) {
1196       if (_exists(nextTokenId)) {
1197         _ownerships[nextTokenId] = TokenOwnership(
1198           prevOwnership.addr,
1199           prevOwnership.startTimestamp
1200         );
1201       }
1202     }
1203 
1204     emit Transfer(from, to, tokenId);
1205     _afterTokenTransfers(from, to, tokenId, 1);
1206   }
1207 
1208   /**
1209    * @dev Approve `to` to operate on `tokenId`
1210    *
1211    * Emits a {Approval} event.
1212    */
1213   function _approve(
1214     address to,
1215     uint256 tokenId,
1216     address owner
1217   ) private {
1218     _tokenApprovals[tokenId] = to;
1219     emit Approval(owner, to, tokenId);
1220   }
1221 
1222   uint256 public nextOwnerToExplicitlySet = 0;
1223 
1224   /**
1225    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1226    */
1227   function _setOwnersExplicit(uint256 quantity) internal {
1228     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1229     require(quantity > 0, "quantity must be nonzero");
1230     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1231     if (endIndex > collectionSize - 1) {
1232       endIndex = collectionSize - 1;
1233     }
1234     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1235     require(_exists(endIndex), "not enough minted yet for this cleanup");
1236     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1237       if (_ownerships[i].addr == address(0)) {
1238         TokenOwnership memory ownership = ownershipOf(i);
1239         _ownerships[i] = TokenOwnership(
1240           ownership.addr,
1241           ownership.startTimestamp
1242         );
1243       }
1244     }
1245     nextOwnerToExplicitlySet = endIndex + 1;
1246   }
1247 
1248   /**
1249    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1250    * The call is not executed if the target address is not a contract.
1251    *
1252    * @param from address representing the previous owner of the given token ID
1253    * @param to target address that will receive the tokens
1254    * @param tokenId uint256 ID of the token to be transferred
1255    * @param _data bytes optional data to send along with the call
1256    * @return bool whether the call correctly returned the expected magic value
1257    */
1258   function _checkOnERC721Received(
1259     address from,
1260     address to,
1261     uint256 tokenId,
1262     bytes memory _data
1263   ) private returns (bool) {
1264     if (to.isContract()) {
1265       try
1266         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1267       returns (bytes4 retval) {
1268         return retval == IERC721Receiver(to).onERC721Received.selector;
1269       } catch (bytes memory reason) {
1270         if (reason.length == 0) {
1271           revert("ERC721A: transfer to non ERC721Receiver implementer");
1272         } else {
1273           assembly {
1274             revert(add(32, reason), mload(reason))
1275           }
1276         }
1277       }
1278     } else {
1279       return true;
1280     }
1281   }
1282 
1283   /**
1284    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1285    *
1286    * startTokenId - the first token id to be transferred
1287    * quantity - the amount to be transferred
1288    *
1289    * Calling conditions:
1290    *
1291    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1292    * transferred to `to`.
1293    * - When `from` is zero, `tokenId` will be minted for `to`.
1294    */
1295   function _beforeTokenTransfers(
1296     address from,
1297     address to,
1298     uint256 startTokenId,
1299     uint256 quantity
1300   ) internal virtual {}
1301 
1302   /**
1303    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1304    * minting.
1305    *
1306    * startTokenId - the first token id to be transferred
1307    * quantity - the amount to be transferred
1308    *
1309    * Calling conditions:
1310    *
1311    * - when `from` and `to` are both non-zero.
1312    * - `from` and `to` are never both zero.
1313    */
1314   function _afterTokenTransfers(
1315     address from,
1316     address to,
1317     uint256 startTokenId,
1318     uint256 quantity
1319   ) internal virtual {}
1320 }
1321 // File: contracts/Yomazuka.sol
1322 
1323 
1324 pragma solidity ^0.8.4;
1325 
1326 
1327 
1328 
1329 contract YomazukaFamily is ERC721A, Ownable {
1330   using Strings for uint256;
1331 
1332   uint256 public constant MAX_SUPPLY = 9999;
1333   uint256 public constant MAX_PUBLIC_MINT = 5;
1334   uint256 public constant MAX_WHITELIST_MINT = 5;
1335   uint256 public PUBLIC_SALE_PRICE = 99000000000000000;
1336   uint256 public WHITELIST_SALE_PRICE = 99000000000000000;
1337 
1338   string private baseTokenUri;
1339   string public placeholderTokenUri;
1340 
1341   uint256 public NUMBER_OF_UNITS_DROP_1 = 2500;
1342   uint256 public NUMBER_OF_UNITS_DROP_2 = 5000;
1343 
1344   //deploy smart contract, toggle WL, toggle WL when done, toggle publicSale
1345   //2 days later toggle reveal
1346   bool public isRevealed;
1347   bool public publicSale;
1348   bool public whiteListSale;
1349   bool public pause;
1350   bool public teamMinted;
1351   bool public drop2;
1352   bool public drop3;
1353 
1354   bytes32 private merkleRoot;
1355 
1356   mapping(address => uint256) public totalPublicMint;
1357   mapping(address => uint256) public totalWhitelistMint;
1358 
1359   constructor() ERC721A('Yomazuka Family', 'YF', 5, 9999) {}
1360 
1361   modifier callerIsUser() {
1362     require(
1363       tx.origin == msg.sender,
1364       'Yomazuka Family :: Cannot be called by a contract'
1365     );
1366     _;
1367   }
1368 
1369   function mint(uint256 _quantity) external payable callerIsUser {
1370     // TODO: Setprice
1371     //  Connect to OpenSea
1372 
1373     if ((totalSupply() + _quantity) > NUMBER_OF_UNITS_DROP_1) {
1374       require(drop2, 'Yomazuka Family :: Drop 1 beyond Max Supply');
1375     }
1376 
1377     if ((totalSupply() + _quantity) > NUMBER_OF_UNITS_DROP_2) {
1378       require(drop3, 'Yomazuka Family :: Drop 2 beyond Max Supply');
1379     }
1380 
1381     require(publicSale, 'Yomazuka Family :: Not Yet Active.');
1382 
1383     require(
1384       (totalSupply() + _quantity) <= MAX_SUPPLY,
1385       'Yomazuka Family :: Beyond Max Supply'
1386     );
1387     require(
1388       (totalPublicMint[msg.sender] + _quantity) <= MAX_PUBLIC_MINT,
1389       'Yomazuka Family :: Already minted 5 times!'
1390     );
1391     require(
1392       msg.value >= (PUBLIC_SALE_PRICE * _quantity),
1393       'Yomazuka Family :: Below '
1394     );
1395 
1396     totalPublicMint[msg.sender] += _quantity;
1397     _safeMint(msg.sender, _quantity);
1398   }
1399 
1400   function whitelistMint(bytes32[] memory _merkleProof, uint256 _quantity)
1401     external
1402     payable
1403     callerIsUser
1404   {
1405     require(whiteListSale, 'Yomazuka Family :: Minting is on Pause');
1406     require(
1407       (totalSupply() + _quantity) <= MAX_SUPPLY,
1408       'Yomazuka Family :: Cannot mint beyond max supply'
1409     );
1410     require(
1411       (totalWhitelistMint[msg.sender] + _quantity) <= MAX_WHITELIST_MINT,
1412       'Yomazuka Family :: Cannot mint beyond whitelist max mint!'
1413     );
1414     require(
1415       msg.value >= (WHITELIST_SALE_PRICE * _quantity),
1416       'Yomazuka Family :: Payment is below the price'
1417     );
1418     //create leaf node
1419     bytes32 sender = keccak256(abi.encodePacked(msg.sender));
1420     require(
1421       MerkleProof.verify(_merkleProof, merkleRoot, sender),
1422       'Yomazuka Family :: You are not whitelisted'
1423     );
1424 
1425     totalWhitelistMint[msg.sender] += _quantity;
1426     _safeMint(msg.sender, _quantity);
1427   }
1428 
1429   function teamMint() external onlyOwner {
1430     require(!teamMinted, 'Yomazuka Family :: Team already minted');
1431     teamMinted = true;
1432     _safeMint(msg.sender, 200);
1433   }
1434 
1435   function _baseURI() internal view virtual override returns (string memory) {
1436     return baseTokenUri;
1437   }
1438 
1439   //return uri for certain token
1440   function tokenURI(uint256 tokenId)
1441     public
1442     view
1443     virtual
1444     override
1445     returns (string memory)
1446   {
1447     require(
1448       _exists(tokenId),
1449       'ERC721Metadata: URI query for nonexistent token'
1450     );
1451 
1452     uint256 trueId = tokenId + 1;
1453 
1454     if (!isRevealed) {
1455       return placeholderTokenUri;
1456     }
1457     //string memory baseURI = _baseURI();
1458     return
1459       bytes(baseTokenUri).length > 0
1460         ? string(abi.encodePacked(baseTokenUri, trueId.toString(), '.json'))
1461         : '';
1462   }
1463 
1464   /// @dev walletOf() function shouldn't be called on-chain due to gas consumption
1465   function walletOf() external view returns (uint256[] memory) {
1466     address _owner = msg.sender;
1467     uint256 numberOfOwnedNFT = balanceOf(_owner);
1468     uint256[] memory ownerIds = new uint256[](numberOfOwnedNFT);
1469 
1470     for (uint256 index = 0; index < numberOfOwnedNFT; index++) {
1471       ownerIds[index] = tokenOfOwnerByIndex(_owner, index);
1472     }
1473 
1474     return ownerIds;
1475   }
1476 
1477   function setTokenUri(string memory _baseTokenUri) external onlyOwner {
1478     baseTokenUri = _baseTokenUri;
1479   }
1480 
1481   function setPlaceHolderUri(string memory _placeholderTokenUri)
1482     external
1483     onlyOwner
1484   {
1485     placeholderTokenUri = _placeholderTokenUri;
1486   }
1487 
1488   function getMerkleRoot() external view returns (bytes32) {
1489     return merkleRoot;
1490   }
1491 
1492   function togglePause() external onlyOwner {
1493     pause = !pause;
1494   }
1495 
1496   function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1497     merkleRoot = _merkleRoot;
1498   }
1499 
1500   function setPublicPrice(uint256 newPublicPrice) external onlyOwner {
1501     PUBLIC_SALE_PRICE = newPublicPrice;
1502   }
1503 
1504   function toggleWhiteListSale() external onlyOwner {
1505     whiteListSale = !whiteListSale;
1506   }
1507 
1508   function togglePublicSale() external onlyOwner {
1509     publicSale = !publicSale;
1510   }
1511 
1512   function setDrop2Amount(uint256 dropOneAmount) external onlyOwner {
1513     NUMBER_OF_UNITS_DROP_1 = dropOneAmount;
1514   }
1515 
1516   function setDrop3Amount(uint256 dropTwoAmount) external onlyOwner {
1517     NUMBER_OF_UNITS_DROP_2 = dropTwoAmount;
1518   }
1519 
1520   function toggleDrop2() external onlyOwner {
1521     drop2 = !drop2;
1522   }
1523 
1524   function toggleDrop3() external onlyOwner {
1525     drop3 = !drop3;
1526   }
1527 
1528   function toggleReveal() external onlyOwner {
1529     isRevealed = !isRevealed;
1530   }
1531 
1532   function withdraw() external onlyOwner {
1533     payable(msg.sender).transfer(address(this).balance);
1534   }
1535 }