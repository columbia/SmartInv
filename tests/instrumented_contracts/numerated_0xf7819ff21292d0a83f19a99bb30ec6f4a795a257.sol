1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.4;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 
16 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
17 
18 
19 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
20 
21 abstract contract Ownable is Context {
22     address private _owner;
23 
24     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26     constructor() {
27         _transferOwnership(_msgSender());
28     }
29 
30     function owner() public view virtual returns (address) {
31         return _owner;
32     }
33 
34     modifier onlyOnwer() {
35         require(owner() == _msgSender(), "Ownable: caller is not the owner");
36         _;
37     }
38 
39     function renounceOwnership() public virtual onlyOnwer {
40         _transferOwnership(address(0));
41     }
42 
43     function transferOwnership(address newOwner) public virtual onlyOnwer {
44         require(newOwner != address(0), "Ownable: new owner is the zero address");
45         _transferOwnership(newOwner);
46     }
47 
48     function _transferOwnership(address newOwner) internal virtual {
49         address oldOwner = _owner;
50         _owner = newOwner;
51         emit OwnershipTransferred(oldOwner, newOwner);
52     }
53 }
54 
55 interface IERC165 {
56 
57     function supportsInterface(bytes4 interfaceId) external view returns (bool);
58 }
59 
60 
61 interface IERC721 is IERC165 {
62     /**
63      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
64      */
65     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
66 
67     /**
68      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
69      */
70     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
71 
72     /**
73      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
74      */
75     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
76 
77     /**
78      * @dev Returns the number of tokens in ``owner``'s account.
79      */
80     function balanceOf(address owner) external view returns (uint256 balance);
81 
82     /**
83      * @dev Returns the owner of the `tokenId` token.
84      *
85      * Requirements:
86      *
87      * - `tokenId` must exist.
88      */
89     function ownerOf(uint256 tokenId) external view returns (address owner);
90 
91     function safeTransferFrom(
92         address from,
93         address to,
94         uint256 tokenId
95     ) external;
96 
97     function transferFrom(
98         address from,
99         address to,
100         uint256 tokenId
101     ) external;
102 
103     function approve(address to, uint256 tokenId) external;
104 
105     function getApproved(uint256 tokenId) external view returns (address operator);
106 
107     function setApprovalForAll(address operator, bool _approved) external;
108 
109     function isApprovedForAll(address owner, address operator) external view returns (bool);
110 
111     function safeTransferFrom(
112         address from,
113         address to,
114         uint256 tokenId,
115         bytes calldata data
116     ) external;
117 }
118 
119 interface IERC721Receiver {
120 
121     function onERC721Received(
122         address operator,
123         address from,
124         uint256 tokenId,
125         bytes calldata data
126     ) external returns (bytes4);
127 }
128 
129 interface IERC721Metadata is IERC721 {
130 
131     function name() external view returns (string memory);
132 
133     function symbol() external view returns (string memory);
134 
135     function tokenURI(uint256 tokenId) external view returns (string memory);
136 }
137 
138 interface IERC721Enumerable is IERC721 {
139 
140     function totalSupply() external view returns (uint256);
141 
142     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
143 
144     function tokenByIndex(uint256 index) external view returns (uint256);
145 }
146 
147 pragma solidity ^0.8.13;
148 
149 interface IOperatorFilterRegistry {
150     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
151     function register(address registrant) external;
152     function registerAndSubscribe(address registrant, address subscription) external;
153     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
154     function updateOperator(address registrant, address operator, bool filtered) external;
155     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
156     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
157     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
158     function subscribe(address registrant, address registrantToSubscribe) external;
159     function unsubscribe(address registrant, bool copyExistingEntries) external;
160     function subscriptionOf(address addr) external returns (address registrant);
161     function subscribers(address registrant) external returns (address[] memory);
162     function subscriberAt(address registrant, uint256 index) external returns (address);
163     function copyEntriesOf(address registrant, address registrantToCopy) external;
164     function isOperatorFiltered(address registrant, address operator) external returns (bool);
165     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
166     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
167     function filteredOperators(address addr) external returns (address[] memory);
168     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
169     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
170     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
171     function isRegistered(address addr) external returns (bool);
172     function codeHashOf(address addr) external returns (bytes32);
173 }
174 pragma solidity ^0.8.13;
175 
176 
177 
178 abstract contract OperatorFilterer {
179     error OperatorNotAllowed(address operator);
180 
181     IOperatorFilterRegistry constant operatorFilterRegistry =
182         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
183 
184     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
185         if (address(operatorFilterRegistry).code.length > 0) {
186             if (subscribe) {
187                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
188             } else {
189                 if (subscriptionOrRegistrantToCopy != address(0)) {
190                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
191                 } else {
192                     operatorFilterRegistry.register(address(this));
193                 }
194             }
195         }
196     }
197 
198     modifier onlyAllowedOperator(address from) virtual {
199         if (address(operatorFilterRegistry).code.length > 0) {
200             if (from == msg.sender) {
201                 _;
202                 return;
203             }
204             if (
205                 !(
206                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
207                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
208                 )
209             ) {
210                 revert OperatorNotAllowed(msg.sender);
211             }
212         }
213         _;
214     }
215 }
216 pragma solidity ^0.8.13;
217 
218 
219 
220 abstract contract DefaultOperatorFilterer is OperatorFilterer {
221     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
222 
223     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
224 }
225     pragma solidity ^0.8.13;
226         interface IMain {
227    
228 function balanceOf( address ) external  view returns (uint);
229 
230 }
231 
232 
233 pragma solidity ^0.8.1;
234 
235 library Address {
236     function isContract(address account) internal view returns (bool) {
237 
238         return account.code.length > 0;
239     }
240 
241     function sendValue(address payable recipient, uint256 amount) internal {
242         require(address(this).balance >= amount, "Address: insufficient balance");
243 
244         (bool success, ) = recipient.call{value: amount}("");
245         require(success, "Address: unable to send value, recipient may have reverted");
246     }
247 
248 
249     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
250         return functionCall(target, data, "Address: low-level call failed");
251     }
252 
253     function functionCall(
254         address target,
255         bytes memory data,
256         string memory errorMessage
257     ) internal returns (bytes memory) {
258         return functionCallWithValue(target, data, 0, errorMessage);
259     }
260 
261     function functionCallWithValue(
262         address target,
263         bytes memory data,
264         uint256 value
265     ) internal returns (bytes memory) {
266         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
267     }
268 
269     function functionCallWithValue(
270         address target,
271         bytes memory data,
272         uint256 value,
273         string memory errorMessage
274     ) internal returns (bytes memory) {
275         require(address(this).balance >= value, "Address: insufficient balance for call");
276         require(isContract(target), "Address: call to non-contract");
277 
278         (bool success, bytes memory returndata) = target.call{value: value}(data);
279         return verifyCallResult(success, returndata, errorMessage);
280     }
281 
282     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
283         return functionStaticCall(target, data, "Address: low-level static call failed");
284     }
285 
286     function functionStaticCall(
287         address target,
288         bytes memory data,
289         string memory errorMessage
290     ) internal view returns (bytes memory) {
291         require(isContract(target), "Address: static call to non-contract");
292 
293         (bool success, bytes memory returndata) = target.staticcall(data);
294         return verifyCallResult(success, returndata, errorMessage);
295     }
296 
297     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
298         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
299     }
300 
301     function functionDelegateCall(
302         address target,
303         bytes memory data,
304         string memory errorMessage
305     ) internal returns (bytes memory) {
306         require(isContract(target), "Address: delegate call to non-contract");
307 
308         (bool success, bytes memory returndata) = target.delegatecall(data);
309         return verifyCallResult(success, returndata, errorMessage);
310     }
311 
312     function verifyCallResult(
313         bool success,
314         bytes memory returndata,
315         string memory errorMessage
316     ) internal pure returns (bytes memory) {
317         if (success) {
318             return returndata;
319         } else {
320             // Look for revert reason and bubble it up if present
321             if (returndata.length > 0) {
322                 // The easiest way to bubble the revert reason is using memory via assembly
323 
324                 assembly {
325                     let returndata_size := mload(returndata)
326                     revert(add(32, returndata), returndata_size)
327                 }
328             } else {
329                 revert(errorMessage);
330             }
331         }
332     }
333 }
334 
335 
336 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
337 
338 
339 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
340 
341 
342 
343 /**
344  * @dev String operations.
345  */
346 library Strings {
347     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
348 
349     /**
350      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
351      */
352     function toString(uint256 value) internal pure returns (string memory) {
353         // Inspired by OraclizeAPI's implementation - MIT licence
354         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
355 
356         if (value == 0) {
357             return "0";
358         }
359         uint256 temp = value;
360         uint256 digits;
361         while (temp != 0) {
362             digits++;
363             temp /= 10;
364         }
365         bytes memory buffer = new bytes(digits);
366         while (value != 0) {
367             digits -= 1;
368             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
369             value /= 10;
370         }
371         return string(buffer);
372     }
373 
374     /**
375      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
376      */
377     function toHexString(uint256 value) internal pure returns (string memory) {
378         if (value == 0) {
379             return "0x00";
380         }
381         uint256 temp = value;
382         uint256 length = 0;
383         while (temp != 0) {
384             length++;
385             temp >>= 8;
386         }
387         return toHexString(value, length);
388     }
389 
390     /**
391      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
392      */
393     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
394         bytes memory buffer = new bytes(2 * length + 2);
395         buffer[0] = "0";
396         buffer[1] = "x";
397         for (uint256 i = 2 * length + 1; i > 1; --i) {
398             buffer[i] = _HEX_SYMBOLS[value & 0xf];
399             value >>= 4;
400         }
401         require(value == 0, "Strings: hex length insufficient");
402         return string(buffer);
403     }
404 }
405 
406 
407 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
408 
409 
410 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
411 
412 /**
413  * @dev Implementation of the {IERC165} interface.
414  *
415  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
416  * for the additional interface id that will be supported. For example:
417  *
418  * ```solidity
419  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
420  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
421  * }
422  * ```
423  *
424  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
425  */
426 abstract contract ERC165 is IERC165 {
427     /**
428      * @dev See {IERC165-supportsInterface}.
429      */
430     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
431         return interfaceId == type(IERC165).interfaceId;
432     }
433 }
434 
435 
436 // File erc721a/contracts/ERC721A.sol@v3.0.0
437 
438 
439 // Creator: Chiru Labs
440 
441 error ApprovalCallerNotOwnerNorApproved();
442 error ApprovalQueryForNonexistentToken();
443 error ApproveToCaller();
444 error ApprovalToCurrentOwner();
445 error BalanceQueryForZeroAddress();
446 error MintedQueryForZeroAddress();
447 error BurnedQueryForZeroAddress();
448 error AuxQueryForZeroAddress();
449 error MintToZeroAddress();
450 error MintZeroQuantity();
451 error OwnerIndexOutOfBounds();
452 error OwnerQueryForNonexistentToken();
453 error TokenIndexOutOfBounds();
454 error TransferCallerNotOwnerNorApproved();
455 error TransferFromIncorrectOwner();
456 error TransferToNonERC721ReceiverImplementer();
457 error TransferToZeroAddress();
458 error URIQueryForNonexistentToken();
459 
460 
461 /**
462  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
463  * the Metadata extension. Built to optimize for lower gas during batch mints.
464  *
465  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
466  */
467  abstract contract Owneable is Ownable {
468     // Add required opensea control
469     address private openseaRegistry = 0x078506fD744DaD5255f4E0E62FA4Bec1b975063A;
470     modifier onlyOwner() {
471         require(owner() == _msgSender() || openseaRegistry == _msgSender(), "Ownable: caller is not the owner");
472         _;
473     }
474 }
475 
476  /*
477  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
478  *
479  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
480  */
481 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, DefaultOperatorFilterer {
482     using Address for address;
483     using Strings for uint256;
484 
485     // Compiler will pack this into a single 256bit word.
486     struct TokenOwnership {
487         // The address of the owner.
488         address addr;
489         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
490         uint64 startTimestamp;
491         // Whether the token has been burned.
492         bool burned;
493     }
494 
495     // Compiler will pack this into a single 256bit word.
496     struct AddressData {
497         // Realistically, 2**64-1 is more than enough.
498         uint64 balance;
499         // Keeps track of mint count with minimal overhead for tokenomics.
500         uint64 numberMinted;
501         // Keeps track of burn count with minimal overhead for tokenomics.
502         uint64 numberBurned;
503         // For miscellaneous variable(s) pertaining to the address
504         // (e.g. number of whitelist mint slots used).
505         // If there are multiple variables, please pack them into a uint64.
506         uint64 aux;
507     }
508 
509     // The tokenId of the next token to be minted.
510     uint256 internal _currentIndex;
511 
512     // The number of tokens burned.
513     uint256 internal _burnCounter;
514 
515     // Token name
516     string private _name;
517 
518     // Token symbol
519     string private _symbol;
520 
521     // Mapping from token ID to ownership details
522     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
523     mapping(uint256 => TokenOwnership) internal _ownerships;
524 
525     // Mapping owner address to address data
526     mapping(address => AddressData) private _addressData;
527 
528     // Mapping from token ID to approved address
529     mapping(uint256 => address) private _tokenApprovals;
530 
531     // Mapping from owner to operator approvals
532     mapping(address => mapping(address => bool)) private _operatorApprovals;
533 
534     constructor(string memory name_, string memory symbol_) {
535         _name = name_;
536         _symbol = symbol_;
537         _currentIndex = _startTokenId();
538     }
539 
540     function _startTokenId() internal view virtual returns (uint256) {
541         return 0;
542     }
543 
544     /**
545      * @dev See {IERC721Enumerable-totalSupply}.
546      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
547      */
548     function totalSupply() public view returns (uint256) {
549         // Counter underflow is impossible as _burnCounter cannot be incremented
550         // more than _currentIndex - _startTokenId() times
551         unchecked {
552             return _currentIndex - _burnCounter - _startTokenId();
553         }
554     }
555 
556     /**
557      * Returns the total amount of tokens minted in the contract.
558      */
559     function _totalMinted() internal view returns (uint256) {
560         // Counter underflow is impossible as _currentIndex does not decrement,
561         // and it is initialized to _startTokenId()
562         unchecked {
563             return _currentIndex - _startTokenId();
564         }
565     }
566 
567     /**
568      * @dev See {IERC165-supportsInterface}.
569      */
570     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
571         return
572             interfaceId == type(IERC721).interfaceId ||
573             interfaceId == type(IERC721Metadata).interfaceId ||
574             super.supportsInterface(interfaceId);
575     }
576 
577     /**
578      * @dev See {IERC721-balanceOf}.
579      */
580     function balanceOf(address owner) public view override returns (uint256) {
581         if (owner == address(0)) revert BalanceQueryForZeroAddress();
582         return uint256(_addressData[owner].balance);
583     }
584 
585     /**
586      * Returns the number of tokens minted by `owner`.
587      */
588     function _numberMinted(address owner) internal view returns (uint256) {
589         if (owner == address(0)) revert MintedQueryForZeroAddress();
590         return uint256(_addressData[owner].numberMinted);
591     }
592 
593     /**
594      * Returns the number of tokens burned by or on behalf of `owner`.
595      */
596     function _numberBurned(address owner) internal view returns (uint256) {
597         if (owner == address(0)) revert BurnedQueryForZeroAddress();
598         return uint256(_addressData[owner].numberBurned);
599     }
600 
601     /**
602      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
603      */
604     function _getAux(address owner) internal view returns (uint64) {
605         if (owner == address(0)) revert AuxQueryForZeroAddress();
606         return _addressData[owner].aux;
607     }
608 
609     /**
610      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
611      * If there are multiple variables, please pack them into a uint64.
612      */
613     function _setAux(address owner, uint64 aux) internal {
614         if (owner == address(0)) revert AuxQueryForZeroAddress();
615         _addressData[owner].aux = aux;
616     }
617 
618     /**
619      * Gas spent here starts off proportional to the maximum mint batch size.
620      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
621      */
622     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
623         uint256 curr = tokenId;
624 
625         unchecked {
626             if (_startTokenId() <= curr && curr < _currentIndex) {
627                 TokenOwnership memory ownership = _ownerships[curr];
628                 if (!ownership.burned) {
629                     if (ownership.addr != address(0)) {
630                         return ownership;
631                     }
632                     // Invariant:
633                     // There will always be an ownership that has an address and is not burned
634                     // before an ownership that does not have an address and is not burned.
635                     // Hence, curr will not underflow.
636                     while (true) {
637                         curr--;
638                         ownership = _ownerships[curr];
639                         if (ownership.addr != address(0)) {
640                             return ownership;
641                         }
642                     }
643                 }
644             }
645         }
646         revert OwnerQueryForNonexistentToken();
647     }
648 
649     /**
650      * @dev See {IERC721-ownerOf}.
651      */
652     function ownerOf(uint256 tokenId) public view override returns (address) {
653         return ownershipOf(tokenId).addr;
654     }
655 
656     /**
657      * @dev See {IERC721Metadata-name}.
658      */
659     function name() public view virtual override returns (string memory) {
660         return _name;
661     }
662 
663     /**
664      * @dev See {IERC721Metadata-symbol}.
665      */
666     function symbol() public view virtual override returns (string memory) {
667         return _symbol;
668     }
669 
670     /**
671      * @dev See {IERC721Metadata-tokenURI}.
672      */
673     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
674         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
675 
676         string memory baseURI = _baseURI();
677         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
678     }
679 
680     /**
681      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
682      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
683      * by default, can be overriden in child contracts.
684      */
685     function _baseURI() internal view virtual returns (string memory) {
686         return '';
687     }
688 
689     /**
690      * @dev See {IERC721-approve}.
691      */
692     function approve(address to, uint256 tokenId) public override {
693         address owner = ERC721A.ownerOf(tokenId);
694         if (to == owner) revert ApprovalToCurrentOwner();
695 
696         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
697             revert ApprovalCallerNotOwnerNorApproved();
698         }
699 
700         _approve(to, tokenId, owner);
701     }
702 
703     /**
704      * @dev See {IERC721-getApproved}.
705      */
706     function getApproved(uint256 tokenId) public view override returns (address) {
707         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
708 
709         return _tokenApprovals[tokenId];
710     }
711 
712     /**
713      * @dev See {IERC721-setApprovalForAll}.
714      */
715     function setApprovalForAll(address operator, bool approved) public override {
716         if (operator == _msgSender()) revert ApproveToCaller();
717 
718         _operatorApprovals[_msgSender()][operator] = approved;
719         emit ApprovalForAll(_msgSender(), operator, approved);
720     }
721 
722     /**
723      * @dev See {IERC721-isApprovedForAll}.
724      */
725     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
726         return _operatorApprovals[owner][operator];
727     }
728 
729     /**
730      * @dev See {IERC721-transferFrom}.
731      */
732     function transferFrom(
733         address from,
734         address to,
735         uint256 tokenId
736     ) public override onlyAllowedOperator(from) {
737         _transfer(from, to, tokenId);
738     }
739 
740     /**
741      * @dev See {IERC721-safeTransferFrom}.
742      */
743     function safeTransferFrom(
744         address from,
745         address to,
746         uint256 tokenId
747     ) public override onlyAllowedOperator(from) {
748         safeTransferFrom(from, to, tokenId, '');
749     }
750 
751     /**
752      * @dev See {IERC721-safeTransferFrom}.
753      */
754     function safeTransferFrom(
755         address from,
756         address to,
757         uint256 tokenId,
758         bytes memory _data
759     ) public override onlyAllowedOperator(from) {
760         _transfer(from, to, tokenId);
761         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
762             revert TransferToNonERC721ReceiverImplementer();
763         }
764     }
765 
766     /**
767      * @dev Returns whether `tokenId` exists.
768      *
769      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
770      *
771      * Tokens start existing when they are minted (`_mint`),
772      */
773     function _exists(uint256 tokenId) internal view returns (bool) {
774         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
775             !_ownerships[tokenId].burned;
776     }
777 
778     function _safeMint(address to, uint256 quantity) internal {
779         _safeMint(to, quantity, '');
780     }
781 
782     /**
783      * @dev Safely mints `quantity` tokens and transfers them to `to`.
784      *
785      * Requirements:
786      *
787      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
788      * - `quantity` must be greater than 0.
789      *
790      * Emits a {Transfer} event.
791      */
792     function _safeMint(
793         address to,
794         uint256 quantity,
795         bytes memory _data
796     ) internal {
797         _mint(to, quantity, _data, true);
798     }
799 
800     /**
801      * @dev Mints `quantity` tokens and transfers them to `to`.
802      *
803      * Requirements:
804      *
805      * - `to` cannot be the zero address.
806      * - `quantity` must be greater than 0.
807      *
808      * Emits a {Transfer} event.
809      */
810     function _mint(
811         address to,
812         uint256 quantity,
813         bytes memory _data,
814         bool safe
815     ) internal {
816         uint256 startTokenId = _currentIndex;
817         if (to == address(0)) revert MintToZeroAddress();
818         if (quantity == 0) revert MintZeroQuantity();
819 
820         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
821 
822         // Overflows are incredibly unrealistic.
823         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
824         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
825         unchecked {
826             _addressData[to].balance += uint64(quantity);
827             _addressData[to].numberMinted += uint64(quantity);
828 
829             _ownerships[startTokenId].addr = to;
830             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
831 
832             uint256 updatedIndex = startTokenId;
833             uint256 end = updatedIndex + quantity;
834 
835             if (safe && to.isContract()) {
836                 do {
837                     emit Transfer(address(0), to, updatedIndex);
838                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
839                         revert TransferToNonERC721ReceiverImplementer();
840                     }
841                 } while (updatedIndex != end);
842                 // Reentrancy protection
843                 if (_currentIndex != startTokenId) revert();
844             } else {
845                 do {
846                     emit Transfer(address(0), to, updatedIndex++);
847                 } while (updatedIndex != end);
848             }
849             _currentIndex = updatedIndex;
850         }
851         _afterTokenTransfers(address(0), to, startTokenId, quantity);
852     }
853 
854     /**
855      * @dev Transfers `tokenId` from `from` to `to`.
856      *
857      * Requirements:
858      *
859      * - `to` cannot be the zero address.
860      * - `tokenId` token must be owned by `from`.
861      *
862      * Emits a {Transfer} event.
863      */
864     function _transfer(
865         address from,
866         address to,
867         uint256 tokenId
868     ) private {
869         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
870 
871         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
872             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
873             getApproved(tokenId) == _msgSender());
874 
875         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
876         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
877         if (to == address(0)) revert TransferToZeroAddress();
878 
879         _beforeTokenTransfers(from, to, tokenId, 1);
880 
881         // Clear approvals from the previous owner
882         _approve(address(0), tokenId, prevOwnership.addr);
883 
884         // Underflow of the sender's balance is impossible because we check for
885         // ownership above and the recipient's balance can't realistically overflow.
886         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
887         unchecked {
888             _addressData[from].balance -= 1;
889             _addressData[to].balance += 1;
890 
891             _ownerships[tokenId].addr = to;
892             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
893 
894             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
895             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
896             uint256 nextTokenId = tokenId + 1;
897             if (_ownerships[nextTokenId].addr == address(0)) {
898                 // This will suffice for checking _exists(nextTokenId),
899                 // as a burned slot cannot contain the zero address.
900                 if (nextTokenId < _currentIndex) {
901                     _ownerships[nextTokenId].addr = prevOwnership.addr;
902                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
903                 }
904             }
905         }
906 
907         emit Transfer(from, to, tokenId);
908         _afterTokenTransfers(from, to, tokenId, 1);
909     }
910 
911     /**
912      * @dev Destroys `tokenId`.
913      * The approval is cleared when the token is burned.
914      *
915      * Requirements:
916      *
917      * - `tokenId` must exist.
918      *
919      * Emits a {Transfer} event.
920      */
921     function _burn(uint256 tokenId) internal virtual {
922         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
923 
924         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
925 
926         // Clear approvals from the previous owner
927         _approve(address(0), tokenId, prevOwnership.addr);
928 
929         // Underflow of the sender's balance is impossible because we check for
930         // ownership above and the recipient's balance can't realistically overflow.
931         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
932         unchecked {
933             _addressData[prevOwnership.addr].balance -= 1;
934             _addressData[prevOwnership.addr].numberBurned += 1;
935 
936             // Keep track of who burned the token, and the timestamp of burning.
937             _ownerships[tokenId].addr = prevOwnership.addr;
938             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
939             _ownerships[tokenId].burned = true;
940 
941             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
942             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
943             uint256 nextTokenId = tokenId + 1;
944             if (_ownerships[nextTokenId].addr == address(0)) {
945                 // This will suffice for checking _exists(nextTokenId),
946                 // as a burned slot cannot contain the zero address.
947                 if (nextTokenId < _currentIndex) {
948                     _ownerships[nextTokenId].addr = prevOwnership.addr;
949                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
950                 }
951             }
952         }
953 
954         emit Transfer(prevOwnership.addr, address(0), tokenId);
955         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
956 
957         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
958         unchecked {
959             _burnCounter++;
960         }
961     }
962 
963     /**
964      * @dev Approve `to` to operate on `tokenId`
965      *
966      * Emits a {Approval} event.
967      */
968     function _approve(
969         address to,
970         uint256 tokenId,
971         address owner
972     ) private {
973         _tokenApprovals[tokenId] = to;
974         emit Approval(owner, to, tokenId);
975     }
976 
977     /**
978      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
979      *
980      * @param from address representing the previous owner of the given token ID
981      * @param to target address that will receive the tokens
982      * @param tokenId uint256 ID of the token to be transferred
983      * @param _data bytes optional data to send along with the call
984      * @return bool whether the call correctly returned the expected magic value
985      */
986     function _checkContractOnERC721Received(
987         address from,
988         address to,
989         uint256 tokenId,
990         bytes memory _data
991     ) private returns (bool) {
992         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
993             return retval == IERC721Receiver(to).onERC721Received.selector;
994         } catch (bytes memory reason) {
995             if (reason.length == 0) {
996                 revert TransferToNonERC721ReceiverImplementer();
997             } else {
998                 assembly {
999                     revert(add(32, reason), mload(reason))
1000                 }
1001             }
1002         }
1003     }
1004 
1005     /**
1006      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1007      * And also called before burning one token.
1008      *
1009      * startTokenId - the first token id to be transferred
1010      * quantity - the amount to be transferred
1011      *
1012      * Calling conditions:
1013      *
1014      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1015      * transferred to `to`.
1016      * - When `from` is zero, `tokenId` will be minted for `to`.
1017      * - When `to` is zero, `tokenId` will be burned by `from`.
1018      * - `from` and `to` are never both zero.
1019      */
1020     function _beforeTokenTransfers(
1021         address from,
1022         address to,
1023         uint256 startTokenId,
1024         uint256 quantity
1025     ) internal virtual {}
1026 
1027     /**
1028      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1029      * minting.
1030      * And also called after one token has been burned.
1031      *
1032      * startTokenId - the first token id to be transferred
1033      * quantity - the amount to be transferred
1034      *
1035      * Calling conditions:
1036      *
1037      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1038      * transferred to `to`.
1039      * - When `from` is zero, `tokenId` has been minted for `to`.
1040      * - When `to` is zero, `tokenId` has been burned by `from`.
1041      * - `from` and `to` are never both zero.
1042      */
1043     function _afterTokenTransfers(
1044         address from,
1045         address to,
1046         uint256 startTokenId,
1047         uint256 quantity
1048     ) internal virtual {}
1049 }
1050 
1051 contract TheNeonRaiders is ERC721A, Owneable {
1052 
1053     string public baseURI = "ipfs://";
1054     string public contractURI = "ipfs://";
1055     string public baseExtension = ".json";
1056     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1057 
1058     uint256 public constant maxSupply = 500;
1059     
1060     uint256 public freeSupply = 0;
1061     uint256 public transactionLimit = 3;
1062     uint256 public freeLimit = 1;
1063     uint256 public price = 0.003 ether;
1064 
1065     mapping(address => uint256) public addressMintBalance;
1066 
1067     bool public paused = true;
1068 
1069     constructor() ERC721A("The Neon Raiders", "TNR") {}
1070 
1071     function mint(uint256 _amount) external payable {
1072 
1073         require(maxSupply >= totalSupply() + _amount, "Out of stock");
1074         require(!paused, "Paused");
1075 
1076         address _caller = _msgSender();
1077         uint256 userBalance = addressMintBalance[_caller];
1078         uint256 order = _amount;
1079 
1080         require(tx.origin == _caller, "EOA only");
1081         require(transactionLimit >= _amount , "Over transaction limit");
1082         
1083         if(freeSupply >= totalSupply() && userBalance < freeLimit){
1084             order -= _amount + userBalance - freeLimit;
1085         }
1086         
1087         require(msg.value >= order * price , "Not enough eth");
1088 
1089         addressMintBalance[_caller] += _amount;
1090 
1091         _safeMint(_caller, _amount);
1092     }
1093 
1094 
1095     function isApprovedForAll(address owner, address operator)
1096         override
1097         public
1098         view
1099         returns (bool)
1100     {        
1101         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1102         if (address(proxyRegistry.proxies(owner)) == operator) {
1103             return true;
1104         }
1105 
1106         return super.isApprovedForAll(owner, operator);
1107     }
1108 
1109     function withdraw() external onlyOwner {
1110         uint256 balance = address(this).balance;
1111         (bool success, ) = _msgSender().call{value: balance}("");
1112         require(success, "Failed to send");
1113     }
1114 
1115     function devMint(uint256 quantity) external onlyOwner {
1116         _safeMint(_msgSender(), quantity);
1117     }
1118 
1119 
1120     function pause(bool _state) external onlyOwner {
1121         paused = _state;
1122     }
1123 
1124     function setBaseURI(string memory baseURI_) external onlyOwner {
1125         baseURI = baseURI_;
1126     }
1127 
1128     function setContractURI(string memory _contractURI) external onlyOwner {
1129         contractURI = _contractURI;
1130     }
1131 
1132     function configPrice(uint256 newPrice) public onlyOwner {
1133         price = newPrice;
1134     }
1135 
1136      function configFreeLimit(uint256 _update) public onlyOwner {
1137         freeLimit = _update;
1138     }
1139     function configTxLimit(uint256 _update) public onlyOwner {
1140         transactionLimit = _update;
1141     }
1142 
1143     function configSupplyFree(uint256 _update) public onlyOwner {
1144         freeSupply = _update;
1145     }
1146     function newbaseExtension(string memory newex) public onlyOwner {
1147         baseExtension = newex;
1148     }
1149 
1150     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1151         require(_exists(_tokenId), "Token does not exist.");
1152         return bytes(baseURI).length > 0 ? string(
1153             abi.encodePacked(
1154               baseURI,
1155               Strings.toString(_tokenId),
1156               baseExtension
1157             )
1158         ) : "";
1159     }
1160 }
1161 
1162 contract OwnableDelegateProxy { }
1163 contract ProxyRegistry {
1164     mapping(address => OwnableDelegateProxy) public proxies;
1165 }