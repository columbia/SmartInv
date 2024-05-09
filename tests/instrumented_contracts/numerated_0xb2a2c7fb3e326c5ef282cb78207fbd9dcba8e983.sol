1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-21
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-05-19
7 */
8 
9 /**
10  *Submitted for verification at polygonscan.com on 2022-04-12
11 */
12 
13 /**
14  *Submitted for verification at polygonscan.com on 2022-04-08
15 */
16 
17 // SPDX-License-Identifier: MIT
18 pragma solidity ^0.8.7; 
19 library MerkleProof {
20     function verify(
21         bytes32[] memory proof,
22         bytes32 root,
23         bytes32 leaf
24     ) internal pure returns (bool) {
25         return processProof(proof, leaf) == root;
26     }
27    function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
28         bytes32 computedHash = leaf;
29         for (uint256 i = 0; i < proof.length; i++) {
30             bytes32 proofElement = proof[i];
31             if (computedHash <= proofElement) {
32                 computedHash = _efficientHash(computedHash, proofElement);
33             } else {
34                 computedHash = _efficientHash(proofElement, computedHash);
35             }
36         }
37         return computedHash;
38     }
39 
40     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
41         assembly {
42             mstore(0x00, a)
43             mstore(0x20, b)
44             value := keccak256(0x00, 0x40)
45         }
46     }
47 }
48 abstract contract ReentrancyGuard { 
49     uint256 private constant _NOT_ENTERED = 1;
50     uint256 private constant _ENTERED = 2;
51 
52     uint256 private _status;
53 
54     constructor() {
55         _status = _NOT_ENTERED;
56     }
57     modifier nonReentrant() {
58         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
59    _status = _ENTERED;
60 
61         _;
62         _status = _NOT_ENTERED;
63     }
64 }
65 
66 library Strings {
67     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
68  
69     function toString(uint256 value) internal pure returns (string memory) { 
70         if (value == 0) {
71             return "0";
72         }
73         uint256 temp = value;
74         uint256 digits;
75         while (temp != 0) {
76             digits++;
77             temp /= 10;
78         }
79         bytes memory buffer = new bytes(digits);
80         while (value != 0) {
81             digits -= 1;
82             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
83             value /= 10;
84         }
85         return string(buffer);
86     }
87  
88     function toHexString(uint256 value) internal pure returns (string memory) {
89         if (value == 0) {
90             return "0x00";
91         }
92         uint256 temp = value;
93         uint256 length = 0;
94         while (temp != 0) {
95             length++;
96             temp >>= 8;
97         }
98         return toHexString(value, length);
99     }
100  
101     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
102         bytes memory buffer = new bytes(2 * length + 2);
103         buffer[0] = "0";
104         buffer[1] = "x";
105         for (uint256 i = 2 * length + 1; i > 1; --i) {
106             buffer[i] = _HEX_SYMBOLS[value & 0xf];
107             value >>= 4;
108         }
109         require(value == 0, "Strings: hex length insufficient");
110         return string(buffer);
111     }
112 }
113  
114 abstract contract Context {
115     function _msgSender() internal view virtual returns (address) {
116         return msg.sender;
117     }
118 
119     function _msgData() internal view virtual returns (bytes calldata) {
120         return msg.data;
121     }
122 }
123  
124 abstract contract Ownable is Context {
125     address private _owner;
126 
127     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
128  
129     constructor() {
130         _transferOwnership(_msgSender());
131     }
132  
133     function owner() public view virtual returns (address) {
134         return _owner;
135     } 
136     modifier onlyOwner() {
137         require(owner() == _msgSender(), "Ownable: caller is not the owner");
138         _;
139     }
140  
141     function renounceOwnership() public virtual onlyOwner {
142         _transferOwnership(address(0));
143     }
144  
145     function transferOwnership(address newOwner) public virtual onlyOwner {
146         require(newOwner != address(0), "Ownable: new owner is the zero address");
147         _transferOwnership(newOwner);
148     }
149  
150     function _transferOwnership(address newOwner) internal virtual {
151         address oldOwner = _owner;
152         _owner = newOwner;
153         emit OwnershipTransferred(oldOwner, newOwner);
154     }
155 }
156  
157 library Address { 
158     function isContract(address account) internal view returns (bool) { 
159         uint256 size;
160         assembly {
161             size := extcodesize(account)
162         }
163         return size > 0;
164     } 
165     function sendValue(address payable recipient, uint256 amount) internal {
166         require(address(this).balance >= amount, "Address: insufficient balance");
167 
168         (bool success, ) = recipient.call{value: amount}("");
169         require(success, "Address: unable to send value, recipient may have reverted");
170     }
171  
172     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
173         return functionCall(target, data, "Address: low-level call failed");
174     } 
175     function functionCall(
176         address target,
177         bytes memory data,
178         string memory errorMessage
179     ) internal returns (bytes memory) {
180         return functionCallWithValue(target, data, 0, errorMessage);
181     }
182  
183     function functionCallWithValue(
184         address target,
185         bytes memory data,
186         uint256 value
187     ) internal returns (bytes memory) {
188         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
189     }
190  
191     function functionCallWithValue(
192         address target,
193         bytes memory data,
194         uint256 value,
195         string memory errorMessage
196     ) internal returns (bytes memory) {
197         require(address(this).balance >= value, "Address: insufficient balance for call");
198         require(isContract(target), "Address: call to non-contract");
199 
200         (bool success, bytes memory returndata) = target.call{value: value}(data);
201         return verifyCallResult(success, returndata, errorMessage);
202     } 
203     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
204         return functionStaticCall(target, data, "Address: low-level static call failed");
205     }
206  
207     function functionStaticCall(
208         address target,
209         bytes memory data,
210         string memory errorMessage
211     ) internal view returns (bytes memory) {
212         require(isContract(target), "Address: static call to non-contract");
213 
214         (bool success, bytes memory returndata) = target.staticcall(data);
215         return verifyCallResult(success, returndata, errorMessage);
216     }
217  
218     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
219         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
220     }
221  
222     function functionDelegateCall(
223         address target,
224         bytes memory data,
225         string memory errorMessage
226     ) internal returns (bytes memory) {
227         require(isContract(target), "Address: delegate call to non-contract");
228 
229         (bool success, bytes memory returndata) = target.delegatecall(data);
230         return verifyCallResult(success, returndata, errorMessage);
231     }
232  
233     function verifyCallResult(
234         bool success,
235         bytes memory returndata,
236         string memory errorMessage
237     ) internal pure returns (bytes memory) {
238         if (success) {
239             return returndata;
240         } else { 
241             if (returndata.length > 0) { 
242 
243                 assembly {
244                     let returndata_size := mload(returndata)
245                     revert(add(32, returndata), returndata_size)
246                 }
247             } else {
248                 revert(errorMessage);
249             }
250         }
251     }
252 }
253  
254 interface IERC721Receiver { 
255     function onERC721Received(
256         address operator,
257         address from,
258         uint256 tokenId,
259         bytes calldata data
260     ) external returns (bytes4);
261 }
262  
263 interface IERC165 { 
264     function supportsInterface(bytes4 interfaceId) external view returns (bool);
265 }
266  
267 abstract contract ERC165 is IERC165 { 
268     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
269         return interfaceId == type(IERC165).interfaceId;
270     }
271 } 
272 interface IERC721 is IERC165 { 
273     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId); 
274     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId); 
275     event ApprovalForAll(address indexed owner, address indexed operator, bool approved); 
276     function balanceOf(address owner) external view returns (uint256 balance); 
277     function ownerOf(uint256 tokenId) external view returns (address owner); 
278     function safeTransferFrom(
279         address from,
280         address to,
281         uint256 tokenId
282     ) external; 
283     function transferFrom(
284         address from,
285         address to,
286         uint256 tokenId
287     ) external; 
288     function approve(address to, uint256 tokenId) external;
289  
290     function getApproved(uint256 tokenId) external view returns (address operator); 
291     function setApprovalForAll(address operator, bool _approved) external; 
292     function isApprovedForAll(address owner, address operator) external view returns (bool); 
293     function safeTransferFrom(
294         address from,
295         address to,
296         uint256 tokenId,
297         bytes calldata data
298     ) external;
299 }
300 interface IERC721Metadata is IERC721 { 
301     function name() external view returns (string memory); 
302     function symbol() external view returns (string memory); 
303     function tokenURI(uint256 tokenId) external view returns (string memory);
304 } 
305 error ApprovalCallerNotOwnerNorApproved();
306 error ApprovalQueryForNonexistentToken();
307 error ApproveToCaller();
308 error ApprovalToCurrentOwner();
309 error BalanceQueryForZeroAddress();
310 error MintToZeroAddress();
311 error MintZeroQuantity();
312 error OwnerQueryForNonexistentToken();
313 error TransferCallerNotOwnerNorApproved();
314 error TransferFromIncorrectOwner();
315 error TransferToNonERC721ReceiverImplementer();
316 error TransferToZeroAddress();
317 error URIQueryForNonexistentToken();
318 
319 /**
320  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
321  * the Metadata extension. Built to optimize for lower gas during batch mints.
322  *
323  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
324  *
325  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
326  *
327  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
328  */
329 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, Ownable {
330     using Address for address;
331     using Strings for uint256;
332 
333     // Compiler will pack this into a single 256bit word.
334     struct TokenOwnership {
335         // The address of the owner.
336         address addr;
337         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
338         uint64 startTimestamp;
339         // Whether the token has been burned.
340         bool burned;
341     }
342 
343     // Compiler will pack this into a single 256bit word.
344     struct AddressData {
345         // Realistically, 2**64-1 is more than enough.
346         uint64 balance;
347         // Keeps track of mint count with minimal overhead for tokenomics.
348         uint64 numberMinted;
349         // Keeps track of burn count with minimal overhead for tokenomics.
350         uint64 numberBurned;
351         // For miscellaneous variable(s) pertaining to the address
352         // (e.g. number of whitelist mint slots used).
353         // If there are multiple variables, please pack them into a uint64.
354         uint64 aux;
355     }
356 
357     // The tokenId of the next token to be minted.
358     uint256 internal _currentIndex;
359 
360     // The number of tokens burned.
361     uint256 internal _burnCounter;
362 
363     // Token name
364     string private _name;
365 
366     // Token symbol
367     string private _symbol;
368 
369     // Mapping from token ID to ownership details
370     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
371     mapping(uint256 => TokenOwnership) internal _ownerships;
372 
373     // Mapping owner address to address data
374     mapping(address => AddressData) private _addressData;
375 
376     // Mapping from token ID to approved address
377     mapping(uint256 => address) private _tokenApprovals;
378 
379     // Mapping from owner to operator approvals
380     mapping(address => mapping(address => bool)) private _operatorApprovals;
381 
382     constructor(string memory name_, string memory symbol_) {
383         _name = name_;
384         _symbol = symbol_;
385         _currentIndex = _startTokenId();
386     }
387 
388     /**
389      * To change the starting tokenId, please override this function.
390      */
391     function _startTokenId() internal view virtual returns (uint256) {
392         return 0;
393     }
394 
395     /**
396      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
397      */
398     function totalSupply() public view returns (uint256) {
399         // Counter underflow is impossible as _burnCounter cannot be incremented
400         // more than _currentIndex - _startTokenId() times
401         unchecked {
402             return _currentIndex - _burnCounter - _startTokenId();
403         }
404     }
405 
406     /**
407      * Returns the total amount of tokens minted in the contract.
408      */
409     function _totalMinted() internal view returns (uint256) {
410         // Counter underflow is impossible as _currentIndex does not decrement,
411         // and it is initialized to _startTokenId()
412         unchecked {
413             return _currentIndex - _startTokenId();
414         }
415     }
416 
417     /**
418      * @dev See {IERC165-supportsInterface}.
419      */
420     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
421         return
422             interfaceId == type(IERC721).interfaceId ||
423             interfaceId == type(IERC721Metadata).interfaceId ||
424             super.supportsInterface(interfaceId);
425     }
426 
427     /**
428      * @dev See {IERC721-balanceOf}.
429      */
430     function balanceOf(address owner) public view override returns (uint256) {
431         if (owner == address(0)) revert BalanceQueryForZeroAddress();
432         return uint256(_addressData[owner].balance);
433     }
434 
435     /**
436      * Returns the number of tokens minted by `owner`.
437      */
438     function _numberMinted(address owner) internal view returns (uint256) {
439         return uint256(_addressData[owner].numberMinted);
440     }
441 
442     /**
443      * Returns the number of tokens burned by or on behalf of `owner`.
444      */
445     function _numberBurned(address owner) internal view returns (uint256) {
446         return uint256(_addressData[owner].numberBurned);
447     }
448 
449     /**
450      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
451      */
452     function _getAux(address owner) internal view returns (uint64) {
453         return _addressData[owner].aux;
454     }
455 
456     /**
457      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
458      * If there are multiple variables, please pack them into a uint64.
459      */
460     function _setAux(address owner, uint64 aux) internal {
461         _addressData[owner].aux = aux;
462     }
463 
464     /**
465      * Gas spent here starts off proportional to the maximum mint batch size.
466      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
467      */
468     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
469         uint256 curr = tokenId;
470 
471         unchecked {
472             if (_startTokenId() <= curr && curr < _currentIndex) {
473                 TokenOwnership memory ownership = _ownerships[curr];
474                 if (!ownership.burned) {
475                     if (ownership.addr != address(0)) {
476                         return ownership;
477                     }
478                     // Invariant:
479                     // There will always be an ownership that has an address and is not burned
480                     // before an ownership that does not have an address and is not burned.
481                     // Hence, curr will not underflow.
482                     while (true) {
483                         curr--;
484                         ownership = _ownerships[curr];
485                         if (ownership.addr != address(0)) {
486                             return ownership;
487                         }
488                     }
489                 }
490             }
491         }
492         revert OwnerQueryForNonexistentToken();
493     }
494 
495     /**
496      * @dev See {IERC721-ownerOf}.
497      */
498     function ownerOf(uint256 tokenId) public view override returns (address) {
499         return _ownershipOf(tokenId).addr;
500     }
501 
502     /**
503      * @dev See {IERC721Metadata-name}.
504      */
505     function name() public view virtual override returns (string memory) {
506         return _name;
507     }
508 
509     /**
510      * @dev See {IERC721Metadata-symbol}.
511      */
512     function symbol() public view virtual override returns (string memory) {
513         return _symbol;
514     }
515 
516     /**
517      * @dev See {IERC721Metadata-tokenURI}.
518      */
519     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
520         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
521 
522         string memory baseURI = _baseURI();
523         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
524     }
525 
526     /**
527      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
528      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
529      * by default, can be overriden in child contracts.
530      */
531     function _baseURI() internal view virtual returns (string memory) {
532         return '';
533     }
534 
535     /**
536      * @dev See {IERC721-approve}.
537      */
538     function approve(address to, uint256 tokenId) public override {
539         address owner = ERC721A.ownerOf(tokenId);
540         if (to == owner) revert ApprovalToCurrentOwner();
541 
542         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
543             revert ApprovalCallerNotOwnerNorApproved();
544         }
545 
546         _approve(to, tokenId, owner);
547     }
548 
549     /**
550      * @dev See {IERC721-getApproved}.
551      */
552     function getApproved(uint256 tokenId) public view override returns (address) {
553         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
554 
555         return _tokenApprovals[tokenId];
556     }
557 
558     /**
559      * @dev See {IERC721-setApprovalForAll}.
560      */
561     function setApprovalForAll(address operator, bool approved) public virtual override {
562         if (operator == _msgSender()) revert ApproveToCaller();
563 
564         _operatorApprovals[_msgSender()][operator] = approved;
565         emit ApprovalForAll(_msgSender(), operator, approved);
566     }
567 
568     /**
569      * @dev See {IERC721-isApprovedForAll}.
570      */
571     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
572         return _operatorApprovals[owner][operator];
573     }
574 
575     /**
576      * @dev See {IERC721-transferFrom}.
577      */
578     function transferFrom(
579         address from,
580         address to,
581         uint256 tokenId
582     ) public virtual override {
583         _transfer(from, to, tokenId);
584     }
585 
586     /**
587      * @dev See {IERC721-safeTransferFrom}.
588      */
589     function safeTransferFrom(
590         address from,
591         address to,
592         uint256 tokenId
593     ) public virtual override {
594         safeTransferFrom(from, to, tokenId, '');
595     }
596 
597     /**
598      * @dev See {IERC721-safeTransferFrom}.
599      */
600     function safeTransferFrom(
601         address from,
602         address to,
603         uint256 tokenId,
604         bytes memory _data
605     ) public virtual override {
606         _transfer(from, to, tokenId);
607         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
608             revert TransferToNonERC721ReceiverImplementer();
609         }
610     }
611 
612     /**
613      * @dev Returns whether `tokenId` exists.
614      *
615      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
616      *
617      * Tokens start existing when they are minted (`_mint`),
618      */
619     function _exists(uint256 tokenId) internal view returns (bool) {
620         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
621     }
622 
623     function _safeMint(address to, uint256 quantity) internal {
624         _safeMint(to, quantity, '');
625     }
626 
627     /**
628      * @dev Safely mints `quantity` tokens and transfers them to `to`.
629      *
630      * Requirements:
631      *
632      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
633      * - `quantity` must be greater than 0.
634      *
635      * Emits a {Transfer} event.
636      */
637     function _safeMint(
638         address to,
639         uint256 quantity,
640         bytes memory _data
641     ) internal {
642         _mint(to, quantity, _data, true);
643     }
644 
645     /**
646      * @dev Mints `quantity` tokens and transfers them to `to`.
647      *
648      * Requirements:
649      *
650      * - `to` cannot be the zero address.
651      * - `quantity` must be greater than 0.
652      *
653      * Emits a {Transfer} event.
654      */
655     function _mint(
656         address to,
657         uint256 quantity,
658         bytes memory _data,
659         bool safe
660     ) internal {
661         uint256 startTokenId = _currentIndex;
662         if (to == address(0)) revert MintToZeroAddress();
663         if (quantity == 0) revert MintZeroQuantity();
664 
665         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
666 
667         // Overflows are incredibly unrealistic.
668         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
669         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
670         unchecked {
671             _addressData[to].balance += uint64(quantity);
672             _addressData[to].numberMinted += uint64(quantity);
673 
674             _ownerships[startTokenId].addr = to;
675             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
676 
677             uint256 updatedIndex = startTokenId;
678             uint256 end = updatedIndex + quantity;
679 
680             if (safe && to.isContract()) {
681                 do {
682                     emit Transfer(address(0), to, updatedIndex);
683                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
684                         revert TransferToNonERC721ReceiverImplementer();
685                     }
686                 } while (updatedIndex != end);
687                 // Reentrancy protection
688                 if (_currentIndex != startTokenId) revert();
689             } else {
690                 do {
691                     emit Transfer(address(0), to, updatedIndex++);
692                 } while (updatedIndex != end);
693             }
694             _currentIndex = updatedIndex;
695         }
696         _afterTokenTransfers(address(0), to, startTokenId, quantity);
697     }
698 
699     /**
700      * @dev Transfers `tokenId` from `from` to `to`.
701      *
702      * Requirements:
703      *
704      * - `to` cannot be the zero address.
705      * - `tokenId` token must be owned by `from`.
706      *
707      * Emits a {Transfer} event.
708      */
709     function _transfer(
710         address from,
711         address to,
712         uint256 tokenId
713     ) private {
714         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
715 
716         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
717 
718         bool isApprovedOrOwner = (_msgSender() == from ||
719             isApprovedForAll(from, _msgSender()) ||
720             getApproved(tokenId) == _msgSender());
721 
722         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
723         if (to == address(0)) revert TransferToZeroAddress();
724 
725         _beforeTokenTransfers(from, to, tokenId, 1);
726 
727         // Clear approvals from the previous owner
728         _approve(address(0), tokenId, from);
729 
730         // Underflow of the sender's balance is impossible because we check for
731         // ownership above and the recipient's balance can't realistically overflow.
732         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
733         unchecked {
734             _addressData[from].balance -= 1;
735             _addressData[to].balance += 1;
736 
737             TokenOwnership storage currSlot = _ownerships[tokenId];
738             currSlot.addr = to;
739             currSlot.startTimestamp = uint64(block.timestamp);
740 
741             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
742             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
743             uint256 nextTokenId = tokenId + 1;
744             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
745             if (nextSlot.addr == address(0)) {
746                 // This will suffice for checking _exists(nextTokenId),
747                 // as a burned slot cannot contain the zero address.
748                 if (nextTokenId != _currentIndex) {
749                     nextSlot.addr = from;
750                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
751                 }
752             }
753         }
754 
755         emit Transfer(from, to, tokenId);
756         _afterTokenTransfers(from, to, tokenId, 1);
757     }
758 
759     /**
760      * @dev This is equivalent to _burn(tokenId, false)
761      */
762     function _burn(uint256 tokenId) internal virtual {
763         _burn(tokenId, false);
764     }
765 
766     /**
767      * @dev Destroys `tokenId`.
768      * The approval is cleared when the token is burned.
769      *
770      * Requirements:
771      *
772      * - `tokenId` must exist.
773      *
774      * Emits a {Transfer} event.
775      */
776     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
777         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
778 
779         address from = prevOwnership.addr;
780 
781         if (approvalCheck) {
782             bool isApprovedOrOwner = (_msgSender() == from ||
783                 isApprovedForAll(from, _msgSender()) ||
784                 getApproved(tokenId) == _msgSender());
785 
786             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
787         }
788 
789         _beforeTokenTransfers(from, address(0), tokenId, 1);
790 
791         // Clear approvals from the previous owner
792         _approve(address(0), tokenId, from);
793 
794         // Underflow of the sender's balance is impossible because we check for
795         // ownership above and the recipient's balance can't realistically overflow.
796         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
797         unchecked {
798             AddressData storage addressData = _addressData[from];
799             addressData.balance -= 1;
800             addressData.numberBurned += 1;
801 
802             // Keep track of who burned the token, and the timestamp of burning.
803             TokenOwnership storage currSlot = _ownerships[tokenId];
804             currSlot.addr = from;
805             currSlot.startTimestamp = uint64(block.timestamp);
806             currSlot.burned = true;
807 
808             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
809             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
810             uint256 nextTokenId = tokenId + 1;
811             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
812             if (nextSlot.addr == address(0)) {
813                 // This will suffice for checking _exists(nextTokenId),
814                 // as a burned slot cannot contain the zero address.
815                 if (nextTokenId != _currentIndex) {
816                     nextSlot.addr = from;
817                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
818                 }
819             }
820         }
821 
822         emit Transfer(from, address(0), tokenId);
823         _afterTokenTransfers(from, address(0), tokenId, 1);
824 
825         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
826         unchecked {
827             _burnCounter++;
828         }
829     }
830 
831     /**
832      * @dev Approve `to` to operate on `tokenId`
833      *
834      * Emits a {Approval} event.
835      */
836     function _approve(
837         address to,
838         uint256 tokenId,
839         address owner
840     ) private {
841         _tokenApprovals[tokenId] = to;
842         emit Approval(owner, to, tokenId);
843     }
844 
845     /**
846      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
847      *
848      * @param from address representing the previous owner of the given token ID
849      * @param to target address that will receive the tokens
850      * @param tokenId uint256 ID of the token to be transferred
851      * @param _data bytes optional data to send along with the call
852      * @return bool whether the call correctly returned the expected magic value
853      */
854     function _checkContractOnERC721Received(
855         address from,
856         address to,
857         uint256 tokenId,
858         bytes memory _data
859     ) private returns (bool) {
860         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
861             return retval == IERC721Receiver(to).onERC721Received.selector;
862         } catch (bytes memory reason) {
863             if (reason.length == 0) {
864                 revert TransferToNonERC721ReceiverImplementer();
865             } else {
866                 assembly {
867                     revert(add(32, reason), mload(reason))
868                 }
869             }
870         }
871     }
872 
873     /**
874      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
875      * And also called before burning one token.
876      *
877      * startTokenId - the first token id to be transferred
878      * quantity - the amount to be transferred
879      *
880      * Calling conditions:
881      *
882      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
883      * transferred to `to`.
884      * - When `from` is zero, `tokenId` will be minted for `to`.
885      * - When `to` is zero, `tokenId` will be burned by `from`.
886      * - `from` and `to` are never both zero.
887      */
888     function _beforeTokenTransfers(
889         address from,
890         address to,
891         uint256 startTokenId,
892         uint256 quantity
893     ) internal virtual {}
894 
895     /**
896      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
897      * minting.
898      * And also called after one token has been burned.
899      *
900      * startTokenId - the first token id to be transferred
901      * quantity - the amount to be transferred
902      *
903      * Calling conditions:
904      *
905      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
906      * transferred to `to`.
907      * - When `from` is zero, `tokenId` has been minted for `to`.
908      * - When `to` is zero, `tokenId` has been burned by `from`.
909      * - `from` and `to` are never both zero.
910      */
911     function _afterTokenTransfers(
912         address from,
913         address to,
914         uint256 startTokenId,
915         uint256 quantity
916     ) internal virtual {}
917 }
918 
919 contract Magiotsri is Ownable, ERC721A, ReentrancyGuard {
920     using Strings for uint256;
921 
922   bytes32 public merkleRoot = 0x1856cb03eeee40e9bba0aa075c3ef16ec78a3613685598d2392090290a08ae9c;
923   function setMerkleRoot(bytes32 m) public onlyOwner{
924     merkleRoot = m;
925   }
926 
927   uint256 public MAX_PER_Transtion = 40; // maximam amount that user can mint
928   uint256 public MAX_PER_Address = 40; // maximam amount that user can mint
929 
930   uint256 public  PRICE = 0.04 ether;
931 
932   uint256 private constant TotalCollectionSize_ = 7777; // total number of nfts
933 
934   string private _baseTokenURI;
935   uint private stopat = 7777;
936   uint private reserve = 170;
937 
938   uint public status = 0; //0-pause 1-whitelist 2-public 
939 
940   constructor() ERC721A("Strange Times","Strange Times") {
941     _baseTokenURI = "ipfs://QmYqKmNQHbGaRYbHzmH9PyNWLiFTg35nqivdVSi45N6uAe/";
942   }
943 
944   modifier callerIsUser() {
945     require(tx.origin == msg.sender, "The caller is another contract");
946     _;
947   }
948  
949   function mint(uint256 quantity) external payable callerIsUser {
950     require(status == 3 , "Sale is not Active");
951     require(totalSupply() + quantity <= TotalCollectionSize_ - reserve, "reached max supply");
952     require(numberMinted(msg.sender) + quantity <= MAX_PER_Address, "Quantity exceeds allowed Mints" );
953     require(quantity <= MAX_PER_Transtion,"can not mint this many");
954     require(msg.value >= PRICE * quantity, "Need to send more ETH.");
955     _safeMint(msg.sender, quantity);   
956     if(totalSupply() >= stopat) {status = 0;}
957   }
958   function phase1mint(uint256 quantity) external payable callerIsUser {
959     require( msg.sender == 0xF142D7bAFF0986B50ae24e694419C65e7091f52c , "Unauthorized");
960     require( status == 1, "Sale is not Active");
961     require(numberMinted(msg.sender) + quantity <= MAX_PER_Address, "Quantity exceeds allowed Mints" );
962     require( msg.value == PRICE * quantity, "Need to send more ETH.");
963     _safeMint(msg.sender, quantity);
964     if(totalSupply() >= stopat) {status = 0;}
965   }
966   function whitelistMint(uint256 quantity, bytes32[] calldata merkleproof) external payable callerIsUser {
967     bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
968     require(MerkleProof.verify( merkleproof, merkleRoot, leaf),"Not whitelisted");
969     require(status == 2, "Whitelist Sale not started");
970     require(totalSupply() + quantity <= TotalCollectionSize_ - reserve, "reached max supply");
971     require( ( numberMinted(msg.sender) + quantity <= MAX_PER_Address ) , "Quantity exceeds allowed Mints" );
972     require(  quantity <= MAX_PER_Transtion,"can not mint this many");
973     require(msg.value >= PRICE * quantity, "Need to send more ETH.");
974     _safeMint(msg.sender, quantity);
975     if(totalSupply() >= stopat) {status = 0;}
976     
977   }
978 
979    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
980     require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
981     string memory baseURI = _baseURI();
982     return
983       bytes(baseURI).length > 0
984         ? string(abi.encodePacked(baseURI, tokenId.toString(),".json"))
985         : "";
986   }
987 
988   function setBaseURI(string memory baseURI) external onlyOwner {
989     _baseTokenURI = baseURI;
990   }
991   function _baseURI() internal view virtual override returns (string memory) {
992     return _baseTokenURI;
993   }
994   function numberMinted(address owner) public view returns (uint256) {
995     return _numberMinted(owner);
996   }
997   function getOwnershipData(uint256 tokenId)
998     external
999     view
1000     returns (TokenOwnership memory)
1001   {
1002     return _ownershipOf(tokenId);
1003   }
1004   function withdraw() external onlyOwner nonReentrant {
1005     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1006     require(success, "Transfer failed.");
1007   }
1008   function changeMintPrice(uint256 _newPrice) external onlyOwner
1009   {
1010       PRICE = _newPrice;
1011   }
1012   function changeMAX_PER_Transtion(uint256 q) external onlyOwner
1013   {
1014       MAX_PER_Transtion = q;
1015   }
1016   function changeMAX_PER_Address(uint256 q) external onlyOwner
1017   {
1018       MAX_PER_Address = q;
1019   }
1020   function setStatus(uint256 s)external onlyOwner{
1021       status = s;
1022   }
1023   function giveaway(address a, uint q)public onlyOwner{
1024     _safeMint(a, q);
1025   }
1026     function setStop(uint256 s)external onlyOwner{
1027       stopat = s;
1028   }
1029   function setReserve(uint256 r)external onlyOwner{
1030       reserve = r;
1031   }
1032      function configuration(uint256 Status , uint256 MPA , uint256 MPT , uint256 Price, uint256 Stop )external onlyOwner{
1033       status = Status;
1034       stopat = Stop;
1035       PRICE = Price;
1036       MAX_PER_Address = MPA;
1037       MAX_PER_Transtion = MPT;
1038   }
1039   function _startTokenId() internal view override returns (uint256) {
1040         return 1;
1041     }
1042   
1043 }