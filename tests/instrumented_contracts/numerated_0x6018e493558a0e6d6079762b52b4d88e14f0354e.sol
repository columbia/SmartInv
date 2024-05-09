1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-04
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev These functions deal with verification of Merkle Trees proofs.
11  *
12  * The proofs can be generated using the JavaScript library
13  * https://github.com/miguelmota/merkletreejs[merkletreejs].
14  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
15  *
16  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
17  *
18  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
19  * hashing, or use a hash function other than keccak256 for hashing leaves.
20  * This is because the concatenation of a sorted pair of internal nodes in
21  * the merkle tree could be reinterpreted as a leaf value.
22  */
23 library MerkleProof {
24     /**
25      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
26      * defined by `root`. For this, a `proof` must be provided, containing
27      * sibling hashes on the branch from the leaf to the root of the tree. Each
28      * pair of leaves and each pair of pre-images are assumed to be sorted.
29      */
30     function verify(
31         bytes32[] memory proof,
32         bytes32 root,
33         bytes32 leaf
34     ) internal pure returns (bool) {
35         return processProof(proof, leaf) == root;
36     }
37 
38     /**
39      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
40      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
41      * hash matches the root of the tree. When processing the proof, the pairs
42      * of leafs & pre-images are assumed to be sorted.
43      *
44      * _Available since v4.4._
45      */
46     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
47         bytes32 computedHash = leaf;
48         for (uint256 i = 0; i < proof.length; i++) {
49             bytes32 proofElement = proof[i];
50             if (computedHash <= proofElement) {
51                 // Hash(current computed hash + current element of the proof)
52                 computedHash = _efficientHash(computedHash, proofElement);
53             } else {
54                 // Hash(current element of the proof + current computed hash)
55                 computedHash = _efficientHash(proofElement, computedHash);
56             }
57         }
58         return computedHash;
59     }
60 
61     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
62         assembly {
63             mstore(0x00, a)
64             mstore(0x20, b)
65             value := keccak256(0x00, 0x40)
66         }
67     }
68 }
69 
70 pragma solidity ^0.8.0; 
71 
72 abstract contract ReentrancyGuard { 
73     uint256 private constant _NOT_ENTERED = 1;
74     uint256 private constant _ENTERED = 2;
75 
76     uint256 private _status;
77 
78     constructor() {
79         _status = _NOT_ENTERED;
80     }
81     modifier nonReentrant() {
82         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
83    _status = _ENTERED;
84 
85         _;
86         _status = _NOT_ENTERED;
87     }
88 }
89 
90 library Strings {
91     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
92  
93     function toString(uint256 value) internal pure returns (string memory) { 
94         if (value == 0) {
95             return "0";
96         }
97         uint256 temp = value;
98         uint256 digits;
99         while (temp != 0) {
100             digits++;
101             temp /= 10;
102         }
103         bytes memory buffer = new bytes(digits);
104         while (value != 0) {
105             digits -= 1;
106             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
107             value /= 10;
108         }
109         return string(buffer);
110     }
111  
112     function toHexString(uint256 value) internal pure returns (string memory) {
113         if (value == 0) {
114             return "0x00";
115         }
116         uint256 temp = value;
117         uint256 length = 0;
118         while (temp != 0) {
119             length++;
120             temp >>= 8;
121         }
122         return toHexString(value, length);
123     }
124  
125     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
126         bytes memory buffer = new bytes(2 * length + 2);
127         buffer[0] = "0";
128         buffer[1] = "x";
129         for (uint256 i = 2 * length + 1; i > 1; --i) {
130             buffer[i] = _HEX_SYMBOLS[value & 0xf];
131             value >>= 4;
132         }
133         require(value == 0, "Strings: hex length insufficient");
134         return string(buffer);
135     }
136 }
137  
138 abstract contract Context {
139     function _msgSender() internal view virtual returns (address) {
140         return msg.sender;
141     }
142 
143     function _msgData() internal view virtual returns (bytes calldata) {
144         return msg.data;
145     }
146 }
147  
148 abstract contract Ownable is Context {
149     address private _owner;
150 
151     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
152  
153     constructor() {
154         _transferOwnership(_msgSender());
155     }
156  
157     function owner() public view virtual returns (address) {
158         return _owner;
159     } 
160     modifier onlyOwner() {
161         require(owner() == _msgSender(), "Ownable: caller is not the owner");
162         _;
163     }
164  
165     function renounceOwnership() public virtual onlyOwner {
166         _transferOwnership(address(0));
167     }
168  
169     function transferOwnership(address newOwner) public virtual onlyOwner {
170         require(newOwner != address(0), "Ownable: new owner is the zero address");
171         _transferOwnership(newOwner);
172     }
173  
174     function _transferOwnership(address newOwner) internal virtual {
175         address oldOwner = _owner;
176         _owner = newOwner;
177         emit OwnershipTransferred(oldOwner, newOwner);
178     }
179 }
180  
181 library Address { 
182     function isContract(address account) internal view returns (bool) { 
183         uint256 size;
184         assembly {
185             size := extcodesize(account)
186         }
187         return size > 0;
188     } 
189     function sendValue(address payable recipient, uint256 amount) internal {
190         require(address(this).balance >= amount, "Address: insufficient balance");
191 
192         (bool success, ) = recipient.call{value: amount}("");
193         require(success, "Address: unable to send value, recipient may have reverted");
194     }
195  
196     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
197         return functionCall(target, data, "Address: low-level call failed");
198     } 
199     function functionCall(
200         address target,
201         bytes memory data,
202         string memory errorMessage
203     ) internal returns (bytes memory) {
204         return functionCallWithValue(target, data, 0, errorMessage);
205     }
206  
207     function functionCallWithValue(
208         address target,
209         bytes memory data,
210         uint256 value
211     ) internal returns (bytes memory) {
212         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
213     }
214  
215     function functionCallWithValue(
216         address target,
217         bytes memory data,
218         uint256 value,
219         string memory errorMessage
220     ) internal returns (bytes memory) {
221         require(address(this).balance >= value, "Address: insufficient balance for call");
222         require(isContract(target), "Address: call to non-contract");
223 
224         (bool success, bytes memory returndata) = target.call{value: value}(data);
225         return verifyCallResult(success, returndata, errorMessage);
226     } 
227     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
228         return functionStaticCall(target, data, "Address: low-level static call failed");
229     }
230  
231     function functionStaticCall(
232         address target,
233         bytes memory data,
234         string memory errorMessage
235     ) internal view returns (bytes memory) {
236         require(isContract(target), "Address: static call to non-contract");
237 
238         (bool success, bytes memory returndata) = target.staticcall(data);
239         return verifyCallResult(success, returndata, errorMessage);
240     }
241  
242     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
243         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
244     }
245  
246     function functionDelegateCall(
247         address target,
248         bytes memory data,
249         string memory errorMessage
250     ) internal returns (bytes memory) {
251         require(isContract(target), "Address: delegate call to non-contract");
252 
253         (bool success, bytes memory returndata) = target.delegatecall(data);
254         return verifyCallResult(success, returndata, errorMessage);
255     }
256  
257     function verifyCallResult(
258         bool success,
259         bytes memory returndata,
260         string memory errorMessage
261     ) internal pure returns (bytes memory) {
262         if (success) {
263             return returndata;
264         } else { 
265             if (returndata.length > 0) { 
266 
267                 assembly {
268                     let returndata_size := mload(returndata)
269                     revert(add(32, returndata), returndata_size)
270                 }
271             } else {
272                 revert(errorMessage);
273             }
274         }
275     }
276 }
277  
278 interface IERC721Receiver { 
279     function onERC721Received(
280         address operator,
281         address from,
282         uint256 tokenId,
283         bytes calldata data
284     ) external returns (bytes4);
285 }
286  
287 interface IERC165 { 
288     function supportsInterface(bytes4 interfaceId) external view returns (bool);
289 }
290  
291 abstract contract ERC165 is IERC165 { 
292     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
293         return interfaceId == type(IERC165).interfaceId;
294     }
295 } 
296 interface IERC721 is IERC165 { 
297     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId); 
298     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId); 
299     event ApprovalForAll(address indexed owner, address indexed operator, bool approved); 
300     function balanceOf(address owner) external view returns (uint256 balance); 
301     function ownerOf(uint256 tokenId) external view returns (address owner); 
302     function safeTransferFrom(
303         address from,
304         address to,
305         uint256 tokenId
306     ) external; 
307     function transferFrom(
308         address from,
309         address to,
310         uint256 tokenId
311     ) external; 
312     function approve(address to, uint256 tokenId) external;
313  
314     function getApproved(uint256 tokenId) external view returns (address operator); 
315     function setApprovalForAll(address operator, bool _approved) external; 
316     function isApprovedForAll(address owner, address operator) external view returns (bool); 
317     function safeTransferFrom(
318         address from,
319         address to,
320         uint256 tokenId,
321         bytes calldata data
322     ) external;
323 } 
324 interface IERC721Enumerable is IERC721 { 
325     function totalSupply() external view returns (uint256); 
326     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId); 
327     function tokenByIndex(uint256 index) external view returns (uint256);
328 }  
329 interface IERC721Metadata is IERC721 { 
330     function name() external view returns (string memory); 
331     function symbol() external view returns (string memory); 
332     function tokenURI(uint256 tokenId) external view returns (string memory);
333 }
334 
335 error ApprovalCallerNotOwnerNorApproved();
336 error ApprovalQueryForNonexistentToken();
337 error ApproveToCaller();
338 error ApprovalToCurrentOwner();
339 error BalanceQueryForZeroAddress();
340 error MintToZeroAddress();
341 error MintZeroQuantity();
342 error OwnerQueryForNonexistentToken();
343 error TransferCallerNotOwnerNorApproved();
344 error TransferFromIncorrectOwner();
345 error TransferToNonERC721ReceiverImplementer();
346 error TransferToZeroAddress();
347 error URIQueryForNonexistentToken();
348 
349 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
350     using Address for address;
351     using Strings for uint256;
352 
353     // Compiler will pack this into a single 256bit word.
354     struct TokenOwnership {
355         // The address of the owner.
356         address addr;
357         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
358         uint64 startTimestamp;
359         // Whether the token has been burned.
360         bool burned;
361     }
362 
363     // Compiler will pack this into a single 256bit word.
364     struct AddressData {
365         // Realistically, 2**64-1 is more than enough.
366         uint64 balance;
367         // Keeps track of mint count with minimal overhead for tokenomics.
368         uint64 numberMinted;
369         // Keeps track of burn count with minimal overhead for tokenomics.
370         uint64 numberBurned;
371         // For miscellaneous variable(s) pertaining to the address
372         // (e.g. number of whitelist mint slots used).
373         // If there are multiple variables, please pack them into a uint64.
374         uint64 aux;
375     }
376 
377     // The tokenId of the next token to be minted.
378     uint256 internal _currentIndex;
379 
380     // The number of tokens burned.
381     uint256 internal _burnCounter;
382 
383     // Token name
384     string private _name;
385 
386     // Token symbol
387     string private _symbol;
388 
389     // Mapping from token ID to ownership details
390     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
391     mapping(uint256 => TokenOwnership) internal _ownerships;
392 
393     // Mapping owner address to address data
394     mapping(address => AddressData) private _addressData;
395 
396     // Mapping from token ID to approved address
397     mapping(uint256 => address) private _tokenApprovals;
398 
399     // Mapping from owner to operator approvals
400     mapping(address => mapping(address => bool)) private _operatorApprovals;
401 
402     constructor(string memory name_, string memory symbol_) {
403         _name = name_;
404         _symbol = symbol_;
405         _currentIndex = _startTokenId();
406     }
407 
408     /**
409      * To change the starting tokenId, please override this function.
410      */
411     function _startTokenId() internal view virtual returns (uint256) {
412         return 1;
413     }
414 
415     /**
416      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
417      */
418     function totalSupply() public view returns (uint256) {
419         // Counter underflow is impossible as _burnCounter cannot be incremented
420         // more than _currentIndex - _startTokenId() times
421         unchecked {
422             return _currentIndex - _burnCounter - _startTokenId();
423         }
424     }
425 
426     /**
427      * Returns the total amount of tokens minted in the contract.
428      */
429     function _totalMinted() internal view returns (uint256) {
430         // Counter underflow is impossible as _currentIndex does not decrement,
431         // and it is initialized to _startTokenId()
432         unchecked {
433             return _currentIndex - _startTokenId();
434         }
435     }
436 
437     /**
438      * @dev See {IERC165-supportsInterface}.
439      */
440     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
441         return
442             interfaceId == type(IERC721).interfaceId ||
443             interfaceId == type(IERC721Metadata).interfaceId ||
444             super.supportsInterface(interfaceId);
445     }
446 
447     /**
448      * @dev See {IERC721-balanceOf}.
449      */
450     function balanceOf(address owner) public view override returns (uint256) {
451         if (owner == address(0)) revert BalanceQueryForZeroAddress();
452         return uint256(_addressData[owner].balance);
453     }
454 
455     /**
456      * Returns the number of tokens minted by `owner`.
457      */
458     function _numberMinted(address owner) internal view returns (uint256) {
459         return uint256(_addressData[owner].numberMinted);
460     }
461 
462     /**
463      * Returns the number of tokens burned by or on behalf of `owner`.
464      */
465     function _numberBurned(address owner) internal view returns (uint256) {
466         return uint256(_addressData[owner].numberBurned);
467     }
468 
469     /**
470      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
471      */
472     function _getAux(address owner) internal view returns (uint64) {
473         return _addressData[owner].aux;
474     }
475 
476     /**
477      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
478      * If there are multiple variables, please pack them into a uint64.
479      */
480     function _setAux(address owner, uint64 aux) internal {
481         _addressData[owner].aux = aux;
482     }
483 
484     /**
485      * Gas spent here starts off proportional to the maximum mint batch size.
486      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
487      */
488     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
489         uint256 curr = tokenId;
490 
491         unchecked {
492             if (_startTokenId() <= curr && curr < _currentIndex) {
493                 TokenOwnership memory ownership = _ownerships[curr];
494                 if (!ownership.burned) {
495                     if (ownership.addr != address(0)) {
496                         return ownership;
497                     }
498                     // Invariant:
499                     // There will always be an ownership that has an address and is not burned
500                     // before an ownership that does not have an address and is not burned.
501                     // Hence, curr will not underflow.
502                     while (true) {
503                         curr--;
504                         ownership = _ownerships[curr];
505                         if (ownership.addr != address(0)) {
506                             return ownership;
507                         }
508                     }
509                 }
510             }
511         }
512         revert OwnerQueryForNonexistentToken();
513     }
514 
515     /**
516      * @dev See {IERC721-ownerOf}.
517      */
518     function ownerOf(uint256 tokenId) public view override returns (address) {
519         return _ownershipOf(tokenId).addr;
520     }
521 
522     /**
523      * @dev See {IERC721Metadata-name}.
524      */
525     function name() public view virtual override returns (string memory) {
526         return _name;
527     }
528 
529     /**
530      * @dev See {IERC721Metadata-symbol}.
531      */
532     function symbol() public view virtual override returns (string memory) {
533         return _symbol;
534     }
535 
536     /**
537      * @dev See {IERC721Metadata-tokenURI}.
538      */
539     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
540         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
541 
542         string memory baseURI = _baseURI();
543         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
544     }
545 
546     /**
547      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
548      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
549      * by default, can be overriden in child contracts.
550      */
551     function _baseURI() internal view virtual returns (string memory) {
552         return '';
553     }
554 
555     /**
556      * @dev See {IERC721-approve}.
557      */
558     function approve(address to, uint256 tokenId) public override {
559         address owner = ERC721A.ownerOf(tokenId);
560         if (to == owner) revert ApprovalToCurrentOwner();
561 
562         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
563             revert ApprovalCallerNotOwnerNorApproved();
564         }
565 
566         _approve(to, tokenId, owner);
567     }
568 
569     /**
570      * @dev See {IERC721-getApproved}.
571      */
572     function getApproved(uint256 tokenId) public view override returns (address) {
573         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
574 
575         return _tokenApprovals[tokenId];
576     }
577 
578     /**
579      * @dev See {IERC721-setApprovalForAll}.
580      */
581     function setApprovalForAll(address operator, bool approved) public virtual override {
582         if (operator == _msgSender()) revert ApproveToCaller();
583 
584         _operatorApprovals[_msgSender()][operator] = approved;
585         emit ApprovalForAll(_msgSender(), operator, approved);
586     }
587 
588     /**
589      * @dev See {IERC721-isApprovedForAll}.
590      */
591     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
592         return _operatorApprovals[owner][operator];
593     }
594 
595     /**
596      * @dev See {IERC721-transferFrom}.
597      */
598     function transferFrom(
599         address from,
600         address to,
601         uint256 tokenId
602     ) public virtual override {
603         _transfer(from, to, tokenId);
604     }
605 
606     /**
607      * @dev See {IERC721-safeTransferFrom}.
608      */
609     function safeTransferFrom(
610         address from,
611         address to,
612         uint256 tokenId
613     ) public virtual override {
614         safeTransferFrom(from, to, tokenId, '');
615     }
616 
617     /**
618      * @dev See {IERC721-safeTransferFrom}.
619      */
620     function safeTransferFrom(
621         address from,
622         address to,
623         uint256 tokenId,
624         bytes memory _data
625     ) public virtual override {
626         _transfer(from, to, tokenId);
627         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
628             revert TransferToNonERC721ReceiverImplementer();
629         }
630     }
631 
632     /**
633      * @dev Returns whether `tokenId` exists.
634      *
635      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
636      *
637      * Tokens start existing when they are minted (`_mint`),
638      */
639     function _exists(uint256 tokenId) internal view returns (bool) {
640         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
641     }
642 
643     function _safeMint(address to, uint256 quantity) internal {
644         _safeMint(to, quantity, '');
645     }
646 
647     /**
648      * @dev Safely mints `quantity` tokens and transfers them to `to`.
649      *
650      * Requirements:
651      *
652      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
653      * - `quantity` must be greater than 0.
654      *
655      * Emits a {Transfer} event.
656      */
657     function _safeMint(
658         address to,
659         uint256 quantity,
660         bytes memory _data
661     ) internal {
662         _mint(to, quantity, _data, true);
663     }
664 
665     /**
666      * @dev Mints `quantity` tokens and transfers them to `to`.
667      *
668      * Requirements:
669      *
670      * - `to` cannot be the zero address.
671      * - `quantity` must be greater than 0.
672      *
673      * Emits a {Transfer} event.
674      */
675     function _mint(
676         address to,
677         uint256 quantity,
678         bytes memory _data,
679         bool safe
680     ) internal {
681         uint256 startTokenId = _currentIndex;
682         if (to == address(0)) revert MintToZeroAddress();
683         if (quantity == 0) revert MintZeroQuantity();
684 
685         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
686 
687         // Overflows are incredibly unrealistic.
688         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
689         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
690         unchecked {
691             _addressData[to].balance += uint64(quantity);
692             _addressData[to].numberMinted += uint64(quantity);
693 
694             _ownerships[startTokenId].addr = to;
695             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
696 
697             uint256 updatedIndex = startTokenId;
698             uint256 end = updatedIndex + quantity;
699 
700             if (safe && to.isContract()) {
701                 do {
702                     emit Transfer(address(0), to, updatedIndex);
703                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
704                         revert TransferToNonERC721ReceiverImplementer();
705                     }
706                 } while (updatedIndex != end);
707                 // Reentrancy protection
708                 if (_currentIndex != startTokenId) revert();
709             } else {
710                 do {
711                     emit Transfer(address(0), to, updatedIndex++);
712                 } while (updatedIndex != end);
713             }
714             _currentIndex = updatedIndex;
715         }
716         _afterTokenTransfers(address(0), to, startTokenId, quantity);
717     }
718 
719     /**
720      * @dev Transfers `tokenId` from `from` to `to`.
721      *
722      * Requirements:
723      *
724      * - `to` cannot be the zero address.
725      * - `tokenId` token must be owned by `from`.
726      *
727      * Emits a {Transfer} event.
728      */
729     function _transfer(
730         address from,
731         address to,
732         uint256 tokenId
733     ) private {
734         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
735 
736         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
737 
738         bool isApprovedOrOwner = (_msgSender() == from ||
739             isApprovedForAll(from, _msgSender()) ||
740             getApproved(tokenId) == _msgSender());
741 
742         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
743         if (to == address(0)) revert TransferToZeroAddress();
744 
745         _beforeTokenTransfers(from, to, tokenId, 1);
746 
747         // Clear approvals from the previous owner
748         _approve(address(0), tokenId, from);
749 
750         // Underflow of the sender's balance is impossible because we check for
751         // ownership above and the recipient's balance can't realistically overflow.
752         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
753         unchecked {
754             _addressData[from].balance -= 1;
755             _addressData[to].balance += 1;
756 
757             TokenOwnership storage currSlot = _ownerships[tokenId];
758             currSlot.addr = to;
759             currSlot.startTimestamp = uint64(block.timestamp);
760 
761             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
762             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
763             uint256 nextTokenId = tokenId + 1;
764             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
765             if (nextSlot.addr == address(0)) {
766                 // This will suffice for checking _exists(nextTokenId),
767                 // as a burned slot cannot contain the zero address.
768                 if (nextTokenId != _currentIndex) {
769                     nextSlot.addr = from;
770                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
771                 }
772             }
773         }
774 
775         emit Transfer(from, to, tokenId);
776         _afterTokenTransfers(from, to, tokenId, 1);
777     }
778 
779     /**
780      * @dev This is equivalent to _burn(tokenId, false)
781      */
782     function _burn(uint256 tokenId) internal virtual {
783         _burn(tokenId, false);
784     }
785 
786     /**
787      * @dev Destroys `tokenId`.
788      * The approval is cleared when the token is burned.
789      *
790      * Requirements:
791      *
792      * - `tokenId` must exist.
793      *
794      * Emits a {Transfer} event.
795      */
796     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
797         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
798 
799         address from = prevOwnership.addr;
800 
801         if (approvalCheck) {
802             bool isApprovedOrOwner = (_msgSender() == from ||
803                 isApprovedForAll(from, _msgSender()) ||
804                 getApproved(tokenId) == _msgSender());
805 
806             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
807         }
808 
809         _beforeTokenTransfers(from, address(0), tokenId, 1);
810 
811         // Clear approvals from the previous owner
812         _approve(address(0), tokenId, from);
813 
814         // Underflow of the sender's balance is impossible because we check for
815         // ownership above and the recipient's balance can't realistically overflow.
816         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
817         unchecked {
818             AddressData storage addressData = _addressData[from];
819             addressData.balance -= 1;
820             addressData.numberBurned += 1;
821 
822             // Keep track of who burned the token, and the timestamp of burning.
823             TokenOwnership storage currSlot = _ownerships[tokenId];
824             currSlot.addr = from;
825             currSlot.startTimestamp = uint64(block.timestamp);
826             currSlot.burned = true;
827 
828             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
829             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
830             uint256 nextTokenId = tokenId + 1;
831             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
832             if (nextSlot.addr == address(0)) {
833                 // This will suffice for checking _exists(nextTokenId),
834                 // as a burned slot cannot contain the zero address.
835                 if (nextTokenId != _currentIndex) {
836                     nextSlot.addr = from;
837                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
838                 }
839             }
840         }
841 
842         emit Transfer(from, address(0), tokenId);
843         _afterTokenTransfers(from, address(0), tokenId, 1);
844 
845         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
846         unchecked {
847             _burnCounter++;
848         }
849     }
850 
851     /**
852      * @dev Approve `to` to operate on `tokenId`
853      *
854      * Emits a {Approval} event.
855      */
856     function _approve(
857         address to,
858         uint256 tokenId,
859         address owner
860     ) private {
861         _tokenApprovals[tokenId] = to;
862         emit Approval(owner, to, tokenId);
863     }
864 
865     /**
866      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
867      *
868      * @param from address representing the previous owner of the given token ID
869      * @param to target address that will receive the tokens
870      * @param tokenId uint256 ID of the token to be transferred
871      * @param _data bytes optional data to send along with the call
872      * @return bool whether the call correctly returned the expected magic value
873      */
874     function _checkContractOnERC721Received(
875         address from,
876         address to,
877         uint256 tokenId,
878         bytes memory _data
879     ) private returns (bool) {
880         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
881             return retval == IERC721Receiver(to).onERC721Received.selector;
882         } catch (bytes memory reason) {
883             if (reason.length == 0) {
884                 revert TransferToNonERC721ReceiverImplementer();
885             } else {
886                 assembly {
887                     revert(add(32, reason), mload(reason))
888                 }
889             }
890         }
891     }
892 
893     /**
894      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
895      * And also called before burning one token.
896      *
897      * startTokenId - the first token id to be transferred
898      * quantity - the amount to be transferred
899      *
900      * Calling conditions:
901      *
902      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
903      * transferred to `to`.
904      * - When `from` is zero, `tokenId` will be minted for `to`.
905      * - When `to` is zero, `tokenId` will be burned by `from`.
906      * - `from` and `to` are never both zero.
907      */
908     function _beforeTokenTransfers(
909         address from,
910         address to,
911         uint256 startTokenId,
912         uint256 quantity
913     ) internal virtual {}
914 
915     /**
916      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
917      * minting.
918      * And also called after one token has been burned.
919      *
920      * startTokenId - the first token id to be transferred
921      * quantity - the amount to be transferred
922      *
923      * Calling conditions:
924      *
925      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
926      * transferred to `to`.
927      * - When `from` is zero, `tokenId` has been minted for `to`.
928      * - When `to` is zero, `tokenId` has been burned by `from`.
929      * - `from` and `to` are never both zero.
930      */
931     function _afterTokenTransfers(
932         address from,
933         address to,
934         uint256 startTokenId,
935         uint256 quantity
936     ) internal virtual {}
937 }
938 
939 contract HauntedZone is Ownable, ERC721A, ReentrancyGuard {
940     using Strings for uint256;
941 
942 
943     uint256 public MAX_PER_Transaction = 1;
944     uint256 public MAX_PER_WALLET = 1; 
945 
946     mapping(address => uint256) public publicClaimedBy;
947 
948     uint256 public  PRICE = 0 ether; 
949 
950     uint256 public maxSupply = 1500; 
951 
952 
953     string private _baseTokenURI;
954 
955 
956 
957     bool public status = false; 
958 
959     constructor() ERC721A("hauntedzone","HauntedZone") {
960 
961     }
962 
963     modifier noContract() {
964         require(tx.origin == msg.sender, "The caller is another contract");
965         _;
966     }
967     
968     function mint(uint256 quantity) external payable noContract {
969         require(status == true , "Sale is not Active");
970         require(totalSupply() + quantity <= maxSupply, "reached max supply");
971         require(quantity <= MAX_PER_Transaction,"exceeds the max mint quantity");
972         require(msg.value >= PRICE * quantity, "value less than.");
973         publicClaimedBy[msg.sender] += quantity;
974         require(publicClaimedBy[msg.sender] <= MAX_PER_WALLET, "Purchase exceeds max allowed");
975         _safeMint(msg.sender, quantity);
976     }
977 
978     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
979         require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
980         string memory baseURI = _baseURI();
981         return
982         bytes(baseURI).length > 0
983             ? string(abi.encodePacked(baseURI, "/", tokenId.toString(), ".json")) : "";
984     }
985 
986     function setBaseURI(string memory baseURI) external onlyOwner {
987         _baseTokenURI = baseURI;
988     }
989     function _baseURI() internal view virtual override returns (string memory) {
990         return _baseTokenURI;
991     }
992 
993     function numberMinted(address owner) public view returns (uint256) {
994         return _numberMinted(owner);
995     }
996     function getOwnershipData(uint256 tokenId)
997         external
998         view
999         returns (TokenOwnership memory)
1000     {
1001         return _ownershipOf(tokenId);
1002     }
1003 
1004     function withdraw() external onlyOwner nonReentrant {
1005         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1006         require(success, "Transfer failed.");
1007     }
1008 
1009     function getMintPrice(uint256 _newPrice) external onlyOwner
1010     {
1011         PRICE = _newPrice;
1012     }
1013 
1014     function getMAX_PER_WALLET(uint256 q) external onlyOwner
1015     {
1016         MAX_PER_WALLET = q;
1017     }
1018 
1019     function getMAX_PER_Transaction(uint256 q) external onlyOwner
1020     {
1021         MAX_PER_Transaction = q;
1022     }
1023 
1024     function setStatus(bool _status)external onlyOwner{
1025         status = _status;
1026     }
1027 
1028     function getStatus()public view returns(bool){
1029         return status;
1030     }
1031 
1032 
1033         
1034     function getPrice(uint256 _quantity) public view returns (uint256) {
1035         
1036             return _quantity*PRICE;
1037         
1038     }
1039     
1040 
1041 
1042     function divMint(address sendTo, uint quantity)public onlyOwner{
1043         require(totalSupply() + quantity <= maxSupply, "reached max supply");
1044         _safeMint(sendTo, quantity);
1045     }
1046 }