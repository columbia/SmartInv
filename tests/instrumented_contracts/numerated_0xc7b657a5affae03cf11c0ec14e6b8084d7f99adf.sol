1 // File: @openzeppelin/contracts/utils/structs/BitMaps.sol
2 
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Library for managing uint256 to bool mapping in a compact and efficient way, providing the keys are sequential.
8  * Largelly inspired by Uniswap's https://github.com/Uniswap/merkle-distributor/blob/master/contracts/MerkleDistributor.sol[merkle-distributor].
9  */
10 library BitMaps {
11     struct BitMap {
12         mapping(uint256 => uint256) _data;
13     }
14 
15     /**
16      * @dev Returns whether the bit at `index` is set.
17      */
18     function get(BitMap storage bitmap, uint256 index) internal view returns (bool) {
19         uint256 bucket = index >> 8;
20         uint256 mask = 1 << (index & 0xff);
21         return bitmap._data[bucket] & mask != 0;
22     }
23 
24     /**
25      * @dev Sets the bit at `index` to the boolean `value`.
26      */
27     function setTo(
28         BitMap storage bitmap,
29         uint256 index,
30         bool value
31     ) internal {
32         if (value) {
33             set(bitmap, index);
34         } else {
35             unset(bitmap, index);
36         }
37     }
38 
39     /**
40      * @dev Sets the bit at `index`.
41      */
42     function set(BitMap storage bitmap, uint256 index) internal {
43         uint256 bucket = index >> 8;
44         uint256 mask = 1 << (index & 0xff);
45         bitmap._data[bucket] |= mask;
46     }
47 
48     /**
49      * @dev Unsets the bit at `index`.
50      */
51     function unset(BitMap storage bitmap, uint256 index) internal {
52         uint256 bucket = index >> 8;
53         uint256 mask = 1 << (index & 0xff);
54         bitmap._data[bucket] &= ~mask;
55     }
56 }
57 
58 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
59 
60 
61 
62 pragma solidity ^0.8.0;
63 
64 /**
65  * @dev These functions deal with verification of Merkle Trees proofs.
66  *
67  * The proofs can be generated using the JavaScript library
68  * https://github.com/miguelmota/merkletreejs[merkletreejs].
69  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
70  *
71  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
72  */
73 library MerkleProof {
74     /**
75      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
76      * defined by `root`. For this, a `proof` must be provided, containing
77      * sibling hashes on the branch from the leaf to the root of the tree. Each
78      * pair of leaves and each pair of pre-images are assumed to be sorted.
79      */
80     function verify(
81         bytes32[] memory proof,
82         bytes32 root,
83         bytes32 leaf
84     ) internal pure returns (bool) {
85         bytes32 computedHash = leaf;
86 
87         for (uint256 i = 0; i < proof.length; i++) {
88             bytes32 proofElement = proof[i];
89 
90             if (computedHash <= proofElement) {
91                 // Hash(current computed hash + current element of the proof)
92                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
93             } else {
94                 // Hash(current element of the proof + current computed hash)
95                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
96             }
97         }
98 
99         // Check if the computed hash (root) is equal to the provided root
100         return computedHash == root;
101     }
102 }
103 
104 // File: @openzeppelin/contracts/utils/Strings.sol
105 
106 
107 
108 pragma solidity ^0.8.0;
109 
110 /**
111  * @dev String operations.
112  */
113 library Strings {
114     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
115 
116     /**
117      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
118      */
119     function toString(uint256 value) internal pure returns (string memory) {
120         // Inspired by OraclizeAPI's implementation - MIT licence
121         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
122 
123         if (value == 0) {
124             return "0";
125         }
126         uint256 temp = value;
127         uint256 digits;
128         while (temp != 0) {
129             digits++;
130             temp /= 10;
131         }
132         bytes memory buffer = new bytes(digits);
133         while (value != 0) {
134             digits -= 1;
135             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
136             value /= 10;
137         }
138         return string(buffer);
139     }
140 
141     /**
142      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
143      */
144     function toHexString(uint256 value) internal pure returns (string memory) {
145         if (value == 0) {
146             return "0x00";
147         }
148         uint256 temp = value;
149         uint256 length = 0;
150         while (temp != 0) {
151             length++;
152             temp >>= 8;
153         }
154         return toHexString(value, length);
155     }
156 
157     /**
158      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
159      */
160     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
161         bytes memory buffer = new bytes(2 * length + 2);
162         buffer[0] = "0";
163         buffer[1] = "x";
164         for (uint256 i = 2 * length + 1; i > 1; --i) {
165             buffer[i] = _HEX_SYMBOLS[value & 0xf];
166             value >>= 4;
167         }
168         require(value == 0, "Strings: hex length insufficient");
169         return string(buffer);
170     }
171 }
172 
173 // File: @openzeppelin/contracts/utils/Context.sol
174 
175 
176 
177 pragma solidity ^0.8.0;
178 
179 /**
180  * @dev Provides information about the current execution context, including the
181  * sender of the transaction and its data. While these are generally available
182  * via msg.sender and msg.data, they should not be accessed in such a direct
183  * manner, since when dealing with meta-transactions the account sending and
184  * paying for execution may not be the actual sender (as far as an application
185  * is concerned).
186  *
187  * This contract is only required for intermediate, library-like contracts.
188  */
189 abstract contract Context {
190     function _msgSender() internal view virtual returns (address) {
191         return msg.sender;
192     }
193 
194     function _msgData() internal view virtual returns (bytes calldata) {
195         return msg.data;
196     }
197 }
198 
199 // File: @openzeppelin/contracts/access/Ownable.sol
200 
201 
202 
203 pragma solidity ^0.8.0;
204 
205 
206 /**
207  * @dev Contract module which provides a basic access control mechanism, where
208  * there is an account (an owner) that can be granted exclusive access to
209  * specific functions.
210  *
211  * By default, the owner account will be the one that deploys the contract. This
212  * can later be changed with {transferOwnership}.
213  *
214  * This module is used through inheritance. It will make available the modifier
215  * `onlyOwner`, which can be applied to your functions to restrict their use to
216  * the owner.
217  */
218 abstract contract Ownable is Context {
219     address private _owner;
220 
221     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
222 
223     /**
224      * @dev Initializes the contract setting the deployer as the initial owner.
225      */
226     constructor() {
227         _setOwner(_msgSender());
228     }
229 
230     /**
231      * @dev Returns the address of the current owner.
232      */
233     function owner() public view virtual returns (address) {
234         return _owner;
235     }
236 
237     /**
238      * @dev Throws if called by any account other than the owner.
239      */
240     modifier onlyOwner() {
241         require(owner() == _msgSender(), "Ownable: caller is not the owner");
242         _;
243     }
244 
245     /**
246      * @dev Leaves the contract without owner. It will not be possible to call
247      * `onlyOwner` functions anymore. Can only be called by the current owner.
248      *
249      * NOTE: Renouncing ownership will leave the contract without an owner,
250      * thereby removing any functionality that is only available to the owner.
251      */
252     function renounceOwnership() public virtual onlyOwner {
253         _setOwner(address(0));
254     }
255 
256     /**
257      * @dev Transfers ownership of the contract to a new account (`newOwner`).
258      * Can only be called by the current owner.
259      */
260     function transferOwnership(address newOwner) public virtual onlyOwner {
261         require(newOwner != address(0), "Ownable: new owner is the zero address");
262         _setOwner(newOwner);
263     }
264 
265     function _setOwner(address newOwner) private {
266         address oldOwner = _owner;
267         _owner = newOwner;
268         emit OwnershipTransferred(oldOwner, newOwner);
269     }
270 }
271 
272 // File: @openzeppelin/contracts/utils/Address.sol
273 
274 
275 
276 pragma solidity ^0.8.0;
277 
278 /**
279  * @dev Collection of functions related to the address type
280  */
281 library Address {
282     /**
283      * @dev Returns true if `account` is a contract.
284      *
285      * [IMPORTANT]
286      * ====
287      * It is unsafe to assume that an address for which this function returns
288      * false is an externally-owned account (EOA) and not a contract.
289      *
290      * Among others, `isContract` will return false for the following
291      * types of addresses:
292      *
293      *  - an externally-owned account
294      *  - a contract in construction
295      *  - an address where a contract will be created
296      *  - an address where a contract lived, but was destroyed
297      * ====
298      */
299     function isContract(address account) internal view returns (bool) {
300         // This method relies on extcodesize, which returns 0 for contracts in
301         // construction, since the code is only stored at the end of the
302         // constructor execution.
303 
304         uint256 size;
305         assembly {
306             size := extcodesize(account)
307         }
308         return size > 0;
309     }
310 
311     /**
312      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
313      * `recipient`, forwarding all available gas and reverting on errors.
314      *
315      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
316      * of certain opcodes, possibly making contracts go over the 2300 gas limit
317      * imposed by `transfer`, making them unable to receive funds via
318      * `transfer`. {sendValue} removes this limitation.
319      *
320      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
321      *
322      * IMPORTANT: because control is transferred to `recipient`, care must be
323      * taken to not create reentrancy vulnerabilities. Consider using
324      * {ReentrancyGuard} or the
325      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
326      */
327     function sendValue(address payable recipient, uint256 amount) internal {
328         require(address(this).balance >= amount, "Address: insufficient balance");
329 
330         (bool success, ) = recipient.call{value: amount}("");
331         require(success, "Address: unable to send value, recipient may have reverted");
332     }
333 
334     /**
335      * @dev Performs a Solidity function call using a low level `call`. A
336      * plain `call` is an unsafe replacement for a function call: use this
337      * function instead.
338      *
339      * If `target` reverts with a revert reason, it is bubbled up by this
340      * function (like regular Solidity function calls).
341      *
342      * Returns the raw returned data. To convert to the expected return value,
343      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
344      *
345      * Requirements:
346      *
347      * - `target` must be a contract.
348      * - calling `target` with `data` must not revert.
349      *
350      * _Available since v3.1._
351      */
352     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
353         return functionCall(target, data, "Address: low-level call failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
358      * `errorMessage` as a fallback revert reason when `target` reverts.
359      *
360      * _Available since v3.1._
361      */
362     function functionCall(
363         address target,
364         bytes memory data,
365         string memory errorMessage
366     ) internal returns (bytes memory) {
367         return functionCallWithValue(target, data, 0, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but also transferring `value` wei to `target`.
373      *
374      * Requirements:
375      *
376      * - the calling contract must have an ETH balance of at least `value`.
377      * - the called Solidity function must be `payable`.
378      *
379      * _Available since v3.1._
380      */
381     function functionCallWithValue(
382         address target,
383         bytes memory data,
384         uint256 value
385     ) internal returns (bytes memory) {
386         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
391      * with `errorMessage` as a fallback revert reason when `target` reverts.
392      *
393      * _Available since v3.1._
394      */
395     function functionCallWithValue(
396         address target,
397         bytes memory data,
398         uint256 value,
399         string memory errorMessage
400     ) internal returns (bytes memory) {
401         require(address(this).balance >= value, "Address: insufficient balance for call");
402         require(isContract(target), "Address: call to non-contract");
403 
404         (bool success, bytes memory returndata) = target.call{value: value}(data);
405         return verifyCallResult(success, returndata, errorMessage);
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
410      * but performing a static call.
411      *
412      * _Available since v3.3._
413      */
414     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
415         return functionStaticCall(target, data, "Address: low-level static call failed");
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
420      * but performing a static call.
421      *
422      * _Available since v3.3._
423      */
424     function functionStaticCall(
425         address target,
426         bytes memory data,
427         string memory errorMessage
428     ) internal view returns (bytes memory) {
429         require(isContract(target), "Address: static call to non-contract");
430 
431         (bool success, bytes memory returndata) = target.staticcall(data);
432         return verifyCallResult(success, returndata, errorMessage);
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
437      * but performing a delegate call.
438      *
439      * _Available since v3.4._
440      */
441     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
442         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
447      * but performing a delegate call.
448      *
449      * _Available since v3.4._
450      */
451     function functionDelegateCall(
452         address target,
453         bytes memory data,
454         string memory errorMessage
455     ) internal returns (bytes memory) {
456         require(isContract(target), "Address: delegate call to non-contract");
457 
458         (bool success, bytes memory returndata) = target.delegatecall(data);
459         return verifyCallResult(success, returndata, errorMessage);
460     }
461 
462     /**
463      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
464      * revert reason using the provided one.
465      *
466      * _Available since v4.3._
467      */
468     function verifyCallResult(
469         bool success,
470         bytes memory returndata,
471         string memory errorMessage
472     ) internal pure returns (bytes memory) {
473         if (success) {
474             return returndata;
475         } else {
476             // Look for revert reason and bubble it up if present
477             if (returndata.length > 0) {
478                 // The easiest way to bubble the revert reason is using memory via assembly
479 
480                 assembly {
481                     let returndata_size := mload(returndata)
482                     revert(add(32, returndata), returndata_size)
483                 }
484             } else {
485                 revert(errorMessage);
486             }
487         }
488     }
489 }
490 
491 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
492 
493 
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
523 
524 pragma solidity ^0.8.0;
525 
526 /**
527  * @dev Interface of the ERC165 standard, as defined in the
528  * https://eips.ethereum.org/EIPS/eip-165[EIP].
529  *
530  * Implementers can declare support of contract interfaces, which can then be
531  * queried by others ({ERC165Checker}).
532  *
533  * For an implementation, see {ERC165}.
534  */
535 interface IERC165 {
536     /**
537      * @dev Returns true if this contract implements the interface defined by
538      * `interfaceId`. See the corresponding
539      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
540      * to learn more about how these ids are created.
541      *
542      * This function call must use less than 30 000 gas.
543      */
544     function supportsInterface(bytes4 interfaceId) external view returns (bool);
545 }
546 
547 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
548 
549 
550 
551 pragma solidity ^0.8.0;
552 
553 
554 /**
555  * @dev Implementation of the {IERC165} interface.
556  *
557  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
558  * for the additional interface id that will be supported. For example:
559  *
560  * ```solidity
561  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
562  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
563  * }
564  * ```
565  *
566  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
567  */
568 abstract contract ERC165 is IERC165 {
569     /**
570      * @dev See {IERC165-supportsInterface}.
571      */
572     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
573         return interfaceId == type(IERC165).interfaceId;
574     }
575 }
576 
577 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
578 
579 
580 
581 pragma solidity ^0.8.0;
582 
583 
584 /**
585  * @dev Required interface of an ERC721 compliant contract.
586  */
587 interface IERC721 is IERC165 {
588     /**
589      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
590      */
591     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
592 
593     /**
594      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
595      */
596     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
597 
598     /**
599      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
600      */
601     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
602 
603     /**
604      * @dev Returns the number of tokens in ``owner``'s account.
605      */
606     function balanceOf(address owner) external view returns (uint256 balance);
607 
608     /**
609      * @dev Returns the owner of the `tokenId` token.
610      *
611      * Requirements:
612      *
613      * - `tokenId` must exist.
614      */
615     function ownerOf(uint256 tokenId) external view returns (address owner);
616 
617     /**
618      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
619      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
620      *
621      * Requirements:
622      *
623      * - `from` cannot be the zero address.
624      * - `to` cannot be the zero address.
625      * - `tokenId` token must exist and be owned by `from`.
626      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
627      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
628      *
629      * Emits a {Transfer} event.
630      */
631     function safeTransferFrom(
632         address from,
633         address to,
634         uint256 tokenId
635     ) external;
636 
637     /**
638      * @dev Transfers `tokenId` token from `from` to `to`.
639      *
640      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
641      *
642      * Requirements:
643      *
644      * - `from` cannot be the zero address.
645      * - `to` cannot be the zero address.
646      * - `tokenId` token must be owned by `from`.
647      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
648      *
649      * Emits a {Transfer} event.
650      */
651     function transferFrom(
652         address from,
653         address to,
654         uint256 tokenId
655     ) external;
656 
657     /**
658      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
659      * The approval is cleared when the token is transferred.
660      *
661      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
662      *
663      * Requirements:
664      *
665      * - The caller must own the token or be an approved operator.
666      * - `tokenId` must exist.
667      *
668      * Emits an {Approval} event.
669      */
670     function approve(address to, uint256 tokenId) external;
671 
672     /**
673      * @dev Returns the account approved for `tokenId` token.
674      *
675      * Requirements:
676      *
677      * - `tokenId` must exist.
678      */
679     function getApproved(uint256 tokenId) external view returns (address operator);
680 
681     /**
682      * @dev Approve or remove `operator` as an operator for the caller.
683      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
684      *
685      * Requirements:
686      *
687      * - The `operator` cannot be the caller.
688      *
689      * Emits an {ApprovalForAll} event.
690      */
691     function setApprovalForAll(address operator, bool _approved) external;
692 
693     /**
694      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
695      *
696      * See {setApprovalForAll}
697      */
698     function isApprovedForAll(address owner, address operator) external view returns (bool);
699 
700     /**
701      * @dev Safely transfers `tokenId` token from `from` to `to`.
702      *
703      * Requirements:
704      *
705      * - `from` cannot be the zero address.
706      * - `to` cannot be the zero address.
707      * - `tokenId` token must exist and be owned by `from`.
708      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
709      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
710      *
711      * Emits a {Transfer} event.
712      */
713     function safeTransferFrom(
714         address from,
715         address to,
716         uint256 tokenId,
717         bytes calldata data
718     ) external;
719 }
720 
721 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
722 
723 
724 
725 pragma solidity ^0.8.0;
726 
727 
728 /**
729  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
730  * @dev See https://eips.ethereum.org/EIPS/eip-721
731  */
732 interface IERC721Metadata is IERC721 {
733     /**
734      * @dev Returns the token collection name.
735      */
736     function name() external view returns (string memory);
737 
738     /**
739      * @dev Returns the token collection symbol.
740      */
741     function symbol() external view returns (string memory);
742 
743     /**
744      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
745      */
746     function tokenURI(uint256 tokenId) external view returns (string memory);
747 }
748 
749 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
750 
751 
752 
753 pragma solidity ^0.8.0;
754 
755 
756 
757 
758 
759 
760 
761 
762 /**
763  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
764  * the Metadata extension, but not including the Enumerable extension, which is available separately as
765  * {ERC721Enumerable}.
766  */
767 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
768     using Address for address;
769     using Strings for uint256;
770 
771     // Token name
772     string private _name;
773 
774     // Token symbol
775     string private _symbol;
776 
777     // Mapping from token ID to owner address
778     mapping(uint256 => address) private _owners;
779 
780     // Mapping owner address to token count
781     mapping(address => uint256) private _balances;
782 
783     // Mapping from token ID to approved address
784     mapping(uint256 => address) private _tokenApprovals;
785 
786     // Mapping from owner to operator approvals
787     mapping(address => mapping(address => bool)) private _operatorApprovals;
788 
789     /**
790      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
791      */
792     constructor(string memory name_, string memory symbol_) {
793         _name = name_;
794         _symbol = symbol_;
795     }
796 
797     /**
798      * @dev See {IERC165-supportsInterface}.
799      */
800     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
801         return
802             interfaceId == type(IERC721).interfaceId ||
803             interfaceId == type(IERC721Metadata).interfaceId ||
804             super.supportsInterface(interfaceId);
805     }
806 
807     /**
808      * @dev See {IERC721-balanceOf}.
809      */
810     function balanceOf(address owner) public view virtual override returns (uint256) {
811         require(owner != address(0), "ERC721: balance query for the zero address");
812         return _balances[owner];
813     }
814 
815     /**
816      * @dev See {IERC721-ownerOf}.
817      */
818     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
819         address owner = _owners[tokenId];
820         require(owner != address(0), "ERC721: owner query for nonexistent token");
821         return owner;
822     }
823 
824     /**
825      * @dev See {IERC721Metadata-name}.
826      */
827     function name() public view virtual override returns (string memory) {
828         return _name;
829     }
830 
831     /**
832      * @dev See {IERC721Metadata-symbol}.
833      */
834     function symbol() public view virtual override returns (string memory) {
835         return _symbol;
836     }
837 
838     /**
839      * @dev See {IERC721Metadata-tokenURI}.
840      */
841     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
842         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
843 
844         string memory baseURI = _baseURI();
845         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
846     }
847 
848     /**
849      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
850      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
851      * by default, can be overriden in child contracts.
852      */
853     function _baseURI() internal view virtual returns (string memory) {
854         return "";
855     }
856 
857     /**
858      * @dev See {IERC721-approve}.
859      */
860     function approve(address to, uint256 tokenId) public virtual override {
861         address owner = ERC721.ownerOf(tokenId);
862         require(to != owner, "ERC721: approval to current owner");
863 
864         require(
865             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
866             "ERC721: approve caller is not owner nor approved for all"
867         );
868 
869         _approve(to, tokenId);
870     }
871 
872     /**
873      * @dev See {IERC721-getApproved}.
874      */
875     function getApproved(uint256 tokenId) public view virtual override returns (address) {
876         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
877 
878         return _tokenApprovals[tokenId];
879     }
880 
881     /**
882      * @dev See {IERC721-setApprovalForAll}.
883      */
884     function setApprovalForAll(address operator, bool approved) public virtual override {
885         require(operator != _msgSender(), "ERC721: approve to caller");
886 
887         _operatorApprovals[_msgSender()][operator] = approved;
888         emit ApprovalForAll(_msgSender(), operator, approved);
889     }
890 
891     /**
892      * @dev See {IERC721-isApprovedForAll}.
893      */
894     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
895         return _operatorApprovals[owner][operator];
896     }
897 
898     /**
899      * @dev See {IERC721-transferFrom}.
900      */
901     function transferFrom(
902         address from,
903         address to,
904         uint256 tokenId
905     ) public virtual override {
906         //solhint-disable-next-line max-line-length
907         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
908 
909         _transfer(from, to, tokenId);
910     }
911 
912     /**
913      * @dev See {IERC721-safeTransferFrom}.
914      */
915     function safeTransferFrom(
916         address from,
917         address to,
918         uint256 tokenId
919     ) public virtual override {
920         safeTransferFrom(from, to, tokenId, "");
921     }
922 
923     /**
924      * @dev See {IERC721-safeTransferFrom}.
925      */
926     function safeTransferFrom(
927         address from,
928         address to,
929         uint256 tokenId,
930         bytes memory _data
931     ) public virtual override {
932         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
933         _safeTransfer(from, to, tokenId, _data);
934     }
935 
936     /**
937      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
938      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
939      *
940      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
941      *
942      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
943      * implement alternative mechanisms to perform token transfer, such as signature-based.
944      *
945      * Requirements:
946      *
947      * - `from` cannot be the zero address.
948      * - `to` cannot be the zero address.
949      * - `tokenId` token must exist and be owned by `from`.
950      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
951      *
952      * Emits a {Transfer} event.
953      */
954     function _safeTransfer(
955         address from,
956         address to,
957         uint256 tokenId,
958         bytes memory _data
959     ) internal virtual {
960         _transfer(from, to, tokenId);
961         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
962     }
963 
964     /**
965      * @dev Returns whether `tokenId` exists.
966      *
967      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
968      *
969      * Tokens start existing when they are minted (`_mint`),
970      * and stop existing when they are burned (`_burn`).
971      */
972     function _exists(uint256 tokenId) internal view virtual returns (bool) {
973         return _owners[tokenId] != address(0);
974     }
975 
976     /**
977      * @dev Returns whether `spender` is allowed to manage `tokenId`.
978      *
979      * Requirements:
980      *
981      * - `tokenId` must exist.
982      */
983     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
984         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
985         address owner = ERC721.ownerOf(tokenId);
986         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
987     }
988 
989     /**
990      * @dev Safely mints `tokenId` and transfers it to `to`.
991      *
992      * Requirements:
993      *
994      * - `tokenId` must not exist.
995      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
996      *
997      * Emits a {Transfer} event.
998      */
999     function _safeMint(address to, uint256 tokenId) internal virtual {
1000         _safeMint(to, tokenId, "");
1001     }
1002 
1003     /**
1004      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1005      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1006      */
1007     function _safeMint(
1008         address to,
1009         uint256 tokenId,
1010         bytes memory _data
1011     ) internal virtual {
1012         _mint(to, tokenId);
1013         require(
1014             _checkOnERC721Received(address(0), to, tokenId, _data),
1015             "ERC721: transfer to non ERC721Receiver implementer"
1016         );
1017     }
1018 
1019     /**
1020      * @dev Mints `tokenId` and transfers it to `to`.
1021      *
1022      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1023      *
1024      * Requirements:
1025      *
1026      * - `tokenId` must not exist.
1027      * - `to` cannot be the zero address.
1028      *
1029      * Emits a {Transfer} event.
1030      */
1031     function _mint(address to, uint256 tokenId) internal virtual {
1032         require(to != address(0), "ERC721: mint to the zero address");
1033         require(!_exists(tokenId), "ERC721: token already minted");
1034 
1035         _beforeTokenTransfer(address(0), to, tokenId);
1036 
1037         _balances[to] += 1;
1038         _owners[tokenId] = to;
1039 
1040         emit Transfer(address(0), to, tokenId);
1041     }
1042 
1043     /**
1044      * @dev Destroys `tokenId`.
1045      * The approval is cleared when the token is burned.
1046      *
1047      * Requirements:
1048      *
1049      * - `tokenId` must exist.
1050      *
1051      * Emits a {Transfer} event.
1052      */
1053     function _burn(uint256 tokenId) internal virtual {
1054         address owner = ERC721.ownerOf(tokenId);
1055 
1056         _beforeTokenTransfer(owner, address(0), tokenId);
1057 
1058         // Clear approvals
1059         _approve(address(0), tokenId);
1060 
1061         _balances[owner] -= 1;
1062         delete _owners[tokenId];
1063 
1064         emit Transfer(owner, address(0), tokenId);
1065     }
1066 
1067     /**
1068      * @dev Transfers `tokenId` from `from` to `to`.
1069      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1070      *
1071      * Requirements:
1072      *
1073      * - `to` cannot be the zero address.
1074      * - `tokenId` token must be owned by `from`.
1075      *
1076      * Emits a {Transfer} event.
1077      */
1078     function _transfer(
1079         address from,
1080         address to,
1081         uint256 tokenId
1082     ) internal virtual {
1083         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1084         require(to != address(0), "ERC721: transfer to the zero address");
1085 
1086         _beforeTokenTransfer(from, to, tokenId);
1087 
1088         // Clear approvals from the previous owner
1089         _approve(address(0), tokenId);
1090 
1091         _balances[from] -= 1;
1092         _balances[to] += 1;
1093         _owners[tokenId] = to;
1094 
1095         emit Transfer(from, to, tokenId);
1096     }
1097 
1098     /**
1099      * @dev Approve `to` to operate on `tokenId`
1100      *
1101      * Emits a {Approval} event.
1102      */
1103     function _approve(address to, uint256 tokenId) internal virtual {
1104         _tokenApprovals[tokenId] = to;
1105         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1106     }
1107 
1108     /**
1109      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1110      * The call is not executed if the target address is not a contract.
1111      *
1112      * @param from address representing the previous owner of the given token ID
1113      * @param to target address that will receive the tokens
1114      * @param tokenId uint256 ID of the token to be transferred
1115      * @param _data bytes optional data to send along with the call
1116      * @return bool whether the call correctly returned the expected magic value
1117      */
1118     function _checkOnERC721Received(
1119         address from,
1120         address to,
1121         uint256 tokenId,
1122         bytes memory _data
1123     ) private returns (bool) {
1124         if (to.isContract()) {
1125             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1126                 return retval == IERC721Receiver.onERC721Received.selector;
1127             } catch (bytes memory reason) {
1128                 if (reason.length == 0) {
1129                     revert("ERC721: transfer to non ERC721Receiver implementer");
1130                 } else {
1131                     assembly {
1132                         revert(add(32, reason), mload(reason))
1133                     }
1134                 }
1135             }
1136         } else {
1137             return true;
1138         }
1139     }
1140 
1141     /**
1142      * @dev Hook that is called before any token transfer. This includes minting
1143      * and burning.
1144      *
1145      * Calling conditions:
1146      *
1147      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1148      * transferred to `to`.
1149      * - When `from` is zero, `tokenId` will be minted for `to`.
1150      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1151      * - `from` and `to` are never both zero.
1152      *
1153      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1154      */
1155     function _beforeTokenTransfer(
1156         address from,
1157         address to,
1158         uint256 tokenId
1159     ) internal virtual {}
1160 }
1161 
1162 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1163 
1164 
1165 
1166 pragma solidity ^0.8.0;
1167 
1168 
1169 /**
1170  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1171  * @dev See https://eips.ethereum.org/EIPS/eip-721
1172  */
1173 interface IERC721Enumerable is IERC721 {
1174     /**
1175      * @dev Returns the total amount of tokens stored by the contract.
1176      */
1177     function totalSupply() external view returns (uint256);
1178 
1179     /**
1180      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1181      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1182      */
1183     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1184 
1185     /**
1186      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1187      * Use along with {totalSupply} to enumerate all tokens.
1188      */
1189     function tokenByIndex(uint256 index) external view returns (uint256);
1190 }
1191 
1192 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1193 
1194 
1195 
1196 pragma solidity ^0.8.0;
1197 
1198 
1199 
1200 /**
1201  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1202  * enumerability of all the token ids in the contract as well as all token ids owned by each
1203  * account.
1204  */
1205 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1206     // Mapping from owner to list of owned token IDs
1207     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1208 
1209     // Mapping from token ID to index of the owner tokens list
1210     mapping(uint256 => uint256) private _ownedTokensIndex;
1211 
1212     // Array with all token ids, used for enumeration
1213     uint256[] private _allTokens;
1214 
1215     // Mapping from token id to position in the allTokens array
1216     mapping(uint256 => uint256) private _allTokensIndex;
1217 
1218     /**
1219      * @dev See {IERC165-supportsInterface}.
1220      */
1221     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1222         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1223     }
1224 
1225     /**
1226      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1227      */
1228     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1229         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1230         return _ownedTokens[owner][index];
1231     }
1232 
1233     /**
1234      * @dev See {IERC721Enumerable-totalSupply}.
1235      */
1236     function totalSupply() public view virtual override returns (uint256) {
1237         return _allTokens.length;
1238     }
1239 
1240     /**
1241      * @dev See {IERC721Enumerable-tokenByIndex}.
1242      */
1243     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1244         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1245         return _allTokens[index];
1246     }
1247 
1248     /**
1249      * @dev Hook that is called before any token transfer. This includes minting
1250      * and burning.
1251      *
1252      * Calling conditions:
1253      *
1254      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1255      * transferred to `to`.
1256      * - When `from` is zero, `tokenId` will be minted for `to`.
1257      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1258      * - `from` cannot be the zero address.
1259      * - `to` cannot be the zero address.
1260      *
1261      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1262      */
1263     function _beforeTokenTransfer(
1264         address from,
1265         address to,
1266         uint256 tokenId
1267     ) internal virtual override {
1268         super._beforeTokenTransfer(from, to, tokenId);
1269 
1270         if (from == address(0)) {
1271             _addTokenToAllTokensEnumeration(tokenId);
1272         } else if (from != to) {
1273             _removeTokenFromOwnerEnumeration(from, tokenId);
1274         }
1275         if (to == address(0)) {
1276             _removeTokenFromAllTokensEnumeration(tokenId);
1277         } else if (to != from) {
1278             _addTokenToOwnerEnumeration(to, tokenId);
1279         }
1280     }
1281 
1282     /**
1283      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1284      * @param to address representing the new owner of the given token ID
1285      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1286      */
1287     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1288         uint256 length = ERC721.balanceOf(to);
1289         _ownedTokens[to][length] = tokenId;
1290         _ownedTokensIndex[tokenId] = length;
1291     }
1292 
1293     /**
1294      * @dev Private function to add a token to this extension's token tracking data structures.
1295      * @param tokenId uint256 ID of the token to be added to the tokens list
1296      */
1297     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1298         _allTokensIndex[tokenId] = _allTokens.length;
1299         _allTokens.push(tokenId);
1300     }
1301 
1302     /**
1303      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1304      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1305      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1306      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1307      * @param from address representing the previous owner of the given token ID
1308      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1309      */
1310     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1311         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1312         // then delete the last slot (swap and pop).
1313 
1314         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1315         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1316 
1317         // When the token to delete is the last token, the swap operation is unnecessary
1318         if (tokenIndex != lastTokenIndex) {
1319             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1320 
1321             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1322             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1323         }
1324 
1325         // This also deletes the contents at the last position of the array
1326         delete _ownedTokensIndex[tokenId];
1327         delete _ownedTokens[from][lastTokenIndex];
1328     }
1329 
1330     /**
1331      * @dev Private function to remove a token from this extension's token tracking data structures.
1332      * This has O(1) time complexity, but alters the order of the _allTokens array.
1333      * @param tokenId uint256 ID of the token to be removed from the tokens list
1334      */
1335     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1336         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1337         // then delete the last slot (swap and pop).
1338 
1339         uint256 lastTokenIndex = _allTokens.length - 1;
1340         uint256 tokenIndex = _allTokensIndex[tokenId];
1341 
1342         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1343         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1344         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1345         uint256 lastTokenId = _allTokens[lastTokenIndex];
1346 
1347         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1348         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1349 
1350         // This also deletes the contents at the last position of the array
1351         delete _allTokensIndex[tokenId];
1352         _allTokens.pop();
1353     }
1354 }
1355 
1356 // File: contracts/Phantoms.sol
1357 
1358 
1359 pragma solidity ^0.8.0;
1360 
1361 
1362 contract Phantoms is Ownable, ERC721Enumerable {
1363 
1364     using Strings for uint256;
1365     using BitMaps for BitMaps.BitMap;
1366 
1367     uint256 public onAuction; // of tokens put on auction
1368     string public sourceCode;
1369     mapping (address => bool) private _participated; //only for DA    
1370     BitMaps.BitMap private _spectralClaimed;  
1371     IERC721Enumerable private _spectrals = IERC721Enumerable(0xc29EecF43C89071fA2e8fEbBbbaD86c14D7F4C44); 
1372     bytes32 private _merkleRoot = 0xc85d1b056eb792ee2dc79028b11688b34c785a490b2252e5e9722a56ac1e14cd;
1373     string private _baseTokenURI;
1374     
1375     mapping (address => bool) private _claimed;
1376     
1377     constructor(uint256 quantityToAuction) ERC721("Phantoms", "PHTM") {
1378         onAuction = quantityToAuction;
1379     }
1380 
1381     function withdraw() onlyOwner public {
1382         Address.sendValue(payable(owner()), address(this).balance);
1383     }
1384 
1385     function _baseURI() internal view override returns (string memory) {
1386         return _baseTokenURI;
1387     }
1388 
1389     function setBaseURI(string memory baseTokenURI) onlyOwner public {
1390         _baseTokenURI = baseTokenURI;
1391     }
1392 
1393     function setMerkleProof(bytes32 root) onlyOwner public {
1394         _merkleRoot = root;
1395     }
1396 
1397     function uploadSourceCode(string calldata code) onlyOwner public {
1398         sourceCode = code;
1399     }
1400 
1401     uint256 public constant phantomPrice = 40000000000000000;
1402     bool public auctionState = false;
1403     uint256 public merkleClaimed = 0;
1404     uint256 public dutchClaimed = 0;
1405     uint256 startingPrice;
1406     uint64 startingBlock;
1407     uint64 decreasingConstant;
1408     uint64 period; //period (in blocks) during which price will decrease
1409 
1410     function setAuction(uint256 startingPrice_, uint64 startingBlock_, uint64 decreasingConstant_, uint64 period_) onlyOwner public {
1411         startingPrice = startingPrice_;
1412         startingBlock = startingBlock_;
1413         decreasingConstant = decreasingConstant_;
1414         period = period_;
1415     }
1416     
1417     function getPrice() public view returns (uint256) {
1418         uint256 price = startingPrice;
1419         if (block.number <= startingBlock) return price;
1420         uint256 floorPrice = price - period * decreasingConstant;
1421         unchecked {
1422             price -= decreasingConstant * (block.number - startingBlock);
1423         }
1424         return price >= floorPrice && price <= startingPrice ? price : floorPrice;
1425     }
1426 
1427     function verifyBid() internal returns (uint256) {
1428         require(startingBlock > 0, "AUCTION:NOT CREATED");
1429         require(block.number >= startingBlock, "PURCHASE:AUCTION NOT STARTED");
1430         uint256 price = getPrice();
1431         require(msg.value >= price, "PURCHASE:INCORRECT MSG.VALUE");
1432         if (msg.value - price > 0) Address.sendValue(payable(msg.sender), msg.value-price); //refund difference
1433         return price;
1434     }
1435 
1436     function ownerMint(address to) onlyOwner public {
1437         _safeMint(to, totalSupply());
1438     }
1439 
1440     function merkleClaim(bytes32[] calldata proof) public payable {
1441         require(!_claimed[msg.sender], "already claimed");
1442         _claimed[msg.sender] = true;
1443         bytes32 node = keccak256(abi.encodePacked(msg.sender));
1444         require(MerkleProof.verify(proof, _merkleRoot, node), "invalid proof");
1445         require(msg.value >= phantomPrice, "not enough");
1446         _safeMint(msg.sender, totalSupply());
1447         merkleClaimed++;
1448     }
1449 
1450     function bid() public payable {
1451         require(!Address.isContract(msg.sender), "is a contract");
1452         require(onAuction > 0, "sold out");
1453         require(!_participated[msg.sender], "already bought one");
1454         onAuction--;
1455         require(_spectrals.balanceOf(msg.sender) > 0, "no spectrals owned");
1456         uint256 paid = verifyBid();
1457         _safeMint(msg.sender, totalSupply());
1458         _participated[msg.sender] = true;
1459         payout(paid);
1460         dutchClaimed++;
1461     }
1462     
1463     function payout(uint256 amount) internal {
1464         Address.sendValue(payable(owner()), amount);
1465     }
1466 
1467     function flipAuctionState() public onlyOwner {
1468         auctionState = !auctionState;
1469     }
1470 
1471     function burn(uint256 tokenId) public {
1472         require(_isApprovedOrOwner(_msgSender(), tokenId), "BURN:CALLER ISN'T OWNER OR APPROVED");
1473         super._burn(tokenId);
1474     }
1475 
1476     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1477         return string(abi.encodePacked(_baseURI(), "/", tokenId.toString()));
1478     }
1479 
1480     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721Enumerable) {
1481         super._beforeTokenTransfer(from, to, tokenId);
1482     }
1483 
1484     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Enumerable) returns (bool) {
1485         return super.supportsInterface(interfaceId);
1486     }
1487 }