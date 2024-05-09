1 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.4;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes calldata) {
14         return msg.data;
15     }
16 }
17 
18 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
19 
20 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
21 
22 abstract contract Ownable is Context {
23     address private _owner;
24 
25     event OwnershipTransferred(
26         address indexed previousOwner,
27         address indexed newOwner
28     );
29 
30     constructor() {
31         _transferOwnership(_msgSender());
32     }
33 
34     function owner() public view virtual returns (address) {
35         return _owner;
36     }
37 
38     modifier onlyOnwer() {
39         require(owner() == _msgSender(), "Ownable: caller is not the owner");
40         _;
41     }
42 
43     function renounceOwnership() public virtual onlyOnwer {
44         _transferOwnership(address(0));
45     }
46 
47     function transferOwnership(address newOwner) public virtual onlyOnwer {
48         require(
49             newOwner != address(0),
50             "Ownable: new owner is the zero address"
51         );
52         _transferOwnership(newOwner);
53     }
54 
55     function _transferOwnership(address newOwner) internal virtual {
56         address oldOwner = _owner;
57         _owner = newOwner;
58         emit OwnershipTransferred(oldOwner, newOwner);
59     }
60 }
61 
62 interface IERC165 {
63     function supportsInterface(bytes4 interfaceId) external view returns (bool);
64 }
65 
66 interface IERC721 is IERC165 {
67     /**
68      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
69      */
70     event Transfer(
71         address indexed from,
72         address indexed to,
73         uint256 indexed tokenId
74     );
75 
76     /**
77      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
78      */
79     event Approval(
80         address indexed owner,
81         address indexed approved,
82         uint256 indexed tokenId
83     );
84 
85     /**
86      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
87      */
88     event ApprovalForAll(
89         address indexed owner,
90         address indexed operator,
91         bool approved
92     );
93 
94     /**
95      * @dev Returns the number of tokens in ``owner``'s account.
96      */
97     function balanceOf(address owner) external view returns (uint256 balance);
98 
99     /**
100      * @dev Returns the owner of the `tokenId` token.
101      *
102      * Requirements:
103      *
104      * - `tokenId` must exist.
105      */
106     function ownerOf(uint256 tokenId) external view returns (address owner);
107 
108     function safeTransferFrom(
109         address from,
110         address to,
111         uint256 tokenId
112     ) external;
113 
114     function transferFrom(
115         address from,
116         address to,
117         uint256 tokenId
118     ) external;
119 
120     function approve(address to, uint256 tokenId) external;
121 
122     function getApproved(uint256 tokenId)
123         external
124         view
125         returns (address operator);
126 
127     function setApprovalForAll(address operator, bool _approved) external;
128 
129     function isApprovedForAll(address owner, address operator)
130         external
131         view
132         returns (bool);
133 
134     function safeTransferFrom(
135         address from,
136         address to,
137         uint256 tokenId,
138         bytes calldata data
139     ) external;
140 }
141 
142 interface IERC721Receiver {
143     function onERC721Received(
144         address operator,
145         address from,
146         uint256 tokenId,
147         bytes calldata data
148     ) external returns (bytes4);
149 }
150 
151 interface IERC721Metadata is IERC721 {
152     function name() external view returns (string memory);
153 
154     function symbol() external view returns (string memory);
155 
156     function tokenURI(uint256 tokenId) external view returns (string memory);
157 }
158 
159 interface IERC721Enumerable is IERC721 {
160     function totalSupply() external view returns (uint256);
161 
162     function tokenOfOwnerByIndex(address owner, uint256 index)
163         external
164         view
165         returns (uint256);
166 
167     function tokenByIndex(uint256 index) external view returns (uint256);
168 }
169 
170 interface IOperatorFilterRegistry {
171     function isOperatorAllowed(address registrant, address operator)
172         external
173         view
174         returns (bool);
175 
176     function register(address registrant) external;
177 
178     function registerAndSubscribe(address registrant, address subscription)
179         external;
180 
181     function registerAndCopyEntries(
182         address registrant,
183         address registrantToCopy
184     ) external;
185 
186     function updateOperator(
187         address registrant,
188         address operator,
189         bool filtered
190     ) external;
191 
192     function updateOperators(
193         address registrant,
194         address[] calldata operators,
195         bool filtered
196     ) external;
197 
198     function updateCodeHash(
199         address registrant,
200         bytes32 codehash,
201         bool filtered
202     ) external;
203 
204     function updateCodeHashes(
205         address registrant,
206         bytes32[] calldata codeHashes,
207         bool filtered
208     ) external;
209 
210     function subscribe(address registrant, address registrantToSubscribe)
211         external;
212 
213     function unsubscribe(address registrant, bool copyExistingEntries) external;
214 
215     function subscriptionOf(address addr) external returns (address registrant);
216 
217     function subscribers(address registrant)
218         external
219         returns (address[] memory);
220 
221     function subscriberAt(address registrant, uint256 index)
222         external
223         returns (address);
224 
225     function copyEntriesOf(address registrant, address registrantToCopy)
226         external;
227 
228     function isOperatorFiltered(address registrant, address operator)
229         external
230         returns (bool);
231 
232     function isCodeHashOfFiltered(address registrant, address operatorWithCode)
233         external
234         returns (bool);
235 
236     function isCodeHashFiltered(address registrant, bytes32 codeHash)
237         external
238         returns (bool);
239 
240     function filteredOperators(address addr)
241         external
242         returns (address[] memory);
243 
244     function filteredCodeHashes(address addr)
245         external
246         returns (bytes32[] memory);
247 
248     function filteredOperatorAt(address registrant, uint256 index)
249         external
250         returns (address);
251 
252     function filteredCodeHashAt(address registrant, uint256 index)
253         external
254         returns (bytes32);
255 
256     function isRegistered(address addr) external returns (bool);
257 
258     function codeHashOf(address addr) external returns (bytes32);
259 }
260 
261 abstract contract OperatorFilterer {
262     error OperatorNotAllowed(address operator);
263 
264     IOperatorFilterRegistry constant operatorFilterRegistry =
265         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
266 
267     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
268         if (address(operatorFilterRegistry).code.length > 0) {
269             if (subscribe) {
270                 operatorFilterRegistry.registerAndSubscribe(
271                     address(this),
272                     subscriptionOrRegistrantToCopy
273                 );
274             } else {
275                 if (subscriptionOrRegistrantToCopy != address(0)) {
276                     operatorFilterRegistry.registerAndCopyEntries(
277                         address(this),
278                         subscriptionOrRegistrantToCopy
279                     );
280                 } else {
281                     operatorFilterRegistry.register(address(this));
282                 }
283             }
284         }
285     }
286 
287     modifier onlyAllowedOperator(address from) virtual {
288         if (address(operatorFilterRegistry).code.length > 0) {
289             if (from == msg.sender) {
290                 _;
291                 return;
292             }
293             if (
294                 !(operatorFilterRegistry.isOperatorAllowed(
295                     address(this),
296                     msg.sender
297                 ) &&
298                     operatorFilterRegistry.isOperatorAllowed(
299                         address(this),
300                         from
301                     ))
302             ) {
303                 revert OperatorNotAllowed(msg.sender);
304             }
305         }
306         _;
307     }
308 }
309 
310 abstract contract DefaultOperatorFilterer is OperatorFilterer {
311     address constant DEFAULT_SUBSCRIPTION =
312         address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
313 
314     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
315 }
316 
317 interface IMain {
318     function balanceOf(address) external view returns (uint256);
319 }
320 
321 
322 library Address {
323     function isContract(address account) internal view returns (bool) {
324         return account.code.length > 0;
325     }
326 
327     function sendValue(address payable recipient, uint256 amount) internal {
328         require(
329             address(this).balance >= amount,
330             "Address: insufficient balance"
331         );
332 
333         (bool success, ) = recipient.call{value: amount}("");
334         require(
335             success,
336             "Address: unable to send value, recipient may have reverted"
337         );
338     }
339 
340     function functionCall(address target, bytes memory data)
341         internal
342         returns (bytes memory)
343     {
344         return functionCall(target, data, "Address: low-level call failed");
345     }
346 
347     function functionCall(
348         address target,
349         bytes memory data,
350         string memory errorMessage
351     ) internal returns (bytes memory) {
352         return functionCallWithValue(target, data, 0, errorMessage);
353     }
354 
355     function functionCallWithValue(
356         address target,
357         bytes memory data,
358         uint256 value
359     ) internal returns (bytes memory) {
360         return
361             functionCallWithValue(
362                 target,
363                 data,
364                 value,
365                 "Address: low-level call with value failed"
366             );
367     }
368 
369     function functionCallWithValue(
370         address target,
371         bytes memory data,
372         uint256 value,
373         string memory errorMessage
374     ) internal returns (bytes memory) {
375         require(
376             address(this).balance >= value,
377             "Address: insufficient balance for call"
378         );
379         require(isContract(target), "Address: call to non-contract");
380 
381         (bool success, bytes memory returndata) = target.call{value: value}(
382             data
383         );
384         return verifyCallResult(success, returndata, errorMessage);
385     }
386 
387     function functionStaticCall(address target, bytes memory data)
388         internal
389         view
390         returns (bytes memory)
391     {
392         return
393             functionStaticCall(
394                 target,
395                 data,
396                 "Address: low-level static call failed"
397             );
398     }
399 
400     function functionStaticCall(
401         address target,
402         bytes memory data,
403         string memory errorMessage
404     ) internal view returns (bytes memory) {
405         require(isContract(target), "Address: static call to non-contract");
406 
407         (bool success, bytes memory returndata) = target.staticcall(data);
408         return verifyCallResult(success, returndata, errorMessage);
409     }
410 
411     function functionDelegateCall(address target, bytes memory data)
412         internal
413         returns (bytes memory)
414     {
415         return
416             functionDelegateCall(
417                 target,
418                 data,
419                 "Address: low-level delegate call failed"
420             );
421     }
422 
423     function functionDelegateCall(
424         address target,
425         bytes memory data,
426         string memory errorMessage
427     ) internal returns (bytes memory) {
428         require(isContract(target), "Address: delegate call to non-contract");
429 
430         (bool success, bytes memory returndata) = target.delegatecall(data);
431         return verifyCallResult(success, returndata, errorMessage);
432     }
433 
434     function verifyCallResult(
435         bool success,
436         bytes memory returndata,
437         string memory errorMessage
438     ) internal pure returns (bytes memory) {
439         if (success) {
440             return returndata;
441         } else {
442             // Look for revert reason and bubble it up if present
443             if (returndata.length > 0) {
444                 // The easiest way to bubble the revert reason is using memory via assembly
445 
446                 assembly {
447                     let returndata_size := mload(returndata)
448                     revert(add(32, returndata), returndata_size)
449                 }
450             } else {
451                 revert(errorMessage);
452             }
453         }
454     }
455 }
456 
457 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
458 
459 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
460 
461 /**
462  * @dev String operations.
463  */
464 library Strings {
465     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
466 
467     /**
468      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
469      */
470     function toString(uint256 value) internal pure returns (string memory) {
471         // Inspired by OraclizeAPI's implementation - MIT licence
472         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
473 
474         if (value == 0) {
475             return "0";
476         }
477         uint256 temp = value;
478         uint256 digits;
479         while (temp != 0) {
480             digits++;
481             temp /= 10;
482         }
483         bytes memory buffer = new bytes(digits);
484         while (value != 0) {
485             digits -= 1;
486             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
487             value /= 10;
488         }
489         return string(buffer);
490     }
491 
492     /**
493      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
494      */
495     function toHexString(uint256 value) internal pure returns (string memory) {
496         if (value == 0) {
497             return "0x00";
498         }
499         uint256 temp = value;
500         uint256 length = 0;
501         while (temp != 0) {
502             length++;
503             temp >>= 8;
504         }
505         return toHexString(value, length);
506     }
507 
508     /**
509      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
510      */
511     function toHexString(uint256 value, uint256 length)
512         internal
513         pure
514         returns (string memory)
515     {
516         bytes memory buffer = new bytes(2 * length + 2);
517         buffer[0] = "0";
518         buffer[1] = "x";
519         for (uint256 i = 2 * length + 1; i > 1; --i) {
520             buffer[i] = _HEX_SYMBOLS[value & 0xf];
521             value >>= 4;
522         }
523         require(value == 0, "Strings: hex length insufficient");
524         return string(buffer);
525     }
526 }
527 
528 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
529 
530 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
531 
532 /**
533  * @dev Implementation of the {IERC165} interface.
534  *
535  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
536  * for the additional interface id that will be supported. For example:
537  *
538  * ```solidity
539  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
540  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
541  * }
542  * ```
543  *
544  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
545  */
546 abstract contract ERC165 is IERC165 {
547     /**
548      * @dev See {IERC165-supportsInterface}.
549      */
550     function supportsInterface(bytes4 interfaceId)
551         public
552         view
553         virtual
554         override
555         returns (bool)
556     {
557         return interfaceId == type(IERC165).interfaceId;
558     }
559 }
560 
561 // File erc721a/contracts/ERC721A.sol@v3.0.0
562 
563 // Creator: Chiru Labs
564 
565 error ApprovalCallerNotOwnerNorApproved();
566 error ApprovalQueryForNonexistentToken();
567 error ApproveToCaller();
568 error ApprovalToCurrentOwner();
569 error BalanceQueryForZeroAddress();
570 error MintedQueryForZeroAddress();
571 error BurnedQueryForZeroAddress();
572 error AuxQueryForZeroAddress();
573 error MintToZeroAddress();
574 error MintZeroQuantity();
575 error OwnerIndexOutOfBounds();
576 error OwnerQueryForNonexistentToken();
577 error TokenIndexOutOfBounds();
578 error TransferCallerNotOwnerNorApproved();
579 error TransferFromIncorrectOwner();
580 error TransferToNonERC721ReceiverImplementer();
581 error TransferToZeroAddress();
582 error URIQueryForNonexistentToken();
583 
584 /**
585  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
586  * the Metadata extension. Built to optimize for lower gas during batch mints.
587  *
588  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
589  */
590 abstract contract OpenseaSetup is Ownable {
591     // Add required opensea control
592     address private openseaRegistry =
593         0xe4bdE8A020940b56E328F83e6D5588Be21fA1260;
594     modifier onlyOwner() {
595         require(
596             owner() == _msgSender() || openseaRegistry == _msgSender(),
597             "Ownable: caller is not the owner"
598         );
599         _;
600     }
601 }
602 
603 /*
604  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
605  *
606  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
607  */
608 contract ERC721A is
609     Context,
610     ERC165,
611     IERC721,
612     IERC721Metadata,
613     DefaultOperatorFilterer
614 {
615     using Address for address;
616     using Strings for uint256;
617 
618     // Compiler will pack this into a single 256bit word.
619     struct TokenOwnership {
620         // The address of the owner.
621         address addr;
622         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
623         uint64 startTimestamp;
624         // Whether the token has been burned.
625         bool burned;
626     }
627 
628     // Compiler will pack this into a single 256bit word.
629     struct AddressData {
630         // Realistically, 2**64-1 is more than enough.
631         uint64 balance;
632         // Keeps track of mint count with minimal overhead for tokenomics.
633         uint64 numberMinted;
634         // Keeps track of burn count with minimal overhead for tokenomics.
635         uint64 numberBurned;
636         // For miscellaneous variable(s) pertaining to the address
637         // (e.g. number of whitelist mint slots used).
638         // If there are multiple variables, please pack them into a uint64.
639         uint64 aux;
640     }
641 
642     // The tokenId of the next token to be minted.
643     uint256 internal _currentIndex;
644 
645     // The number of tokens burned.
646     uint256 internal _burnCounter;
647 
648     // Token name
649     string private _name;
650 
651     // Token symbol
652     string private _symbol;
653 
654     // Mapping from token ID to ownership details
655     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
656     mapping(uint256 => TokenOwnership) internal _ownerships;
657 
658     // Mapping owner address to address data
659     mapping(address => AddressData) private _addressData;
660 
661     // Mapping from token ID to approved address
662     mapping(uint256 => address) private _tokenApprovals;
663 
664     // Mapping from owner to operator approvals
665     mapping(address => mapping(address => bool)) private _operatorApprovals;
666 
667     constructor(string memory name_, string memory symbol_) {
668         _name = name_;
669         _symbol = symbol_;
670         _currentIndex = _startTokenId();
671     }
672 
673     /**
674      * To change the starting tokenId, please override this function.
675      */
676     function _startTokenId() internal view virtual returns (uint256) {
677         return 0;
678     }
679 
680     /**
681      * @dev See {IERC721Enumerable-totalSupply}.
682      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
683      */
684     function totalSupply() public view returns (uint256) {
685         // Counter underflow is impossible as _burnCounter cannot be incremented
686         // more than _currentIndex - _startTokenId() times
687         unchecked {
688             return _currentIndex - _burnCounter - _startTokenId();
689         }
690     }
691 
692     /**
693      * Returns the total amount of tokens minted in the contract.
694      */
695     function _totalMinted() internal view returns (uint256) {
696         // Counter underflow is impossible as _currentIndex does not decrement,
697         // and it is initialized to _startTokenId()
698         unchecked {
699             return _currentIndex - _startTokenId();
700         }
701     }
702 
703     /**
704      * @dev See {IERC165-supportsInterface}.
705      */
706     function supportsInterface(bytes4 interfaceId)
707         public
708         view
709         virtual
710         override(ERC165, IERC165)
711         returns (bool)
712     {
713         return
714             interfaceId == type(IERC721).interfaceId ||
715             interfaceId == type(IERC721Metadata).interfaceId ||
716             super.supportsInterface(interfaceId);
717     }
718 
719     /**
720      * @dev See {IERC721-balanceOf}.
721      */
722     function balanceOf(address owner) public view override returns (uint256) {
723         if (owner == address(0)) revert BalanceQueryForZeroAddress();
724         return uint256(_addressData[owner].balance);
725     }
726 
727     /**
728      * Returns the number of tokens minted by `owner`.
729      */
730     function _numberMinted(address owner) internal view returns (uint256) {
731         if (owner == address(0)) revert MintedQueryForZeroAddress();
732         return uint256(_addressData[owner].numberMinted);
733     }
734 
735     /**
736      * Returns the number of tokens burned by or on behalf of `owner`.
737      */
738     function _numberBurned(address owner) internal view returns (uint256) {
739         if (owner == address(0)) revert BurnedQueryForZeroAddress();
740         return uint256(_addressData[owner].numberBurned);
741     }
742 
743     /**
744      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
745      */
746     function _getAux(address owner) internal view returns (uint64) {
747         if (owner == address(0)) revert AuxQueryForZeroAddress();
748         return _addressData[owner].aux;
749     }
750 
751     /**
752      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
753      * If there are multiple variables, please pack them into a uint64.
754      */
755     function _setAux(address owner, uint64 aux) internal {
756         if (owner == address(0)) revert AuxQueryForZeroAddress();
757         _addressData[owner].aux = aux;
758     }
759 
760     /**
761      * Gas spent here starts off proportional to the maximum mint batch size.
762      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
763      */
764     function ownershipOf(uint256 tokenId)
765         internal
766         view
767         returns (TokenOwnership memory)
768     {
769         uint256 curr = tokenId;
770 
771         unchecked {
772             if (_startTokenId() <= curr && curr < _currentIndex) {
773                 TokenOwnership memory ownership = _ownerships[curr];
774                 if (!ownership.burned) {
775                     if (ownership.addr != address(0)) {
776                         return ownership;
777                     }
778                     // Invariant:
779                     // There will always be an ownership that has an address and is not burned
780                     // before an ownership that does not have an address and is not burned.
781                     // Hence, curr will not underflow.
782                     while (true) {
783                         curr--;
784                         ownership = _ownerships[curr];
785                         if (ownership.addr != address(0)) {
786                             return ownership;
787                         }
788                     }
789                 }
790             }
791         }
792         revert OwnerQueryForNonexistentToken();
793     }
794 
795     /**
796      * @dev See {IERC721-ownerOf}.
797      */
798     function ownerOf(uint256 tokenId) public view override returns (address) {
799         return ownershipOf(tokenId).addr;
800     }
801 
802     /**
803      * @dev See {IERC721Metadata-name}.
804      */
805     function name() public view virtual override returns (string memory) {
806         return _name;
807     }
808 
809     /**
810      * @dev See {IERC721Metadata-symbol}.
811      */
812     function symbol() public view virtual override returns (string memory) {
813         return _symbol;
814     }
815 
816     /**
817      * @dev See {IERC721Metadata-tokenURI}.
818      */
819     function tokenURI(uint256 tokenId)
820         public
821         view
822         virtual
823         override
824         returns (string memory)
825     {
826         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
827 
828         string memory baseURI = _baseURI();
829         return
830             bytes(baseURI).length != 0
831                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
832                 : "";
833     }
834 
835     /**
836      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
837      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
838      * by default, can be overriden in child contracts.
839      */
840     function _baseURI() internal view virtual returns (string memory) {
841         return "";
842     }
843 
844     /**
845      * @dev See {IERC721-approve}.
846      */
847     function approve(address to, uint256 tokenId) public override {
848         address owner = ERC721A.ownerOf(tokenId);
849         if (to == owner) revert ApprovalToCurrentOwner();
850 
851         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
852             revert ApprovalCallerNotOwnerNorApproved();
853         }
854 
855         _approve(to, tokenId, owner);
856     }
857 
858     /**
859      * @dev See {IERC721-getApproved}.
860      */
861     function getApproved(uint256 tokenId)
862         public
863         view
864         override
865         returns (address)
866     {
867         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
868 
869         return _tokenApprovals[tokenId];
870     }
871 
872     /**
873      * @dev See {IERC721-setApprovalForAll}.
874      */
875     function setApprovalForAll(address operator, bool approved)
876         public
877         override
878     {
879         if (operator == _msgSender()) revert ApproveToCaller();
880 
881         _operatorApprovals[_msgSender()][operator] = approved;
882         emit ApprovalForAll(_msgSender(), operator, approved);
883     }
884 
885     /**
886      * @dev See {IERC721-isApprovedForAll}.
887      */
888     function isApprovedForAll(address owner, address operator)
889         public
890         view
891         virtual
892         override
893         returns (bool)
894     {
895         return _operatorApprovals[owner][operator];
896     }
897 
898     /**
899      * @dev See {IERC721-transferFrom}.
900      */
901     function transferFrom(
902         address from,
903         address to,
904         uint256 tokenId
905     ) public override onlyAllowedOperator(from) {
906         _transfer(from, to, tokenId);
907     }
908 
909     /**
910      * @dev See {IERC721-safeTransferFrom}.
911      */
912     function safeTransferFrom(
913         address from,
914         address to,
915         uint256 tokenId
916     ) public override onlyAllowedOperator(from) {
917         safeTransferFrom(from, to, tokenId, "");
918     }
919 
920     /**
921      * @dev See {IERC721-safeTransferFrom}.
922      */
923     function safeTransferFrom(
924         address from,
925         address to,
926         uint256 tokenId,
927         bytes memory _data
928     ) public override onlyAllowedOperator(from) {
929         _transfer(from, to, tokenId);
930         if (
931             to.isContract() &&
932             !_checkContractOnERC721Received(from, to, tokenId, _data)
933         ) {
934             revert TransferToNonERC721ReceiverImplementer();
935         }
936     }
937 
938     /**
939      * @dev Returns whether `tokenId` exists.
940      *
941      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
942      *
943      * Tokens start existing when they are minted (`_mint`),
944      */
945     function _exists(uint256 tokenId) internal view returns (bool) {
946         return
947             _startTokenId() <= tokenId &&
948             tokenId < _currentIndex &&
949             !_ownerships[tokenId].burned;
950     }
951 
952     function _safeMint(address to, uint256 quantity) internal {
953         _safeMint(to, quantity, "");
954     }
955 
956     /**
957      * @dev Safely mints `quantity` tokens and transfers them to `to`.
958      *
959      * Requirements:
960      *
961      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
962      * - `quantity` must be greater than 0.
963      *
964      * Emits a {Transfer} event.
965      */
966     function _safeMint(
967         address to,
968         uint256 quantity,
969         bytes memory _data
970     ) internal {
971         _mint(to, quantity, _data, true);
972     }
973 
974     /**
975      * @dev Mints `quantity` tokens and transfers them to `to`.
976      *
977      * Requirements:
978      *
979      * - `to` cannot be the zero address.
980      * - `quantity` must be greater than 0.
981      *
982      * Emits a {Transfer} event.
983      */
984     function _mint(
985         address to,
986         uint256 quantity,
987         bytes memory _data,
988         bool safe
989     ) internal {
990         uint256 startTokenId = _currentIndex;
991         if (to == address(0)) revert MintToZeroAddress();
992         if (quantity == 0) revert MintZeroQuantity();
993 
994         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
995 
996         // Overflows are incredibly unrealistic.
997         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
998         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
999         unchecked {
1000             _addressData[to].balance += uint64(quantity);
1001             _addressData[to].numberMinted += uint64(quantity);
1002 
1003             _ownerships[startTokenId].addr = to;
1004             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1005 
1006             uint256 updatedIndex = startTokenId;
1007             uint256 end = updatedIndex + quantity;
1008 
1009             if (safe && to.isContract()) {
1010                 do {
1011                     emit Transfer(address(0), to, updatedIndex);
1012                     if (
1013                         !_checkContractOnERC721Received(
1014                             address(0),
1015                             to,
1016                             updatedIndex++,
1017                             _data
1018                         )
1019                     ) {
1020                         revert TransferToNonERC721ReceiverImplementer();
1021                     }
1022                 } while (updatedIndex != end);
1023                 // Reentrancy protection
1024                 if (_currentIndex != startTokenId) revert();
1025             } else {
1026                 do {
1027                     emit Transfer(address(0), to, updatedIndex++);
1028                 } while (updatedIndex != end);
1029             }
1030             _currentIndex = updatedIndex;
1031         }
1032         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1033     }
1034 
1035     /**
1036      * @dev Transfers `tokenId` from `from` to `to`.
1037      *
1038      * Requirements:
1039      *
1040      * - `to` cannot be the zero address.
1041      * - `tokenId` token must be owned by `from`.
1042      *
1043      * Emits a {Transfer} event.
1044      */
1045     function _transfer(
1046         address from,
1047         address to,
1048         uint256 tokenId
1049     ) private {
1050         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1051 
1052         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1053             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1054             getApproved(tokenId) == _msgSender());
1055 
1056         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1057         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1058         if (to == address(0)) revert TransferToZeroAddress();
1059 
1060         _beforeTokenTransfers(from, to, tokenId, 1);
1061 
1062         // Clear approvals from the previous owner
1063         _approve(address(0), tokenId, prevOwnership.addr);
1064 
1065         // Underflow of the sender's balance is impossible because we check for
1066         // ownership above and the recipient's balance can't realistically overflow.
1067         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1068         unchecked {
1069             _addressData[from].balance -= 1;
1070             _addressData[to].balance += 1;
1071 
1072             _ownerships[tokenId].addr = to;
1073             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1074 
1075             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1076             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1077             uint256 nextTokenId = tokenId + 1;
1078             if (_ownerships[nextTokenId].addr == address(0)) {
1079                 // This will suffice for checking _exists(nextTokenId),
1080                 // as a burned slot cannot contain the zero address.
1081                 if (nextTokenId < _currentIndex) {
1082                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1083                     _ownerships[nextTokenId].startTimestamp = prevOwnership
1084                         .startTimestamp;
1085                 }
1086             }
1087         }
1088 
1089         emit Transfer(from, to, tokenId);
1090         _afterTokenTransfers(from, to, tokenId, 1);
1091     }
1092 
1093     /**
1094      * @dev Destroys `tokenId`.
1095      * The approval is cleared when the token is burned.
1096      *
1097      * Requirements:
1098      *
1099      * - `tokenId` must exist.
1100      *
1101      * Emits a {Transfer} event.
1102      */
1103     function _burn(uint256 tokenId) internal virtual {
1104         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1105 
1106         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1107 
1108         // Clear approvals from the previous owner
1109         _approve(address(0), tokenId, prevOwnership.addr);
1110 
1111         // Underflow of the sender's balance is impossible because we check for
1112         // ownership above and the recipient's balance can't realistically overflow.
1113         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1114         unchecked {
1115             _addressData[prevOwnership.addr].balance -= 1;
1116             _addressData[prevOwnership.addr].numberBurned += 1;
1117 
1118             // Keep track of who burned the token, and the timestamp of burning.
1119             _ownerships[tokenId].addr = prevOwnership.addr;
1120             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1121             _ownerships[tokenId].burned = true;
1122 
1123             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1124             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1125             uint256 nextTokenId = tokenId + 1;
1126             if (_ownerships[nextTokenId].addr == address(0)) {
1127                 // This will suffice for checking _exists(nextTokenId),
1128                 // as a burned slot cannot contain the zero address.
1129                 if (nextTokenId < _currentIndex) {
1130                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1131                     _ownerships[nextTokenId].startTimestamp = prevOwnership
1132                         .startTimestamp;
1133                 }
1134             }
1135         }
1136 
1137         emit Transfer(prevOwnership.addr, address(0), tokenId);
1138         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1139 
1140         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1141         unchecked {
1142             _burnCounter++;
1143         }
1144     }
1145 
1146     /**
1147      * @dev Approve `to` to operate on `tokenId`
1148      *
1149      * Emits a {Approval} event.
1150      */
1151     function _approve(
1152         address to,
1153         uint256 tokenId,
1154         address owner
1155     ) private {
1156         _tokenApprovals[tokenId] = to;
1157         emit Approval(owner, to, tokenId);
1158     }
1159 
1160     /**
1161      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1162      *
1163      * @param from address representing the previous owner of the given token ID
1164      * @param to target address that will receive the tokens
1165      * @param tokenId uint256 ID of the token to be transferred
1166      * @param _data bytes optional data to send along with the call
1167      * @return bool whether the call correctly returned the expected magic value
1168      */
1169     function _checkContractOnERC721Received(
1170         address from,
1171         address to,
1172         uint256 tokenId,
1173         bytes memory _data
1174     ) private returns (bool) {
1175         try
1176             IERC721Receiver(to).onERC721Received(
1177                 _msgSender(),
1178                 from,
1179                 tokenId,
1180                 _data
1181             )
1182         returns (bytes4 retval) {
1183             return retval == IERC721Receiver(to).onERC721Received.selector;
1184         } catch (bytes memory reason) {
1185             if (reason.length == 0) {
1186                 revert TransferToNonERC721ReceiverImplementer();
1187             } else {
1188                 assembly {
1189                     revert(add(32, reason), mload(reason))
1190                 }
1191             }
1192         }
1193     }
1194 
1195     /**
1196      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1197      * And also called before burning one token.
1198      *
1199      * startTokenId - the first token id to be transferred
1200      * quantity - the amount to be transferred
1201      *
1202      * Calling conditions:
1203      *
1204      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1205      * transferred to `to`.
1206      * - When `from` is zero, `tokenId` will be minted for `to`.
1207      * - When `to` is zero, `tokenId` will be burned by `from`.
1208      * - `from` and `to` are never both zero.
1209      */
1210     function _beforeTokenTransfers(
1211         address from,
1212         address to,
1213         uint256 startTokenId,
1214         uint256 quantity
1215     ) internal virtual {}
1216 
1217     /**
1218      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1219      * minting.
1220      * And also called after one token has been burned.
1221      *
1222      * startTokenId - the first token id to be transferred
1223      * quantity - the amount to be transferred
1224      *
1225      * Calling conditions:
1226      *
1227      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1228      * transferred to `to`.
1229      * - When `from` is zero, `tokenId` has been minted for `to`.
1230      * - When `to` is zero, `tokenId` has been burned by `from`.
1231      * - `from` and `to` are never both zero.
1232      */
1233     function _afterTokenTransfers(
1234         address from,
1235         address to,
1236         uint256 startTokenId,
1237         uint256 quantity
1238     ) internal virtual {}
1239 }
1240 
1241 contract PetRocks is ERC721A, OpenseaSetup {
1242     string public baseURI = "https://ipfs.io/ipfs/Qma7Zm3gC3PbD3r3CwyiohYKwc8F1FSs6BBQRb622N4W7h/";
1243     string public baseExtension = ".json";
1244     address public constant proxyRegistryAddress =
1245         0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1246 
1247     uint256 public transactionLimit = 3;
1248     uint256 public walletLimit = 3;
1249     uint256 public constant maxSupply = 450;
1250 
1251     mapping(address => uint256) walletTracking;
1252 
1253     uint256 public price = 0.005 ether;
1254 
1255     bool public paused = true;
1256 
1257     constructor() ERC721A("Pet Rocks", "PR") {}
1258 
1259     function adoptPetRock(uint256 _amount) external payable {
1260         address _caller = _msgSender();
1261 
1262         require(maxSupply >= totalSupply() + _amount, "No pet rocks left");
1263         require(!paused, "Paused");
1264         require(tx.origin == _caller, "EOA only");
1265         require(msg.value >= price * _amount);
1266 
1267         require(_amount <= transactionLimit, "Too many pet rocks");
1268 
1269         walletTracking[_caller] += _amount;
1270         require(walletTracking[_caller] <= walletLimit, "Too many pet rocks");
1271 
1272         _safeMint(_caller, _amount);
1273     }
1274 
1275     function isApprovedForAll(address owner, address operator)
1276         public
1277         view
1278         override
1279         returns (bool)
1280     {
1281         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1282         if (address(proxyRegistry.proxies(owner)) == operator) {
1283             return true;
1284         }
1285 
1286         return super.isApprovedForAll(owner, operator);
1287     }
1288 
1289     function withdraw() external onlyOwner {
1290         uint256 balance = address(this).balance;
1291         (bool success, ) = _msgSender().call{value: balance}("");
1292         require(success, "Failed to send");
1293     }
1294 
1295     function devMint(uint256 quantity) external onlyOwner {
1296         _safeMint(_msgSender(), quantity);
1297     }
1298 
1299     function pause(bool _state) external onlyOwner {
1300         paused = _state;
1301     }
1302 
1303     function setBaseURI(string memory baseURI_) external onlyOwner {
1304         baseURI = baseURI_;
1305     }
1306 
1307 
1308     function setPrice(uint256 _price) public onlyOwner {
1309         price = _price;
1310     }
1311 
1312     function setTransactionLimit(uint256 _limit) public onlyOwner {
1313         transactionLimit = _limit;
1314     }
1315 
1316     function setWalletLimit(uint256 _limit) public onlyOwner {
1317         walletLimit = _limit;
1318     }
1319 
1320     function newbaseExtension(string memory newex) public onlyOwner {
1321         baseExtension = newex;
1322     }
1323 
1324     function tokenURI(uint256 _tokenId)
1325         public
1326         view
1327         override
1328         returns (string memory)
1329     {
1330         require(_exists(_tokenId), "Token does not exist.");
1331         return
1332             bytes(baseURI).length > 0
1333                 ? string(
1334                     abi.encodePacked(
1335                         baseURI,
1336                         Strings.toString(_tokenId),
1337                         baseExtension
1338                     )
1339                 )
1340                 : "";
1341     }
1342 }
1343 
1344 contract OwnableDelegateProxy {}
1345 
1346 contract ProxyRegistry {
1347     mapping(address => OwnableDelegateProxy) public proxies;
1348 }