1 //SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 library MerkleProof {
5     /**
6      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
7      * defined by `root`. For this, a `proof` must be provided, containing
8      * sibling hashes on the branch from the leaf to the root of the tree. Each
9      * pair of leaves and each pair of pre-images are assumed to be sorted.
10      */
11     function verify(
12         bytes32[] memory proof,
13         bytes32 root,
14         bytes32 leaf
15     ) internal pure returns (bool) {
16         return processProof(proof, leaf) == root;
17     }
18 
19     /**
20      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
21      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
22      * hash matches the root of the tree. When processing the proof, the pairs
23      * of leafs & pre-images are assumed to be sorted.
24      *
25      * _Available since v4.4._
26      */
27     function processProof(bytes32[] memory proof, bytes32 leaf)
28         internal
29         pure
30         returns (bytes32)
31     {
32         bytes32 computedHash = leaf;
33         for (uint256 i = 0; i < proof.length; i++) {
34             bytes32 proofElement = proof[i];
35             if (computedHash <= proofElement) {
36                 // Hash(current computed hash + current element of the proof)
37                 computedHash = _efficientHash(computedHash, proofElement);
38             } else {
39                 // Hash(current element of the proof + current computed hash)
40                 computedHash = _efficientHash(proofElement, computedHash);
41             }
42         }
43         return computedHash;
44     }
45 
46     function _efficientHash(bytes32 a, bytes32 b)
47         private
48         pure
49         returns (bytes32 value)
50     {
51         assembly {
52             mstore(0x00, a)
53             mstore(0x20, b)
54             value := keccak256(0x00, 0x40)
55         }
56     }
57 }
58 
59 library Strings {
60     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
64      */
65     function toString(uint256 value) internal pure returns (string memory) {
66         // Inspired by OraclizeAPI's implementation - MIT licence
67         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
68 
69         if (value == 0) {
70             return "0";
71         }
72         uint256 temp = value;
73         uint256 digits;
74         while (temp != 0) {
75             digits++;
76             temp /= 10;
77         }
78         bytes memory buffer = new bytes(digits);
79         while (value != 0) {
80             digits -= 1;
81             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
82             value /= 10;
83         }
84         return string(buffer);
85     }
86 
87     /**
88      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
89      */
90     function toHexString(uint256 value) internal pure returns (string memory) {
91         if (value == 0) {
92             return "0x00";
93         }
94         uint256 temp = value;
95         uint256 length = 0;
96         while (temp != 0) {
97             length++;
98             temp >>= 8;
99         }
100         return toHexString(value, length);
101     }
102 
103     /**
104      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
105      */
106     function toHexString(uint256 value, uint256 length)
107         internal
108         pure
109         returns (string memory)
110     {
111         bytes memory buffer = new bytes(2 * length + 2);
112         buffer[0] = "0";
113         buffer[1] = "x";
114         for (uint256 i = 2 * length + 1; i > 1; --i) {
115             buffer[i] = _HEX_SYMBOLS[value & 0xf];
116             value >>= 4;
117         }
118         require(value == 0, "Strings: hex length insufficient");
119         return string(buffer);
120     }
121 }
122 
123 abstract contract Context {
124     function _msgSender() internal view virtual returns (address) {
125         return msg.sender;
126     }
127 
128     function _msgData() internal view virtual returns (bytes calldata) {
129         return msg.data;
130     }
131 }
132 
133 abstract contract Ownable is Context {
134     address private _owner;
135 
136     event OwnershipTransferred(
137         address indexed previousOwner,
138         address indexed newOwner
139     );
140 
141     /**
142      * @dev Initializes the contract setting the deployer as the initial owner.
143      */
144     constructor() {
145         _transferOwnership(_msgSender());
146     }
147 
148     /**
149      * @dev Returns the address of the current owner.
150      */
151     function owner() public view virtual returns (address) {
152         return _owner;
153     }
154 
155     /**
156      * @dev Throws if called by any account other than the owner.
157      */
158     modifier onlyOwner() {
159         require(owner() == _msgSender(), "Ownable: caller is not the owner");
160         _;
161     }
162 
163     /**
164      * @dev Leaves the contract without owner. It will not be possible to call
165      * `onlyOwner` functions anymore. Can only be called by the current owner.
166      *
167      * NOTE: Renouncing ownership will leave the contract without an owner,
168      * thereby removing any functionality that is only available to the owner.
169      */
170     function renounceOwnership() public virtual onlyOwner {
171         _transferOwnership(address(0));
172     }
173 
174     /**
175      * @dev Transfers ownership of the contract to a new account (`newOwner`).
176      * Can only be called by the current owner.
177      */
178     function transferOwnership(address newOwner) public virtual onlyOwner {
179         require(
180             newOwner != address(0),
181             "Ownable: new owner is the zero address"
182         );
183         _transferOwnership(newOwner);
184     }
185 
186     /**
187      * @dev Transfers ownership of the contract to a new account (`newOwner`).
188      * Internal function without access restriction.
189      */
190     function _transferOwnership(address newOwner) internal virtual {
191         address oldOwner = _owner;
192         _owner = newOwner;
193         emit OwnershipTransferred(oldOwner, newOwner);
194     }
195 }
196 
197 library Address {
198     /**
199      * @dev Returns true if `account` is a contract.
200      *
201      * [IMPORTANT]
202      * ====
203      * It is unsafe to assume that an address for which this function returns
204      * false is an externally-owned account (EOA) and not a contract.
205      *
206      * Among others, `isContract` will return false for the following
207      * types of addresses:
208      *
209      *  - an externally-owned account
210      *  - a contract in construction
211      *  - an address where a contract will be created
212      *  - an address where a contract lived, but was destroyed
213      * ====
214      *
215      * [IMPORTANT]
216      * ====
217      * You shouldn't rely on `isContract` to protect against flash loan attacks!
218      *
219      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
220      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
221      * constructor.
222      * ====
223      */
224     function isContract(address account) internal view returns (bool) {
225         // This method relies on extcodesize/address.code.length, which returns 0
226         // for contracts in construction, since the code is only stored at the end
227         // of the constructor execution.
228 
229         return account.code.length > 0;
230     }
231 
232     /**
233      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
234      * `recipient`, forwarding all available gas and reverting on errors.
235      *
236      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
237      * of certain opcodes, possibly making contracts go over the 2300 gas limit
238      * imposed by `transfer`, making them unable to receive funds via
239      * `transfer`. {sendValue} removes this limitation.
240      *
241      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
242      *
243      * IMPORTANT: because control is transferred to `recipient`, care must be
244      * taken to not create reentrancy vulnerabilities. Consider using
245      * {ReentrancyGuard} or the
246      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
247      */
248     function sendValue(address payable recipient, uint256 amount) internal {
249         require(
250             address(this).balance >= amount,
251             "Address: insufficient balance"
252         );
253 
254         (bool success, ) = recipient.call{value: amount}("");
255         require(
256             success,
257             "Address: unable to send value, recipient may have reverted"
258         );
259     }
260 
261     /**
262      * @dev Performs a Solidity function call using a low level `call`. A
263      * plain `call` is an unsafe replacement for a function call: use this
264      * function instead.
265      *
266      * If `target` reverts with a revert reason, it is bubbled up by this
267      * function (like regular Solidity function calls).
268      *
269      * Returns the raw returned data. To convert to the expected return value,
270      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
271      *
272      * Requirements:
273      *
274      * - `target` must be a contract.
275      * - calling `target` with `data` must not revert.
276      *
277      * _Available since v3.1._
278      */
279     function functionCall(address target, bytes memory data)
280         internal
281         returns (bytes memory)
282     {
283         return functionCall(target, data, "Address: low-level call failed");
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
288      * `errorMessage` as a fallback revert reason when `target` reverts.
289      *
290      * _Available since v3.1._
291      */
292     function functionCall(
293         address target,
294         bytes memory data,
295         string memory errorMessage
296     ) internal returns (bytes memory) {
297         return functionCallWithValue(target, data, 0, errorMessage);
298     }
299 
300     /**
301      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
302      * but also transferring `value` wei to `target`.
303      *
304      * Requirements:
305      *
306      * - the calling contract must have an ETH balance of at least `value`.
307      * - the called Solidity function must be `payable`.
308      *
309      * _Available since v3.1._
310      */
311     function functionCallWithValue(
312         address target,
313         bytes memory data,
314         uint256 value
315     ) internal returns (bytes memory) {
316         return
317             functionCallWithValue(
318                 target,
319                 data,
320                 value,
321                 "Address: low-level call with value failed"
322             );
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
327      * with `errorMessage` as a fallback revert reason when `target` reverts.
328      *
329      * _Available since v3.1._
330      */
331     function functionCallWithValue(
332         address target,
333         bytes memory data,
334         uint256 value,
335         string memory errorMessage
336     ) internal returns (bytes memory) {
337         require(
338             address(this).balance >= value,
339             "Address: insufficient balance for call"
340         );
341         require(isContract(target), "Address: call to non-contract");
342 
343         (bool success, bytes memory returndata) = target.call{value: value}(
344             data
345         );
346         return verifyCallResult(success, returndata, errorMessage);
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
351      * but performing a static call.
352      *
353      * _Available since v3.3._
354      */
355     function functionStaticCall(address target, bytes memory data)
356         internal
357         view
358         returns (bytes memory)
359     {
360         return
361             functionStaticCall(
362                 target,
363                 data,
364                 "Address: low-level static call failed"
365             );
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
370      * but performing a static call.
371      *
372      * _Available since v3.3._
373      */
374     function functionStaticCall(
375         address target,
376         bytes memory data,
377         string memory errorMessage
378     ) internal view returns (bytes memory) {
379         require(isContract(target), "Address: static call to non-contract");
380 
381         (bool success, bytes memory returndata) = target.staticcall(data);
382         return verifyCallResult(success, returndata, errorMessage);
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
387      * but performing a delegate call.
388      *
389      * _Available since v3.4._
390      */
391     function functionDelegateCall(address target, bytes memory data)
392         internal
393         returns (bytes memory)
394     {
395         return
396             functionDelegateCall(
397                 target,
398                 data,
399                 "Address: low-level delegate call failed"
400             );
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
405      * but performing a delegate call.
406      *
407      * _Available since v3.4._
408      */
409     function functionDelegateCall(
410         address target,
411         bytes memory data,
412         string memory errorMessage
413     ) internal returns (bytes memory) {
414         require(isContract(target), "Address: delegate call to non-contract");
415 
416         (bool success, bytes memory returndata) = target.delegatecall(data);
417         return verifyCallResult(success, returndata, errorMessage);
418     }
419 
420     /**
421      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
422      * revert reason using the provided one.
423      *
424      * _Available since v4.3._
425      */
426     function verifyCallResult(
427         bool success,
428         bytes memory returndata,
429         string memory errorMessage
430     ) internal pure returns (bytes memory) {
431         if (success) {
432             return returndata;
433         } else {
434             // Look for revert reason and bubble it up if present
435             if (returndata.length > 0) {
436                 // The easiest way to bubble the revert reason is using memory via assembly
437 
438                 assembly {
439                     let returndata_size := mload(returndata)
440                     revert(add(32, returndata), returndata_size)
441                 }
442             } else {
443                 revert(errorMessage);
444             }
445         }
446     }
447 }
448 
449 interface IERC721A {
450     /**
451      * The caller must own the token or be an approved operator.
452      */
453     error ApprovalCallerNotOwnerNorApproved();
454 
455     /**
456      * The token does not exist.
457      */
458     error ApprovalQueryForNonexistentToken();
459 
460     /**
461      * The caller cannot approve to their own address.
462      */
463     error ApproveToCaller();
464 
465     /**
466      * Cannot query the balance for the zero address.
467      */
468     error BalanceQueryForZeroAddress();
469 
470     /**
471      * Cannot mint to the zero address.
472      */
473     error MintToZeroAddress();
474 
475     /**
476      * The quantity of tokens minted must be more than zero.
477      */
478     error MintZeroQuantity();
479 
480     /**
481      * The token does not exist.
482      */
483     error OwnerQueryForNonexistentToken();
484 
485     /**
486      * The caller must own the token or be an approved operator.
487      */
488     error TransferCallerNotOwnerNorApproved();
489 
490     /**
491      * The token must be owned by `from`.
492      */
493     error TransferFromIncorrectOwner();
494 
495     /**
496      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
497      */
498     error TransferToNonERC721ReceiverImplementer();
499 
500     /**
501      * Cannot transfer to the zero address.
502      */
503     error TransferToZeroAddress();
504 
505     /**
506      * The token does not exist.
507      */
508     error URIQueryForNonexistentToken();
509 
510     /**
511      * The `quantity` minted with ERC2309 exceeds the safety limit.
512      */
513     error MintERC2309QuantityExceedsLimit();
514 
515     /**
516      * The `extraData` cannot be set on an unintialized ownership slot.
517      */
518     error OwnershipNotInitializedForExtraData();
519 
520     struct TokenOwnership {
521         // The address of the owner.
522         address addr;
523         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
524         uint64 startTimestamp;
525         // Whether the token has been burned.
526         bool burned;
527         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
528         uint24 extraData;
529     }
530 
531     /**
532      * @dev Returns the total amount of tokens stored by the contract.
533      *
534      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
535      */
536     function totalSupply() external view returns (uint256);
537 
538     // ==============================
539     //            IERC165
540     // ==============================
541 
542     /**
543      * @dev Returns true if this contract implements the interface defined by
544      * `interfaceId`. See the corresponding
545      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
546      * to learn more about how these ids are created.
547      *
548      * This function call must use less than 30 000 gas.
549      */
550     function supportsInterface(bytes4 interfaceId) external view returns (bool);
551 
552     // ==============================
553     //            IERC721
554     // ==============================
555 
556     /**
557      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
558      */
559     event Transfer(
560         address indexed from,
561         address indexed to,
562         uint256 indexed tokenId
563     );
564 
565     /**
566      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
567      */
568     event Approval(
569         address indexed owner,
570         address indexed approved,
571         uint256 indexed tokenId
572     );
573 
574     /**
575      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
576      */
577     event ApprovalForAll(
578         address indexed owner,
579         address indexed operator,
580         bool approved
581     );
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
598      * @dev Safely transfers `tokenId` token from `from` to `to`.
599      *
600      * Requirements:
601      *
602      * - `from` cannot be the zero address.
603      * - `to` cannot be the zero address.
604      * - `tokenId` token must exist and be owned by `from`.
605      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
606      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
607      *
608      * Emits a {Transfer} event.
609      */
610     function safeTransferFrom(
611         address from,
612         address to,
613         uint256 tokenId,
614         bytes calldata data
615     ) external;
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
673      * @dev Approve or remove `operator` as an operator for the caller.
674      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
675      *
676      * Requirements:
677      *
678      * - The `operator` cannot be the caller.
679      *
680      * Emits an {ApprovalForAll} event.
681      */
682     function setApprovalForAll(address operator, bool _approved) external;
683 
684     /**
685      * @dev Returns the account approved for `tokenId` token.
686      *
687      * Requirements:
688      *
689      * - `tokenId` must exist.
690      */
691     function getApproved(uint256 tokenId)
692         external
693         view
694         returns (address operator);
695 
696     /**
697      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
698      *
699      * See {setApprovalForAll}
700      */
701     function isApprovedForAll(address owner, address operator)
702         external
703         view
704         returns (bool);
705 
706     // ==============================
707     //        IERC721Metadata
708     // ==============================
709 
710     /**
711      * @dev Returns the token collection name.
712      */
713     function name() external view returns (string memory);
714 
715     /**
716      * @dev Returns the token collection symbol.
717      */
718     function symbol() external view returns (string memory);
719 
720     /**
721      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
722      */
723     function tokenURI(uint256 tokenId) external view returns (string memory);
724 
725     // ==============================
726     //            IERC2309
727     // ==============================
728 
729     /**
730      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
731      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
732      */
733     event ConsecutiveTransfer(
734         uint256 indexed fromTokenId,
735         uint256 toTokenId,
736         address indexed from,
737         address indexed to
738     );
739 }
740 
741 interface ERC721A__IERC721Receiver {
742     function onERC721Received(
743         address operator,
744         address from,
745         uint256 tokenId,
746         bytes calldata data
747     ) external returns (bytes4);
748 }
749 
750 contract ERC721A is IERC721A {
751     // Mask of an entry in packed address data.
752     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
753 
754     // The bit position of `numberMinted` in packed address data.
755     uint256 private constant BITPOS_NUMBER_MINTED = 64;
756 
757     // The bit position of `numberBurned` in packed address data.
758     uint256 private constant BITPOS_NUMBER_BURNED = 128;
759 
760     // The bit position of `aux` in packed address data.
761     uint256 private constant BITPOS_AUX = 192;
762 
763     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
764     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
765 
766     // The bit position of `startTimestamp` in packed ownership.
767     uint256 private constant BITPOS_START_TIMESTAMP = 160;
768 
769     // The bit mask of the `burned` bit in packed ownership.
770     uint256 private constant BITMASK_BURNED = 1 << 224;
771 
772     // The bit position of the `nextInitialized` bit in packed ownership.
773     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
774 
775     // The bit mask of the `nextInitialized` bit in packed ownership.
776     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
777 
778     // The bit position of `extraData` in packed ownership.
779     uint256 private constant BITPOS_EXTRA_DATA = 232;
780 
781     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
782     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
783 
784     // The mask of the lower 160 bits for addresses.
785     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
786 
787     // The maximum `quantity` that can be minted with `_mintERC2309`.
788     // This limit is to prevent overflows on the address data entries.
789     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
790     // is required to cause an overflow, which is unrealistic.
791     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
792 
793     // The tokenId of the next token to be minted.
794     uint256 private _currentIndex;
795 
796     // The number of tokens burned.
797     uint256 private _burnCounter;
798 
799     // Token name
800     string private _name;
801 
802     // Token symbol
803     string private _symbol;
804 
805     // Mapping from token ID to ownership details
806     // An empty struct value does not necessarily mean the token is unowned.
807     // See `_packedOwnershipOf` implementation for details.
808     //
809     // Bits Layout:
810     // - [0..159]   `addr`
811     // - [160..223] `startTimestamp`
812     // - [224]      `burned`
813     // - [225]      `nextInitialized`
814     // - [232..255] `extraData`
815     mapping(uint256 => uint256) private _packedOwnerships;
816 
817     // Mapping owner address to address data.
818     //
819     // Bits Layout:
820     // - [0..63]    `balance`
821     // - [64..127]  `numberMinted`
822     // - [128..191] `numberBurned`
823     // - [192..255] `aux`
824     mapping(address => uint256) private _packedAddressData;
825 
826     // Mapping from token ID to approved address.
827     mapping(uint256 => address) private _tokenApprovals;
828 
829     // Mapping from owner to operator approvals
830     mapping(address => mapping(address => bool)) private _operatorApprovals;
831 
832     constructor(string memory name_, string memory symbol_) {
833         _name = name_;
834         _symbol = symbol_;
835         _currentIndex = _startTokenId();
836     }
837 
838     /**
839      * @dev Returns the starting token ID.
840      * To change the starting token ID, please override this function.
841      */
842     function _startTokenId() internal view virtual returns (uint256) {
843         return 1;
844     }
845 
846     /**
847      * @dev Returns the next token ID to be minted.
848      */
849     function _nextTokenId() internal view returns (uint256) {
850         return _currentIndex;
851     }
852 
853     /**
854      * @dev Returns the total number of tokens in existence.
855      * Burned tokens will reduce the count.
856      * To get the total number of tokens minted, please see `_totalMinted`.
857      */
858     function totalSupply() public view override returns (uint256) {
859         // Counter underflow is impossible as _burnCounter cannot be incremented
860         // more than `_currentIndex - _startTokenId()` times.
861         unchecked {
862             return _currentIndex - _burnCounter - _startTokenId();
863         }
864     }
865 
866     /**
867      * @dev Returns the total amount of tokens minted in the contract.
868      */
869     function _totalMinted() internal view returns (uint256) {
870         // Counter underflow is impossible as _currentIndex does not decrement,
871         // and it is initialized to `_startTokenId()`
872         unchecked {
873             return _currentIndex - _startTokenId();
874         }
875     }
876 
877     /**
878      * @dev Returns the total number of tokens burned.
879      */
880     function _totalBurned() internal view returns (uint256) {
881         return _burnCounter;
882     }
883 
884     /**
885      * @dev See {IERC165-supportsInterface}.
886      */
887     function supportsInterface(bytes4 interfaceId)
888         public
889         view
890         virtual
891         override
892         returns (bool)
893     {
894         // The interface IDs are constants representing the first 4 bytes of the XOR of
895         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
896         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
897         return
898             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
899             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
900             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
901     }
902 
903     /**
904      * @dev See {IERC721-balanceOf}.
905      */
906     function balanceOf(address owner) public view override returns (uint256) {
907         if (owner == address(0)) revert BalanceQueryForZeroAddress();
908         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
909     }
910 
911     /**
912      * Returns the number of tokens minted by `owner`.
913      */
914     function _numberMinted(address owner) internal view returns (uint256) {
915         return
916             (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) &
917             BITMASK_ADDRESS_DATA_ENTRY;
918     }
919 
920     /**
921      * Returns the number of tokens burned by or on behalf of `owner`.
922      */
923     function _numberBurned(address owner) internal view returns (uint256) {
924         return
925             (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) &
926             BITMASK_ADDRESS_DATA_ENTRY;
927     }
928 
929     /**
930      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
931      */
932     function _getAux(address owner) internal view returns (uint64) {
933         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
934     }
935 
936     /**
937      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
938      * If there are multiple variables, please pack them into a uint64.
939      */
940     function _setAux(address owner, uint64 aux) internal {
941         uint256 packed = _packedAddressData[owner];
942         uint256 auxCasted;
943         // Cast `aux` with assembly to avoid redundant masking.
944         assembly {
945             auxCasted := aux
946         }
947         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
948         _packedAddressData[owner] = packed;
949     }
950 
951     /**
952      * Returns the packed ownership data of `tokenId`.
953      */
954     function _packedOwnershipOf(uint256 tokenId)
955         private
956         view
957         returns (uint256)
958     {
959         uint256 curr = tokenId;
960 
961         unchecked {
962             if (_startTokenId() <= curr)
963                 if (curr < _currentIndex) {
964                     uint256 packed = _packedOwnerships[curr];
965                     // If not burned.
966                     if (packed & BITMASK_BURNED == 0) {
967                         // Invariant:
968                         // There will always be an ownership that has an address and is not burned
969                         // before an ownership that does not have an address and is not burned.
970                         // Hence, curr will not underflow.
971                         //
972                         // We can directly compare the packed value.
973                         // If the address is zero, packed is zero.
974                         while (packed == 0) {
975                             packed = _packedOwnerships[--curr];
976                         }
977                         return packed;
978                     }
979                 }
980         }
981         revert OwnerQueryForNonexistentToken();
982     }
983 
984     /**
985      * Returns the unpacked `TokenOwnership` struct from `packed`.
986      */
987     function _unpackedOwnership(uint256 packed)
988         private
989         pure
990         returns (TokenOwnership memory ownership)
991     {
992         ownership.addr = address(uint160(packed));
993         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
994         ownership.burned = packed & BITMASK_BURNED != 0;
995         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
996     }
997 
998     /**
999      * Returns the unpacked `TokenOwnership` struct at `index`.
1000      */
1001     function _ownershipAt(uint256 index)
1002         internal
1003         view
1004         returns (TokenOwnership memory)
1005     {
1006         return _unpackedOwnership(_packedOwnerships[index]);
1007     }
1008 
1009     /**
1010      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1011      */
1012     function _initializeOwnershipAt(uint256 index) internal {
1013         if (_packedOwnerships[index] == 0) {
1014             _packedOwnerships[index] = _packedOwnershipOf(index);
1015         }
1016     }
1017 
1018     /**
1019      * Gas spent here starts off proportional to the maximum mint batch size.
1020      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1021      */
1022     function _ownershipOf(uint256 tokenId)
1023         internal
1024         view
1025         returns (TokenOwnership memory)
1026     {
1027         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1028     }
1029 
1030     /**
1031      * @dev Packs ownership data into a single uint256.
1032      */
1033     function _packOwnershipData(address owner, uint256 flags)
1034         private
1035         view
1036         returns (uint256 result)
1037     {
1038         assembly {
1039             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1040             owner := and(owner, BITMASK_ADDRESS)
1041             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
1042             result := or(
1043                 owner,
1044                 or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags)
1045             )
1046         }
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-ownerOf}.
1051      */
1052     function ownerOf(uint256 tokenId) public view override returns (address) {
1053         return address(uint160(_packedOwnershipOf(tokenId)));
1054     }
1055 
1056     /**
1057      * @dev See {IERC721Metadata-name}.
1058      */
1059     function name() public view virtual override returns (string memory) {
1060         return _name;
1061     }
1062 
1063     /**
1064      * @dev See {IERC721Metadata-symbol}.
1065      */
1066     function symbol() public view virtual override returns (string memory) {
1067         return _symbol;
1068     }
1069 
1070     /**
1071      * @dev See {IERC721Metadata-tokenURI}.
1072      */
1073     function tokenURI(uint256 tokenId)
1074         public
1075         view
1076         virtual
1077         override
1078         returns (string memory)
1079     {
1080         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1081 
1082         string memory baseURI = _baseURI();
1083         return
1084             bytes(baseURI).length != 0
1085                 ? string(abi.encodePacked(baseURI, _toString(tokenId)))
1086                 : "";
1087     }
1088 
1089     /**
1090      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1091      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1092      * by default, it can be overridden in child contracts.
1093      */
1094     function _baseURI() internal view virtual returns (string memory) {
1095         return "";
1096     }
1097 
1098     /**
1099      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1100      */
1101     function _nextInitializedFlag(uint256 quantity)
1102         private
1103         pure
1104         returns (uint256 result)
1105     {
1106         // For branchless setting of the `nextInitialized` flag.
1107         assembly {
1108             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1109             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1110         }
1111     }
1112 
1113     /**
1114      * @dev See {IERC721-approve}.
1115      */
1116     function approve(address to, uint256 tokenId) public override {
1117         address owner = ownerOf(tokenId);
1118 
1119         if (_msgSenderERC721A() != owner)
1120             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1121                 revert ApprovalCallerNotOwnerNorApproved();
1122             }
1123 
1124         _tokenApprovals[tokenId] = to;
1125         emit Approval(owner, to, tokenId);
1126     }
1127 
1128     /**
1129      * @dev See {IERC721-getApproved}.
1130      */
1131     function getApproved(uint256 tokenId)
1132         public
1133         view
1134         override
1135         returns (address)
1136     {
1137         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1138 
1139         return _tokenApprovals[tokenId];
1140     }
1141 
1142     /**
1143      * @dev See {IERC721-setApprovalForAll}.
1144      */
1145     function setApprovalForAll(address operator, bool approved)
1146         public
1147         virtual
1148         override
1149     {
1150         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1151 
1152         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1153         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1154     }
1155 
1156     /**
1157      * @dev See {IERC721-isApprovedForAll}.
1158      */
1159     function isApprovedForAll(address owner, address operator)
1160         public
1161         view
1162         virtual
1163         override
1164         returns (bool)
1165     {
1166         return _operatorApprovals[owner][operator];
1167     }
1168 
1169     /**
1170      * @dev See {IERC721-safeTransferFrom}.
1171      */
1172     function safeTransferFrom(
1173         address from,
1174         address to,
1175         uint256 tokenId
1176     ) public virtual override {
1177         safeTransferFrom(from, to, tokenId, "");
1178     }
1179 
1180     /**
1181      * @dev See {IERC721-safeTransferFrom}.
1182      */
1183     function safeTransferFrom(
1184         address from,
1185         address to,
1186         uint256 tokenId,
1187         bytes memory _data
1188     ) public virtual override {
1189         transferFrom(from, to, tokenId);
1190         if (to.code.length != 0)
1191             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1192                 revert TransferToNonERC721ReceiverImplementer();
1193             }
1194     }
1195 
1196     /**
1197      * @dev Returns whether `tokenId` exists.
1198      *
1199      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1200      *
1201      * Tokens start existing when they are minted (`_mint`),
1202      */
1203     function _exists(uint256 tokenId) internal view returns (bool) {
1204         return
1205             _startTokenId() <= tokenId &&
1206             tokenId < _currentIndex && // If within bounds,
1207             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1208     }
1209 
1210     /**
1211      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1212      */
1213     function _safeMint(address to, uint256 quantity) internal {
1214         _safeMint(to, quantity, "");
1215     }
1216 
1217     /**
1218      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1219      *
1220      * Requirements:
1221      *
1222      * - If `to` refers to a smart contract, it must implement
1223      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1224      * - `quantity` must be greater than 0.
1225      *
1226      * See {_mint}.
1227      *
1228      * Emits a {Transfer} event for each mint.
1229      */
1230     function _safeMint(
1231         address to,
1232         uint256 quantity,
1233         bytes memory _data
1234     ) internal {
1235         _mint(to, quantity);
1236 
1237         unchecked {
1238             if (to.code.length != 0) {
1239                 uint256 end = _currentIndex;
1240                 uint256 index = end - quantity;
1241                 do {
1242                     if (
1243                         !_checkContractOnERC721Received(
1244                             address(0),
1245                             to,
1246                             index++,
1247                             _data
1248                         )
1249                     ) {
1250                         revert TransferToNonERC721ReceiverImplementer();
1251                     }
1252                 } while (index < end);
1253                 // Reentrancy protection.
1254                 if (_currentIndex != end) revert();
1255             }
1256         }
1257     }
1258 
1259     /**
1260      * @dev Mints `quantity` tokens and transfers them to `to`.
1261      *
1262      * Requirements:
1263      *
1264      * - `to` cannot be the zero address.
1265      * - `quantity` must be greater than 0.
1266      *
1267      * Emits a {Transfer} event for each mint.
1268      */
1269     function _mint(address to, uint256 quantity) internal {
1270         uint256 startTokenId = _currentIndex;
1271         if (to == address(0)) revert MintToZeroAddress();
1272         if (quantity == 0) revert MintZeroQuantity();
1273 
1274         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1275 
1276         // Overflows are incredibly unrealistic.
1277         // `balance` and `numberMinted` have a maximum limit of 2**64.
1278         // `tokenId` has a maximum limit of 2**256.
1279         unchecked {
1280             // Updates:
1281             // - `balance += quantity`.
1282             // - `numberMinted += quantity`.
1283             //
1284             // We can directly add to the `balance` and `numberMinted`.
1285             _packedAddressData[to] +=
1286                 quantity *
1287                 ((1 << BITPOS_NUMBER_MINTED) | 1);
1288 
1289             // Updates:
1290             // - `address` to the owner.
1291             // - `startTimestamp` to the timestamp of minting.
1292             // - `burned` to `false`.
1293             // - `nextInitialized` to `quantity == 1`.
1294             _packedOwnerships[startTokenId] = _packOwnershipData(
1295                 to,
1296                 _nextInitializedFlag(quantity) |
1297                     _nextExtraData(address(0), to, 0)
1298             );
1299 
1300             uint256 tokenId = startTokenId;
1301             uint256 end = startTokenId + quantity;
1302             do {
1303                 emit Transfer(address(0), to, tokenId++);
1304             } while (tokenId < end);
1305 
1306             _currentIndex = end;
1307         }
1308         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1309     }
1310 
1311     /**
1312      * @dev Mints `quantity` tokens and transfers them to `to`.
1313      *
1314      * This function is intended for efficient minting only during contract creation.
1315      *
1316      * It emits only one {ConsecutiveTransfer} as defined in
1317      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1318      * instead of a sequence of {Transfer} event(s).
1319      *
1320      * Calling this function outside of contract creation WILL make your contract
1321      * non-compliant with the ERC721 standard.
1322      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1323      * {ConsecutiveTransfer} event is only permissible during contract creation.
1324      *
1325      * Requirements:
1326      *
1327      * - `to` cannot be the zero address.
1328      * - `quantity` must be greater than 0.
1329      *
1330      * Emits a {ConsecutiveTransfer} event.
1331      */
1332     function _mintERC2309(address to, uint256 quantity) internal {
1333         uint256 startTokenId = _currentIndex;
1334         if (to == address(0)) revert MintToZeroAddress();
1335         if (quantity == 0) revert MintZeroQuantity();
1336         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT)
1337             revert MintERC2309QuantityExceedsLimit();
1338 
1339         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1340 
1341         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1342         unchecked {
1343             // Updates:
1344             // - `balance += quantity`.
1345             // - `numberMinted += quantity`.
1346             //
1347             // We can directly add to the `balance` and `numberMinted`.
1348             _packedAddressData[to] +=
1349                 quantity *
1350                 ((1 << BITPOS_NUMBER_MINTED) | 1);
1351 
1352             // Updates:
1353             // - `address` to the owner.
1354             // - `startTimestamp` to the timestamp of minting.
1355             // - `burned` to `false`.
1356             // - `nextInitialized` to `quantity == 1`.
1357             _packedOwnerships[startTokenId] = _packOwnershipData(
1358                 to,
1359                 _nextInitializedFlag(quantity) |
1360                     _nextExtraData(address(0), to, 0)
1361             );
1362 
1363             emit ConsecutiveTransfer(
1364                 startTokenId,
1365                 startTokenId + quantity - 1,
1366                 address(0),
1367                 to
1368             );
1369 
1370             _currentIndex = startTokenId + quantity;
1371         }
1372         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1373     }
1374 
1375     /**
1376      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1377      */
1378     function _getApprovedAddress(uint256 tokenId)
1379         private
1380         view
1381         returns (uint256 approvedAddressSlot, address approvedAddress)
1382     {
1383         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1384         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1385         assembly {
1386             // Compute the slot.
1387             mstore(0x00, tokenId)
1388             mstore(0x20, tokenApprovalsPtr.slot)
1389             approvedAddressSlot := keccak256(0x00, 0x40)
1390             // Load the slot's value from storage.
1391             approvedAddress := sload(approvedAddressSlot)
1392         }
1393     }
1394 
1395     /**
1396      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1397      */
1398     function _isOwnerOrApproved(
1399         address approvedAddress,
1400         address from,
1401         address msgSender
1402     ) private pure returns (bool result) {
1403         assembly {
1404             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1405             from := and(from, BITMASK_ADDRESS)
1406             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1407             msgSender := and(msgSender, BITMASK_ADDRESS)
1408             // `msgSender == from || msgSender == approvedAddress`.
1409             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1410         }
1411     }
1412 
1413     /**
1414      * @dev Transfers `tokenId` from `from` to `to`.
1415      *
1416      * Requirements:
1417      *
1418      * - `to` cannot be the zero address.
1419      * - `tokenId` token must be owned by `from`.
1420      *
1421      * Emits a {Transfer} event.
1422      */
1423     function transferFrom(
1424         address from,
1425         address to,
1426         uint256 tokenId
1427     ) public virtual override {
1428         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1429 
1430         if (address(uint160(prevOwnershipPacked)) != from)
1431             revert TransferFromIncorrectOwner();
1432 
1433         (
1434             uint256 approvedAddressSlot,
1435             address approvedAddress
1436         ) = _getApprovedAddress(tokenId);
1437 
1438         // The nested ifs save around 20+ gas over a compound boolean condition.
1439         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1440             if (!isApprovedForAll(from, _msgSenderERC721A()))
1441                 revert TransferCallerNotOwnerNorApproved();
1442 
1443         if (to == address(0)) revert TransferToZeroAddress();
1444 
1445         _beforeTokenTransfers(from, to, tokenId, 1);
1446 
1447         // Clear approvals from the previous owner.
1448         assembly {
1449             if approvedAddress {
1450                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1451                 sstore(approvedAddressSlot, 0)
1452             }
1453         }
1454 
1455         // Underflow of the sender's balance is impossible because we check for
1456         // ownership above and the recipient's balance can't realistically overflow.
1457         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1458         unchecked {
1459             // We can directly increment and decrement the balances.
1460             --_packedAddressData[from]; // Updates: `balance -= 1`.
1461             ++_packedAddressData[to]; // Updates: `balance += 1`.
1462 
1463             // Updates:
1464             // - `address` to the next owner.
1465             // - `startTimestamp` to the timestamp of transfering.
1466             // - `burned` to `false`.
1467             // - `nextInitialized` to `true`.
1468             _packedOwnerships[tokenId] = _packOwnershipData(
1469                 to,
1470                 BITMASK_NEXT_INITIALIZED |
1471                     _nextExtraData(from, to, prevOwnershipPacked)
1472             );
1473 
1474             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1475             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1476                 uint256 nextTokenId = tokenId + 1;
1477                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1478                 if (_packedOwnerships[nextTokenId] == 0) {
1479                     // If the next slot is within bounds.
1480                     if (nextTokenId != _currentIndex) {
1481                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1482                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1483                     }
1484                 }
1485             }
1486         }
1487 
1488         emit Transfer(from, to, tokenId);
1489         _afterTokenTransfers(from, to, tokenId, 1);
1490     }
1491 
1492     /**
1493      * @dev Equivalent to `_burn(tokenId, false)`.
1494      */
1495     function _burn(uint256 tokenId) internal virtual {
1496         _burn(tokenId, false);
1497     }
1498 
1499     /**
1500      * @dev Destroys `tokenId`.
1501      * The approval is cleared when the token is burned.
1502      *
1503      * Requirements:
1504      *
1505      * - `tokenId` must exist.
1506      *
1507      * Emits a {Transfer} event.
1508      */
1509     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1510         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1511 
1512         address from = address(uint160(prevOwnershipPacked));
1513 
1514         (
1515             uint256 approvedAddressSlot,
1516             address approvedAddress
1517         ) = _getApprovedAddress(tokenId);
1518 
1519         if (approvalCheck) {
1520             // The nested ifs save around 20+ gas over a compound boolean condition.
1521             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1522                 if (!isApprovedForAll(from, _msgSenderERC721A()))
1523                     revert TransferCallerNotOwnerNorApproved();
1524         }
1525 
1526         _beforeTokenTransfers(from, address(0), tokenId, 1);
1527 
1528         // Clear approvals from the previous owner.
1529         assembly {
1530             if approvedAddress {
1531                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1532                 sstore(approvedAddressSlot, 0)
1533             }
1534         }
1535 
1536         // Underflow of the sender's balance is impossible because we check for
1537         // ownership above and the recipient's balance can't realistically overflow.
1538         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1539         unchecked {
1540             // Updates:
1541             // - `balance -= 1`.
1542             // - `numberBurned += 1`.
1543             //
1544             // We can directly decrement the balance, and increment the number burned.
1545             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1546             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1547 
1548             // Updates:
1549             // - `address` to the last owner.
1550             // - `startTimestamp` to the timestamp of burning.
1551             // - `burned` to `true`.
1552             // - `nextInitialized` to `true`.
1553             _packedOwnerships[tokenId] = _packOwnershipData(
1554                 from,
1555                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) |
1556                     _nextExtraData(from, address(0), prevOwnershipPacked)
1557             );
1558 
1559             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1560             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1561                 uint256 nextTokenId = tokenId + 1;
1562                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1563                 if (_packedOwnerships[nextTokenId] == 0) {
1564                     // If the next slot is within bounds.
1565                     if (nextTokenId != _currentIndex) {
1566                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1567                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1568                     }
1569                 }
1570             }
1571         }
1572 
1573         emit Transfer(from, address(0), tokenId);
1574         _afterTokenTransfers(from, address(0), tokenId, 1);
1575 
1576         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1577         unchecked {
1578             _burnCounter++;
1579         }
1580     }
1581 
1582     /**
1583      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1584      *
1585      * @param from address representing the previous owner of the given token ID
1586      * @param to target address that will receive the tokens
1587      * @param tokenId uint256 ID of the token to be transferred
1588      * @param _data bytes optional data to send along with the call
1589      * @return bool whether the call correctly returned the expected magic value
1590      */
1591     function _checkContractOnERC721Received(
1592         address from,
1593         address to,
1594         uint256 tokenId,
1595         bytes memory _data
1596     ) private returns (bool) {
1597         try
1598             ERC721A__IERC721Receiver(to).onERC721Received(
1599                 _msgSenderERC721A(),
1600                 from,
1601                 tokenId,
1602                 _data
1603             )
1604         returns (bytes4 retval) {
1605             return
1606                 retval ==
1607                 ERC721A__IERC721Receiver(to).onERC721Received.selector;
1608         } catch (bytes memory reason) {
1609             if (reason.length == 0) {
1610                 revert TransferToNonERC721ReceiverImplementer();
1611             } else {
1612                 assembly {
1613                     revert(add(32, reason), mload(reason))
1614                 }
1615             }
1616         }
1617     }
1618 
1619     /**
1620      * @dev Directly sets the extra data for the ownership data `index`.
1621      */
1622     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1623         uint256 packed = _packedOwnerships[index];
1624         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1625         uint256 extraDataCasted;
1626         // Cast `extraData` with assembly to avoid redundant masking.
1627         assembly {
1628             extraDataCasted := extraData
1629         }
1630         packed =
1631             (packed & BITMASK_EXTRA_DATA_COMPLEMENT) |
1632             (extraDataCasted << BITPOS_EXTRA_DATA);
1633         _packedOwnerships[index] = packed;
1634     }
1635 
1636     /**
1637      * @dev Returns the next extra data for the packed ownership data.
1638      * The returned result is shifted into position.
1639      */
1640     function _nextExtraData(
1641         address from,
1642         address to,
1643         uint256 prevOwnershipPacked
1644     ) private view returns (uint256) {
1645         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1646         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1647     }
1648 
1649     /**
1650      * @dev Called during each token transfer to set the 24bit `extraData` field.
1651      * Intended to be overridden by the cosumer contract.
1652      *
1653      * `previousExtraData` - the value of `extraData` before transfer.
1654      *
1655      * Calling conditions:
1656      *
1657      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1658      * transferred to `to`.
1659      * - When `from` is zero, `tokenId` will be minted for `to`.
1660      * - When `to` is zero, `tokenId` will be burned by `from`.
1661      * - `from` and `to` are never both zero.
1662      */
1663     function _extraData(
1664         address from,
1665         address to,
1666         uint24 previousExtraData
1667     ) internal view virtual returns (uint24) {}
1668 
1669     /**
1670      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1671      * This includes minting.
1672      * And also called before burning one token.
1673      *
1674      * startTokenId - the first token id to be transferred
1675      * quantity - the amount to be transferred
1676      *
1677      * Calling conditions:
1678      *
1679      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1680      * transferred to `to`.
1681      * - When `from` is zero, `tokenId` will be minted for `to`.
1682      * - When `to` is zero, `tokenId` will be burned by `from`.
1683      * - `from` and `to` are never both zero.
1684      */
1685     function _beforeTokenTransfers(
1686         address from,
1687         address to,
1688         uint256 startTokenId,
1689         uint256 quantity
1690     ) internal virtual {}
1691 
1692     /**
1693      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1694      * This includes minting.
1695      * And also called after one token has been burned.
1696      *
1697      * startTokenId - the first token id to be transferred
1698      * quantity - the amount to be transferred
1699      *
1700      * Calling conditions:
1701      *
1702      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1703      * transferred to `to`.
1704      * - When `from` is zero, `tokenId` has been minted for `to`.
1705      * - When `to` is zero, `tokenId` has been burned by `from`.
1706      * - `from` and `to` are never both zero.
1707      */
1708     function _afterTokenTransfers(
1709         address from,
1710         address to,
1711         uint256 startTokenId,
1712         uint256 quantity
1713     ) internal virtual {}
1714 
1715     /**
1716      * @dev Returns the message sender (defaults to `msg.sender`).
1717      *
1718      * If you are writing GSN compatible contracts, you need to override this function.
1719      */
1720     function _msgSenderERC721A() internal view virtual returns (address) {
1721         return msg.sender;
1722     }
1723 
1724     /**
1725      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1726      */
1727     function _toString(uint256 value)
1728         internal
1729         pure
1730         returns (string memory ptr)
1731     {
1732         assembly {
1733             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1734             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1735             // We will need 1 32-byte word to store the length,
1736             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1737             ptr := add(mload(0x40), 128)
1738             // Update the free memory pointer to allocate.
1739             mstore(0x40, ptr)
1740 
1741             // Cache the end of the memory to calculate the length later.
1742             let end := ptr
1743 
1744             // We write the string from the rightmost digit to the leftmost digit.
1745             // The following is essentially a do-while loop that also handles the zero case.
1746             // Costs a bit more than early returning for the zero case,
1747             // but cheaper in terms of deployment and overall runtime costs.
1748             for {
1749                 // Initialize and perform the first pass without check.
1750                 let temp := value
1751                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1752                 ptr := sub(ptr, 1)
1753                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1754                 mstore8(ptr, add(48, mod(temp, 10)))
1755                 temp := div(temp, 10)
1756             } temp {
1757                 // Keep dividing `temp` until zero.
1758                 temp := div(temp, 10)
1759             } {
1760                 // Body of the for loop.
1761                 ptr := sub(ptr, 1)
1762                 mstore8(ptr, add(48, mod(temp, 10)))
1763             }
1764 
1765             let length := sub(end, ptr)
1766             // Move the pointer 32 bytes leftwards to make room for the length.
1767             ptr := sub(ptr, 32)
1768             // Store the length.
1769             mstore(ptr, length)
1770         }
1771     }
1772 }
1773 
1774 contract CollageBots is ERC721A, Ownable {
1775     using Strings for uint256;
1776     string public baseURI;
1777     string public baseExtension = ".json";
1778     address public collageBotsVault = 0xF5891B4C98a51D004D5C0A610022ec5FF59f30e7;
1779     uint256 public cost = 0.003 ether;
1780     uint256 public amountWHALE = 20;
1781     uint256 public amountOG = 10;
1782     uint256 public amountWL = 5;
1783     uint256 public amountPUBLIC = 3;
1784     uint256 public maxSupply = 2222;
1785     uint256 public maxMintAmount = 20;
1786     bool public paused = true;
1787 
1788     mapping(address => uint256) public addressMintedBalance;
1789 
1790     bytes32 public whitelistMerkleRootOG;
1791     bytes32 public whitelistMerkleRootWL;
1792     bytes32 public whitelistMerkleRootWHALE;
1793 
1794     constructor(
1795         string memory _name,
1796         string memory _symbol,
1797         string memory _URI
1798     ) ERC721A(_name, _symbol) {
1799         initialMint(200);
1800         setBaseURI(_URI);
1801     }
1802 
1803     function _baseURI() internal view virtual override returns (string memory) {
1804         return baseURI;
1805     }
1806 
1807     function mint(uint256 _mintAmount, bytes32[] calldata merkleProof)
1808         public
1809         payable
1810     {
1811         require(!paused || msg.sender == owner(), "the contract is paused");
1812         require(_mintAmount > 0, "need to mint at least 1 NFT");
1813         uint256 supply = totalSupply();
1814         require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1815         if(msg.sender != owner()) {
1816             require(maxMintAmount - (addressMintedBalance[msg.sender] + _mintAmount) >= 0, "max amount per wallet reached");
1817             require(!paused, "the contract is paused");
1818         }
1819         uint256 freeMintable = checkAmountFreeMinting(merkleProof, msg.sender);
1820         uint256 toPayMint = freeMintable > _mintAmount ? 0 : _mintAmount - freeMintable;
1821         require(msg.value >= cost * toPayMint, "insufficient funds");
1822         address receiver = msg.sender != owner() ? msg.sender : collageBotsVault;
1823         addressMintedBalance[receiver] += _mintAmount;
1824         _safeMint(receiver, _mintAmount);
1825     }
1826 
1827     function initialMint(uint256 _mintAmount) internal onlyOwner {
1828         addressMintedBalance[collageBotsVault] += _mintAmount;
1829         _safeMint(collageBotsVault, _mintAmount);
1830     }
1831 
1832     function burn(uint256 _tokenId) external onlyOwner {
1833         _burn(_tokenId);
1834     }
1835 
1836     function checkValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root)
1837         public
1838         view
1839         returns (bool)
1840     {
1841         return
1842             MerkleProof.verify(
1843                 merkleProof,
1844                 root,
1845                 keccak256(abi.encodePacked(msg.sender))
1846             );
1847     }
1848 
1849     function checkAmountFreeMinting(
1850         bytes32[] calldata merkleProof,
1851         address sender
1852     ) public view returns (uint256) {
1853         if (sender == owner()) return 1000;
1854         if (checkValidMerkleProof(merkleProof, whitelistMerkleRootWHALE)) {
1855             return
1856                 (amountWHALE - addressMintedBalance[sender]) > 0
1857                     ? amountWHALE - addressMintedBalance[sender]
1858                     : 0;
1859         } else if (checkValidMerkleProof(merkleProof, whitelistMerkleRootOG)) {
1860             return
1861                 (amountOG - addressMintedBalance[sender]) > 0
1862                     ? amountOG - addressMintedBalance[sender]
1863                     : 0;
1864         } else if (checkValidMerkleProof(merkleProof, whitelistMerkleRootWL)) {
1865             return
1866                 (amountWL - addressMintedBalance[sender]) > 0
1867                     ? amountWL - addressMintedBalance[sender]
1868                     : 0;
1869         }
1870         return
1871             (amountPUBLIC - addressMintedBalance[sender]) > 0
1872                 ? amountPUBLIC - addressMintedBalance[sender]
1873                 : 0;
1874     }
1875 
1876     function setRootOGMerkle(bytes32 merkleRoot) external onlyOwner {
1877         whitelistMerkleRootOG = merkleRoot;
1878     }
1879 
1880     function setRootWLMerkle(bytes32 merkleRoot) external onlyOwner {
1881         whitelistMerkleRootWL = merkleRoot;
1882     }
1883 
1884     function setRootWHALEMerkle(bytes32 merkleRoot) external onlyOwner {
1885         whitelistMerkleRootWHALE = merkleRoot;
1886     }
1887 
1888     function tokenURI(uint256 tokenId)
1889         public
1890         view
1891         virtual
1892         override
1893         returns (string memory)
1894     {
1895         require(
1896             _exists(tokenId),
1897             "ERC721Metadata: URI query for nonexistent token"
1898         );
1899 
1900         string memory currentBaseURI = _baseURI();
1901         return
1902             bytes(currentBaseURI).length > 0
1903                 ? string(
1904                     abi.encodePacked(
1905                         currentBaseURI,
1906                         tokenId.toString(),
1907                         baseExtension
1908                     )
1909                 )
1910                 : "";
1911     }
1912 
1913     function setCost(uint256 _newCost) public onlyOwner {
1914         cost = _newCost;
1915     }
1916 
1917     function setOGamount(uint256 _newAmount) public onlyOwner {
1918         amountOG = _newAmount;
1919     }
1920 
1921     function setWLamount(uint256 _newAmount) public onlyOwner {
1922         amountWL = _newAmount;
1923     }
1924 
1925     function setPUBLICamount(uint256 _newAmount) public onlyOwner {
1926         amountPUBLIC = _newAmount;
1927     }
1928 
1929     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1930         maxMintAmount = _newmaxMintAmount;
1931     }
1932 
1933     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1934         baseURI = _newBaseURI;
1935     }
1936 
1937     function setBaseExtension(string memory _newBaseExtension)
1938         public
1939         onlyOwner
1940     {
1941         baseExtension = _newBaseExtension;
1942     }
1943 
1944     function pause(bool _state) public onlyOwner {
1945         paused = _state;
1946     }
1947 
1948     function withdraw() public payable onlyOwner {
1949         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1950         require(os);
1951     }
1952 }