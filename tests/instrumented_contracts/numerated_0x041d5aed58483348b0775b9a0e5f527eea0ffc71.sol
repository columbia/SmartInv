1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev These functions deal with verification of Merkle Trees proofs.
7  *
8  * The proofs can be generated using the JavaScript library
9  * https://github.com/miguelmota/merkletreejs[merkletreejs].
10  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
11  *
12  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
13  *
14  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
15  * hashing, or use a hash function other than keccak256 for hashing leaves.
16  * This is because the concatenation of a sorted pair of internal nodes in
17  * the merkle tree could be reinterpreted as a leaf value.
18  */
19 library MerkleProof {
20     /**
21      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
22      * defined by `root`. For this, a `proof` must be provided, containing
23      * sibling hashes on the branch from the leaf to the root of the tree. Each
24      * pair of leaves and each pair of pre-images are assumed to be sorted.
25      */
26     function verify(
27         bytes32[] memory proof,
28         bytes32 root,
29         bytes32 leaf
30     ) internal pure returns (bool) {
31         return processProof(proof, leaf) == root;
32     }
33 
34     /**
35      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
36      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
37      * hash matches the root of the tree. When processing the proof, the pairs
38      * of leafs & pre-images are assumed to be sorted.
39      *
40      * _Available since v4.4._
41      */
42     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
43         bytes32 computedHash = leaf;
44         for (uint256 i = 0; i < proof.length; i++) {
45             bytes32 proofElement = proof[i];
46             if (computedHash <= proofElement) {
47                 // Hash(current computed hash + current element of the proof)
48                 computedHash = _efficientHash(computedHash, proofElement);
49             } else {
50                 // Hash(current element of the proof + current computed hash)
51                 computedHash = _efficientHash(proofElement, computedHash);
52             }
53         }
54         return computedHash;
55     }
56 
57     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
58         assembly {
59             mstore(0x00, a)
60             mstore(0x20, b)
61             value := keccak256(0x00, 0x40)
62         }
63     }
64 }
65 
66 pragma solidity ^0.8.0; 
67 
68 abstract contract ReentrancyGuard { 
69     uint256 private constant _NOT_ENTERED = 1;
70     uint256 private constant _ENTERED = 2;
71 
72     uint256 private _status;
73 
74     constructor() {
75         _status = _NOT_ENTERED;
76     }
77     modifier nonReentrant() {
78         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
79    _status = _ENTERED;
80 
81         _;
82         _status = _NOT_ENTERED;
83     }
84 }
85 
86 library Strings {
87     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
88  
89     function toString(uint256 value) internal pure returns (string memory) { 
90         if (value == 0) {
91             return "0";
92         }
93         uint256 temp = value;
94         uint256 digits;
95         while (temp != 0) {
96             digits++;
97             temp /= 10;
98         }
99         bytes memory buffer = new bytes(digits);
100         while (value != 0) {
101             digits -= 1;
102             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
103             value /= 10;
104         }
105         return string(buffer);
106     }
107  
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
121     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
122         bytes memory buffer = new bytes(2 * length + 2);
123         buffer[0] = "0";
124         buffer[1] = "x";
125         for (uint256 i = 2 * length + 1; i > 1; --i) {
126             buffer[i] = _HEX_SYMBOLS[value & 0xf];
127             value >>= 4;
128         }
129         require(value == 0, "Strings: hex length insufficient");
130         return string(buffer);
131     }
132 }
133  
134 abstract contract Context {
135     function _msgSender() internal view virtual returns (address) {
136         return msg.sender;
137     }
138 
139     function _msgData() internal view virtual returns (bytes calldata) {
140         return msg.data;
141     }
142 }
143  
144 abstract contract Ownable is Context {
145     address private _owner;
146 
147     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
148  
149     constructor() {
150         _transferOwnership(_msgSender());
151     }
152  
153     function owner() public view virtual returns (address) {
154         return _owner;
155     } 
156     modifier onlyOwner() {
157         require(owner() == _msgSender(), "Ownable: caller is not the owner");
158         _;
159     }
160  
161     function renounceOwnership() public virtual onlyOwner {
162         _transferOwnership(address(0));
163     }
164  
165     function transferOwnership(address newOwner) public virtual onlyOwner {
166         require(newOwner != address(0), "Ownable: new owner is the zero address");
167         _transferOwnership(newOwner);
168     }
169  
170     function _transferOwnership(address newOwner) internal virtual {
171         address oldOwner = _owner;
172         _owner = newOwner;
173         emit OwnershipTransferred(oldOwner, newOwner);
174     }
175 }
176  
177 library Address { 
178     function isContract(address account) internal view returns (bool) { 
179         uint256 size;
180         assembly {
181             size := extcodesize(account)
182         }
183         return size > 0;
184     } 
185     function sendValue(address payable recipient, uint256 amount) internal {
186         require(address(this).balance >= amount, "Address: insufficient balance");
187 
188         (bool success, ) = recipient.call{value: amount}("");
189         require(success, "Address: unable to send value, recipient may have reverted");
190     }
191  
192     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
193         return functionCall(target, data, "Address: low-level call failed");
194     } 
195     function functionCall(
196         address target,
197         bytes memory data,
198         string memory errorMessage
199     ) internal returns (bytes memory) {
200         return functionCallWithValue(target, data, 0, errorMessage);
201     }
202  
203     function functionCallWithValue(
204         address target,
205         bytes memory data,
206         uint256 value
207     ) internal returns (bytes memory) {
208         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
209     }
210  
211     function functionCallWithValue(
212         address target,
213         bytes memory data,
214         uint256 value,
215         string memory errorMessage
216     ) internal returns (bytes memory) {
217         require(address(this).balance >= value, "Address: insufficient balance for call");
218         require(isContract(target), "Address: call to non-contract");
219 
220         (bool success, bytes memory returndata) = target.call{value: value}(data);
221         return verifyCallResult(success, returndata, errorMessage);
222     } 
223     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
224         return functionStaticCall(target, data, "Address: low-level static call failed");
225     }
226  
227     function functionStaticCall(
228         address target,
229         bytes memory data,
230         string memory errorMessage
231     ) internal view returns (bytes memory) {
232         require(isContract(target), "Address: static call to non-contract");
233 
234         (bool success, bytes memory returndata) = target.staticcall(data);
235         return verifyCallResult(success, returndata, errorMessage);
236     }
237  
238     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
239         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
240     }
241  
242     function functionDelegateCall(
243         address target,
244         bytes memory data,
245         string memory errorMessage
246     ) internal returns (bytes memory) {
247         require(isContract(target), "Address: delegate call to non-contract");
248 
249         (bool success, bytes memory returndata) = target.delegatecall(data);
250         return verifyCallResult(success, returndata, errorMessage);
251     }
252  
253     function verifyCallResult(
254         bool success,
255         bytes memory returndata,
256         string memory errorMessage
257     ) internal pure returns (bytes memory) {
258         if (success) {
259             return returndata;
260         } else { 
261             if (returndata.length > 0) { 
262 
263                 assembly {
264                     let returndata_size := mload(returndata)
265                     revert(add(32, returndata), returndata_size)
266                 }
267             } else {
268                 revert(errorMessage);
269             }
270         }
271     }
272 }
273  
274 interface IERC721Receiver { 
275     function onERC721Received(
276         address operator,
277         address from,
278         uint256 tokenId,
279         bytes calldata data
280     ) external returns (bytes4);
281 }
282  
283 interface IERC165 { 
284     function supportsInterface(bytes4 interfaceId) external view returns (bool);
285 }
286  
287 abstract contract ERC165 is IERC165 { 
288     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
289         return interfaceId == type(IERC165).interfaceId;
290     }
291 } 
292 interface IERC721 is IERC165 { 
293     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId); 
294     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId); 
295     event ApprovalForAll(address indexed owner, address indexed operator, bool approved); 
296     function balanceOf(address owner) external view returns (uint256 balance); 
297     function ownerOf(uint256 tokenId) external view returns (address owner); 
298     function safeTransferFrom(
299         address from,
300         address to,
301         uint256 tokenId
302     ) external; 
303     function transferFrom(
304         address from,
305         address to,
306         uint256 tokenId
307     ) external; 
308     function approve(address to, uint256 tokenId) external;
309  
310     function getApproved(uint256 tokenId) external view returns (address operator); 
311     function setApprovalForAll(address operator, bool _approved) external; 
312     function isApprovedForAll(address owner, address operator) external view returns (bool); 
313     function safeTransferFrom(
314         address from,
315         address to,
316         uint256 tokenId,
317         bytes calldata data
318     ) external;
319 } 
320 interface IERC721Enumerable is IERC721 { 
321     function totalSupply() external view returns (uint256); 
322     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId); 
323     function tokenByIndex(uint256 index) external view returns (uint256);
324 }  
325 interface IERC721Metadata is IERC721 { 
326     function name() external view returns (string memory); 
327     function symbol() external view returns (string memory); 
328     function tokenURI(uint256 tokenId) external view returns (string memory);
329 }
330 
331 error ApprovalCallerNotOwnerNorApproved();
332 error ApprovalQueryForNonexistentToken();
333 error ApproveToCaller();
334 error ApprovalToCurrentOwner();
335 error BalanceQueryForZeroAddress();
336 error MintToZeroAddress();
337 error MintZeroQuantity();
338 error OwnerQueryForNonexistentToken();
339 error TransferCallerNotOwnerNorApproved();
340 error TransferFromIncorrectOwner();
341 error TransferToNonERC721ReceiverImplementer();
342 error TransferToZeroAddress();
343 error URIQueryForNonexistentToken();
344 
345 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
346     using Address for address;
347     using Strings for uint256;
348 
349     // Compiler will pack this into a single 256bit word.
350     struct TokenOwnership {
351         // The address of the owner.
352         address addr;
353         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
354         uint64 startTimestamp;
355         // Whether the token has been burned.
356         bool burned;
357     }
358 
359     // Compiler will pack this into a single 256bit word.
360     struct AddressData {
361         // Realistically, 2**64-1 is more than enough.
362         uint64 balance;
363         // Keeps track of mint count with minimal overhead for tokenomics.
364         uint64 numberMinted;
365         // Keeps track of burn count with minimal overhead for tokenomics.
366         uint64 numberBurned;
367         // For miscellaneous variable(s) pertaining to the address
368         // (e.g. number of whitelist mint slots used).
369         // If there are multiple variables, please pack them into a uint64.
370         uint64 aux;
371     }
372 
373     // The tokenId of the next token to be minted.
374     uint256 internal _currentIndex;
375 
376     // The number of tokens burned.
377     uint256 internal _burnCounter;
378 
379     // Token name
380     string private _name;
381 
382     // Token symbol
383     string private _symbol;
384 
385     // Mapping from token ID to ownership details
386     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
387     mapping(uint256 => TokenOwnership) internal _ownerships;
388 
389     // Mapping owner address to address data
390     mapping(address => AddressData) private _addressData;
391 
392     // Mapping from token ID to approved address
393     mapping(uint256 => address) private _tokenApprovals;
394 
395     // Mapping from owner to operator approvals
396     mapping(address => mapping(address => bool)) private _operatorApprovals;
397 
398     constructor(string memory name_, string memory symbol_) {
399         _name = name_;
400         _symbol = symbol_;
401         _currentIndex = _startTokenId();
402     }
403 
404     /**
405      * To change the starting tokenId, please override this function.
406      */
407     function _startTokenId() internal view virtual returns (uint256) {
408         return 1;
409     }
410 
411     /**
412      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
413      */
414     function totalSupply() public view returns (uint256) {
415         // Counter underflow is impossible as _burnCounter cannot be incremented
416         // more than _currentIndex - _startTokenId() times
417         unchecked {
418             return _currentIndex - _burnCounter - _startTokenId();
419         }
420     }
421 
422     /**
423      * Returns the total amount of tokens minted in the contract.
424      */
425     function _totalMinted() internal view returns (uint256) {
426         // Counter underflow is impossible as _currentIndex does not decrement,
427         // and it is initialized to _startTokenId()
428         unchecked {
429             return _currentIndex - _startTokenId();
430         }
431     }
432 
433     /**
434      * @dev See {IERC165-supportsInterface}.
435      */
436     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
437         return
438             interfaceId == type(IERC721).interfaceId ||
439             interfaceId == type(IERC721Metadata).interfaceId ||
440             super.supportsInterface(interfaceId);
441     }
442 
443     /**
444      * @dev See {IERC721-balanceOf}.
445      */
446     function balanceOf(address owner) public view override returns (uint256) {
447         if (owner == address(0)) revert BalanceQueryForZeroAddress();
448         return uint256(_addressData[owner].balance);
449     }
450 
451     /**
452      * Returns the number of tokens minted by `owner`.
453      */
454     function _numberMinted(address owner) internal view returns (uint256) {
455         return uint256(_addressData[owner].numberMinted);
456     }
457 
458     /**
459      * Returns the number of tokens burned by or on behalf of `owner`.
460      */
461     function _numberBurned(address owner) internal view returns (uint256) {
462         return uint256(_addressData[owner].numberBurned);
463     }
464 
465     /**
466      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
467      */
468     function _getAux(address owner) internal view returns (uint64) {
469         return _addressData[owner].aux;
470     }
471 
472     /**
473      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
474      * If there are multiple variables, please pack them into a uint64.
475      */
476     function _setAux(address owner, uint64 aux) internal {
477         _addressData[owner].aux = aux;
478     }
479 
480     /**
481      * Gas spent here starts off proportional to the maximum mint batch size.
482      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
483      */
484     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
485         uint256 curr = tokenId;
486 
487         unchecked {
488             if (_startTokenId() <= curr && curr < _currentIndex) {
489                 TokenOwnership memory ownership = _ownerships[curr];
490                 if (!ownership.burned) {
491                     if (ownership.addr != address(0)) {
492                         return ownership;
493                     }
494                     // Invariant:
495                     // There will always be an ownership that has an address and is not burned
496                     // before an ownership that does not have an address and is not burned.
497                     // Hence, curr will not underflow.
498                     while (true) {
499                         curr--;
500                         ownership = _ownerships[curr];
501                         if (ownership.addr != address(0)) {
502                             return ownership;
503                         }
504                     }
505                 }
506             }
507         }
508         revert OwnerQueryForNonexistentToken();
509     }
510 
511     /**
512      * @dev See {IERC721-ownerOf}.
513      */
514     function ownerOf(uint256 tokenId) public view override returns (address) {
515         return _ownershipOf(tokenId).addr;
516     }
517 
518     /**
519      * @dev See {IERC721Metadata-name}.
520      */
521     function name() public view virtual override returns (string memory) {
522         return _name;
523     }
524 
525     /**
526      * @dev See {IERC721Metadata-symbol}.
527      */
528     function symbol() public view virtual override returns (string memory) {
529         return _symbol;
530     }
531 
532     /**
533      * @dev See {IERC721Metadata-tokenURI}.
534      */
535     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
536         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
537 
538         string memory baseURI = _baseURI();
539         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
540     }
541 
542     /**
543      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
544      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
545      * by default, can be overriden in child contracts.
546      */
547     function _baseURI() internal view virtual returns (string memory) {
548         return '';
549     }
550 
551     /**
552      * @dev See {IERC721-approve}.
553      */
554     function approve(address to, uint256 tokenId) public override {
555         address owner = ERC721A.ownerOf(tokenId);
556         if (to == owner) revert ApprovalToCurrentOwner();
557 
558         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
559             revert ApprovalCallerNotOwnerNorApproved();
560         }
561 
562         _approve(to, tokenId, owner);
563     }
564 
565     /**
566      * @dev See {IERC721-getApproved}.
567      */
568     function getApproved(uint256 tokenId) public view override returns (address) {
569         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
570 
571         return _tokenApprovals[tokenId];
572     }
573 
574     /**
575      * @dev See {IERC721-setApprovalForAll}.
576      */
577     function setApprovalForAll(address operator, bool approved) public virtual override {
578         if (operator == _msgSender()) revert ApproveToCaller();
579 
580         _operatorApprovals[_msgSender()][operator] = approved;
581         emit ApprovalForAll(_msgSender(), operator, approved);
582     }
583 
584     /**
585      * @dev See {IERC721-isApprovedForAll}.
586      */
587     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
588         return _operatorApprovals[owner][operator];
589     }
590 
591     /**
592      * @dev See {IERC721-transferFrom}.
593      */
594     function transferFrom(
595         address from,
596         address to,
597         uint256 tokenId
598     ) public virtual override {
599         _transfer(from, to, tokenId);
600     }
601 
602     /**
603      * @dev See {IERC721-safeTransferFrom}.
604      */
605     function safeTransferFrom(
606         address from,
607         address to,
608         uint256 tokenId
609     ) public virtual override {
610         safeTransferFrom(from, to, tokenId, '');
611     }
612 
613     /**
614      * @dev See {IERC721-safeTransferFrom}.
615      */
616     function safeTransferFrom(
617         address from,
618         address to,
619         uint256 tokenId,
620         bytes memory _data
621     ) public virtual override {
622         _transfer(from, to, tokenId);
623         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
624             revert TransferToNonERC721ReceiverImplementer();
625         }
626     }
627 
628     /**
629      * @dev Returns whether `tokenId` exists.
630      *
631      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
632      *
633      * Tokens start existing when they are minted (`_mint`),
634      */
635     function _exists(uint256 tokenId) internal view returns (bool) {
636         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
637     }
638 
639     function _safeMint(address to, uint256 quantity) internal {
640         _safeMint(to, quantity, '');
641     }
642 
643     /**
644      * @dev Safely mints `quantity` tokens and transfers them to `to`.
645      *
646      * Requirements:
647      *
648      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
649      * - `quantity` must be greater than 0.
650      *
651      * Emits a {Transfer} event.
652      */
653     function _safeMint(
654         address to,
655         uint256 quantity,
656         bytes memory _data
657     ) internal {
658         _mint(to, quantity, _data, true);
659     }
660 
661     /**
662      * @dev Mints `quantity` tokens and transfers them to `to`.
663      *
664      * Requirements:
665      *
666      * - `to` cannot be the zero address.
667      * - `quantity` must be greater than 0.
668      *
669      * Emits a {Transfer} event.
670      */
671     function _mint(
672         address to,
673         uint256 quantity,
674         bytes memory _data,
675         bool safe
676     ) internal {
677         uint256 startTokenId = _currentIndex;
678         if (to == address(0)) revert MintToZeroAddress();
679         if (quantity == 0) revert MintZeroQuantity();
680 
681         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
682 
683         // Overflows are incredibly unrealistic.
684         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
685         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
686         unchecked {
687             _addressData[to].balance += uint64(quantity);
688             _addressData[to].numberMinted += uint64(quantity);
689 
690             _ownerships[startTokenId].addr = to;
691             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
692 
693             uint256 updatedIndex = startTokenId;
694             uint256 end = updatedIndex + quantity;
695 
696             if (safe && to.isContract()) {
697                 do {
698                     emit Transfer(address(0), to, updatedIndex);
699                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
700                         revert TransferToNonERC721ReceiverImplementer();
701                     }
702                 } while (updatedIndex != end);
703                 // Reentrancy protection
704                 if (_currentIndex != startTokenId) revert();
705             } else {
706                 do {
707                     emit Transfer(address(0), to, updatedIndex++);
708                 } while (updatedIndex != end);
709             }
710             _currentIndex = updatedIndex;
711         }
712         _afterTokenTransfers(address(0), to, startTokenId, quantity);
713     }
714 
715     /**
716      * @dev Transfers `tokenId` from `from` to `to`.
717      *
718      * Requirements:
719      *
720      * - `to` cannot be the zero address.
721      * - `tokenId` token must be owned by `from`.
722      *
723      * Emits a {Transfer} event.
724      */
725     function _transfer(
726         address from,
727         address to,
728         uint256 tokenId
729     ) private {
730         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
731 
732         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
733 
734         bool isApprovedOrOwner = (_msgSender() == from ||
735             isApprovedForAll(from, _msgSender()) ||
736             getApproved(tokenId) == _msgSender());
737 
738         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
739         if (to == address(0)) revert TransferToZeroAddress();
740 
741         _beforeTokenTransfers(from, to, tokenId, 1);
742 
743         // Clear approvals from the previous owner
744         _approve(address(0), tokenId, from);
745 
746         // Underflow of the sender's balance is impossible because we check for
747         // ownership above and the recipient's balance can't realistically overflow.
748         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
749         unchecked {
750             _addressData[from].balance -= 1;
751             _addressData[to].balance += 1;
752 
753             TokenOwnership storage currSlot = _ownerships[tokenId];
754             currSlot.addr = to;
755             currSlot.startTimestamp = uint64(block.timestamp);
756 
757             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
758             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
759             uint256 nextTokenId = tokenId + 1;
760             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
761             if (nextSlot.addr == address(0)) {
762                 // This will suffice for checking _exists(nextTokenId),
763                 // as a burned slot cannot contain the zero address.
764                 if (nextTokenId != _currentIndex) {
765                     nextSlot.addr = from;
766                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
767                 }
768             }
769         }
770 
771         emit Transfer(from, to, tokenId);
772         _afterTokenTransfers(from, to, tokenId, 1);
773     }
774 
775     /**
776      * @dev This is equivalent to _burn(tokenId, false)
777      */
778     function _burn(uint256 tokenId) internal virtual {
779         _burn(tokenId, false);
780     }
781 
782     /**
783      * @dev Destroys `tokenId`.
784      * The approval is cleared when the token is burned.
785      *
786      * Requirements:
787      *
788      * - `tokenId` must exist.
789      *
790      * Emits a {Transfer} event.
791      */
792     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
793         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
794 
795         address from = prevOwnership.addr;
796 
797         if (approvalCheck) {
798             bool isApprovedOrOwner = (_msgSender() == from ||
799                 isApprovedForAll(from, _msgSender()) ||
800                 getApproved(tokenId) == _msgSender());
801 
802             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
803         }
804 
805         _beforeTokenTransfers(from, address(0), tokenId, 1);
806 
807         // Clear approvals from the previous owner
808         _approve(address(0), tokenId, from);
809 
810         // Underflow of the sender's balance is impossible because we check for
811         // ownership above and the recipient's balance can't realistically overflow.
812         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
813         unchecked {
814             AddressData storage addressData = _addressData[from];
815             addressData.balance -= 1;
816             addressData.numberBurned += 1;
817 
818             // Keep track of who burned the token, and the timestamp of burning.
819             TokenOwnership storage currSlot = _ownerships[tokenId];
820             currSlot.addr = from;
821             currSlot.startTimestamp = uint64(block.timestamp);
822             currSlot.burned = true;
823 
824             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
825             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
826             uint256 nextTokenId = tokenId + 1;
827             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
828             if (nextSlot.addr == address(0)) {
829                 // This will suffice for checking _exists(nextTokenId),
830                 // as a burned slot cannot contain the zero address.
831                 if (nextTokenId != _currentIndex) {
832                     nextSlot.addr = from;
833                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
834                 }
835             }
836         }
837 
838         emit Transfer(from, address(0), tokenId);
839         _afterTokenTransfers(from, address(0), tokenId, 1);
840 
841         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
842         unchecked {
843             _burnCounter++;
844         }
845     }
846 
847     /**
848      * @dev Approve `to` to operate on `tokenId`
849      *
850      * Emits a {Approval} event.
851      */
852     function _approve(
853         address to,
854         uint256 tokenId,
855         address owner
856     ) private {
857         _tokenApprovals[tokenId] = to;
858         emit Approval(owner, to, tokenId);
859     }
860 
861     /**
862      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
863      *
864      * @param from address representing the previous owner of the given token ID
865      * @param to target address that will receive the tokens
866      * @param tokenId uint256 ID of the token to be transferred
867      * @param _data bytes optional data to send along with the call
868      * @return bool whether the call correctly returned the expected magic value
869      */
870     function _checkContractOnERC721Received(
871         address from,
872         address to,
873         uint256 tokenId,
874         bytes memory _data
875     ) private returns (bool) {
876         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
877             return retval == IERC721Receiver(to).onERC721Received.selector;
878         } catch (bytes memory reason) {
879             if (reason.length == 0) {
880                 revert TransferToNonERC721ReceiverImplementer();
881             } else {
882                 assembly {
883                     revert(add(32, reason), mload(reason))
884                 }
885             }
886         }
887     }
888 
889     /**
890      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
891      * And also called before burning one token.
892      *
893      * startTokenId - the first token id to be transferred
894      * quantity - the amount to be transferred
895      *
896      * Calling conditions:
897      *
898      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
899      * transferred to `to`.
900      * - When `from` is zero, `tokenId` will be minted for `to`.
901      * - When `to` is zero, `tokenId` will be burned by `from`.
902      * - `from` and `to` are never both zero.
903      */
904     function _beforeTokenTransfers(
905         address from,
906         address to,
907         uint256 startTokenId,
908         uint256 quantity
909     ) internal virtual {}
910 
911     /**
912      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
913      * minting.
914      * And also called after one token has been burned.
915      *
916      * startTokenId - the first token id to be transferred
917      * quantity - the amount to be transferred
918      *
919      * Calling conditions:
920      *
921      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
922      * transferred to `to`.
923      * - When `from` is zero, `tokenId` has been minted for `to`.
924      * - When `to` is zero, `tokenId` has been burned by `from`.
925      * - `from` and `to` are never both zero.
926      */
927     function _afterTokenTransfers(
928         address from,
929         address to,
930         uint256 startTokenId,
931         uint256 quantity
932     ) internal virtual {}
933 }
934 
935 contract BeaniezOfficial is Ownable, ERC721A, ReentrancyGuard {
936     using Strings for uint256;
937 
938 
939   uint256 public MAX_PER_Transaction = 3; // maximam amount that user can mint/Transaction
940 
941   mapping(address => uint256) public publicClaimedBy;
942 
943   uint256 public  PRICE = 0.03 ether; 
944 
945   uint256 private constant TotalCollectionSize_ = 3333; // total number of nfts
946   uint256 private constant MaxMintPerBatch_ = 20; //max mint per transaction
947 
948   string private _baseTokenURI;
949   uint public reserve = 0;
950 
951 
952   uint public status = 0; //0-pause 1-whitelist 2-public
953 
954   constructor() ERC721A("Beaniez Official","BO") {
955 
956   }
957 
958   modifier callerIsUser() {
959     require(tx.origin == msg.sender, "The caller is another contract");
960     _;
961   }
962  
963   function mint(uint256 quantity) external payable callerIsUser {
964     require(status == 2 , "Sale is not Active");
965     require(totalSupply() + quantity <= TotalCollectionSize_-reserve, "reached max supply");
966     require(quantity <= MAX_PER_Transaction,"can not mint this many");
967     require(msg.value >= PRICE * quantity, "Need to send more ETH.");
968 
969 
970     _safeMint(msg.sender, quantity);
971   }
972 
973    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
974     require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
975     string memory baseURI = _baseURI();
976     return
977       bytes(baseURI).length > 0
978         ? string(abi.encodePacked(baseURI, "/", tokenId.toString(), ".json")) : "";
979   }
980 
981   function setBaseURI(string memory baseURI) external onlyOwner {
982     _baseTokenURI = baseURI;
983   }
984   function _baseURI() internal view virtual override returns (string memory) {
985     return _baseTokenURI;
986   }
987 
988   function numberMinted(address owner) public view returns (uint256) {
989     return _numberMinted(owner);
990   }
991   function getOwnershipData(uint256 tokenId)
992     external
993     view
994     returns (TokenOwnership memory)
995   {
996     return _ownershipOf(tokenId);
997   }
998 
999   function withdrawMoney() external onlyOwner nonReentrant {
1000     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1001     require(success, "Transfer failed.");
1002   }
1003 
1004   function changeMintPrice(uint256 _newPrice) external onlyOwner
1005   {
1006       PRICE = _newPrice;
1007   }
1008 
1009   function changeMAX_PER_Transaction(uint256 q) external onlyOwner
1010   {
1011       MAX_PER_Transaction = q;
1012   }
1013 
1014   function setStatus(uint256 s)external onlyOwner{
1015       status = s;
1016   }
1017 
1018    function getStatus()public view returns(uint){
1019       return status;
1020   }
1021 
1022  function setReserveTokens(uint256 _quantity) public onlyOwner {
1023         reserve=_quantity;
1024     }
1025     
1026   function getPrice(uint256 _quantity) public view returns (uint256) {
1027        
1028         return _quantity*PRICE;
1029     }
1030 
1031  function mintReserveTokens(uint quantity) public onlyOwner {
1032         require(quantity <= reserve, "The quantity exceeds the reserve.");
1033         reserve -= quantity;
1034         _safeMint(msg.sender, quantity);
1035 
1036     }
1037 
1038   function airdrop(address sendTo, uint quantity)public onlyOwner{
1039     require(totalSupply() + quantity <= TotalCollectionSize_, "reached max supply");
1040     _safeMint(sendTo, quantity);
1041   }
1042 
1043 
1044     //    WhiteList CODE STARTS    //
1045 
1046     uint256 public MAX_PER_WL_TRANSACTION = 3; // maximam amount that user can mint/Wallet
1047     bytes32 public whitelistMerkleRoot;
1048     uint256 public itemPriceWhiteList = 0.03 ether;
1049     mapping(address => uint256) public whiteListClaimedBy;
1050     uint256 private TotalWLavailable = 3333; // total number of nfts
1051 
1052 
1053     function setWhitelistMerkleRoot(bytes32 _whitelistMerkleRoot) external onlyOwner {
1054         whitelistMerkleRoot = _whitelistMerkleRoot;
1055     }
1056 
1057     function getWhitelistPrice(uint256 _quantity) public view returns (uint256) {
1058        
1059            return _quantity*itemPriceWhiteList;
1060     }
1061 
1062     function inWhitelist(bytes32[] memory _proof, address _owner) public view returns (bool) {
1063         return MerkleProof.verify(_proof, whitelistMerkleRoot, keccak256(abi.encodePacked(_owner)));
1064     }
1065 
1066 
1067     function purchaseWhiteListTokens(uint256 _howMany, bytes32[] calldata _proof) external payable {
1068         require(status == 1 , "Sale is not active ");
1069         require(totalSupply()+_howMany<=TotalWLavailable,"Quantity must be lesser then MaxSupply");
1070         require(inWhitelist(_proof, msg.sender), "You are not in presale");
1071         require(msg.value >= _howMany * itemPriceWhiteList, "Try to send more ETH");
1072         require(_howMany <= MAX_PER_WL_TRANSACTION , "can not mint this many");
1073 
1074         _safeMint(msg.sender, _howMany);
1075 
1076     }
1077 
1078      function setWLavailable(uint256 _whiteListCollection) external onlyOwner {
1079         TotalWLavailable = _whiteListCollection;
1080     }
1081 
1082     function setPriceWhiteList(uint256 _itemPriceWhiteList) external onlyOwner {
1083         itemPriceWhiteList = _itemPriceWhiteList;
1084     }
1085 
1086     function changeMAX_PER_WL_TRANSACTION(uint256 q) external onlyOwner
1087   {
1088       MAX_PER_WL_TRANSACTION = q;
1089   }
1090 }