1 // SPDX-License-Identifier: GPL-3.0
2 
3 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
4 
5 
6 // ⎝⎝✧GͥOͣDͫ✧⎠⎠ ⟦D⟧⟦E⟧⟦A⟧⟦T⟧⟦H⟧ ⟦D⟧⟦A⟧⟦T⟧⟦E⟧ ⟦N⟧⟦F⟧⟦T⟧ ⎝⎝✧GͥOͣDͫ✧⎠⎠
7 
8 pragma solidity ^0.8.0;
9 
10 abstract contract ReentrancyGuard {
11     
12     uint256 private constant _NOT_ENTERED = 1;
13     uint256 private constant _ENTERED = 2;
14 
15     uint256 private _status;
16 
17     constructor() {
18         _status = _NOT_ENTERED;
19     }
20 
21     modifier nonReentrant() {
22         // On the first call to nonReentrant, _notEntered will be true
23         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
24 
25         // Any calls to nonReentrant after this point will fail
26         _status = _ENTERED;
27 
28         _;
29 
30         _status = _NOT_ENTERED;
31     }
32 }
33 
34 
35 // File: @openzeppelin/contracts/utils/Strings.sol
36 
37 
38 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
39 
40 pragma solidity ^0.8.0;
41 
42 /**
43  * @dev String operations.
44  */
45 library Strings {
46     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
47 
48     function toString(uint256 value) internal pure returns (string memory) {
49 
50         if (value == 0) {
51             return "0";
52         }
53         uint256 temp = value;
54         uint256 digits;
55         while (temp != 0) {
56             digits++;
57             temp /= 10;
58         }
59         bytes memory buffer = new bytes(digits);
60         while (value != 0) {
61             digits -= 1;
62             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
63             value /= 10;
64         }
65         return string(buffer);
66     }
67 
68     /**
69      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
70      */
71     function toHexString(uint256 value) internal pure returns (string memory) {
72         if (value == 0) {
73             return "0x00";
74         }
75         uint256 temp = value;
76         uint256 length = 0;
77         while (temp != 0) {
78             length++;
79             temp >>= 8;
80         }
81         return toHexString(value, length);
82     }
83 
84     /**
85      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
86      */
87     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
88         bytes memory buffer = new bytes(2 * length + 2);
89         buffer[0] = "0";
90         buffer[1] = "x";
91         for (uint256 i = 2 * length + 1; i > 1; --i) {
92             buffer[i] = _HEX_SYMBOLS[value & 0xf];
93             value >>= 4;
94         }
95         require(value == 0, "Strings: hex length insufficient");
96         return string(buffer);
97     }
98 }
99 
100 // File: @openzeppelin/contracts/utils/Context.sol
101 
102 
103 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
104 
105 pragma solidity ^0.8.0;
106 
107 abstract contract Context {
108     function _msgSender() internal view virtual returns (address) {
109         return msg.sender;
110     }
111 
112     function _msgData() internal view virtual returns (bytes calldata) {
113         return msg.data;
114     }
115 }
116 
117 
118 // File: @openzeppelin/contracts/access/Ownable.sol
119 
120 pragma solidity ^0.8.0;
121 
122 abstract contract Ownable is Context {
123     address private _owner;
124 
125     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
126 
127     /**
128      * @dev Initializes the contract setting the deployer as the initial owner.
129      */
130     constructor() {
131         _transferOwnership(_msgSender());
132     }
133 
134     /**
135      * @dev Returns the address of the current owner.
136      */
137     function owner() public view virtual returns (address) {
138         return _owner;
139     }
140 
141     /**
142      * @dev Throws if called by any account other than the owner.
143      */
144     modifier onlyOwner() {
145         require(owner() == _msgSender(), "Ownable: caller is not the owner");
146         _;
147     }
148 
149     /**
150      * @dev Leaves the contract without owner. It will not be possible to call
151      * `onlyOwner` functions anymore. Can only be called by the current owner.
152      *
153      * NOTE: Renouncing ownership will leave the contract without an owner,
154      * thereby removing any functionality that is only available to the owner.
155      */
156     function renounceOwnership() public virtual onlyOwner {
157         _transferOwnership(address(0));
158     }
159 
160     /**
161      * @dev Transfers ownership of the contract to a new account (`newOwner`).
162      * Can only be called by the current owner.
163      */
164     function transferOwnership(address newOwner) public virtual onlyOwner {
165         require(newOwner != address(0), "Ownable: new owner is the zero address");
166         _transferOwnership(newOwner);
167     }
168 
169     /**
170      * @dev Transfers ownership of the contract to a new account (`newOwner`).
171      * Internal function without access restriction.
172      */
173     function _transferOwnership(address newOwner) internal virtual {
174         address oldOwner = _owner;
175         _owner = newOwner;
176         emit OwnershipTransferred(oldOwner, newOwner);
177     }
178 }
179 
180 // File: @openzeppelin/contracts/utils/Address.sol
181 
182 
183 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
184 
185 pragma solidity ^0.8.1;
186 
187 /**
188  * @dev Collection of functions related to the address type
189  */
190 library Address {
191     
192     function isContract(address account) internal view returns (bool) {
193         return account.code.length > 0;
194     }
195 
196     function sendValue(address payable recipient, uint256 amount) internal {
197         require(address(this).balance >= amount, "Address: insufficient balance");
198 
199         (bool success, ) = recipient.call{value: amount}("");
200         require(success, "Address: unable to send value, recipient may have reverted");
201     }
202 
203     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
204         return functionCall(target, data, "Address: low-level call failed");
205     }
206 
207     function functionCall(
208         address target,
209         bytes memory data,
210         string memory errorMessage
211     ) internal returns (bytes memory) {
212         return functionCallWithValue(target, data, 0, errorMessage);
213     }
214 
215     function functionCallWithValue(
216         address target,
217         bytes memory data,
218         uint256 value
219     ) internal returns (bytes memory) {
220         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
221     }
222 
223     function functionCallWithValue(
224         address target,
225         bytes memory data,
226         uint256 value,
227         string memory errorMessage
228     ) internal returns (bytes memory) {
229         require(address(this).balance >= value, "Address: insufficient balance for call");
230         require(isContract(target), "Address: call to non-contract");
231 
232         (bool success, bytes memory returndata) = target.call{value: value}(data);
233         return verifyCallResult(success, returndata, errorMessage);
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
238      * but performing a static call.
239      *
240      * _Available since v3.3._
241      */
242     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
243         return functionStaticCall(target, data, "Address: low-level static call failed");
244     }
245 
246     /**
247      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
248      * but performing a static call.
249      *
250      * _Available since v3.3._
251      */
252     function functionStaticCall(
253         address target,
254         bytes memory data,
255         string memory errorMessage
256     ) internal view returns (bytes memory) {
257         require(isContract(target), "Address: static call to non-contract");
258 
259         (bool success, bytes memory returndata) = target.staticcall(data);
260         return verifyCallResult(success, returndata, errorMessage);
261     }
262 
263     /**
264      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
265      * but performing a delegate call.
266      *
267      * _Available since v3.4._
268      */
269     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
270         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
271     }
272 
273     /**
274      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
275      * but performing a delegate call.
276      *
277      * _Available since v3.4._
278      */
279     function functionDelegateCall(
280         address target,
281         bytes memory data,
282         string memory errorMessage
283     ) internal returns (bytes memory) {
284         require(isContract(target), "Address: delegate call to non-contract");
285 
286         (bool success, bytes memory returndata) = target.delegatecall(data);
287         return verifyCallResult(success, returndata, errorMessage);
288     }
289 
290     /**
291      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
292      * revert reason using the provided one.
293      *
294      * _Available since v4.3._
295      */
296     function verifyCallResult(
297         bool success,
298         bytes memory returndata,
299         string memory errorMessage
300     ) internal pure returns (bytes memory) {
301         if (success) {
302             return returndata;
303         } else {
304             // Look for revert reason and bubble it up if present
305             if (returndata.length > 0) {
306                 // The easiest way to bubble the revert reason is using memory via assembly
307 
308                 assembly {
309                     let returndata_size := mload(returndata)
310                     revert(add(32, returndata), returndata_size)
311                 }
312             } else {
313                 revert(errorMessage);
314             }
315         }
316     }
317 }
318 
319 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
320 
321 
322 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
323 
324 pragma solidity ^0.8.0;
325 
326 interface IERC721Receiver {
327   
328     function onERC721Received(
329         address operator,
330         address from,
331         uint256 tokenId,
332         bytes calldata data
333     ) external returns (bytes4);
334 }
335 
336 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
337 
338 
339 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
340 
341 pragma solidity ^0.8.0;
342 
343 /**
344  * @dev Interface of the ERC165 standard, as defined in the
345  * https://eips.ethereum.org/EIPS/eip-165[EIP].
346  *
347  * Implementers can declare support of contract interfaces, which can then be
348  * queried by others ({ERC165Checker}).
349  *
350  * For an implementation, see {ERC165}.
351  */
352 interface IERC165 {
353     function supportsInterface(bytes4 interfaceId) external view returns (bool);
354 }
355 
356 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
357 
358 
359 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
360 
361 pragma solidity ^0.8.0;
362 
363 abstract contract ERC165 is IERC165 {
364     /**
365      * @dev See {IERC165-supportsInterface}.
366      */
367     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
368         return interfaceId == type(IERC165).interfaceId;
369     }
370 }
371 
372 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
373 
374 
375 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
376 
377 pragma solidity ^0.8.0;
378 
379 
380 /**
381  * @dev Required interface of an ERC721 compliant contract.
382  */
383 interface IERC721 is IERC165 {
384     /**
385      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
386      */
387     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
388 
389     /**
390      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
391      */
392     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
393 
394     /**
395      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
396      */
397     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
398 
399     /**
400      * @dev Returns the number of tokens in ``owner``'s account.
401      */
402     function balanceOf(address owner) external view returns (uint256 balance);
403 
404   
405     function ownerOf(uint256 tokenId) external view returns (address owner);
406 
407 
408     function safeTransferFrom(
409         address from,
410         address to,
411         uint256 tokenId,
412         bytes calldata data
413     ) external;
414 
415   
416     function safeTransferFrom(
417         address from,
418         address to,
419         uint256 tokenId
420     ) external;
421 
422  
423     function transferFrom(
424         address from,
425         address to,
426         uint256 tokenId
427     ) external;
428 
429 
430     function approve(address to, uint256 tokenId) external;
431 
432 
433     function setApprovalForAll(address operator, bool _approved) external;
434 
435 
436     function getApproved(uint256 tokenId) external view returns (address operator);
437 
438     /**
439      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
440      *
441      * See {setApprovalForAll}
442      */
443     function isApprovedForAll(address owner, address operator) external view returns (bool);
444 }
445 
446 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
447 
448 
449 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
450 
451 pragma solidity ^0.8.0;
452 
453 
454 /**
455  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
456  * @dev See https://eips.ethereum.org/EIPS/eip-721
457  */
458 interface IERC721Metadata is IERC721 {
459     /**
460      * @dev Returns the token collection name.
461      */
462     function name() external view returns (string memory);
463 
464     /**
465      * @dev Returns the token collection symbol.
466      */
467     function symbol() external view returns (string memory);
468 
469     /**
470      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
471      */
472     function tokenURI(uint256 tokenId) external view returns (string memory);
473 }
474 
475 // File: erc721a/contracts/IERC721A.sol
476 
477 
478 // ERC721A Contracts v3.3.0
479 // Creator: Chiru Labs
480 
481 pragma solidity ^0.8.4;
482 
483 
484 
485 /**
486  * @dev Interface of an ERC721A compliant contract.
487  */
488 interface IERC721A is IERC721, IERC721Metadata {
489     /**
490      * The caller must own the token or be an approved operator.
491      */
492     error ApprovalCallerNotOwnerNorApproved();
493 
494     /**
495      * The token does not exist.
496      */
497     error ApprovalQueryForNonexistentToken();
498 
499     /**
500      * The caller cannot approve to their own address.
501      */
502     error ApproveToCaller();
503 
504     /**
505      * The caller cannot approve to the current owner.
506      */
507     error ApprovalToCurrentOwner();
508 
509     /**
510      * Cannot query the balance for the zero address.
511      */
512     error BalanceQueryForZeroAddress();
513 
514     /**
515      * Cannot mint to the zero address.
516      */
517     error MintToZeroAddress();
518 
519     /**
520      * The quantity of tokens minted must be more than zero.
521      */
522     error MintZeroQuantity();
523 
524     /**
525      * The token does not exist.
526      */
527     error OwnerQueryForNonexistentToken();
528 
529     /**
530      * The caller must own the token or be an approved operator.
531      */
532     error TransferCallerNotOwnerNorApproved();
533 
534     /**
535      * The token must be owned by `from`.
536      */
537     error TransferFromIncorrectOwner();
538 
539     /**
540      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
541      */
542     error TransferToNonERC721ReceiverImplementer();
543 
544     /**
545      * Cannot transfer to the zero address.
546      */
547     error TransferToZeroAddress();
548 
549     /**
550      * The token does not exist.
551      */
552     error URIQueryForNonexistentToken();
553 
554     // Compiler will pack this into a single 256bit word.
555     struct TokenOwnership {
556         // The address of the owner.
557         address addr;
558         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
559         uint64 startTimestamp;
560         // Whether the token has been burned.
561         bool burned;
562     }
563 
564     // Compiler will pack this into a single 256bit word.
565     struct AddressData {
566         // Realistically, 2**64-1 is more than enough.
567         uint64 balance;
568         // Keeps track of mint count with minimal overhead for tokenomics.
569         uint64 numberMinted;
570         // Keeps track of burn count with minimal overhead for tokenomics.
571         uint64 numberBurned;
572         // For miscellaneous variable(s) pertaining to the address
573         // (e.g. number of whitelist mint slots used).
574         // If there are multiple variables, please pack them into a uint64.
575         uint64 aux;
576     }
577 
578     /**
579      * @dev Returns the total amount of tokens stored by the contract.
580      * 
581      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
582      */
583     function totalSupply() external view returns (uint256);
584 }
585 
586 
587 // File: erc721a/contracts/ERC721A.sol
588 
589 // ERC721A Contracts v3.3.0
590 // Creator: Chiru Labs
591 
592 pragma solidity ^0.8.4;
593 
594 /**
595  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
596  * the Metadata extension. Built to optimize for lower gas during batch mints.
597  *
598  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
599  *
600  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
601  *
602  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
603  */
604 contract ERC721A is Context, ERC165, IERC721A {
605     using Address for address;
606     using Strings for uint256;
607 
608     // The tokenId of the next token to be minted.
609     uint256 internal _currentIndex;
610 
611     // The number of tokens burned.
612     uint256 internal _burnCounter;
613 
614     // Token name
615     string private _name;
616 
617     // Token symbol
618     string private _symbol;
619 
620     // Mapping from token ID to ownership details
621     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
622     mapping(uint256 => TokenOwnership) internal _ownerships;
623 
624     // Mapping owner address to address data
625     mapping(address => AddressData) private _addressData;
626 
627     // Mapping from token ID to approved address
628     mapping(uint256 => address) private _tokenApprovals;
629 
630     // Mapping from owner to operator approvals
631     mapping(address => mapping(address => bool)) private _operatorApprovals;
632 
633     constructor(string memory name_, string memory symbol_) {
634         _name = name_;
635         _symbol = symbol_;
636         _currentIndex = _startTokenId();
637     }
638 
639     /**
640      * To change the starting tokenId, please override this function.
641      */
642     function _startTokenId() internal view virtual returns (uint256) {
643         return 0;
644     }
645 
646     /**
647      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
648      */
649     function totalSupply() public view override returns (uint256) {
650         // Counter underflow is impossible as _burnCounter cannot be incremented
651         // more than _currentIndex - _startTokenId() times
652         unchecked {
653             return _currentIndex - _burnCounter - _startTokenId();
654         }
655     }
656 
657     /**
658      * Returns the total amount of tokens minted in the contract.
659      */
660     function _totalMinted() internal view returns (uint256) {
661         // Counter underflow is impossible as _currentIndex does not decrement,
662         // and it is initialized to _startTokenId()
663         unchecked {
664             return _currentIndex - _startTokenId();
665         }
666     }
667 
668     /**
669      * @dev See {IERC165-supportsInterface}.
670      */
671     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
672         return
673             interfaceId == type(IERC721).interfaceId ||
674             interfaceId == type(IERC721Metadata).interfaceId ||
675             super.supportsInterface(interfaceId);
676     }
677 
678     /**
679      * @dev See {IERC721-balanceOf}.
680      */
681     function balanceOf(address owner) public view override returns (uint256) {
682         if (owner == address(0)) revert BalanceQueryForZeroAddress();
683         return uint256(_addressData[owner].balance);
684     }
685 
686     /**
687      * Returns the number of tokens minted by `owner`.
688      */
689     function _numberMinted(address owner) internal view returns (uint256) {
690         return uint256(_addressData[owner].numberMinted);
691     }
692 
693     /**
694      * Returns the number of tokens burned by or on behalf of `owner`.
695      */
696     function _numberBurned(address owner) internal view returns (uint256) {
697         return uint256(_addressData[owner].numberBurned);
698     }
699 
700     /**
701      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
702      */
703     function _getAux(address owner) internal view returns (uint64) {
704         return _addressData[owner].aux;
705     }
706 
707     /**
708      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
709      * If there are multiple variables, please pack them into a uint64.
710      */
711     function _setAux(address owner, uint64 aux) internal {
712         _addressData[owner].aux = aux;
713     }
714 
715     /**
716      * Gas spent here starts off proportional to the maximum mint batch size.
717      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
718      */
719     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
720         uint256 curr = tokenId;
721 
722         unchecked {
723             if (_startTokenId() <= curr) if (curr < _currentIndex) {
724                 TokenOwnership memory ownership = _ownerships[curr];
725                 if (!ownership.burned) {
726                     if (ownership.addr != address(0)) {
727                         return ownership;
728                     }
729                     // Invariant:
730                     // There will always be an ownership that has an address and is not burned
731                     // before an ownership that does not have an address and is not burned.
732                     // Hence, curr will not underflow.
733                     while (true) {
734                         curr--;
735                         ownership = _ownerships[curr];
736                         if (ownership.addr != address(0)) {
737                             return ownership;
738                         }
739                     }
740                 }
741             }
742         }
743         revert OwnerQueryForNonexistentToken();
744     }
745 
746     /**
747      * @dev See {IERC721-ownerOf}.
748      */
749     function ownerOf(uint256 tokenId) public view override returns (address) {
750         return _ownershipOf(tokenId).addr;
751     }
752 
753     /**
754      * @dev See {IERC721Metadata-name}.
755      */
756     function name() public view virtual override returns (string memory) {
757         return _name;
758     }
759 
760     /**
761      * @dev See {IERC721Metadata-symbol}.
762      */
763     function symbol() public view virtual override returns (string memory) {
764         return _symbol;
765     }
766 
767     /**
768      * @dev See {IERC721Metadata-tokenURI}.
769      */
770     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
771         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
772 
773         string memory baseURI = _baseURI();
774         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
775     }
776 
777     /**
778      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
779      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
780      * by default, can be overriden in child contracts.
781      */
782     function _baseURI() internal view virtual returns (string memory) {
783         return '';
784     }
785 
786     /**
787      * @dev See {IERC721-approve}.
788      */
789     function approve(address to, uint256 tokenId) public override {
790         address owner = ERC721A.ownerOf(tokenId);
791         if (to == owner) revert ApprovalToCurrentOwner();
792 
793         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
794             revert ApprovalCallerNotOwnerNorApproved();
795         }
796 
797         _approve(to, tokenId, owner);
798     }
799 
800     /**
801      * @dev See {IERC721-getApproved}.
802      */
803     function getApproved(uint256 tokenId) public view override returns (address) {
804         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
805 
806         return _tokenApprovals[tokenId];
807     }
808 
809     /**
810      * @dev See {IERC721-setApprovalForAll}.
811      */
812     function setApprovalForAll(address operator, bool approved) public virtual override {
813         if (operator == _msgSender()) revert ApproveToCaller();
814 
815         _operatorApprovals[_msgSender()][operator] = approved;
816         emit ApprovalForAll(_msgSender(), operator, approved);
817     }
818 
819     /**
820      * @dev See {IERC721-isApprovedForAll}.
821      */
822     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
823         return _operatorApprovals[owner][operator];
824     }
825 
826     /**
827      * @dev See {IERC721-transferFrom}.
828      */
829     function transferFrom(
830         address from,
831         address to,
832         uint256 tokenId
833     ) public virtual override {
834         _transfer(from, to, tokenId);
835     }
836 
837     /**
838      * @dev See {IERC721-safeTransferFrom}.
839      */
840     function safeTransferFrom(
841         address from,
842         address to,
843         uint256 tokenId
844     ) public virtual override {
845         safeTransferFrom(from, to, tokenId, '');
846     }
847 
848     /**
849      * @dev See {IERC721-safeTransferFrom}.
850      */
851     function safeTransferFrom(
852         address from,
853         address to,
854         uint256 tokenId,
855         bytes memory _data
856     ) public virtual override {
857         _transfer(from, to, tokenId);
858         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
859             revert TransferToNonERC721ReceiverImplementer();
860         }
861     }
862 
863     /**
864      * @dev Returns whether `tokenId` exists.
865      *
866      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
867      *
868      * Tokens start existing when they are minted (`_mint`),
869      */
870     function _exists(uint256 tokenId) internal view returns (bool) {
871         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
872     }
873 
874     /**
875      * @dev Equivalent to `_safeMint(to, quantity, '')`.
876      */
877     function _safeMint(address to, uint256 quantity) internal {
878         _safeMint(to, quantity, '');
879     }
880 
881     /**
882      * @dev Safely mints `quantity` tokens and transfers them to `to`.
883      *
884      * Requirements:
885      *
886      * - If `to` refers to a smart contract, it must implement
887      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
888      * - `quantity` must be greater than 0.
889      *
890      * Emits a {Transfer} event.
891      */
892     function _safeMint(
893         address to,
894         uint256 quantity,
895         bytes memory _data
896     ) internal {
897         uint256 startTokenId = _currentIndex;
898         if (to == address(0)) revert MintToZeroAddress();
899         if (quantity == 0) revert MintZeroQuantity();
900 
901         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
902 
903         // Overflows are incredibly unrealistic.
904         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
905         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
906         unchecked {
907             _addressData[to].balance += uint64(quantity);
908             _addressData[to].numberMinted += uint64(quantity);
909 
910             _ownerships[startTokenId].addr = to;
911             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
912 
913             uint256 updatedIndex = startTokenId;
914             uint256 end = updatedIndex + quantity;
915 
916             if (to.isContract()) {
917                 do {
918                     emit Transfer(address(0), to, updatedIndex);
919                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
920                         revert TransferToNonERC721ReceiverImplementer();
921                     }
922                 } while (updatedIndex < end);
923                 // Reentrancy protection
924                 if (_currentIndex != startTokenId) revert();
925             } else {
926                 do {
927                     emit Transfer(address(0), to, updatedIndex++);
928                 } while (updatedIndex < end);
929             }
930             _currentIndex = updatedIndex;
931         }
932         _afterTokenTransfers(address(0), to, startTokenId, quantity);
933     }
934 
935     /**
936      * @dev Mints `quantity` tokens and transfers them to `to`.
937      *
938      * Requirements:
939      *
940      * - `to` cannot be the zero address.
941      * - `quantity` must be greater than 0.
942      *
943      * Emits a {Transfer} event.
944      */
945     function _mint(address to, uint256 quantity) internal {
946         uint256 startTokenId = _currentIndex;
947         if (to == address(0)) revert MintToZeroAddress();
948         if (quantity == 0) revert MintZeroQuantity();
949 
950         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
951 
952         // Overflows are incredibly unrealistic.
953         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
954         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
955         unchecked {
956             _addressData[to].balance += uint64(quantity);
957             _addressData[to].numberMinted += uint64(quantity);
958 
959             _ownerships[startTokenId].addr = to;
960             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
961 
962             uint256 updatedIndex = startTokenId;
963             uint256 end = updatedIndex + quantity;
964 
965             do {
966                 emit Transfer(address(0), to, updatedIndex++);
967             } while (updatedIndex < end);
968 
969             _currentIndex = updatedIndex;
970         }
971         _afterTokenTransfers(address(0), to, startTokenId, quantity);
972     }
973 
974     /**
975      * @dev Transfers `tokenId` from `from` to `to`.
976      *
977      * Requirements:
978      *
979      * - `to` cannot be the zero address.
980      * - `tokenId` token must be owned by `from`.
981      *
982      * Emits a {Transfer} event.
983      */
984     function _transfer(
985         address from,
986         address to,
987         uint256 tokenId
988     ) private {
989         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
990 
991         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
992 
993         bool isApprovedOrOwner = (_msgSender() == from ||
994             isApprovedForAll(from, _msgSender()) ||
995             getApproved(tokenId) == _msgSender());
996 
997         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
998         if (to == address(0)) revert TransferToZeroAddress();
999 
1000         _beforeTokenTransfers(from, to, tokenId, 1);
1001 
1002         // Clear approvals from the previous owner
1003         _approve(address(0), tokenId, from);
1004 
1005         // Underflow of the sender's balance is impossible because we check for
1006         // ownership above and the recipient's balance can't realistically overflow.
1007         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1008         unchecked {
1009             _addressData[from].balance -= 1;
1010             _addressData[to].balance += 1;
1011 
1012             TokenOwnership storage currSlot = _ownerships[tokenId];
1013             currSlot.addr = to;
1014             currSlot.startTimestamp = uint64(block.timestamp);
1015 
1016             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1017             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1018             uint256 nextTokenId = tokenId + 1;
1019             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1020             if (nextSlot.addr == address(0)) {
1021                 // This will suffice for checking _exists(nextTokenId),
1022                 // as a burned slot cannot contain the zero address.
1023                 if (nextTokenId != _currentIndex) {
1024                     nextSlot.addr = from;
1025                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1026                 }
1027             }
1028         }
1029 
1030         emit Transfer(from, to, tokenId);
1031         _afterTokenTransfers(from, to, tokenId, 1);
1032     }
1033 
1034     /**
1035      * @dev Equivalent to `_burn(tokenId, false)`.
1036      */
1037     function _burn(uint256 tokenId) internal virtual {
1038         _burn(tokenId, false);
1039     }
1040 
1041     /**
1042      * @dev Destroys `tokenId`.
1043      * The approval is cleared when the token is burned.
1044      *
1045      * Requirements:
1046      *
1047      * - `tokenId` must exist.
1048      *
1049      * Emits a {Transfer} event.
1050      */
1051     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1052         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1053 
1054         address from = prevOwnership.addr;
1055 
1056         if (approvalCheck) {
1057             bool isApprovedOrOwner = (_msgSender() == from ||
1058                 isApprovedForAll(from, _msgSender()) ||
1059                 getApproved(tokenId) == _msgSender());
1060 
1061             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1062         }
1063 
1064         _beforeTokenTransfers(from, address(0), tokenId, 1);
1065 
1066         // Clear approvals from the previous owner
1067         _approve(address(0), tokenId, from);
1068 
1069         // Underflow of the sender's balance is impossible because we check for
1070         // ownership above and the recipient's balance can't realistically overflow.
1071         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1072         unchecked {
1073             AddressData storage addressData = _addressData[from];
1074             addressData.balance -= 1;
1075             addressData.numberBurned += 1;
1076 
1077             // Keep track of who burned the token, and the timestamp of burning.
1078             TokenOwnership storage currSlot = _ownerships[tokenId];
1079             currSlot.addr = from;
1080             currSlot.startTimestamp = uint64(block.timestamp);
1081             currSlot.burned = true;
1082 
1083             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1084             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1085             uint256 nextTokenId = tokenId + 1;
1086             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1087             if (nextSlot.addr == address(0)) {
1088                 // This will suffice for checking _exists(nextTokenId),
1089                 // as a burned slot cannot contain the zero address.
1090                 if (nextTokenId != _currentIndex) {
1091                     nextSlot.addr = from;
1092                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1093                 }
1094             }
1095         }
1096 
1097         emit Transfer(from, address(0), tokenId);
1098         _afterTokenTransfers(from, address(0), tokenId, 1);
1099 
1100         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1101         unchecked {
1102             _burnCounter++;
1103         }
1104     }
1105 
1106     /**
1107      * @dev Approve `to` to operate on `tokenId`
1108      *
1109      * Emits a {Approval} event.
1110      */
1111     function _approve(
1112         address to,
1113         uint256 tokenId,
1114         address owner
1115     ) private {
1116         _tokenApprovals[tokenId] = to;
1117         emit Approval(owner, to, tokenId);
1118     }
1119 
1120 
1121     function _checkContractOnERC721Received(
1122         address from,
1123         address to,
1124         uint256 tokenId,
1125         bytes memory _data
1126     ) private returns (bool) {
1127         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1128             return retval == IERC721Receiver(to).onERC721Received.selector;
1129         } catch (bytes memory reason) {
1130             if (reason.length == 0) {
1131                 revert TransferToNonERC721ReceiverImplementer();
1132             } else {
1133                 assembly {
1134                     revert(add(32, reason), mload(reason))
1135                 }
1136             }
1137         }
1138     }
1139 
1140  
1141     function _beforeTokenTransfers(
1142         address from,
1143         address to,
1144         uint256 startTokenId,
1145         uint256 quantity
1146     ) internal virtual {}
1147 
1148 
1149     function _afterTokenTransfers(
1150         address from,
1151         address to,
1152         uint256 startTokenId,
1153         uint256 quantity
1154     ) internal virtual {}
1155 }
1156 
1157 
1158 // File: contracts/deathdate.sol
1159 
1160 // Death Date NFT
1161 
1162 pragma solidity >= 0.8.0 < 0.9.0;
1163 
1164 contract DEATH_DATE_NFT is ERC721A, Ownable, ReentrancyGuard {
1165 
1166   using Strings for uint256;
1167 
1168   string public uriPrefix;
1169   string public notRevealedURI;
1170   string public uriSuffix = ".json";
1171   
1172   uint256 public cost = 0 ether;
1173   uint256 public maxSupply = 7777;
1174   uint256 public MaxperTx = 20;
1175   uint256 public nftPerAddressLimit = 100;
1176 
1177   bool public paused = true;
1178   bool public revealed = false;
1179 
1180   mapping(address => uint256) public addressMintedBalance;
1181 
1182 
1183   constructor() ERC721A ( "Death Date NFT", "DDN" ) {
1184     setNotRevealedURI( "ipfs://QmfBLKSPW8rSnjSGXQs26p34VaYR6rz1vu2LdhkDSfjUWz/hidden.json" );
1185   }
1186 
1187 
1188   // MODIFIERS
1189   modifier mintCompliance(uint256 _mintAmount) {
1190     require(!paused, "The contract is paused!");
1191     require(_mintAmount > 0, "Mint amount can't be zero.");
1192     require(tx.origin == msg.sender, "The caller is another contract");
1193     require(_mintAmount <= MaxperTx, "Max mint per transaction exceeded!");
1194     require(addressMintedBalance[msg.sender] + _mintAmount <= nftPerAddressLimit, "Max mint amount per address exceeded!");
1195     require(totalSupply() + _mintAmount <= maxSupply, "Mint amount exceeds max supply!");
1196     _;
1197   }
1198 
1199   modifier mintPriceCompliance(uint256 _mintAmount) {
1200     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1201     _;
1202   }
1203 
1204 
1205   //URIs
1206   function _baseURI() internal view virtual override returns (string memory) {
1207     return uriPrefix;
1208   }
1209 
1210 
1211   // PUBLIC MINT
1212   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1213     addressMintedBalance[msg.sender] += _mintAmount;
1214     _safeMint(_msgSender(), _mintAmount);
1215   }
1216 
1217   // MINT for address
1218   function mintToAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1219     require(totalSupply() + _mintAmount <= maxSupply, "Mint amount exceeds max supply!");
1220     _safeMint(_receiver, _mintAmount);
1221   }
1222 
1223 
1224   // Check Wallet assets
1225   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1226     uint256 ownerTokenCount = balanceOf(_owner);
1227     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1228     uint256 currentTokenId = _startTokenId();
1229     uint256 ownedTokenIndex = 0;
1230     address latestOwnerAddress;
1231 
1232     while (ownedTokenIndex < ownerTokenCount && currentTokenId < _currentIndex) {
1233       TokenOwnership memory ownership = _ownerships[currentTokenId];
1234 
1235       if (!ownership.burned) {
1236         if (ownership.addr != address(0)) {
1237           latestOwnerAddress = ownership.addr;
1238         }
1239 
1240         if (latestOwnerAddress == _owner) {
1241           ownedTokenIds[ownedTokenIndex] = currentTokenId;
1242           ownedTokenIndex++;
1243         }
1244       }
1245       currentTokenId++;
1246     }
1247     return ownedTokenIds;
1248   }
1249 
1250 
1251   // Start Token
1252   function _startTokenId() internal view virtual override returns (uint256) {
1253     return 1;
1254   }
1255 
1256   // TOKEN URI <= If you are reading this you are awesome!!
1257   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1258     require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token.");
1259     
1260     if (revealed == false) { return notRevealedURI; }
1261 
1262     string memory currentBaseURI = _baseURI();
1263     return bytes(currentBaseURI).length > 0
1264     ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1265     : "";
1266     }
1267 
1268 
1269   // Only owner
1270   function setCost(uint256 _cost) public onlyOwner {
1271     cost = _cost;
1272   }
1273 
1274   function setMaxperTx(uint256 _maxMintperTx) public onlyOwner {
1275     MaxperTx = _maxMintperTx;
1276   }
1277 
1278   // BaseURI
1279   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1280     uriPrefix = _uriPrefix;
1281   }
1282 
1283   // NotRevealedURI
1284   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1285     notRevealedURI = _notRevealedURI;
1286   }
1287 
1288   function pause() public onlyOwner {
1289     if (paused == true) { paused = false; }
1290     else { paused = true; }
1291   }
1292 
1293   function reveal() public onlyOwner {
1294     if (revealed == true) { revealed = false; }
1295     else { revealed = true; }
1296   }
1297 
1298   function withdraw() external onlyOwner nonReentrant {
1299     (bool success, ) = payable(owner()).call{value: address(this).balance}("");
1300     require(success);
1301   }
1302 }