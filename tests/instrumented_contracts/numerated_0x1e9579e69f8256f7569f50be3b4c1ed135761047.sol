1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.6;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         return msg.data;
11     }
12 }
13 
14 
15 library Strings {
16     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
17 
18     /**
19      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
20      */
21     function toString(uint256 value) internal pure returns (string memory) {
22         // Inspired by OraclizeAPI's implementation - MIT licence
23         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
24 
25         if (value == 0) {
26             return "0";
27         }
28         uint256 temp = value;
29         uint256 digits;
30         while (temp != 0) {
31             digits++;
32             temp /= 10;
33         }
34         bytes memory buffer = new bytes(digits);
35         while (value != 0) {
36             digits -= 1;
37             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
38             value /= 10;
39         }
40         return string(buffer);
41     }
42 
43     /**
44      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
45      */
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
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
61      */
62     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
63         bytes memory buffer = new bytes(2 * length + 2);
64         buffer[0] = "0";
65         buffer[1] = "x";
66         for (uint256 i = 2 * length + 1; i > 1; --i) {
67             buffer[i] = _HEX_SYMBOLS[value & 0xf];
68             value >>= 4;
69         }
70         require(value == 0, "Strings: hex length insufficient");
71         return string(buffer);
72     }
73 }
74 
75 
76 library Address {
77 
78     function isContract(address account) internal view returns (bool) {
79         // This method relies on extcodesize/address.code.length, which returns 0
80         // for contracts in construction, since the code is only stored at the end
81         // of the constructor execution.
82 
83         return account.code.length > 0;
84     }
85 
86     function sendValue(address payable recipient, uint256 amount) internal {
87         require(address(this).balance >= amount, "Address: insufficient balance");
88 
89         (bool success, ) = recipient.call{value: amount}("");
90         require(success, "Address: unable to send value, recipient may have reverted");
91     }
92 
93     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
94         return functionCall(target, data, "Address: low-level call failed");
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
99      * `errorMessage` as a fallback revert reason when `target` reverts.
100      *
101      * _Available since v3.1._
102      */
103     function functionCall(
104         address target,
105         bytes memory data,
106         string memory errorMessage
107     ) internal returns (bytes memory) {
108         return functionCallWithValue(target, data, 0, errorMessage);
109     }
110 
111     function functionCallWithValue(
112         address target,
113         bytes memory data,
114         uint256 value
115     ) internal returns (bytes memory) {
116         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
117     }
118 
119 
120     function functionCallWithValue(
121         address target,
122         bytes memory data,
123         uint256 value,
124         string memory errorMessage
125     ) internal returns (bytes memory) {
126         require(address(this).balance >= value, "Address: insufficient balance for call");
127         require(isContract(target), "Address: call to non-contract");
128 
129         (bool success, bytes memory returndata) = target.call{value: value}(data);
130         return verifyCallResult(success, returndata, errorMessage);
131     }
132 
133 
134     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
135         return functionStaticCall(target, data, "Address: low-level static call failed");
136     }
137 
138     function functionStaticCall(
139         address target,
140         bytes memory data,
141         string memory errorMessage
142     ) internal view returns (bytes memory) {
143         require(isContract(target), "Address: static call to non-contract");
144 
145         (bool success, bytes memory returndata) = target.staticcall(data);
146         return verifyCallResult(success, returndata, errorMessage);
147     }
148 
149     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
150         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
151     }
152 
153     function functionDelegateCall(
154         address target,
155         bytes memory data,
156         string memory errorMessage
157     ) internal returns (bytes memory) {
158         require(isContract(target), "Address: delegate call to non-contract");
159 
160         (bool success, bytes memory returndata) = target.delegatecall(data);
161         return verifyCallResult(success, returndata, errorMessage);
162     }
163 
164     function verifyCallResult(
165         bool success,
166         bytes memory returndata,
167         string memory errorMessage
168     ) internal pure returns (bytes memory) {
169         if (success) {
170             return returndata;
171         } else {
172             // Look for revert reason and bubble it up if present
173             if (returndata.length > 0) {
174                 // The easiest way to bubble the revert reason is using memory via assembly
175 
176                 assembly {
177                     let returndata_size := mload(returndata)
178                     revert(add(32, returndata), returndata_size)
179                 }
180             } else {
181                 revert(errorMessage);
182             }
183         }
184     }
185 }
186 
187 
188 abstract contract ReentrancyGuard {
189     // Booleans are more expensive than uint256 or any type that takes up a full
190     // word because each write operation emits an extra SLOAD to first read the
191     // slot's contents, replace the bits taken up by the boolean, and then write
192     // back. This is the compiler's defense against contract upgrades and
193     // pointer aliasing, and it cannot be disabled.
194 
195     // The values being non-zero value makes deployment a bit more expensive,
196     // but in exchange the refund on every call to nonReentrant will be lower in
197     // amount. Since refunds are capped to a percentage of the total
198     // transaction's gas, it is best to keep them low in cases like this one, to
199     // increase the likelihood of the full refund coming into effect.
200     uint256 private constant _NOT_ENTERED = 1;
201     uint256 private constant _ENTERED = 2;
202 
203     uint256 private _status;
204 
205     constructor() {
206         _status = _NOT_ENTERED;
207     }
208 
209     /**
210      * @dev Prevents a contract from calling itself, directly or indirectly.
211      * Calling a `nonReentrant` function from another `nonReentrant`
212      * function is not supported. It is possible to prevent this from happening
213      * by making the `nonReentrant` function external, and making it call a
214      * `private` function that does the actual work.
215      */
216     modifier nonReentrant() {
217         // On the first call to nonReentrant, _notEntered will be true
218         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
219 
220         // Any calls to nonReentrant after this point will fail
221         _status = _ENTERED;
222 
223         _;
224 
225         // By storing the original value once again, a refund is triggered (see
226         // https://eips.ethereum.org/EIPS/eip-2200)
227         _status = _NOT_ENTERED;
228     }
229 }
230 
231 
232 abstract contract Ownable is Context {
233     address private _owner;
234 
235     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
236 
237     /**
238      * @dev Initializes the contract setting the deployer as the initial owner.
239      */
240     constructor() {
241         _transferOwnership(_msgSender());
242     }
243 
244     /**
245      * @dev Returns the address of the current owner.
246      */
247     function owner() public view virtual returns (address) {
248         return _owner;
249     }
250 
251     /**
252      * @dev Throws if called by any account other than the owner.
253      */
254     modifier onlyOwner() {
255         require(owner() == _msgSender(), "Ownable: caller is not the owner");
256         _;
257     }
258 
259     /**
260      * @dev Leaves the contract without owner. It will not be possible to call
261      * `onlyOwner` functions anymore. Can only be called by the current owner.
262      *
263      * NOTE: Renouncing ownership will leave the contract without an owner,
264      * thereby removing any functionality that is only available to the owner.
265      */
266     function renounceOwnership() public virtual onlyOwner {
267         _transferOwnership(address(0));
268     }
269 
270     /**
271      * @dev Transfers ownership of the contract to a new account (`newOwner`).
272      * Can only be called by the current owner.
273      */
274     function transferOwnership(address newOwner) public virtual onlyOwner {
275         require(newOwner != address(0), "Ownable: new owner is the zero address");
276         _transferOwnership(newOwner);
277     }
278 
279     function _transferOwnership(address newOwner) internal virtual {
280         address oldOwner = _owner;
281         _owner = newOwner;
282         emit OwnershipTransferred(oldOwner, newOwner);
283     }
284 }
285 
286 
287 interface IERC165 {
288     function supportsInterface(bytes4 interfaceId) external view returns (bool);
289 }
290 
291 abstract contract ERC165 is IERC165 {
292 
293     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
294         return interfaceId == type(IERC165).interfaceId;
295     }
296 }
297 
298 
299 interface IERC721 is IERC165 {
300     /**
301      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
302      */
303     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
304 
305     /**
306      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
307      */
308     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
309 
310     /**
311      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
312      */
313     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
314 
315     /**
316      * @dev Returns the number of tokens in ``owner``'s account.
317      */
318     function balanceOf(address owner) external view returns (uint256 balance);
319 
320     function ownerOf(uint256 tokenId) external view returns (address owner);
321 
322     function safeTransferFrom(
323         address from,
324         address to,
325         uint256 tokenId,
326         bytes calldata data
327     ) external;
328 
329 
330     function safeTransferFrom(
331         address from,
332         address to,
333         uint256 tokenId
334     ) external;
335 
336     function transferFrom(
337         address from,
338         address to,
339         uint256 tokenId
340     ) external;
341 
342     function approve(address to, uint256 tokenId) external;
343 
344     function setApprovalForAll(address operator, bool _approved) external;
345 
346     function getApproved(uint256 tokenId) external view returns (address operator);
347 
348     function isApprovedForAll(address owner, address operator) external view returns (bool);
349 }
350 
351 
352 interface IERC721Receiver {
353 
354     function onERC721Received(
355         address operator,
356         address from,
357         uint256 tokenId,
358         bytes calldata data
359     ) external returns (bytes4);
360 }
361 
362 interface IERC721Metadata is IERC721 {
363     /**
364      * @dev Returns the token collection name.
365      */
366     function name() external view returns (string memory);
367 
368     /**
369      * @dev Returns the token collection symbol.
370      */
371     function symbol() external view returns (string memory);
372 
373     /**
374      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
375      */
376     function tokenURI(uint256 tokenId) external view returns (string memory);
377 }
378 
379 
380 /**
381  * @dev Interface of an ERC721A compliant contract.
382  */
383 interface IERC721A is IERC721, IERC721Metadata {
384     /**
385      * The caller must own the token or be an approved operator.
386      */
387     error ApprovalCallerNotOwnerNorApproved();
388 
389     /**
390      * The token does not exist.
391      */
392     error ApprovalQueryForNonexistentToken();
393 
394     /**
395      * The caller cannot approve to their own address.
396      */
397     error ApproveToCaller();
398 
399     /**
400      * The caller cannot approve to the current owner.
401      */
402     error ApprovalToCurrentOwner();
403 
404     /**
405      * Cannot query the balance for the zero address.
406      */
407     error BalanceQueryForZeroAddress();
408 
409     /**
410      * Cannot mint to the zero address.
411      */
412     error MintToZeroAddress();
413 
414     /**
415      * The quantity of tokens minted must be more than zero.
416      */
417     error MintZeroQuantity();
418 
419     /**
420      * The token does not exist.
421      */
422     error OwnerQueryForNonexistentToken();
423 
424     /**
425      * The caller must own the token or be an approved operator.
426      */
427     error TransferCallerNotOwnerNorApproved();
428 
429     /**
430      * The token must be owned by `from`.
431      */
432     error TransferFromIncorrectOwner();
433 
434     /**
435      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
436      */
437     error TransferToNonERC721ReceiverImplementer();
438 
439     /**
440      * Cannot transfer to the zero address.
441      */
442     error TransferToZeroAddress();
443 
444     /**
445      * The token does not exist.
446      */
447     error URIQueryForNonexistentToken();
448 
449     // Compiler will pack this into a single 256bit word.
450     struct TokenOwnership {
451         // The address of the owner.
452         address addr;
453         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
454         uint64 startTimestamp;
455         // Whether the token has been burned.
456         bool burned;
457     }
458 
459     // Compiler will pack this into a single 256bit word.
460     struct AddressData {
461         // Realistically, 2**64-1 is more than enough.
462         uint64 balance;
463         // Keeps track of mint count with minimal overhead for tokenomics.
464         uint64 numberMinted;
465         // Keeps track of burn count with minimal overhead for tokenomics.
466         uint64 numberBurned;
467         // For miscellaneous variable(s) pertaining to the address
468         // (e.g. number of whitelist mint slots used).
469         // If there are multiple variables, please pack them into a uint64.
470         uint64 aux;
471     }
472 
473     /**
474      * @dev Returns the total amount of tokens stored by the contract.
475      * 
476      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
477      */
478     function totalSupply() external view returns (uint256);
479 }
480 
481 
482 contract ERC721A is Context, ERC165, IERC721A {
483     using Address for address;
484     using Strings for uint256;
485 
486     // The tokenId of the next token to be minted.
487     uint256 internal _currentIndex;
488 
489     // The number of tokens burned.
490     uint256 internal _burnCounter;
491 
492     // Token name
493     string private _name;
494 
495     // Token symbol
496     string private _symbol;
497 
498     // Mapping from token ID to ownership details
499     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
500     mapping(uint256 => TokenOwnership) internal _ownerships;
501 
502     // Mapping owner address to address data
503     mapping(address => AddressData) private _addressData;
504 
505     // Mapping from token ID to approved address
506     mapping(uint256 => address) private _tokenApprovals;
507 
508     // Mapping from owner to operator approvals
509     mapping(address => mapping(address => bool)) private _operatorApprovals;
510 
511     constructor(string memory name_, string memory symbol_) {
512         _name = name_;
513         _symbol = symbol_;
514         _currentIndex = _startTokenId();
515     }
516 
517     /**
518      * To change the starting tokenId, please override this function.
519      */
520     function _startTokenId() internal view virtual returns (uint256) {
521         return 0;
522     }
523 
524     /**
525      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
526      */
527     function totalSupply() public view override returns (uint256) {
528         // Counter underflow is impossible as _burnCounter cannot be incremented
529         // more than _currentIndex - _startTokenId() times
530         unchecked {
531             return _currentIndex - _burnCounter - _startTokenId();
532         }
533     }
534 
535     /**
536      * Returns the total amount of tokens minted in the contract.
537      */
538     function _totalMinted() internal view returns (uint256) {
539         // Counter underflow is impossible as _currentIndex does not decrement,
540         // and it is initialized to _startTokenId()
541         unchecked {
542             return _currentIndex - _startTokenId();
543         }
544     }
545 
546     /**
547      * @dev See {IERC165-supportsInterface}.
548      */
549     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
550         return
551             interfaceId == type(IERC721).interfaceId ||
552             interfaceId == type(IERC721Metadata).interfaceId ||
553             super.supportsInterface(interfaceId);
554     }
555 
556     /**
557      * @dev See {IERC721-balanceOf}.
558      */
559     function balanceOf(address owner) public view override returns (uint256) {
560         if (owner == address(0)) revert BalanceQueryForZeroAddress();
561         return uint256(_addressData[owner].balance);
562     }
563 
564     /**
565      * Returns the number of tokens minted by `owner`.
566      */
567     function _numberMinted(address owner) internal view returns (uint256) {
568         return uint256(_addressData[owner].numberMinted);
569     }
570 
571     /**
572      * Returns the number of tokens burned by or on behalf of `owner`.
573      */
574     function _numberBurned(address owner) internal view returns (uint256) {
575         return uint256(_addressData[owner].numberBurned);
576     }
577 
578     /**
579      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
580      */
581     function _getAux(address owner) internal view returns (uint64) {
582         return _addressData[owner].aux;
583     }
584 
585     /**
586      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
587      * If there are multiple variables, please pack them into a uint64.
588      */
589     function _setAux(address owner, uint64 aux) internal {
590         _addressData[owner].aux = aux;
591     }
592 
593     /**
594      * Gas spent here starts off proportional to the maximum mint batch size.
595      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
596      */
597     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
598         uint256 curr = tokenId;
599 
600         unchecked {
601             if (_startTokenId() <= curr) if (curr < _currentIndex) {
602                 TokenOwnership memory ownership = _ownerships[curr];
603                 if (!ownership.burned) {
604                     if (ownership.addr != address(0)) {
605                         return ownership;
606                     }
607                     // Invariant:
608                     // There will always be an ownership that has an address and is not burned
609                     // before an ownership that does not have an address and is not burned.
610                     // Hence, curr will not underflow.
611                     while (true) {
612                         curr--;
613                         ownership = _ownerships[curr];
614                         if (ownership.addr != address(0)) {
615                             return ownership;
616                         }
617                     }
618                 }
619             }
620         }
621         revert OwnerQueryForNonexistentToken();
622     }
623 
624     /**
625      * @dev See {IERC721-ownerOf}.
626      */
627     function ownerOf(uint256 tokenId) public view override returns (address) {
628         return _ownershipOf(tokenId).addr;
629     }
630 
631     /**
632      * @dev See {IERC721Metadata-name}.
633      */
634     function name() public view virtual override returns (string memory) {
635         return _name;
636     }
637 
638     /**
639      * @dev See {IERC721Metadata-symbol}.
640      */
641     function symbol() public view virtual override returns (string memory) {
642         return _symbol;
643     }
644 
645     /**
646      * @dev See {IERC721Metadata-tokenURI}.
647      */
648     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
649         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
650 
651         string memory baseURI = _baseURI();
652         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
653     }
654 
655     function _baseURI() internal view virtual returns (string memory) {
656         return '';
657     }
658 
659     /**
660      * @dev See {IERC721-approve}.
661      */
662     function approve(address to, uint256 tokenId) public override {
663         address owner = ERC721A.ownerOf(tokenId);
664         if (to == owner) revert ApprovalToCurrentOwner();
665 
666         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
667             revert ApprovalCallerNotOwnerNorApproved();
668         }
669 
670         _approve(to, tokenId, owner);
671     }
672 
673     /**
674      * @dev See {IERC721-getApproved}.
675      */
676     function getApproved(uint256 tokenId) public view override returns (address) {
677         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
678 
679         return _tokenApprovals[tokenId];
680     }
681 
682     /**
683      * @dev See {IERC721-setApprovalForAll}.
684      */
685     function setApprovalForAll(address operator, bool approved) public virtual override {
686         if (operator == _msgSender()) revert ApproveToCaller();
687 
688         _operatorApprovals[_msgSender()][operator] = approved;
689         emit ApprovalForAll(_msgSender(), operator, approved);
690     }
691 
692     /**
693      * @dev See {IERC721-isApprovedForAll}.
694      */
695     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
696         return _operatorApprovals[owner][operator];
697     }
698 
699     /**
700      * @dev See {IERC721-transferFrom}.
701      */
702     function transferFrom(
703         address from,
704         address to,
705         uint256 tokenId
706     ) public virtual override {
707         _transfer(from, to, tokenId);
708     }
709 
710     /**
711      * @dev See {IERC721-safeTransferFrom}.
712      */
713     function safeTransferFrom(
714         address from,
715         address to,
716         uint256 tokenId
717     ) public virtual override {
718         safeTransferFrom(from, to, tokenId, '');
719     }
720 
721     /**
722      * @dev See {IERC721-safeTransferFrom}.
723      */
724     function safeTransferFrom(
725         address from,
726         address to,
727         uint256 tokenId,
728         bytes memory _data
729     ) public virtual override {
730         _transfer(from, to, tokenId);
731         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
732             revert TransferToNonERC721ReceiverImplementer();
733         }
734     }
735 
736     function _exists(uint256 tokenId) internal view returns (bool) {
737         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
738     }
739 
740     /**
741      * @dev Equivalent to `_safeMint(to, quantity, '')`.
742      */
743     function _safeMint(address to, uint256 quantity) internal {
744         _safeMint(to, quantity, '');
745     }
746 
747     function _safeMint(
748         address to,
749         uint256 quantity,
750         bytes memory _data
751     ) internal {
752         uint256 startTokenId = _currentIndex;
753         if (to == address(0)) revert MintToZeroAddress();
754         if (quantity == 0) revert MintZeroQuantity();
755 
756         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
757 
758         // Overflows are incredibly unrealistic.
759         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
760         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
761         unchecked {
762             _addressData[to].balance += uint64(quantity);
763             _addressData[to].numberMinted += uint64(quantity);
764 
765             _ownerships[startTokenId].addr = to;
766             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
767 
768             uint256 updatedIndex = startTokenId;
769             uint256 end = updatedIndex + quantity;
770 
771             if (to.isContract()) {
772                 do {
773                     emit Transfer(address(0), to, updatedIndex);
774                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
775                         revert TransferToNonERC721ReceiverImplementer();
776                     }
777                 } while (updatedIndex < end);
778                 // Reentrancy protection
779                 if (_currentIndex != startTokenId) revert();
780             } else {
781                 do {
782                     emit Transfer(address(0), to, updatedIndex++);
783                 } while (updatedIndex < end);
784             }
785             _currentIndex = updatedIndex;
786         }
787         _afterTokenTransfers(address(0), to, startTokenId, quantity);
788     }
789 
790 
791     function _mint(address to, uint256 quantity) internal {
792         uint256 startTokenId = _currentIndex;
793         if (to == address(0)) revert MintToZeroAddress();
794         if (quantity == 0) revert MintZeroQuantity();
795 
796         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
797 
798         // Overflows are incredibly unrealistic.
799         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
800         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
801         unchecked {
802             _addressData[to].balance += uint64(quantity);
803             _addressData[to].numberMinted += uint64(quantity);
804 
805             _ownerships[startTokenId].addr = to;
806             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
807 
808             uint256 updatedIndex = startTokenId;
809             uint256 end = updatedIndex + quantity;
810 
811             do {
812                 emit Transfer(address(0), to, updatedIndex++);
813             } while (updatedIndex < end);
814 
815             _currentIndex = updatedIndex;
816         }
817         _afterTokenTransfers(address(0), to, startTokenId, quantity);
818     }
819 
820     function _transfer(
821         address from,
822         address to,
823         uint256 tokenId
824     ) private {
825         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
826 
827         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
828 
829         bool isApprovedOrOwner = (_msgSender() == from ||
830             isApprovedForAll(from, _msgSender()) ||
831             getApproved(tokenId) == _msgSender());
832 
833         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
834         if (to == address(0)) revert TransferToZeroAddress();
835 
836         _beforeTokenTransfers(from, to, tokenId, 1);
837 
838         // Clear approvals from the previous owner
839         _approve(address(0), tokenId, from);
840 
841         // Underflow of the sender's balance is impossible because we check for
842         // ownership above and the recipient's balance can't realistically overflow.
843         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
844         unchecked {
845             _addressData[from].balance -= 1;
846             _addressData[to].balance += 1;
847 
848             TokenOwnership storage currSlot = _ownerships[tokenId];
849             currSlot.addr = to;
850             currSlot.startTimestamp = uint64(block.timestamp);
851 
852             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
853             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
854             uint256 nextTokenId = tokenId + 1;
855             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
856             if (nextSlot.addr == address(0)) {
857                 // This will suffice for checking _exists(nextTokenId),
858                 // as a burned slot cannot contain the zero address.
859                 if (nextTokenId != _currentIndex) {
860                     nextSlot.addr = from;
861                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
862                 }
863             }
864         }
865 
866         emit Transfer(from, to, tokenId);
867         _afterTokenTransfers(from, to, tokenId, 1);
868     }
869 
870     /**
871      * @dev Equivalent to `_burn(tokenId, false)`.
872      */
873     function _burn(uint256 tokenId) internal virtual {
874         _burn(tokenId, false);
875     }
876 
877     /**
878      * @dev Destroys `tokenId`.
879      * The approval is cleared when the token is burned.
880      *
881      * Requirements:
882      *
883      * - `tokenId` must exist.
884      *
885      * Emits a {Transfer} event.
886      */
887     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
888         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
889 
890         address from = prevOwnership.addr;
891 
892         if (approvalCheck) {
893             bool isApprovedOrOwner = (_msgSender() == from ||
894                 isApprovedForAll(from, _msgSender()) ||
895                 getApproved(tokenId) == _msgSender());
896 
897             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
898         }
899 
900         _beforeTokenTransfers(from, address(0), tokenId, 1);
901 
902         // Clear approvals from the previous owner
903         _approve(address(0), tokenId, from);
904 
905         // Underflow of the sender's balance is impossible because we check for
906         // ownership above and the recipient's balance can't realistically overflow.
907         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
908         unchecked {
909             AddressData storage addressData = _addressData[from];
910             addressData.balance -= 1;
911             addressData.numberBurned += 1;
912 
913             // Keep track of who burned the token, and the timestamp of burning.
914             TokenOwnership storage currSlot = _ownerships[tokenId];
915             currSlot.addr = from;
916             currSlot.startTimestamp = uint64(block.timestamp);
917             currSlot.burned = true;
918 
919             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
920             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
921             uint256 nextTokenId = tokenId + 1;
922             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
923             if (nextSlot.addr == address(0)) {
924                 // This will suffice for checking _exists(nextTokenId),
925                 // as a burned slot cannot contain the zero address.
926                 if (nextTokenId != _currentIndex) {
927                     nextSlot.addr = from;
928                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
929                 }
930             }
931         }
932 
933         emit Transfer(from, address(0), tokenId);
934         _afterTokenTransfers(from, address(0), tokenId, 1);
935 
936         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
937         unchecked {
938             _burnCounter++;
939         }
940     }
941 
942     /**
943      * @dev Approve `to` to operate on `tokenId`
944      *
945      * Emits a {Approval} event.
946      */
947     function _approve(
948         address to,
949         uint256 tokenId,
950         address owner
951     ) private {
952         _tokenApprovals[tokenId] = to;
953         emit Approval(owner, to, tokenId);
954     }
955 
956     /**
957      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
958      *
959      * @param from address representing the previous owner of the given token ID
960      * @param to target address that will receive the tokens
961      * @param tokenId uint256 ID of the token to be transferred
962      * @param _data bytes optional data to send along with the call
963      * @return bool whether the call correctly returned the expected magic value
964      */
965     function _checkContractOnERC721Received(
966         address from,
967         address to,
968         uint256 tokenId,
969         bytes memory _data
970     ) private returns (bool) {
971         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
972             return retval == IERC721Receiver(to).onERC721Received.selector;
973         } catch (bytes memory reason) {
974             if (reason.length == 0) {
975                 revert TransferToNonERC721ReceiverImplementer();
976             } else {
977                 assembly {
978                     revert(add(32, reason), mload(reason))
979                 }
980             }
981         }
982     }
983 
984     /**
985      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
986      * And also called before burning one token.
987      *
988      * startTokenId - the first token id to be transferred
989      * quantity - the amount to be transferred
990      *
991      * Calling conditions:
992      *
993      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
994      * transferred to `to`.
995      * - When `from` is zero, `tokenId` will be minted for `to`.
996      * - When `to` is zero, `tokenId` will be burned by `from`.
997      * - `from` and `to` are never both zero.
998      */
999     function _beforeTokenTransfers(
1000         address from,
1001         address to,
1002         uint256 startTokenId,
1003         uint256 quantity
1004     ) internal virtual {}
1005 
1006     /**
1007      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1008      * minting.
1009      * And also called after one token has been burned.
1010      *
1011      * startTokenId - the first token id to be transferred
1012      * quantity - the amount to be transferred
1013      *
1014      * Calling conditions:
1015      *
1016      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1017      * transferred to `to`.
1018      * - When `from` is zero, `tokenId` has been minted for `to`.
1019      * - When `to` is zero, `tokenId` has been burned by `from`.
1020      * - `from` and `to` are never both zero.
1021      */
1022     function _afterTokenTransfers(
1023         address from,
1024         address to,
1025         uint256 startTokenId,
1026         uint256 quantity
1027     ) internal virtual {}
1028 }
1029 
1030 
1031 contract NFT is ERC721A("Who is the murderer V2", "WTM"), Ownable, ReentrancyGuard {
1032 
1033     uint256 public constant BUY_LIMIT_PER_TX = 20;
1034     uint256 public constant MAX_NFT_PUBLIC = 9500;
1035     uint256 private constant MAX_NFT = 10000;
1036     bool public isActive;
1037     string internal baseTokenURI = "https://bafybeia3wyn3bs6mfszn4xpbwmpyqffkoqjcrcrmwasdrs7q6vdrljoh6m.ipfs.nftstorage.link/";
1038 
1039     
1040     function setBaseTokenURI(string calldata _uri) external onlyOwner {
1041         baseTokenURI = _uri;
1042     }
1043 
1044     function _baseURI() internal override view returns (string memory) {
1045         return baseTokenURI;
1046     }
1047 
1048     /*
1049      * Function setIsActive to activate/desactivate the smart contract
1050     */
1051     function setIsActive(bool _isActive) external onlyOwner {
1052         isActive = _isActive;
1053     }
1054    
1055     /*
1056      * Function to mint new NFTs during the public sale
1057      * It is payable. Amount is calculated as per (NFTPrice.mul(_numOfTokens))
1058     */
1059     function mintNFT(uint256 _numOfTokens)public payable{
1060         require(isActive, 'Contract is not active');
1061         require(balanceOf(msg.sender) + _numOfTokens <= BUY_LIMIT_PER_TX, "Cannot mint above limit");
1062         _mintTo(msg.sender, _numOfTokens);
1063     }
1064 
1065     
1066     /*
1067      * Function to mint NFTs for partnerships
1068     */
1069     function mintByOwner(address _to, uint256 _numOfTokens) external onlyOwner{
1070         require((totalSupply() + _numOfTokens) < (MAX_NFT - MAX_NFT_PUBLIC), "Exceeds Total Supply");
1071         _mintTo(_to, _numOfTokens);
1072     }
1073 
1074     function _mintTo(address to, uint _numberToken) internal {
1075         require(_numberToken + totalSupply() <= MAX_NFT, "Exceeds Total Supply");
1076         _mint(to, _numberToken);
1077     }
1078 
1079      /*
1080      * Function to withdraw collected amount during minting by the owner
1081     */
1082     function withdraw() public onlyOwner {
1083         uint balance = address(this).balance;
1084 
1085         require(balance > 0, "Balance should be more then zero");
1086         payable(msg.sender).transfer(balance);
1087     }
1088     
1089     
1090 }