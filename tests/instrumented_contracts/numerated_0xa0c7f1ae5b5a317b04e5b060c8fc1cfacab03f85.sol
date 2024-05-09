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
321 // File: IEnvelope.sol
322 
323 
324 // Creator: OZ
325 
326 pragma solidity ^0.8.4;
327 
328 interface IEnvelope {
329     function locked(address _asset,uint256 _assetId) external view returns(bool);
330     function ownerOfAsset(uint256 _assetId) external view returns(address);
331     }
332 
333 // File: @openzeppelin/contracts/utils/Address.sol
334 
335 
336 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
337 
338 pragma solidity ^0.8.1;
339 
340 /**
341  * @dev Collection of functions related to the address type
342  */
343 library Address {
344     /**
345      * @dev Returns true if `account` is a contract.
346      *
347      * [IMPORTANT]
348      * ====
349      * It is unsafe to assume that an address for which this function returns
350      * false is an externally-owned account (EOA) and not a contract.
351      *
352      * Among others, `isContract` will return false for the following
353      * types of addresses:
354      *
355      *  - an externally-owned account
356      *  - a contract in construction
357      *  - an address where a contract will be created
358      *  - an address where a contract lived, but was destroyed
359      * ====
360      *
361      * [IMPORTANT]
362      * ====
363      * You shouldn't rely on `isContract` to protect against flash loan attacks!
364      *
365      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
366      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
367      * constructor.
368      * ====
369      */
370     function isContract(address account) internal view returns (bool) {
371         // This method relies on extcodesize/address.code.length, which returns 0
372         // for contracts in construction, since the code is only stored at the end
373         // of the constructor execution.
374 
375         return account.code.length > 0;
376     }
377 
378     /**
379      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
380      * `recipient`, forwarding all available gas and reverting on errors.
381      *
382      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
383      * of certain opcodes, possibly making contracts go over the 2300 gas limit
384      * imposed by `transfer`, making them unable to receive funds via
385      * `transfer`. {sendValue} removes this limitation.
386      *
387      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
388      *
389      * IMPORTANT: because control is transferred to `recipient`, care must be
390      * taken to not create reentrancy vulnerabilities. Consider using
391      * {ReentrancyGuard} or the
392      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
393      */
394     function sendValue(address payable recipient, uint256 amount) internal {
395         require(address(this).balance >= amount, "Address: insufficient balance");
396 
397         (bool success, ) = recipient.call{value: amount}("");
398         require(success, "Address: unable to send value, recipient may have reverted");
399     }
400 
401     /**
402      * @dev Performs a Solidity function call using a low level `call`. A
403      * plain `call` is an unsafe replacement for a function call: use this
404      * function instead.
405      *
406      * If `target` reverts with a revert reason, it is bubbled up by this
407      * function (like regular Solidity function calls).
408      *
409      * Returns the raw returned data. To convert to the expected return value,
410      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
411      *
412      * Requirements:
413      *
414      * - `target` must be a contract.
415      * - calling `target` with `data` must not revert.
416      *
417      * _Available since v3.1._
418      */
419     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
420         return functionCall(target, data, "Address: low-level call failed");
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
425      * `errorMessage` as a fallback revert reason when `target` reverts.
426      *
427      * _Available since v3.1._
428      */
429     function functionCall(
430         address target,
431         bytes memory data,
432         string memory errorMessage
433     ) internal returns (bytes memory) {
434         return functionCallWithValue(target, data, 0, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but also transferring `value` wei to `target`.
440      *
441      * Requirements:
442      *
443      * - the calling contract must have an ETH balance of at least `value`.
444      * - the called Solidity function must be `payable`.
445      *
446      * _Available since v3.1._
447      */
448     function functionCallWithValue(
449         address target,
450         bytes memory data,
451         uint256 value
452     ) internal returns (bytes memory) {
453         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
458      * with `errorMessage` as a fallback revert reason when `target` reverts.
459      *
460      * _Available since v3.1._
461      */
462     function functionCallWithValue(
463         address target,
464         bytes memory data,
465         uint256 value,
466         string memory errorMessage
467     ) internal returns (bytes memory) {
468         require(address(this).balance >= value, "Address: insufficient balance for call");
469         require(isContract(target), "Address: call to non-contract");
470 
471         (bool success, bytes memory returndata) = target.call{value: value}(data);
472         return verifyCallResult(success, returndata, errorMessage);
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
477      * but performing a static call.
478      *
479      * _Available since v3.3._
480      */
481     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
482         return functionStaticCall(target, data, "Address: low-level static call failed");
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
487      * but performing a static call.
488      *
489      * _Available since v3.3._
490      */
491     function functionStaticCall(
492         address target,
493         bytes memory data,
494         string memory errorMessage
495     ) internal view returns (bytes memory) {
496         require(isContract(target), "Address: static call to non-contract");
497 
498         (bool success, bytes memory returndata) = target.staticcall(data);
499         return verifyCallResult(success, returndata, errorMessage);
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
504      * but performing a delegate call.
505      *
506      * _Available since v3.4._
507      */
508     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
509         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
510     }
511 
512     /**
513      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
514      * but performing a delegate call.
515      *
516      * _Available since v3.4._
517      */
518     function functionDelegateCall(
519         address target,
520         bytes memory data,
521         string memory errorMessage
522     ) internal returns (bytes memory) {
523         require(isContract(target), "Address: delegate call to non-contract");
524 
525         (bool success, bytes memory returndata) = target.delegatecall(data);
526         return verifyCallResult(success, returndata, errorMessage);
527     }
528 
529     /**
530      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
531      * revert reason using the provided one.
532      *
533      * _Available since v4.3._
534      */
535     function verifyCallResult(
536         bool success,
537         bytes memory returndata,
538         string memory errorMessage
539     ) internal pure returns (bytes memory) {
540         if (success) {
541             return returndata;
542         } else {
543             // Look for revert reason and bubble it up if present
544             if (returndata.length > 0) {
545                 // The easiest way to bubble the revert reason is using memory via assembly
546 
547                 assembly {
548                     let returndata_size := mload(returndata)
549                     revert(add(32, returndata), returndata_size)
550                 }
551             } else {
552                 revert(errorMessage);
553             }
554         }
555     }
556 }
557 
558 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
559 
560 
561 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 /**
566  * @title ERC721 token receiver interface
567  * @dev Interface for any contract that wants to support safeTransfers
568  * from ERC721 asset contracts.
569  */
570 interface IERC721Receiver {
571     /**
572      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
573      * by `operator` from `from`, this function is called.
574      *
575      * It must return its Solidity selector to confirm the token transfer.
576      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
577      *
578      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
579      */
580     function onERC721Received(
581         address operator,
582         address from,
583         uint256 tokenId,
584         bytes calldata data
585     ) external returns (bytes4);
586 }
587 
588 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
589 
590 
591 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
592 
593 pragma solidity ^0.8.0;
594 
595 /**
596  * @dev Interface of the ERC165 standard, as defined in the
597  * https://eips.ethereum.org/EIPS/eip-165[EIP].
598  *
599  * Implementers can declare support of contract interfaces, which can then be
600  * queried by others ({ERC165Checker}).
601  *
602  * For an implementation, see {ERC165}.
603  */
604 interface IERC165 {
605     /**
606      * @dev Returns true if this contract implements the interface defined by
607      * `interfaceId`. See the corresponding
608      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
609      * to learn more about how these ids are created.
610      *
611      * This function call must use less than 30 000 gas.
612      */
613     function supportsInterface(bytes4 interfaceId) external view returns (bool);
614 }
615 
616 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
617 
618 
619 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
620 
621 pragma solidity ^0.8.0;
622 
623 
624 /**
625  * @dev Implementation of the {IERC165} interface.
626  *
627  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
628  * for the additional interface id that will be supported. For example:
629  *
630  * ```solidity
631  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
632  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
633  * }
634  * ```
635  *
636  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
637  */
638 abstract contract ERC165 is IERC165 {
639     /**
640      * @dev See {IERC165-supportsInterface}.
641      */
642     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
643         return interfaceId == type(IERC165).interfaceId;
644     }
645 }
646 
647 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
648 
649 
650 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
651 
652 pragma solidity ^0.8.0;
653 
654 
655 /**
656  * @dev Required interface of an ERC721 compliant contract.
657  */
658 interface IERC721 is IERC165 {
659     /**
660      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
661      */
662     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
663 
664     /**
665      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
666      */
667     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
668 
669     /**
670      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
671      */
672     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
673 
674     /**
675      * @dev Returns the number of tokens in ``owner``'s account.
676      */
677     function balanceOf(address owner) external view returns (uint256 balance);
678 
679     /**
680      * @dev Returns the owner of the `tokenId` token.
681      *
682      * Requirements:
683      *
684      * - `tokenId` must exist.
685      */
686     function ownerOf(uint256 tokenId) external view returns (address owner);
687 
688     /**
689      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
690      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
691      *
692      * Requirements:
693      *
694      * - `from` cannot be the zero address.
695      * - `to` cannot be the zero address.
696      * - `tokenId` token must exist and be owned by `from`.
697      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
698      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
699      *
700      * Emits a {Transfer} event.
701      */
702     function safeTransferFrom(
703         address from,
704         address to,
705         uint256 tokenId
706     ) external;
707 
708     /**
709      * @dev Transfers `tokenId` token from `from` to `to`.
710      *
711      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
712      *
713      * Requirements:
714      *
715      * - `from` cannot be the zero address.
716      * - `to` cannot be the zero address.
717      * - `tokenId` token must be owned by `from`.
718      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
719      *
720      * Emits a {Transfer} event.
721      */
722     function transferFrom(
723         address from,
724         address to,
725         uint256 tokenId
726     ) external;
727 
728     /**
729      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
730      * The approval is cleared when the token is transferred.
731      *
732      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
733      *
734      * Requirements:
735      *
736      * - The caller must own the token or be an approved operator.
737      * - `tokenId` must exist.
738      *
739      * Emits an {Approval} event.
740      */
741     function approve(address to, uint256 tokenId) external;
742 
743     /**
744      * @dev Returns the account approved for `tokenId` token.
745      *
746      * Requirements:
747      *
748      * - `tokenId` must exist.
749      */
750     function getApproved(uint256 tokenId) external view returns (address operator);
751 
752     /**
753      * @dev Approve or remove `operator` as an operator for the caller.
754      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
755      *
756      * Requirements:
757      *
758      * - The `operator` cannot be the caller.
759      *
760      * Emits an {ApprovalForAll} event.
761      */
762     function setApprovalForAll(address operator, bool _approved) external;
763 
764     /**
765      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
766      *
767      * See {setApprovalForAll}
768      */
769     function isApprovedForAll(address owner, address operator) external view returns (bool);
770 
771     /**
772      * @dev Safely transfers `tokenId` token from `from` to `to`.
773      *
774      * Requirements:
775      *
776      * - `from` cannot be the zero address.
777      * - `to` cannot be the zero address.
778      * - `tokenId` token must exist and be owned by `from`.
779      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
780      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
781      *
782      * Emits a {Transfer} event.
783      */
784     function safeTransferFrom(
785         address from,
786         address to,
787         uint256 tokenId,
788         bytes calldata data
789     ) external;
790 }
791 
792 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
793 
794 
795 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
796 
797 pragma solidity ^0.8.0;
798 
799 
800 /**
801  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
802  * @dev See https://eips.ethereum.org/EIPS/eip-721
803  */
804 interface IERC721Enumerable is IERC721 {
805     /**
806      * @dev Returns the total amount of tokens stored by the contract.
807      */
808     function totalSupply() external view returns (uint256);
809 
810     /**
811      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
812      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
813      */
814     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
815 
816     /**
817      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
818      * Use along with {totalSupply} to enumerate all tokens.
819      */
820     function tokenByIndex(uint256 index) external view returns (uint256);
821 }
822 
823 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
824 
825 
826 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
827 
828 pragma solidity ^0.8.0;
829 
830 
831 /**
832  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
833  * @dev See https://eips.ethereum.org/EIPS/eip-721
834  */
835 interface IERC721Metadata is IERC721 {
836     /**
837      * @dev Returns the token collection name.
838      */
839     function name() external view returns (string memory);
840 
841     /**
842      * @dev Returns the token collection symbol.
843      */
844     function symbol() external view returns (string memory);
845 
846     /**
847      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
848      */
849     function tokenURI(uint256 tokenId) external view returns (string memory);
850 }
851 
852 // File: @openzeppelin/contracts/utils/Context.sol
853 
854 
855 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
856 
857 pragma solidity ^0.8.0;
858 
859 /**
860  * @dev Provides information about the current execution context, including the
861  * sender of the transaction and its data. While these are generally available
862  * via msg.sender and msg.data, they should not be accessed in such a direct
863  * manner, since when dealing with meta-transactions the account sending and
864  * paying for execution may not be the actual sender (as far as an application
865  * is concerned).
866  *
867  * This contract is only required for intermediate, library-like contracts.
868  */
869 abstract contract Context {
870     function _msgSender() internal view virtual returns (address) {
871         return msg.sender;
872     }
873 
874     function _msgData() internal view virtual returns (bytes calldata) {
875         return msg.data;
876     }
877 }
878 
879 // File: Ownership.sol
880 
881 
882 // Creator: OZ using Chiru Labs
883 
884 pragma solidity ^0.8.4;
885 
886 
887 
888 
889 
890 contract Ownership is Context, TokenStorage {
891 
892     /**
893      * Gas spent here starts off proportional to the maximum mint batch size.
894      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
895      */
896     function ownershipOf(uint256 tokenId)
897     internal view
898     returns (TokenOwnership memory)
899     {
900         uint256 curr = tokenId;
901 
902         unchecked {
903             if (curr < _currentIndex) {
904                 TokenOwnership memory ownership = _ownerships[curr];
905                 if (!ownership.burned) {
906                     if (ownership.addr != address(0)) {
907                         return ownership;
908                     }
909                     // Invariant: 
910                     // There will always be an ownership that has an address and is not burned 
911                     // before an ownership that does not have an address and is not burned.
912                     // Hence, curr will not underflow.
913                     while (true) {
914                         curr--;
915                         ownership = _ownerships[curr];
916                         if (ownership.addr != address(0)) {
917                             return ownership;
918                         }
919                     }
920                 }
921             }
922         }
923         revert OwnerQueryForNonexistentToken();
924     }
925 
926     uint256[] private __tokens__;
927 
928     function tokensOf(address _owner)
929     external
930     returns(uint256[] memory tokens)
931     {
932         unchecked {
933             for(uint i=0;i<_currentIndex;i++) {
934                 TokenOwnership memory ownership = ownershipOf(i);
935                 if(ownership.addr == _owner) {
936                     if (!ownership.burned) {
937                         if(_contractData.isEnvelope) {
938                             __tokens__.push(i);
939                         } else {
940                             if(!IEnvelope(_envelopeTypes.envelope).locked(address(this),i)) {
941                                 __tokens__.push(i);
942                             }
943                         }
944                     }
945                 }
946             }
947             return __tokens__;
948         }
949     }
950 
951 }
952 // File: AccessControl.sol
953 
954 
955 // Creator: OZ
956 
957 pragma solidity ^0.8.4;
958 
959 
960 
961 
962 contract AccessControl is Ownership {
963 
964     function ActiveMint()
965     internal view
966     {
967         if(MintStatus.NONE == _contractData.mintStatus)
968             revert MintShouldBeOpened();
969     }
970 
971     function ApprovedOnly(address owner)
972     internal view
973     {
974         if (!_operatorApprovals[owner][_msgSender()])
975             revert CallerNotOwnerNorApproved();
976     }
977 
978     function BotProtection()
979     internal view
980     {
981         if(tx.origin != msg.sender)
982             revert Err();
983     }
984 
985     function OwnerOnly(address owner,uint256 tokenId)
986     internal view
987     {
988         if (owner != ownershipOf(tokenId).addr)
989             revert CallerNotOwnerNorApproved();
990     }
991 
992     function RootOnly()
993     internal view
994     {
995         address sender = _msgSender();
996         if(
997             sender != _root &&
998             sender != _envelopeTypes.envelope
999         ) revert RootAddressError();
1000     }
1001 
1002     function Whitelisted(bytes32[] calldata _merkleProof)
1003     internal view
1004     {
1005         address sender = _msgSender();
1006         bool flag =
1007             _root == sender ||
1008             _contractData.mintStatus == MintStatus.SALE
1009         ;
1010 
1011         /**
1012          * Set merkle tree root
1013          */
1014         if(!flag)
1015             flag = MerkleProof.verify(_merkleProof, _contractData.wl, keccak256(abi.encodePacked(sender)));
1016 
1017         /**/
1018         if(!flag)
1019             revert WhitelistedOnly();
1020     }
1021 
1022     function setWLRoot(bytes32 _root)
1023     external
1024     {
1025         RootOnly();
1026 
1027         _contractData.wl = _root;
1028     }
1029 
1030 }
1031 // File: Array.sol
1032 
1033 
1034 // Creator: OZ
1035 
1036 pragma solidity ^0.8.4;
1037 
1038 contract Array{
1039 
1040     function remove(uint256[] memory arr, uint256 e)
1041     internal pure
1042     {
1043         unchecked {
1044             uint idx = 0;
1045             for(uint i = 0; i < arr.length; i++) {
1046                 if(arr[i] == e) {
1047                     idx = i;
1048                 }
1049             }
1050             for (uint i = idx; i < arr.length-1; i++){
1051                 arr[i] = arr[i+1];        
1052             }
1053             delete arr[arr.length - 1];
1054         }
1055     }
1056     
1057 }
1058 // File: Math.sol
1059 
1060 
1061 pragma solidity ^0.8.4;
1062 
1063 library Math{
1064 
1065     function max(uint256 a,uint256 b) internal pure returns(uint256)
1066     {
1067         return a >= b ? a : b;
1068     }
1069 
1070     function min(uint256 a,uint256 b) internal pure returns(uint256)
1071     {
1072         return a < b ? a : b;
1073     }
1074 
1075     function average(uint256 a,uint256 b) internal pure returns(uint256)
1076     {
1077         return (a & b) + (a ^ b) / 2;
1078     }
1079 
1080     function ceilDiv(uint256 a,uint256 b) internal pure returns(uint256)
1081     {
1082         return a / b + (a % b == 0 ? 0 : 1);
1083     }
1084 
1085     function mul(uint256 a,uint256 b) internal pure returns(uint256 c)
1086     {
1087         if (0 == a) {
1088             return 0;
1089         }
1090         c = a * b;
1091         assert(c / a == b);
1092         return c;
1093     }
1094 
1095     function div(uint256 a,uint256 b) internal pure returns(uint256)
1096     {
1097         assert(0 != b);
1098         return a / b;
1099     }
1100 
1101     function sub(uint256 a,uint256 b) internal pure returns(uint256)
1102     {
1103         assert(b <= a);
1104         return a - b;
1105     }
1106 
1107     function add(uint256 a,uint256 b) internal pure returns(uint256 c)
1108     {
1109         c = a + b;
1110         assert(c >= a);
1111         return c;
1112     }
1113 }
1114 
1115 // File: Payment.sol
1116 
1117 
1118 // Creator: OZ
1119 
1120 pragma solidity ^0.8.4;
1121 
1122 
1123 
1124 contract Payment is TokenStorage {
1125 
1126     function lackOfMoney(uint _quantity)
1127     internal
1128     returns(bool)
1129     {
1130         return msg.value < Math.mul(_contractData.mintStatus == MintStatus.PRESALE ?
1131         _mintSettings.priceOnPresale : _mintSettings.priceOnSale
1132         ,_quantity);
1133     }
1134 
1135     function lackOfMoneyForConcat()
1136     internal
1137     returns(bool)
1138     {
1139         return
1140             _mintSettings.envelopeConcatPrice != 0 &&
1141             _mintSettings.envelopeConcatPrice > msg.value
1142             ;
1143     }
1144 
1145     function lackOfMoneyForSplit()
1146     internal
1147     returns(bool)
1148     {
1149         return
1150             _mintSettings.envelopeSplitPrice != 0 &&
1151             _mintSettings.envelopeSplitPrice > msg.value
1152             ;
1153     }
1154 
1155 }
1156 // File: Quantity.sol
1157 
1158 
1159 // Creator: OZ
1160 
1161 pragma solidity ^0.8.4;
1162 
1163 
1164 
1165 contract Quantity is TokenStorage {
1166 
1167     function quantityIsGood(uint256 _quantity,uint256 _minted,uint256 _mintedOnPresale)
1168     internal view
1169     returns(bool)
1170     {
1171         return
1172             (
1173                 _contractData.mintStatus == MintStatus.PRESALE &&
1174                 _mintSettings.mintOnPresale >= _quantity + _minted
1175             ) || (
1176                 _contractData.mintStatus == MintStatus.SALE &&
1177                 _mintSettings.maxMintPerUser >= _quantity + _minted - _mintedOnPresale &&
1178                 _mintSettings.minMintPerUser <= _quantity
1179             )
1180             ;
1181     }
1182 
1183     function supplyIsGood()
1184     internal view
1185     returns(bool)
1186     {
1187         return
1188             _contractData.isEnvelope || (
1189                 _contractData.isEnvelope == false &&
1190                 _mintSettings.maxTokenSupply > _currentIndex
1191             )
1192             ;
1193     }
1194 
1195 }
1196 // File: ERC721A.sol
1197 
1198 
1199 // Creator: Chiru Labs
1200 
1201 pragma solidity ^0.8.4;
1202 
1203 
1204 
1205 
1206 
1207 
1208 
1209 
1210 
1211 
1212 
1213 
1214 //import "hardhat/console.sol";
1215 
1216 /**
1217  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1218  * the Metadata extension. Built to optimize for lower gas during batch mints.
1219  *
1220  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1221  *
1222  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1223  *
1224  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1225  */
1226 abstract contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, AccessControl, Quantity {
1227     using Address for address;
1228     using Strings for uint256;
1229 
1230     constructor(
1231         string memory name_,
1232         string memory description_,
1233         string memory symbol_,
1234         string memory baseURL_,
1235         string memory contractURL_
1236     ) {
1237         _contractData.name = name_;
1238         _contractData.description = description_;
1239         _contractData.symbol = symbol_;
1240         _contractData.baseURL = baseURL_;
1241         _contractData.contractURL = contractURL_;
1242     }
1243 
1244     /**
1245      * @dev See {IERC721Enumerable-totalSupply}.
1246      */
1247     function totalSupply()
1248     public view
1249     returns(uint256)
1250     {
1251         // Counter underflow is impossible as _burnCounter cannot be incremented
1252         // more than _currentIndex times
1253         unchecked {
1254             return _currentIndex - _burnCounter;    
1255         }
1256     }
1257 
1258     /**
1259      * @dev See {IERC165-supportsInterface}.
1260      */
1261     function supportsInterface(bytes4 interfaceId)
1262     public view virtual
1263     override(ERC165, IERC165)
1264     returns(bool)
1265     {
1266         return
1267             interfaceId == type(IERC721).interfaceId ||
1268             interfaceId == type(IERC721Metadata).interfaceId ||
1269             super.supportsInterface(interfaceId);
1270     }
1271 
1272     /**
1273      * @dev See {IERC721-balanceOf}.
1274      */
1275     function balanceOf(address owner)
1276     public view
1277     override
1278     returns(uint256)
1279     {
1280         if (owner == address(0))
1281             revert BalanceQueryForZeroAddress();
1282         return uint256(_addressData[owner].balance);
1283     }
1284 
1285     /**
1286      * returnsthe number of tokens minted by `owner`.
1287      */
1288     function _numberMinted(address owner)
1289     internal view
1290     returns(uint256)
1291     {
1292         if (owner == address(0))
1293             revert MintedQueryForZeroAddress();
1294         else return
1295             uint256(_addressData[owner].numberMinted);
1296     }
1297 
1298     function _numberMintedOnPresale(address owner)
1299     internal view
1300     returns(uint256)
1301     {
1302         if (owner == address(0))
1303             revert MintedQueryForZeroAddress();
1304         else return
1305             uint256(_addressData[owner].numberMintedOnPresale);
1306     }
1307 
1308     /**
1309      * returnsthe number of tokens burned by or on behalf of `owner`.
1310      */
1311     function _numberBurned(address owner)
1312     internal view
1313     returns(uint256)
1314     {
1315         if (owner == address(0))
1316             revert BurnedQueryForZeroAddress();
1317         else return
1318             uint256(_addressData[owner].numberBurned);
1319     }
1320 
1321     /**
1322      * @dev See {IERC721-ownerOf}.
1323      */
1324     function ownerOf(uint256 tokenId)
1325     public view
1326     override
1327     returns(address)
1328     {
1329         if(!_contractData.isEnvelope) {
1330             if(IEnvelope(_envelopeTypes.envelope).locked(address(this),tokenId)) {
1331                 return address(0);
1332             }
1333         }
1334         return ownershipOf(tokenId).addr;
1335     }
1336 
1337     /**
1338      * @dev See {IERC721-approve}.
1339      */
1340     function approve(address to, uint256 tokenId)
1341     public
1342     override
1343     {
1344         address owner = ERC721A.ownerOf(tokenId);
1345         if (to == owner)
1346             revert ApprovalToCurrentOwner();
1347         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender()))
1348             revert CallerNotOwnerNorApproved();
1349         _approve(to, tokenId, owner);
1350     }
1351 
1352     /**
1353      * @dev See {IERC721-getApproved}.
1354      */
1355     function getApproved(uint256 tokenId)
1356     public view
1357     override
1358     returns(address)
1359     {
1360         if (!_exists(tokenId))
1361             revert ApprovalQueryForNonexistentToken();
1362         else return
1363             _tokenApprovals[tokenId];
1364     }
1365 
1366     /**
1367      * @dev See {IERC721-setApprovalForAll}.
1368      */
1369     function setApprovalForAll(address operator, bool approved)
1370     public
1371     override
1372     {
1373         if (operator == _msgSender())
1374             revert ApproveToCaller();
1375         _operatorApprovals[_msgSender()][operator] = approved;
1376         emit ApprovalForAll(_msgSender(), operator, approved);
1377     }
1378 
1379     /**
1380      * @dev See {IERC721-isApprovedForAll}.
1381      */
1382     function isApprovedForAll(address owner, address operator)
1383     public view virtual
1384     override
1385     returns(bool)
1386     {
1387         return _operatorApprovals[owner][operator];
1388     }
1389 
1390     /**
1391      * @dev See {IERC721-transferFrom}.
1392      */
1393     function transferFrom(
1394         address from,
1395         address to,
1396         uint256 tokenId
1397     ) public virtual override {
1398         if(!_contractData.isEnvelope)
1399             if(IEnvelope(_envelopeTypes.envelope).locked(address(this),tokenId))
1400                 revert AssetLocked();
1401                 
1402         _transfer(from, to, tokenId);
1403     }
1404 
1405     /**
1406      * @dev See {IERC721-safeTransferFrom}.
1407      */
1408     function safeTransferFrom(
1409         address from,
1410         address to,
1411         uint256 tokenId
1412     ) public virtual override {
1413         safeTransferFrom(from, to, tokenId, '');
1414     }
1415 
1416     /**
1417      * @dev See {IERC721-safeTransferFrom}.
1418      */
1419     function safeTransferFrom(
1420         address from,
1421         address to,
1422         uint256 tokenId,
1423         bytes memory _data
1424     ) public virtual override {
1425         if(!_contractData.isEnvelope)
1426             if(IEnvelope(_envelopeTypes.envelope).locked(address(this),tokenId))
1427                 revert AssetLocked();
1428 
1429         _transfer(from, to, tokenId);
1430         if (!_checkOnERC721Received(from, to, tokenId, _data))
1431             revert TransferToNonERC721ReceiverImplementer();
1432     }
1433 
1434     /**
1435      * @dev returnswhether `tokenId` exists.
1436      *
1437      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1438      *
1439      * Tokens start existing when they are minted (`_mint`),
1440      */
1441     function _exists(uint256 tokenId)
1442     internal view
1443     returns(bool)
1444     {
1445         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1446     }
1447 
1448     function _safeMint(address to, uint256 quantity) internal {
1449         _safeMint(to, quantity, '');
1450     }
1451 
1452     /**
1453      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1454      *
1455      * Requirements:
1456      *
1457      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1458      * - `quantity` must be greater than 0.
1459      *
1460      * Emits a {Transfer} event.
1461      */
1462     function _safeMint(
1463         address to,
1464         uint256 quantity,
1465         bytes memory _data
1466     ) internal {
1467         _mint(to, quantity, _data, true);
1468     }
1469 
1470     /**
1471      * @dev Mints `quantity` tokens and transfers them to `to`.
1472      *
1473      * Requirements:
1474      *
1475      * - `to` cannot be the zero address.
1476      * - `quantity` must be greater than 0.
1477      *
1478      * Emits a {Transfer} event.
1479      */
1480     function _mint(
1481         address to,
1482         uint256 quantity,
1483         bytes memory _data,
1484         bool safe
1485     ) internal {
1486         uint256 startTokenId = _currentIndex;
1487         if(!supplyIsGood())
1488             revert OutOfMintBoundaries();
1489         if (to == address(0))
1490             revert MintToZeroAddress();
1491         if (quantity == 0)
1492             revert MintZeroQuantity();
1493 
1494         // Overflows are incredibly unrealistic.
1495         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1496         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1497         unchecked {
1498             _addressData[to].balance += uint64(quantity);
1499             _addressData[to].numberMinted += uint64(quantity);
1500             if(_contractData.mintStatus == MintStatus.PRESALE)
1501                 _addressData[to].numberMintedOnPresale = _addressData[to].numberMintedOnPresale + uint64(quantity);
1502 
1503             _ownerships[startTokenId].addr = to;
1504             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1505 
1506             uint256 updatedIndex = startTokenId;
1507             for (uint256 i; i < quantity; i++) {
1508                 emit Transfer(address(0), to, updatedIndex);
1509                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data))
1510                     revert TransferToNonERC721ReceiverImplementer();
1511                 updatedIndex++;
1512             }
1513 
1514             _currentIndex = updatedIndex;
1515         }
1516     }
1517 
1518     /**
1519      * Transfer set and all its assets
1520      */
1521     function _transferEnvelope(address _to,uint256 _assetId)
1522     internal
1523     {
1524         unchecked {
1525             for (uint i = 0; i < _envelopeTypes.types.length; i++) {
1526                 (bool success,bytes memory res) = _envelopeTypes.types[i].call(
1527                     abi.encodeWithSignature("unlock(uint256,address)",
1528                         _assetsEnvelope[_assetId][_envelopeTypes.types[i]],
1529                         _to)
1530                 );
1531                 if(!success)
1532                     revert AssetCannotBeTransfered();
1533             }
1534         }
1535     }
1536 
1537     /**
1538      * @dev Transfers `tokenId` from `from` to `to`.
1539      *
1540      * Requirements:
1541      *
1542      * - `to` cannot be the zero address.
1543      * - `tokenId` token must be owned by `from`.
1544      *
1545      * Emits a {Transfer} event.
1546      */
1547     function _transfer(
1548         address from,
1549         address to,
1550         uint256 tokenId
1551     ) internal {
1552 
1553         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1554         address sender = _msgSender();
1555 
1556         bool isApprovedOrOwner = (
1557             sender == _envelopeTypes.envelope ||
1558             sender == prevOwnership.addr ||
1559             sender == getApproved(tokenId) ||
1560             isApprovedForAll(prevOwnership.addr, sender)
1561         );
1562 
1563         if (!isApprovedOrOwner)
1564             revert TransferCallerNotOwnerNorApproved();
1565         if (prevOwnership.addr != from)
1566             revert TransferFromIncorrectOwner();
1567         if (to == address(0))
1568             revert TransferToZeroAddress();
1569 
1570         /*
1571         if(
1572             sender == prevOwnership.addr &&
1573             _contractData.isEnvelope
1574         ) _transferEnvelope(to,tokenId);
1575         */
1576 
1577         // Clear approvals from the previous owner
1578         _approve(address(0), tokenId, prevOwnership.addr);
1579 
1580         // Underflow of the sender's balance is impossible because we check for
1581         // ownership above and the recipient's balance can't realistically overflow.
1582         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1583         unchecked {
1584             _addressData[from].balance -= 1;
1585             _addressData[to].balance += 1;
1586 
1587             _ownerships[tokenId].addr = to;
1588             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1589 
1590             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1591             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1592             uint256 nextTokenId = tokenId + 1;
1593             if (_ownerships[nextTokenId].addr == address(0)) {
1594                 // This will suffice for checking _exists(nextTokenId),
1595                 // as a burned slot cannot contain the zero address.
1596                 if (nextTokenId < _currentIndex) {
1597                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1598                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1599                 }
1600             }
1601         }
1602 
1603         emit Transfer(from, to, tokenId);
1604     }
1605 
1606     /**
1607      * @dev Destroys `tokenId`.
1608      * The approval is cleared when the token is burned.
1609      *
1610      * Requirements:
1611      *
1612      * - `tokenId` must exist.
1613      *
1614      * Emits a {Transfer} event.
1615      */
1616     function _burn(uint256 tokenId)
1617     internal virtual
1618     {
1619         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1620 
1621         // Clear approvals from the previous owner
1622         _approve(address(0), tokenId, prevOwnership.addr);
1623 
1624         // Underflow of the sender's balance is impossible because we check for
1625         // ownership above and the recipient's balance can't realistically overflow.
1626         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1627         unchecked {
1628             _addressData[prevOwnership.addr].balance -= 1;
1629             _addressData[prevOwnership.addr].numberBurned += 1;
1630 
1631             // Keep track of who burned the token, and the timestamp of burning.
1632             _ownerships[tokenId].addr = prevOwnership.addr;
1633             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1634             _ownerships[tokenId].burned = true;
1635 
1636             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1637             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1638             uint256 nextTokenId = tokenId + 1;
1639             if (_ownerships[nextTokenId].addr == address(0)) {
1640                 // This will suffice for checking _exists(nextTokenId),
1641                 // as a burned slot cannot contain the zero address.
1642                 if (nextTokenId < _currentIndex) {
1643                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1644                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1645                 }
1646             }
1647         }
1648 
1649         emit Transfer(prevOwnership.addr, address(0), tokenId);
1650 
1651         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1652         unchecked {
1653             _burnCounter++;
1654         }
1655     }
1656 
1657     /**
1658      * @dev Approve `to` to operate on `tokenId`
1659      *
1660      * Emits a {Approval} event.
1661      */
1662     function _approve(
1663         address to,
1664         uint256 tokenId,
1665         address owner
1666     ) private {
1667         _tokenApprovals[tokenId] = to;
1668         emit Approval(owner, to, tokenId);
1669     }
1670 
1671     /**
1672      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1673      * The call is not executed if the target address is not a contract.
1674      *
1675      * @param from address representing the previous owner of the given token ID
1676      * @param to target address that will receive the tokens
1677      * @param tokenId uint256 ID of the token to be transferred
1678      * @param _data bytes optional data to send along with the call
1679      * @return bool whether the call correctly returned the expected magic value
1680      */
1681     function _checkOnERC721Received(
1682         address from,
1683         address to,
1684         uint256 tokenId,
1685         bytes memory _data
1686     ) private returns(bool) {
1687         if (to.isContract()) {
1688             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns(bytes4 retval) {
1689                 return retval == IERC721Receiver(to).onERC721Received.selector;
1690             } catch (bytes memory reason) {
1691                 if (reason.length == 0) {
1692                     revert TransferToNonERC721ReceiverImplementer();
1693                 } else {
1694                     assembly {
1695                         revert(add(32, reason), mload(reason))
1696                     }
1697                 }
1698             }
1699         } else {
1700             return true;
1701         }
1702     }
1703 
1704     function getBalance()
1705     external view
1706     returns(uint256)
1707     {
1708         if(_root != _msgSender())
1709             revert RootAddressError();
1710         return address(this).balance;
1711     }
1712 
1713     function withdraw(address _to,uint256 _amount)
1714     external
1715     {
1716         if(_root != _msgSender())
1717             revert RootAddressError();
1718         if(address(this).balance < _amount)
1719             revert LackOfMoney();
1720         payable(_to).transfer(_amount);
1721     }
1722 
1723 }
1724 
1725 // File: ERC721AToken.sol
1726 
1727 
1728 // Creator: Chiru Labs & OZ
1729 
1730 pragma solidity ^0.8.4;
1731 
1732 
1733 
1734 
1735 /**
1736  * @title ERC721A Base Token
1737  * @dev ERC721A Token that can be irreversibly burned (destroyed).
1738  */
1739 abstract contract ERC721AToken is Context, Ownership, ERC721A {
1740     using Strings for uint256;
1741 
1742     /**
1743      * @dev See {IERC721Metadata-name}.
1744      */
1745     function name()
1746     external view virtual
1747     override
1748     returns(string memory)
1749     {
1750         return _contractData.name;
1751     }
1752 
1753     /**
1754      * @dev See {IERC721Metadata-symbol}.
1755      */
1756     function symbol()
1757     external view virtual
1758     override
1759     returns(string memory)
1760     {
1761         return _contractData.symbol;
1762     }
1763 
1764     function baseTokenURI()
1765     external view
1766     returns(string memory)
1767     {
1768         return _contractData.baseURL;
1769     }
1770   
1771     function contractURI()
1772     external view
1773     returns(string memory)
1774     {
1775         return _contractData.contractURL;
1776     }
1777 
1778     /**
1779      * @dev See {IERC721Metadata-tokenURI}.
1780      */
1781     function tokenURI(uint256 tokenId)
1782     external view
1783     override
1784     returns(string memory)
1785     {
1786         if (!_exists(tokenId))
1787             revert URIQueryForNonexistentToken();
1788 
1789         return string(
1790                 abi.encodePacked(
1791                     _contractData.baseURL,
1792                     "/",
1793                     Strings.toString(tokenId),
1794                     ".json"
1795                 ));
1796     }
1797 
1798     function decimals()
1799     external pure
1800     returns(uint8)
1801     {
1802         return 0;
1803     }
1804 
1805     /**
1806      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1807      *
1808      * Requirements:
1809      *
1810      * - The caller must own `tokenId` or be an approved operator.
1811      */
1812     function burn(uint256 tokenId)
1813     internal
1814     {
1815         if(!_contractData.isEnvelope)
1816             if(IEnvelope(_envelopeTypes.envelope).locked(address(this),tokenId))
1817                 revert AssetLocked();
1818                 
1819         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1820 
1821         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1822             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1823             getApproved(tokenId) == _msgSender());
1824 
1825         if (!isApprovedOrOwner)
1826             revert TransferCallerNotOwnerNorApproved();
1827 
1828         _burn(tokenId);
1829     }
1830 
1831 }
1832 // File: IAsset.sol
1833 
1834 
1835 // Creator: OZ
1836 
1837 pragma solidity ^0.8.4;
1838 
1839 interface IAsset {
1840     function checkMint(address _owner,uint256 _quantity) external returns(uint256);
1841     function locked(uint256 _assetId) external view returns(bool);
1842     function ownerOfAsset(uint256 _assetId) external view returns(address);
1843     }
1844 
1845 // File: ERC721AEnvelope.sol
1846 
1847 
1848 // Creator: OZ
1849 
1850 pragma solidity ^0.8.4;
1851 
1852 
1853 
1854 
1855 
1856 //import "hardhat/console.sol";
1857 
1858 abstract contract ERC721AEnvelope is Array, Context, ERC721AToken {
1859     using Math for uint256;
1860 
1861     function _mintSetOfAssets(address _owner,uint _quantity)
1862     internal
1863     {
1864         unchecked {
1865             for(uint i = 0; i < _envelopeTypes.types.length; i++) {
1866                 (bool success,bytes memory res) = _envelopeTypes.types[i].call(
1867                     abi.encodeWithSignature("safeMint(address,uint256)",
1868                         _owner,
1869                         _quantity
1870                         )
1871                 );
1872                 if(!success)
1873                     revert Err();
1874             }
1875         }
1876     }
1877 
1878     function _envelopeAssets(uint256 _envelopeId)
1879     internal view
1880     returns(address[] memory,uint256[] memory)
1881     {
1882         unchecked {
1883             uint len = 0;
1884             for (uint i = 0; i < _envelopeTypes.types.length; i++) {
1885                 len++;
1886             }
1887             address[] memory addrs = new address[](len);
1888             uint256[] memory tokens = new uint256[](len);
1889             len = 0;
1890             for (uint i = 0; i < _envelopeTypes.types.length; i++) {
1891                 addrs[len] = _envelopeTypes.types[i];
1892                 tokens[len++] = _assetsEnvelope[_envelopeId][_envelopeTypes.types[i]];
1893             }
1894             return (addrs,tokens);
1895         }
1896     }
1897 
1898     function _envelopeSplit(address _owner,uint256 _envelopeId)
1899     internal
1900     returns(address[] memory,uint256[] memory)
1901     {
1902         OwnerOnly(_owner,_envelopeId);
1903 
1904         (address[] memory addrs,uint256[] memory tokens) = _envelopeAssets(_envelopeId);
1905         _burn(_envelopeId);
1906         _transferEnvelope(_owner,_envelopeId);
1907         unchecked {
1908             for(uint i = 0; i < addrs.length; i++) {
1909                 _unlockEnvelopeAsset(
1910                         _envelopeId,
1911                         addrs[i],
1912                         tokens[i]
1913                         );
1914             }
1915         }
1916         return (addrs,tokens);
1917     }
1918 
1919     function _unlockEnvelopeAsset(uint256 _envelopeId,address _asset,uint256 _assetId)
1920     internal
1921     {
1922         if(!_locked(_asset,_assetId))
1923             revert AssetNotLocked();
1924         if(_msgSender() != IAsset(_asset).ownerOfAsset(_assetId))
1925             revert CallerNotOwnerNorApproved();
1926 
1927         delete _assetsEnveloped[_asset][_assetId];
1928         delete _assetsEnvelope[_envelopeId][_asset];
1929     }
1930 
1931     function _envelopeCreate(address _owner,address[] calldata _assets,uint256[] calldata _assetIds)
1932     internal
1933     returns(uint256)
1934     {
1935         if(
1936             _assets.length == 0 &&
1937             _assets.length != _assetIds.length
1938         ) revert Err();
1939 
1940         uint256 envelopeId = _currentIndex;
1941         _safeMint(_owner,1);
1942         unchecked {
1943             _assetsEnvelope[envelopeId][_envelopeTypes.envelope] = envelopeId;
1944             for(uint i = 0; i < _assets.length; i++) {
1945                 if(_locked(_assets[i],_assetIds[i]))
1946                     revert AssetLocked();
1947                 if(_owner != IAsset(_assets[i]).ownerOfAsset(_assetIds[i]))
1948                     revert CallerNotOwnerNorApproved();
1949                 _assetsEnvelope[envelopeId][_assets[i]] = _assetIds[i];
1950                 _assetsEnveloped[_assets[i]][_assetIds[i]] = true;
1951             }
1952         }
1953         return envelopeId;
1954     }
1955 
1956     function _locked(address _asset,uint256 _assetId)
1957     internal view
1958     returns(bool)
1959     {
1960         if (_contractData.isEnvelope)
1961             return _assetsEnveloped[_asset][_assetId];
1962         else
1963             return IAsset(_envelopeTypes.envelope).locked(_assetId);
1964     }
1965 
1966 }
1967 
1968 // File: Master.sol
1969 
1970 
1971 // Creator: OZ
1972 
1973 pragma solidity ^0.8.4;
1974 
1975 
1976 abstract contract Master is ERC721AEnvelope {
1977 
1978     constructor() {
1979         _root = _msgSender();
1980         _contractData.isRevealed = false;
1981         _contractData.mintStatus = MintStatus.NONE;
1982         _contractData.mintStatusAuto = true;
1983         _mintSettings.mintOnPresale = 1; // number of tokens on presale
1984         _mintSettings.maxMintPerUser = 2; // max tokens on sale
1985         _mintSettings.minMintPerUser = 1; // min tokens on sale
1986         _mintSettings.maxTokenSupply = 5000;
1987         _mintSettings.priceOnPresale = 37500000000000000; // in wei, may be changed later
1988         _mintSettings.priceOnSale = 47500000000000000; // in wei, may be changed later
1989         _mintSettings.envelopeConcatPrice = 0; // in wei, may be changed later
1990         _mintSettings.envelopeSplitPrice = 0; // in wei, may be changed later
1991         _mintSettings.mintStatusPreale = 1649683800; // Monday, April 11, 2022 2:00:00 PM GMT
1992         _mintSettings.mintStatusSale = 1649734200; // Tuesday, April 12, 2022 3:30:00 AM
1993         _mintSettings.mintStatusFinished = 0; //does not specified
1994     }
1995 
1996     function exists(uint256 tokenId)
1997     external view
1998     returns(bool)
1999     {
2000         return _exists(tokenId);
2001     }
2002 
2003     function setRoot(address _owner)
2004     external
2005     {
2006         RootOnly();
2007         
2008         _root = _owner;
2009     }
2010 
2011     function getRoot()
2012     external view
2013     returns(address)
2014     {
2015         return _root;
2016     }
2017 
2018     function CheckMintStatus()
2019     internal
2020     {
2021         if(!_contractData.mintStatusAuto)
2022             return;
2023         
2024         uint256 mps = _mintSettings.mintStatusPreale;
2025         uint256 ms = _mintSettings.mintStatusSale;
2026         uint256 mf = _mintSettings.mintStatusFinished;
2027         if (mps <= block.timestamp && block.timestamp < ms) {
2028             _contractData.mintStatus = MintStatus.PRESALE;
2029         } else if (ms <= block.timestamp && (block.timestamp < mf || 0 == mf)) {
2030             _contractData.mintStatus = MintStatus.SALE;
2031         } else {
2032             _contractData.mintStatus = MintStatus.NONE;
2033         }
2034     }
2035 
2036     function toggleMintStatus(bool _mode)
2037     external
2038     {
2039         RootOnly();
2040 
2041         _contractData.mintStatusAuto = _mode;
2042     }
2043 
2044     function setMintingIsOnPresale()
2045     external
2046     {
2047         RootOnly();
2048 
2049         _contractData.mintStatus = MintStatus.PRESALE;
2050     }
2051     
2052     function setMintingIsOnSale()
2053     external
2054     {
2055         RootOnly();
2056 
2057         _contractData.mintStatus = MintStatus.SALE;
2058     }
2059      
2060     function stopMinting()
2061     external
2062     {
2063         RootOnly();
2064 
2065         _contractData.mintStatus = MintStatus.NONE;
2066     }
2067 
2068     function updateContract(
2069         uint256 _pricePresale,
2070         uint256 _priceSale,
2071         uint8 _minMint,
2072         uint8 _maxMint,
2073         uint64 _maxSupply
2074         )
2075     external
2076     {
2077         RootOnly();
2078 
2079         _mintSettings.priceOnPresale = _pricePresale;
2080         _mintSettings.priceOnSale = _priceSale;
2081         _mintSettings.maxMintPerUser = _maxMint;
2082         _mintSettings.minMintPerUser = _minMint;
2083         _mintSettings.maxTokenSupply = _maxSupply;
2084     }
2085 
2086     function setRevealed(string calldata _url)
2087     external
2088     {
2089         RootOnly();
2090 
2091         _contractData.isRevealed = true;
2092         _contractData.baseURL = _url;
2093     }
2094 
2095     function updateBaseURL(string calldata _url)
2096     external
2097     {
2098         RootOnly();
2099 
2100         _contractData.baseURL = _url;
2101     }
2102 
2103 }
2104 // File: Contract.sol
2105 
2106 
2107 // Creator: OZ
2108 
2109 pragma solidity ^0.8.4;
2110 
2111 
2112 
2113 
2114 contract Contract is Master, Payment, IEnvelope {
2115 
2116     constructor(
2117         string memory name_,
2118         string memory description_,
2119         string memory symbol_,
2120         string memory baseURL_,
2121         string memory contractURL_
2122     ) ERC721A(
2123         name_,
2124         description_,
2125         symbol_,
2126         baseURL_,
2127         contractURL_
2128     ) Master() {
2129         _contractData.isEnvelope = true;
2130         //_contractData.wl = 0x7355b511eb06aa6d5a11b366b27ed407bc3237cf6e2eafe1799efef4a678756f;
2131         _contractData.wl = 0xcdab47e163c1eb6040f36523ce1ddb86b732c6e652e159613a6e0b896d4f8232;
2132     }
2133 
2134     function addAssetType(address _asset)
2135     external
2136     {
2137         RootOnly();
2138 
2139         unchecked {
2140             _envelopeTypes.types.push(_asset);
2141         }
2142     }
2143 
2144     function setEnvelopeConcatPrice(uint256 _price)
2145     external
2146     {
2147         RootOnly();
2148 
2149         _mintSettings.envelopeConcatPrice = _price;
2150     }
2151 
2152     function setEnvelopeSplitPrice(uint256 _price)
2153     external
2154     {
2155         RootOnly();
2156 
2157         _mintSettings.envelopeSplitPrice = _price;
2158     }
2159 
2160     function addMint(uint _quantity)
2161     external payable
2162     returns(uint256)
2163     {
2164         BotProtection();
2165         CheckMintStatus();
2166         ActiveMint();
2167 
2168         if(_contractData.mintStatus != MintStatus.SALE)
2169             revert WhitelistedOnly();
2170 
2171         //
2172         if (lackOfMoney(_quantity * _envelopeTypes.types.length))
2173             revert LackOfMoney();
2174         else {
2175             _mintSetOfAssets(_msgSender(), _quantity);
2176             return _quantity;
2177         }
2178     }
2179 
2180     function addMint(uint _quantity,bytes32[] calldata _merkleProof)
2181     external payable
2182     returns(uint256)
2183     {
2184         BotProtection();
2185         CheckMintStatus();
2186         ActiveMint();
2187         Whitelisted(_merkleProof);
2188 
2189         if (lackOfMoney(_quantity * _envelopeTypes.types.length))
2190             revert LackOfMoney();
2191         else {
2192             _mintSetOfAssets(_msgSender(), _quantity);
2193             return _quantity;
2194         }
2195     }
2196 
2197     function addMint(address _owner,uint _quantity)
2198     external
2199     {
2200         RootOnly();
2201         CheckMintStatus();
2202 
2203         _mintSetOfAssets(_owner, _quantity);
2204     }
2205 
2206     function envelopeCreate(address[] calldata _assets,uint256[] calldata _assetIds)
2207     external payable 
2208     returns(uint256)
2209     {
2210         if(lackOfMoneyForConcat())
2211             revert LackOfMoney();
2212         else return
2213             _envelopeCreate(_msgSender(),_assets, _assetIds);
2214     }
2215 
2216     function envelopeSplit(uint256 _envelopeId)
2217     external payable
2218     returns(address[] memory,uint256[] memory)
2219     {
2220         OwnerOnly(_msgSender(),_envelopeId);
2221 
2222         if(lackOfMoneyForSplit())
2223             revert LackOfMoney();
2224         else return
2225             _envelopeSplit(_msgSender(),_envelopeId);
2226     }
2227 
2228     function getAssetTypes()
2229     external view
2230     returns(address[] memory)
2231     {
2232         return _envelopeTypes.types;
2233     }
2234 
2235     function getEnvelopeAssets(uint256 _envelopeId)
2236     external view
2237     returns(address[] memory,uint256[] memory)
2238     {
2239         return _envelopeAssets(_envelopeId);
2240     }
2241 
2242     function locked(address _asset,uint256 _assetId)
2243     external view
2244     override
2245     returns(bool)
2246     {
2247         return _assetsEnveloped[_asset][_assetId];
2248     }
2249 
2250     function ownerOfAsset(uint256 _assetId)
2251     external view
2252     override
2253     returns(address)
2254     {
2255         return ownershipOf(_assetId).addr;
2256     }
2257 
2258 }