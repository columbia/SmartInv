1 // SPDX-License-Identifier: GPL-3.0
2 
3 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
4 
5 pragma solidity ^0.8.0;
6 
7 abstract contract ReentrancyGuard {
8     uint256 private constant _NOT_ENTERED = 1;
9     uint256 private constant _ENTERED = 2;
10 
11     uint256 private _status;
12 
13     constructor() {
14         _status = _NOT_ENTERED;
15     }
16 
17     modifier nonReentrant() {
18         // On the first call to nonReentrant, _notEntered will be true
19         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
20 
21         // Any calls to nonReentrant after this point will fail
22         _status = _ENTERED;
23 
24         _;
25 
26         // By storing the original value once again, a refund is triggered (see
27         // https://eips.ethereum.org/EIPS/eip-2200)
28         _status = _NOT_ENTERED;
29     }
30 }
31 
32 // File: @openzeppelin/contracts/utils/Strings.sol
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev String operations.
38  */
39 library Strings {
40     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
41 
42     /**
43      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
44      */
45     function toString(uint256 value) internal pure returns (string memory) {
46         // Inspired by OraclizeAPI's implementation - MIT licence
47         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
48 
49         if (value == 0) {
50             return "0";
51         }
52         uint256 temp = value;
53         uint256 digits;
54         while (temp != 0) {
55             digits++;
56             temp /= 10;
57         }
58         bytes memory buffer = new bytes(digits);
59         while (value != 0) {
60             digits -= 1;
61             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
62             value /= 10;
63         }
64         return string(buffer);
65     }
66 
67     /**
68      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
69      */
70     function toHexString(uint256 value) internal pure returns (string memory) {
71         if (value == 0) {
72             return "0x00";
73         }
74         uint256 temp = value;
75         uint256 length = 0;
76         while (temp != 0) {
77             length++;
78             temp >>= 8;
79         }
80         return toHexString(value, length);
81     }
82 
83     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
84         bytes memory buffer = new bytes(2 * length + 2);
85         buffer[0] = "0";
86         buffer[1] = "x";
87         for (uint256 i = 2 * length + 1; i > 1; --i) {
88             buffer[i] = _HEX_SYMBOLS[value & 0xf];
89             value >>= 4;
90         }
91         require(value == 0, "Strings: hex length insufficient");
92         return string(buffer);
93     }
94 }
95 
96 // File: @openzeppelin/contracts/utils/Context.sol
97 
98 pragma solidity ^0.8.0;
99 
100 abstract contract Context {
101     function _msgSender() internal view virtual returns (address) {
102         return msg.sender;
103     }
104 
105     function _msgData() internal view virtual returns (bytes calldata) {
106         return msg.data;
107     }
108 }
109 
110 // File: @openzeppelin/contracts/access/Ownable.sol
111 
112 pragma solidity ^0.8.0;
113 
114 abstract contract Ownable is Context {
115     address private _owner;
116 
117     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
118 
119     /**
120      * @dev Initializes the contract setting the deployer as the initial owner.
121      */
122     constructor() {
123         _transferOwnership(_msgSender());
124     }
125 
126     /**
127      * @dev Returns the address of the current owner.
128      */
129     function owner() public view virtual returns (address) {
130         return _owner;
131     }
132 
133     /**
134      * @dev Throws if called by any account other than the owner.
135      */
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
150     /**
151      * @dev Transfers ownership of the contract to a new account (`newOwner`).
152      * Internal function without access restriction.
153      */
154     function _transferOwnership(address newOwner) internal virtual {
155         address oldOwner = _owner;
156         _owner = newOwner;
157         emit OwnershipTransferred(oldOwner, newOwner);
158     }
159 }
160 
161 // File: @openzeppelin/contracts/utils/Address.sol
162 
163 pragma solidity ^0.8.1;
164 
165 library Address {
166     function isContract(address account) internal view returns (bool) {
167         // This method relies on extcodesize/address.code.length, which returns 0
168         // for contracts in construction, since the code is only stored at the end
169         // of the constructor execution.
170 
171         return account.code.length > 0;
172     }
173 
174     function sendValue(address payable recipient, uint256 amount) internal {
175         require(address(this).balance >= amount, "Address: insufficient balance");
176 
177         (bool success, ) = recipient.call{value: amount}("");
178         require(success, "Address: unable to send value, recipient may have reverted");
179     }
180 
181     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
182         return functionCall(target, data, "Address: low-level call failed");
183     }
184 
185     function functionCall(
186         address target,
187         bytes memory data,
188         string memory errorMessage
189     ) internal returns (bytes memory) {
190         return functionCallWithValue(target, data, 0, errorMessage);
191     }
192 
193     function functionCallWithValue(
194         address target,
195         bytes memory data,
196         uint256 value
197     ) internal returns (bytes memory) {
198         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
199     }
200 
201     function functionCallWithValue(
202         address target,
203         bytes memory data,
204         uint256 value,
205         string memory errorMessage
206     ) internal returns (bytes memory) {
207         require(address(this).balance >= value, "Address: insufficient balance for call");
208         require(isContract(target), "Address: call to non-contract");
209 
210         (bool success, bytes memory returndata) = target.call{value: value}(data);
211         return verifyCallResult(success, returndata, errorMessage);
212     }
213 
214     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
215         return functionStaticCall(target, data, "Address: low-level static call failed");
216     }
217 
218     function functionStaticCall(
219         address target,
220         bytes memory data,
221         string memory errorMessage
222     ) internal view returns (bytes memory) {
223         require(isContract(target), "Address: static call to non-contract");
224 
225         (bool success, bytes memory returndata) = target.staticcall(data);
226         return verifyCallResult(success, returndata, errorMessage);
227     }
228 
229     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
230         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
231     }
232 
233     function functionDelegateCall(
234         address target,
235         bytes memory data,
236         string memory errorMessage
237     ) internal returns (bytes memory) {
238         require(isContract(target), "Address: delegate call to non-contract");
239 
240         (bool success, bytes memory returndata) = target.delegatecall(data);
241         return verifyCallResult(success, returndata, errorMessage);
242     }
243 
244     function verifyCallResult(
245         bool success,
246         bytes memory returndata,
247         string memory errorMessage
248     ) internal pure returns (bytes memory) {
249         if (success) {
250             return returndata;
251         } else {
252             // Look for revert reason and bubble it up if present
253             if (returndata.length > 0) {
254                 // The easiest way to bubble the revert reason is using memory via assembly
255 
256                 assembly {
257                     let returndata_size := mload(returndata)
258                     revert(add(32, returndata), returndata_size)
259                 }
260             } else {
261                 revert(errorMessage);
262             }
263         }
264     }
265 }
266 
267 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
268 
269 pragma solidity ^0.8.0;
270 
271 interface IERC721Receiver {
272     function onERC721Received(
273         address operator,
274         address from,
275         uint256 tokenId,
276         bytes calldata data
277     ) external returns (bytes4);
278 }
279 
280 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
281 
282 pragma solidity ^0.8.0;
283 
284 interface IERC165 {
285     function supportsInterface(bytes4 interfaceId) external view returns (bool);
286 }
287 
288 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
289 
290 pragma solidity ^0.8.0;
291 
292 abstract contract ERC165 is IERC165 {
293     /**
294      * @dev See {IERC165-supportsInterface}.
295      */
296     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
297         return interfaceId == type(IERC165).interfaceId;
298     }
299 }
300 
301 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
302 
303 pragma solidity ^0.8.0;
304 
305 /**
306  * @dev Required interface of an ERC721 compliant contract.
307  */
308 interface IERC721 is IERC165 {
309     /**
310      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
311      */
312     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
313 
314     /**
315      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
316      */
317     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
318 
319     /**
320      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
321      */
322     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
323 
324     /**
325      * @dev Returns the number of tokens in ``owner``'s account.
326      */
327     function balanceOf(address owner) external view returns (uint256 balance);
328 
329     function ownerOf(uint256 tokenId) external view returns (address owner);
330 
331     function safeTransferFrom(
332         address from,
333         address to,
334         uint256 tokenId
335     ) external;
336 
337     function transferFrom(
338         address from,
339         address to,
340         uint256 tokenId
341     ) external;
342 
343     function approve(address to, uint256 tokenId) external;
344 
345     function getApproved(uint256 tokenId) external view returns (address operator);
346 
347     function setApprovalForAll(address operator, bool _approved) external;
348 
349     function isApprovedForAll(address owner, address operator) external view returns (bool);
350 
351     function safeTransferFrom(
352         address from,
353         address to,
354         uint256 tokenId,
355         bytes calldata data
356     ) external;
357 }
358 
359 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
360 
361 pragma solidity ^0.8.0;
362 
363 interface IERC721Metadata is IERC721 {
364     /**
365      * @dev Returns the token collection name.
366      */
367     function name() external view returns (string memory);
368 
369     /**
370      * @dev Returns the token collection symbol.
371      */
372     function symbol() external view returns (string memory);
373 
374     /**
375      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
376      */
377     function tokenURI(uint256 tokenId) external view returns (string memory);
378 }
379 
380 // File: erc721a/contracts/IERC721A.sol
381 
382 pragma solidity ^0.8.4;
383 
384 /**
385  * @dev Interface of an ERC721A compliant contract.
386  */
387 interface IERC721A is IERC721, IERC721Metadata {
388     /**
389      * The caller must own the token or be an approved operator.
390      */
391     error ApprovalCallerNotOwnerNorApproved();
392 
393     /**
394      * The token does not exist.
395      */
396     error ApprovalQueryForNonexistentToken();
397 
398     /**
399      * The caller cannot approve to their own address.
400      */
401     error ApproveToCaller();
402 
403     /**
404      * The caller cannot approve to the current owner.
405      */
406     error ApprovalToCurrentOwner();
407 
408     /**
409      * Cannot query the balance for the zero address.
410      */
411     error BalanceQueryForZeroAddress();
412 
413     /**
414      * Cannot mint to the zero address.
415      */
416     error MintToZeroAddress();
417 
418     /**
419      * The quantity of tokens minted must be more than zero.
420      */
421     error MintZeroQuantity();
422 
423     /**
424      * The token does not exist.
425      */
426     error OwnerQueryForNonexistentToken();
427 
428     /**
429      * The caller must own the token or be an approved operator.
430      */
431     error TransferCallerNotOwnerNorApproved();
432 
433     /**
434      * The token must be owned by `from`.
435      */
436     error TransferFromIncorrectOwner();
437 
438     /**
439      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
440      */
441     error TransferToNonERC721ReceiverImplementer();
442 
443     /**
444      * Cannot transfer to the zero address.
445      */
446     error TransferToZeroAddress();
447 
448     /**
449      * The token does not exist.
450      */
451     error URIQueryForNonexistentToken();
452 
453     // Compiler will pack this into a single 256bit word.
454     struct TokenOwnership {
455         // The address of the owner.
456         address addr;
457         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
458         uint64 startTimestamp;
459         // Whether the token has been burned.
460         bool burned;
461     }
462 
463     // Compiler will pack this into a single 256bit word.
464     struct AddressData {
465         // Realistically, 2**64-1 is more than enough.
466         uint64 balance;
467         // Keeps track of mint count with minimal overhead for tokenomics.
468         uint64 numberMinted;
469         // Keeps track of burn count with minimal overhead for tokenomics.
470         uint64 numberBurned;
471         // For miscellaneous variable(s) pertaining to the address
472         // (e.g. number of whitelist mint slots used).
473         // If there are multiple variables, please pack them into a uint64.
474         uint64 aux;
475     }
476 
477     function totalSupply() external view returns (uint256);
478 }
479 
480 // File: erc721a/contracts/ERC721A.sol
481 
482 // ERC721A Contracts v3.3.0
483 pragma solidity ^0.8.4;
484 contract ERC721A is Context, ERC165, IERC721A {
485     using Address for address;
486     using Strings for uint256;
487 
488     // The tokenId of the next token to be minted.
489     uint256 internal _currentIndex;
490 
491     // The number of tokens burned.
492     uint256 internal _burnCounter;
493 
494     // Token name
495     string private _name;
496 
497     // Token symbol
498     string private _symbol;
499 
500     // Mapping from token ID to ownership details
501     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
502     mapping(uint256 => TokenOwnership) internal _ownerships;
503 
504     // Mapping owner address to address data
505     mapping(address => AddressData) private _addressData;
506 
507     // Mapping from token ID to approved address
508     mapping(uint256 => address) private _tokenApprovals;
509 
510     // Mapping from owner to operator approvals
511     mapping(address => mapping(address => bool)) private _operatorApprovals;
512 
513     constructor(string memory name_, string memory symbol_) {
514         _name = name_;
515         _symbol = symbol_;
516         _currentIndex = _startTokenId();
517     }
518 
519     /**
520      * To change the starting tokenId, please override this function.
521      */
522     function _startTokenId() internal view virtual returns (uint256) {
523         return 0;
524     }
525 
526     /**
527      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
528      */
529     function totalSupply() public view override returns (uint256) {
530         // Counter underflow is impossible as _burnCounter cannot be incremented
531         // more than _currentIndex - _startTokenId() times
532         unchecked {
533             return _currentIndex - _burnCounter - _startTokenId();
534         }
535     }
536 
537     /**
538      * Returns the total amount of tokens minted in the contract.
539      */
540     function _totalMinted() internal view returns (uint256) {
541         // Counter underflow is impossible as _currentIndex does not decrement,
542         // and it is initialized to _startTokenId()
543         unchecked {
544             return _currentIndex - _startTokenId();
545         }
546     }
547 
548     /**
549      * @dev See {IERC165-supportsInterface}.
550      */
551     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
552         return
553             interfaceId == type(IERC721).interfaceId ||
554             interfaceId == type(IERC721Metadata).interfaceId ||
555             super.supportsInterface(interfaceId);
556     }
557 
558     /**
559      * @dev See {IERC721-balanceOf}.
560      */
561     function balanceOf(address owner) public view override returns (uint256) {
562         if (owner == address(0)) revert BalanceQueryForZeroAddress();
563         return uint256(_addressData[owner].balance);
564     }
565 
566     /**
567      * Returns the number of tokens minted by `owner`.
568      */
569     function _numberMinted(address owner) internal view returns (uint256) {
570         return uint256(_addressData[owner].numberMinted);
571     }
572 
573     /**
574      * Returns the number of tokens burned by or on behalf of `owner`.
575      */
576     function _numberBurned(address owner) internal view returns (uint256) {
577         return uint256(_addressData[owner].numberBurned);
578     }
579 
580     /**
581      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
582      */
583     function _getAux(address owner) internal view returns (uint64) {
584         return _addressData[owner].aux;
585     }
586 
587     /**
588      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
589      * If there are multiple variables, please pack them into a uint64.
590      */
591     function _setAux(address owner, uint64 aux) internal {
592         _addressData[owner].aux = aux;
593     }
594 
595     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
596         uint256 curr = tokenId;
597 
598         unchecked {
599             if (_startTokenId() <= curr) if (curr < _currentIndex) {
600                 TokenOwnership memory ownership = _ownerships[curr];
601                 if (!ownership.burned) {
602                     if (ownership.addr != address(0)) {
603                         return ownership;
604                     }
605                     while (true) {
606                         curr--;
607                         ownership = _ownerships[curr];
608                         if (ownership.addr != address(0)) {
609                             return ownership;
610                         }
611                     }
612                 }
613             }
614         }
615         revert OwnerQueryForNonexistentToken();
616     }
617 
618     function ownerOf(uint256 tokenId) public view override returns (address) {
619         return _ownershipOf(tokenId).addr;
620     }
621 
622     /**
623      * @dev See {IERC721Metadata-name}.
624      */
625     function name() public view virtual override returns (string memory) {
626         return _name;
627     }
628 
629     function symbol() public view virtual override returns (string memory) {
630         return _symbol;
631     }
632 
633     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
634         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
635 
636         string memory baseURI = _baseURI();
637         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
638     }
639 
640     function _baseURI() internal view virtual returns (string memory) {
641         return '';
642     }
643 
644     /**
645      * @dev See {IERC721-approve}.
646      */
647     function approve(address to, uint256 tokenId) public override {
648         address owner = ERC721A.ownerOf(tokenId);
649         if (to == owner) revert ApprovalToCurrentOwner();
650 
651         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
652             revert ApprovalCallerNotOwnerNorApproved();
653         }
654 
655         _approve(to, tokenId, owner);
656     }
657 
658     function getApproved(uint256 tokenId) public view override returns (address) {
659         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
660 
661         return _tokenApprovals[tokenId];
662     }
663 
664     /**
665      * @dev See {IERC721-setApprovalForAll}.
666      */
667     function setApprovalForAll(address operator, bool approved) public virtual override {
668         if (operator == _msgSender()) revert ApproveToCaller();
669 
670         _operatorApprovals[_msgSender()][operator] = approved;
671         emit ApprovalForAll(_msgSender(), operator, approved);
672     }
673 
674     /**
675      * @dev See {IERC721-isApprovedForAll}.
676      */
677     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
678         return _operatorApprovals[owner][operator];
679     }
680 
681     function transferFrom(
682         address from,
683         address to,
684         uint256 tokenId
685     ) public virtual override {
686         _transfer(from, to, tokenId);
687     }
688 
689     function safeTransferFrom(
690         address from,
691         address to,
692         uint256 tokenId
693     ) public virtual override {
694         safeTransferFrom(from, to, tokenId, '');
695     }
696 
697     function safeTransferFrom(
698         address from,
699         address to,
700         uint256 tokenId,
701         bytes memory _data
702     ) public virtual override {
703         _transfer(from, to, tokenId);
704         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
705             revert TransferToNonERC721ReceiverImplementer();
706         }
707     }
708 
709     function _exists(uint256 tokenId) internal view returns (bool) {
710         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
711     }
712 
713     function _safeMint(address to, uint256 quantity) internal {
714         _safeMint(to, quantity, '');
715     }
716 
717     function _safeMint(
718         address to,
719         uint256 quantity,
720         bytes memory _data
721     ) internal {
722         uint256 startTokenId = _currentIndex;
723         if (to == address(0)) revert MintToZeroAddress();
724         if (quantity == 0) revert MintZeroQuantity();
725 
726         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
727 
728         // Overflows are incredibly unrealistic.
729         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
730         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
731         unchecked {
732             _addressData[to].balance += uint64(quantity);
733             _addressData[to].numberMinted += uint64(quantity);
734 
735             _ownerships[startTokenId].addr = to;
736             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
737 
738             uint256 updatedIndex = startTokenId;
739             uint256 end = updatedIndex + quantity;
740 
741             if (to.isContract()) {
742                 do {
743                     emit Transfer(address(0), to, updatedIndex);
744                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
745                         revert TransferToNonERC721ReceiverImplementer();
746                     }
747                 } while (updatedIndex < end);
748                 // Reentrancy protection
749                 if (_currentIndex != startTokenId) revert();
750             } else {
751                 do {
752                     emit Transfer(address(0), to, updatedIndex++);
753                 } while (updatedIndex < end);
754             }
755             _currentIndex = updatedIndex;
756         }
757         _afterTokenTransfers(address(0), to, startTokenId, quantity);
758     }
759 
760     function _mint(address to, uint256 quantity) internal {
761         uint256 startTokenId = _currentIndex;
762         if (to == address(0)) revert MintToZeroAddress();
763         if (quantity == 0) revert MintZeroQuantity();
764 
765         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
766 
767         // Overflows are incredibly unrealistic.
768         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
769         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
770         unchecked {
771             _addressData[to].balance += uint64(quantity);
772             _addressData[to].numberMinted += uint64(quantity);
773 
774             _ownerships[startTokenId].addr = to;
775             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
776 
777             uint256 updatedIndex = startTokenId;
778             uint256 end = updatedIndex + quantity;
779 
780             do {
781                 emit Transfer(address(0), to, updatedIndex++);
782             } while (updatedIndex < end);
783 
784             _currentIndex = updatedIndex;
785         }
786         _afterTokenTransfers(address(0), to, startTokenId, quantity);
787     }
788 
789     function _transfer(
790         address from,
791         address to,
792         uint256 tokenId
793     ) private {
794         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
795 
796         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
797 
798         bool isApprovedOrOwner = (_msgSender() == from ||
799             isApprovedForAll(from, _msgSender()) ||
800             getApproved(tokenId) == _msgSender());
801 
802         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
803         if (to == address(0)) revert TransferToZeroAddress();
804 
805         _beforeTokenTransfers(from, to, tokenId, 1);
806 
807         // Clear approvals from the previous owner
808         _approve(address(0), tokenId, from);
809 
810         // Underflow of the sender's balance is impossible because we check for
811         // ownership above and the recipient's balance can't realistically overflow.
812         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
813         unchecked {
814             _addressData[from].balance -= 1;
815             _addressData[to].balance += 1;
816 
817             TokenOwnership storage currSlot = _ownerships[tokenId];
818             currSlot.addr = to;
819             currSlot.startTimestamp = uint64(block.timestamp);
820 
821             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
822             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
823             uint256 nextTokenId = tokenId + 1;
824             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
825             if (nextSlot.addr == address(0)) {
826                 // This will suffice for checking _exists(nextTokenId),
827                 // as a burned slot cannot contain the zero address.
828                 if (nextTokenId != _currentIndex) {
829                     nextSlot.addr = from;
830                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
831                 }
832             }
833         }
834 
835         emit Transfer(from, to, tokenId);
836         _afterTokenTransfers(from, to, tokenId, 1);
837     }
838 
839     function _burn(uint256 tokenId) internal virtual {
840         _burn(tokenId, false);
841     }
842 
843     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
844         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
845 
846         address from = prevOwnership.addr;
847 
848         if (approvalCheck) {
849             bool isApprovedOrOwner = (_msgSender() == from ||
850                 isApprovedForAll(from, _msgSender()) ||
851                 getApproved(tokenId) == _msgSender());
852 
853             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
854         }
855 
856         _beforeTokenTransfers(from, address(0), tokenId, 1);
857 
858         // Clear approvals from the previous owner
859         _approve(address(0), tokenId, from);
860 
861         // Underflow of the sender's balance is impossible because we check for
862         // ownership above and the recipient's balance can't realistically overflow.
863         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
864         unchecked {
865             AddressData storage addressData = _addressData[from];
866             addressData.balance -= 1;
867             addressData.numberBurned += 1;
868 
869             // Keep track of who burned the token, and the timestamp of burning.
870             TokenOwnership storage currSlot = _ownerships[tokenId];
871             currSlot.addr = from;
872             currSlot.startTimestamp = uint64(block.timestamp);
873             currSlot.burned = true;
874 
875             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
876             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
877             uint256 nextTokenId = tokenId + 1;
878             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
879             if (nextSlot.addr == address(0)) {
880                 // This will suffice for checking _exists(nextTokenId),
881                 // as a burned slot cannot contain the zero address.
882                 if (nextTokenId != _currentIndex) {
883                     nextSlot.addr = from;
884                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
885                 }
886             }
887         }
888 
889         emit Transfer(from, address(0), tokenId);
890         _afterTokenTransfers(from, address(0), tokenId, 1);
891 
892         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
893         unchecked {
894             _burnCounter++;
895         }
896     }
897 
898     function _approve(
899         address to,
900         uint256 tokenId,
901         address owner
902     ) private {
903         _tokenApprovals[tokenId] = to;
904         emit Approval(owner, to, tokenId);
905     }
906 
907     function _checkContractOnERC721Received(
908         address from,
909         address to,
910         uint256 tokenId,
911         bytes memory _data
912     ) private returns (bool) {
913         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
914             return retval == IERC721Receiver(to).onERC721Received.selector;
915         } catch (bytes memory reason) {
916             if (reason.length == 0) {
917                 revert TransferToNonERC721ReceiverImplementer();
918             } else {
919                 assembly {
920                     revert(add(32, reason), mload(reason))
921                 }
922             }
923         }
924     }
925 
926     function _beforeTokenTransfers(
927         address from,
928         address to,
929         uint256 startTokenId,
930         uint256 quantity
931     ) internal virtual {}
932 
933     function _afterTokenTransfers(
934         address from,
935         address to,
936         uint256 startTokenId,
937         uint256 quantity
938     ) internal virtual {}
939 }
940 
941 // File: LilDoodz.sol
942 
943 pragma solidity >=0.7.0 <0.9.0;
944 
945 contract LilDoodz is ERC721A, Ownable, ReentrancyGuard {
946   using Strings for uint256;
947   string public baseURI;
948   string public baseExtension = "";
949   uint256 public cost = 0 ether;
950   uint256 public maxSupply = 4500;
951   bool public paused = false;
952   bool public revealed = true;
953   constructor(
954     string memory _initBaseURI
955   ) ERC721A("Lil Doodz", "DOODZ") {
956     setBaseURI(_initBaseURI);
957   }
958   function _baseURI() internal view virtual override returns (string memory) {
959     return baseURI;
960   }
961   function _startTokenId() internal view virtual override returns (uint256) {
962     return 1;
963   }
964   function mint(uint256 tokens) public payable nonReentrant {
965     require(!paused, "Lil Doodz: contract is paused");
966     uint256 supply = totalSupply();
967     require(tokens > 0, "Lil Doodz: need to mint at least 1 NFT");
968     require(supply + tokens <= maxSupply, "Lil Doodz: We Soldout");
969     require(msg.value >= cost * tokens, "Lil Doodz: insufficient funds");
970     require(
971             numberMinted(msg.sender) + tokens <= 20,
972             "this wallet cannot mint any more"
973         );
974       _safeMint(_msgSender(), tokens);
975   }
976   function gift(uint256 _mintAmount, address destination) public onlyOwner nonReentrant {
977     require(_mintAmount > 0, "need to mint at least 1 NFT");
978     uint256 supply = totalSupply();
979     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
980       _safeMint(destination, _mintAmount);
981   }
982   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
983     require(_exists(tokenId), "ERC721AMetadata: URI query for nonexistent token");
984     string memory currentBaseURI = _baseURI();
985     return bytes(currentBaseURI).length > 0
986       ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
987       : "";
988   }
989   function numberMinted(address owner) public view returns (uint256) {
990     return _numberMinted(owner);
991   }
992   function reveal(bool _state) public onlyOwner {
993     revealed = _state;
994   }
995   function setCost(uint256 _newCost) public onlyOwner {
996     cost = _newCost;
997   }
998   function setMaxsupply(uint256 _newsupply) public onlyOwner {
999     maxSupply = _newsupply;
1000   }
1001   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1002     baseURI = _newBaseURI;
1003   }
1004   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1005     baseExtension = _newBaseExtension;
1006   }
1007   function pause(bool _state) public onlyOwner {
1008     paused = _state;
1009   }
1010   function withdraw() external nonReentrant {
1011     uint balance = address(this).balance;
1012     payable(0xD9AF38402Ee322fd3Ae0D198A1FF8DCBc4c556C6).transfer((balance*100)/100);
1013   }
1014 }