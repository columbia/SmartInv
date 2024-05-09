1 // File: IWhitelist.sol
2 
3 
4 // Creator: OZ
5 
6 pragma solidity ^0.8.4;
7 
8 interface IWhitelist {
9     function check(address addr) external view returns(bool);
10 }
11 
12 // File: Errors.sol
13 
14 
15 // Creator: OZ using Chiru Labs
16 
17 pragma solidity ^0.8.4;
18 
19 error ApprovalQueryForNonexistentToken();
20 error ApproveToCaller();
21 error ApprovalToCurrentOwner();
22 error AssetCannotBeTransfered();
23 error AssetLocked();
24 error AssetNotLocked();
25 error BalanceQueryForZeroAddress();
26 error BurnedQueryForZeroAddress();
27 error CallerNotOwnerNorApproved();
28 error Err();
29 error LackOfMoney();
30 error LockCallerNotOwnerNorApproved();
31 error MintShouldBeOpened();
32 error MintToZeroAddress();
33 error MintZeroQuantity();
34 error MintedQueryForZeroAddress();
35 error OutOfMintBoundaries();
36 error OwnerIndexOutOfBounds();
37 error OwnerQueryForNonexistentToken();
38 error RootAddressError();
39 error TokenIndexOutOfBounds();
40 error TransferCallerNotOwnerNorApproved();
41 error TransferFromIncorrectOwner();
42 error TransferToNonERC721ReceiverImplementer();
43 error TransferToZeroAddress();
44 error URIQueryForNonexistentToken();
45 error WhitelistedOnly();
46 
47 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
48 
49 
50 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev These functions deal with verification of Merkle Trees proofs.
56  *
57  * The proofs can be generated using the JavaScript library
58  * https://github.com/miguelmota/merkletreejs[merkletreejs].
59  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
60  *
61  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
62  */
63 library MerkleProof {
64     /**
65      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
66      * defined by `root`. For this, a `proof` must be provided, containing
67      * sibling hashes on the branch from the leaf to the root of the tree. Each
68      * pair of leaves and each pair of pre-images are assumed to be sorted.
69      */
70     function verify(
71         bytes32[] memory proof,
72         bytes32 root,
73         bytes32 leaf
74     ) internal pure returns (bool) {
75         return processProof(proof, leaf) == root;
76     }
77 
78     /**
79      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
80      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
81      * hash matches the root of the tree. When processing the proof, the pairs
82      * of leafs & pre-images are assumed to be sorted.
83      *
84      * _Available since v4.4._
85      */
86     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
87         bytes32 computedHash = leaf;
88         for (uint256 i = 0; i < proof.length; i++) {
89             bytes32 proofElement = proof[i];
90             if (computedHash <= proofElement) {
91                 // Hash(current computed hash + current element of the proof)
92                 computedHash = _efficientHash(computedHash, proofElement);
93             } else {
94                 // Hash(current element of the proof + current computed hash)
95                 computedHash = _efficientHash(proofElement, computedHash);
96             }
97         }
98         return computedHash;
99     }
100 
101     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
102         assembly {
103             mstore(0x00, a)
104             mstore(0x20, b)
105             value := keccak256(0x00, 0x40)
106         }
107     }
108 }
109 
110 // File: Strings.sol
111 
112 
113 pragma solidity ^0.8.4;
114 
115 /**
116  * Libraries
117  * Used https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol for Strings
118  */
119 
120 library Strings{
121 
122     bytes16 private constant _HEXSYMBOLS = "0123456789abcdef";
123 
124     function toString(address account) public pure returns(string memory) {
125         return toString(abi.encodePacked(account));
126     }
127 
128     function toString(bytes32 value) public pure returns(string memory) {
129         return toString(abi.encodePacked(value));
130     }
131 
132     function toString(bytes memory data) public pure returns(string memory) {
133         bytes memory alphabet = "0123456789abcdef";
134 
135         bytes memory str = new bytes(2 + data.length * 2);
136         str[0] = "0";
137         str[1] = "x";
138         for (uint i = 0; i < data.length; i++) {
139             str[2+i*2] = alphabet[uint(uint8(data[i] >> 4))];
140             str[3+i*2] = alphabet[uint(uint8(data[i] & 0x0f))];
141         }
142         return string(str);
143     }
144 
145     function toString(uint256 value) internal pure returns(string memory)
146     {
147         // Inspired by OraclizeAPI's implementation - MIT licence
148         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
149 
150         if (0 == value) {
151             return "0";
152         }
153         uint256 temp = value;
154         uint256 digits;
155         while (0 != temp) {
156             digits++;
157             temp /= 10;
158         }
159         bytes memory buffer = new bytes(digits);
160         while (0 != value) {
161             digits -= 1;
162             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
163             value /= 10;
164         }
165         return string(buffer);
166     }
167 
168     function toHexString(uint256 value) internal pure returns(string memory)
169     {
170         if (0 == value) {
171             return "0x00";
172         }
173         uint256 temp = value;
174         uint256 length = 0;
175         while (0 != temp) {
176             length++;
177             temp >>= 8;
178         }
179         return toHexString(value,length);
180     }
181 
182     function toHexString(uint256 value,uint256 length) internal pure returns(string memory)
183     {
184         bytes memory buffer = new bytes(2 * length + 2);
185         buffer[0] = "0";
186         buffer[1] = "x";
187         for (uint256 i = 2 * length + 1; i > 1; --i) {
188             buffer[i] = _HEXSYMBOLS[value & 0xf];
189             value >>= 4;
190         }
191         require(value == 0);
192         return string(buffer);
193     }
194     
195     function concat(string memory self, string memory other) internal pure returns(string memory)
196     {
197         return string(
198         abi.encodePacked(
199             self,
200             other
201         ));
202     }
203     
204 }
205 
206 // File: TokenStorage.sol
207 
208 
209 // Creator: OZ
210 
211 pragma solidity ^0.8.4;
212 
213 contract TokenStorage {
214 
215     enum MintStatus {
216         NONE,
217         PRESALE,
218         SALE
219     }
220 
221     // Compiler will pack this into a single 256bit word.
222     struct TokenOwnership {
223         // The address of the owner.
224         address addr;
225         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
226         uint64 startTimestamp;
227         // Whether the token has been burned.
228         bool burned;
229     }
230 
231     // Compiler will pack this into a single 256bit word.
232     struct AddressData {
233         // Realistically, 2**64-1 is more than enough.
234         uint64 balance;
235         // Keeps track of mint count with minimal overhead for tokenomics.
236         uint64 numberMinted;
237         uint64 numberMintedOnPresale;
238         // Keeps track of burn count with minimal overhead for tokenomics.
239         uint64 numberBurned;
240     }
241 
242     struct ContractData {
243         // Token name
244         string name;
245         // Token description
246         string description;
247         // Token symbol
248         string symbol;
249         // Base URL for tokens metadata
250         string baseURL;
251         // Contract-level metadata URL
252         string contractURL;
253         // Whitelist Merkle tree root
254         bytes32 wl;
255         // Is it set or asset?
256         bool isEnvelope;
257         // Revealed?
258         bool isRevealed;
259         // Mint status managed by
260         bool mintStatusAuto;
261         // Status
262         MintStatus mintStatus;
263     }
264 
265     struct EnvelopeTypes {
266         address envelope;
267         address[] types;
268     }
269 
270     struct MintSettings {
271         uint8 mintOnPresale;
272         uint8 maxMintPerUser;
273         uint8 minMintPerUser;
274         uint64 maxTokenSupply;
275         uint256 priceOnPresale;
276         uint256 priceOnSale;
277         uint256 envelopeConcatPrice;
278         uint256 envelopeSplitPrice;
279         // MintStatus timing
280         uint256 mintStatusPreale;
281         uint256 mintStatusSale;
282         uint256 mintStatusFinished;
283     }
284 
285     // Contract root address
286     address internal _root;
287 
288     // The tokenId of the next token to be minted.
289     uint256 internal _currentIndex;
290 
291     // The number of tokens burned.
292     uint256 internal _burnCounter;
293 
294     // Contract data
295     ContractData internal _contractData;
296 
297     // Envelope data
298     EnvelopeTypes internal _envelopeTypes;
299 
300     // Mint settings
301     MintSettings internal _mintSettings;
302 
303     // Mapping from token ID to ownership details
304     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
305     mapping(uint256 => TokenOwnership) internal _ownerships;
306 
307     // Mapping from token ID to approved address
308     mapping(uint256 => address) internal _tokenApprovals;
309 
310     // Mapping owner address to address data
311     mapping(address => AddressData) internal _addressData;
312 
313     // Mapping from owner to operator approvals
314     mapping(address => mapping(address => bool)) internal _operatorApprovals;
315 
316     // Envelope container
317     mapping(uint256 => mapping(address => uint256)) internal _assetsEnvelope;
318     mapping(address => mapping(uint256 => bool)) internal _assetsEnveloped;
319 
320 }
321 // File: @openzeppelin/contracts/utils/Address.sol
322 
323 
324 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
325 
326 pragma solidity ^0.8.1;
327 
328 /**
329  * @dev Collection of functions related to the address type
330  */
331 library Address {
332     /**
333      * @dev Returns true if `account` is a contract.
334      *
335      * [IMPORTANT]
336      * ====
337      * It is unsafe to assume that an address for which this function returns
338      * false is an externally-owned account (EOA) and not a contract.
339      *
340      * Among others, `isContract` will return false for the following
341      * types of addresses:
342      *
343      *  - an externally-owned account
344      *  - a contract in construction
345      *  - an address where a contract will be created
346      *  - an address where a contract lived, but was destroyed
347      * ====
348      *
349      * [IMPORTANT]
350      * ====
351      * You shouldn't rely on `isContract` to protect against flash loan attacks!
352      *
353      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
354      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
355      * constructor.
356      * ====
357      */
358     function isContract(address account) internal view returns (bool) {
359         // This method relies on extcodesize/address.code.length, which returns 0
360         // for contracts in construction, since the code is only stored at the end
361         // of the constructor execution.
362 
363         return account.code.length > 0;
364     }
365 
366     /**
367      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
368      * `recipient`, forwarding all available gas and reverting on errors.
369      *
370      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
371      * of certain opcodes, possibly making contracts go over the 2300 gas limit
372      * imposed by `transfer`, making them unable to receive funds via
373      * `transfer`. {sendValue} removes this limitation.
374      *
375      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
376      *
377      * IMPORTANT: because control is transferred to `recipient`, care must be
378      * taken to not create reentrancy vulnerabilities. Consider using
379      * {ReentrancyGuard} or the
380      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
381      */
382     function sendValue(address payable recipient, uint256 amount) internal {
383         require(address(this).balance >= amount, "Address: insufficient balance");
384 
385         (bool success, ) = recipient.call{value: amount}("");
386         require(success, "Address: unable to send value, recipient may have reverted");
387     }
388 
389     /**
390      * @dev Performs a Solidity function call using a low level `call`. A
391      * plain `call` is an unsafe replacement for a function call: use this
392      * function instead.
393      *
394      * If `target` reverts with a revert reason, it is bubbled up by this
395      * function (like regular Solidity function calls).
396      *
397      * Returns the raw returned data. To convert to the expected return value,
398      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
399      *
400      * Requirements:
401      *
402      * - `target` must be a contract.
403      * - calling `target` with `data` must not revert.
404      *
405      * _Available since v3.1._
406      */
407     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
408         return functionCall(target, data, "Address: low-level call failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
413      * `errorMessage` as a fallback revert reason when `target` reverts.
414      *
415      * _Available since v3.1._
416      */
417     function functionCall(
418         address target,
419         bytes memory data,
420         string memory errorMessage
421     ) internal returns (bytes memory) {
422         return functionCallWithValue(target, data, 0, errorMessage);
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
427      * but also transferring `value` wei to `target`.
428      *
429      * Requirements:
430      *
431      * - the calling contract must have an ETH balance of at least `value`.
432      * - the called Solidity function must be `payable`.
433      *
434      * _Available since v3.1._
435      */
436     function functionCallWithValue(
437         address target,
438         bytes memory data,
439         uint256 value
440     ) internal returns (bytes memory) {
441         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
446      * with `errorMessage` as a fallback revert reason when `target` reverts.
447      *
448      * _Available since v3.1._
449      */
450     function functionCallWithValue(
451         address target,
452         bytes memory data,
453         uint256 value,
454         string memory errorMessage
455     ) internal returns (bytes memory) {
456         require(address(this).balance >= value, "Address: insufficient balance for call");
457         require(isContract(target), "Address: call to non-contract");
458 
459         (bool success, bytes memory returndata) = target.call{value: value}(data);
460         return verifyCallResult(success, returndata, errorMessage);
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
465      * but performing a static call.
466      *
467      * _Available since v3.3._
468      */
469     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
470         return functionStaticCall(target, data, "Address: low-level static call failed");
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
475      * but performing a static call.
476      *
477      * _Available since v3.3._
478      */
479     function functionStaticCall(
480         address target,
481         bytes memory data,
482         string memory errorMessage
483     ) internal view returns (bytes memory) {
484         require(isContract(target), "Address: static call to non-contract");
485 
486         (bool success, bytes memory returndata) = target.staticcall(data);
487         return verifyCallResult(success, returndata, errorMessage);
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
492      * but performing a delegate call.
493      *
494      * _Available since v3.4._
495      */
496     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
497         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
502      * but performing a delegate call.
503      *
504      * _Available since v3.4._
505      */
506     function functionDelegateCall(
507         address target,
508         bytes memory data,
509         string memory errorMessage
510     ) internal returns (bytes memory) {
511         require(isContract(target), "Address: delegate call to non-contract");
512 
513         (bool success, bytes memory returndata) = target.delegatecall(data);
514         return verifyCallResult(success, returndata, errorMessage);
515     }
516 
517     /**
518      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
519      * revert reason using the provided one.
520      *
521      * _Available since v4.3._
522      */
523     function verifyCallResult(
524         bool success,
525         bytes memory returndata,
526         string memory errorMessage
527     ) internal pure returns (bytes memory) {
528         if (success) {
529             return returndata;
530         } else {
531             // Look for revert reason and bubble it up if present
532             if (returndata.length > 0) {
533                 // The easiest way to bubble the revert reason is using memory via assembly
534 
535                 assembly {
536                     let returndata_size := mload(returndata)
537                     revert(add(32, returndata), returndata_size)
538                 }
539             } else {
540                 revert(errorMessage);
541             }
542         }
543     }
544 }
545 
546 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
547 
548 
549 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
550 
551 pragma solidity ^0.8.0;
552 
553 /**
554  * @title ERC721 token receiver interface
555  * @dev Interface for any contract that wants to support safeTransfers
556  * from ERC721 asset contracts.
557  */
558 interface IERC721Receiver {
559     /**
560      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
561      * by `operator` from `from`, this function is called.
562      *
563      * It must return its Solidity selector to confirm the token transfer.
564      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
565      *
566      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
567      */
568     function onERC721Received(
569         address operator,
570         address from,
571         uint256 tokenId,
572         bytes calldata data
573     ) external returns (bytes4);
574 }
575 
576 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
577 
578 
579 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
580 
581 pragma solidity ^0.8.0;
582 
583 /**
584  * @dev Interface of the ERC165 standard, as defined in the
585  * https://eips.ethereum.org/EIPS/eip-165[EIP].
586  *
587  * Implementers can declare support of contract interfaces, which can then be
588  * queried by others ({ERC165Checker}).
589  *
590  * For an implementation, see {ERC165}.
591  */
592 interface IERC165 {
593     /**
594      * @dev Returns true if this contract implements the interface defined by
595      * `interfaceId`. See the corresponding
596      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
597      * to learn more about how these ids are created.
598      *
599      * This function call must use less than 30 000 gas.
600      */
601     function supportsInterface(bytes4 interfaceId) external view returns (bool);
602 }
603 
604 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
605 
606 
607 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
608 
609 pragma solidity ^0.8.0;
610 
611 
612 /**
613  * @dev Implementation of the {IERC165} interface.
614  *
615  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
616  * for the additional interface id that will be supported. For example:
617  *
618  * ```solidity
619  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
620  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
621  * }
622  * ```
623  *
624  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
625  */
626 abstract contract ERC165 is IERC165 {
627     /**
628      * @dev See {IERC165-supportsInterface}.
629      */
630     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
631         return interfaceId == type(IERC165).interfaceId;
632     }
633 }
634 
635 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
636 
637 
638 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
639 
640 pragma solidity ^0.8.0;
641 
642 
643 /**
644  * @dev Required interface of an ERC721 compliant contract.
645  */
646 interface IERC721 is IERC165 {
647     /**
648      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
649      */
650     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
651 
652     /**
653      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
654      */
655     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
656 
657     /**
658      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
659      */
660     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
661 
662     /**
663      * @dev Returns the number of tokens in ``owner``'s account.
664      */
665     function balanceOf(address owner) external view returns (uint256 balance);
666 
667     /**
668      * @dev Returns the owner of the `tokenId` token.
669      *
670      * Requirements:
671      *
672      * - `tokenId` must exist.
673      */
674     function ownerOf(uint256 tokenId) external view returns (address owner);
675 
676     /**
677      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
678      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
679      *
680      * Requirements:
681      *
682      * - `from` cannot be the zero address.
683      * - `to` cannot be the zero address.
684      * - `tokenId` token must exist and be owned by `from`.
685      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
686      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
687      *
688      * Emits a {Transfer} event.
689      */
690     function safeTransferFrom(
691         address from,
692         address to,
693         uint256 tokenId
694     ) external;
695 
696     /**
697      * @dev Transfers `tokenId` token from `from` to `to`.
698      *
699      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
700      *
701      * Requirements:
702      *
703      * - `from` cannot be the zero address.
704      * - `to` cannot be the zero address.
705      * - `tokenId` token must be owned by `from`.
706      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
707      *
708      * Emits a {Transfer} event.
709      */
710     function transferFrom(
711         address from,
712         address to,
713         uint256 tokenId
714     ) external;
715 
716     /**
717      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
718      * The approval is cleared when the token is transferred.
719      *
720      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
721      *
722      * Requirements:
723      *
724      * - The caller must own the token or be an approved operator.
725      * - `tokenId` must exist.
726      *
727      * Emits an {Approval} event.
728      */
729     function approve(address to, uint256 tokenId) external;
730 
731     /**
732      * @dev Returns the account approved for `tokenId` token.
733      *
734      * Requirements:
735      *
736      * - `tokenId` must exist.
737      */
738     function getApproved(uint256 tokenId) external view returns (address operator);
739 
740     /**
741      * @dev Approve or remove `operator` as an operator for the caller.
742      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
743      *
744      * Requirements:
745      *
746      * - The `operator` cannot be the caller.
747      *
748      * Emits an {ApprovalForAll} event.
749      */
750     function setApprovalForAll(address operator, bool _approved) external;
751 
752     /**
753      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
754      *
755      * See {setApprovalForAll}
756      */
757     function isApprovedForAll(address owner, address operator) external view returns (bool);
758 
759     /**
760      * @dev Safely transfers `tokenId` token from `from` to `to`.
761      *
762      * Requirements:
763      *
764      * - `from` cannot be the zero address.
765      * - `to` cannot be the zero address.
766      * - `tokenId` token must exist and be owned by `from`.
767      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
768      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
769      *
770      * Emits a {Transfer} event.
771      */
772     function safeTransferFrom(
773         address from,
774         address to,
775         uint256 tokenId,
776         bytes calldata data
777     ) external;
778 }
779 
780 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
781 
782 
783 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
784 
785 pragma solidity ^0.8.0;
786 
787 
788 /**
789  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
790  * @dev See https://eips.ethereum.org/EIPS/eip-721
791  */
792 interface IERC721Enumerable is IERC721 {
793     /**
794      * @dev Returns the total amount of tokens stored by the contract.
795      */
796     function totalSupply() external view returns (uint256);
797 
798     /**
799      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
800      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
801      */
802     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
803 
804     /**
805      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
806      * Use along with {totalSupply} to enumerate all tokens.
807      */
808     function tokenByIndex(uint256 index) external view returns (uint256);
809 }
810 
811 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
812 
813 
814 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
815 
816 pragma solidity ^0.8.0;
817 
818 
819 /**
820  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
821  * @dev See https://eips.ethereum.org/EIPS/eip-721
822  */
823 interface IERC721Metadata is IERC721 {
824     /**
825      * @dev Returns the token collection name.
826      */
827     function name() external view returns (string memory);
828 
829     /**
830      * @dev Returns the token collection symbol.
831      */
832     function symbol() external view returns (string memory);
833 
834     /**
835      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
836      */
837     function tokenURI(uint256 tokenId) external view returns (string memory);
838 }
839 
840 // File: @openzeppelin/contracts/utils/Context.sol
841 
842 
843 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
844 
845 pragma solidity ^0.8.0;
846 
847 /**
848  * @dev Provides information about the current execution context, including the
849  * sender of the transaction and its data. While these are generally available
850  * via msg.sender and msg.data, they should not be accessed in such a direct
851  * manner, since when dealing with meta-transactions the account sending and
852  * paying for execution may not be the actual sender (as far as an application
853  * is concerned).
854  *
855  * This contract is only required for intermediate, library-like contracts.
856  */
857 abstract contract Context {
858     function _msgSender() internal view virtual returns (address) {
859         return msg.sender;
860     }
861 
862     function _msgData() internal view virtual returns (bytes calldata) {
863         return msg.data;
864     }
865 }
866 
867 // File: Array.sol
868 
869 
870 // Creator: OZ
871 
872 pragma solidity ^0.8.4;
873 
874 contract Array{
875 
876     function remove(uint256[] memory arr, uint256 e)
877     internal pure
878     {
879         unchecked {
880             uint idx = 0;
881             for(uint i = 0; i < arr.length; i++) {
882                 if(arr[i] == e) {
883                     idx = i;
884                 }
885             }
886             for (uint i = idx; i < arr.length-1; i++){
887                 arr[i] = arr[i+1];        
888             }
889             delete arr[arr.length - 1];
890         }
891     }
892     
893 }
894 // File: Math.sol
895 
896 
897 pragma solidity ^0.8.4;
898 
899 library Math{
900 
901     function max(uint256 a,uint256 b) internal pure returns(uint256)
902     {
903         return a >= b ? a : b;
904     }
905 
906     function min(uint256 a,uint256 b) internal pure returns(uint256)
907     {
908         return a < b ? a : b;
909     }
910 
911     function average(uint256 a,uint256 b) internal pure returns(uint256)
912     {
913         return (a & b) + (a ^ b) / 2;
914     }
915 
916     function ceilDiv(uint256 a,uint256 b) internal pure returns(uint256)
917     {
918         return a / b + (a % b == 0 ? 0 : 1);
919     }
920 
921     function mul(uint256 a,uint256 b) internal pure returns(uint256 c)
922     {
923         if (0 == a) {
924             return 0;
925         }
926         c = a * b;
927         assert(c / a == b);
928         return c;
929     }
930 
931     function div(uint256 a,uint256 b) internal pure returns(uint256)
932     {
933         assert(0 != b);
934         return a / b;
935     }
936 
937     function sub(uint256 a,uint256 b) internal pure returns(uint256)
938     {
939         assert(b <= a);
940         return a - b;
941     }
942 
943     function add(uint256 a,uint256 b) internal pure returns(uint256 c)
944     {
945         c = a + b;
946         assert(c >= a);
947         return c;
948     }
949 }
950 
951 // File: Quantity.sol
952 
953 
954 // Creator: OZ
955 
956 pragma solidity ^0.8.4;
957 
958 
959 
960 contract Quantity is TokenStorage {
961 
962     function quantityIsGood(uint256 _quantity,uint256 _minted,uint256 _mintedOnPresale)
963     internal view
964     returns(bool)
965     {
966         return
967             (
968                 _contractData.mintStatus == MintStatus.PRESALE &&
969                 _mintSettings.mintOnPresale >= _quantity + _minted
970             ) || (
971                 _contractData.mintStatus == MintStatus.SALE &&
972                 _mintSettings.maxMintPerUser >= _quantity + _minted - _mintedOnPresale &&
973                 _mintSettings.minMintPerUser <= _quantity
974             )
975             ;
976     }
977 
978     function supplyIsGood()
979     internal view
980     returns(bool)
981     {
982         return
983             _contractData.isEnvelope || (
984                 _contractData.isEnvelope == false &&
985                 _mintSettings.maxTokenSupply > _currentIndex
986             )
987             ;
988     }
989 
990 }
991 // File: IEnvelope.sol
992 
993 
994 // Creator: OZ
995 
996 pragma solidity ^0.8.4;
997 
998 interface IEnvelope {
999     function locked(address _asset,uint256 _assetId) external view returns(bool);
1000     function ownerOfAsset(uint256 _assetId) external view returns(address);
1001     }
1002 
1003 // File: Ownership.sol
1004 
1005 
1006 // Creator: OZ using Chiru Labs
1007 
1008 pragma solidity ^0.8.4;
1009 
1010 
1011 
1012 
1013 
1014 contract Ownership is Context, TokenStorage {
1015 
1016     /**
1017      * Gas spent here starts off proportional to the maximum mint batch size.
1018      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1019      */
1020     function ownershipOf(uint256 tokenId)
1021     internal view
1022     returns (TokenOwnership memory)
1023     {
1024         uint256 curr = tokenId;
1025 
1026         unchecked {
1027             if (curr < _currentIndex) {
1028                 TokenOwnership memory ownership = _ownerships[curr];
1029                 if (!ownership.burned) {
1030                     if (ownership.addr != address(0)) {
1031                         return ownership;
1032                     }
1033                     // Invariant: 
1034                     // There will always be an ownership that has an address and is not burned 
1035                     // before an ownership that does not have an address and is not burned.
1036                     // Hence, curr will not underflow.
1037                     while (true) {
1038                         curr--;
1039                         ownership = _ownerships[curr];
1040                         if (ownership.addr != address(0)) {
1041                             return ownership;
1042                         }
1043                     }
1044                 }
1045             }
1046         }
1047         revert OwnerQueryForNonexistentToken();
1048     }
1049 
1050     uint256[] private __tokens__;
1051 
1052     function tokensOf(address _owner)
1053     external
1054     returns(uint256[] memory tokens)
1055     {
1056         unchecked {
1057             for(uint i=0;i<_currentIndex;i++) {
1058                 TokenOwnership memory ownership = ownershipOf(i);
1059                 if(ownership.addr == _owner) {
1060                     if (!ownership.burned) {
1061                         if(_contractData.isEnvelope) {
1062                             __tokens__.push(i);
1063                         } else {
1064                             if(!IEnvelope(_envelopeTypes.envelope).locked(address(this),i)) {
1065                                 __tokens__.push(i);
1066                             }
1067                         }
1068                     }
1069                 }
1070             }
1071             return __tokens__;
1072         }
1073     }
1074 
1075 }
1076 // File: AccessControl.sol
1077 
1078 
1079 // Creator: OZ
1080 
1081 pragma solidity ^0.8.4;
1082 
1083 
1084 
1085 
1086 contract AccessControl is Ownership {
1087 
1088     function ActiveMint()
1089     internal view
1090     {
1091         if(MintStatus.NONE == _contractData.mintStatus)
1092             revert MintShouldBeOpened();
1093     }
1094 
1095     function ApprovedOnly(address owner)
1096     internal view
1097     {
1098         if (!_operatorApprovals[owner][_msgSender()])
1099             revert CallerNotOwnerNorApproved();
1100     }
1101 
1102     function BotProtection()
1103     internal view
1104     {
1105         if(tx.origin != msg.sender)
1106             revert Err();
1107     }
1108 
1109     function OwnerOnly(address owner,uint256 tokenId)
1110     internal view
1111     {
1112         if (owner != ownershipOf(tokenId).addr)
1113             revert CallerNotOwnerNorApproved();
1114     }
1115 
1116     function RootOnly()
1117     internal view
1118     {
1119         address sender = _msgSender();
1120         if(
1121             sender != _root &&
1122             sender != _envelopeTypes.envelope
1123         ) revert RootAddressError();
1124     }
1125 
1126     function Whitelisted(bytes32[] calldata _merkleProof)
1127     internal view
1128     {
1129         address sender = _msgSender();
1130         bool flag =
1131             _root == sender ||
1132             _contractData.mintStatus == MintStatus.SALE
1133         ;
1134 
1135         /**
1136          * Set merkle tree root
1137          */
1138         if(!flag)
1139             flag = MerkleProof.verify(_merkleProof, _contractData.wl, keccak256(abi.encodePacked(sender)));
1140 
1141         /**/
1142         if(!flag)
1143             revert WhitelistedOnly();
1144     }
1145 
1146     function setWLRoot(bytes32 _root)
1147     external
1148     {
1149         RootOnly();
1150 
1151         _contractData.wl = _root;
1152     }
1153 
1154 }
1155 // File: ERC721A.sol
1156 
1157 
1158 // Creator: Chiru Labs
1159 
1160 pragma solidity ^0.8.4;
1161 
1162 
1163 
1164 
1165 
1166 
1167 
1168 
1169 
1170 
1171 
1172 
1173 //import "hardhat/console.sol";
1174 
1175 /**
1176  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1177  * the Metadata extension. Built to optimize for lower gas during batch mints.
1178  *
1179  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1180  *
1181  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1182  *
1183  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1184  */
1185 abstract contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, AccessControl, Quantity {
1186     using Address for address;
1187     using Strings for uint256;
1188 
1189     constructor(
1190         string memory name_,
1191         string memory description_,
1192         string memory symbol_,
1193         string memory baseURL_,
1194         string memory contractURL_
1195     ) {
1196         _contractData.name = name_;
1197         _contractData.description = description_;
1198         _contractData.symbol = symbol_;
1199         _contractData.baseURL = baseURL_;
1200         _contractData.contractURL = contractURL_;
1201     }
1202 
1203     /**
1204      * @dev See {IERC721Enumerable-totalSupply}.
1205      */
1206     function totalSupply()
1207     public view
1208     returns(uint256)
1209     {
1210         // Counter underflow is impossible as _burnCounter cannot be incremented
1211         // more than _currentIndex times
1212         unchecked {
1213             return _currentIndex - _burnCounter;    
1214         }
1215     }
1216 
1217     /**
1218      * @dev See {IERC165-supportsInterface}.
1219      */
1220     function supportsInterface(bytes4 interfaceId)
1221     public view virtual
1222     override(ERC165, IERC165)
1223     returns(bool)
1224     {
1225         return
1226             interfaceId == type(IERC721).interfaceId ||
1227             interfaceId == type(IERC721Metadata).interfaceId ||
1228             super.supportsInterface(interfaceId);
1229     }
1230 
1231     /**
1232      * @dev See {IERC721-balanceOf}.
1233      */
1234     function balanceOf(address owner)
1235     public view
1236     override
1237     returns(uint256)
1238     {
1239         if (owner == address(0))
1240             revert BalanceQueryForZeroAddress();
1241         return uint256(_addressData[owner].balance);
1242     }
1243 
1244     /**
1245      * returnsthe number of tokens minted by `owner`.
1246      */
1247     function _numberMinted(address owner)
1248     internal view
1249     returns(uint256)
1250     {
1251         if (owner == address(0))
1252             revert MintedQueryForZeroAddress();
1253         else return
1254             uint256(_addressData[owner].numberMinted);
1255     }
1256 
1257     function _numberMintedOnPresale(address owner)
1258     internal view
1259     returns(uint256)
1260     {
1261         if (owner == address(0))
1262             revert MintedQueryForZeroAddress();
1263         else return
1264             uint256(_addressData[owner].numberMintedOnPresale);
1265     }
1266 
1267     /**
1268      * returnsthe number of tokens burned by or on behalf of `owner`.
1269      */
1270     function _numberBurned(address owner)
1271     internal view
1272     returns(uint256)
1273     {
1274         if (owner == address(0))
1275             revert BurnedQueryForZeroAddress();
1276         else return
1277             uint256(_addressData[owner].numberBurned);
1278     }
1279 
1280     /**
1281      * @dev See {IERC721-ownerOf}.
1282      */
1283     function ownerOf(uint256 tokenId)
1284     public view
1285     override
1286     returns(address)
1287     {
1288         if(!_contractData.isEnvelope) {
1289             if(IEnvelope(_envelopeTypes.envelope).locked(address(this),tokenId)) {
1290                 return address(0);
1291             }
1292         }
1293         return ownershipOf(tokenId).addr;
1294     }
1295 
1296     /**
1297      * @dev See {IERC721-approve}.
1298      */
1299     function approve(address to, uint256 tokenId)
1300     public
1301     override
1302     {
1303         address owner = ERC721A.ownerOf(tokenId);
1304         if (to == owner)
1305             revert ApprovalToCurrentOwner();
1306         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender()))
1307             revert CallerNotOwnerNorApproved();
1308         _approve(to, tokenId, owner);
1309     }
1310 
1311     /**
1312      * @dev See {IERC721-getApproved}.
1313      */
1314     function getApproved(uint256 tokenId)
1315     public view
1316     override
1317     returns(address)
1318     {
1319         if (!_exists(tokenId))
1320             revert ApprovalQueryForNonexistentToken();
1321         else return
1322             _tokenApprovals[tokenId];
1323     }
1324 
1325     /**
1326      * @dev See {IERC721-setApprovalForAll}.
1327      */
1328     function setApprovalForAll(address operator, bool approved)
1329     public
1330     override
1331     {
1332         if (operator == _msgSender())
1333             revert ApproveToCaller();
1334         _operatorApprovals[_msgSender()][operator] = approved;
1335         emit ApprovalForAll(_msgSender(), operator, approved);
1336     }
1337 
1338     /**
1339      * @dev See {IERC721-isApprovedForAll}.
1340      */
1341     function isApprovedForAll(address owner, address operator)
1342     public view virtual
1343     override
1344     returns(bool)
1345     {
1346         return _operatorApprovals[owner][operator];
1347     }
1348 
1349     /**
1350      * @dev See {IERC721-transferFrom}.
1351      */
1352     function transferFrom(
1353         address from,
1354         address to,
1355         uint256 tokenId
1356     ) public virtual override {
1357         if(!_contractData.isEnvelope)
1358             if(IEnvelope(_envelopeTypes.envelope).locked(address(this),tokenId))
1359                 revert AssetLocked();
1360                 
1361         _transfer(from, to, tokenId);
1362     }
1363 
1364     /**
1365      * @dev See {IERC721-safeTransferFrom}.
1366      */
1367     function safeTransferFrom(
1368         address from,
1369         address to,
1370         uint256 tokenId
1371     ) public virtual override {
1372         safeTransferFrom(from, to, tokenId, '');
1373     }
1374 
1375     /**
1376      * @dev See {IERC721-safeTransferFrom}.
1377      */
1378     function safeTransferFrom(
1379         address from,
1380         address to,
1381         uint256 tokenId,
1382         bytes memory _data
1383     ) public virtual override {
1384         if(!_contractData.isEnvelope)
1385             if(IEnvelope(_envelopeTypes.envelope).locked(address(this),tokenId))
1386                 revert AssetLocked();
1387 
1388         _transfer(from, to, tokenId);
1389         if (!_checkOnERC721Received(from, to, tokenId, _data))
1390             revert TransferToNonERC721ReceiverImplementer();
1391     }
1392 
1393     /**
1394      * @dev returnswhether `tokenId` exists.
1395      *
1396      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1397      *
1398      * Tokens start existing when they are minted (`_mint`),
1399      */
1400     function _exists(uint256 tokenId)
1401     internal view
1402     returns(bool)
1403     {
1404         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1405     }
1406 
1407     function _safeMint(address to, uint256 quantity) internal {
1408         _safeMint(to, quantity, '');
1409     }
1410 
1411     /**
1412      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1413      *
1414      * Requirements:
1415      *
1416      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1417      * - `quantity` must be greater than 0.
1418      *
1419      * Emits a {Transfer} event.
1420      */
1421     function _safeMint(
1422         address to,
1423         uint256 quantity,
1424         bytes memory _data
1425     ) internal {
1426         _mint(to, quantity, _data, true);
1427     }
1428 
1429     /**
1430      * @dev Mints `quantity` tokens and transfers them to `to`.
1431      *
1432      * Requirements:
1433      *
1434      * - `to` cannot be the zero address.
1435      * - `quantity` must be greater than 0.
1436      *
1437      * Emits a {Transfer} event.
1438      */
1439     function _mint(
1440         address to,
1441         uint256 quantity,
1442         bytes memory _data,
1443         bool safe
1444     ) internal {
1445         uint256 startTokenId = _currentIndex;
1446         if(!supplyIsGood())
1447             revert OutOfMintBoundaries();
1448         if (to == address(0))
1449             revert MintToZeroAddress();
1450         if (quantity == 0)
1451             revert MintZeroQuantity();
1452 
1453         // Overflows are incredibly unrealistic.
1454         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1455         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1456         unchecked {
1457             _addressData[to].balance += uint64(quantity);
1458             _addressData[to].numberMinted += uint64(quantity);
1459             if(_contractData.mintStatus == MintStatus.PRESALE)
1460                 _addressData[to].numberMintedOnPresale = _addressData[to].numberMintedOnPresale + uint64(quantity);
1461 
1462             _ownerships[startTokenId].addr = to;
1463             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1464 
1465             uint256 updatedIndex = startTokenId;
1466             for (uint256 i; i < quantity; i++) {
1467                 emit Transfer(address(0), to, updatedIndex);
1468                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data))
1469                     revert TransferToNonERC721ReceiverImplementer();
1470                 updatedIndex++;
1471             }
1472 
1473             _currentIndex = updatedIndex;
1474         }
1475     }
1476 
1477     /**
1478      * Transfer set and all its assets
1479      */
1480     function _transferEnvelope(address _to,uint256 _assetId)
1481     internal
1482     {
1483         unchecked {
1484             for (uint i = 0; i < _envelopeTypes.types.length; i++) {
1485                 (bool success,bytes memory res) = _envelopeTypes.types[i].call(
1486                     abi.encodeWithSignature("unlock(uint256,address)",
1487                         _assetsEnvelope[_assetId][_envelopeTypes.types[i]],
1488                         _to)
1489                 );
1490                 if(!success)
1491                     revert AssetCannotBeTransfered();
1492             }
1493         }
1494     }
1495 
1496     /**
1497      * @dev Transfers `tokenId` from `from` to `to`.
1498      *
1499      * Requirements:
1500      *
1501      * - `to` cannot be the zero address.
1502      * - `tokenId` token must be owned by `from`.
1503      *
1504      * Emits a {Transfer} event.
1505      */
1506     function _transfer(
1507         address from,
1508         address to,
1509         uint256 tokenId
1510     ) internal {
1511 
1512         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1513         address sender = _msgSender();
1514 
1515         bool isApprovedOrOwner = (
1516             sender == _envelopeTypes.envelope ||
1517             sender == prevOwnership.addr ||
1518             sender == getApproved(tokenId) ||
1519             isApprovedForAll(prevOwnership.addr, sender)
1520         );
1521 
1522         if (!isApprovedOrOwner)
1523             revert TransferCallerNotOwnerNorApproved();
1524         if (prevOwnership.addr != from)
1525             revert TransferFromIncorrectOwner();
1526         if (to == address(0))
1527             revert TransferToZeroAddress();
1528 
1529         /*
1530         if(
1531             sender == prevOwnership.addr &&
1532             _contractData.isEnvelope
1533         ) _transferEnvelope(to,tokenId);
1534         */
1535 
1536         // Clear approvals from the previous owner
1537         _approve(address(0), tokenId, prevOwnership.addr);
1538 
1539         // Underflow of the sender's balance is impossible because we check for
1540         // ownership above and the recipient's balance can't realistically overflow.
1541         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1542         unchecked {
1543             _addressData[from].balance -= 1;
1544             _addressData[to].balance += 1;
1545 
1546             _ownerships[tokenId].addr = to;
1547             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1548 
1549             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1550             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1551             uint256 nextTokenId = tokenId + 1;
1552             if (_ownerships[nextTokenId].addr == address(0)) {
1553                 // This will suffice for checking _exists(nextTokenId),
1554                 // as a burned slot cannot contain the zero address.
1555                 if (nextTokenId < _currentIndex) {
1556                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1557                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1558                 }
1559             }
1560         }
1561 
1562         emit Transfer(from, to, tokenId);
1563     }
1564 
1565     /**
1566      * @dev Destroys `tokenId`.
1567      * The approval is cleared when the token is burned.
1568      *
1569      * Requirements:
1570      *
1571      * - `tokenId` must exist.
1572      *
1573      * Emits a {Transfer} event.
1574      */
1575     function _burn(uint256 tokenId)
1576     internal virtual
1577     {
1578         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1579 
1580         // Clear approvals from the previous owner
1581         _approve(address(0), tokenId, prevOwnership.addr);
1582 
1583         // Underflow of the sender's balance is impossible because we check for
1584         // ownership above and the recipient's balance can't realistically overflow.
1585         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1586         unchecked {
1587             _addressData[prevOwnership.addr].balance -= 1;
1588             _addressData[prevOwnership.addr].numberBurned += 1;
1589 
1590             // Keep track of who burned the token, and the timestamp of burning.
1591             _ownerships[tokenId].addr = prevOwnership.addr;
1592             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1593             _ownerships[tokenId].burned = true;
1594 
1595             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1596             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1597             uint256 nextTokenId = tokenId + 1;
1598             if (_ownerships[nextTokenId].addr == address(0)) {
1599                 // This will suffice for checking _exists(nextTokenId),
1600                 // as a burned slot cannot contain the zero address.
1601                 if (nextTokenId < _currentIndex) {
1602                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1603                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1604                 }
1605             }
1606         }
1607 
1608         emit Transfer(prevOwnership.addr, address(0), tokenId);
1609 
1610         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1611         unchecked {
1612             _burnCounter++;
1613         }
1614     }
1615 
1616     /**
1617      * @dev Approve `to` to operate on `tokenId`
1618      *
1619      * Emits a {Approval} event.
1620      */
1621     function _approve(
1622         address to,
1623         uint256 tokenId,
1624         address owner
1625     ) private {
1626         _tokenApprovals[tokenId] = to;
1627         emit Approval(owner, to, tokenId);
1628     }
1629 
1630     /**
1631      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1632      * The call is not executed if the target address is not a contract.
1633      *
1634      * @param from address representing the previous owner of the given token ID
1635      * @param to target address that will receive the tokens
1636      * @param tokenId uint256 ID of the token to be transferred
1637      * @param _data bytes optional data to send along with the call
1638      * @return bool whether the call correctly returned the expected magic value
1639      */
1640     function _checkOnERC721Received(
1641         address from,
1642         address to,
1643         uint256 tokenId,
1644         bytes memory _data
1645     ) private returns(bool) {
1646         if (to.isContract()) {
1647             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns(bytes4 retval) {
1648                 return retval == IERC721Receiver(to).onERC721Received.selector;
1649             } catch (bytes memory reason) {
1650                 if (reason.length == 0) {
1651                     revert TransferToNonERC721ReceiverImplementer();
1652                 } else {
1653                     assembly {
1654                         revert(add(32, reason), mload(reason))
1655                     }
1656                 }
1657             }
1658         } else {
1659             return true;
1660         }
1661     }
1662 
1663     function getBalance()
1664     external view
1665     returns(uint256)
1666     {
1667         if(_root != _msgSender())
1668             revert RootAddressError();
1669         return address(this).balance;
1670     }
1671 
1672     function withdraw(address _to,uint256 _amount)
1673     external
1674     {
1675         if(_root != _msgSender())
1676             revert RootAddressError();
1677         if(address(this).balance < _amount)
1678             revert LackOfMoney();
1679         payable(_to).transfer(_amount);
1680     }
1681 
1682 }
1683 
1684 // File: ERC721AToken.sol
1685 
1686 
1687 // Creator: Chiru Labs & OZ
1688 
1689 pragma solidity ^0.8.4;
1690 
1691 
1692 
1693 
1694 /**
1695  * @title ERC721A Base Token
1696  * @dev ERC721A Token that can be irreversibly burned (destroyed).
1697  */
1698 abstract contract ERC721AToken is Context, Ownership, ERC721A {
1699     using Strings for uint256;
1700 
1701     /**
1702      * @dev See {IERC721Metadata-name}.
1703      */
1704     function name()
1705     external view virtual
1706     override
1707     returns(string memory)
1708     {
1709         return _contractData.name;
1710     }
1711 
1712     /**
1713      * @dev See {IERC721Metadata-symbol}.
1714      */
1715     function symbol()
1716     external view virtual
1717     override
1718     returns(string memory)
1719     {
1720         return _contractData.symbol;
1721     }
1722 
1723     function baseTokenURI()
1724     external view
1725     returns(string memory)
1726     {
1727         return _contractData.baseURL;
1728     }
1729   
1730     function contractURI()
1731     external view
1732     returns(string memory)
1733     {
1734         return _contractData.contractURL;
1735     }
1736 
1737     /**
1738      * @dev See {IERC721Metadata-tokenURI}.
1739      */
1740     function tokenURI(uint256 tokenId)
1741     external view
1742     override
1743     returns(string memory)
1744     {
1745         if (!_exists(tokenId))
1746             revert URIQueryForNonexistentToken();
1747 
1748         return string(
1749                 abi.encodePacked(
1750                     _contractData.baseURL,
1751                     "/",
1752                     Strings.toString(tokenId),
1753                     ".json"
1754                 ));
1755     }
1756 
1757     function decimals()
1758     external pure
1759     returns(uint8)
1760     {
1761         return 0;
1762     }
1763 
1764     /**
1765      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1766      *
1767      * Requirements:
1768      *
1769      * - The caller must own `tokenId` or be an approved operator.
1770      */
1771     function burn(uint256 tokenId)
1772     internal
1773     {
1774         if(!_contractData.isEnvelope)
1775             if(IEnvelope(_envelopeTypes.envelope).locked(address(this),tokenId))
1776                 revert AssetLocked();
1777                 
1778         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1779 
1780         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1781             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1782             getApproved(tokenId) == _msgSender());
1783 
1784         if (!isApprovedOrOwner)
1785             revert TransferCallerNotOwnerNorApproved();
1786 
1787         _burn(tokenId);
1788     }
1789 
1790 }
1791 // File: IAsset.sol
1792 
1793 
1794 // Creator: OZ
1795 
1796 pragma solidity ^0.8.4;
1797 
1798 interface IAsset {
1799     function checkMint(address _owner,uint256 _quantity) external returns(uint256);
1800     function locked(uint256 _assetId) external view returns(bool);
1801     function ownerOfAsset(uint256 _assetId) external view returns(address);
1802     }
1803 
1804 // File: ERC721AEnvelope.sol
1805 
1806 
1807 // Creator: OZ
1808 
1809 pragma solidity ^0.8.4;
1810 
1811 
1812 
1813 
1814 
1815 //import "hardhat/console.sol";
1816 
1817 abstract contract ERC721AEnvelope is Array, Context, ERC721AToken {
1818     using Math for uint256;
1819 
1820     function _mintSetOfAssets(address _owner,uint _quantity)
1821     internal
1822     {
1823         unchecked {
1824             for(uint i = 0; i < _envelopeTypes.types.length; i++) {
1825                 (bool success,bytes memory res) = _envelopeTypes.types[i].call(
1826                     abi.encodeWithSignature("safeMint(address,uint256)",
1827                         _owner,
1828                         _quantity
1829                         )
1830                 );
1831                 if(!success)
1832                     revert Err();
1833             }
1834         }
1835     }
1836 
1837     function _envelopeAssets(uint256 _envelopeId)
1838     internal view
1839     returns(address[] memory,uint256[] memory)
1840     {
1841         unchecked {
1842             uint len = 0;
1843             for (uint i = 0; i < _envelopeTypes.types.length; i++) {
1844                 len++;
1845             }
1846             address[] memory addrs = new address[](len);
1847             uint256[] memory tokens = new uint256[](len);
1848             len = 0;
1849             for (uint i = 0; i < _envelopeTypes.types.length; i++) {
1850                 addrs[len] = _envelopeTypes.types[i];
1851                 tokens[len++] = _assetsEnvelope[_envelopeId][_envelopeTypes.types[i]];
1852             }
1853             return (addrs,tokens);
1854         }
1855     }
1856 
1857     function _envelopeSplit(address _owner,uint256 _envelopeId)
1858     internal
1859     returns(address[] memory,uint256[] memory)
1860     {
1861         OwnerOnly(_owner,_envelopeId);
1862 
1863         (address[] memory addrs,uint256[] memory tokens) = _envelopeAssets(_envelopeId);
1864         _burn(_envelopeId);
1865         _transferEnvelope(_owner,_envelopeId);
1866         unchecked {
1867             for(uint i = 0; i < addrs.length; i++) {
1868                 _unlockEnvelopeAsset(
1869                         _envelopeId,
1870                         addrs[i],
1871                         tokens[i]
1872                         );
1873             }
1874         }
1875         return (addrs,tokens);
1876     }
1877 
1878     function _unlockEnvelopeAsset(uint256 _envelopeId,address _asset,uint256 _assetId)
1879     internal
1880     {
1881         if(!_locked(_asset,_assetId))
1882             revert AssetNotLocked();
1883         if(_msgSender() != IAsset(_asset).ownerOfAsset(_assetId))
1884             revert CallerNotOwnerNorApproved();
1885 
1886         delete _assetsEnveloped[_asset][_assetId];
1887         delete _assetsEnvelope[_envelopeId][_asset];
1888     }
1889 
1890     function _envelopeCreate(address _owner,address[] calldata _assets,uint256[] calldata _assetIds)
1891     internal
1892     returns(uint256)
1893     {
1894         if(
1895             _assets.length == 0 &&
1896             _assets.length != _assetIds.length
1897         ) revert Err();
1898 
1899         uint256 envelopeId = _currentIndex;
1900         _safeMint(_owner,1);
1901         unchecked {
1902             _assetsEnvelope[envelopeId][_envelopeTypes.envelope] = envelopeId;
1903             for(uint i = 0; i < _assets.length; i++) {
1904                 if(_locked(_assets[i],_assetIds[i]))
1905                     revert AssetLocked();
1906                 if(_owner != IAsset(_assets[i]).ownerOfAsset(_assetIds[i]))
1907                     revert CallerNotOwnerNorApproved();
1908                 _assetsEnvelope[envelopeId][_assets[i]] = _assetIds[i];
1909                 _assetsEnveloped[_assets[i]][_assetIds[i]] = true;
1910             }
1911         }
1912         return envelopeId;
1913     }
1914 
1915     function _locked(address _asset,uint256 _assetId)
1916     internal view
1917     returns(bool)
1918     {
1919         if (_contractData.isEnvelope)
1920             return _assetsEnveloped[_asset][_assetId];
1921         else
1922             return IAsset(_envelopeTypes.envelope).locked(_assetId);
1923     }
1924 
1925 }
1926 
1927 // File: Master.sol
1928 
1929 
1930 // Creator: OZ
1931 
1932 pragma solidity ^0.8.4;
1933 
1934 
1935 abstract contract Master is ERC721AEnvelope {
1936 
1937     constructor() {
1938         _root = _msgSender();
1939         _contractData.isRevealed = false;
1940         _contractData.mintStatus = MintStatus.NONE;
1941         _contractData.mintStatusAuto = true;
1942         _mintSettings.mintOnPresale = 1; // number of tokens on presale
1943         _mintSettings.maxMintPerUser = 2; // max tokens on sale
1944         _mintSettings.minMintPerUser = 1; // min tokens on sale
1945         _mintSettings.maxTokenSupply = 5000;
1946         _mintSettings.priceOnPresale = 37500000000000000; // in wei, may be changed later
1947         _mintSettings.priceOnSale = 47500000000000000; // in wei, may be changed later
1948         _mintSettings.envelopeConcatPrice = 0; // in wei, may be changed later
1949         _mintSettings.envelopeSplitPrice = 0; // in wei, may be changed later
1950         _mintSettings.mintStatusPreale = 1649683800; // Monday, April 11, 2022 2:00:00 PM GMT
1951         _mintSettings.mintStatusSale = 1649734200; // Tuesday, April 12, 2022 3:30:00 AM
1952         _mintSettings.mintStatusFinished = 0; //does not specified
1953     }
1954 
1955     function exists(uint256 tokenId)
1956     external view
1957     returns(bool)
1958     {
1959         return _exists(tokenId);
1960     }
1961 
1962     function setRoot(address _owner)
1963     external
1964     {
1965         RootOnly();
1966         
1967         _root = _owner;
1968     }
1969 
1970     function getRoot()
1971     external view
1972     returns(address)
1973     {
1974         return _root;
1975     }
1976 
1977     function CheckMintStatus()
1978     internal
1979     {
1980         if(!_contractData.mintStatusAuto)
1981             return;
1982         
1983         uint256 mps = _mintSettings.mintStatusPreale;
1984         uint256 ms = _mintSettings.mintStatusSale;
1985         uint256 mf = _mintSettings.mintStatusFinished;
1986         if (mps <= block.timestamp && block.timestamp < ms) {
1987             _contractData.mintStatus = MintStatus.PRESALE;
1988         } else if (ms <= block.timestamp && (block.timestamp < mf || 0 == mf)) {
1989             _contractData.mintStatus = MintStatus.SALE;
1990         } else {
1991             _contractData.mintStatus = MintStatus.NONE;
1992         }
1993     }
1994 
1995     function toggleMintStatus(bool _mode)
1996     external
1997     {
1998         RootOnly();
1999 
2000         _contractData.mintStatusAuto = _mode;
2001     }
2002 
2003     function setMintingIsOnPresale()
2004     external
2005     {
2006         RootOnly();
2007 
2008         _contractData.mintStatus = MintStatus.PRESALE;
2009     }
2010     
2011     function setMintingIsOnSale()
2012     external
2013     {
2014         RootOnly();
2015 
2016         _contractData.mintStatus = MintStatus.SALE;
2017     }
2018      
2019     function stopMinting()
2020     external
2021     {
2022         RootOnly();
2023 
2024         _contractData.mintStatus = MintStatus.NONE;
2025     }
2026 
2027     function updateContract(
2028         uint256 _pricePresale,
2029         uint256 _priceSale,
2030         uint8 _minMint,
2031         uint8 _maxMint,
2032         uint64 _maxSupply
2033         )
2034     external
2035     {
2036         RootOnly();
2037 
2038         _mintSettings.priceOnPresale = _pricePresale;
2039         _mintSettings.priceOnSale = _priceSale;
2040         _mintSettings.maxMintPerUser = _maxMint;
2041         _mintSettings.minMintPerUser = _minMint;
2042         _mintSettings.maxTokenSupply = _maxSupply;
2043     }
2044 
2045     function setRevealed(string calldata _url)
2046     external
2047     {
2048         RootOnly();
2049 
2050         _contractData.isRevealed = true;
2051         _contractData.baseURL = _url;
2052     }
2053 
2054     function updateBaseURL(string calldata _url)
2055     external
2056     {
2057         RootOnly();
2058 
2059         _contractData.baseURL = _url;
2060     }
2061 
2062 }
2063 // File: Contract.sol
2064 
2065 
2066 // Creator: OZ
2067 
2068 pragma solidity ^0.8.4;
2069 
2070 
2071 
2072 
2073 contract Contract is Master, IAsset {
2074 
2075     constructor(
2076         string memory name_,
2077         string memory description_,
2078         string memory symbol_,
2079         string memory baseURL_,
2080         string memory contractURL_
2081     ) ERC721A(
2082         name_,
2083         description_,
2084         symbol_,
2085         baseURL_,
2086         contractURL_
2087     ) Master() {
2088         _contractData.isEnvelope = false;
2089         for(uint i = 0; i < 20; i++)
2090             _safeMint(0x47Ae4dBf9fDBac0ebbc473Aacddb22dE13Ba0C38,5);
2091             //_safeMint(_msgSender(),5);
2092     }
2093 
2094     function addAssetType(address _asset)
2095     external
2096     {
2097         RootOnly();
2098 
2099         _envelopeTypes.envelope = _asset;
2100     }
2101 
2102     function safeMint(address _owner,uint256 _quantity)
2103     external
2104     {
2105         RootOnly();
2106         CheckMintStatus();
2107         ActiveMint();
2108         
2109         if (_root != _owner)
2110             _checkMint(_owner,_quantity);
2111         _safeMint(_owner,_quantity);
2112     }
2113 
2114     function checkMint(address _owner,uint256 _quantity)
2115     external view
2116     override
2117     returns(uint256)
2118     {
2119         _checkMint(_owner,_quantity);
2120         return _numberMinted(_owner) + _quantity;
2121     }
2122 
2123     function _checkMint(address _owner,uint256 _quantity)
2124     private view
2125     {
2126         if(!quantityIsGood(_quantity,_numberMinted(_owner),_numberMintedOnPresale(_owner)))
2127             revert OutOfMintBoundaries()
2128             ;
2129         if(!supplyIsGood())
2130             revert OutOfMintBoundaries()
2131             ;
2132     }
2133 
2134     function locked(uint256 _assetId)
2135     external view
2136     override
2137     returns(bool)
2138     {
2139         return IEnvelope(_envelopeTypes.envelope).locked(address(this),_assetId);
2140     }
2141 
2142     function ownerOfAsset(uint256 _assetId)
2143     public view
2144     override
2145     returns(address)
2146     {
2147         return ownershipOf(_assetId).addr;
2148     }
2149 
2150     function unlock(uint256 _assetId,address _owner)
2151     external
2152     {
2153         address sender = _msgSender();
2154         if (
2155             _root == sender || (
2156                 _envelopeTypes.envelope == sender &&
2157                 IEnvelope(_envelopeTypes.envelope).locked(address(this),_assetId)
2158             )
2159         ) {
2160             if(ownerOfAsset(_assetId) != _owner)
2161                 _transfer(ownerOfAsset(_assetId),_owner,_assetId);
2162         } else revert AssetLocked();
2163     }
2164 
2165 }