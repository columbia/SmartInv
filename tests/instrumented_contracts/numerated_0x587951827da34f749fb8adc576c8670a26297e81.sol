1 // SPDX-License-Identifier: GPL-3.0
2 
3 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
4 
5 pragma solidity ^0.8.0;
6 
7 abstract contract ReentrancyGuard {
8     
9     uint256 private constant _NOT_ENTERED = 1;
10     uint256 private constant _ENTERED = 2;
11 
12     uint256 private _status;
13 
14     constructor() {
15         _status = _NOT_ENTERED;
16     }
17 
18     modifier nonReentrant() {
19         // On the first call to nonReentrant, _notEntered will be true
20         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
21 
22         // Any calls to nonReentrant after this point will fail
23         _status = _ENTERED;
24 
25         _;
26 
27         _status = _NOT_ENTERED;
28     }
29 }
30 
31 
32 // File: @openzeppelin/contracts/utils/Strings.sol
33 
34 
35 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev String operations.
41  */
42 library Strings {
43     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
44 
45     function toString(uint256 value) internal pure returns (string memory) {
46 
47         if (value == 0) {
48             return "0";
49         }
50         uint256 temp = value;
51         uint256 digits;
52         while (temp != 0) {
53             digits++;
54             temp /= 10;
55         }
56         bytes memory buffer = new bytes(digits);
57         while (value != 0) {
58             digits -= 1;
59             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
60             value /= 10;
61         }
62         return string(buffer);
63     }
64 
65     /**
66      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
67      */
68     function toHexString(uint256 value) internal pure returns (string memory) {
69         if (value == 0) {
70             return "0x00";
71         }
72         uint256 temp = value;
73         uint256 length = 0;
74         while (temp != 0) {
75             length++;
76             temp >>= 8;
77         }
78         return toHexString(value, length);
79     }
80 
81     /**
82      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
83      */
84     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
85         bytes memory buffer = new bytes(2 * length + 2);
86         buffer[0] = "0";
87         buffer[1] = "x";
88         for (uint256 i = 2 * length + 1; i > 1; --i) {
89             buffer[i] = _HEX_SYMBOLS[value & 0xf];
90             value >>= 4;
91         }
92         require(value == 0, "Strings: hex length insufficient");
93         return string(buffer);
94     }
95 }
96 
97 // File: @openzeppelin/contracts/utils/Context.sol
98 
99 
100 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
101 
102 pragma solidity ^0.8.0;
103 
104 abstract contract Context {
105     function _msgSender() internal view virtual returns (address) {
106         return msg.sender;
107     }
108 
109     function _msgData() internal view virtual returns (bytes calldata) {
110         return msg.data;
111     }
112 }
113 
114 
115 // File: @openzeppelin/contracts/access/Ownable.sol
116 
117 pragma solidity ^0.8.0;
118 
119 abstract contract Ownable is Context {
120     address private _owner;
121 
122     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
123 
124     /**
125      * @dev Initializes the contract setting the deployer as the initial owner.
126      */
127     constructor() {
128         _transferOwnership(_msgSender());
129     }
130 
131     /**
132      * @dev Returns the address of the current owner.
133      */
134     function owner() public view virtual returns (address) {
135         return _owner;
136     }
137 
138     /**
139      * @dev Throws if called by any account other than the owner.
140      */
141     modifier onlyOwner() {
142         require(owner() == _msgSender(), "Ownable: caller is not the owner");
143         _;
144     }
145 
146     /**
147      * @dev Leaves the contract without owner. It will not be possible to call
148      * `onlyOwner` functions anymore. Can only be called by the current owner.
149      *
150      * NOTE: Renouncing ownership will leave the contract without an owner,
151      * thereby removing any functionality that is only available to the owner.
152      */
153     function renounceOwnership() public virtual onlyOwner {
154         _transferOwnership(address(0));
155     }
156 
157     /**
158      * @dev Transfers ownership of the contract to a new account (`newOwner`).
159      * Can only be called by the current owner.
160      */
161     function transferOwnership(address newOwner) public virtual onlyOwner {
162         require(newOwner != address(0), "Ownable: new owner is the zero address");
163         _transferOwnership(newOwner);
164     }
165 
166     /**
167      * @dev Transfers ownership of the contract to a new account (`newOwner`).
168      * Internal function without access restriction.
169      */
170     function _transferOwnership(address newOwner) internal virtual {
171         address oldOwner = _owner;
172         _owner = newOwner;
173         emit OwnershipTransferred(oldOwner, newOwner);
174     }
175 }
176 
177 // File: @openzeppelin/contracts/utils/Address.sol
178 
179 
180 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
181 
182 pragma solidity ^0.8.1;
183 
184 /**
185  * @dev Collection of functions related to the address type
186  */
187 library Address {
188     
189     function isContract(address account) internal view returns (bool) {
190         return account.code.length > 0;
191     }
192 
193     function sendValue(address payable recipient, uint256 amount) internal {
194         require(address(this).balance >= amount, "Address: insufficient balance");
195 
196         (bool success, ) = recipient.call{value: amount}("");
197         require(success, "Address: unable to send value, recipient may have reverted");
198     }
199 
200     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
201         return functionCall(target, data, "Address: low-level call failed");
202     }
203 
204     function functionCall(
205         address target,
206         bytes memory data,
207         string memory errorMessage
208     ) internal returns (bytes memory) {
209         return functionCallWithValue(target, data, 0, errorMessage);
210     }
211 
212     function functionCallWithValue(
213         address target,
214         bytes memory data,
215         uint256 value
216     ) internal returns (bytes memory) {
217         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
218     }
219 
220     function functionCallWithValue(
221         address target,
222         bytes memory data,
223         uint256 value,
224         string memory errorMessage
225     ) internal returns (bytes memory) {
226         require(address(this).balance >= value, "Address: insufficient balance for call");
227         require(isContract(target), "Address: call to non-contract");
228 
229         (bool success, bytes memory returndata) = target.call{value: value}(data);
230         return verifyCallResult(success, returndata, errorMessage);
231     }
232 
233     /**
234      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
235      * but performing a static call.
236      *
237      * _Available since v3.3._
238      */
239     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
240         return functionStaticCall(target, data, "Address: low-level static call failed");
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
245      * but performing a static call.
246      *
247      * _Available since v3.3._
248      */
249     function functionStaticCall(
250         address target,
251         bytes memory data,
252         string memory errorMessage
253     ) internal view returns (bytes memory) {
254         require(isContract(target), "Address: static call to non-contract");
255 
256         (bool success, bytes memory returndata) = target.staticcall(data);
257         return verifyCallResult(success, returndata, errorMessage);
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
262      * but performing a delegate call.
263      *
264      * _Available since v3.4._
265      */
266     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
267         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
272      * but performing a delegate call.
273      *
274      * _Available since v3.4._
275      */
276     function functionDelegateCall(
277         address target,
278         bytes memory data,
279         string memory errorMessage
280     ) internal returns (bytes memory) {
281         require(isContract(target), "Address: delegate call to non-contract");
282 
283         (bool success, bytes memory returndata) = target.delegatecall(data);
284         return verifyCallResult(success, returndata, errorMessage);
285     }
286 
287     /**
288      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
289      * revert reason using the provided one.
290      *
291      * _Available since v4.3._
292      */
293     function verifyCallResult(
294         bool success,
295         bytes memory returndata,
296         string memory errorMessage
297     ) internal pure returns (bytes memory) {
298         if (success) {
299             return returndata;
300         } else {
301             // Look for revert reason and bubble it up if present
302             if (returndata.length > 0) {
303                 // The easiest way to bubble the revert reason is using memory via assembly
304 
305                 assembly {
306                     let returndata_size := mload(returndata)
307                     revert(add(32, returndata), returndata_size)
308                 }
309             } else {
310                 revert(errorMessage);
311             }
312         }
313     }
314 }
315 
316 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
317 
318 
319 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
320 
321 pragma solidity ^0.8.0;
322 
323 interface IERC721Receiver {
324   
325     function onERC721Received(
326         address operator,
327         address from,
328         uint256 tokenId,
329         bytes calldata data
330     ) external returns (bytes4);
331 }
332 
333 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
334 
335 
336 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
337 
338 pragma solidity ^0.8.0;
339 
340 /**
341  * @dev Interface of the ERC165 standard, as defined in the
342  * https://eips.ethereum.org/EIPS/eip-165[EIP].
343  *
344  * Implementers can declare support of contract interfaces, which can then be
345  * queried by others ({ERC165Checker}).
346  *
347  * For an implementation, see {ERC165}.
348  */
349 interface IERC165 {
350     function supportsInterface(bytes4 interfaceId) external view returns (bool);
351 }
352 
353 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
354 
355 
356 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
357 
358 pragma solidity ^0.8.0;
359 
360 abstract contract ERC165 is IERC165 {
361     /**
362      * @dev See {IERC165-supportsInterface}.
363      */
364     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
365         return interfaceId == type(IERC165).interfaceId;
366     }
367 }
368 
369 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
370 
371 
372 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
373 
374 pragma solidity ^0.8.0;
375 
376 
377 /**
378  * @dev Required interface of an ERC721 compliant contract.
379  */
380 interface IERC721 is IERC165 {
381     /**
382      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
383      */
384     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
385 
386     /**
387      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
388      */
389     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
390 
391     /**
392      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
393      */
394     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
395 
396     /**
397      * @dev Returns the number of tokens in ``owner``'s account.
398      */
399     function balanceOf(address owner) external view returns (uint256 balance);
400 
401   
402     function ownerOf(uint256 tokenId) external view returns (address owner);
403 
404 
405     function safeTransferFrom(
406         address from,
407         address to,
408         uint256 tokenId,
409         bytes calldata data
410     ) external;
411 
412   
413     function safeTransferFrom(
414         address from,
415         address to,
416         uint256 tokenId
417     ) external;
418 
419  
420     function transferFrom(
421         address from,
422         address to,
423         uint256 tokenId
424     ) external;
425 
426 
427     function approve(address to, uint256 tokenId) external;
428 
429 
430     function setApprovalForAll(address operator, bool _approved) external;
431 
432 
433     function getApproved(uint256 tokenId) external view returns (address operator);
434 
435     /**
436      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
437      *
438      * See {setApprovalForAll}
439      */
440     function isApprovedForAll(address owner, address operator) external view returns (bool);
441 }
442 
443 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
444 
445 
446 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
447 
448 pragma solidity ^0.8.0;
449 
450 
451 /**
452  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
453  * @dev See https://eips.ethereum.org/EIPS/eip-721
454  */
455 interface IERC721Metadata is IERC721 {
456     /**
457      * @dev Returns the token collection name.
458      */
459     function name() external view returns (string memory);
460 
461     /**
462      * @dev Returns the token collection symbol.
463      */
464     function symbol() external view returns (string memory);
465 
466     /**
467      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
468      */
469     function tokenURI(uint256 tokenId) external view returns (string memory);
470 }
471 
472 // File: erc721a/contracts/IERC721A.sol
473 
474 
475 // ERC721A Contracts v3.3.0
476 // Creator: Chiru Labs
477 
478 pragma solidity ^0.8.4;
479 
480 
481 
482 /**
483  * @dev Interface of an ERC721A compliant contract.
484  */
485 interface IERC721A is IERC721, IERC721Metadata {
486     /**
487      * The caller must own the token or be an approved operator.
488      */
489     error ApprovalCallerNotOwnerNorApproved();
490 
491     /**
492      * The token does not exist.
493      */
494     error ApprovalQueryForNonexistentToken();
495 
496     /**
497      * The caller cannot approve to their own address.
498      */
499     error ApproveToCaller();
500 
501     /**
502      * The caller cannot approve to the current owner.
503      */
504     error ApprovalToCurrentOwner();
505 
506     /**
507      * Cannot query the balance for the zero address.
508      */
509     error BalanceQueryForZeroAddress();
510 
511     /**
512      * Cannot mint to the zero address.
513      */
514     error MintToZeroAddress();
515 
516     /**
517      * The quantity of tokens minted must be more than zero.
518      */
519     error MintZeroQuantity();
520 
521     /**
522      * The token does not exist.
523      */
524     error OwnerQueryForNonexistentToken();
525 
526     /**
527      * The caller must own the token or be an approved operator.
528      */
529     error TransferCallerNotOwnerNorApproved();
530 
531     /**
532      * The token must be owned by `from`.
533      */
534     error TransferFromIncorrectOwner();
535 
536     /**
537      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
538      */
539     error TransferToNonERC721ReceiverImplementer();
540 
541     /**
542      * Cannot transfer to the zero address.
543      */
544     error TransferToZeroAddress();
545 
546     /**
547      * The token does not exist.
548      */
549     error URIQueryForNonexistentToken();
550 
551     // Compiler will pack this into a single 256bit word.
552     struct TokenOwnership {
553         // The address of the owner.
554         address addr;
555         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
556         uint64 startTimestamp;
557         // Whether the token has been burned.
558         bool burned;
559     }
560 
561     // Compiler will pack this into a single 256bit word.
562     struct AddressData {
563         // Realistically, 2**64-1 is more than enough.
564         uint64 balance;
565         // Keeps track of mint count with minimal overhead for tokenomics.
566         uint64 numberMinted;
567         // Keeps track of burn count with minimal overhead for tokenomics.
568         uint64 numberBurned;
569         // For miscellaneous variable(s) pertaining to the address
570         // (e.g. number of whitelist mint slots used).
571         // If there are multiple variables, please pack them into a uint64.
572         uint64 aux;
573     }
574 
575     /**
576      * @dev Returns the total amount of tokens stored by the contract.
577      * 
578      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
579      */
580     function totalSupply() external view returns (uint256);
581 }
582 
583 
584 // File: erc721a/contracts/ERC721A.sol
585 
586 // ERC721A Contracts v3.3.0
587 // Creator: Chiru Labs
588 
589 pragma solidity ^0.8.4;
590 
591 /**
592  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
593  * the Metadata extension. Built to optimize for lower gas during batch mints.
594  *
595  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
596  *
597  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
598  *
599  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
600  */
601 contract ERC721A is Context, ERC165, IERC721A {
602     using Address for address;
603     using Strings for uint256;
604 
605     // The tokenId of the next token to be minted.
606     uint256 internal _currentIndex;
607 
608     // The number of tokens burned.
609     uint256 internal _burnCounter;
610 
611     // Token name
612     string private _name;
613 
614     // Token symbol
615     string private _symbol;
616 
617     // Mapping from token ID to ownership details
618     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
619     mapping(uint256 => TokenOwnership) internal _ownerships;
620 
621     // Mapping owner address to address data
622     mapping(address => AddressData) private _addressData;
623 
624     // Mapping from token ID to approved address
625     mapping(uint256 => address) private _tokenApprovals;
626 
627     // Mapping from owner to operator approvals
628     mapping(address => mapping(address => bool)) private _operatorApprovals;
629 
630     constructor(string memory name_, string memory symbol_) {
631         _name = name_;
632         _symbol = symbol_;
633         _currentIndex = _startTokenId();
634     }
635 
636     /**
637      * To change the starting tokenId, please override this function.
638      */
639     function _startTokenId() internal view virtual returns (uint256) {
640         return 0;
641     }
642 
643     /**
644      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
645      */
646     function totalSupply() public view override returns (uint256) {
647         // Counter underflow is impossible as _burnCounter cannot be incremented
648         // more than _currentIndex - _startTokenId() times
649         unchecked {
650             return _currentIndex - _burnCounter - _startTokenId();
651         }
652     }
653 
654     /**
655      * Returns the total amount of tokens minted in the contract.
656      */
657     function _totalMinted() internal view returns (uint256) {
658         // Counter underflow is impossible as _currentIndex does not decrement,
659         // and it is initialized to _startTokenId()
660         unchecked {
661             return _currentIndex - _startTokenId();
662         }
663     }
664 
665     /**
666      * @dev See {IERC165-supportsInterface}.
667      */
668     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
669         return
670             interfaceId == type(IERC721).interfaceId ||
671             interfaceId == type(IERC721Metadata).interfaceId ||
672             super.supportsInterface(interfaceId);
673     }
674 
675     /**
676      * @dev See {IERC721-balanceOf}.
677      */
678     function balanceOf(address owner) public view override returns (uint256) {
679         if (owner == address(0)) revert BalanceQueryForZeroAddress();
680         return uint256(_addressData[owner].balance);
681     }
682 
683     /**
684      * Returns the number of tokens minted by `owner`.
685      */
686     function _numberMinted(address owner) internal view returns (uint256) {
687         return uint256(_addressData[owner].numberMinted);
688     }
689 
690     /**
691      * Returns the number of tokens burned by or on behalf of `owner`.
692      */
693     function _numberBurned(address owner) internal view returns (uint256) {
694         return uint256(_addressData[owner].numberBurned);
695     }
696 
697     /**
698      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
699      */
700     function _getAux(address owner) internal view returns (uint64) {
701         return _addressData[owner].aux;
702     }
703 
704     /**
705      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
706      * If there are multiple variables, please pack them into a uint64.
707      */
708     function _setAux(address owner, uint64 aux) internal {
709         _addressData[owner].aux = aux;
710     }
711 
712     /**
713      * Gas spent here starts off proportional to the maximum mint batch size.
714      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
715      */
716     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
717         uint256 curr = tokenId;
718 
719         unchecked {
720             if (_startTokenId() <= curr) if (curr < _currentIndex) {
721                 TokenOwnership memory ownership = _ownerships[curr];
722                 if (!ownership.burned) {
723                     if (ownership.addr != address(0)) {
724                         return ownership;
725                     }
726                     // Invariant:
727                     // There will always be an ownership that has an address and is not burned
728                     // before an ownership that does not have an address and is not burned.
729                     // Hence, curr will not underflow.
730                     while (true) {
731                         curr--;
732                         ownership = _ownerships[curr];
733                         if (ownership.addr != address(0)) {
734                             return ownership;
735                         }
736                     }
737                 }
738             }
739         }
740         revert OwnerQueryForNonexistentToken();
741     }
742 
743     /**
744      * @dev See {IERC721-ownerOf}.
745      */
746     function ownerOf(uint256 tokenId) public view override returns (address) {
747         return _ownershipOf(tokenId).addr;
748     }
749 
750     /**
751      * @dev See {IERC721Metadata-name}.
752      */
753     function name() public view virtual override returns (string memory) {
754         return _name;
755     }
756 
757     /**
758      * @dev See {IERC721Metadata-symbol}.
759      */
760     function symbol() public view virtual override returns (string memory) {
761         return _symbol;
762     }
763 
764     /**
765      * @dev See {IERC721Metadata-tokenURI}.
766      */
767     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
768         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
769 
770         string memory baseURI = _baseURI();
771         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
772     }
773 
774     /**
775      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
776      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
777      * by default, can be overriden in child contracts.
778      */
779     function _baseURI() internal view virtual returns (string memory) {
780         return '';
781     }
782 
783     /**
784      * @dev See {IERC721-approve}.
785      */
786     function approve(address to, uint256 tokenId) public override {
787         address owner = ERC721A.ownerOf(tokenId);
788         if (to == owner) revert ApprovalToCurrentOwner();
789 
790         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
791             revert ApprovalCallerNotOwnerNorApproved();
792         }
793 
794         _approve(to, tokenId, owner);
795     }
796 
797     /**
798      * @dev See {IERC721-getApproved}.
799      */
800     function getApproved(uint256 tokenId) public view override returns (address) {
801         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
802 
803         return _tokenApprovals[tokenId];
804     }
805 
806     /**
807      * @dev See {IERC721-setApprovalForAll}.
808      */
809     function setApprovalForAll(address operator, bool approved) public virtual override {
810         if (operator == _msgSender()) revert ApproveToCaller();
811 
812         _operatorApprovals[_msgSender()][operator] = approved;
813         emit ApprovalForAll(_msgSender(), operator, approved);
814     }
815 
816     /**
817      * @dev See {IERC721-isApprovedForAll}.
818      */
819     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
820         return _operatorApprovals[owner][operator];
821     }
822 
823     /**
824      * @dev See {IERC721-transferFrom}.
825      */
826     function transferFrom(
827         address from,
828         address to,
829         uint256 tokenId
830     ) public virtual override {
831         _transfer(from, to, tokenId);
832     }
833 
834     /**
835      * @dev See {IERC721-safeTransferFrom}.
836      */
837     function safeTransferFrom(
838         address from,
839         address to,
840         uint256 tokenId
841     ) public virtual override {
842         safeTransferFrom(from, to, tokenId, '');
843     }
844 
845     /**
846      * @dev See {IERC721-safeTransferFrom}.
847      */
848     function safeTransferFrom(
849         address from,
850         address to,
851         uint256 tokenId,
852         bytes memory _data
853     ) public virtual override {
854         _transfer(from, to, tokenId);
855         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
856             revert TransferToNonERC721ReceiverImplementer();
857         }
858     }
859 
860     /**
861      * @dev Returns whether `tokenId` exists.
862      *
863      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
864      *
865      * Tokens start existing when they are minted (`_mint`),
866      */
867     function _exists(uint256 tokenId) internal view returns (bool) {
868         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
869     }
870 
871     /**
872      * @dev Equivalent to `_safeMint(to, quantity, '')`.
873      */
874     function _safeMint(address to, uint256 quantity) internal {
875         _safeMint(to, quantity, '');
876     }
877 
878     /**
879      * @dev Safely mints `quantity` tokens and transfers them to `to`.
880      *
881      * Requirements:
882      *
883      * - If `to` refers to a smart contract, it must implement
884      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
885      * - `quantity` must be greater than 0.
886      *
887      * Emits a {Transfer} event.
888      */
889     function _safeMint(
890         address to,
891         uint256 quantity,
892         bytes memory _data
893     ) internal {
894         uint256 startTokenId = _currentIndex;
895         if (to == address(0)) revert MintToZeroAddress();
896         if (quantity == 0) revert MintZeroQuantity();
897 
898         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
899 
900         // Overflows are incredibly unrealistic.
901         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
902         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
903         unchecked {
904             _addressData[to].balance += uint64(quantity);
905             _addressData[to].numberMinted += uint64(quantity);
906 
907             _ownerships[startTokenId].addr = to;
908             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
909 
910             uint256 updatedIndex = startTokenId;
911             uint256 end = updatedIndex + quantity;
912 
913             if (to.isContract()) {
914                 do {
915                     emit Transfer(address(0), to, updatedIndex);
916                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
917                         revert TransferToNonERC721ReceiverImplementer();
918                     }
919                 } while (updatedIndex < end);
920                 // Reentrancy protection
921                 if (_currentIndex != startTokenId) revert();
922             } else {
923                 do {
924                     emit Transfer(address(0), to, updatedIndex++);
925                 } while (updatedIndex < end);
926             }
927             _currentIndex = updatedIndex;
928         }
929         _afterTokenTransfers(address(0), to, startTokenId, quantity);
930     }
931 
932     /**
933      * @dev Mints `quantity` tokens and transfers them to `to`.
934      *
935      * Requirements:
936      *
937      * - `to` cannot be the zero address.
938      * - `quantity` must be greater than 0.
939      *
940      * Emits a {Transfer} event.
941      */
942     function _mint(address to, uint256 quantity) internal {
943         uint256 startTokenId = _currentIndex;
944         if (to == address(0)) revert MintToZeroAddress();
945         if (quantity == 0) revert MintZeroQuantity();
946 
947         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
948 
949         // Overflows are incredibly unrealistic.
950         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
951         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
952         unchecked {
953             _addressData[to].balance += uint64(quantity);
954             _addressData[to].numberMinted += uint64(quantity);
955 
956             _ownerships[startTokenId].addr = to;
957             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
958 
959             uint256 updatedIndex = startTokenId;
960             uint256 end = updatedIndex + quantity;
961 
962             do {
963                 emit Transfer(address(0), to, updatedIndex++);
964             } while (updatedIndex < end);
965 
966             _currentIndex = updatedIndex;
967         }
968         _afterTokenTransfers(address(0), to, startTokenId, quantity);
969     }
970 
971     /**
972      * @dev Transfers `tokenId` from `from` to `to`.
973      *
974      * Requirements:
975      *
976      * - `to` cannot be the zero address.
977      * - `tokenId` token must be owned by `from`.
978      *
979      * Emits a {Transfer} event.
980      */
981     function _transfer(
982         address from,
983         address to,
984         uint256 tokenId
985     ) private {
986         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
987 
988         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
989 
990         bool isApprovedOrOwner = (_msgSender() == from ||
991             isApprovedForAll(from, _msgSender()) ||
992             getApproved(tokenId) == _msgSender());
993 
994         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
995         if (to == address(0)) revert TransferToZeroAddress();
996 
997         _beforeTokenTransfers(from, to, tokenId, 1);
998 
999         // Clear approvals from the previous owner
1000         _approve(address(0), tokenId, from);
1001 
1002         // Underflow of the sender's balance is impossible because we check for
1003         // ownership above and the recipient's balance can't realistically overflow.
1004         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1005         unchecked {
1006             _addressData[from].balance -= 1;
1007             _addressData[to].balance += 1;
1008 
1009             TokenOwnership storage currSlot = _ownerships[tokenId];
1010             currSlot.addr = to;
1011             currSlot.startTimestamp = uint64(block.timestamp);
1012 
1013             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1014             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1015             uint256 nextTokenId = tokenId + 1;
1016             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1017             if (nextSlot.addr == address(0)) {
1018                 // This will suffice for checking _exists(nextTokenId),
1019                 // as a burned slot cannot contain the zero address.
1020                 if (nextTokenId != _currentIndex) {
1021                     nextSlot.addr = from;
1022                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1023                 }
1024             }
1025         }
1026 
1027         emit Transfer(from, to, tokenId);
1028         _afterTokenTransfers(from, to, tokenId, 1);
1029     }
1030 
1031     /**
1032      * @dev Equivalent to `_burn(tokenId, false)`.
1033      */
1034     function _burn(uint256 tokenId) internal virtual {
1035         _burn(tokenId, false);
1036     }
1037 
1038     /**
1039      * @dev Destroys `tokenId`.
1040      * The approval is cleared when the token is burned.
1041      *
1042      * Requirements:
1043      *
1044      * - `tokenId` must exist.
1045      *
1046      * Emits a {Transfer} event.
1047      */
1048     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1049         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1050 
1051         address from = prevOwnership.addr;
1052 
1053         if (approvalCheck) {
1054             bool isApprovedOrOwner = (_msgSender() == from ||
1055                 isApprovedForAll(from, _msgSender()) ||
1056                 getApproved(tokenId) == _msgSender());
1057 
1058             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1059         }
1060 
1061         _beforeTokenTransfers(from, address(0), tokenId, 1);
1062 
1063         // Clear approvals from the previous owner
1064         _approve(address(0), tokenId, from);
1065 
1066         // Underflow of the sender's balance is impossible because we check for
1067         // ownership above and the recipient's balance can't realistically overflow.
1068         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1069         unchecked {
1070             AddressData storage addressData = _addressData[from];
1071             addressData.balance -= 1;
1072             addressData.numberBurned += 1;
1073 
1074             // Keep track of who burned the token, and the timestamp of burning.
1075             TokenOwnership storage currSlot = _ownerships[tokenId];
1076             currSlot.addr = from;
1077             currSlot.startTimestamp = uint64(block.timestamp);
1078             currSlot.burned = true;
1079 
1080             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1081             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1082             uint256 nextTokenId = tokenId + 1;
1083             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1084             if (nextSlot.addr == address(0)) {
1085                 // This will suffice for checking _exists(nextTokenId),
1086                 // as a burned slot cannot contain the zero address.
1087                 if (nextTokenId != _currentIndex) {
1088                     nextSlot.addr = from;
1089                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1090                 }
1091             }
1092         }
1093 
1094         emit Transfer(from, address(0), tokenId);
1095         _afterTokenTransfers(from, address(0), tokenId, 1);
1096 
1097         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1098         unchecked {
1099             _burnCounter++;
1100         }
1101     }
1102 
1103     /**
1104      * @dev Approve `to` to operate on `tokenId`
1105      *
1106      * Emits a {Approval} event.
1107      */
1108     function _approve(
1109         address to,
1110         uint256 tokenId,
1111         address owner
1112     ) private {
1113         _tokenApprovals[tokenId] = to;
1114         emit Approval(owner, to, tokenId);
1115     }
1116 
1117 
1118     function _checkContractOnERC721Received(
1119         address from,
1120         address to,
1121         uint256 tokenId,
1122         bytes memory _data
1123     ) private returns (bool) {
1124         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1125             return retval == IERC721Receiver(to).onERC721Received.selector;
1126         } catch (bytes memory reason) {
1127             if (reason.length == 0) {
1128                 revert TransferToNonERC721ReceiverImplementer();
1129             } else {
1130                 assembly {
1131                     revert(add(32, reason), mload(reason))
1132                 }
1133             }
1134         }
1135     }
1136 
1137  
1138     function _beforeTokenTransfers(
1139         address from,
1140         address to,
1141         uint256 startTokenId,
1142         uint256 quantity
1143     ) internal virtual {}
1144 
1145 
1146     function _afterTokenTransfers(
1147         address from,
1148         address to,
1149         uint256 startTokenId,
1150         uint256 quantity
1151     ) internal virtual {}
1152 }
1153 
1154 
1155 // File: contracts/skellywags.sol
1156 // Created by EVANZ
1157 
1158 pragma solidity >= 0.8.0 < 0.9.0;
1159 
1160 contract Skellywags is ERC721A, Ownable, ReentrancyGuard {
1161 
1162   using Strings for uint256;
1163 
1164   string public uriPrefix;
1165   string public uriSuffix = ".json";
1166   
1167   uint256 public cost = 0 ether;
1168   uint256 public maxSupply = 5000;
1169 
1170   uint256 public MaxperTx = 5;
1171   uint256 public nftPerAddressLimit = 50;
1172 
1173   bool public paused = true;
1174 
1175   mapping(address => uint256) public addressMintedBalance;
1176 
1177   constructor() ERC721A ( "SkellywagsNFT", "SW" ) {
1178     setUriPrefix( "https://arweave.net/t3SShYotzo8w0wKzeqAG7PCm6GFPU_I4itv300eJVL4/" );
1179   }
1180 
1181 // ~~~~~~~~~~~~~~~~~~~~ baseURI ~~~~~~~~~~~~~~~~~~~~
1182 
1183   function _baseURI() internal view virtual override returns (string memory) {
1184     return uriPrefix;
1185   }
1186 
1187 // ~~~~~~~~~~~~~~~~~~~~ Modifiers ~~~~~~~~~~~~~~~~~~~~
1188 
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
1204 // ~~~~~~~~~~~~~~~~~~~~ Mint Functions ~~~~~~~~~~~~~~~~~~~~
1205 
1206   // PUBLIC and WHITELIST MINT
1207   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1208     addressMintedBalance[msg.sender] += _mintAmount;
1209     _safeMint(_msgSender(), _mintAmount);
1210   }
1211 
1212   // MINT for address
1213   function mintToAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1214     require(totalSupply() + _mintAmount <= maxSupply, "Mint amount exceeds max supply!");
1215     _safeMint(_receiver, _mintAmount);
1216   }
1217 
1218 // ~~~~~~~~~~~~~~~~~~~~ Checks ~~~~~~~~~~~~~~~~~~~~
1219 
1220   // Check Wallet assets
1221   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1222     uint256 ownerTokenCount = balanceOf(_owner);
1223     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1224     uint256 currentTokenId = _startTokenId();
1225     uint256 ownedTokenIndex = 0;
1226     address latestOwnerAddress;
1227 
1228     while (ownedTokenIndex < ownerTokenCount && currentTokenId < _currentIndex) {
1229       TokenOwnership memory ownership = _ownerships[currentTokenId];
1230 
1231       if (!ownership.burned) {
1232         if (ownership.addr != address(0)) {
1233           latestOwnerAddress = ownership.addr;
1234         }
1235 
1236         if (latestOwnerAddress == _owner) {
1237           ownedTokenIds[ownedTokenIndex] = currentTokenId;
1238           ownedTokenIndex++;
1239         }
1240       }
1241       currentTokenId++;
1242     }
1243     return ownedTokenIds;
1244   }
1245 
1246   // Start Token
1247   function _startTokenId() internal view virtual override returns (uint256) {
1248     return 1;
1249   }
1250 
1251   // TOKEN URI <= If you are reading this you are awesome!!
1252   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1253     require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token.");
1254 
1255     string memory currentBaseURI = _baseURI();
1256     return bytes(currentBaseURI).length > 0
1257     ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1258     : "";
1259   }
1260 
1261 // ~~~~~~~~~~~~~~~~~~~~ onlyOwner Functions ~~~~~~~~~~~~~~~~~~~~
1262 
1263   function setCost(uint256 _cost) public onlyOwner {
1264     cost = _cost;
1265   }
1266 
1267   function setMaxperTx(uint256 _maxMintperTx) public onlyOwner {
1268     MaxperTx = _maxMintperTx;
1269   }
1270 
1271   // BaseURI
1272   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1273     uriPrefix = _uriPrefix;
1274   }
1275 
1276   function pause() public onlyOwner {
1277     if (paused == true) { paused = false; }
1278     else { paused = true; }
1279   }
1280 
1281   function withdraw() external onlyOwner nonReentrant {
1282     (bool success, ) = payable(owner()).call{value: address(this).balance}("");
1283     require(success);
1284   }
1285 }