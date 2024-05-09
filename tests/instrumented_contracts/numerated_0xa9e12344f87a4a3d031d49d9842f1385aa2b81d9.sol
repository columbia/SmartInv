1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.0 (utils/cryptography/MerkleProof.sol)
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
56 // File: @openzeppelin/contracts/utils/Strings.sol
57 
58 
59 
60 pragma solidity ^0.8.0;
61 
62 /**
63  * @dev String operations.
64  */
65 library Strings {
66     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
67 
68     /**
69      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
70      */
71     function toString(uint256 value) internal pure returns (string memory) {
72         // Inspired by OraclizeAPI's implementation - MIT licence
73         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
74 
75         if (value == 0) {
76             return "0";
77         }
78         uint256 temp = value;
79         uint256 digits;
80         while (temp != 0) {
81             digits++;
82             temp /= 10;
83         }
84         bytes memory buffer = new bytes(digits);
85         while (value != 0) {
86             digits -= 1;
87             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
88             value /= 10;
89         }
90         return string(buffer);
91     }
92 
93     /**
94      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
95      */
96     function toHexString(uint256 value) internal pure returns (string memory) {
97         if (value == 0) {
98             return "0x00";
99         }
100         uint256 temp = value;
101         uint256 length = 0;
102         while (temp != 0) {
103             length++;
104             temp >>= 8;
105         }
106         return toHexString(value, length);
107     }
108 
109     /**
110      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
111      */
112     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
113         bytes memory buffer = new bytes(2 * length + 2);
114         buffer[0] = "0";
115         buffer[1] = "x";
116         for (uint256 i = 2 * length + 1; i > 1; --i) {
117             buffer[i] = _HEX_SYMBOLS[value & 0xf];
118             value >>= 4;
119         }
120         require(value == 0, "Strings: hex length insufficient");
121         return string(buffer);
122     }
123 }
124 
125 // File: @openzeppelin/contracts/utils/Context.sol
126 
127 
128 
129 pragma solidity ^0.8.0;
130 
131 /**
132  * @dev Provides information about the current execution context, including the
133  * sender of the transaction and its data. While these are generally available
134  * via msg.sender and msg.data, they should not be accessed in such a direct
135  * manner, since when dealing with meta-transactions the account sending and
136  * paying for execution may not be the actual sender (as far as an application
137  * is concerned).
138  *
139  * This contract is only required for intermediate, library-like contracts.
140  */
141 abstract contract Context {
142     function _msgSender() internal view virtual returns (address) {
143         return msg.sender;
144     }
145 
146     function _msgData() internal view virtual returns (bytes calldata) {
147         return msg.data;
148     }
149 }
150 
151 // File: @openzeppelin/contracts/access/Ownable.sol
152 
153 
154 
155 pragma solidity ^0.8.0;
156 
157 
158 /**
159  * @dev Contract module which provides a basic access control mechanism, where
160  * there is an account (an owner) that can be granted exclusive access to
161  * specific functions.
162  *
163  * By default, the owner account will be the one that deploys the contract. This
164  * can later be changed with {transferOwnership}.
165  *
166  * This module is used through inheritance. It will make available the modifier
167  * `onlyOwner`, which can be applied to your functions to restrict their use to
168  * the owner.
169  */
170 abstract contract Ownable is Context {
171     address private _owner;
172 
173     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
174 
175     /**
176      * @dev Initializes the contract setting the deployer as the initial owner.
177      */
178     constructor() {
179         _setOwner(_msgSender());
180     }
181 
182     /**
183      * @dev Returns the address of the current owner.
184      */
185     function owner() public view virtual returns (address) {
186         return _owner;
187     }
188 
189     /**
190      * @dev Throws if called by any account other than the owner.
191      */
192     modifier onlyOwner() {
193         require(owner() == _msgSender(), "Ownable: caller is not the owner");
194         _;
195     }
196 
197     /**
198      * @dev Leaves the contract without owner. It will not be possible to call
199      * `onlyOwner` functions anymore. Can only be called by the current owner.
200      *
201      * NOTE: Renouncing ownership will leave the contract without an owner,
202      * thereby removing any functionality that is only available to the owner.
203      */
204     function renounceOwnership() public virtual onlyOwner {
205         _setOwner(address(0));
206     }
207 
208     /**
209      * @dev Transfers ownership of the contract to a new account (`newOwner`).
210      * Can only be called by the current owner.
211      */
212     function transferOwnership(address newOwner) public virtual onlyOwner {
213         require(newOwner != address(0), "Ownable: new owner is the zero address");
214         _setOwner(newOwner);
215     }
216 
217     function _setOwner(address newOwner) private {
218         address oldOwner = _owner;
219         _owner = newOwner;
220         emit OwnershipTransferred(oldOwner, newOwner);
221     }
222 }
223 
224 // File: @openzeppelin/contracts/utils/Address.sol
225 
226 
227 
228 pragma solidity ^0.8.0;
229 
230 /**
231  * @dev Collection of functions related to the address type
232  */
233 library Address {
234     /**
235      * @dev Returns true if `account` is a contract.
236      *
237      * [IMPORTANT]
238      * ====
239      * It is unsafe to assume that an address for which this function returns
240      * false is an externally-owned account (EOA) and not a contract.
241      *
242      * Among others, `isContract` will return false for the following
243      * types of addresses:
244      *
245      *  - an externally-owned account
246      *  - a contract in construction
247      *  - an address where a contract will be created
248      *  - an address where a contract lived, but was destroyed
249      * ====
250      */
251     function isContract(address account) internal view returns (bool) {
252         // This method relies on extcodesize, which returns 0 for contracts in
253         // construction, since the code is only stored at the end of the
254         // constructor execution.
255 
256         uint256 size;
257         assembly {
258             size := extcodesize(account)
259         }
260         return size > 0;
261     }
262 
263     /**
264      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
265      * `recipient`, forwarding all available gas and reverting on errors.
266      *
267      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
268      * of certain opcodes, possibly making contracts go over the 2300 gas limit
269      * imposed by `transfer`, making them unable to receive funds via
270      * `transfer`. {sendValue} removes this limitation.
271      *
272      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
273      *
274      * IMPORTANT: because control is transferred to `recipient`, care must be
275      * taken to not create reentrancy vulnerabilities. Consider using
276      * {ReentrancyGuard} or the
277      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
278      */
279     function sendValue(address payable recipient, uint256 amount) internal {
280         require(address(this).balance >= amount, "Address: insufficient balance");
281 
282         (bool success, ) = recipient.call{value: amount}("");
283         require(success, "Address: unable to send value, recipient may have reverted");
284     }
285 
286     /**
287      * @dev Performs a Solidity function call using a low level `call`. A
288      * plain `call` is an unsafe replacement for a function call: use this
289      * function instead.
290      *
291      * If `target` reverts with a revert reason, it is bubbled up by this
292      * function (like regular Solidity function calls).
293      *
294      * Returns the raw returned data. To convert to the expected return value,
295      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
296      *
297      * Requirements:
298      *
299      * - `target` must be a contract.
300      * - calling `target` with `data` must not revert.
301      *
302      * _Available since v3.1._
303      */
304     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
305         return functionCall(target, data, "Address: low-level call failed");
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
310      * `errorMessage` as a fallback revert reason when `target` reverts.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(
315         address target,
316         bytes memory data,
317         string memory errorMessage
318     ) internal returns (bytes memory) {
319         return functionCallWithValue(target, data, 0, errorMessage);
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324      * but also transferring `value` wei to `target`.
325      *
326      * Requirements:
327      *
328      * - the calling contract must have an ETH balance of at least `value`.
329      * - the called Solidity function must be `payable`.
330      *
331      * _Available since v3.1._
332      */
333     function functionCallWithValue(
334         address target,
335         bytes memory data,
336         uint256 value
337     ) internal returns (bytes memory) {
338         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
343      * with `errorMessage` as a fallback revert reason when `target` reverts.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(
348         address target,
349         bytes memory data,
350         uint256 value,
351         string memory errorMessage
352     ) internal returns (bytes memory) {
353         require(address(this).balance >= value, "Address: insufficient balance for call");
354         require(isContract(target), "Address: call to non-contract");
355 
356         (bool success, bytes memory returndata) = target.call{value: value}(data);
357         return verifyCallResult(success, returndata, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but performing a static call.
363      *
364      * _Available since v3.3._
365      */
366     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
367         return functionStaticCall(target, data, "Address: low-level static call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
372      * but performing a static call.
373      *
374      * _Available since v3.3._
375      */
376     function functionStaticCall(
377         address target,
378         bytes memory data,
379         string memory errorMessage
380     ) internal view returns (bytes memory) {
381         require(isContract(target), "Address: static call to non-contract");
382 
383         (bool success, bytes memory returndata) = target.staticcall(data);
384         return verifyCallResult(success, returndata, errorMessage);
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
389      * but performing a delegate call.
390      *
391      * _Available since v3.4._
392      */
393     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
394         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
399      * but performing a delegate call.
400      *
401      * _Available since v3.4._
402      */
403     function functionDelegateCall(
404         address target,
405         bytes memory data,
406         string memory errorMessage
407     ) internal returns (bytes memory) {
408         require(isContract(target), "Address: delegate call to non-contract");
409 
410         (bool success, bytes memory returndata) = target.delegatecall(data);
411         return verifyCallResult(success, returndata, errorMessage);
412     }
413 
414     /**
415      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
416      * revert reason using the provided one.
417      *
418      * _Available since v4.3._
419      */
420     function verifyCallResult(
421         bool success,
422         bytes memory returndata,
423         string memory errorMessage
424     ) internal pure returns (bytes memory) {
425         if (success) {
426             return returndata;
427         } else {
428             // Look for revert reason and bubble it up if present
429             if (returndata.length > 0) {
430                 // The easiest way to bubble the revert reason is using memory via assembly
431 
432                 assembly {
433                     let returndata_size := mload(returndata)
434                     revert(add(32, returndata), returndata_size)
435                 }
436             } else {
437                 revert(errorMessage);
438             }
439         }
440     }
441 }
442 
443 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
444 
445 
446 
447 pragma solidity ^0.8.0;
448 
449 /**
450  * @title ERC721 token receiver interface
451  * @dev Interface for any contract that wants to support safeTransfers
452  * from ERC721 asset contracts.
453  */
454 interface IERC721Receiver {
455     /**
456      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
457      * by `operator` from `from`, this function is called.
458      *
459      * It must return its Solidity selector to confirm the token transfer.
460      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
461      *
462      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
463      */
464     function onERC721Received(
465         address operator,
466         address from,
467         uint256 tokenId,
468         bytes calldata data
469     ) external returns (bytes4);
470 }
471 
472 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
473 
474 
475 
476 pragma solidity ^0.8.0;
477 
478 /**
479  * @dev Interface of the ERC165 standard, as defined in the
480  * https://eips.ethereum.org/EIPS/eip-165[EIP].
481  *
482  * Implementers can declare support of contract interfaces, which can then be
483  * queried by others ({ERC165Checker}).
484  *
485  * For an implementation, see {ERC165}.
486  */
487 interface IERC165 {
488     /**
489      * @dev Returns true if this contract implements the interface defined by
490      * `interfaceId`. See the corresponding
491      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
492      * to learn more about how these ids are created.
493      *
494      * This function call must use less than 30 000 gas.
495      */
496     function supportsInterface(bytes4 interfaceId) external view returns (bool);
497 }
498 
499 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
500 
501 
502 
503 pragma solidity ^0.8.0;
504 
505 
506 /**
507  * @dev Implementation of the {IERC165} interface.
508  *
509  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
510  * for the additional interface id that will be supported. For example:
511  *
512  * ```solidity
513  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
514  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
515  * }
516  * ```
517  *
518  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
519  */
520 abstract contract ERC165 is IERC165 {
521     /**
522      * @dev See {IERC165-supportsInterface}.
523      */
524     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
525         return interfaceId == type(IERC165).interfaceId;
526     }
527 }
528 
529 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
530 
531 
532 
533 pragma solidity ^0.8.0;
534 
535 
536 /**
537  * @dev Required interface of an ERC721 compliant contract.
538  */
539 interface IERC721 is IERC165 {
540     /**
541      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
542      */
543     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
544 
545     /**
546      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
547      */
548     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
549 
550     /**
551      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
552      */
553     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
554 
555     /**
556      * @dev Returns the number of tokens in ``owner``'s account.
557      */
558     function balanceOf(address owner) external view returns (uint256 balance);
559 
560     /**
561      * @dev Returns the owner of the `tokenId` token.
562      *
563      * Requirements:
564      *
565      * - `tokenId` must exist.
566      */
567     function ownerOf(uint256 tokenId) external view returns (address owner);
568 
569     /**
570      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
571      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
572      *
573      * Requirements:
574      *
575      * - `from` cannot be the zero address.
576      * - `to` cannot be the zero address.
577      * - `tokenId` token must exist and be owned by `from`.
578      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
579      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
580      *
581      * Emits a {Transfer} event.
582      */
583     function safeTransferFrom(
584         address from,
585         address to,
586         uint256 tokenId
587     ) external;
588 
589     /**
590      * @dev Transfers `tokenId` token from `from` to `to`.
591      *
592      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
593      *
594      * Requirements:
595      *
596      * - `from` cannot be the zero address.
597      * - `to` cannot be the zero address.
598      * - `tokenId` token must be owned by `from`.
599      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
600      *
601      * Emits a {Transfer} event.
602      */
603     function transferFrom(
604         address from,
605         address to,
606         uint256 tokenId
607     ) external;
608 
609     /**
610      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
611      * The approval is cleared when the token is transferred.
612      *
613      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
614      *
615      * Requirements:
616      *
617      * - The caller must own the token or be an approved operator.
618      * - `tokenId` must exist.
619      *
620      * Emits an {Approval} event.
621      */
622     function approve(address to, uint256 tokenId) external;
623 
624     /**
625      * @dev Returns the account approved for `tokenId` token.
626      *
627      * Requirements:
628      *
629      * - `tokenId` must exist.
630      */
631     function getApproved(uint256 tokenId) external view returns (address operator);
632 
633     /**
634      * @dev Approve or remove `operator` as an operator for the caller.
635      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
636      *
637      * Requirements:
638      *
639      * - The `operator` cannot be the caller.
640      *
641      * Emits an {ApprovalForAll} event.
642      */
643     function setApprovalForAll(address operator, bool _approved) external;
644 
645     /**
646      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
647      *
648      * See {setApprovalForAll}
649      */
650     function isApprovedForAll(address owner, address operator) external view returns (bool);
651 
652     /**
653      * @dev Safely transfers `tokenId` token from `from` to `to`.
654      *
655      * Requirements:
656      *
657      * - `from` cannot be the zero address.
658      * - `to` cannot be the zero address.
659      * - `tokenId` token must exist and be owned by `from`.
660      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
661      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
662      *
663      * Emits a {Transfer} event.
664      */
665     function safeTransferFrom(
666         address from,
667         address to,
668         uint256 tokenId,
669         bytes calldata data
670     ) external;
671 }
672 
673 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
674 
675 
676 
677 pragma solidity ^0.8.0;
678 
679 
680 /**
681  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
682  * @dev See https://eips.ethereum.org/EIPS/eip-721
683  */
684 interface IERC721Enumerable is IERC721 {
685     /**
686      * @dev Returns the total amount of tokens stored by the contract.
687      */
688     function totalSupply() external view returns (uint256);
689 
690     /**
691      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
692      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
693      */
694     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
695 
696     /**
697      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
698      * Use along with {totalSupply} to enumerate all tokens.
699      */
700     function tokenByIndex(uint256 index) external view returns (uint256);
701 }
702 
703 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
704 
705 
706 
707 pragma solidity ^0.8.0;
708 
709 
710 /**
711  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
712  * @dev See https://eips.ethereum.org/EIPS/eip-721
713  */
714 interface IERC721Metadata is IERC721 {
715     /**
716      * @dev Returns the token collection name.
717      */
718     function name() external view returns (string memory);
719 
720     /**
721      * @dev Returns the token collection symbol.
722      */
723     function symbol() external view returns (string memory);
724 
725     /**
726      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
727      */
728     function tokenURI(uint256 tokenId) external view returns (string memory);
729 }
730 
731 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
732 
733 
734 
735 pragma solidity ^0.8.0;
736 
737 
738 
739 
740 
741 
742 
743 
744 /**
745  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
746  * the Metadata extension, but not including the Enumerable extension, which is available separately as
747  * {ERC721Enumerable}.
748  */
749 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
750     using Address for address;
751     using Strings for uint256;
752 
753     // Token name
754     string private _name;
755 
756     // Token symbol
757     string private _symbol;
758 
759     // Mapping from token ID to owner address
760     mapping(uint256 => address) private _owners;
761 
762     // Mapping owner address to token count
763     mapping(address => uint256) private _balances;
764 
765     // Mapping from token ID to approved address
766     mapping(uint256 => address) private _tokenApprovals;
767 
768     // Mapping from owner to operator approvals
769     mapping(address => mapping(address => bool)) private _operatorApprovals;
770 
771     /**
772      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
773      */
774     constructor(string memory name_, string memory symbol_) {
775         _name = name_;
776         _symbol = symbol_;
777     }
778 
779     /**
780      * @dev See {IERC165-supportsInterface}.
781      */
782     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
783         return
784             interfaceId == type(IERC721).interfaceId ||
785             interfaceId == type(IERC721Metadata).interfaceId ||
786             super.supportsInterface(interfaceId);
787     }
788 
789     /**
790      * @dev See {IERC721-balanceOf}.
791      */
792     function balanceOf(address owner) public view virtual override returns (uint256) {
793         require(owner != address(0), "ERC721: balance query for the zero address");
794         return _balances[owner];
795     }
796 
797     /**
798      * @dev See {IERC721-ownerOf}.
799      */
800     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
801         address owner = _owners[tokenId];
802         require(owner != address(0), "ERC721: owner query for nonexistent token");
803         return owner;
804     }
805 
806     /**
807      * @dev See {IERC721Metadata-name}.
808      */
809     function name() public view virtual override returns (string memory) {
810         return _name;
811     }
812 
813     /**
814      * @dev See {IERC721Metadata-symbol}.
815      */
816     function symbol() public view virtual override returns (string memory) {
817         return _symbol;
818     }
819 
820     /**
821      * @dev See {IERC721Metadata-tokenURI}.
822      */
823     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
824         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
825 
826         string memory baseURI = _baseURI();
827         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
828     }
829 
830     /**
831      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
832      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
833      * by default, can be overriden in child contracts.
834      */
835     function _baseURI() internal view virtual returns (string memory) {
836         return "";
837     }
838 
839     /**
840      * @dev See {IERC721-approve}.
841      */
842     function approve(address to, uint256 tokenId) public virtual override {
843         address owner = ERC721.ownerOf(tokenId);
844         require(to != owner, "ERC721: approval to current owner");
845 
846         require(
847             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
848             "ERC721: approve caller is not owner nor approved for all"
849         );
850 
851         _approve(to, tokenId);
852     }
853 
854     /**
855      * @dev See {IERC721-getApproved}.
856      */
857     function getApproved(uint256 tokenId) public view virtual override returns (address) {
858         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
859 
860         return _tokenApprovals[tokenId];
861     }
862 
863     /**
864      * @dev See {IERC721-setApprovalForAll}.
865      */
866     function setApprovalForAll(address operator, bool approved) public virtual override {
867         require(operator != _msgSender(), "ERC721: approve to caller");
868 
869         _operatorApprovals[_msgSender()][operator] = approved;
870         emit ApprovalForAll(_msgSender(), operator, approved);
871     }
872 
873     /**
874      * @dev See {IERC721-isApprovedForAll}.
875      */
876     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
877         return _operatorApprovals[owner][operator];
878     }
879 
880     /**
881      * @dev See {IERC721-transferFrom}.
882      */
883     function transferFrom(
884         address from,
885         address to,
886         uint256 tokenId
887     ) public virtual override {
888         //solhint-disable-next-line max-line-length
889         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
890 
891         _transfer(from, to, tokenId);
892     }
893 
894     /**
895      * @dev See {IERC721-safeTransferFrom}.
896      */
897     function safeTransferFrom(
898         address from,
899         address to,
900         uint256 tokenId
901     ) public virtual override {
902         safeTransferFrom(from, to, tokenId, "");
903     }
904 
905     /**
906      * @dev See {IERC721-safeTransferFrom}.
907      */
908     function safeTransferFrom(
909         address from,
910         address to,
911         uint256 tokenId,
912         bytes memory _data
913     ) public virtual override {
914         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
915         _safeTransfer(from, to, tokenId, _data);
916     }
917 
918     /**
919      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
920      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
921      *
922      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
923      *
924      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
925      * implement alternative mechanisms to perform token transfer, such as signature-based.
926      *
927      * Requirements:
928      *
929      * - `from` cannot be the zero address.
930      * - `to` cannot be the zero address.
931      * - `tokenId` token must exist and be owned by `from`.
932      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
933      *
934      * Emits a {Transfer} event.
935      */
936     function _safeTransfer(
937         address from,
938         address to,
939         uint256 tokenId,
940         bytes memory _data
941     ) internal virtual {
942         _transfer(from, to, tokenId);
943         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
944     }
945 
946     /**
947      * @dev Returns whether `tokenId` exists.
948      *
949      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
950      *
951      * Tokens start existing when they are minted (`_mint`),
952      * and stop existing when they are burned (`_burn`).
953      */
954     function _exists(uint256 tokenId) internal view virtual returns (bool) {
955         return _owners[tokenId] != address(0);
956     }
957 
958     /**
959      * @dev Returns whether `spender` is allowed to manage `tokenId`.
960      *
961      * Requirements:
962      *
963      * - `tokenId` must exist.
964      */
965     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
966         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
967         address owner = ERC721.ownerOf(tokenId);
968         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
969     }
970 
971     /**
972      * @dev Safely mints `tokenId` and transfers it to `to`.
973      *
974      * Requirements:
975      *
976      * - `tokenId` must not exist.
977      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
978      *
979      * Emits a {Transfer} event.
980      */
981     function _safeMint(address to, uint256 tokenId) internal virtual {
982         _safeMint(to, tokenId, "");
983     }
984 
985     /**
986      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
987      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
988      */
989     function _safeMint(
990         address to,
991         uint256 tokenId,
992         bytes memory _data
993     ) internal virtual {
994         _mint(to, tokenId);
995         require(
996             _checkOnERC721Received(address(0), to, tokenId, _data),
997             "ERC721: transfer to non ERC721Receiver implementer"
998         );
999     }
1000 
1001     /**
1002      * @dev Mints `tokenId` and transfers it to `to`.
1003      *
1004      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1005      *
1006      * Requirements:
1007      *
1008      * - `tokenId` must not exist.
1009      * - `to` cannot be the zero address.
1010      *
1011      * Emits a {Transfer} event.
1012      */
1013     function _mint(address to, uint256 tokenId) internal virtual {
1014         require(to != address(0), "ERC721: mint to the zero address");
1015         require(!_exists(tokenId), "ERC721: token already minted");
1016 
1017         _beforeTokenTransfer(address(0), to, tokenId);
1018 
1019         _balances[to] += 1;
1020         _owners[tokenId] = to;
1021 
1022         emit Transfer(address(0), to, tokenId);
1023     }
1024 
1025     /**
1026      * @dev Destroys `tokenId`.
1027      * The approval is cleared when the token is burned.
1028      *
1029      * Requirements:
1030      *
1031      * - `tokenId` must exist.
1032      *
1033      * Emits a {Transfer} event.
1034      */
1035     function _burn(uint256 tokenId) internal virtual {
1036         address owner = ERC721.ownerOf(tokenId);
1037 
1038         _beforeTokenTransfer(owner, address(0), tokenId);
1039 
1040         // Clear approvals
1041         _approve(address(0), tokenId);
1042 
1043         _balances[owner] -= 1;
1044         delete _owners[tokenId];
1045 
1046         emit Transfer(owner, address(0), tokenId);
1047     }
1048 
1049     /**
1050      * @dev Transfers `tokenId` from `from` to `to`.
1051      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1052      *
1053      * Requirements:
1054      *
1055      * - `to` cannot be the zero address.
1056      * - `tokenId` token must be owned by `from`.
1057      *
1058      * Emits a {Transfer} event.
1059      */
1060     function _transfer(
1061         address from,
1062         address to,
1063         uint256 tokenId
1064     ) internal virtual {
1065         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1066         require(to != address(0), "ERC721: transfer to the zero address");
1067 
1068         _beforeTokenTransfer(from, to, tokenId);
1069 
1070         // Clear approvals from the previous owner
1071         _approve(address(0), tokenId);
1072 
1073         _balances[from] -= 1;
1074         _balances[to] += 1;
1075         _owners[tokenId] = to;
1076 
1077         emit Transfer(from, to, tokenId);
1078     }
1079 
1080     /**
1081      * @dev Approve `to` to operate on `tokenId`
1082      *
1083      * Emits a {Approval} event.
1084      */
1085     function _approve(address to, uint256 tokenId) internal virtual {
1086         _tokenApprovals[tokenId] = to;
1087         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1088     }
1089 
1090     /**
1091      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1092      * The call is not executed if the target address is not a contract.
1093      *
1094      * @param from address representing the previous owner of the given token ID
1095      * @param to target address that will receive the tokens
1096      * @param tokenId uint256 ID of the token to be transferred
1097      * @param _data bytes optional data to send along with the call
1098      * @return bool whether the call correctly returned the expected magic value
1099      */
1100     function _checkOnERC721Received(
1101         address from,
1102         address to,
1103         uint256 tokenId,
1104         bytes memory _data
1105     ) private returns (bool) {
1106         if (to.isContract()) {
1107             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1108                 return retval == IERC721Receiver.onERC721Received.selector;
1109             } catch (bytes memory reason) {
1110                 if (reason.length == 0) {
1111                     revert("ERC721: transfer to non ERC721Receiver implementer");
1112                 } else {
1113                     assembly {
1114                         revert(add(32, reason), mload(reason))
1115                     }
1116                 }
1117             }
1118         } else {
1119             return true;
1120         }
1121     }
1122 
1123     /**
1124      * @dev Hook that is called before any token transfer. This includes minting
1125      * and burning.
1126      *
1127      * Calling conditions:
1128      *
1129      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1130      * transferred to `to`.
1131      * - When `from` is zero, `tokenId` will be minted for `to`.
1132      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1133      * - `from` and `to` are never both zero.
1134      *
1135      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1136      */
1137     function _beforeTokenTransfer(
1138         address from,
1139         address to,
1140         uint256 tokenId
1141     ) internal virtual {}
1142 }
1143 
1144 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1145 
1146 
1147 
1148 pragma solidity ^0.8.0;
1149 
1150 
1151 
1152 /**
1153  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1154  * enumerability of all the token ids in the contract as well as all token ids owned by each
1155  * account.
1156  */
1157 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1158     // Mapping from owner to list of owned token IDs
1159     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1160 
1161     // Mapping from token ID to index of the owner tokens list
1162     mapping(uint256 => uint256) private _ownedTokensIndex;
1163 
1164     // Array with all token ids, used for enumeration
1165     uint256[] private _allTokens;
1166 
1167     // Mapping from token id to position in the allTokens array
1168     mapping(uint256 => uint256) private _allTokensIndex;
1169 
1170     /**
1171      * @dev See {IERC165-supportsInterface}.
1172      */
1173     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1174         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1175     }
1176 
1177     /**
1178      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1179      */
1180     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1181         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1182         return _ownedTokens[owner][index];
1183     }
1184 
1185     /**
1186      * @dev See {IERC721Enumerable-totalSupply}.
1187      */
1188     function totalSupply() public view virtual override returns (uint256) {
1189         return _allTokens.length;
1190     }
1191 
1192     /**
1193      * @dev See {IERC721Enumerable-tokenByIndex}.
1194      */
1195     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1196         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1197         return _allTokens[index];
1198     }
1199 
1200     /**
1201      * @dev Hook that is called before any token transfer. This includes minting
1202      * and burning.
1203      *
1204      * Calling conditions:
1205      *
1206      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1207      * transferred to `to`.
1208      * - When `from` is zero, `tokenId` will be minted for `to`.
1209      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1210      * - `from` cannot be the zero address.
1211      * - `to` cannot be the zero address.
1212      *
1213      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1214      */
1215     function _beforeTokenTransfer(
1216         address from,
1217         address to,
1218         uint256 tokenId
1219     ) internal virtual override {
1220         super._beforeTokenTransfer(from, to, tokenId);
1221 
1222         if (from == address(0)) {
1223             _addTokenToAllTokensEnumeration(tokenId);
1224         } else if (from != to) {
1225             _removeTokenFromOwnerEnumeration(from, tokenId);
1226         }
1227         if (to == address(0)) {
1228             _removeTokenFromAllTokensEnumeration(tokenId);
1229         } else if (to != from) {
1230             _addTokenToOwnerEnumeration(to, tokenId);
1231         }
1232     }
1233 
1234     /**
1235      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1236      * @param to address representing the new owner of the given token ID
1237      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1238      */
1239     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1240         uint256 length = ERC721.balanceOf(to);
1241         _ownedTokens[to][length] = tokenId;
1242         _ownedTokensIndex[tokenId] = length;
1243     }
1244 
1245     /**
1246      * @dev Private function to add a token to this extension's token tracking data structures.
1247      * @param tokenId uint256 ID of the token to be added to the tokens list
1248      */
1249     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1250         _allTokensIndex[tokenId] = _allTokens.length;
1251         _allTokens.push(tokenId);
1252     }
1253 
1254     /**
1255      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1256      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1257      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1258      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1259      * @param from address representing the previous owner of the given token ID
1260      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1261      */
1262     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1263         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1264         // then delete the last slot (swap and pop).
1265 
1266         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1267         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1268 
1269         // When the token to delete is the last token, the swap operation is unnecessary
1270         if (tokenIndex != lastTokenIndex) {
1271             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1272 
1273             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1274             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1275         }
1276 
1277         // This also deletes the contents at the last position of the array
1278         delete _ownedTokensIndex[tokenId];
1279         delete _ownedTokens[from][lastTokenIndex];
1280     }
1281 
1282     /**
1283      * @dev Private function to remove a token from this extension's token tracking data structures.
1284      * This has O(1) time complexity, but alters the order of the _allTokens array.
1285      * @param tokenId uint256 ID of the token to be removed from the tokens list
1286      */
1287     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1288         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1289         // then delete the last slot (swap and pop).
1290 
1291         uint256 lastTokenIndex = _allTokens.length - 1;
1292         uint256 tokenIndex = _allTokensIndex[tokenId];
1293 
1294         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1295         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1296         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1297         uint256 lastTokenId = _allTokens[lastTokenIndex];
1298 
1299         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1300         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1301 
1302         // This also deletes the contents at the last position of the array
1303         delete _allTokensIndex[tokenId];
1304         _allTokens.pop();
1305     }
1306 }
1307 
1308 // File: contracts/metaPengusContract.sol
1309 
1310 
1311 
1312 pragma solidity >=0.7.0 <0.9.0;
1313 
1314 
1315 
1316 // SPDX-License-Identifier: GPL-3.0
1317 
1318 contract MetaPengus is ERC721Enumerable, Ownable {
1319 	using Strings for uint256;
1320 
1321 	string baseURI;
1322 	string baseExtension = ".json";
1323 	string notRevealedUri;
1324 	uint256 public cost = .05 ether;
1325 	uint256 public maxSupply = 6200;
1326 	uint256 public nftPerAddressLimit = 4;
1327 	uint256 public maxMintOverall = 8;
1328 	bool public paused = true;
1329 	bool public revealed = false;
1330 	bool public onlyWhitelisted = true;
1331 	mapping(address => uint256) public addressMintedBalance;
1332 	bytes32 public whitelistMerkleRoot;
1333 	mapping(address => bool) public whitelistedAddressesBackup;
1334 	bool public useWhitelistedAddressesBackup = false;
1335 
1336 	constructor(
1337 		string memory _name,
1338 		string memory _symbol,
1339 		string memory _notRevealedUri
1340 	) ERC721(_name, _symbol) {
1341 		notRevealedUri = _notRevealedUri;
1342 	}
1343 
1344 	// internal
1345 	function _baseURI() internal view virtual override returns (string memory) {
1346 		return baseURI;
1347 	}
1348 
1349 	function _generateMerkleLeaf(address account)
1350 		internal
1351 		pure
1352 		returns (bytes32)
1353 	{
1354 		return keccak256(abi.encodePacked(account));
1355 	}
1356 
1357 	/**
1358 	 * Validates a Merkle proof based on a provided merkle root and leaf node.
1359 	 */
1360 	function _verify(
1361 		bytes32[] memory proof,
1362 		bytes32 merkleRoot,
1363 		bytes32 leafNode
1364 	) internal pure returns (bool) {
1365 		return MerkleProof.verify(proof, merkleRoot, leafNode);
1366 	}
1367 
1368 	/**
1369 	 * Mint a Pengu!
1370 	 *
1371 	 * Limit: 4 Whitelist Presale, 8 Total
1372 	 * Only whitelisted individuals can mint presale. We utilize a Merkle Proof to determine who is whitelisted.
1373 	 *
1374 	 * If these cases are not met, the mint WILL fail, and your gas will NOT be refunded.
1375 	 * Please only mint through metapengus.io unless you're absolutely sure you know what you're doing!
1376 	 */
1377 	function mint(uint256 _mintAmount, bytes32[] calldata proof)
1378 		public
1379 		payable
1380 	{
1381 		require(paused == false, "the contract is paused");
1382 		uint256 supply = totalSupply();
1383 		require(_mintAmount > 0, "need to mint at least 1 NFT");
1384 		require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1385 
1386 		uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1387 		if (msg.sender != owner()) {
1388 			if (onlyWhitelisted == true) {
1389 				if (useWhitelistedAddressesBackup) {
1390 					require(whitelistedAddressesBackup[msg.sender] == true, "user is not whitelisted");
1391 				} else {
1392 					require(
1393 						_verify(
1394 							proof,
1395 							whitelistMerkleRoot,
1396 							_generateMerkleLeaf(msg.sender)
1397 						),
1398 						"user is not whitelisted"
1399 					);
1400 				}
1401 				require(
1402 					ownerMintedCount + _mintAmount <= nftPerAddressLimit,
1403 					"max NFT per address exceeded"
1404 				);
1405 			}
1406 			require(msg.value >= cost * _mintAmount, "insufficient funds");
1407 
1408 			/** When regular minting is enabled, make sure max hold per wallet is 8. */
1409 			require(
1410 				ownerMintedCount + _mintAmount <= maxMintOverall,
1411 				"max NFT per address exceeded"
1412 			);
1413 		}
1414 
1415 		for (uint256 i = 1; i <= _mintAmount; i++) {
1416 			addressMintedBalance[msg.sender]++;
1417 			_safeMint(msg.sender, supply + i);
1418 		}
1419 	}
1420 
1421 	function walletOfOwner(address _owner)
1422 		public
1423 		view
1424 		returns (uint256[] memory)
1425 	{
1426 		uint256 ownerTokenCount = balanceOf(_owner);
1427 		uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1428 		for (uint256 i; i < ownerTokenCount; i++) {
1429 			tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1430 		}
1431 		return tokenIds;
1432 	}
1433 
1434 	function tokenURI(uint256 tokenId)
1435 		public
1436 		view
1437 		virtual
1438 		override
1439 		returns (string memory)
1440 	{
1441 		require(
1442 			_exists(tokenId),
1443 			"ERC721Metadata: URI query for nonexistent token"
1444 		);
1445 
1446 		if (revealed == false) {
1447 			return notRevealedUri;
1448 		}
1449 
1450 		string memory currentBaseURI = _baseURI();
1451 		return
1452 			bytes(currentBaseURI).length > 0
1453 				? string(
1454 					abi.encodePacked(
1455 						currentBaseURI,
1456 						tokenId.toString(),
1457 						baseExtension
1458 					)
1459 				)
1460 				: "";
1461 	}
1462 
1463 	//only owner
1464 	function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1465 		nftPerAddressLimit = _limit;
1466 	}
1467 
1468 	/** Sets the merkle root for the whitelisted individuals. */
1469 	function setWhiteListMerkleRoot(bytes32 merkleRoot) public onlyOwner {
1470 		whitelistMerkleRoot = merkleRoot;
1471 	}
1472 
1473 	function setWhitelistedAddressesBackup(address[] memory addresses) public onlyOwner {
1474 		for (uint256 i = 0; i < addresses.length; i++) {
1475 			whitelistedAddressesBackup[addresses[i]] = true;
1476 		}
1477 	}
1478 
1479 	function setBackupWhitelistedAddressState(bool state) public onlyOwner {
1480 		useWhitelistedAddressesBackup = state;
1481 	}
1482 
1483 	//cost in Wei
1484 	function setCost(uint256 _newCost) public onlyOwner {
1485 		cost = _newCost;
1486 	}
1487 
1488 	function setBaseURI(string memory _newBaseURI) public onlyOwner {
1489 		baseURI = _newBaseURI;
1490 	}
1491 
1492 	function setBaseExtension(string memory _newBaseExtension)
1493 		public
1494 		onlyOwner
1495 	{
1496 		baseExtension = _newBaseExtension;
1497 	}
1498 
1499 	function setRevealedState(bool revealedState) public onlyOwner {
1500 		revealed = revealedState;
1501 	}
1502 
1503 	function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1504 		notRevealedUri = _notRevealedURI;
1505 	}
1506 
1507 	function pause(bool _state) public onlyOwner {
1508 		paused = _state;
1509 	}
1510 
1511 	function setOnlyWhitelisted(bool _state) public onlyOwner {
1512 		onlyWhitelisted = _state;
1513 	}
1514 
1515 	function setMaxMintOverall(uint256 count) public onlyOwner {
1516 		maxMintOverall = count;
1517 	}
1518 
1519 	function withdraw() public payable onlyOwner {
1520 		(bool os, ) = payable(owner()).call{value: address(this).balance}("");
1521 		require(os);
1522 	}
1523 }