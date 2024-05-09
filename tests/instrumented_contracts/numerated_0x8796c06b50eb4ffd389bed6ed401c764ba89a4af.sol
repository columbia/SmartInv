1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity ^0.8.0; 
5 
6 abstract contract ReentrancyGuard { 
7     uint256 private constant _NOT_ENTERED = 1;
8     uint256 private constant _ENTERED = 2;
9 
10     uint256 private _status;
11 
12     constructor() {
13         _status = _NOT_ENTERED;
14     }
15     modifier nonReentrant() {
16         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
17    _status = _ENTERED;
18 
19         _;
20         _status = _NOT_ENTERED;
21     }
22 }
23 
24 library Strings {
25     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
26  
27     function toString(uint256 value) internal pure returns (string memory) { 
28         if (value == 0) {
29             return "0";
30         }
31         uint256 temp = value;
32         uint256 digits;
33         while (temp != 0) {
34             digits++;
35             temp /= 10;
36         }
37         bytes memory buffer = new bytes(digits);
38         while (value != 0) {
39             digits -= 1;
40             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
41             value /= 10;
42         }
43         return string(buffer);
44     }
45  
46     function toHexString(uint256 value) internal pure returns (string memory) {
47         if (value == 0) {
48             return "0x00";
49         }
50         uint256 temp = value;
51         uint256 length = 0;
52         while (temp != 0) {
53             length++;
54             temp >>= 8;
55         }
56         return toHexString(value, length);
57     }
58  
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 }
71  
72 abstract contract Context {
73     function _msgSender() internal view virtual returns (address) {
74         return msg.sender;
75     }
76 
77     function _msgData() internal view virtual returns (bytes calldata) {
78         return msg.data;
79     }
80 }
81  
82 abstract contract Ownable is Context {
83     address private _owner;
84 
85     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
86  
87     constructor() {
88         _transferOwnership(_msgSender());
89     }
90  
91     function owner() public view virtual returns (address) {
92         return _owner;
93     } 
94     modifier onlyOwner() {
95         require(owner() == _msgSender(), "Ownable: caller is not the owner");
96         _;
97     }
98  
99     function renounceOwnership() public virtual onlyOwner {
100         _transferOwnership(address(0));
101     }
102  
103     function transferOwnership(address newOwner) public virtual onlyOwner {
104         require(newOwner != address(0), "Ownable: new owner is the zero address");
105         _transferOwnership(newOwner);
106     }
107  
108     function _transferOwnership(address newOwner) internal virtual {
109         address oldOwner = _owner;
110         _owner = newOwner;
111         emit OwnershipTransferred(oldOwner, newOwner);
112     }
113 }
114  
115 library Address { 
116     function isContract(address account) internal view returns (bool) { 
117         uint256 size;
118         assembly {
119             size := extcodesize(account)
120         }
121         return size > 0;
122     } 
123     function sendValue(address payable recipient, uint256 amount) internal {
124         require(address(this).balance >= amount, "Address: insufficient balance");
125 
126         (bool success, ) = recipient.call{value: amount}("");
127         require(success, "Address: unable to send value, recipient may have reverted");
128     }
129  
130     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
131         return functionCall(target, data, "Address: low-level call failed");
132     } 
133     function functionCall(
134         address target,
135         bytes memory data,
136         string memory errorMessage
137     ) internal returns (bytes memory) {
138         return functionCallWithValue(target, data, 0, errorMessage);
139     }
140  
141     function functionCallWithValue(
142         address target,
143         bytes memory data,
144         uint256 value
145     ) internal returns (bytes memory) {
146         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
147     }
148  
149     function functionCallWithValue(
150         address target,
151         bytes memory data,
152         uint256 value,
153         string memory errorMessage
154     ) internal returns (bytes memory) {
155         require(address(this).balance >= value, "Address: insufficient balance for call");
156         require(isContract(target), "Address: call to non-contract");
157 
158         (bool success, bytes memory returndata) = target.call{value: value}(data);
159         return verifyCallResult(success, returndata, errorMessage);
160     } 
161     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
162         return functionStaticCall(target, data, "Address: low-level static call failed");
163     }
164  
165     function functionStaticCall(
166         address target,
167         bytes memory data,
168         string memory errorMessage
169     ) internal view returns (bytes memory) {
170         require(isContract(target), "Address: static call to non-contract");
171 
172         (bool success, bytes memory returndata) = target.staticcall(data);
173         return verifyCallResult(success, returndata, errorMessage);
174     }
175  
176     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
177         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
178     }
179  
180     function functionDelegateCall(
181         address target,
182         bytes memory data,
183         string memory errorMessage
184     ) internal returns (bytes memory) {
185         require(isContract(target), "Address: delegate call to non-contract");
186 
187         (bool success, bytes memory returndata) = target.delegatecall(data);
188         return verifyCallResult(success, returndata, errorMessage);
189     }
190  
191     function verifyCallResult(
192         bool success,
193         bytes memory returndata,
194         string memory errorMessage
195     ) internal pure returns (bytes memory) {
196         if (success) {
197             return returndata;
198         } else { 
199             if (returndata.length > 0) { 
200 
201                 assembly {
202                     let returndata_size := mload(returndata)
203                     revert(add(32, returndata), returndata_size)
204                 }
205             } else {
206                 revert(errorMessage);
207             }
208         }
209     }
210 }
211  
212 interface IERC721Receiver { 
213     function onERC721Received(
214         address operator,
215         address from,
216         uint256 tokenId,
217         bytes calldata data
218     ) external returns (bytes4);
219 }
220  
221 interface IERC165 { 
222     function supportsInterface(bytes4 interfaceId) external view returns (bool);
223 }
224  
225 abstract contract ERC165 is IERC165 { 
226     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
227         return interfaceId == type(IERC165).interfaceId;
228     }
229 } 
230 interface IERC721 is IERC165 { 
231     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId); 
232     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId); 
233     event ApprovalForAll(address indexed owner, address indexed operator, bool approved); 
234     function balanceOf(address owner) external view returns (uint256 balance); 
235     function ownerOf(uint256 tokenId) external view returns (address owner); 
236     function safeTransferFrom(
237         address from,
238         address to,
239         uint256 tokenId
240     ) external; 
241     function transferFrom(
242         address from,
243         address to,
244         uint256 tokenId
245     ) external; 
246     function approve(address to, uint256 tokenId) external;
247  
248     function getApproved(uint256 tokenId) external view returns (address operator); 
249     function setApprovalForAll(address operator, bool _approved) external; 
250     function isApprovedForAll(address owner, address operator) external view returns (bool); 
251     function safeTransferFrom(
252         address from,
253         address to,
254         uint256 tokenId,
255         bytes calldata data
256     ) external;
257 } 
258 interface IERC721Enumerable is IERC721 { 
259     function totalSupply() external view returns (uint256); 
260     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId); 
261     function tokenByIndex(uint256 index) external view returns (uint256);
262 }  
263 interface IERC721Metadata is IERC721 { 
264     function name() external view returns (string memory); 
265     function symbol() external view returns (string memory); 
266     function tokenURI(uint256 tokenId) external view returns (string memory);
267 }
268 
269 error ApprovalCallerNotOwnerNorApproved();
270 error ApprovalQueryForNonexistentToken();
271 error ApproveToCaller();
272 error ApprovalToCurrentOwner();
273 error BalanceQueryForZeroAddress();
274 error MintToZeroAddress();
275 error MintZeroQuantity();
276 error OwnerQueryForNonexistentToken();
277 error TransferCallerNotOwnerNorApproved();
278 error TransferFromIncorrectOwner();
279 error TransferToNonERC721ReceiverImplementer();
280 error TransferToZeroAddress();
281 error URIQueryForNonexistentToken();
282 
283 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
284     using Address for address;
285     using Strings for uint256;
286 
287     // Compiler will pack this into a single 256bit word.
288     struct TokenOwnership {
289         // The address of the owner.
290         address addr;
291         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
292         uint64 startTimestamp;
293         // Whether the token has been burned.
294         bool burned;
295     }
296 
297     // Compiler will pack this into a single 256bit word.
298     struct AddressData {
299         // Realistically, 2**64-1 is more than enough.
300         uint64 balance;
301         // Keeps track of mint count with minimal overhead for tokenomics.
302         uint64 numberMinted;
303         // Keeps track of burn count with minimal overhead for tokenomics.
304         uint64 numberBurned;
305         // For miscellaneous variable(s) pertaining to the address
306         // (e.g. number of whitelist mint slots used).
307         // If there are multiple variables, please pack them into a uint64.
308         uint64 aux;
309     }
310 
311     // The tokenId of the next token to be minted.
312     uint256 internal _currentIndex;
313 
314     // The number of tokens burned.
315     uint256 internal _burnCounter;
316 
317     // Token name
318     string private _name;
319 
320     // Token symbol
321     string private _symbol;
322 
323     // Mapping from token ID to ownership details
324     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
325     mapping(uint256 => TokenOwnership) internal _ownerships;
326 
327     // Mapping owner address to address data
328     mapping(address => AddressData) private _addressData;
329 
330     // Mapping from token ID to approved address
331     mapping(uint256 => address) private _tokenApprovals;
332 
333     // Mapping from owner to operator approvals
334     mapping(address => mapping(address => bool)) private _operatorApprovals;
335 
336     constructor(string memory name_, string memory symbol_) {
337         _name = name_;
338         _symbol = symbol_;
339         _currentIndex = _startTokenId();
340     }
341 
342     /**
343      * To change the starting tokenId, please override this function.
344      */
345     function _startTokenId() internal view virtual returns (uint256) {
346         return 1;
347     }
348 
349     /**
350      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
351      */
352     function totalSupply() public view returns (uint256) {
353         // Counter underflow is impossible as _burnCounter cannot be incremented
354         // more than _currentIndex - _startTokenId() times
355         unchecked {
356             return _currentIndex - _burnCounter - _startTokenId();
357         }
358     }
359 
360     /**
361      * Returns the total amount of tokens minted in the contract.
362      */
363     function _totalMinted() internal view returns (uint256) {
364         // Counter underflow is impossible as _currentIndex does not decrement,
365         // and it is initialized to _startTokenId()
366         unchecked {
367             return _currentIndex - _startTokenId();
368         }
369     }
370 
371     /**
372      * @dev See {IERC165-supportsInterface}.
373      */
374     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
375         return
376             interfaceId == type(IERC721).interfaceId ||
377             interfaceId == type(IERC721Metadata).interfaceId ||
378             super.supportsInterface(interfaceId);
379     }
380 
381     /**
382      * @dev See {IERC721-balanceOf}.
383      */
384     function balanceOf(address owner) public view override returns (uint256) {
385         if (owner == address(0)) revert BalanceQueryForZeroAddress();
386         return uint256(_addressData[owner].balance);
387     }
388 
389     /**
390      * Returns the number of tokens minted by `owner`.
391      */
392     function _numberMinted(address owner) internal view returns (uint256) {
393         return uint256(_addressData[owner].numberMinted);
394     }
395 
396     /**
397      * Returns the number of tokens burned by or on behalf of `owner`.
398      */
399     function _numberBurned(address owner) internal view returns (uint256) {
400         return uint256(_addressData[owner].numberBurned);
401     }
402 
403     /**
404      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
405      */
406     function _getAux(address owner) internal view returns (uint64) {
407         return _addressData[owner].aux;
408     }
409 
410     /**
411      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
412      * If there are multiple variables, please pack them into a uint64.
413      */
414     function _setAux(address owner, uint64 aux) internal {
415         _addressData[owner].aux = aux;
416     }
417 
418     /**
419      * Gas spent here starts off proportional to the maximum mint batch size.
420      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
421      */
422     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
423         uint256 curr = tokenId;
424 
425         unchecked {
426             if (_startTokenId() <= curr && curr < _currentIndex) {
427                 TokenOwnership memory ownership = _ownerships[curr];
428                 if (!ownership.burned) {
429                     if (ownership.addr != address(0)) {
430                         return ownership;
431                     }
432                     // Invariant:
433                     // There will always be an ownership that has an address and is not burned
434                     // before an ownership that does not have an address and is not burned.
435                     // Hence, curr will not underflow.
436                     while (true) {
437                         curr--;
438                         ownership = _ownerships[curr];
439                         if (ownership.addr != address(0)) {
440                             return ownership;
441                         }
442                     }
443                 }
444             }
445         }
446         revert OwnerQueryForNonexistentToken();
447     }
448 
449     /**
450      * @dev See {IERC721-ownerOf}.
451      */
452     function ownerOf(uint256 tokenId) public view override returns (address) {
453         return _ownershipOf(tokenId).addr;
454     }
455 
456     /**
457      * @dev See {IERC721Metadata-name}.
458      */
459     function name() public view virtual override returns (string memory) {
460         return _name;
461     }
462 
463     /**
464      * @dev See {IERC721Metadata-symbol}.
465      */
466     function symbol() public view virtual override returns (string memory) {
467         return _symbol;
468     }
469 
470     /**
471      * @dev See {IERC721Metadata-tokenURI}.
472      */
473     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
474         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
475 
476         string memory baseURI = _baseURI();
477         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
478     }
479 
480     /**
481      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
482      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
483      * by default, can be overriden in child contracts.
484      */
485     function _baseURI() internal view virtual returns (string memory) {
486         return '';
487     }
488 
489     /**
490      * @dev See {IERC721-approve}.
491      */
492     function approve(address to, uint256 tokenId) public override {
493         address owner = ERC721A.ownerOf(tokenId);
494         if (to == owner) revert ApprovalToCurrentOwner();
495 
496         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
497             revert ApprovalCallerNotOwnerNorApproved();
498         }
499 
500         _approve(to, tokenId, owner);
501     }
502 
503     /**
504      * @dev See {IERC721-getApproved}.
505      */
506     function getApproved(uint256 tokenId) public view override returns (address) {
507         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
508 
509         return _tokenApprovals[tokenId];
510     }
511 
512     /**
513      * @dev See {IERC721-setApprovalForAll}.
514      */
515     function setApprovalForAll(address operator, bool approved) public virtual override {
516         if (operator == _msgSender()) revert ApproveToCaller();
517 
518         _operatorApprovals[_msgSender()][operator] = approved;
519         emit ApprovalForAll(_msgSender(), operator, approved);
520     }
521 
522     /**
523      * @dev See {IERC721-isApprovedForAll}.
524      */
525     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
526         return _operatorApprovals[owner][operator];
527     }
528 
529     /**
530      * @dev See {IERC721-transferFrom}.
531      */
532     function transferFrom(
533         address from,
534         address to,
535         uint256 tokenId
536     ) public virtual override {
537         _transfer(from, to, tokenId);
538     }
539 
540     /**
541      * @dev See {IERC721-safeTransferFrom}.
542      */
543     function safeTransferFrom(
544         address from,
545         address to,
546         uint256 tokenId
547     ) public virtual override {
548         safeTransferFrom(from, to, tokenId, '');
549     }
550 
551     /**
552      * @dev See {IERC721-safeTransferFrom}.
553      */
554     function safeTransferFrom(
555         address from,
556         address to,
557         uint256 tokenId,
558         bytes memory _data
559     ) public virtual override {
560         _transfer(from, to, tokenId);
561         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
562             revert TransferToNonERC721ReceiverImplementer();
563         }
564     }
565 
566     /**
567      * @dev Returns whether `tokenId` exists.
568      *
569      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
570      *
571      * Tokens start existing when they are minted (`_mint`),
572      */
573     function _exists(uint256 tokenId) internal view returns (bool) {
574         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
575     }
576 
577     function _safeMint(address to, uint256 quantity) internal {
578         _safeMint(to, quantity, '');
579     }
580 
581     /**
582      * @dev Safely mints `quantity` tokens and transfers them to `to`.
583      *
584      * Requirements:
585      *
586      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
587      * - `quantity` must be greater than 0.
588      *
589      * Emits a {Transfer} event.
590      */
591     function _safeMint(
592         address to,
593         uint256 quantity,
594         bytes memory _data
595     ) internal {
596         _mint(to, quantity, _data, true);
597     }
598 
599     /**
600      * @dev Mints `quantity` tokens and transfers them to `to`.
601      *
602      * Requirements:
603      *
604      * - `to` cannot be the zero address.
605      * - `quantity` must be greater than 0.
606      *
607      * Emits a {Transfer} event.
608      */
609     function _mint(
610         address to,
611         uint256 quantity,
612         bytes memory _data,
613         bool safe
614     ) internal {
615         uint256 startTokenId = _currentIndex;
616         if (to == address(0)) revert MintToZeroAddress();
617         if (quantity == 0) revert MintZeroQuantity();
618 
619         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
620 
621         // Overflows are incredibly unrealistic.
622         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
623         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
624         unchecked {
625             _addressData[to].balance += uint64(quantity);
626             _addressData[to].numberMinted += uint64(quantity);
627 
628             _ownerships[startTokenId].addr = to;
629             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
630 
631             uint256 updatedIndex = startTokenId;
632             uint256 end = updatedIndex + quantity;
633 
634             if (safe && to.isContract()) {
635                 do {
636                     emit Transfer(address(0), to, updatedIndex);
637                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
638                         revert TransferToNonERC721ReceiverImplementer();
639                     }
640                 } while (updatedIndex != end);
641                 // Reentrancy protection
642                 if (_currentIndex != startTokenId) revert();
643             } else {
644                 do {
645                     emit Transfer(address(0), to, updatedIndex++);
646                 } while (updatedIndex != end);
647             }
648             _currentIndex = updatedIndex;
649         }
650         _afterTokenTransfers(address(0), to, startTokenId, quantity);
651     }
652 
653     /**
654      * @dev Transfers `tokenId` from `from` to `to`.
655      *
656      * Requirements:
657      *
658      * - `to` cannot be the zero address.
659      * - `tokenId` token must be owned by `from`.
660      *
661      * Emits a {Transfer} event.
662      */
663     function _transfer(
664         address from,
665         address to,
666         uint256 tokenId
667     ) private {
668         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
669 
670         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
671 
672         bool isApprovedOrOwner = (_msgSender() == from ||
673             isApprovedForAll(from, _msgSender()) ||
674             getApproved(tokenId) == _msgSender());
675 
676         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
677         if (to == address(0)) revert TransferToZeroAddress();
678 
679         _beforeTokenTransfers(from, to, tokenId, 1);
680 
681         // Clear approvals from the previous owner
682         _approve(address(0), tokenId, from);
683 
684         // Underflow of the sender's balance is impossible because we check for
685         // ownership above and the recipient's balance can't realistically overflow.
686         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
687         unchecked {
688             _addressData[from].balance -= 1;
689             _addressData[to].balance += 1;
690 
691             TokenOwnership storage currSlot = _ownerships[tokenId];
692             currSlot.addr = to;
693             currSlot.startTimestamp = uint64(block.timestamp);
694 
695             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
696             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
697             uint256 nextTokenId = tokenId + 1;
698             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
699             if (nextSlot.addr == address(0)) {
700                 // This will suffice for checking _exists(nextTokenId),
701                 // as a burned slot cannot contain the zero address.
702                 if (nextTokenId != _currentIndex) {
703                     nextSlot.addr = from;
704                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
705                 }
706             }
707         }
708 
709         emit Transfer(from, to, tokenId);
710         _afterTokenTransfers(from, to, tokenId, 1);
711     }
712 
713     /**
714      * @dev This is equivalent to _burn(tokenId, false)
715      */
716     function _burn(uint256 tokenId) internal virtual {
717         _burn(tokenId, false);
718     }
719 
720     /**
721      * @dev Destroys `tokenId`.
722      * The approval is cleared when the token is burned.
723      *
724      * Requirements:
725      *
726      * - `tokenId` must exist.
727      *
728      * Emits a {Transfer} event.
729      */
730     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
731         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
732 
733         address from = prevOwnership.addr;
734 
735         if (approvalCheck) {
736             bool isApprovedOrOwner = (_msgSender() == from ||
737                 isApprovedForAll(from, _msgSender()) ||
738                 getApproved(tokenId) == _msgSender());
739 
740             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
741         }
742 
743         _beforeTokenTransfers(from, address(0), tokenId, 1);
744 
745         // Clear approvals from the previous owner
746         _approve(address(0), tokenId, from);
747 
748         // Underflow of the sender's balance is impossible because we check for
749         // ownership above and the recipient's balance can't realistically overflow.
750         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
751         unchecked {
752             AddressData storage addressData = _addressData[from];
753             addressData.balance -= 1;
754             addressData.numberBurned += 1;
755 
756             // Keep track of who burned the token, and the timestamp of burning.
757             TokenOwnership storage currSlot = _ownerships[tokenId];
758             currSlot.addr = from;
759             currSlot.startTimestamp = uint64(block.timestamp);
760             currSlot.burned = true;
761 
762             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
763             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
764             uint256 nextTokenId = tokenId + 1;
765             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
766             if (nextSlot.addr == address(0)) {
767                 // This will suffice for checking _exists(nextTokenId),
768                 // as a burned slot cannot contain the zero address.
769                 if (nextTokenId != _currentIndex) {
770                     nextSlot.addr = from;
771                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
772                 }
773             }
774         }
775 
776         emit Transfer(from, address(0), tokenId);
777         _afterTokenTransfers(from, address(0), tokenId, 1);
778 
779         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
780         unchecked {
781             _burnCounter++;
782         }
783     }
784 
785     /**
786      * @dev Approve `to` to operate on `tokenId`
787      *
788      * Emits a {Approval} event.
789      */
790     function _approve(
791         address to,
792         uint256 tokenId,
793         address owner
794     ) private {
795         _tokenApprovals[tokenId] = to;
796         emit Approval(owner, to, tokenId);
797     }
798 
799     /**
800      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
801      *
802      * @param from address representing the previous owner of the given token ID
803      * @param to target address that will receive the tokens
804      * @param tokenId uint256 ID of the token to be transferred
805      * @param _data bytes optional data to send along with the call
806      * @return bool whether the call correctly returned the expected magic value
807      */
808     function _checkContractOnERC721Received(
809         address from,
810         address to,
811         uint256 tokenId,
812         bytes memory _data
813     ) private returns (bool) {
814         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
815             return retval == IERC721Receiver(to).onERC721Received.selector;
816         } catch (bytes memory reason) {
817             if (reason.length == 0) {
818                 revert TransferToNonERC721ReceiverImplementer();
819             } else {
820                 assembly {
821                     revert(add(32, reason), mload(reason))
822                 }
823             }
824         }
825     }
826 
827     /**
828      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
829      * And also called before burning one token.
830      *
831      * startTokenId - the first token id to be transferred
832      * quantity - the amount to be transferred
833      *
834      * Calling conditions:
835      *
836      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
837      * transferred to `to`.
838      * - When `from` is zero, `tokenId` will be minted for `to`.
839      * - When `to` is zero, `tokenId` will be burned by `from`.
840      * - `from` and `to` are never both zero.
841      */
842     function _beforeTokenTransfers(
843         address from,
844         address to,
845         uint256 startTokenId,
846         uint256 quantity
847     ) internal virtual {}
848 
849     /**
850      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
851      * minting.
852      * And also called after one token has been burned.
853      *
854      * startTokenId - the first token id to be transferred
855      * quantity - the amount to be transferred
856      *
857      * Calling conditions:
858      *
859      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
860      * transferred to `to`.
861      * - When `from` is zero, `tokenId` has been minted for `to`.
862      * - When `to` is zero, `tokenId` has been burned by `from`.
863      * - `from` and `to` are never both zero.
864      */
865     function _afterTokenTransfers(
866         address from,
867         address to,
868         uint256 startTokenId,
869         uint256 quantity
870     ) internal virtual {}
871 }
872 
873 contract DirtyTacoNFT is Ownable, ERC721A, ReentrancyGuard {
874     using Strings for uint256;
875 
876 
877   uint256 public MAX_PER_Transtion = 10; // maximam amount that user can mint
878 
879     uint256 public  PRICE = 0.16 ether; 
880 
881   uint256 private constant TotalCollectionSize_ = 3000; // total number of nfts
882   uint256 private constant MaxMintPerBatch_ = 10; //max mint per traction
883 
884 
885   string private _baseTokenURI;
886   uint public reserve = 0;
887 
888 
889   uint public status = 0; //0-pause 1-public
890 
891   constructor() ERC721A("Dirty Taco NFT","DT") {
892   }
893 
894   modifier callerIsUser() {
895     require(tx.origin == msg.sender, "The caller is another contract");
896     _;
897   }
898  
899   function mint(uint256 quantity) external payable callerIsUser {
900     require(status == 1 , "Sale is not Active");
901     require(totalSupply() + quantity <= TotalCollectionSize_-reserve, "reached max supply");
902     require(quantity <= MAX_PER_Transtion,"can not mint this many");
903     require(msg.value >= PRICE * quantity, "Need to send more ETH.");
904     _safeMint(msg.sender, quantity);
905   }
906 
907    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
908     require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
909     string memory baseURI = _baseURI();
910     return
911       bytes(baseURI).length > 0
912         ? string(abi.encodePacked(baseURI, "/", tokenId.toString(), ".json")) : "";
913         
914   }
915 
916   function setBaseURI(string memory baseURI) external onlyOwner {
917     _baseTokenURI = baseURI;
918   }
919   function _baseURI() internal view virtual override returns (string memory) {
920     return _baseTokenURI;
921   }
922   function numberMinted(address owner) public view returns (uint256) {
923     return _numberMinted(owner);
924   }
925   function getOwnershipData(uint256 tokenId)
926     external
927     view
928     returns (TokenOwnership memory)
929   {
930     return _ownershipOf(tokenId);
931   }
932 
933   function withdrawMoney() external onlyOwner nonReentrant {
934     (bool success, ) = msg.sender.call{value: address(this).balance}("");
935     require(success, "Transfer failed.");
936   }
937 
938   function changeMintPrice(uint256 _newPrice) external onlyOwner
939   {
940       PRICE = _newPrice;
941   }
942   function changeMAX_PER_Transtion(uint256 q) external onlyOwner
943   {
944       MAX_PER_Transtion = q;
945   }
946 
947   function setStatus(uint256 s)external onlyOwner{
948       status = s;
949   }
950 
951    function getStatus()public view returns(uint){
952       return status;
953   }
954 
955  function setReserveTokens(uint256 _quantity) public onlyOwner {
956         reserve=_quantity;
957     }
958     
959   function getPrice(uint256 _quantity) public view returns (uint256) {
960        
961         return _quantity*PRICE;
962     }
963 
964  function mintReserveTokens(uint quantity) public onlyOwner {
965         require(quantity <= reserve, "The quantity exceeds the reserve.");
966         reserve -= quantity;
967         _safeMint(msg.sender, quantity);
968 
969     }
970 
971   function airdrop(address a, uint q)public onlyOwner{
972     require(totalSupply() + q <= TotalCollectionSize_, "reached max supply");
973     require(q <= MAX_PER_Transtion,"can not mint this many");
974     _safeMint(a, q);
975   }
976 
977 }