1 // File: contracts/CalScore.sol
2 
3 
4 pragma solidity ^0.8.9;
5 
6 contract CalScore{
7 
8     function calculate(uint256 _totalScore, uint256 _randomNumber) internal view virtual returns (uint256) {
9         
10         if (_totalScore >= 1000000){
11                 return 5;
12         }  
13         if (_totalScore < 66306){
14             if (_randomNumber <= 3){
15                 return 5;
16             }
17             if (_randomNumber >= 4 && _randomNumber <= 10 ){
18                 return 4;
19             }
20             if (_randomNumber >= 11 && _randomNumber <= 20 ){
21                 return 3;
22             }
23             if (_randomNumber >= 21 && _randomNumber <= 40 ){
24                 return 2;
25             }
26             if (_randomNumber >= 41 && _randomNumber <= 100){
27                 return 1;
28             }
29         }
30         if (_totalScore >= 66306 && _totalScore <=81632){
31             if (_randomNumber <= 5){
32                 return 5;
33             }
34             if (_randomNumber >= 6 && _randomNumber <= 15 ){
35                 return 4;
36             }
37             if (_randomNumber >= 16 && _randomNumber <= 25 ){
38                 return 3;
39             }
40             if (_randomNumber >= 26 && _randomNumber <= 35 ){
41                 return 2;
42             }
43             if (_randomNumber >= 36 && _randomNumber <= 100){
44                 return 1;
45             }
46         }
47         if (_totalScore >= 81633 && _totalScore <=103148){
48             if (_randomNumber <= 10){
49                 return 5;
50             }
51             if (_randomNumber >= 11 && _randomNumber <= 40 ){
52                 return 4;
53             }
54             if (_randomNumber >= 41 && _randomNumber <= 100 ){
55                 return 3;
56             }
57         }
58         if (_totalScore >= 103148 ){
59             if (_randomNumber <= 15){
60                 return 5;
61             }
62             if (_randomNumber >= 16 && _randomNumber <= 100 ){
63                 return 4;
64             }
65         }
66            
67     }
68 }
69 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
70 
71 
72 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev These functions deal with verification of Merkle Trees proofs.
78  *
79  * The proofs can be generated using the JavaScript library
80  * https://github.com/miguelmota/merkletreejs[merkletreejs].
81  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
82  *
83  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
84  *
85  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
86  * hashing, or use a hash function other than keccak256 for hashing leaves.
87  * This is because the concatenation of a sorted pair of internal nodes in
88  * the merkle tree could be reinterpreted as a leaf value.
89  */
90 library MerkleProof {
91     /**
92      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
93      * defined by `root`. For this, a `proof` must be provided, containing
94      * sibling hashes on the branch from the leaf to the root of the tree. Each
95      * pair of leaves and each pair of pre-images are assumed to be sorted.
96      */
97     function verify(
98         bytes32[] memory proof,
99         bytes32 root,
100         bytes32 leaf
101     ) internal pure returns (bool) {
102         return processProof(proof, leaf) == root;
103     }
104 
105     /**
106      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
107      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
108      * hash matches the root of the tree. When processing the proof, the pairs
109      * of leafs & pre-images are assumed to be sorted.
110      *
111      * _Available since v4.4._
112      */
113     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
114         bytes32 computedHash = leaf;
115         for (uint256 i = 0; i < proof.length; i++) {
116             bytes32 proofElement = proof[i];
117             if (computedHash <= proofElement) {
118                 // Hash(current computed hash + current element of the proof)
119                 computedHash = _efficientHash(computedHash, proofElement);
120             } else {
121                 // Hash(current element of the proof + current computed hash)
122                 computedHash = _efficientHash(proofElement, computedHash);
123             }
124         }
125         return computedHash;
126     }
127 
128     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
129         assembly {
130             mstore(0x00, a)
131             mstore(0x20, b)
132             value := keccak256(0x00, 0x40)
133         }
134     }
135 }
136 
137 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
138 
139 
140 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
141 
142 pragma solidity ^0.8.0;
143 
144 /**
145  * @title ERC721 token receiver interface
146  * @dev Interface for any contract that wants to support safeTransfers
147  * from ERC721 asset contracts.
148  */
149 interface IERC721Receiver {
150     /**
151      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
152      * by `operator` from `from`, this function is called.
153      *
154      * It must return its Solidity selector to confirm the token transfer.
155      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
156      *
157      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
158      */
159     function onERC721Received(
160         address operator,
161         address from,
162         uint256 tokenId,
163         bytes calldata data
164     ) external returns (bytes4);
165 }
166 
167 // File: contracts/VerifySign.sol
168 
169 
170 pragma solidity ^0.8.9;
171 
172 contract VerifySign{
173 
174     struct EIP712Domain {
175         string  name;
176         string  version;
177         uint256 chainId;
178         address verifyingContract;
179     }
180 
181     struct Tokens {
182         uint256 tokenId1;
183         uint256 tokenId2;
184         uint256 tokenId3;
185         uint256 tokenId4;
186         uint256 totalScore;
187     }
188 
189     bytes32 constant EIP712DOMAIN_TYPEHASH = keccak256(
190         "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
191     );
192 
193     bytes32 constant ID_TYPEHASH = keccak256(
194         "Tokens(uint256 tokenId1,uint256 tokenId2,uint256 tokenId3,uint256 tokenId4,uint256 totalScore)"
195     );
196 
197     bytes32 DOMAIN_SEPARATOR;
198 
199     constructor () {
200         DOMAIN_SEPARATOR = hash(EIP712Domain({
201             name: "Land",
202             version: '1',
203             chainId: 1,
204             verifyingContract: address(this)
205         }));
206     }
207 
208     function hash(EIP712Domain memory eip712Domain) internal pure returns (bytes32) {
209         return keccak256(abi.encode(
210             EIP712DOMAIN_TYPEHASH,
211             keccak256(bytes(eip712Domain.name)),
212             keccak256(bytes(eip712Domain.version)),
213             eip712Domain.chainId,
214             eip712Domain.verifyingContract
215         ));
216     }
217 
218     function hash(Tokens memory tokens) internal pure returns (bytes32) {
219         return keccak256(abi.encode(
220             ID_TYPEHASH,
221             tokens.tokenId1,
222             tokens.tokenId2,
223             tokens.tokenId3,
224             tokens.tokenId4,
225             tokens.totalScore
226         ));
227     }
228 
229     function verifySig(uint256[] memory tokenId, uint256 _toalScore, uint8 v, bytes32 r, bytes32 s) internal view virtual returns (address) {
230 
231         Tokens memory t;
232         t.tokenId1 = tokenId[0];
233         t.tokenId2 = tokenId[1];
234         t.tokenId3 = tokenId[2];
235         t.tokenId4 = tokenId[3];
236         t.totalScore = _toalScore;
237         
238         bytes32 digest = keccak256(abi.encodePacked(
239             "\x19\x01",
240             DOMAIN_SEPARATOR,
241             hash(t)
242         ));
243         return ecrecover(digest, v, r, s) ;
244     }
245 
246 
247 }
248 
249 // File: @openzeppelin/contracts/utils/Address.sol
250 
251 
252 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
253 
254 pragma solidity ^0.8.1;
255 
256 /**
257  * @dev Collection of functions related to the address type
258  */
259 library Address {
260     /**
261      * @dev Returns true if `account` is a contract.
262      *
263      * [IMPORTANT]
264      * ====
265      * It is unsafe to assume that an address for which this function returns
266      * false is an externally-owned account (EOA) and not a contract.
267      *
268      * Among others, `isContract` will return false for the following
269      * types of addresses:
270      *
271      *  - an externally-owned account
272      *  - a contract in construction
273      *  - an address where a contract will be created
274      *  - an address where a contract lived, but was destroyed
275      * ====
276      *
277      * [IMPORTANT]
278      * ====
279      * You shouldn't rely on `isContract` to protect against flash loan attacks!
280      *
281      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
282      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
283      * constructor.
284      * ====
285      */
286     function isContract(address account) internal view returns (bool) {
287         // This method relies on extcodesize/address.code.length, which returns 0
288         // for contracts in construction, since the code is only stored at the end
289         // of the constructor execution.
290 
291         return account.code.length > 0;
292     }
293 
294     /**
295      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
296      * `recipient`, forwarding all available gas and reverting on errors.
297      *
298      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
299      * of certain opcodes, possibly making contracts go over the 2300 gas limit
300      * imposed by `transfer`, making them unable to receive funds via
301      * `transfer`. {sendValue} removes this limitation.
302      *
303      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
304      *
305      * IMPORTANT: because control is transferred to `recipient`, care must be
306      * taken to not create reentrancy vulnerabilities. Consider using
307      * {ReentrancyGuard} or the
308      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
309      */
310     function sendValue(address payable recipient, uint256 amount) internal {
311         require(address(this).balance >= amount, "Address: insufficient balance");
312 
313         (bool success, ) = recipient.call{value: amount}("");
314         require(success, "Address: unable to send value, recipient may have reverted");
315     }
316 
317     /**
318      * @dev Performs a Solidity function call using a low level `call`. A
319      * plain `call` is an unsafe replacement for a function call: use this
320      * function instead.
321      *
322      * If `target` reverts with a revert reason, it is bubbled up by this
323      * function (like regular Solidity function calls).
324      *
325      * Returns the raw returned data. To convert to the expected return value,
326      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
327      *
328      * Requirements:
329      *
330      * - `target` must be a contract.
331      * - calling `target` with `data` must not revert.
332      *
333      * _Available since v3.1._
334      */
335     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
336         return functionCall(target, data, "Address: low-level call failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
341      * `errorMessage` as a fallback revert reason when `target` reverts.
342      *
343      * _Available since v3.1._
344      */
345     function functionCall(
346         address target,
347         bytes memory data,
348         string memory errorMessage
349     ) internal returns (bytes memory) {
350         return functionCallWithValue(target, data, 0, errorMessage);
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
355      * but also transferring `value` wei to `target`.
356      *
357      * Requirements:
358      *
359      * - the calling contract must have an ETH balance of at least `value`.
360      * - the called Solidity function must be `payable`.
361      *
362      * _Available since v3.1._
363      */
364     function functionCallWithValue(
365         address target,
366         bytes memory data,
367         uint256 value
368     ) internal returns (bytes memory) {
369         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
374      * with `errorMessage` as a fallback revert reason when `target` reverts.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(
379         address target,
380         bytes memory data,
381         uint256 value,
382         string memory errorMessage
383     ) internal returns (bytes memory) {
384         require(address(this).balance >= value, "Address: insufficient balance for call");
385         require(isContract(target), "Address: call to non-contract");
386 
387         (bool success, bytes memory returndata) = target.call{value: value}(data);
388         return verifyCallResult(success, returndata, errorMessage);
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
393      * but performing a static call.
394      *
395      * _Available since v3.3._
396      */
397     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
398         return functionStaticCall(target, data, "Address: low-level static call failed");
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
403      * but performing a static call.
404      *
405      * _Available since v3.3._
406      */
407     function functionStaticCall(
408         address target,
409         bytes memory data,
410         string memory errorMessage
411     ) internal view returns (bytes memory) {
412         require(isContract(target), "Address: static call to non-contract");
413 
414         (bool success, bytes memory returndata) = target.staticcall(data);
415         return verifyCallResult(success, returndata, errorMessage);
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
420      * but performing a delegate call.
421      *
422      * _Available since v3.4._
423      */
424     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
425         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
430      * but performing a delegate call.
431      *
432      * _Available since v3.4._
433      */
434     function functionDelegateCall(
435         address target,
436         bytes memory data,
437         string memory errorMessage
438     ) internal returns (bytes memory) {
439         require(isContract(target), "Address: delegate call to non-contract");
440 
441         (bool success, bytes memory returndata) = target.delegatecall(data);
442         return verifyCallResult(success, returndata, errorMessage);
443     }
444 
445     /**
446      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
447      * revert reason using the provided one.
448      *
449      * _Available since v4.3._
450      */
451     function verifyCallResult(
452         bool success,
453         bytes memory returndata,
454         string memory errorMessage
455     ) internal pure returns (bytes memory) {
456         if (success) {
457             return returndata;
458         } else {
459             // Look for revert reason and bubble it up if present
460             if (returndata.length > 0) {
461                 // The easiest way to bubble the revert reason is using memory via assembly
462 
463                 assembly {
464                     let returndata_size := mload(returndata)
465                     revert(add(32, returndata), returndata_size)
466                 }
467             } else {
468                 revert(errorMessage);
469             }
470         }
471     }
472 }
473 
474 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
475 
476 
477 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
478 
479 pragma solidity ^0.8.0;
480 
481 /**
482  * @dev Interface of the ERC165 standard, as defined in the
483  * https://eips.ethereum.org/EIPS/eip-165[EIP].
484  *
485  * Implementers can declare support of contract interfaces, which can then be
486  * queried by others ({ERC165Checker}).
487  *
488  * For an implementation, see {ERC165}.
489  */
490 interface IERC165 {
491     /**
492      * @dev Returns true if this contract implements the interface defined by
493      * `interfaceId`. See the corresponding
494      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
495      * to learn more about how these ids are created.
496      *
497      * This function call must use less than 30 000 gas.
498      */
499     function supportsInterface(bytes4 interfaceId) external view returns (bool);
500 }
501 
502 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
503 
504 
505 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
506 
507 pragma solidity ^0.8.0;
508 
509 
510 /**
511  * @dev Required interface of an ERC721 compliant contract.
512  */
513 interface IERC721 is IERC165 {
514     /**
515      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
516      */
517     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
518 
519     /**
520      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
521      */
522     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
523 
524     /**
525      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
526      */
527     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
528 
529     /**
530      * @dev Returns the number of tokens in ``owner``'s account.
531      */
532     function balanceOf(address owner) external view returns (uint256 balance);
533 
534     /**
535      * @dev Returns the owner of the `tokenId` token.
536      *
537      * Requirements:
538      *
539      * - `tokenId` must exist.
540      */
541     function ownerOf(uint256 tokenId) external view returns (address owner);
542 
543     /**
544      * @dev Safely transfers `tokenId` token from `from` to `to`.
545      *
546      * Requirements:
547      *
548      * - `from` cannot be the zero address.
549      * - `to` cannot be the zero address.
550      * - `tokenId` token must exist and be owned by `from`.
551      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
552      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
553      *
554      * Emits a {Transfer} event.
555      */
556     function safeTransferFrom(
557         address from,
558         address to,
559         uint256 tokenId,
560         bytes calldata data
561     ) external;
562 
563     /**
564      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
565      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
566      *
567      * Requirements:
568      *
569      * - `from` cannot be the zero address.
570      * - `to` cannot be the zero address.
571      * - `tokenId` token must exist and be owned by `from`.
572      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
573      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
574      *
575      * Emits a {Transfer} event.
576      */
577     function safeTransferFrom(
578         address from,
579         address to,
580         uint256 tokenId
581     ) external;
582 
583     /**
584      * @dev Transfers `tokenId` token from `from` to `to`.
585      *
586      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
587      *
588      * Requirements:
589      *
590      * - `from` cannot be the zero address.
591      * - `to` cannot be the zero address.
592      * - `tokenId` token must be owned by `from`.
593      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
594      *
595      * Emits a {Transfer} event.
596      */
597     function transferFrom(
598         address from,
599         address to,
600         uint256 tokenId
601     ) external;
602 
603     /**
604      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
605      * The approval is cleared when the token is transferred.
606      *
607      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
608      *
609      * Requirements:
610      *
611      * - The caller must own the token or be an approved operator.
612      * - `tokenId` must exist.
613      *
614      * Emits an {Approval} event.
615      */
616     function approve(address to, uint256 tokenId) external;
617 
618     /**
619      * @dev Approve or remove `operator` as an operator for the caller.
620      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
621      *
622      * Requirements:
623      *
624      * - The `operator` cannot be the caller.
625      *
626      * Emits an {ApprovalForAll} event.
627      */
628     function setApprovalForAll(address operator, bool _approved) external;
629 
630     /**
631      * @dev Returns the account approved for `tokenId` token.
632      *
633      * Requirements:
634      *
635      * - `tokenId` must exist.
636      */
637     function getApproved(uint256 tokenId) external view returns (address operator);
638 
639     /**
640      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
641      *
642      * See {setApprovalForAll}
643      */
644     function isApprovedForAll(address owner, address operator) external view returns (bool);
645 }
646 
647 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
648 
649 
650 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
651 
652 pragma solidity ^0.8.0;
653 
654 
655 /**
656  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
657  * @dev See https://eips.ethereum.org/EIPS/eip-721
658  */
659 interface IERC721Metadata is IERC721 {
660     /**
661      * @dev Returns the token collection name.
662      */
663     function name() external view returns (string memory);
664 
665     /**
666      * @dev Returns the token collection symbol.
667      */
668     function symbol() external view returns (string memory);
669 
670     /**
671      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
672      */
673     function tokenURI(uint256 tokenId) external view returns (string memory);
674 }
675 
676 // File: erc721a/contracts/IERC721A.sol
677 
678 
679 // ERC721A Contracts v3.3.0
680 // Creator: Chiru Labs
681 
682 pragma solidity ^0.8.4;
683 
684 
685 
686 /**
687  * @dev Interface of an ERC721A compliant contract.
688  */
689 interface IERC721A is IERC721, IERC721Metadata {
690     /**
691      * The caller must own the token or be an approved operator.
692      */
693     error ApprovalCallerNotOwnerNorApproved();
694 
695     /**
696      * The token does not exist.
697      */
698     error ApprovalQueryForNonexistentToken();
699 
700     /**
701      * The caller cannot approve to their own address.
702      */
703     error ApproveToCaller();
704 
705     /**
706      * The caller cannot approve to the current owner.
707      */
708     error ApprovalToCurrentOwner();
709 
710     /**
711      * Cannot query the balance for the zero address.
712      */
713     error BalanceQueryForZeroAddress();
714 
715     /**
716      * Cannot mint to the zero address.
717      */
718     error MintToZeroAddress();
719 
720     /**
721      * The quantity of tokens minted must be more than zero.
722      */
723     error MintZeroQuantity();
724 
725     /**
726      * The token does not exist.
727      */
728     error OwnerQueryForNonexistentToken();
729 
730     /**
731      * The caller must own the token or be an approved operator.
732      */
733     error TransferCallerNotOwnerNorApproved();
734 
735     /**
736      * The token must be owned by `from`.
737      */
738     error TransferFromIncorrectOwner();
739 
740     /**
741      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
742      */
743     error TransferToNonERC721ReceiverImplementer();
744 
745     /**
746      * Cannot transfer to the zero address.
747      */
748     error TransferToZeroAddress();
749 
750     /**
751      * The token does not exist.
752      */
753     error URIQueryForNonexistentToken();
754 
755     // Compiler will pack this into a single 256bit word.
756     struct TokenOwnership {
757         // The address of the owner.
758         address addr;
759         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
760         uint64 startTimestamp;
761         // Whether the token has been burned.
762         bool burned;
763     }
764 
765     // Compiler will pack this into a single 256bit word.
766     struct AddressData {
767         // Realistically, 2**64-1 is more than enough.
768         uint64 balance;
769         // Keeps track of mint count with minimal overhead for tokenomics.
770         uint64 numberMinted;
771         // Keeps track of burn count with minimal overhead for tokenomics.
772         uint64 numberBurned;
773         // For miscellaneous variable(s) pertaining to the address
774         // (e.g. number of whitelist mint slots used).
775         // If there are multiple variables, please pack them into a uint64.
776         uint64 aux;
777     }
778 
779     /**
780      * @dev Returns the total amount of tokens stored by the contract.
781      * 
782      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
783      */
784     function totalSupply() external view returns (uint256);
785 }
786 
787 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
788 
789 
790 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
791 
792 pragma solidity ^0.8.0;
793 
794 
795 /**
796  * @dev Implementation of the {IERC165} interface.
797  *
798  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
799  * for the additional interface id that will be supported. For example:
800  *
801  * ```solidity
802  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
803  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
804  * }
805  * ```
806  *
807  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
808  */
809 abstract contract ERC165 is IERC165 {
810     /**
811      * @dev See {IERC165-supportsInterface}.
812      */
813     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
814         return interfaceId == type(IERC165).interfaceId;
815     }
816 }
817 
818 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
819 
820 
821 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
822 
823 pragma solidity ^0.8.0;
824 
825 
826 /**
827  * @dev _Available since v3.1._
828  */
829 interface IERC1155Receiver is IERC165 {
830     /**
831      * @dev Handles the receipt of a single ERC1155 token type. This function is
832      * called at the end of a `safeTransferFrom` after the balance has been updated.
833      *
834      * NOTE: To accept the transfer, this must return
835      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
836      * (i.e. 0xf23a6e61, or its own function selector).
837      *
838      * @param operator The address which initiated the transfer (i.e. msg.sender)
839      * @param from The address which previously owned the token
840      * @param id The ID of the token being transferred
841      * @param value The amount of tokens being transferred
842      * @param data Additional data with no specified format
843      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
844      */
845     function onERC1155Received(
846         address operator,
847         address from,
848         uint256 id,
849         uint256 value,
850         bytes calldata data
851     ) external returns (bytes4);
852 
853     /**
854      * @dev Handles the receipt of a multiple ERC1155 token types. This function
855      * is called at the end of a `safeBatchTransferFrom` after the balances have
856      * been updated.
857      *
858      * NOTE: To accept the transfer(s), this must return
859      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
860      * (i.e. 0xbc197c81, or its own function selector).
861      *
862      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
863      * @param from The address which previously owned the token
864      * @param ids An array containing ids of each token being transferred (order and length must match values array)
865      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
866      * @param data Additional data with no specified format
867      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
868      */
869     function onERC1155BatchReceived(
870         address operator,
871         address from,
872         uint256[] calldata ids,
873         uint256[] calldata values,
874         bytes calldata data
875     ) external returns (bytes4);
876 }
877 
878 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
879 
880 
881 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
882 
883 pragma solidity ^0.8.0;
884 
885 
886 /**
887  * @dev Required interface of an ERC1155 compliant contract, as defined in the
888  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
889  *
890  * _Available since v3.1._
891  */
892 interface IERC1155 is IERC165 {
893     /**
894      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
895      */
896     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
897 
898     /**
899      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
900      * transfers.
901      */
902     event TransferBatch(
903         address indexed operator,
904         address indexed from,
905         address indexed to,
906         uint256[] ids,
907         uint256[] values
908     );
909 
910     /**
911      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
912      * `approved`.
913      */
914     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
915 
916     /**
917      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
918      *
919      * If an {URI} event was emitted for `id`, the standard
920      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
921      * returned by {IERC1155MetadataURI-uri}.
922      */
923     event URI(string value, uint256 indexed id);
924 
925     /**
926      * @dev Returns the amount of tokens of token type `id` owned by `account`.
927      *
928      * Requirements:
929      *
930      * - `account` cannot be the zero address.
931      */
932     function balanceOf(address account, uint256 id) external view returns (uint256);
933 
934     /**
935      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
936      *
937      * Requirements:
938      *
939      * - `accounts` and `ids` must have the same length.
940      */
941     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
942         external
943         view
944         returns (uint256[] memory);
945 
946     /**
947      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
948      *
949      * Emits an {ApprovalForAll} event.
950      *
951      * Requirements:
952      *
953      * - `operator` cannot be the caller.
954      */
955     function setApprovalForAll(address operator, bool approved) external;
956 
957     /**
958      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
959      *
960      * See {setApprovalForAll}.
961      */
962     function isApprovedForAll(address account, address operator) external view returns (bool);
963 
964     /**
965      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
966      *
967      * Emits a {TransferSingle} event.
968      *
969      * Requirements:
970      *
971      * - `to` cannot be the zero address.
972      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
973      * - `from` must have a balance of tokens of type `id` of at least `amount`.
974      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
975      * acceptance magic value.
976      */
977     function safeTransferFrom(
978         address from,
979         address to,
980         uint256 id,
981         uint256 amount,
982         bytes calldata data
983     ) external;
984 
985     /**
986      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
987      *
988      * Emits a {TransferBatch} event.
989      *
990      * Requirements:
991      *
992      * - `ids` and `amounts` must have the same length.
993      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
994      * acceptance magic value.
995      */
996     function safeBatchTransferFrom(
997         address from,
998         address to,
999         uint256[] calldata ids,
1000         uint256[] calldata amounts,
1001         bytes calldata data
1002     ) external;
1003 }
1004 
1005 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
1006 
1007 
1008 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
1009 
1010 pragma solidity ^0.8.0;
1011 
1012 
1013 /**
1014  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
1015  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
1016  *
1017  * _Available since v3.1._
1018  */
1019 interface IERC1155MetadataURI is IERC1155 {
1020     /**
1021      * @dev Returns the URI for token type `id`.
1022      *
1023      * If the `\{id\}` substring is present in the URI, it must be replaced by
1024      * clients with the actual token type ID.
1025      */
1026     function uri(uint256 id) external view returns (string memory);
1027 }
1028 
1029 // File: @openzeppelin/contracts/utils/Context.sol
1030 
1031 
1032 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1033 
1034 pragma solidity ^0.8.0;
1035 
1036 /**
1037  * @dev Provides information about the current execution context, including the
1038  * sender of the transaction and its data. While these are generally available
1039  * via msg.sender and msg.data, they should not be accessed in such a direct
1040  * manner, since when dealing with meta-transactions the account sending and
1041  * paying for execution may not be the actual sender (as far as an application
1042  * is concerned).
1043  *
1044  * This contract is only required for intermediate, library-like contracts.
1045  */
1046 abstract contract Context {
1047     function _msgSender() internal view virtual returns (address) {
1048         return msg.sender;
1049     }
1050 
1051     function _msgData() internal view virtual returns (bytes calldata) {
1052         return msg.data;
1053     }
1054 }
1055 
1056 // File: @openzeppelin/contracts/security/Pausable.sol
1057 
1058 
1059 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
1060 
1061 pragma solidity ^0.8.0;
1062 
1063 
1064 /**
1065  * @dev Contract module which allows children to implement an emergency stop
1066  * mechanism that can be triggered by an authorized account.
1067  *
1068  * This module is used through inheritance. It will make available the
1069  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1070  * the functions of your contract. Note that they will not be pausable by
1071  * simply including this module, only once the modifiers are put in place.
1072  */
1073 abstract contract Pausable is Context {
1074     /**
1075      * @dev Emitted when the pause is triggered by `account`.
1076      */
1077     event Paused(address account);
1078 
1079     /**
1080      * @dev Emitted when the pause is lifted by `account`.
1081      */
1082     event Unpaused(address account);
1083 
1084     bool private _paused;
1085 
1086     /**
1087      * @dev Initializes the contract in unpaused state.
1088      */
1089     constructor() {
1090         _paused = false;
1091     }
1092 
1093     /**
1094      * @dev Modifier to make a function callable only when the contract is not paused.
1095      *
1096      * Requirements:
1097      *
1098      * - The contract must not be paused.
1099      */
1100     modifier whenNotPaused() {
1101         _requireNotPaused();
1102         _;
1103     }
1104 
1105     /**
1106      * @dev Modifier to make a function callable only when the contract is paused.
1107      *
1108      * Requirements:
1109      *
1110      * - The contract must be paused.
1111      */
1112     modifier whenPaused() {
1113         _requirePaused();
1114         _;
1115     }
1116 
1117     /**
1118      * @dev Returns true if the contract is paused, and false otherwise.
1119      */
1120     function paused() public view virtual returns (bool) {
1121         return _paused;
1122     }
1123 
1124     /**
1125      * @dev Throws if the contract is paused.
1126      */
1127     function _requireNotPaused() internal view virtual {
1128         require(!paused(), "Pausable: paused");
1129     }
1130 
1131     /**
1132      * @dev Throws if the contract is not paused.
1133      */
1134     function _requirePaused() internal view virtual {
1135         require(paused(), "Pausable: not paused");
1136     }
1137 
1138     /**
1139      * @dev Triggers stopped state.
1140      *
1141      * Requirements:
1142      *
1143      * - The contract must not be paused.
1144      */
1145     function _pause() internal virtual whenNotPaused {
1146         _paused = true;
1147         emit Paused(_msgSender());
1148     }
1149 
1150     /**
1151      * @dev Returns to normal state.
1152      *
1153      * Requirements:
1154      *
1155      * - The contract must be paused.
1156      */
1157     function _unpause() internal virtual whenPaused {
1158         _paused = false;
1159         emit Unpaused(_msgSender());
1160     }
1161 }
1162 
1163 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
1164 
1165 
1166 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)
1167 
1168 pragma solidity ^0.8.0;
1169 
1170 
1171 
1172 
1173 
1174 
1175 
1176 /**
1177  * @dev Implementation of the basic standard multi-token.
1178  * See https://eips.ethereum.org/EIPS/eip-1155
1179  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1180  *
1181  * _Available since v3.1._
1182  */
1183 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1184     using Address for address;
1185 
1186     // Mapping from token ID to account balances
1187     mapping(uint256 => mapping(address => uint256)) private _balances;
1188 
1189     // Mapping from account to operator approvals
1190     mapping(address => mapping(address => bool)) private _operatorApprovals;
1191 
1192     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1193     string private _uri;
1194 
1195     /**
1196      * @dev See {_setURI}.
1197      */
1198     constructor(string memory uri_) {
1199         _setURI(uri_);
1200     }
1201 
1202     /**
1203      * @dev See {IERC165-supportsInterface}.
1204      */
1205     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1206         return
1207             interfaceId == type(IERC1155).interfaceId ||
1208             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1209             super.supportsInterface(interfaceId);
1210     }
1211 
1212     /**
1213      * @dev See {IERC1155MetadataURI-uri}.
1214      *
1215      * This implementation returns the same URI for *all* token types. It relies
1216      * on the token type ID substitution mechanism
1217      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1218      *
1219      * Clients calling this function must replace the `\{id\}` substring with the
1220      * actual token type ID.
1221      */
1222     function uri(uint256) public view virtual override returns (string memory) {
1223         return _uri;
1224     }
1225 
1226     /**
1227      * @dev See {IERC1155-balanceOf}.
1228      *
1229      * Requirements:
1230      *
1231      * - `account` cannot be the zero address.
1232      */
1233     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1234         require(account != address(0), "ERC1155: address zero is not a valid owner");
1235         return _balances[id][account];
1236     }
1237 
1238     /**
1239      * @dev See {IERC1155-balanceOfBatch}.
1240      *
1241      * Requirements:
1242      *
1243      * - `accounts` and `ids` must have the same length.
1244      */
1245     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1246         public
1247         view
1248         virtual
1249         override
1250         returns (uint256[] memory)
1251     {
1252         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1253 
1254         uint256[] memory batchBalances = new uint256[](accounts.length);
1255 
1256         for (uint256 i = 0; i < accounts.length; ++i) {
1257             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1258         }
1259 
1260         return batchBalances;
1261     }
1262 
1263     /**
1264      * @dev See {IERC1155-setApprovalForAll}.
1265      */
1266     function setApprovalForAll(address operator, bool approved) public virtual override {
1267         _setApprovalForAll(_msgSender(), operator, approved);
1268     }
1269 
1270     /**
1271      * @dev See {IERC1155-isApprovedForAll}.
1272      */
1273     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1274         return _operatorApprovals[account][operator];
1275     }
1276 
1277     /**
1278      * @dev See {IERC1155-safeTransferFrom}.
1279      */
1280     function safeTransferFrom(
1281         address from,
1282         address to,
1283         uint256 id,
1284         uint256 amount,
1285         bytes memory data
1286     ) public virtual override {
1287         require(
1288             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1289             "ERC1155: caller is not token owner nor approved"
1290         );
1291         _safeTransferFrom(from, to, id, amount, data);
1292     }
1293 
1294     /**
1295      * @dev See {IERC1155-safeBatchTransferFrom}.
1296      */
1297     function safeBatchTransferFrom(
1298         address from,
1299         address to,
1300         uint256[] memory ids,
1301         uint256[] memory amounts,
1302         bytes memory data
1303     ) public virtual override {
1304         require(
1305             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1306             "ERC1155: caller is not token owner nor approved"
1307         );
1308         _safeBatchTransferFrom(from, to, ids, amounts, data);
1309     }
1310 
1311     /**
1312      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1313      *
1314      * Emits a {TransferSingle} event.
1315      *
1316      * Requirements:
1317      *
1318      * - `to` cannot be the zero address.
1319      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1320      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1321      * acceptance magic value.
1322      */
1323     function _safeTransferFrom(
1324         address from,
1325         address to,
1326         uint256 id,
1327         uint256 amount,
1328         bytes memory data
1329     ) internal virtual {
1330         require(to != address(0), "ERC1155: transfer to the zero address");
1331 
1332         address operator = _msgSender();
1333         uint256[] memory ids = _asSingletonArray(id);
1334         uint256[] memory amounts = _asSingletonArray(amount);
1335 
1336         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1337 
1338         uint256 fromBalance = _balances[id][from];
1339         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1340         unchecked {
1341             _balances[id][from] = fromBalance - amount;
1342         }
1343         _balances[id][to] += amount;
1344 
1345         emit TransferSingle(operator, from, to, id, amount);
1346 
1347         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1348 
1349         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1350     }
1351 
1352     /**
1353      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1354      *
1355      * Emits a {TransferBatch} event.
1356      *
1357      * Requirements:
1358      *
1359      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1360      * acceptance magic value.
1361      */
1362     function _safeBatchTransferFrom(
1363         address from,
1364         address to,
1365         uint256[] memory ids,
1366         uint256[] memory amounts,
1367         bytes memory data
1368     ) internal virtual {
1369         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1370         require(to != address(0), "ERC1155: transfer to the zero address");
1371 
1372         address operator = _msgSender();
1373 
1374         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1375 
1376         for (uint256 i = 0; i < ids.length; ++i) {
1377             uint256 id = ids[i];
1378             uint256 amount = amounts[i];
1379 
1380             uint256 fromBalance = _balances[id][from];
1381             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1382             unchecked {
1383                 _balances[id][from] = fromBalance - amount;
1384             }
1385             _balances[id][to] += amount;
1386         }
1387 
1388         emit TransferBatch(operator, from, to, ids, amounts);
1389 
1390         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1391 
1392         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1393     }
1394 
1395     /**
1396      * @dev Sets a new URI for all token types, by relying on the token type ID
1397      * substitution mechanism
1398      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1399      *
1400      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1401      * URI or any of the amounts in the JSON file at said URI will be replaced by
1402      * clients with the token type ID.
1403      *
1404      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1405      * interpreted by clients as
1406      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1407      * for token type ID 0x4cce0.
1408      *
1409      * See {uri}.
1410      *
1411      * Because these URIs cannot be meaningfully represented by the {URI} event,
1412      * this function emits no events.
1413      */
1414     function _setURI(string memory newuri) internal virtual {
1415         _uri = newuri;
1416     }
1417 
1418     /**
1419      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1420      *
1421      * Emits a {TransferSingle} event.
1422      *
1423      * Requirements:
1424      *
1425      * - `to` cannot be the zero address.
1426      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1427      * acceptance magic value.
1428      */
1429     function _mint(
1430         address to,
1431         uint256 id,
1432         uint256 amount,
1433         bytes memory data
1434     ) internal virtual {
1435         require(to != address(0), "ERC1155: mint to the zero address");
1436 
1437         address operator = _msgSender();
1438         uint256[] memory ids = _asSingletonArray(id);
1439         uint256[] memory amounts = _asSingletonArray(amount);
1440 
1441         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1442 
1443         _balances[id][to] += amount;
1444         emit TransferSingle(operator, address(0), to, id, amount);
1445 
1446         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1447 
1448         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1449     }
1450 
1451     /**
1452      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1453      *
1454      * Emits a {TransferBatch} event.
1455      *
1456      * Requirements:
1457      *
1458      * - `ids` and `amounts` must have the same length.
1459      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1460      * acceptance magic value.
1461      */
1462     function _mintBatch(
1463         address to,
1464         uint256[] memory ids,
1465         uint256[] memory amounts,
1466         bytes memory data
1467     ) internal virtual {
1468         require(to != address(0), "ERC1155: mint to the zero address");
1469         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1470 
1471         address operator = _msgSender();
1472 
1473         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1474 
1475         for (uint256 i = 0; i < ids.length; i++) {
1476             _balances[ids[i]][to] += amounts[i];
1477         }
1478 
1479         emit TransferBatch(operator, address(0), to, ids, amounts);
1480 
1481         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1482 
1483         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1484     }
1485 
1486     /**
1487      * @dev Destroys `amount` tokens of token type `id` from `from`
1488      *
1489      * Emits a {TransferSingle} event.
1490      *
1491      * Requirements:
1492      *
1493      * - `from` cannot be the zero address.
1494      * - `from` must have at least `amount` tokens of token type `id`.
1495      */
1496     function _burn(
1497         address from,
1498         uint256 id,
1499         uint256 amount
1500     ) internal virtual {
1501         require(from != address(0), "ERC1155: burn from the zero address");
1502 
1503         address operator = _msgSender();
1504         uint256[] memory ids = _asSingletonArray(id);
1505         uint256[] memory amounts = _asSingletonArray(amount);
1506 
1507         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1508 
1509         uint256 fromBalance = _balances[id][from];
1510         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1511         unchecked {
1512             _balances[id][from] = fromBalance - amount;
1513         }
1514 
1515         emit TransferSingle(operator, from, address(0), id, amount);
1516 
1517         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1518     }
1519 
1520     /**
1521      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1522      *
1523      * Emits a {TransferBatch} event.
1524      *
1525      * Requirements:
1526      *
1527      * - `ids` and `amounts` must have the same length.
1528      */
1529     function _burnBatch(
1530         address from,
1531         uint256[] memory ids,
1532         uint256[] memory amounts
1533     ) internal virtual {
1534         require(from != address(0), "ERC1155: burn from the zero address");
1535         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1536 
1537         address operator = _msgSender();
1538 
1539         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1540 
1541         for (uint256 i = 0; i < ids.length; i++) {
1542             uint256 id = ids[i];
1543             uint256 amount = amounts[i];
1544 
1545             uint256 fromBalance = _balances[id][from];
1546             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1547             unchecked {
1548                 _balances[id][from] = fromBalance - amount;
1549             }
1550         }
1551 
1552         emit TransferBatch(operator, from, address(0), ids, amounts);
1553 
1554         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1555     }
1556 
1557     /**
1558      * @dev Approve `operator` to operate on all of `owner` tokens
1559      *
1560      * Emits an {ApprovalForAll} event.
1561      */
1562     function _setApprovalForAll(
1563         address owner,
1564         address operator,
1565         bool approved
1566     ) internal virtual {
1567         require(owner != operator, "ERC1155: setting approval status for self");
1568         _operatorApprovals[owner][operator] = approved;
1569         emit ApprovalForAll(owner, operator, approved);
1570     }
1571 
1572     /**
1573      * @dev Hook that is called before any token transfer. This includes minting
1574      * and burning, as well as batched variants.
1575      *
1576      * The same hook is called on both single and batched variants. For single
1577      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1578      *
1579      * Calling conditions (for each `id` and `amount` pair):
1580      *
1581      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1582      * of token type `id` will be  transferred to `to`.
1583      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1584      * for `to`.
1585      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1586      * will be burned.
1587      * - `from` and `to` are never both zero.
1588      * - `ids` and `amounts` have the same, non-zero length.
1589      *
1590      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1591      */
1592     function _beforeTokenTransfer(
1593         address operator,
1594         address from,
1595         address to,
1596         uint256[] memory ids,
1597         uint256[] memory amounts,
1598         bytes memory data
1599     ) internal virtual {}
1600 
1601     /**
1602      * @dev Hook that is called after any token transfer. This includes minting
1603      * and burning, as well as batched variants.
1604      *
1605      * The same hook is called on both single and batched variants. For single
1606      * transfers, the length of the `id` and `amount` arrays will be 1.
1607      *
1608      * Calling conditions (for each `id` and `amount` pair):
1609      *
1610      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1611      * of token type `id` will be  transferred to `to`.
1612      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1613      * for `to`.
1614      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1615      * will be burned.
1616      * - `from` and `to` are never both zero.
1617      * - `ids` and `amounts` have the same, non-zero length.
1618      *
1619      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1620      */
1621     function _afterTokenTransfer(
1622         address operator,
1623         address from,
1624         address to,
1625         uint256[] memory ids,
1626         uint256[] memory amounts,
1627         bytes memory data
1628     ) internal virtual {}
1629 
1630     function _doSafeTransferAcceptanceCheck(
1631         address operator,
1632         address from,
1633         address to,
1634         uint256 id,
1635         uint256 amount,
1636         bytes memory data
1637     ) private {
1638         if (to.isContract()) {
1639             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1640                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1641                     revert("ERC1155: ERC1155Receiver rejected tokens");
1642                 }
1643             } catch Error(string memory reason) {
1644                 revert(reason);
1645             } catch {
1646                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1647             }
1648         }
1649     }
1650 
1651     function _doSafeBatchTransferAcceptanceCheck(
1652         address operator,
1653         address from,
1654         address to,
1655         uint256[] memory ids,
1656         uint256[] memory amounts,
1657         bytes memory data
1658     ) private {
1659         if (to.isContract()) {
1660             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1661                 bytes4 response
1662             ) {
1663                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1664                     revert("ERC1155: ERC1155Receiver rejected tokens");
1665                 }
1666             } catch Error(string memory reason) {
1667                 revert(reason);
1668             } catch {
1669                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1670             }
1671         }
1672     }
1673 
1674     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1675         uint256[] memory array = new uint256[](1);
1676         array[0] = element;
1677 
1678         return array;
1679     }
1680 }
1681 
1682 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol
1683 
1684 
1685 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/extensions/ERC1155Supply.sol)
1686 
1687 pragma solidity ^0.8.0;
1688 
1689 
1690 /**
1691  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1692  *
1693  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1694  * clearly identified. Note: While a totalSupply of 1 might mean the
1695  * corresponding is an NFT, there is no guarantees that no other token with the
1696  * same id are not going to be minted.
1697  */
1698 abstract contract ERC1155Supply is ERC1155 {
1699     mapping(uint256 => uint256) private _totalSupply;
1700 
1701     /**
1702      * @dev Total amount of tokens in with a given id.
1703      */
1704     function totalSupply(uint256 id) public view virtual returns (uint256) {
1705         return _totalSupply[id];
1706     }
1707 
1708     /**
1709      * @dev Indicates whether any token exist with a given id, or not.
1710      */
1711     function exists(uint256 id) public view virtual returns (bool) {
1712         return ERC1155Supply.totalSupply(id) > 0;
1713     }
1714 
1715     /**
1716      * @dev See {ERC1155-_beforeTokenTransfer}.
1717      */
1718     function _beforeTokenTransfer(
1719         address operator,
1720         address from,
1721         address to,
1722         uint256[] memory ids,
1723         uint256[] memory amounts,
1724         bytes memory data
1725     ) internal virtual override {
1726         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1727 
1728         if (from == address(0)) {
1729             for (uint256 i = 0; i < ids.length; ++i) {
1730                 _totalSupply[ids[i]] += amounts[i];
1731             }
1732         }
1733 
1734         if (to == address(0)) {
1735             for (uint256 i = 0; i < ids.length; ++i) {
1736                 uint256 id = ids[i];
1737                 uint256 amount = amounts[i];
1738                 uint256 supply = _totalSupply[id];
1739                 require(supply >= amount, "ERC1155: burn amount exceeds totalSupply");
1740                 unchecked {
1741                     _totalSupply[id] = supply - amount;
1742                 }
1743             }
1744         }
1745     }
1746 }
1747 
1748 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol
1749 
1750 
1751 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/extensions/ERC1155Burnable.sol)
1752 
1753 pragma solidity ^0.8.0;
1754 
1755 
1756 /**
1757  * @dev Extension of {ERC1155} that allows token holders to destroy both their
1758  * own tokens and those that they have been approved to use.
1759  *
1760  * _Available since v3.1._
1761  */
1762 abstract contract ERC1155Burnable is ERC1155 {
1763     function burn(
1764         address account,
1765         uint256 id,
1766         uint256 value
1767     ) public virtual {
1768         require(
1769             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1770             "ERC1155: caller is not token owner nor approved"
1771         );
1772 
1773         _burn(account, id, value);
1774     }
1775 
1776     function burnBatch(
1777         address account,
1778         uint256[] memory ids,
1779         uint256[] memory values
1780     ) public virtual {
1781         require(
1782             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1783             "ERC1155: caller is not token owner nor approved"
1784         );
1785 
1786         _burnBatch(account, ids, values);
1787     }
1788 }
1789 
1790 // File: @openzeppelin/contracts/access/Ownable.sol
1791 
1792 
1793 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1794 
1795 pragma solidity ^0.8.0;
1796 
1797 
1798 /**
1799  * @dev Contract module which provides a basic access control mechanism, where
1800  * there is an account (an owner) that can be granted exclusive access to
1801  * specific functions.
1802  *
1803  * By default, the owner account will be the one that deploys the contract. This
1804  * can later be changed with {transferOwnership}.
1805  *
1806  * This module is used through inheritance. It will make available the modifier
1807  * `onlyOwner`, which can be applied to your functions to restrict their use to
1808  * the owner.
1809  */
1810 abstract contract Ownable is Context {
1811     address private _owner;
1812 
1813     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1814 
1815     /**
1816      * @dev Initializes the contract setting the deployer as the initial owner.
1817      */
1818     constructor() {
1819         _transferOwnership(_msgSender());
1820     }
1821 
1822     /**
1823      * @dev Returns the address of the current owner.
1824      */
1825     function owner() public view virtual returns (address) {
1826         return _owner;
1827     }
1828 
1829     /**
1830      * @dev Throws if called by any account other than the owner.
1831      */
1832     modifier onlyOwner() {
1833         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1834         _;
1835     }
1836 
1837     /**
1838      * @dev Leaves the contract without owner. It will not be possible to call
1839      * `onlyOwner` functions anymore. Can only be called by the current owner.
1840      *
1841      * NOTE: Renouncing ownership will leave the contract without an owner,
1842      * thereby removing any functionality that is only available to the owner.
1843      */
1844     function renounceOwnership() public virtual onlyOwner {
1845         _transferOwnership(address(0));
1846     }
1847 
1848     /**
1849      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1850      * Can only be called by the current owner.
1851      */
1852     function transferOwnership(address newOwner) public virtual onlyOwner {
1853         require(newOwner != address(0), "Ownable: new owner is the zero address");
1854         _transferOwnership(newOwner);
1855     }
1856 
1857     /**
1858      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1859      * Internal function without access restriction.
1860      */
1861     function _transferOwnership(address newOwner) internal virtual {
1862         address oldOwner = _owner;
1863         _owner = newOwner;
1864         emit OwnershipTransferred(oldOwner, newOwner);
1865     }
1866 }
1867 
1868 // File: contracts/AbstractERC1155Factory.sol
1869 
1870 
1871 
1872 pragma solidity ^0.8.9;
1873 
1874 
1875 
1876 
1877 
1878 abstract contract AbstractERC1155Factory is Pausable, ERC1155Supply, ERC1155Burnable, Ownable {
1879 
1880     string name_ = "WeArePiplWorld Land";
1881     string symbol_ = "WeAreLand";
1882 
1883     function pause() external onlyOwner {
1884         _pause();
1885     }
1886 
1887     function unpause() external onlyOwner {
1888         _unpause();
1889     }    
1890 
1891     function setURI(string memory baseURI) external onlyOwner {
1892         _setURI(baseURI);
1893     }    
1894 
1895     function name() public view returns (string memory) {
1896         return name_;
1897     }
1898 
1899     function symbol() public view returns (string memory) {
1900         return symbol_;
1901     }          
1902 
1903     function _beforeTokenTransfer(
1904         address operator,
1905         address from,
1906         address to,
1907         uint256[] memory ids,
1908         uint256[] memory amounts,
1909         bytes memory data
1910     ) internal virtual override(ERC1155, ERC1155Supply) {
1911         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1912     }  
1913 }
1914 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1915 
1916 
1917 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1918 
1919 pragma solidity ^0.8.0;
1920 
1921 /**
1922  * @dev Contract module that helps prevent reentrant calls to a function.
1923  *
1924  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1925  * available, which can be applied to functions to make sure there are no nested
1926  * (reentrant) calls to them.
1927  *
1928  * Note that because there is a single `nonReentrant` guard, functions marked as
1929  * `nonReentrant` may not call one another. This can be worked around by making
1930  * those functions `private`, and then adding `external` `nonReentrant` entry
1931  * points to them.
1932  *
1933  * TIP: If you would like to learn more about reentrancy and alternative ways
1934  * to protect against it, check out our blog post
1935  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1936  */
1937 abstract contract ReentrancyGuard {
1938     // Booleans are more expensive than uint256 or any type that takes up a full
1939     // word because each write operation emits an extra SLOAD to first read the
1940     // slot's contents, replace the bits taken up by the boolean, and then write
1941     // back. This is the compiler's defense against contract upgrades and
1942     // pointer aliasing, and it cannot be disabled.
1943 
1944     // The values being non-zero value makes deployment a bit more expensive,
1945     // but in exchange the refund on every call to nonReentrant will be lower in
1946     // amount. Since refunds are capped to a percentage of the total
1947     // transaction's gas, it is best to keep them low in cases like this one, to
1948     // increase the likelihood of the full refund coming into effect.
1949     uint256 private constant _NOT_ENTERED = 1;
1950     uint256 private constant _ENTERED = 2;
1951 
1952     uint256 private _status;
1953 
1954     constructor() {
1955         _status = _NOT_ENTERED;
1956     }
1957 
1958     /**
1959      * @dev Prevents a contract from calling itself, directly or indirectly.
1960      * Calling a `nonReentrant` function from another `nonReentrant`
1961      * function is not supported. It is possible to prevent this from happening
1962      * by making the `nonReentrant` function external, and making it call a
1963      * `private` function that does the actual work.
1964      */
1965     modifier nonReentrant() {
1966         // On the first call to nonReentrant, _notEntered will be true
1967         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1968 
1969         // Any calls to nonReentrant after this point will fail
1970         _status = _ENTERED;
1971 
1972         _;
1973 
1974         // By storing the original value once again, a refund is triggered (see
1975         // https://eips.ethereum.org/EIPS/eip-2200)
1976         _status = _NOT_ENTERED;
1977     }
1978 }
1979 
1980 // File: @openzeppelin/contracts/utils/Strings.sol
1981 
1982 
1983 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1984 
1985 pragma solidity ^0.8.0;
1986 
1987 /**
1988  * @dev String operations.
1989  */
1990 library Strings {
1991     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1992 
1993     /**
1994      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1995      */
1996     function toString(uint256 value) internal pure returns (string memory) {
1997         // Inspired by OraclizeAPI's implementation - MIT licence
1998         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1999 
2000         if (value == 0) {
2001             return "0";
2002         }
2003         uint256 temp = value;
2004         uint256 digits;
2005         while (temp != 0) {
2006             digits++;
2007             temp /= 10;
2008         }
2009         bytes memory buffer = new bytes(digits);
2010         while (value != 0) {
2011             digits -= 1;
2012             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
2013             value /= 10;
2014         }
2015         return string(buffer);
2016     }
2017 
2018     /**
2019      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2020      */
2021     function toHexString(uint256 value) internal pure returns (string memory) {
2022         if (value == 0) {
2023             return "0x00";
2024         }
2025         uint256 temp = value;
2026         uint256 length = 0;
2027         while (temp != 0) {
2028             length++;
2029             temp >>= 8;
2030         }
2031         return toHexString(value, length);
2032     }
2033 
2034     /**
2035      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2036      */
2037     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2038         bytes memory buffer = new bytes(2 * length + 2);
2039         buffer[0] = "0";
2040         buffer[1] = "x";
2041         for (uint256 i = 2 * length + 1; i > 1; --i) {
2042             buffer[i] = _HEX_SYMBOLS[value & 0xf];
2043             value >>= 4;
2044         }
2045         require(value == 0, "Strings: hex length insufficient");
2046         return string(buffer);
2047     }
2048 }
2049 
2050 // File: erc721a/contracts/ERC721A.sol
2051 
2052 
2053 // ERC721A Contracts v3.3.0
2054 // Creator: Chiru Labs
2055 
2056 pragma solidity ^0.8.4;
2057 
2058 
2059 
2060 
2061 
2062 
2063 
2064 /**
2065  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2066  * the Metadata extension. Built to optimize for lower gas during batch mints.
2067  *
2068  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
2069  *
2070  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
2071  *
2072  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
2073  */
2074 contract ERC721A is Context, ERC165, IERC721A {
2075     using Address for address;
2076     using Strings for uint256;
2077 
2078     // The tokenId of the next token to be minted.
2079     uint256 internal _currentIndex;
2080 
2081     // The number of tokens burned.
2082     uint256 internal _burnCounter;
2083 
2084     // Token name
2085     string private _name;
2086 
2087     // Token symbol
2088     string private _symbol;
2089 
2090     // Mapping from token ID to ownership details
2091     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
2092     mapping(uint256 => TokenOwnership) internal _ownerships;
2093 
2094     // Mapping owner address to address data
2095     mapping(address => AddressData) private _addressData;
2096 
2097     // Mapping from token ID to approved address
2098     mapping(uint256 => address) private _tokenApprovals;
2099 
2100     // Mapping from owner to operator approvals
2101     mapping(address => mapping(address => bool)) private _operatorApprovals;
2102 
2103     constructor(string memory name_, string memory symbol_) {
2104         _name = name_;
2105         _symbol = symbol_;
2106         _currentIndex = _startTokenId();
2107     }
2108 
2109     /**
2110      * To change the starting tokenId, please override this function.
2111      */
2112     function _startTokenId() internal view virtual returns (uint256) {
2113         return 0;
2114     }
2115 
2116     /**
2117      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
2118      */
2119     function totalSupply() public view override returns (uint256) {
2120         // Counter underflow is impossible as _burnCounter cannot be incremented
2121         // more than _currentIndex - _startTokenId() times
2122         unchecked {
2123             return _currentIndex - _burnCounter - _startTokenId();
2124         }
2125     }
2126 
2127     /**
2128      * Returns the total amount of tokens minted in the contract.
2129      */
2130     function _totalMinted() internal view returns (uint256) {
2131         // Counter underflow is impossible as _currentIndex does not decrement,
2132         // and it is initialized to _startTokenId()
2133         unchecked {
2134             return _currentIndex - _startTokenId();
2135         }
2136     }
2137 
2138     /**
2139      * @dev See {IERC165-supportsInterface}.
2140      */
2141     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2142         return
2143             interfaceId == type(IERC721).interfaceId ||
2144             interfaceId == type(IERC721Metadata).interfaceId ||
2145             super.supportsInterface(interfaceId);
2146     }
2147 
2148     /**
2149      * @dev See {IERC721-balanceOf}.
2150      */
2151     function balanceOf(address owner) public view override returns (uint256) {
2152         if (owner == address(0)) revert BalanceQueryForZeroAddress();
2153         return uint256(_addressData[owner].balance);
2154     }
2155 
2156     /**
2157      * Returns the number of tokens minted by `owner`.
2158      */
2159     function _numberMinted(address owner) internal view returns (uint256) {
2160         return uint256(_addressData[owner].numberMinted);
2161     }
2162 
2163     /**
2164      * Returns the number of tokens burned by or on behalf of `owner`.
2165      */
2166     function _numberBurned(address owner) internal view returns (uint256) {
2167         return uint256(_addressData[owner].numberBurned);
2168     }
2169 
2170     /**
2171      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
2172      */
2173     function _getAux(address owner) internal view returns (uint64) {
2174         return _addressData[owner].aux;
2175     }
2176 
2177     /**
2178      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
2179      * If there are multiple variables, please pack them into a uint64.
2180      */
2181     function _setAux(address owner, uint64 aux) internal {
2182         _addressData[owner].aux = aux;
2183     }
2184 
2185     /**
2186      * Gas spent here starts off proportional to the maximum mint batch size.
2187      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
2188      */
2189     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
2190         uint256 curr = tokenId;
2191 
2192         unchecked {
2193             if (_startTokenId() <= curr) if (curr < _currentIndex) {
2194                 TokenOwnership memory ownership = _ownerships[curr];
2195                 if (!ownership.burned) {
2196                     if (ownership.addr != address(0)) {
2197                         return ownership;
2198                     }
2199                     // Invariant:
2200                     // There will always be an ownership that has an address and is not burned
2201                     // before an ownership that does not have an address and is not burned.
2202                     // Hence, curr will not underflow.
2203                     while (true) {
2204                         curr--;
2205                         ownership = _ownerships[curr];
2206                         if (ownership.addr != address(0)) {
2207                             return ownership;
2208                         }
2209                     }
2210                 }
2211             }
2212         }
2213         revert OwnerQueryForNonexistentToken();
2214     }
2215 
2216     /**
2217      * @dev See {IERC721-ownerOf}.
2218      */
2219     function ownerOf(uint256 tokenId) public view override returns (address) {
2220         return _ownershipOf(tokenId).addr;
2221     }
2222 
2223     /**
2224      * @dev See {IERC721Metadata-name}.
2225      */
2226     function name() public view virtual override returns (string memory) {
2227         return _name;
2228     }
2229 
2230     /**
2231      * @dev See {IERC721Metadata-symbol}.
2232      */
2233     function symbol() public view virtual override returns (string memory) {
2234         return _symbol;
2235     }
2236 
2237     /**
2238      * @dev See {IERC721Metadata-tokenURI}.
2239      */
2240     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2241         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2242 
2243         string memory baseURI = _baseURI();
2244         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
2245     }
2246 
2247     /**
2248      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2249      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2250      * by default, can be overriden in child contracts.
2251      */
2252     function _baseURI() internal view virtual returns (string memory) {
2253         return '';
2254     }
2255 
2256     /**
2257      * @dev See {IERC721-approve}.
2258      */
2259     function approve(address to, uint256 tokenId) public override {
2260         address owner = ERC721A.ownerOf(tokenId);
2261         if (to == owner) revert ApprovalToCurrentOwner();
2262 
2263         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
2264             revert ApprovalCallerNotOwnerNorApproved();
2265         }
2266 
2267         _approve(to, tokenId, owner);
2268     }
2269 
2270     /**
2271      * @dev See {IERC721-getApproved}.
2272      */
2273     function getApproved(uint256 tokenId) public view override returns (address) {
2274         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2275 
2276         return _tokenApprovals[tokenId];
2277     }
2278 
2279     /**
2280      * @dev See {IERC721-setApprovalForAll}.
2281      */
2282     function setApprovalForAll(address operator, bool approved) public virtual override {
2283         if (operator == _msgSender()) revert ApproveToCaller();
2284 
2285         _operatorApprovals[_msgSender()][operator] = approved;
2286         emit ApprovalForAll(_msgSender(), operator, approved);
2287     }
2288 
2289     /**
2290      * @dev See {IERC721-isApprovedForAll}.
2291      */
2292     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2293         return _operatorApprovals[owner][operator];
2294     }
2295 
2296     /**
2297      * @dev See {IERC721-transferFrom}.
2298      */
2299     function transferFrom(
2300         address from,
2301         address to,
2302         uint256 tokenId
2303     ) public virtual override {
2304         _transfer(from, to, tokenId);
2305     }
2306 
2307     /**
2308      * @dev See {IERC721-safeTransferFrom}.
2309      */
2310     function safeTransferFrom(
2311         address from,
2312         address to,
2313         uint256 tokenId
2314     ) public virtual override {
2315         safeTransferFrom(from, to, tokenId, '');
2316     }
2317 
2318     /**
2319      * @dev See {IERC721-safeTransferFrom}.
2320      */
2321     function safeTransferFrom(
2322         address from,
2323         address to,
2324         uint256 tokenId,
2325         bytes memory _data
2326     ) public virtual override {
2327         _transfer(from, to, tokenId);
2328         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2329             revert TransferToNonERC721ReceiverImplementer();
2330         }
2331     }
2332 
2333     /**
2334      * @dev Returns whether `tokenId` exists.
2335      *
2336      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2337      *
2338      * Tokens start existing when they are minted (`_mint`),
2339      */
2340     function _exists(uint256 tokenId) internal view returns (bool) {
2341         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
2342     }
2343 
2344     /**
2345      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2346      */
2347     function _safeMint(address to, uint256 quantity) internal {
2348         _safeMint(to, quantity, '');
2349     }
2350 
2351     /**
2352      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2353      *
2354      * Requirements:
2355      *
2356      * - If `to` refers to a smart contract, it must implement
2357      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2358      * - `quantity` must be greater than 0.
2359      *
2360      * Emits a {Transfer} event.
2361      */
2362     function _safeMint(
2363         address to,
2364         uint256 quantity,
2365         bytes memory _data
2366     ) internal {
2367         uint256 startTokenId = _currentIndex;
2368         if (to == address(0)) revert MintToZeroAddress();
2369         if (quantity == 0) revert MintZeroQuantity();
2370 
2371         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2372 
2373         // Overflows are incredibly unrealistic.
2374         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
2375         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
2376         unchecked {
2377             _addressData[to].balance += uint64(quantity);
2378             _addressData[to].numberMinted += uint64(quantity);
2379 
2380             _ownerships[startTokenId].addr = to;
2381             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
2382 
2383             uint256 updatedIndex = startTokenId;
2384             uint256 end = updatedIndex + quantity;
2385 
2386             if (to.isContract()) {
2387                 do {
2388                     emit Transfer(address(0), to, updatedIndex);
2389                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
2390                         revert TransferToNonERC721ReceiverImplementer();
2391                     }
2392                 } while (updatedIndex < end);
2393                 // Reentrancy protection
2394                 if (_currentIndex != startTokenId) revert();
2395             } else {
2396                 do {
2397                     emit Transfer(address(0), to, updatedIndex++);
2398                 } while (updatedIndex < end);
2399             }
2400             _currentIndex = updatedIndex;
2401         }
2402         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2403     }
2404 
2405     /**
2406      * @dev Mints `quantity` tokens and transfers them to `to`.
2407      *
2408      * Requirements:
2409      *
2410      * - `to` cannot be the zero address.
2411      * - `quantity` must be greater than 0.
2412      *
2413      * Emits a {Transfer} event.
2414      */
2415     function _mint(address to, uint256 quantity) internal {
2416         uint256 startTokenId = _currentIndex;
2417         if (to == address(0)) revert MintToZeroAddress();
2418         if (quantity == 0) revert MintZeroQuantity();
2419 
2420         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2421 
2422         // Overflows are incredibly unrealistic.
2423         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
2424         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
2425         unchecked {
2426             _addressData[to].balance += uint64(quantity);
2427             _addressData[to].numberMinted += uint64(quantity);
2428 
2429             _ownerships[startTokenId].addr = to;
2430             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
2431 
2432             uint256 updatedIndex = startTokenId;
2433             uint256 end = updatedIndex + quantity;
2434 
2435             do {
2436                 emit Transfer(address(0), to, updatedIndex++);
2437             } while (updatedIndex < end);
2438 
2439             _currentIndex = updatedIndex;
2440         }
2441         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2442     }
2443 
2444     /**
2445      * @dev Transfers `tokenId` from `from` to `to`.
2446      *
2447      * Requirements:
2448      *
2449      * - `to` cannot be the zero address.
2450      * - `tokenId` token must be owned by `from`.
2451      *
2452      * Emits a {Transfer} event.
2453      */
2454     function _transfer(
2455         address from,
2456         address to,
2457         uint256 tokenId
2458     ) private {
2459         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2460 
2461         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
2462 
2463         bool isApprovedOrOwner = (_msgSender() == from ||
2464             isApprovedForAll(from, _msgSender()) ||
2465             getApproved(tokenId) == _msgSender());
2466 
2467         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2468         if (to == address(0)) revert TransferToZeroAddress();
2469 
2470         _beforeTokenTransfers(from, to, tokenId, 1);
2471 
2472         // Clear approvals from the previous owner
2473         _approve(address(0), tokenId, from);
2474 
2475         // Underflow of the sender's balance is impossible because we check for
2476         // ownership above and the recipient's balance can't realistically overflow.
2477         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2478         unchecked {
2479             _addressData[from].balance -= 1;
2480             _addressData[to].balance += 1;
2481 
2482             TokenOwnership storage currSlot = _ownerships[tokenId];
2483             currSlot.addr = to;
2484             currSlot.startTimestamp = uint64(block.timestamp);
2485 
2486             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
2487             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2488             uint256 nextTokenId = tokenId + 1;
2489             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2490             if (nextSlot.addr == address(0)) {
2491                 // This will suffice for checking _exists(nextTokenId),
2492                 // as a burned slot cannot contain the zero address.
2493                 if (nextTokenId != _currentIndex) {
2494                     nextSlot.addr = from;
2495                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2496                 }
2497             }
2498         }
2499 
2500         emit Transfer(from, to, tokenId);
2501         _afterTokenTransfers(from, to, tokenId, 1);
2502     }
2503 
2504     /**
2505      * @dev Equivalent to `_burn(tokenId, false)`.
2506      */
2507     function _burn(uint256 tokenId) internal virtual {
2508         _burn(tokenId, false);
2509     }
2510 
2511     /**
2512      * @dev Destroys `tokenId`.
2513      * The approval is cleared when the token is burned.
2514      *
2515      * Requirements:
2516      *
2517      * - `tokenId` must exist.
2518      *
2519      * Emits a {Transfer} event.
2520      */
2521     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2522         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2523 
2524         address from = prevOwnership.addr;
2525 
2526         if (approvalCheck) {
2527             bool isApprovedOrOwner = (_msgSender() == from ||
2528                 isApprovedForAll(from, _msgSender()) ||
2529                 getApproved(tokenId) == _msgSender());
2530 
2531             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2532         }
2533 
2534         _beforeTokenTransfers(from, address(0), tokenId, 1);
2535 
2536         // Clear approvals from the previous owner
2537         _approve(address(0), tokenId, from);
2538 
2539         // Underflow of the sender's balance is impossible because we check for
2540         // ownership above and the recipient's balance can't realistically overflow.
2541         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2542         unchecked {
2543             AddressData storage addressData = _addressData[from];
2544             addressData.balance -= 1;
2545             addressData.numberBurned += 1;
2546 
2547             // Keep track of who burned the token, and the timestamp of burning.
2548             TokenOwnership storage currSlot = _ownerships[tokenId];
2549             currSlot.addr = from;
2550             currSlot.startTimestamp = uint64(block.timestamp);
2551             currSlot.burned = true;
2552 
2553             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
2554             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2555             uint256 nextTokenId = tokenId + 1;
2556             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2557             if (nextSlot.addr == address(0)) {
2558                 // This will suffice for checking _exists(nextTokenId),
2559                 // as a burned slot cannot contain the zero address.
2560                 if (nextTokenId != _currentIndex) {
2561                     nextSlot.addr = from;
2562                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2563                 }
2564             }
2565         }
2566 
2567         emit Transfer(from, address(0), tokenId);
2568         _afterTokenTransfers(from, address(0), tokenId, 1);
2569 
2570         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2571         unchecked {
2572             _burnCounter++;
2573         }
2574     }
2575 
2576     /**
2577      * @dev Approve `to` to operate on `tokenId`
2578      *
2579      * Emits a {Approval} event.
2580      */
2581     function _approve(
2582         address to,
2583         uint256 tokenId,
2584         address owner
2585     ) private {
2586         _tokenApprovals[tokenId] = to;
2587         emit Approval(owner, to, tokenId);
2588     }
2589 
2590     /**
2591      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2592      *
2593      * @param from address representing the previous owner of the given token ID
2594      * @param to target address that will receive the tokens
2595      * @param tokenId uint256 ID of the token to be transferred
2596      * @param _data bytes optional data to send along with the call
2597      * @return bool whether the call correctly returned the expected magic value
2598      */
2599     function _checkContractOnERC721Received(
2600         address from,
2601         address to,
2602         uint256 tokenId,
2603         bytes memory _data
2604     ) private returns (bool) {
2605         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2606             return retval == IERC721Receiver(to).onERC721Received.selector;
2607         } catch (bytes memory reason) {
2608             if (reason.length == 0) {
2609                 revert TransferToNonERC721ReceiverImplementer();
2610             } else {
2611                 assembly {
2612                     revert(add(32, reason), mload(reason))
2613                 }
2614             }
2615         }
2616     }
2617 
2618     /**
2619      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2620      * And also called before burning one token.
2621      *
2622      * startTokenId - the first token id to be transferred
2623      * quantity - the amount to be transferred
2624      *
2625      * Calling conditions:
2626      *
2627      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2628      * transferred to `to`.
2629      * - When `from` is zero, `tokenId` will be minted for `to`.
2630      * - When `to` is zero, `tokenId` will be burned by `from`.
2631      * - `from` and `to` are never both zero.
2632      */
2633     function _beforeTokenTransfers(
2634         address from,
2635         address to,
2636         uint256 startTokenId,
2637         uint256 quantity
2638     ) internal virtual {}
2639 
2640     /**
2641      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2642      * minting.
2643      * And also called after one token has been burned.
2644      *
2645      * startTokenId - the first token id to be transferred
2646      * quantity - the amount to be transferred
2647      *
2648      * Calling conditions:
2649      *
2650      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2651      * transferred to `to`.
2652      * - When `from` is zero, `tokenId` has been minted for `to`.
2653      * - When `to` is zero, `tokenId` has been burned by `from`.
2654      * - `from` and `to` are never both zero.
2655      */
2656     function _afterTokenTransfers(
2657         address from,
2658         address to,
2659         uint256 startTokenId,
2660         uint256 quantity
2661     ) internal virtual {}
2662 }
2663 
2664 // File: contracts/WeAre.sol
2665 
2666 
2667 
2668 pragma solidity >=0.8.9 <0.9.0;
2669 
2670 
2671 
2672 
2673 
2674 contract WeAre is ERC721A, Ownable, ReentrancyGuard {
2675 
2676   using Strings for uint256;
2677 
2678   bytes32 public merkleRoot;
2679   mapping(address => bool) public whitelistAddressClaimed;
2680   mapping(address => bool) public addressClaimed;
2681 
2682   string public contractURi = "https://gateway.pinata.cloud/ipfs/QmQLTacNdjPWeCKZknda58J7PFfF45ejKnhbv1wCFTB2nG";
2683   string public uriPrefix = '';
2684   string public uriSuffix = '.json';
2685   string public hiddenMetadataUri = "ipfs://QmVJB8B1aSgHoC3Fuerg5eiTrSAN8VJRfwpwLj2tqaBCJJ";
2686   
2687   uint256 public cost = 0 ether;
2688   uint256 public maxSupply = 5000;
2689   uint256 public maxMintAmountPerTx = 1;
2690 
2691   bool public paused = true;
2692   bool public whitelistMintEnabled = false;
2693   bool public revealed = false;
2694 
2695   event minted(address indexed _from, uint256 indexed _amount);
2696   event whitelist(bool _state);
2697   event pause(bool _state);
2698 
2699   constructor(
2700     string memory _tokenName,
2701     string memory _tokenSymbol
2702   ) ERC721A(_tokenName, _tokenSymbol) {
2703   }
2704 
2705   modifier mintCompliance(uint256 _mintAmount) {
2706     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
2707     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
2708     _;
2709   }
2710 
2711   modifier mintPriceCompliance(uint256 _mintAmount) {
2712     require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
2713     _;
2714   }
2715 
2716   function whitelistMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount){
2717     require(whitelistMintEnabled, 'The whitelist sale is not enabled!');
2718     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
2719     require(!whitelistAddressClaimed[_msgSender()], 'Address already claimed!');
2720     
2721     // Verify whitelist requirements
2722     bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
2723     require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'You are not in Whitelist!');
2724 
2725     whitelistAddressClaimed[_msgSender()] = true;
2726     _safeMint(_msgSender(), _mintAmount);
2727     emit minted(msg.sender, _mintAmount);
2728   }
2729 
2730   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount){
2731     require(!paused, 'The contract is paused!');
2732     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
2733     require(!addressClaimed[_msgSender()], 'Address already claimed!');
2734 
2735     addressClaimed[_msgSender()] = true;
2736     _safeMint(_msgSender(), _mintAmount);
2737     emit minted(msg.sender, _mintAmount);
2738   }
2739   
2740   // For marketing etc.
2741   function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
2742     require(_mintAmount > 0 , 'Invalid mint amount!');
2743     _safeMint(_receiver, _mintAmount);
2744   }
2745 
2746   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
2747     uint256 ownerTokenCount = balanceOf(_owner);
2748     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
2749     uint256 currentTokenId = _startTokenId();
2750     uint256 ownedTokenIndex = 0;
2751     address latestOwnerAddress;
2752 
2753     while (ownedTokenIndex < ownerTokenCount && currentTokenId < _currentIndex) {
2754       TokenOwnership memory ownership = _ownerships[currentTokenId];
2755 
2756       if (!ownership.burned) {
2757         if (ownership.addr != address(0)) {
2758           latestOwnerAddress = ownership.addr;
2759         }
2760 
2761         if (latestOwnerAddress == _owner) {
2762           ownedTokenIds[ownedTokenIndex] = currentTokenId;
2763 
2764           ownedTokenIndex++;
2765         }
2766       }
2767 
2768       currentTokenId++;
2769     }
2770 
2771     return ownedTokenIds;
2772   }
2773 
2774   function burn(uint256 tokenId) public {
2775     _burn(tokenId, true);
2776   }
2777 
2778   function _startTokenId() internal view virtual override returns (uint256) {
2779     return 1;
2780   }
2781 
2782   function contractURI() public view returns (string memory) {
2783         return contractURi;
2784     }
2785 
2786   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2787     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
2788 
2789     if (revealed == false) {
2790       return hiddenMetadataUri;
2791     }
2792 
2793     string memory currentBaseURI = _baseURI();
2794     return bytes(currentBaseURI).length > 0
2795         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
2796         : '';
2797   }
2798 
2799   function setContractURI(string memory _newContractURI) public onlyOwner {
2800     contractURi = _newContractURI;
2801   }
2802 
2803   function setRevealed(bool _state) public onlyOwner {
2804     revealed = _state;
2805   }
2806 
2807   function setCost(uint256 _cost) public onlyOwner {
2808     cost = _cost;
2809   }
2810 
2811   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
2812     maxMintAmountPerTx = _maxMintAmountPerTx;
2813   }
2814 
2815   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2816     hiddenMetadataUri = _hiddenMetadataUri;
2817   }
2818 
2819   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2820     uriPrefix = _uriPrefix;
2821   }
2822 
2823   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2824     uriSuffix = _uriSuffix;
2825   }
2826 
2827   function setPaused(bool _state) public onlyOwner {
2828     paused = _state;
2829     emit pause(_state);
2830   }
2831 
2832   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
2833     merkleRoot = _merkleRoot;
2834   }
2835 
2836   function setWhitelistMintEnabled(bool _state) public onlyOwner {
2837     whitelistMintEnabled = _state;
2838     emit whitelist(_state);
2839   }
2840 
2841   function withdraw() public onlyOwner nonReentrant {
2842     
2843     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
2844     require(os);
2845     
2846   }
2847 
2848   function _baseURI() internal view virtual override returns (string memory) {
2849     return uriPrefix;
2850   }
2851 }
2852 // File: contracts/PIPL.sol
2853 
2854 
2855 
2856 pragma solidity >=0.8.9 <0.9.0;
2857 
2858 
2859 
2860 
2861 
2862 contract PIPL is ERC721A, Ownable, ReentrancyGuard {
2863 
2864   using Strings for uint256;
2865 
2866   bytes32 public merkleRoot;
2867   mapping(address => bool) public addressClaimed;
2868 
2869   string public contractURi = "https://gateway.pinata.cloud/ipfs/QmdfvkTCpxNqBuLeps3L7W3TZXT4FXfopoAT8kqMbuWb5W";
2870   string public uriPrefix = '';
2871   string public uriSuffix = '.json';
2872   string public hiddenMetadataUri = "ipfs://QmdpiCYNpgdeTLZVMq8uwmPmzB6eLvhTmhp5KDA61LbxYb";
2873   
2874   uint256 public cost = 0 ether;
2875   uint256 public maxSupply = 10000;
2876   uint256 public maxMintAmountPerTx = 2;
2877 
2878   bool public paused = true;
2879   bool public whitelistMintEnabled = false;
2880   bool public revealed = false;
2881 
2882   event minted(address indexed _from, uint256 indexed _amount);
2883   event whitelist(bool _state);
2884   event pause(bool _state);
2885 
2886   constructor(
2887     string memory _tokenName,
2888     string memory _tokenSymbol
2889   ) ERC721A(_tokenName, _tokenSymbol) {
2890   }
2891 
2892   modifier mintCompliance(uint256 _mintAmount) {
2893     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
2894     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
2895     _;
2896   }
2897 
2898   modifier mintPriceCompliance(uint256 _mintAmount) {
2899     require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
2900     _;
2901   }
2902 
2903   function whitelistMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
2904     // Verify whitelist requirements
2905     require(whitelistMintEnabled, 'The whitelist sale is not enabled!');
2906     require(!addressClaimed[_msgSender()], 'Address already claimed!');
2907     bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
2908     require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'You are not in Whitelist!');
2909 
2910     addressClaimed[_msgSender()] = true;
2911     _safeMint(_msgSender(), _mintAmount);
2912     emit minted(msg.sender, _mintAmount);
2913   }
2914 
2915   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
2916     require(!paused, 'The contract is paused!');
2917     require(!addressClaimed[_msgSender()], 'Address already claimed!');
2918 
2919     addressClaimed[_msgSender()] = true;
2920     _safeMint(_msgSender(), _mintAmount);
2921     emit minted(msg.sender, _mintAmount);
2922   }
2923   
2924   // For marketing etc.
2925   function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
2926     require(_mintAmount > 0 , 'Invalid mint amount!');
2927     _safeMint(_receiver, _mintAmount);
2928   }
2929 
2930   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
2931     uint256 ownerTokenCount = balanceOf(_owner);
2932     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
2933     uint256 currentTokenId = _startTokenId();
2934     uint256 ownedTokenIndex = 0;
2935     address latestOwnerAddress;
2936 
2937     while (ownedTokenIndex < ownerTokenCount && currentTokenId < _currentIndex) {
2938       TokenOwnership memory ownership = _ownerships[currentTokenId];
2939 
2940       if (!ownership.burned) {
2941         if (ownership.addr != address(0)) {
2942           latestOwnerAddress = ownership.addr;
2943         }
2944 
2945         if (latestOwnerAddress == _owner) {
2946           ownedTokenIds[ownedTokenIndex] = currentTokenId;
2947 
2948           ownedTokenIndex++;
2949         }
2950       }
2951 
2952       currentTokenId++;
2953     }
2954 
2955     return ownedTokenIds;
2956   }
2957 
2958   function _startTokenId() internal view virtual override returns (uint256) {
2959     return 1;
2960   }
2961 
2962   function contractURI() public view returns (string memory) {
2963         return contractURi;
2964     }
2965 
2966   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2967     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
2968 
2969     if (revealed == false) {
2970       return hiddenMetadataUri;
2971     }
2972 
2973     string memory currentBaseURI = _baseURI();
2974     return bytes(currentBaseURI).length > 0
2975         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
2976         : '';
2977   }
2978 
2979   function setContractURI(string memory _newContractURI) public onlyOwner {
2980     contractURi = _newContractURI;
2981   }
2982 
2983   function setRevealed(bool _state) public onlyOwner {
2984     revealed = _state;
2985   }
2986 
2987   function setCost(uint256 _cost) public onlyOwner {
2988     cost = _cost;
2989   }
2990 
2991   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
2992     maxMintAmountPerTx = _maxMintAmountPerTx;
2993   }
2994 
2995   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2996     hiddenMetadataUri = _hiddenMetadataUri;
2997   }
2998 
2999   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
3000     uriPrefix = _uriPrefix;
3001   }
3002 
3003   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
3004     uriSuffix = _uriSuffix;
3005   }
3006 
3007   function setPaused(bool _state) public onlyOwner {
3008     paused = _state;
3009     emit pause(_state);
3010   }
3011 
3012   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
3013     merkleRoot = _merkleRoot;
3014   }
3015 
3016   function setWhitelistMintEnabled(bool _state) public onlyOwner {
3017     whitelistMintEnabled = _state;
3018     emit whitelist(_state);
3019   }
3020 
3021   function withdraw() public onlyOwner nonReentrant {
3022     
3023     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
3024     require(os);
3025     
3026   }
3027 
3028   function _baseURI() internal view virtual override returns (string memory) {
3029     return uriPrefix;
3030   }
3031 }
3032 // File: contracts/WeAreLand.sol
3033 
3034 //                         $$\        $$$$$$\      $$$$$$\                                $$\ $$\           
3035 //                         $$ |      $$ ___$$\    $$$ __$$\                               $$ |\__|          
3036 // $$\  $$\  $$\  $$$$$$\  $$$$$$$\  \_/   $$ |   $$$$\ $$ |$$$$$$\$$$$\   $$$$$$\   $$$$$$$ |$$\  $$$$$$\  
3037 // $$ | $$ | $$ |$$  __$$\ $$  __$$\   $$$$$ /    $$\$$\$$ |$$  _$$  _$$\ $$  __$$\ $$  __$$ |$$ | \____$$\ 
3038 // $$ | $$ | $$ |$$$$$$$$ |$$ |  $$ |  \___$$\    $$ \$$$$ |$$ / $$ / $$ |$$$$$$$$ |$$ /  $$ |$$ | $$$$$$$ |
3039 // $$ | $$ | $$ |$$   ____|$$ |  $$ |$$\   $$ |   $$ |\$$$ |$$ | $$ | $$ |$$   ____|$$ |  $$ |$$ |$$  __$$ |
3040 // \$$$$$\$$$$  |\$$$$$$$\ $$$$$$$  |\$$$$$$  |$$\\$$$$$$  /$$ | $$ | $$ |\$$$$$$$\ \$$$$$$$ |$$ |\$$$$$$$ |
3041 //  \_____\____/  \_______|\_______/  \______/ \__|\______/ \__| \__| \__| \_______| \_______|\__| \_______|
3042 
3043 pragma solidity ^0.8.9;
3044 
3045 
3046 
3047 
3048 
3049 
3050 
3051 
3052 contract WeAreLand is AbstractERC1155Factory, ReentrancyGuard, VerifySign, CalScore{
3053     
3054     mapping (uint256 => bool) public claimedWeareId;
3055     
3056     uint256 public constant WeAreCalm = 1;
3057     uint256 public constant WeAreRelax = 2;
3058     uint256 public constant WeAreHappy = 3;
3059     uint256 public constant WeAreRich = 4;
3060     uint256 public constant WeAreFree = 5;
3061 
3062     string public contractURi = "https://gateway.pinata.cloud/ipfs/QmbDDXaqGYS29ahymuLofioBzDDfoazwmmqzupT8TpEQDy";
3063     string public uriPrefix = "ipfs://QmUdX9a4t2mLqSkoz73p332RiHGvmnfWtEuQxdTSiqaSkA/";
3064     string public uriSuffix = ".json";
3065 
3066     address public piplAddress = 0x6Cbf5aB650a7CCb12cf7a4c97E60600A989AcfE1;
3067     address public weareAddress = 0x7b41874eFe38Ea0E4866307B7208D9C856745d31;
3068     uint256 public requirePiplAmount = 4;
3069     uint256 public requireWeAreAmount = 2;
3070     uint256 public claimTokenAmount = 100000;
3071     address public signerAddress = 0xA6e8318353B20660dD9EC9fDaD7361Ad350e917e;
3072 
3073 
3074     constructor() ERC1155(uriPrefix) {
3075         _pause();
3076     }
3077 
3078     event claimed(address indexed _to, uint256 indexed _tokenId);
3079 
3080     function claim(uint256[] calldata pipl_tokenId, uint256[] calldata weare_tokenId, uint256 _totalScore, uint8 v, bytes32 r, bytes32 s) public payable whenNotPaused{
3081 
3082         PIPL piplContact = PIPL(piplAddress);
3083         WeAre weareContact = WeAre(weareAddress);
3084         
3085         //verify signature
3086         require(verifySig(pipl_tokenId, _totalScore, v, r, s) == signerAddress, "Not sign by signer");
3087 
3088         require(pipl_tokenId.length == requirePiplAmount, "Please input a vaild amount of pipl tokenId"); 
3089         require(weare_tokenId.length == requireWeAreAmount, "Please input a vaild amount of WeAre tokenId"); 
3090 
3091         for (uint i = 0; i < requireWeAreAmount; i++){
3092             require(weareContact.ownerOf(weare_tokenId[i]) == msg.sender, "You must be owner of the WeAre");  
3093             require(claimedWeareId[weare_tokenId[i]] == false, "Please use unclaimed WeAre for claim");                     
3094             //mark down claimed WeAre
3095             claimedWeareId[weare_tokenId[i]] = true;
3096         }
3097         
3098         for (uint i = 0; i < requirePiplAmount; i++){
3099             //burn the token
3100             require(piplContact.getApproved(pipl_tokenId[i]) == address(this) || piplContact.isApprovedForAll(msg.sender, address(this)) == true, "Please approve the token for claim");                     
3101             piplContact.safeTransferFrom(msg.sender, 0x000000000000000000000000000000000000dEaD , pipl_tokenId[i]);
3102         }
3103 
3104 
3105         //random
3106         uint256 randomNumber =  uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender,block.difficulty)));
3107         randomNumber = (randomNumber % 100) + 1;
3108 
3109         uint256 landId = calculate(_totalScore, randomNumber);      
3110         
3111         _mint(msg.sender, landId, 1, "");
3112 
3113         emit claimed(msg.sender, landId);   
3114         
3115     }
3116 
3117     // For marketing etc.
3118     function mintForAddress(uint256 _tokenId, uint256 _mintAmount, address _receiver) public onlyOwner {
3119         _mint(_receiver, _tokenId, _mintAmount, "");
3120     }
3121 
3122     function mintForAddressBatch(uint256[] memory _tokenId, uint256[] memory _mintAmount, address _receiver) public onlyOwner {
3123         _mintBatch(_receiver, _tokenId, _mintAmount, "");
3124     }
3125 
3126     function uri(uint256 _tokenId) public view virtual override returns (string memory) {
3127         require(exists(_tokenId), 'Metadata: URI query for nonexistent token');
3128 
3129         string memory currentBaseURI = super.uri(_tokenId);
3130         return bytes(currentBaseURI).length > 0
3131             ? string(abi.encodePacked(currentBaseURI, Strings.toString(_tokenId), uriSuffix))
3132             : '';
3133     }
3134 
3135     function contractURI() public view returns (string memory) {
3136         return contractURi;
3137     }
3138 
3139     function setSignerAddress(address _signerAddress) public onlyOwner {
3140         signerAddress = _signerAddress;
3141     }
3142 
3143     function setContractURI(string memory _newContractURI) public onlyOwner {
3144         contractURi = _newContractURI;
3145     }
3146 
3147     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
3148         uriSuffix = _uriSuffix;
3149     }
3150 
3151     function setRequirePiplAmount(uint256 _requirePiplAmount) public onlyOwner {
3152         requirePiplAmount = _requirePiplAmount;
3153     }
3154 
3155     function setRequireWeAreAmount(uint256 _requireWeAreAmount) public onlyOwner {
3156         requireWeAreAmount = _requireWeAreAmount;
3157     }
3158 
3159     function setClaimTokenAmount(uint256 _claimTokenAmount) public onlyOwner {
3160         claimTokenAmount = _claimTokenAmount;
3161     }
3162 
3163     function withdraw() public onlyOwner nonReentrant {    
3164         (bool os, ) = payable(owner()).call{value: address(this).balance}('');
3165         require(os);    
3166     }
3167 }