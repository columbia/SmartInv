1 /**
2  *Submitted for verification at Etherscan.io on 2022-03-28
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-03-17
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.0;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         return msg.data;
20     }
21 }
22 
23 abstract contract Ownable is Context {
24     address private _owner;
25 
26     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28     /**
29      * @dev Initializes the contract setting the deployer as the initial owner.
30      */
31     constructor() {
32         _setOwner(_msgSender());
33     }
34 
35     /**
36      * @dev Returns the address of the current owner.
37      */
38     function owner() public view virtual returns (address) {
39         return _owner;
40     }
41 
42     /**
43      * @dev Throws if called by any account other than the owner.
44      */
45     modifier onlyOwner() {
46         require(owner() == _msgSender(), "Ownable: caller is not the owner");
47         _;
48     }
49 
50     /**
51      * @dev Leaves the contract without owner. It will not be possible to call
52      * `onlyOwner` functions anymore. Can only be called by the current owner.
53      *
54      * NOTE: Renouncing ownership will leave the contract without an owner,
55      * thereby removing any functionality that is only available to the owner.
56      */
57     function renounceOwnership() public virtual onlyOwner {
58         _setOwner(address(0));
59     }
60 
61     /**
62      * @dev Transfers ownership of the contract to a new account (`newOwner`).
63      * Can only be called by the current owner.
64      */
65     function transferOwnership(address newOwner) public virtual onlyOwner {
66         require(newOwner != address(0), "Ownable: new owner is the zero address");
67         _setOwner(newOwner);
68     }
69 
70     function _setOwner(address newOwner) private {
71         address oldOwner = _owner;
72         _owner = newOwner;
73         emit OwnershipTransferred(oldOwner, newOwner);
74     }
75 }
76 
77 abstract contract ReentrancyGuard {
78     // Booleans are more expensive than uint256 or any type that takes up a full
79     // word because each write operation emits an extra SLOAD to first read the
80     // slot's contents, replace the bits taken up by the boolean, and then write
81     // back. This is the compiler's defense against contract upgrades and
82     // pointer aliasing, and it cannot be disabled.
83 
84     // The values being non-zero value makes deployment a bit more expensive,
85     // but in exchange the refund on every call to nonReentrant will be lower in
86     // amount. Since refunds are capped to a percentage of the total
87     // transaction's gas, it is best to keep them low in cases like this one, to
88     // increase the likelihood of the full refund coming into effect.
89     uint256 private constant _NOT_ENTERED = 1;
90     uint256 private constant _ENTERED = 2;
91 
92     uint256 private _status;
93 
94     constructor() {
95         _status = _NOT_ENTERED;
96     }
97 
98     /**
99      * @dev Prevents a contract from calling itself, directly or indirectly.
100      * Calling a `nonReentrant` function from another `nonReentrant`
101      * function is not supported. It is possible to prevent this from happening
102      * by making the `nonReentrant` function external, and make it call a
103      * `private` function that does the actual work.
104      */
105     modifier nonReentrant() {
106         // On the first call to nonReentrant, _notEntered will be true
107         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
108 
109         // Any calls to nonReentrant after this point will fail
110         _status = _ENTERED;
111 
112         _;
113 
114         // By storing the original value once again, a refund is triggered (see
115         // https://eips.ethereum.org/EIPS/eip-2200)
116         _status = _NOT_ENTERED;
117     }
118 }
119 
120 
121 //merkle start
122 
123 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
124 
125 pragma solidity ^0.8.0;
126 
127 /**
128  * @dev These functions deal with verification of Merkle Trees proofs.
129  *
130  * The proofs can be generated using the JavaScript library
131  * https://github.com/miguelmota/merkletreejs[merkletreejs].
132  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
133  *
134  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
135  *
136  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
137  * hashing, or use a hash function other than keccak256 for hashing leaves.
138  * This is because the concatenation of a sorted pair of internal nodes in
139  * the merkle tree could be reinterpreted as a leaf value.
140  */
141 library MerkleProof {
142     /**
143      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
144      * defined by `root`. For this, a `proof` must be provided, containing
145      * sibling hashes on the branch from the leaf to the root of the tree. Each
146      * pair of leaves and each pair of pre-images are assumed to be sorted.
147      */
148     function verify(
149         bytes32[] memory proof,
150         bytes32 root,
151         bytes32 leaf
152     ) internal pure returns (bool) {
153         return processProof(proof, leaf) == root;
154     }
155 
156     /**
157      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
158      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
159      * hash matches the root of the tree. When processing the proof, the pairs
160      * of leafs & pre-images are assumed to be sorted.
161      *
162      * _Available since v4.4._
163      */
164     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
165         bytes32 computedHash = leaf;
166         for (uint256 i = 0; i < proof.length; i++) {
167             bytes32 proofElement = proof[i];
168             if (computedHash <= proofElement) {
169                 // Hash(current computed hash + current element of the proof)
170                 computedHash = _efficientHash(computedHash, proofElement);
171             } else {
172                 // Hash(current element of the proof + current computed hash)
173                 computedHash = _efficientHash(proofElement, computedHash);
174             }
175         }
176         return computedHash;
177     }
178 
179     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
180         assembly {
181             mstore(0x00, a)
182             mstore(0x20, b)
183             value := keccak256(0x00, 0x40)
184         }
185     }
186 }
187 
188 //merkle end
189 
190 interface IERC165 {
191     /**
192      * @dev Returns true if this contract implements the interface defined by
193      * `interfaceId`. See the corresponding
194      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
195      * to learn more about how these ids are created.
196      *
197      * This function call must use less than 30 000 gas.
198      */
199     function supportsInterface(bytes4 interfaceId) external view returns (bool);
200 }
201 interface IERC721 is IERC165 {
202     /**
203      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
204      */
205     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
206 
207     /**
208      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
209      */
210     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
211 
212     /**
213      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
214      */
215     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
216 
217     /**
218      * @dev Returns the number of tokens in ``owner``'s account.
219      */
220     function balanceOf(address owner) external view returns (uint256 balance);
221 
222     /**
223      * @dev Returns the owner of the `tokenId` token.
224      *
225      * Requirements:
226      *
227      * - `tokenId` must exist.
228      */
229     function ownerOf(uint256 tokenId) external view returns (address owner);
230 
231     /**
232      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
233      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
234      *
235      * Requirements:
236      *
237      * - `from` cannot be the zero address.
238      * - `to` cannot be the zero address.
239      * - `tokenId` token must exist and be owned by `from`.
240      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
241      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
242      *
243      * Emits a {Transfer} event.
244      */
245     function safeTransferFrom(
246         address from,
247         address to,
248         uint256 tokenId
249     ) external;
250 
251     /**
252      * @dev Transfers `tokenId` token from `from` to `to`.
253      *
254      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
255      *
256      * Requirements:
257      *
258      * - `from` cannot be the zero address.
259      * - `to` cannot be the zero address.
260      * - `tokenId` token must be owned by `from`.
261      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
262      *
263      * Emits a {Transfer} event.
264      */
265     function transferFrom(
266         address from,
267         address to,
268         uint256 tokenId
269     ) external;
270 
271     /**
272      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
273      * The approval is cleared when the token is transferred.
274      *
275      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
276      *
277      * Requirements:
278      *
279      * - The caller must own the token or be an approved operator.
280      * - `tokenId` must exist.
281      *
282      * Emits an {Approval} event.
283      */
284     function approve(address to, uint256 tokenId) external;
285 
286     /**
287      * @dev Returns the account approved for `tokenId` token.
288      *
289      * Requirements:
290      *
291      * - `tokenId` must exist.
292      */
293     function getApproved(uint256 tokenId) external view returns (address operator);
294 
295     /**
296      * @dev Approve or remove `operator` as an operator for the caller.
297      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
298      *
299      * Requirements:
300      *
301      * - The `operator` cannot be the caller.
302      *
303      * Emits an {ApprovalForAll} event.
304      */
305     function setApprovalForAll(address operator, bool _approved) external;
306 
307     /**
308      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
309      *
310      * See {setApprovalForAll}
311      */
312     function isApprovedForAll(address owner, address operator) external view returns (bool);
313 
314     /**
315      * @dev Safely transfers `tokenId` token from `from` to `to`.
316      *
317      * Requirements:
318      *
319      * - `from` cannot be the zero address.
320      * - `to` cannot be the zero address.
321      * - `tokenId` token must exist and be owned by `from`.
322      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
323      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
324      *
325      * Emits a {Transfer} event.
326      */
327     function safeTransferFrom(
328         address from,
329         address to,
330         uint256 tokenId,
331         bytes calldata data
332     ) external;
333 }
334 
335 interface IERC721Receiver {
336     /**
337      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
338      * by `operator` from `from`, this function is called.
339      *
340      * It must return its Solidity selector to confirm the token transfer.
341      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
342      *
343      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
344      */
345     function onERC721Received(
346         address operator,
347         address from,
348         uint256 tokenId,
349         bytes calldata data
350     ) external returns (bytes4);
351 }
352 
353 interface IERC721Metadata is IERC721 {
354     /**
355      * @dev Returns the token collection name.
356      */
357     function name() external view returns (string memory);
358 
359     /**
360      * @dev Returns the token collection symbol.
361      */
362     function symbol() external view returns (string memory);
363 
364     /**
365      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
366      */
367     function tokenURI(uint256 tokenId) external view returns (string memory);
368 }
369 
370 interface IERC721Enumerable is IERC721 {
371     /**
372      * @dev Returns the total amount of tokens stored by the contract.
373      */
374     function totalSupply() external view returns (uint256);
375 
376     /**
377      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
378      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
379      */
380     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
381 
382     /**
383      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
384      * Use along with {totalSupply} to enumerate all tokens.
385      */
386     function tokenByIndex(uint256 index) external view returns (uint256);
387 }
388 
389 library Address {
390     /**
391      * @dev Returns true if `account` is a contract.
392      *
393      * [IMPORTANT]
394      * ====
395      * It is unsafe to assume that an address for which this function returns
396      * false is an externally-owned account (EOA) and not a contract.
397      *
398      * Among others, `isContract` will return false for the following
399      * types of addresses:
400      *
401      *  - an externally-owned account
402      *  - a contract in construction
403      *  - an address where a contract will be created
404      *  - an address where a contract lived, but was destroyed
405      * ====
406      */
407     function isContract(address account) internal view returns (bool) {
408         // This method relies on extcodesize, which returns 0 for contracts in
409         // construction, since the code is only stored at the end of the
410         // constructor execution.
411 
412         uint256 size;
413         assembly {
414             size := extcodesize(account)
415         }
416         return size > 0;
417     }
418 
419     /**
420      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
421      * `recipient`, forwarding all available gas and reverting on errors.
422      *
423      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
424      * of certain opcodes, possibly making contracts go over the 2300 gas limit
425      * imposed by `transfer`, making them unable to receive funds via
426      * `transfer`. {sendValue} removes this limitation.
427      *
428      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
429      *
430      * IMPORTANT: because control is transferred to `recipient`, care must be
431      * taken to not create reentrancy vulnerabilities. Consider using
432      * {ReentrancyGuard} or the
433      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
434      */
435     function sendValue(address payable recipient, uint256 amount) internal {
436         require(address(this).balance >= amount, "Address: insufficient balance");
437 
438         (bool success, ) = recipient.call{value: amount}("");
439         require(success, "Address: unable to send value, recipient may have reverted");
440     }
441 
442     /**
443      * @dev Performs a Solidity function call using a low level `call`. A
444      * plain `call` is an unsafe replacement for a function call: use this
445      * function instead.
446      *
447      * If `target` reverts with a revert reason, it is bubbled up by this
448      * function (like regular Solidity function calls).
449      *
450      * Returns the raw returned data. To convert to the expected return value,
451      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
452      *
453      * Requirements:
454      *
455      * - `target` must be a contract.
456      * - calling `target` with `data` must not revert.
457      *
458      * _Available since v3.1._
459      */
460     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
461         return functionCall(target, data, "Address: low-level call failed");
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
466      * `errorMessage` as a fallback revert reason when `target` reverts.
467      *
468      * _Available since v3.1._
469      */
470     function functionCall(
471         address target,
472         bytes memory data,
473         string memory errorMessage
474     ) internal returns (bytes memory) {
475         return functionCallWithValue(target, data, 0, errorMessage);
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
480      * but also transferring `value` wei to `target`.
481      *
482      * Requirements:
483      *
484      * - the calling contract must have an ETH balance of at least `value`.
485      * - the called Solidity function must be `payable`.
486      *
487      * _Available since v3.1._
488      */
489     function functionCallWithValue(
490         address target,
491         bytes memory data,
492         uint256 value
493     ) internal returns (bytes memory) {
494         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
495     }
496 
497     /**
498      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
499      * with `errorMessage` as a fallback revert reason when `target` reverts.
500      *
501      * _Available since v3.1._
502      */
503     function functionCallWithValue(
504         address target,
505         bytes memory data,
506         uint256 value,
507         string memory errorMessage
508     ) internal returns (bytes memory) {
509         require(address(this).balance >= value, "Address: insufficient balance for call");
510         require(isContract(target), "Address: call to non-contract");
511 
512         (bool success, bytes memory returndata) = target.call{value: value}(data);
513         return _verifyCallResult(success, returndata, errorMessage);
514     }
515 
516     /**
517      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
518      * but performing a static call.
519      *
520      * _Available since v3.3._
521      */
522     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
523         return functionStaticCall(target, data, "Address: low-level static call failed");
524     }
525 
526     /**
527      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
528      * but performing a static call.
529      *
530      * _Available since v3.3._
531      */
532     function functionStaticCall(
533         address target,
534         bytes memory data,
535         string memory errorMessage
536     ) internal view returns (bytes memory) {
537         require(isContract(target), "Address: static call to non-contract");
538 
539         (bool success, bytes memory returndata) = target.staticcall(data);
540         return _verifyCallResult(success, returndata, errorMessage);
541     }
542 
543     /**
544      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
545      * but performing a delegate call.
546      *
547      * _Available since v3.4._
548      */
549     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
550         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
555      * but performing a delegate call.
556      *
557      * _Available since v3.4._
558      */
559     function functionDelegateCall(
560         address target,
561         bytes memory data,
562         string memory errorMessage
563     ) internal returns (bytes memory) {
564         require(isContract(target), "Address: delegate call to non-contract");
565 
566         (bool success, bytes memory returndata) = target.delegatecall(data);
567         return _verifyCallResult(success, returndata, errorMessage);
568     }
569 
570     function _verifyCallResult(
571         bool success,
572         bytes memory returndata,
573         string memory errorMessage
574     ) private pure returns (bytes memory) {
575         if (success) {
576             return returndata;
577         } else {
578             // Look for revert reason and bubble it up if present
579             if (returndata.length > 0) {
580                 // The easiest way to bubble the revert reason is using memory via assembly
581 
582                 assembly {
583                     let returndata_size := mload(returndata)
584                     revert(add(32, returndata), returndata_size)
585                 }
586             } else {
587                 revert(errorMessage);
588             }
589         }
590     }
591 }
592 abstract contract ERC165 is IERC165 {
593     /**
594      * @dev See {IERC165-supportsInterface}.
595      */
596     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
597         return interfaceId == type(IERC165).interfaceId;
598     }
599 }
600 error ApprovalCallerNotOwnerNorApproved();
601 error ApprovalQueryForNonexistentToken();
602 error ApproveToCaller();
603 error ApprovalToCurrentOwner();
604 error BalanceQueryForZeroAddress();
605 error MintedQueryForZeroAddress();
606 error BurnedQueryForZeroAddress();
607 error MintToZeroAddress();
608 error MintZeroQuantity();
609 error OwnerIndexOutOfBounds();
610 error OwnerQueryForNonexistentToken();
611 error TokenIndexOutOfBounds();
612 error TransferCallerNotOwnerNorApproved();
613 error TransferFromIncorrectOwner();
614 error TransferToNonERC721ReceiverImplementer();
615 error TransferToZeroAddress();
616 error URIQueryForNonexistentToken();
617 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
618     using Address for address;
619     using Strings for uint256;
620 
621     // Compiler will pack this into a single 256bit word.
622     struct TokenOwnership {
623         // The address of the owner.
624         address addr;
625         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
626         uint64 startTimestamp;
627         // Whether the token has been burned.
628         bool burned;
629     }
630 
631     // Compiler will pack this into a single 256bit word.
632     struct AddressData {
633         // Realistically, 2**64-1 is more than enough.
634         uint64 balance;
635         // Keeps track of mint count with minimal overhead for tokenomics.
636         uint64 numberMinted;
637         // Keeps track of burn count with minimal overhead for tokenomics.
638         uint64 numberBurned;
639     }
640 
641     // The tokenId of the next token to be minted.
642     uint256 internal _currentIndex;
643 
644     // The number of tokens burned.
645     uint256 internal _burnCounter;
646 
647     // Token name
648     string private _name;
649 
650     // Token symbol
651     string private _symbol;
652 
653     // Mapping from token ID to ownership details
654     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
655     mapping(uint256 => TokenOwnership) internal _ownerships;
656 
657     // Mapping owner address to address data
658     mapping(address => AddressData) private _addressData;
659 
660     // Mapping from token ID to approved address
661     mapping(uint256 => address) private _tokenApprovals;
662 
663     // Mapping from owner to operator approvals
664     mapping(address => mapping(address => bool)) private _operatorApprovals;
665 
666     constructor(string memory name_, string memory symbol_) {
667         _name = name_;
668         _symbol = symbol_;
669     }
670 
671     /**
672      * @dev See {IERC721Enumerable-totalSupply}.
673      */
674     function totalSupply() public view override returns (uint256) {
675         // Counter underflow is impossible as _burnCounter cannot be incremented
676         // more than _currentIndex times
677         unchecked {
678             return _currentIndex - _burnCounter;    
679         }
680     }
681 
682     /**
683      * @dev See {IERC721Enumerable-tokenByIndex}.
684      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
685      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
686      */
687     function tokenByIndex(uint256 index) public view override returns (uint256) {
688         uint256 numMintedSoFar = _currentIndex;
689         uint256 tokenIdsIdx;
690 
691         // Counter overflow is impossible as the loop breaks when
692         // uint256 i is equal to another uint256 numMintedSoFar.
693         unchecked {
694             for (uint256 i; i < numMintedSoFar; i++) {
695                 TokenOwnership memory ownership = _ownerships[i];
696                 if (!ownership.burned) {
697                     if (tokenIdsIdx == index) {
698                         return i;
699                     }
700                     tokenIdsIdx++;
701                 }
702             }
703         }
704         revert TokenIndexOutOfBounds();
705     }
706 
707     /**
708      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
709      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
710      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
711      */
712     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
713         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
714         uint256 numMintedSoFar = _currentIndex;
715         uint256 tokenIdsIdx;
716         address currOwnershipAddr;
717 
718         // Counter overflow is impossible as the loop breaks when
719         // uint256 i is equal to another uint256 numMintedSoFar.
720         unchecked {
721             for (uint256 i; i < numMintedSoFar; i++) {
722                 TokenOwnership memory ownership = _ownerships[i];
723                 if (ownership.burned) {
724                     continue;
725                 }
726                 if (ownership.addr != address(0)) {
727                     currOwnershipAddr = ownership.addr;
728                 }
729                 if (currOwnershipAddr == owner) {
730                     if (tokenIdsIdx == index) {
731                         return i;
732                     }
733                     tokenIdsIdx++;
734                 }
735             }
736         }
737 
738         // Execution should never reach this point.
739         revert();
740     }
741 
742     /**
743      * @dev See {IERC165-supportsInterface}.
744      */
745     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
746         return
747             interfaceId == type(IERC721).interfaceId ||
748             interfaceId == type(IERC721Metadata).interfaceId ||
749             interfaceId == type(IERC721Enumerable).interfaceId ||
750             super.supportsInterface(interfaceId);
751     }
752 
753     /**
754      * @dev See {IERC721-balanceOf}.
755      */
756     function balanceOf(address owner) public view override returns (uint256) {
757         if (owner == address(0)) revert BalanceQueryForZeroAddress();
758         return uint256(_addressData[owner].balance);
759     }
760 
761     function _numberMinted(address owner) internal view returns (uint256) {
762         if (owner == address(0)) revert MintedQueryForZeroAddress();
763         return uint256(_addressData[owner].numberMinted);
764     }
765 
766     function _numberBurned(address owner) internal view returns (uint256) {
767         if (owner == address(0)) revert BurnedQueryForZeroAddress();
768         return uint256(_addressData[owner].numberBurned);
769     }
770 
771     /**
772      * Gas spent here starts off proportional to the maximum mint batch size.
773      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
774      */
775     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
776         uint256 curr = tokenId;
777 
778         unchecked {
779             if (curr < _currentIndex) {
780                 TokenOwnership memory ownership = _ownerships[curr];
781                 if (!ownership.burned) {
782                     if (ownership.addr != address(0)) {
783                         return ownership;
784                     }
785                     // Invariant: 
786                     // There will always be an ownership that has an address and is not burned 
787                     // before an ownership that does not have an address and is not burned.
788                     // Hence, curr will not underflow.
789                     while (true) {
790                         curr--;
791                         ownership = _ownerships[curr];
792                         if (ownership.addr != address(0)) {
793                             return ownership;
794                         }
795                     }
796                 }
797             }
798         }
799         revert OwnerQueryForNonexistentToken();
800     }
801 
802     /**
803      * @dev See {IERC721-ownerOf}.
804      */
805     function ownerOf(uint256 tokenId) public view override returns (address) {
806         return ownershipOf(tokenId).addr;
807     }
808 
809     /**
810      * @dev See {IERC721Metadata-name}.
811      */
812     function name() public view virtual override returns (string memory) {
813         return _name;
814     }
815 
816     /**
817      * @dev See {IERC721Metadata-symbol}.
818      */
819     function symbol() public view virtual override returns (string memory) {
820         return _symbol;
821     }
822 
823     /**
824      * @dev See {IERC721Metadata-tokenURI}.
825      */
826     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
827         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
828 
829         string memory baseURI = _baseURI();
830         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
831     }
832 
833     /**
834      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
835      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
836      * by default, can be overriden in child contracts.
837      */
838    function _baseURI() internal view virtual returns (string memory) {
839         return "";
840     }
841 
842     /**
843      * @dev See {IERC721-approve}.
844      */
845     function approve(address to, uint256 tokenId) public override {
846         address owner = ERC721A.ownerOf(tokenId);
847         if (to == owner) revert ApprovalToCurrentOwner();
848 
849         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
850             revert ApprovalCallerNotOwnerNorApproved();
851         }
852 
853         _approve(to, tokenId, owner);
854     }
855 
856     /**
857      * @dev See {IERC721-getApproved}.
858      */
859     function getApproved(uint256 tokenId) public view override returns (address) {
860         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
861 
862         return _tokenApprovals[tokenId];
863     }
864 
865     /**
866      * @dev See {IERC721-setApprovalForAll}.
867      */
868     function setApprovalForAll(address operator, bool approved) public override {
869         if (operator == _msgSender()) revert ApproveToCaller();
870 
871         _operatorApprovals[_msgSender()][operator] = approved;
872         emit ApprovalForAll(_msgSender(), operator, approved);
873     }
874 
875     /**
876      * @dev See {IERC721-isApprovedForAll}.
877      */
878     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
879         return _operatorApprovals[owner][operator];
880     }
881 
882     /**
883      * @dev See {IERC721-transferFrom}.
884      */
885     function transferFrom(
886         address from,
887         address to,
888         uint256 tokenId
889     ) public virtual override {
890         _transfer(from, to, tokenId);
891     }
892 
893     /**
894      * @dev See {IERC721-safeTransferFrom}.
895      */
896     function safeTransferFrom(
897         address from,
898         address to,
899         uint256 tokenId
900     ) public virtual override {
901         safeTransferFrom(from, to, tokenId, '');
902     }
903 
904     /**
905      * @dev See {IERC721-safeTransferFrom}.
906      */
907     function safeTransferFrom(
908         address from,
909         address to,
910         uint256 tokenId,
911         bytes memory _data
912     ) public virtual override {
913         _transfer(from, to, tokenId);
914         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
915             revert TransferToNonERC721ReceiverImplementer();
916         }
917     }
918 
919     /**
920      * @dev Returns whether `tokenId` exists.
921      *
922      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
923      *
924      * Tokens start existing when they are minted (`_mint`),
925      */
926     function _exists(uint256 tokenId) internal view returns (bool) {
927         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
928     }
929 
930     function _safeMint(address to, uint256 quantity) internal {
931         _safeMint(to, quantity, '');
932     }
933 
934     /**
935      * @dev Safely mints `quantity` tokens and transfers them to `to`.
936      *
937      * Requirements:
938      *
939      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
940      * - `quantity` must be greater than 0.
941      *
942      * Emits a {Transfer} event.
943      */
944     function _safeMint(
945         address to,
946         uint256 quantity,
947         bytes memory _data
948     ) internal {
949         _mint(to, quantity, _data, true);
950     }
951 
952     /**
953      * @dev Mints `quantity` tokens and transfers them to `to`.
954      *
955      * Requirements:
956      *
957      * - `to` cannot be the zero address.
958      * - `quantity` must be greater than 0.
959      *
960      * Emits a {Transfer} event.
961      */
962     function _mint(
963         address to,
964         uint256 quantity,
965         bytes memory _data,
966         bool safe
967     ) internal {
968         uint256 startTokenId = _currentIndex;
969         if (to == address(0)) revert MintToZeroAddress();
970         if (quantity == 0) revert MintZeroQuantity();
971 
972         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
973 
974         // Overflows are incredibly unrealistic.
975         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
976         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
977         unchecked {
978             _addressData[to].balance += uint64(quantity);
979             _addressData[to].numberMinted += uint64(quantity);
980 
981             _ownerships[startTokenId].addr = to;
982             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
983 
984             uint256 updatedIndex = startTokenId;
985 
986             for (uint256 i; i < quantity; i++) {
987                 emit Transfer(address(0), to, updatedIndex);
988                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
989                     revert TransferToNonERC721ReceiverImplementer();
990                 }
991                 updatedIndex++;
992             }
993 
994             _currentIndex = updatedIndex;
995         }
996         _afterTokenTransfers(address(0), to, startTokenId, quantity);
997     }
998 
999     /**
1000      * @dev Transfers `tokenId` from `from` to `to`.
1001      *
1002      * Requirements:
1003      *
1004      * - `to` cannot be the zero address.
1005      * - `tokenId` token must be owned by `from`.
1006      *
1007      * Emits a {Transfer} event.
1008      */
1009     function _transfer(
1010         address from,
1011         address to,
1012         uint256 tokenId
1013     ) private {
1014         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1015 
1016         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1017             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1018             getApproved(tokenId) == _msgSender());
1019 
1020         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1021         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1022         if (to == address(0)) revert TransferToZeroAddress();
1023 
1024         _beforeTokenTransfers(from, to, tokenId, 1);
1025 
1026         // Clear approvals from the previous owner
1027         _approve(address(0), tokenId, prevOwnership.addr);
1028 
1029         // Underflow of the sender's balance is impossible because we check for
1030         // ownership above and the recipient's balance can't realistically overflow.
1031         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1032         unchecked {
1033             _addressData[from].balance -= 1;
1034             _addressData[to].balance += 1;
1035 
1036             _ownerships[tokenId].addr = to;
1037             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1038 
1039             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1040             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1041             uint256 nextTokenId = tokenId + 1;
1042             if (_ownerships[nextTokenId].addr == address(0)) {
1043                 // This will suffice for checking _exists(nextTokenId),
1044                 // as a burned slot cannot contain the zero address.
1045                 if (nextTokenId < _currentIndex) {
1046                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1047                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1048                 }
1049             }
1050         }
1051 
1052         emit Transfer(from, to, tokenId);
1053         _afterTokenTransfers(from, to, tokenId, 1);
1054     }
1055 
1056     /**
1057      * @dev Destroys `tokenId`.
1058      * The approval is cleared when the token is burned.
1059      *
1060      * Requirements:
1061      *
1062      * - `tokenId` must exist.
1063      *
1064      * Emits a {Transfer} event.
1065      */
1066     function _burn(uint256 tokenId) internal virtual {
1067         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1068 
1069         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1070 
1071         // Clear approvals from the previous owner
1072         _approve(address(0), tokenId, prevOwnership.addr);
1073 
1074         // Underflow of the sender's balance is impossible because we check for
1075         // ownership above and the recipient's balance can't realistically overflow.
1076         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1077         unchecked {
1078             _addressData[prevOwnership.addr].balance -= 1;
1079             _addressData[prevOwnership.addr].numberBurned += 1;
1080 
1081             // Keep track of who burned the token, and the timestamp of burning.
1082             _ownerships[tokenId].addr = prevOwnership.addr;
1083             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1084             _ownerships[tokenId].burned = true;
1085 
1086             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1087             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1088             uint256 nextTokenId = tokenId + 1;
1089             if (_ownerships[nextTokenId].addr == address(0)) {
1090                 // This will suffice for checking _exists(nextTokenId),
1091                 // as a burned slot cannot contain the zero address.
1092                 if (nextTokenId < _currentIndex) {
1093                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1094                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1095                 }
1096             }
1097         }
1098 
1099         emit Transfer(prevOwnership.addr, address(0), tokenId);
1100         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1101 
1102         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1103         unchecked { 
1104             _burnCounter++;
1105         }
1106     }
1107 
1108     /**
1109      * @dev Approve `to` to operate on `tokenId`
1110      *
1111      * Emits a {Approval} event.
1112      */
1113     function _approve(
1114         address to,
1115         uint256 tokenId,
1116         address owner
1117     ) private {
1118         _tokenApprovals[tokenId] = to;
1119         emit Approval(owner, to, tokenId);
1120     }
1121 
1122     /**
1123      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1124      * The call is not executed if the target address is not a contract.
1125      *
1126      * @param from address representing the previous owner of the given token ID
1127      * @param to target address that will receive the tokens
1128      * @param tokenId uint256 ID of the token to be transferred
1129      * @param _data bytes optional data to send along with the call
1130      * @return bool whether the call correctly returned the expected magic value
1131      */
1132     function _checkOnERC721Received(
1133         address from,
1134         address to,
1135         uint256 tokenId,
1136         bytes memory _data
1137     ) private returns (bool) {
1138         if (to.isContract()) {
1139             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1140                 return retval == IERC721Receiver(to).onERC721Received.selector;
1141             } catch (bytes memory reason) {
1142                 if (reason.length == 0) {
1143                     revert TransferToNonERC721ReceiverImplementer();
1144                 } else {
1145                     assembly {
1146                         revert(add(32, reason), mload(reason))
1147                     }
1148                 }
1149             }
1150         } else {
1151             return true;
1152         }
1153     }
1154 
1155     /**
1156      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1157      * And also called before burning one token.
1158      *
1159      * startTokenId - the first token id to be transferred
1160      * quantity - the amount to be transferred
1161      *
1162      * Calling conditions:
1163      *
1164      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1165      * transferred to `to`.
1166      * - When `from` is zero, `tokenId` will be minted for `to`.
1167      * - When `to` is zero, `tokenId` will be burned by `from`.
1168      * - `from` and `to` are never both zero.
1169      */
1170     function _beforeTokenTransfers(
1171         address from,
1172         address to,
1173         uint256 startTokenId,
1174         uint256 quantity
1175     ) internal virtual {}
1176 
1177     /**
1178      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1179      * minting.
1180      * And also called after one token has been burned.
1181      *
1182      * startTokenId - the first token id to be transferred
1183      * quantity - the amount to be transferred
1184      *
1185      * Calling conditions:
1186      *
1187      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1188      * transferred to `to`.
1189      * - When `from` is zero, `tokenId` has been minted for `to`.
1190      * - When `to` is zero, `tokenId` has been burned by `from`.
1191      * - `from` and `to` are never both zero.
1192      */
1193     function _afterTokenTransfers(
1194         address from,
1195         address to,
1196         uint256 startTokenId,
1197         uint256 quantity
1198     ) internal virtual {}
1199 }
1200 
1201 library Strings {
1202     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1203 
1204     /**
1205      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1206      */
1207     function toString(uint256 value) internal pure returns (string memory) {
1208         // Inspired by OraclizeAPI's implementation - MIT licence
1209         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1210 
1211         if (value == 0) {
1212             return "0";
1213         }
1214         uint256 temp = value;
1215         uint256 digits;
1216         while (temp != 0) {
1217             digits++;
1218             temp /= 10;
1219         }
1220         bytes memory buffer = new bytes(digits);
1221         while (value != 0) {
1222             digits -= 1;
1223             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1224             value /= 10;
1225         }
1226         return string(buffer);
1227     }
1228 
1229     /**
1230      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1231      */
1232     function toHexString(uint256 value) internal pure returns (string memory) {
1233         if (value == 0) {
1234             return "0x00";
1235         }
1236         uint256 temp = value;
1237         uint256 length = 0;
1238         while (temp != 0) {
1239             length++;
1240             temp >>= 8;
1241         }
1242         return toHexString(value, length);
1243     }
1244 
1245     /**
1246      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1247      */
1248     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1249         bytes memory buffer = new bytes(2 * length + 2);
1250         buffer[0] = "0";
1251         buffer[1] = "x";
1252         for (uint256 i = 2 * length + 1; i > 1; --i) {
1253             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1254             value >>= 4;
1255         }
1256         require(value == 0, "Strings: hex length insufficient");
1257         return string(buffer);
1258     }
1259 }
1260 
1261 contract GummiesGang is Ownable, ERC721A, ReentrancyGuard {
1262     
1263 
1264     using Strings for uint256;
1265     
1266     bool public Presale_status = false;
1267     bool public public_sale_status = false;
1268 
1269     string public baseURI;
1270     uint public tokenPrice = 0.075 ether;
1271     uint public presale_price = 0.075 ether;
1272     uint256 public maxSupply = 6969;
1273     uint256 public maxPerWallet = 2;
1274     uint public maxPerTransaction = 2; 
1275     uint public phase= 6969;
1276      bytes32 public whitelistMerkleRoot;
1277 
1278     constructor(string memory name, 
1279         string memory symbol) 
1280         ERC721A(name, symbol) 
1281     {}
1282 
1283     function buy(uint256 _count) public payable {
1284        
1285         require(public_sale_status == true, "Sale is not Active");
1286         require(_count > 0, "mint at least one token");
1287         require(_count <= maxPerTransaction, "max per transaction 2");
1288         require(totalSupply() + _count <= maxSupply, "Reaching max supply");
1289         require(totalSupply() + _count<= phase, "Not enough tokens left in current phase");
1290         require(getMintedCount(msg.sender) + _count <= maxPerWallet, "Exceed max per wallet");
1291         require(msg.value >= tokenPrice * _count, "incorrect ether amount");
1292         
1293         _safeMint(msg.sender, _count);
1294 
1295     }
1296     function buy_presale(uint256 _count, bytes32[] calldata merkleProof) public payable {
1297         require(Presale_status == true, "Sale is not Active");
1298          require(MerkleProof.verify(merkleProof,whitelistMerkleRoot,keccak256(abi.encodePacked(msg.sender))),"Your address is not Whitelisted");
1299         require(_count > 0, "mint at least one token");
1300         require(_count <= maxPerTransaction, "max per transaction 2");
1301         require(totalSupply() + _count <= maxSupply, "Reaching max supply");
1302         require(totalSupply() + _count<= phase, "Not enough tokens left in current phase");
1303         require(getMintedCount(msg.sender) + _count <= maxPerWallet, "Exceed max per wallet");
1304         require(msg.value >= presale_price, "incorrect ether amount");
1305 
1306         _safeMint(msg.sender, _count);
1307 
1308     }
1309 
1310         function sendGifts(address[] memory _wallets) public onlyOwner{
1311         require(_wallets.length > 0, "mint at least one token");
1312         require(totalSupply() + _wallets.length <= maxSupply, "not enough tokens left");
1313         for(uint i = 0; i < _wallets.length; i++)
1314             _safeMint(_wallets[i], 1 );
1315         
1316     }
1317 
1318     function setBaseUri(string memory _uri) external onlyOwner {
1319         baseURI = _uri;
1320     }
1321 
1322     function _baseURI() internal view virtual override returns (string memory) {
1323         return baseURI;
1324     }
1325 
1326     function setmaxPerWallet(uint256 _temp) public onlyOwner() {
1327         maxPerWallet = _temp;
1328     }
1329 
1330     function setmaxPerTransaction(uint256 _temp) public onlyOwner() {
1331         maxPerTransaction = _temp;
1332     }
1333 
1334     function pre_Sale_status(bool temp) external onlyOwner {
1335         Presale_status = temp;
1336     }
1337     function publicSale_status(bool temp) external onlyOwner {
1338         public_sale_status = temp;
1339     }
1340      function update_public_price(uint price) external onlyOwner {
1341         tokenPrice = price;
1342     }
1343        function update_preSale_price(uint price) external onlyOwner {
1344         presale_price = price;
1345     }
1346 
1347     function getBalance() public view returns(uint) {
1348         return address(this).balance;
1349     }
1350 
1351     function getMintedCount(address owner) public view returns (uint256) {
1352     return _numberMinted(owner);
1353   }
1354 
1355     function withdraw() external onlyOwner {
1356         uint _balance = address(this).balance;
1357         payable(owner()).transfer(_balance); //Owner
1358     }
1359 
1360         function setWhiteListMerkleRoot(bytes32 merkleRoot) public onlyOwner {
1361 		whitelistMerkleRoot = merkleRoot;
1362 	}
1363 
1364          function setPhase(uint256 _newPhase) public onlyOwner() {
1365         phase = _newPhase;
1366     }
1367 
1368 }