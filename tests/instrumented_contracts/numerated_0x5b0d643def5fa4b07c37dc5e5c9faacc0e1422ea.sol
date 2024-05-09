1 // SPDX-License-Identifier: GPL-3.0
2 
3 /*
4 
5 ########   #######   ######   ##       #### ######## ##    ##  ######  
6 ##     ## ##     ## ##    ##  ##        ##  ##       ###   ## ##    ## 
7 ##     ## ##     ## ##        ##        ##  ##       ####  ## ##       
8 ##     ## ##     ## ##   #### ##        ##  ######   ## ## ##  ######  
9 ##     ## ##     ## ##    ##  ##        ##  ##       ##  ####       ## 
10 ##     ## ##     ## ##    ##  ##        ##  ##       ##   ### ##    ## 
11 ########   #######   ######   ######## #### ######## ##    ##  ######  
12 
13 */
14 
15 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
16 
17 pragma solidity ^0.8.0;
18 
19 abstract contract ReentrancyGuard {
20     
21     uint256 private constant _NOT_ENTERED = 1;
22     uint256 private constant _ENTERED = 2;
23 
24     uint256 private _status;
25 
26     constructor() {
27         _status = _NOT_ENTERED;
28     }
29 
30     modifier nonReentrant() {
31         // On the first call to nonReentrant, _notEntered will be true
32         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
33 
34         // Any calls to nonReentrant after this point will fail
35         _status = _ENTERED;
36 
37         _;
38 
39         _status = _NOT_ENTERED;
40     }
41 }
42 
43 
44 // File: @openzeppelin/contracts/utils/Strings.sol
45 
46 
47 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
48 
49 pragma solidity ^0.8.0;
50 
51 /**
52  * @dev String operations.
53  */
54 library Strings {
55     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
56 
57     function toString(uint256 value) internal pure returns (string memory) {
58 
59         if (value == 0) {
60             return "0";
61         }
62         uint256 temp = value;
63         uint256 digits;
64         while (temp != 0) {
65             digits++;
66             temp /= 10;
67         }
68         bytes memory buffer = new bytes(digits);
69         while (value != 0) {
70             digits -= 1;
71             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
72             value /= 10;
73         }
74         return string(buffer);
75     }
76 
77     /**
78      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
79      */
80     function toHexString(uint256 value) internal pure returns (string memory) {
81         if (value == 0) {
82             return "0x00";
83         }
84         uint256 temp = value;
85         uint256 length = 0;
86         while (temp != 0) {
87             length++;
88             temp >>= 8;
89         }
90         return toHexString(value, length);
91     }
92 
93     /**
94      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
95      */
96     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
97         bytes memory buffer = new bytes(2 * length + 2);
98         buffer[0] = "0";
99         buffer[1] = "x";
100         for (uint256 i = 2 * length + 1; i > 1; --i) {
101             buffer[i] = _HEX_SYMBOLS[value & 0xf];
102             value >>= 4;
103         }
104         require(value == 0, "Strings: hex length insufficient");
105         return string(buffer);
106     }
107 }
108 
109 // File: @openzeppelin/contracts/utils/Context.sol
110 
111 
112 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
113 
114 pragma solidity ^0.8.0;
115 
116 abstract contract Context {
117     function _msgSender() internal view virtual returns (address) {
118         return msg.sender;
119     }
120 
121     function _msgData() internal view virtual returns (bytes calldata) {
122         return msg.data;
123     }
124 }
125 
126 
127 // File: @openzeppelin/contracts/access/Ownable.sol
128 
129 pragma solidity ^0.8.0;
130 
131 abstract contract Ownable is Context {
132     address private _owner;
133 
134     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
135 
136     /**
137      * @dev Initializes the contract setting the deployer as the initial owner.
138      */
139     constructor() {
140         _transferOwnership(_msgSender());
141     }
142 
143     /**
144      * @dev Returns the address of the current owner.
145      */
146     function owner() public view virtual returns (address) {
147         return _owner;
148     }
149 
150     /**
151      * @dev Throws if called by any account other than the owner.
152      */
153     modifier onlyOwner() {
154         require(owner() == _msgSender(), "Ownable: caller is not the owner");
155         _;
156     }
157 
158     /**
159      * @dev Leaves the contract without owner. It will not be possible to call
160      * `onlyOwner` functions anymore. Can only be called by the current owner.
161      *
162      * NOTE: Renouncing ownership will leave the contract without an owner,
163      * thereby removing any functionality that is only available to the owner.
164      */
165     function renounceOwnership() public virtual onlyOwner {
166         _transferOwnership(address(0));
167     }
168 
169     /**
170      * @dev Transfers ownership of the contract to a new account (`newOwner`).
171      * Can only be called by the current owner.
172      */
173     function transferOwnership(address newOwner) public virtual onlyOwner {
174         require(newOwner != address(0), "Ownable: new owner is the zero address");
175         _transferOwnership(newOwner);
176     }
177 
178     /**
179      * @dev Transfers ownership of the contract to a new account (`newOwner`).
180      * Internal function without access restriction.
181      */
182     function _transferOwnership(address newOwner) internal virtual {
183         address oldOwner = _owner;
184         _owner = newOwner;
185         emit OwnershipTransferred(oldOwner, newOwner);
186     }
187 }
188 
189 // File: @openzeppelin/contracts/utils/Address.sol
190 
191 
192 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
193 
194 pragma solidity ^0.8.1;
195 
196 /**
197  * @dev Collection of functions related to the address type
198  */
199 library Address {
200     
201     function isContract(address account) internal view returns (bool) {
202         return account.code.length > 0;
203     }
204 
205     function sendValue(address payable recipient, uint256 amount) internal {
206         require(address(this).balance >= amount, "Address: insufficient balance");
207 
208         (bool success, ) = recipient.call{value: amount}("");
209         require(success, "Address: unable to send value, recipient may have reverted");
210     }
211 
212     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
213         return functionCall(target, data, "Address: low-level call failed");
214     }
215 
216     function functionCall(
217         address target,
218         bytes memory data,
219         string memory errorMessage
220     ) internal returns (bytes memory) {
221         return functionCallWithValue(target, data, 0, errorMessage);
222     }
223 
224     function functionCallWithValue(
225         address target,
226         bytes memory data,
227         uint256 value
228     ) internal returns (bytes memory) {
229         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
230     }
231 
232     function functionCallWithValue(
233         address target,
234         bytes memory data,
235         uint256 value,
236         string memory errorMessage
237     ) internal returns (bytes memory) {
238         require(address(this).balance >= value, "Address: insufficient balance for call");
239         require(isContract(target), "Address: call to non-contract");
240 
241         (bool success, bytes memory returndata) = target.call{value: value}(data);
242         return verifyCallResult(success, returndata, errorMessage);
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
247      * but performing a static call.
248      *
249      * _Available since v3.3._
250      */
251     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
252         return functionStaticCall(target, data, "Address: low-level static call failed");
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
257      * but performing a static call.
258      *
259      * _Available since v3.3._
260      */
261     function functionStaticCall(
262         address target,
263         bytes memory data,
264         string memory errorMessage
265     ) internal view returns (bytes memory) {
266         require(isContract(target), "Address: static call to non-contract");
267 
268         (bool success, bytes memory returndata) = target.staticcall(data);
269         return verifyCallResult(success, returndata, errorMessage);
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
274      * but performing a delegate call.
275      *
276      * _Available since v3.4._
277      */
278     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
279         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
284      * but performing a delegate call.
285      *
286      * _Available since v3.4._
287      */
288     function functionDelegateCall(
289         address target,
290         bytes memory data,
291         string memory errorMessage
292     ) internal returns (bytes memory) {
293         require(isContract(target), "Address: delegate call to non-contract");
294 
295         (bool success, bytes memory returndata) = target.delegatecall(data);
296         return verifyCallResult(success, returndata, errorMessage);
297     }
298 
299     /**
300      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
301      * revert reason using the provided one.
302      *
303      * _Available since v4.3._
304      */
305     function verifyCallResult(
306         bool success,
307         bytes memory returndata,
308         string memory errorMessage
309     ) internal pure returns (bytes memory) {
310         if (success) {
311             return returndata;
312         } else {
313             // Look for revert reason and bubble it up if present
314             if (returndata.length > 0) {
315                 // The easiest way to bubble the revert reason is using memory via assembly
316 
317                 assembly {
318                     let returndata_size := mload(returndata)
319                     revert(add(32, returndata), returndata_size)
320                 }
321             } else {
322                 revert(errorMessage);
323             }
324         }
325     }
326 }
327 
328 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
329 
330 
331 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
332 
333 pragma solidity ^0.8.0;
334 
335 interface IERC721Receiver {
336   
337     function onERC721Received(
338         address operator,
339         address from,
340         uint256 tokenId,
341         bytes calldata data
342     ) external returns (bytes4);
343 }
344 
345 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
346 
347 
348 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
349 
350 pragma solidity ^0.8.0;
351 
352 /**
353  * @dev Interface of the ERC165 standard, as defined in the
354  * https://eips.ethereum.org/EIPS/eip-165[EIP].
355  *
356  * Implementers can declare support of contract interfaces, which can then be
357  * queried by others ({ERC165Checker}).
358  *
359  * For an implementation, see {ERC165}.
360  */
361 interface IERC165 {
362     function supportsInterface(bytes4 interfaceId) external view returns (bool);
363 }
364 
365 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
366 
367 
368 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
369 
370 pragma solidity ^0.8.0;
371 
372 abstract contract ERC165 is IERC165 {
373     /**
374      * @dev See {IERC165-supportsInterface}.
375      */
376     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
377         return interfaceId == type(IERC165).interfaceId;
378     }
379 }
380 
381 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
382 
383 
384 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
385 
386 pragma solidity ^0.8.0;
387 
388 
389 /**
390  * @dev Required interface of an ERC721 compliant contract.
391  */
392 interface IERC721 is IERC165 {
393     /**
394      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
395      */
396     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
397 
398     /**
399      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
400      */
401     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
402 
403     /**
404      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
405      */
406     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
407 
408     /**
409      * @dev Returns the number of tokens in ``owner``'s account.
410      */
411     function balanceOf(address owner) external view returns (uint256 balance);
412 
413   
414     function ownerOf(uint256 tokenId) external view returns (address owner);
415 
416 
417     function safeTransferFrom(
418         address from,
419         address to,
420         uint256 tokenId,
421         bytes calldata data
422     ) external;
423 
424   
425     function safeTransferFrom(
426         address from,
427         address to,
428         uint256 tokenId
429     ) external;
430 
431  
432     function transferFrom(
433         address from,
434         address to,
435         uint256 tokenId
436     ) external;
437 
438 
439     function approve(address to, uint256 tokenId) external;
440 
441 
442     function setApprovalForAll(address operator, bool _approved) external;
443 
444 
445     function getApproved(uint256 tokenId) external view returns (address operator);
446 
447     /**
448      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
449      *
450      * See {setApprovalForAll}
451      */
452     function isApprovedForAll(address owner, address operator) external view returns (bool);
453 }
454 
455 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
456 
457 
458 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
459 
460 pragma solidity ^0.8.0;
461 
462 
463 /**
464  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
465  * @dev See https://eips.ethereum.org/EIPS/eip-721
466  */
467 interface IERC721Metadata is IERC721 {
468     /**
469      * @dev Returns the token collection name.
470      */
471     function name() external view returns (string memory);
472 
473     /**
474      * @dev Returns the token collection symbol.
475      */
476     function symbol() external view returns (string memory);
477 
478     /**
479      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
480      */
481     function tokenURI(uint256 tokenId) external view returns (string memory);
482 }
483 
484 // File: erc721a/contracts/IERC721A.sol
485 
486 
487 // ERC721A Contracts v3.3.0
488 // Creator: Chiru Labs
489 
490 pragma solidity ^0.8.4;
491 
492 
493 
494 /**
495  * @dev Interface of an ERC721A compliant contract.
496  */
497 interface IERC721A is IERC721, IERC721Metadata {
498     /**
499      * The caller must own the token or be an approved operator.
500      */
501     error ApprovalCallerNotOwnerNorApproved();
502 
503     /**
504      * The token does not exist.
505      */
506     error ApprovalQueryForNonexistentToken();
507 
508     /**
509      * The caller cannot approve to their own address.
510      */
511     error ApproveToCaller();
512 
513     /**
514      * The caller cannot approve to the current owner.
515      */
516     error ApprovalToCurrentOwner();
517 
518     /**
519      * Cannot query the balance for the zero address.
520      */
521     error BalanceQueryForZeroAddress();
522 
523     /**
524      * Cannot mint to the zero address.
525      */
526     error MintToZeroAddress();
527 
528     /**
529      * The quantity of tokens minted must be more than zero.
530      */
531     error MintZeroQuantity();
532 
533     /**
534      * The token does not exist.
535      */
536     error OwnerQueryForNonexistentToken();
537 
538     /**
539      * The caller must own the token or be an approved operator.
540      */
541     error TransferCallerNotOwnerNorApproved();
542 
543     /**
544      * The token must be owned by `from`.
545      */
546     error TransferFromIncorrectOwner();
547 
548     /**
549      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
550      */
551     error TransferToNonERC721ReceiverImplementer();
552 
553     /**
554      * Cannot transfer to the zero address.
555      */
556     error TransferToZeroAddress();
557 
558     /**
559      * The token does not exist.
560      */
561     error URIQueryForNonexistentToken();
562 
563     // Compiler will pack this into a single 256bit word.
564     struct TokenOwnership {
565         // The address of the owner.
566         address addr;
567         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
568         uint64 startTimestamp;
569         // Whether the token has been burned.
570         bool burned;
571     }
572 
573     // Compiler will pack this into a single 256bit word.
574     struct AddressData {
575         // Realistically, 2**64-1 is more than enough.
576         uint64 balance;
577         // Keeps track of mint count with minimal overhead for tokenomics.
578         uint64 numberMinted;
579         // Keeps track of burn count with minimal overhead for tokenomics.
580         uint64 numberBurned;
581         // For miscellaneous variable(s) pertaining to the address
582         // (e.g. number of whitelist mint slots used).
583         // If there are multiple variables, please pack them into a uint64.
584         uint64 aux;
585     }
586 
587     /**
588      * @dev Returns the total amount of tokens stored by the contract.
589      * 
590      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
591      */
592     function totalSupply() external view returns (uint256);
593 }
594 
595 
596 // File: erc721a/contracts/ERC721A.sol
597 
598 // ERC721A Contracts v3.3.0
599 // Creator: Chiru Labs
600 
601 pragma solidity ^0.8.4;
602 
603 /**
604  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
605  * the Metadata extension. Built to optimize for lower gas during batch mints.
606  *
607  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
608  *
609  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
610  *
611  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
612  */
613 contract ERC721A is Context, ERC165, IERC721A {
614     using Address for address;
615     using Strings for uint256;
616 
617     // The tokenId of the next token to be minted.
618     uint256 internal _currentIndex;
619 
620     // The number of tokens burned.
621     uint256 internal _burnCounter;
622 
623     // Token name
624     string private _name;
625 
626     // Token symbol
627     string private _symbol;
628 
629     // Mapping from token ID to ownership details
630     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
631     mapping(uint256 => TokenOwnership) internal _ownerships;
632 
633     // Mapping owner address to address data
634     mapping(address => AddressData) private _addressData;
635 
636     // Mapping from token ID to approved address
637     mapping(uint256 => address) private _tokenApprovals;
638 
639     // Mapping from owner to operator approvals
640     mapping(address => mapping(address => bool)) private _operatorApprovals;
641 
642     constructor(string memory name_, string memory symbol_) {
643         _name = name_;
644         _symbol = symbol_;
645         _currentIndex = _startTokenId();
646     }
647 
648     /**
649      * To change the starting tokenId, please override this function.
650      */
651     function _startTokenId() internal view virtual returns (uint256) {
652         return 0;
653     }
654 
655     /**
656      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
657      */
658     function totalSupply() public view override returns (uint256) {
659         // Counter underflow is impossible as _burnCounter cannot be incremented
660         // more than _currentIndex - _startTokenId() times
661         unchecked {
662             return _currentIndex - _burnCounter - _startTokenId();
663         }
664     }
665 
666     /**
667      * Returns the total amount of tokens minted in the contract.
668      */
669     function _totalMinted() internal view returns (uint256) {
670         // Counter underflow is impossible as _currentIndex does not decrement,
671         // and it is initialized to _startTokenId()
672         unchecked {
673             return _currentIndex - _startTokenId();
674         }
675     }
676 
677     /**
678      * @dev See {IERC165-supportsInterface}.
679      */
680     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
681         return
682             interfaceId == type(IERC721).interfaceId ||
683             interfaceId == type(IERC721Metadata).interfaceId ||
684             super.supportsInterface(interfaceId);
685     }
686 
687     /**
688      * @dev See {IERC721-balanceOf}.
689      */
690     function balanceOf(address owner) public view override returns (uint256) {
691         if (owner == address(0)) revert BalanceQueryForZeroAddress();
692         return uint256(_addressData[owner].balance);
693     }
694 
695     /**
696      * Returns the number of tokens minted by `owner`.
697      */
698     function _numberMinted(address owner) internal view returns (uint256) {
699         return uint256(_addressData[owner].numberMinted);
700     }
701 
702     /**
703      * Returns the number of tokens burned by or on behalf of `owner`.
704      */
705     function _numberBurned(address owner) internal view returns (uint256) {
706         return uint256(_addressData[owner].numberBurned);
707     }
708 
709     /**
710      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
711      */
712     function _getAux(address owner) internal view returns (uint64) {
713         return _addressData[owner].aux;
714     }
715 
716     /**
717      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
718      * If there are multiple variables, please pack them into a uint64.
719      */
720     function _setAux(address owner, uint64 aux) internal {
721         _addressData[owner].aux = aux;
722     }
723 
724     /**
725      * Gas spent here starts off proportional to the maximum mint batch size.
726      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
727      */
728     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
729         uint256 curr = tokenId;
730 
731         unchecked {
732             if (_startTokenId() <= curr) if (curr < _currentIndex) {
733                 TokenOwnership memory ownership = _ownerships[curr];
734                 if (!ownership.burned) {
735                     if (ownership.addr != address(0)) {
736                         return ownership;
737                     }
738                     // Invariant:
739                     // There will always be an ownership that has an address and is not burned
740                     // before an ownership that does not have an address and is not burned.
741                     // Hence, curr will not underflow.
742                     while (true) {
743                         curr--;
744                         ownership = _ownerships[curr];
745                         if (ownership.addr != address(0)) {
746                             return ownership;
747                         }
748                     }
749                 }
750             }
751         }
752         revert OwnerQueryForNonexistentToken();
753     }
754 
755     /**
756      * @dev See {IERC721-ownerOf}.
757      */
758     function ownerOf(uint256 tokenId) public view override returns (address) {
759         return _ownershipOf(tokenId).addr;
760     }
761 
762     /**
763      * @dev See {IERC721Metadata-name}.
764      */
765     function name() public view virtual override returns (string memory) {
766         return _name;
767     }
768 
769     /**
770      * @dev See {IERC721Metadata-symbol}.
771      */
772     function symbol() public view virtual override returns (string memory) {
773         return _symbol;
774     }
775 
776     /**
777      * @dev See {IERC721Metadata-tokenURI}.
778      */
779     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
780         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
781 
782         string memory baseURI = _baseURI();
783         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
784     }
785 
786     /**
787      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
788      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
789      * by default, can be overriden in child contracts.
790      */
791     function _baseURI() internal view virtual returns (string memory) {
792         return '';
793     }
794 
795     /**
796      * @dev See {IERC721-approve}.
797      */
798     function approve(address to, uint256 tokenId) public override {
799         address owner = ERC721A.ownerOf(tokenId);
800         if (to == owner) revert ApprovalToCurrentOwner();
801 
802         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
803             revert ApprovalCallerNotOwnerNorApproved();
804         }
805 
806         _approve(to, tokenId, owner);
807     }
808 
809     /**
810      * @dev See {IERC721-getApproved}.
811      */
812     function getApproved(uint256 tokenId) public view override returns (address) {
813         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
814 
815         return _tokenApprovals[tokenId];
816     }
817 
818     /**
819      * @dev See {IERC721-setApprovalForAll}.
820      */
821     function setApprovalForAll(address operator, bool approved) public virtual override {
822         if (operator == _msgSender()) revert ApproveToCaller();
823 
824         _operatorApprovals[_msgSender()][operator] = approved;
825         emit ApprovalForAll(_msgSender(), operator, approved);
826     }
827 
828     /**
829      * @dev See {IERC721-isApprovedForAll}.
830      */
831     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
832         return _operatorApprovals[owner][operator];
833     }
834 
835     /**
836      * @dev See {IERC721-transferFrom}.
837      */
838     function transferFrom(
839         address from,
840         address to,
841         uint256 tokenId
842     ) public virtual override {
843         _transfer(from, to, tokenId);
844     }
845 
846     /**
847      * @dev See {IERC721-safeTransferFrom}.
848      */
849     function safeTransferFrom(
850         address from,
851         address to,
852         uint256 tokenId
853     ) public virtual override {
854         safeTransferFrom(from, to, tokenId, '');
855     }
856 
857     /**
858      * @dev See {IERC721-safeTransferFrom}.
859      */
860     function safeTransferFrom(
861         address from,
862         address to,
863         uint256 tokenId,
864         bytes memory _data
865     ) public virtual override {
866         _transfer(from, to, tokenId);
867         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
868             revert TransferToNonERC721ReceiverImplementer();
869         }
870     }
871 
872     /**
873      * @dev Returns whether `tokenId` exists.
874      *
875      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
876      *
877      * Tokens start existing when they are minted (`_mint`),
878      */
879     function _exists(uint256 tokenId) internal view returns (bool) {
880         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
881     }
882 
883     /**
884      * @dev Equivalent to `_safeMint(to, quantity, '')`.
885      */
886     function _safeMint(address to, uint256 quantity) internal {
887         _safeMint(to, quantity, '');
888     }
889 
890     /**
891      * @dev Safely mints `quantity` tokens and transfers them to `to`.
892      *
893      * Requirements:
894      *
895      * - If `to` refers to a smart contract, it must implement
896      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
897      * - `quantity` must be greater than 0.
898      *
899      * Emits a {Transfer} event.
900      */
901     function _safeMint(
902         address to,
903         uint256 quantity,
904         bytes memory _data
905     ) internal {
906         uint256 startTokenId = _currentIndex;
907         if (to == address(0)) revert MintToZeroAddress();
908         if (quantity == 0) revert MintZeroQuantity();
909 
910         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
911 
912         // Overflows are incredibly unrealistic.
913         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
914         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
915         unchecked {
916             _addressData[to].balance += uint64(quantity);
917             _addressData[to].numberMinted += uint64(quantity);
918 
919             _ownerships[startTokenId].addr = to;
920             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
921 
922             uint256 updatedIndex = startTokenId;
923             uint256 end = updatedIndex + quantity;
924 
925             if (to.isContract()) {
926                 do {
927                     emit Transfer(address(0), to, updatedIndex);
928                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
929                         revert TransferToNonERC721ReceiverImplementer();
930                     }
931                 } while (updatedIndex < end);
932                 // Reentrancy protection
933                 if (_currentIndex != startTokenId) revert();
934             } else {
935                 do {
936                     emit Transfer(address(0), to, updatedIndex++);
937                 } while (updatedIndex < end);
938             }
939             _currentIndex = updatedIndex;
940         }
941         _afterTokenTransfers(address(0), to, startTokenId, quantity);
942     }
943 
944     /**
945      * @dev Mints `quantity` tokens and transfers them to `to`.
946      *
947      * Requirements:
948      *
949      * - `to` cannot be the zero address.
950      * - `quantity` must be greater than 0.
951      *
952      * Emits a {Transfer} event.
953      */
954     function _mint(address to, uint256 quantity) internal {
955         uint256 startTokenId = _currentIndex;
956         if (to == address(0)) revert MintToZeroAddress();
957         if (quantity == 0) revert MintZeroQuantity();
958 
959         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
960 
961         // Overflows are incredibly unrealistic.
962         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
963         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
964         unchecked {
965             _addressData[to].balance += uint64(quantity);
966             _addressData[to].numberMinted += uint64(quantity);
967 
968             _ownerships[startTokenId].addr = to;
969             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
970 
971             uint256 updatedIndex = startTokenId;
972             uint256 end = updatedIndex + quantity;
973 
974             do {
975                 emit Transfer(address(0), to, updatedIndex++);
976             } while (updatedIndex < end);
977 
978             _currentIndex = updatedIndex;
979         }
980         _afterTokenTransfers(address(0), to, startTokenId, quantity);
981     }
982 
983     /**
984      * @dev Transfers `tokenId` from `from` to `to`.
985      *
986      * Requirements:
987      *
988      * - `to` cannot be the zero address.
989      * - `tokenId` token must be owned by `from`.
990      *
991      * Emits a {Transfer} event.
992      */
993     function _transfer(
994         address from,
995         address to,
996         uint256 tokenId
997     ) private {
998         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
999 
1000         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1001 
1002         bool isApprovedOrOwner = (_msgSender() == from ||
1003             isApprovedForAll(from, _msgSender()) ||
1004             getApproved(tokenId) == _msgSender());
1005 
1006         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1007         if (to == address(0)) revert TransferToZeroAddress();
1008 
1009         _beforeTokenTransfers(from, to, tokenId, 1);
1010 
1011         // Clear approvals from the previous owner
1012         _approve(address(0), tokenId, from);
1013 
1014         // Underflow of the sender's balance is impossible because we check for
1015         // ownership above and the recipient's balance can't realistically overflow.
1016         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1017         unchecked {
1018             _addressData[from].balance -= 1;
1019             _addressData[to].balance += 1;
1020 
1021             TokenOwnership storage currSlot = _ownerships[tokenId];
1022             currSlot.addr = to;
1023             currSlot.startTimestamp = uint64(block.timestamp);
1024 
1025             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1026             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1027             uint256 nextTokenId = tokenId + 1;
1028             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1029             if (nextSlot.addr == address(0)) {
1030                 // This will suffice for checking _exists(nextTokenId),
1031                 // as a burned slot cannot contain the zero address.
1032                 if (nextTokenId != _currentIndex) {
1033                     nextSlot.addr = from;
1034                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1035                 }
1036             }
1037         }
1038 
1039         emit Transfer(from, to, tokenId);
1040         _afterTokenTransfers(from, to, tokenId, 1);
1041     }
1042 
1043     /**
1044      * @dev Equivalent to `_burn(tokenId, false)`.
1045      */
1046     function _burn(uint256 tokenId) internal virtual {
1047         _burn(tokenId, false);
1048     }
1049 
1050     /**
1051      * @dev Destroys `tokenId`.
1052      * The approval is cleared when the token is burned.
1053      *
1054      * Requirements:
1055      *
1056      * - `tokenId` must exist.
1057      *
1058      * Emits a {Transfer} event.
1059      */
1060     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1061         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1062 
1063         address from = prevOwnership.addr;
1064 
1065         if (approvalCheck) {
1066             bool isApprovedOrOwner = (_msgSender() == from ||
1067                 isApprovedForAll(from, _msgSender()) ||
1068                 getApproved(tokenId) == _msgSender());
1069 
1070             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1071         }
1072 
1073         _beforeTokenTransfers(from, address(0), tokenId, 1);
1074 
1075         // Clear approvals from the previous owner
1076         _approve(address(0), tokenId, from);
1077 
1078         // Underflow of the sender's balance is impossible because we check for
1079         // ownership above and the recipient's balance can't realistically overflow.
1080         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1081         unchecked {
1082             AddressData storage addressData = _addressData[from];
1083             addressData.balance -= 1;
1084             addressData.numberBurned += 1;
1085 
1086             // Keep track of who burned the token, and the timestamp of burning.
1087             TokenOwnership storage currSlot = _ownerships[tokenId];
1088             currSlot.addr = from;
1089             currSlot.startTimestamp = uint64(block.timestamp);
1090             currSlot.burned = true;
1091 
1092             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1093             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1094             uint256 nextTokenId = tokenId + 1;
1095             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1096             if (nextSlot.addr == address(0)) {
1097                 // This will suffice for checking _exists(nextTokenId),
1098                 // as a burned slot cannot contain the zero address.
1099                 if (nextTokenId != _currentIndex) {
1100                     nextSlot.addr = from;
1101                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1102                 }
1103             }
1104         }
1105 
1106         emit Transfer(from, address(0), tokenId);
1107         _afterTokenTransfers(from, address(0), tokenId, 1);
1108 
1109         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1110         unchecked {
1111             _burnCounter++;
1112         }
1113     }
1114 
1115     /**
1116      * @dev Approve `to` to operate on `tokenId`
1117      *
1118      * Emits a {Approval} event.
1119      */
1120     function _approve(
1121         address to,
1122         uint256 tokenId,
1123         address owner
1124     ) private {
1125         _tokenApprovals[tokenId] = to;
1126         emit Approval(owner, to, tokenId);
1127     }
1128 
1129 
1130     function _checkContractOnERC721Received(
1131         address from,
1132         address to,
1133         uint256 tokenId,
1134         bytes memory _data
1135     ) private returns (bool) {
1136         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1137             return retval == IERC721Receiver(to).onERC721Received.selector;
1138         } catch (bytes memory reason) {
1139             if (reason.length == 0) {
1140                 revert TransferToNonERC721ReceiverImplementer();
1141             } else {
1142                 assembly {
1143                     revert(add(32, reason), mload(reason))
1144                 }
1145             }
1146         }
1147     }
1148 
1149  
1150     function _beforeTokenTransfers(
1151         address from,
1152         address to,
1153         uint256 startTokenId,
1154         uint256 quantity
1155     ) internal virtual {}
1156 
1157 
1158     function _afterTokenTransfers(
1159         address from,
1160         address to,
1161         uint256 startTokenId,
1162         uint256 quantity
1163     ) internal virtual {}
1164 }
1165 
1166 
1167 // File: contracts/DOGLIENS.sol
1168 
1169 pragma solidity >= 0.8.0 < 0.9.0;
1170 
1171 contract DOGLIENS is ERC721A, Ownable, ReentrancyGuard {
1172 
1173   using Strings for uint256;
1174   address public signerAddress;
1175 
1176   string public uriPrefix;
1177   string public notRevealedURI = "ipfs://QmVFsyAPjYhU358QbgETkDc6hutC8CPLhfFBy5H8poM9Ar/hidden.json";
1178   string public uriSuffix = ".json";
1179   
1180   uint256 public cost = 0 ether;
1181 
1182   uint256 public maxSupply = 600;
1183 
1184   uint256 public MaxperTx = 3;
1185   uint256 public nftPerAddressLimit = 10;
1186 
1187   bool public paused = true;
1188   uint256 public revealed = 0;
1189 
1190   bool public teamMintEnabled = false;
1191   bool public publicMintEnabled = false;
1192   bool public whitelistMintEnabled = false;
1193 
1194   mapping(address => bool) public whitelistedAddresses;
1195   mapping(address => uint256) public whitelistClaimed;
1196   mapping(address => uint256) public teamMintClaimed;
1197   mapping(address => uint256) public addressMintedBalance;
1198 
1199   constructor( address _signerAddress ) ERC721A ( "DOGLIENS", "DLN" ) {
1200     signerAddress = _signerAddress;
1201   }
1202 
1203 // ~~~~~~~~~~~~~~~~~~~~ URI's ~~~~~~~~~~~~~~~~~~~~
1204 
1205   function _baseURI() internal view virtual override returns (string memory) {
1206     return uriPrefix;
1207   }
1208 
1209 // ~~~~~~~~~~~~~~~~~~~~ Modifiers ~~~~~~~~~~~~~~~~~~~~
1210 
1211   modifier mintCompliance(uint256 _mintAmount) {
1212     if (msg.sender != owner()) {
1213         require(!paused, "The contract is paused!");
1214         require(_mintAmount <= MaxperTx, "Max mint per transaction exceeded!");
1215         require(addressMintedBalance[msg.sender] + _mintAmount <= nftPerAddressLimit, "Max mint amount per address exceeded!");
1216         }
1217     require(_mintAmount > 0, "Mint amount can't be zero.");
1218     require(tx.origin == msg.sender, "The caller is another contract!");
1219     require(totalSupply() + _mintAmount <= maxSupply, "Mint amount exceeds max supply!");
1220     _;
1221   }
1222 
1223   modifier mintPriceCompliance(uint256 _mintAmount) {
1224     if (msg.sender != owner()) {
1225         require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1226         }
1227     _;
1228   }
1229 
1230 // ~~~~~~~~~~~~~~~~~~~~ Mint Functions ~~~~~~~~~~~~~~~~~~~~
1231   
1232   // PUBLIC MINT
1233   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1234     require(publicMintEnabled, "Public mint is not active yet!");
1235 
1236     addressMintedBalance[msg.sender] += _mintAmount;
1237     _safeMint(_msgSender(), _mintAmount);
1238   }
1239   
1240   // WHITELIST AND OG MINT
1241   function mintWhitelist(uint256 _mintAmount, bytes memory sig) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1242     require(whitelistMintEnabled, "Whitelist mint is not active yet!");
1243     require(isValidData(msg.sender, sig) == true, "User is not whitelisted!");
1244     require(whitelistClaimed[msg.sender] + _mintAmount <= nftPerAddressLimit, "Max Whitelist mint exceeded!");
1245 
1246     addressMintedBalance[msg.sender] += _mintAmount;
1247     whitelistClaimed[msg.sender] += _mintAmount;
1248     _safeMint(_msgSender(), _mintAmount);
1249   }
1250 
1251   // TEAM MINT
1252   function mintTeam(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1253     require(teamMintEnabled, "Team mint is not enabled!");
1254     require(isWhitelisted(msg.sender) == true, "User is not a team member!");
1255     require(teamMintClaimed[msg.sender] + _mintAmount <= 10, "Max team mint exceeded!");
1256 
1257     teamMintClaimed[msg.sender] += _mintAmount;
1258     _safeMint(_msgSender(), _mintAmount);
1259   }
1260 
1261   // MINT for address
1262   function mintToAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1263     require(totalSupply() + _mintAmount <= maxSupply, "Mint amount exceeds max supply!");
1264     _safeMint(_receiver, _mintAmount);
1265   }
1266 
1267 // ~~~~~~~~~~~~~~~~~~~~ SIGNATURES ~~~~~~~~~~~~~~~~~~~~
1268   function isValidData(address _user, bytes memory sig) public view returns (bool) {
1269     bytes32 message = keccak256(abi.encodePacked(_user));
1270     return (recoverSigner(message, sig) == signerAddress);
1271   }
1272 
1273   function recoverSigner(bytes32 message, bytes memory sig) public pure returns (address) {
1274     uint8 v; bytes32 r; bytes32 s;
1275     (v, r, s) = splitSignature(sig);
1276     return ecrecover(message, v, r, s);
1277   }
1278 
1279   function splitSignature(bytes memory sig) public pure returns (uint8, bytes32, bytes32) {
1280     require(sig.length == 65);
1281     bytes32 r; bytes32 s; uint8 v;
1282     assembly { r := mload(add(sig, 32)) s := mload(add(sig, 64)) v := byte(0, mload(add(sig, 96))) }
1283     return (v, r, s);
1284   }
1285 
1286 // ~~~~~~~~~~~~~~~~~~~~ Checks ~~~~~~~~~~~~~~~~~~~~
1287 
1288   // Check Wallet assets
1289   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1290     uint256 ownerTokenCount = balanceOf(_owner);
1291     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1292     uint256 currentTokenId = _startTokenId();
1293     uint256 ownedTokenIndex = 0;
1294     address latestOwnerAddress;
1295 
1296     while (ownedTokenIndex < ownerTokenCount && currentTokenId < _currentIndex) {
1297       TokenOwnership memory ownership = _ownerships[currentTokenId];
1298 
1299       if (!ownership.burned) {
1300         if (ownership.addr != address(0)) {
1301           latestOwnerAddress = ownership.addr;
1302         }
1303 
1304         if (latestOwnerAddress == _owner) {
1305           ownedTokenIds[ownedTokenIndex] = currentTokenId;
1306           ownedTokenIndex++;
1307         }
1308       }
1309       currentTokenId++;
1310     }
1311     return ownedTokenIds;
1312   }
1313 
1314   // Start Token
1315   function _startTokenId() internal view virtual override returns (uint256) {
1316     return 1;
1317   }
1318 
1319   // TOKEN URI
1320   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1321     require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token.");
1322     
1323     if (_tokenId > revealed) { return notRevealedURI; }
1324 
1325     string memory currentBaseURI = _baseURI();
1326     return bytes(currentBaseURI).length > 0
1327     ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1328     : "";
1329   }
1330 
1331   // Check if address is whitelisted
1332   function isWhitelisted(address _user) public view returns (bool) {
1333     return whitelistedAddresses[_user];
1334   }
1335 
1336 // ~~~~~~~~~~~~~~~~~~~~ onlyOwner Functions ~~~~~~~~~~~~~~~~~~~~
1337 
1338   // SIGNER
1339   function setSigner(address _newSigner) public onlyOwner {
1340     signerAddress = _newSigner;
1341   }
1342 
1343   // REVEAL
1344   function setRevealed(uint256 _amountRevealed) public onlyOwner {
1345     revealed = _amountRevealed;
1346   }
1347   
1348   // PAUSE
1349   function setPaused(bool _state) public onlyOwner {
1350     paused = _state;
1351   }
1352 
1353   // SET COST
1354   function setCost(uint256 _cost) public onlyOwner {
1355     cost = _cost;
1356   }
1357 
1358   // SET MAX SUPPLY
1359   function setMaxSupply(uint256 _MaxSupply) public onlyOwner {
1360     maxSupply = _MaxSupply;
1361   }
1362   
1363   // SET MAX MINT PER TRX
1364   function setMaxMintPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1365     MaxperTx = _maxMintAmountPerTx;
1366   }
1367   
1368   // SET MAX PER ADDRESS LIMIT
1369   function setMaxPerAddLimit(uint256 _maxPerAddLimit) public onlyOwner {
1370     nftPerAddressLimit = _maxPerAddLimit;
1371   }
1372   
1373   // SET BASE URI
1374   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1375     uriPrefix = _uriPrefix;
1376   }
1377   
1378   // SET PUBLIC MINT STATE
1379   function setPublicMintState(bool _state) public onlyOwner {
1380     publicMintEnabled = _state;
1381   }
1382 
1383   // SET TEAM MINT STATE
1384   function setTeamMintState(bool _state) public onlyOwner {
1385     teamMintEnabled = _state;
1386   }
1387 
1388   // SET WHITELIST MINT STATE
1389   function setWLMintState(bool _state) public onlyOwner {
1390     whitelistMintEnabled = _state;
1391   }
1392 
1393   // WHITELIST USERS
1394   function whitelistUsers(address[] calldata _users) public onlyOwner {
1395     for (uint256 i = 0; i < _users.length; i++) {
1396         whitelistedAddresses[_users[i]] = true; 
1397     }
1398   }
1399 
1400   function withdraw() public onlyOwner nonReentrant {
1401     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1402     require(os);
1403   }
1404 }