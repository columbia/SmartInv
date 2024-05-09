1 // File: ZERO/operator-filter/IOperatorFilterRegistry.sol
2 
3 
4 pragma solidity ^0.8.13;
5 
6 interface IOperatorFilterRegistry {
7     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
8     function register(address registrant) external;
9     function registerAndSubscribe(address registrant, address subscription) external;
10     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
11     function unregister(address addr) external;
12     function updateOperator(address registrant, address operator, bool filtered) external;
13     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
14     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
15     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
16     function subscribe(address registrant, address registrantToSubscribe) external;
17     function unsubscribe(address registrant, bool copyExistingEntries) external;
18     function subscriptionOf(address addr) external returns (address registrant);
19     function subscribers(address registrant) external returns (address[] memory);
20     function subscriberAt(address registrant, uint256 index) external returns (address);
21     function copyEntriesOf(address registrant, address registrantToCopy) external;
22     function isOperatorFiltered(address registrant, address operator) external returns (bool);
23     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
24     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
25     function filteredOperators(address addr) external returns (address[] memory);
26     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
27     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
28     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
29     function isRegistered(address addr) external returns (bool);
30     function codeHashOf(address addr) external returns (bytes32);
31 }
32 
33 // File: ZERO/operator-filter/OperatorFilterer.sol
34 
35 
36 pragma solidity ^0.8.13;
37 
38 
39 /**
40  * @title  OperatorFilterer
41  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
42  *         registrant's entries in the OperatorFilterRegistry.
43  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
44  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
45  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
46  */
47 abstract contract OperatorFilterer {
48     error OperatorNotAllowed(address operator);
49 
50     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
51         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
52 
53     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
54         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
55         // will not revert, but the contract will need to be registered with the registry once it is deployed in
56         // order for the modifier to filter addresses.
57         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
58             if (subscribe) {
59                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
60             } else {
61                 if (subscriptionOrRegistrantToCopy != address(0)) {
62                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
63                 } else {
64                     OPERATOR_FILTER_REGISTRY.register(address(this));
65                 }
66             }
67         }
68     }
69 
70     modifier onlyAllowedOperator(address from) virtual {
71         // Allow spending tokens from addresses with balance
72         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
73         // from an EOA.
74         if (from != msg.sender) {
75             _checkFilterOperator(msg.sender);
76         }
77         _;
78     }
79 
80     modifier onlyAllowedOperatorApproval(address operator) virtual {
81         _checkFilterOperator(operator);
82         _;
83     }
84 
85     function _checkFilterOperator(address operator) internal view virtual {
86         // Check registry code length to facilitate testing in environments without a deployed registry.
87         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
88             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
89                 revert OperatorNotAllowed(operator);
90             }
91         }
92     }
93 }
94 
95 // File: ZERO/operator-filter/DefaultOperatorFilterer.sol
96 
97 
98 pragma solidity ^0.8.13;
99 
100 
101 /**
102  * @title  DefaultOperatorFilterer
103  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
104  */
105 abstract contract DefaultOperatorFilterer is OperatorFilterer {
106     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
107 
108     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
109 }
110 
111 // File: ZERO/ZeroDependencies.sol
112 
113 
114 
115 pragma solidity ^0.8.0;
116 
117 abstract contract ReentrancyGuard {
118     // Booleans are more expensive than uint256 or any type that takes up a full
119     // word because each write operation emits an extra SLOAD to first read the
120     // slot's contents, replace the bits taken up by the boolean, and then write
121     // back. This is the compiler's defense against contract upgrades and
122     // pointer aliasing, and it cannot be disabled.
123 
124     // The values being non-zero value makes deployment a bit more expensive,
125     // but in exchange the refund on every call to nonReentrant will be lower in
126     // amount. Since refunds are capped to a percentage of the total
127     // transaction's gas, it is best to keep them low in cases like this one, to
128     // increase the likelihood of the full refund coming into effect.
129     uint256 private constant _NOT_ENTERED = 1;
130     uint256 private constant _ENTERED = 2;
131 
132     uint256 private _status;
133 
134     constructor() {
135         _status = _NOT_ENTERED;
136     }
137 
138     modifier nonReentrant() {
139         // On the first call to nonReentrant, _notEntered will be true
140         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
141 
142         // Any calls to nonReentrant after this point will fail
143         _status = _ENTERED;
144 
145         _;
146 
147         // By storing the original value once again, a refund is triggered (see
148         // https://eips.ethereum.org/EIPS/eip-2200)
149         _status = _NOT_ENTERED;
150     }
151 }
152 // /Strings.sol
153 
154 
155 
156 pragma solidity ^0.8.0;
157 
158 library Strings {
159     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
160 
161     function toString(uint256 value) internal pure returns (string memory) {
162         if (value == 0) {
163             return "0";
164         }
165         uint256 temp = value;
166         uint256 digits;
167         while (temp != 0) {
168             digits++;
169             temp /= 10;
170         }
171         bytes memory buffer = new bytes(digits);
172         while (value != 0) {
173             digits -= 1;
174             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
175             value /= 10;
176         }
177         return string(buffer);
178     }
179 
180     function toHexString(uint256 value) internal pure returns (string memory) {
181         if (value == 0) {
182             return "0x00";
183         }
184         uint256 temp = value;
185         uint256 length = 0;
186         while (temp != 0) {
187             length++;
188             temp >>= 8;
189         }
190         return toHexString(value, length);
191     }
192 
193     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
194         bytes memory buffer = new bytes(2 * length + 2);
195         buffer[0] = "0";
196         buffer[1] = "x";
197         for (uint256 i = 2 * length + 1; i > 1; --i) {
198             buffer[i] = _HEX_SYMBOLS[value & 0xf];
199             value >>= 4;
200         }
201         require(value == 0, "Strings: hex length insufficient");
202         return string(buffer);
203     }
204 }
205 
206 // /Context.sol
207 
208 
209 pragma solidity ^0.8.0;
210 
211 abstract contract Context {
212     function _msgSender() internal view virtual returns (address) {
213         return msg.sender;
214     }
215 
216     function _msgData() internal view virtual returns (bytes calldata) {
217         return msg.data;
218     }
219 }
220 // /Ownable.sol
221 
222 
223 
224 pragma solidity ^0.8.0;
225 
226 
227 abstract contract Ownable is Context {
228     address private _owner;
229 
230     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
231 
232     constructor() {
233         _transferOwnership(_msgSender());
234     }
235 
236     function owner() public view virtual returns (address) {
237         return _owner;
238     }
239 
240     modifier onlyOwner() {
241         require(owner() == _msgSender(), "Ownable: caller is not the owner");
242         _;
243     }
244 
245     function renounceOwnership() public virtual onlyOwner {
246         _transferOwnership(address(0));
247     }
248 
249     function transferOwnership(address newOwner) public virtual onlyOwner {
250         require(newOwner != address(0), "Ownable: new owner is the zero address");
251         _transferOwnership(newOwner);
252     }
253 
254     function _transferOwnership(address newOwner) internal virtual {
255         address oldOwner = _owner;
256         _owner = newOwner;
257         emit OwnershipTransferred(oldOwner, newOwner);
258     }
259 }
260 
261 // /Address.sol
262 
263 
264 pragma solidity ^0.8.1;
265 
266 library Address {
267     function isContract(address account) internal view returns (bool) {
268         return account.code.length > 0;
269     }
270 
271     function sendValue(address payable recipient, uint256 amount) internal {
272         require(address(this).balance >= amount, "Address: insufficient balance");
273 
274         (bool success, ) = recipient.call{value: amount}("");
275         require(success, "Address: unable to send value, recipient may have reverted");
276     }
277 
278     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
279         return functionCall(target, data, "Address: low-level call failed");
280     }
281 
282     function functionCall(
283         address target,
284         bytes memory data,
285         string memory errorMessage
286     ) internal returns (bytes memory) {
287         return functionCallWithValue(target, data, 0, errorMessage);
288     }
289 
290     function functionCallWithValue(
291         address target,
292         bytes memory data,
293         uint256 value
294     ) internal returns (bytes memory) {
295         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
296     }
297 
298     function functionCallWithValue(
299         address target,
300         bytes memory data,
301         uint256 value,
302         string memory errorMessage
303     ) internal returns (bytes memory) {
304         require(address(this).balance >= value, "Address: insufficient balance for call");
305         require(isContract(target), "Address: call to non-contract");
306 
307         (bool success, bytes memory returndata) = target.call{value: value}(data);
308         return verifyCallResult(success, returndata, errorMessage);
309     }
310 
311     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
312         return functionStaticCall(target, data, "Address: low-level static call failed");
313     }
314 
315     function functionStaticCall(
316         address target,
317         bytes memory data,
318         string memory errorMessage
319     ) internal view returns (bytes memory) {
320         require(isContract(target), "Address: static call to non-contract");
321 
322         (bool success, bytes memory returndata) = target.staticcall(data);
323         return verifyCallResult(success, returndata, errorMessage);
324     }
325 
326     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
327         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
328     }
329 
330     function functionDelegateCall(
331         address target,
332         bytes memory data,
333         string memory errorMessage
334     ) internal returns (bytes memory) {
335         require(isContract(target), "Address: delegate call to non-contract");
336 
337         (bool success, bytes memory returndata) = target.delegatecall(data);
338         return verifyCallResult(success, returndata, errorMessage);
339     }
340 
341     function verifyCallResult(
342         bool success,
343         bytes memory returndata,
344         string memory errorMessage
345     ) internal pure returns (bytes memory) {
346         if (success) {
347             return returndata;
348         } else {
349             // Look for revert reason and bubble it up if present
350             if (returndata.length > 0) {
351                 // The easiest way to bubble the revert reason is using memory via assembly
352 
353                 assembly {
354                     let returndata_size := mload(returndata)
355                     revert(add(32, returndata), returndata_size)
356                 }
357             } else {
358                 revert(errorMessage);
359             }
360         }
361     }
362 }
363 
364 // /IERC721Receiver.sol
365 
366 
367 
368 pragma solidity ^0.8.0;
369 
370 interface IERC721Receiver {
371     function onERC721Received(
372         address operator,
373         address from,
374         uint256 tokenId,
375         bytes calldata data
376     ) external returns (bytes4);
377 }
378 
379 // /IERC165.sol
380 
381 
382 
383 pragma solidity ^0.8.0;
384 
385 interface IERC165 {
386     function supportsInterface(bytes4 interfaceId) external view returns (bool);
387 }
388 
389 // /ERC165.sol
390 
391 
392 pragma solidity ^0.8.0;
393 
394 
395 /**
396  * @dev Implementation of the {IERC165} interface.
397  *
398  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
399  * for the additional interface id that will be supported. For example:
400  *
401  * ```solidity
402  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
403  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
404  * }
405  * ```
406  *
407  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
408  */
409 abstract contract ERC165 is IERC165 {
410     /**
411      * @dev See {IERC165-supportsInterface}.
412      */
413     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
414         return interfaceId == type(IERC165).interfaceId;
415     }
416 }
417 
418 // /IERC721.sol
419 
420 
421 
422 pragma solidity ^0.8.0;
423 
424 
425 interface IERC721 is IERC165 {
426     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
427 
428     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
429 
430     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
431 
432     function balanceOf(address owner) external view returns (uint256 balance);
433 
434     function ownerOf(uint256 tokenId) external view returns (address owner);
435 
436     function safeTransferFrom(
437         address from,
438         address to,
439         uint256 tokenId
440     ) external;
441 
442     function transferFrom(
443         address from,
444         address to,
445         uint256 tokenId
446     ) external;
447 
448     function approve(address to, uint256 tokenId) external;
449 
450     function getApproved(uint256 tokenId) external view returns (address operator);
451 
452     function setApprovalForAll(address operator, bool _approved) external;
453 
454     function isApprovedForAll(address owner, address operator) external view returns (bool);
455 
456     function safeTransferFrom(
457         address from,
458         address to,
459         uint256 tokenId,
460         bytes calldata data
461     ) external;
462 }
463 
464 // /IERC721Metadata.sol
465 
466 
467 
468 pragma solidity ^0.8.0;
469 
470 
471 interface IERC721Metadata is IERC721 {
472     function name() external view returns (string memory);
473 
474     function symbol() external view returns (string memory);
475 
476     function tokenURI(uint256 tokenId) external view returns (string memory);
477 }
478 
479 // /IERC721Enumerable.sol
480 
481 
482 
483 pragma solidity ^0.8.0;
484 
485 
486 /**
487  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
488  * @dev See https://eips.ethereum.org/EIPS/eip-721
489  */
490 interface IERC721Enumerable is IERC721 {
491     /**
492      * @dev Returns the total amount of tokens stored by the contract.
493      */
494     function totalSupply() external view returns (uint256);
495 
496     /**
497      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
498      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
499      */
500     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
501 
502     /**
503      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
504      * Use along with {totalSupply} to enumerate all tokens.
505      */
506     function tokenByIndex(uint256 index) external view returns (uint256);
507 }
508 // /ERC721A.sol
509 
510 
511 
512 pragma solidity ^0.8.0;
513 
514 
515 
516 
517 
518 
519 
520 
521 
522 /**
523  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
524  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
525  *
526  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
527  *
528  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
529  *
530  * Does not support burning tokens to address(0).
531  */
532 
533 
534 contract ERC721A is
535   Context,
536   ERC165,
537   IERC721,
538   IERC721Metadata,
539   IERC721Enumerable,
540   DefaultOperatorFilterer
541 {
542   using Address for address;
543   using Strings for uint256;
544 
545   struct TokenOwnership {
546     address addr;
547     uint64 startTimestamp;
548   }
549 
550   struct AddressData {
551     uint128 balance;
552     uint128 numberMinted;
553   }
554 
555   uint256 private currentIndex = 0;
556 
557   uint256 collectionSize;
558   uint256 maxBatchSize;
559 
560   // Token name
561   string private _name;
562 
563   // Token symbol
564   string private _symbol;
565 
566   // Mapping from token ID to ownership details
567   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
568   mapping(uint256 => TokenOwnership) private _ownerships;
569 
570   // Mapping owner address to address data
571   mapping(address => AddressData) private _addressData;
572 
573   // Mapping from token ID to approved address
574   mapping(uint256 => address) private _tokenApprovals;
575 
576   // Mapping from owner to operator approvals
577   mapping(address => mapping(address => bool)) private _operatorApprovals;
578 
579   /**
580    * @dev
581    * `maxBatchSize` refers to how much a minter can mint at a time.
582    * `collectionSize_` refers to how many tokens are in the collection.
583    */
584   constructor(
585     string memory name_,
586     string memory symbol_,
587     uint256 maxBatchSize_,
588     uint256 collectionSize_
589   ) {
590     require(
591       collectionSize_ > 0,
592       "ERC721A: collection must have a nonzero supply"
593     );
594     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
595     _name = name_;
596     _symbol = symbol_;
597     maxBatchSize = maxBatchSize_;
598     collectionSize = collectionSize_;
599   }
600 
601   /**
602    * @dev See {IERC721Enumerable-totalSupply}.
603    */
604   function totalSupply() public view override returns (uint256) {
605     return currentIndex;
606   }
607 
608   /**
609    * @dev See {IERC721Enumerable-tokenByIndex}.
610    */
611   function tokenByIndex(uint256 index) public view override returns (uint256) {
612     require(index < totalSupply(), "ERC721A: global index out of bounds");
613     return index;
614   }
615 
616   /**
617    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
618    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
619    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
620    */
621   function tokenOfOwnerByIndex(address owner, uint256 index)
622     public
623     view
624     override
625     returns (uint256)
626   {
627     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
628     uint256 numMintedSoFar = totalSupply();
629     uint256 tokenIdsIdx = 0;
630     address currOwnershipAddr = address(0);
631     for (uint256 i = 0; i < numMintedSoFar; i++) {
632       TokenOwnership memory ownership = _ownerships[i];
633       if (ownership.addr != address(0)) {
634         currOwnershipAddr = ownership.addr;
635       }
636       if (currOwnershipAddr == owner) {
637         if (tokenIdsIdx == index) {
638           return i;
639         }
640         tokenIdsIdx++;
641       }
642     }
643     revert("ERC721A: unable to get token of owner by index");
644   }
645 
646   /**
647    * @dev See {IERC165-supportsInterface}.
648    */
649   function supportsInterface(bytes4 interfaceId)
650     public
651     view
652     virtual
653     override(ERC165, IERC165)
654     returns (bool)
655   {
656     return
657       interfaceId == type(IERC721).interfaceId ||
658       interfaceId == type(IERC721Metadata).interfaceId ||
659       interfaceId == type(IERC721Enumerable).interfaceId ||
660       super.supportsInterface(interfaceId);
661   }
662 
663   /**
664    * @dev See {IERC721-balanceOf}.
665    */
666   function balanceOf(address owner) public view override returns (uint256) {
667     require(owner != address(0), "ERC721A: balance query for the zero address");
668     return uint256(_addressData[owner].balance);
669   }
670 
671   function _numberMinted(address owner) internal view returns (uint256) {
672     require(
673       owner != address(0),
674       "ERC721A: number minted query for the zero address"
675     );
676     return uint256(_addressData[owner].numberMinted);
677   }
678 
679   function ownershipOf(uint256 tokenId)
680     internal
681     view
682     returns (TokenOwnership memory)
683   {
684     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
685 
686     uint256 lowestTokenToCheck;
687     if (tokenId >= maxBatchSize) {
688       lowestTokenToCheck = tokenId - maxBatchSize + 1;
689     }
690 
691     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
692       TokenOwnership memory ownership = _ownerships[curr];
693       if (ownership.addr != address(0)) {
694         return ownership;
695       }
696     }
697 
698     revert("ERC721A: unable to determine the owner of token");
699   }
700 
701   /**
702    * @dev See {IERC721-ownerOf}.
703    */
704   function ownerOf(uint256 tokenId) public view override returns (address) {
705     return ownershipOf(tokenId).addr;
706   }
707 
708   /**
709    * @dev See {IERC721Metadata-name}.
710    */
711   function name() public view virtual override returns (string memory) {
712     return _name;
713   }
714 
715   /**
716    * @dev See {IERC721Metadata-symbol}.
717    */
718   function symbol() public view virtual override returns (string memory) {
719     return _symbol;
720   }
721 
722   /**
723    * @dev See {IERC721Metadata-tokenURI}.
724    */
725   function tokenURI(uint256 tokenId)
726     public
727     view
728     virtual
729     override
730     returns (string memory)
731   {
732     require(
733       _exists(tokenId),
734       "ERC721Metadata: URI query for nonexistent token"
735     );
736 
737     string memory baseURI = _baseURI();
738     return
739       bytes(baseURI).length > 0
740         ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
741         : "";
742   }
743 
744   /**
745    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
746    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
747    * by default, can be overriden in child contracts.
748    */
749   function _baseURI() internal view virtual returns (string memory) {
750     return "";
751   }
752 
753   /**
754    * @dev See {IERC721-approve}.
755    */
756   function approve(address to, uint256 tokenId) public override {
757     address owner = ERC721A.ownerOf(tokenId);
758     require(to != owner, "ERC721A: approval to current owner");
759 
760     require(
761       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
762       "ERC721A: approve caller is not owner nor approved for all"
763     );
764 
765     _approve(to, tokenId, owner);
766   }
767 
768   /**
769    * @dev See {IERC721-getApproved}.
770    */
771   function getApproved(uint256 tokenId) public view override returns (address) {
772     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
773 
774     return _tokenApprovals[tokenId];
775   }
776 
777   /**
778    * @dev See {IERC721-setApprovalForAll}.
779    */
780   function setApprovalForAll(address operator, bool approved) public override {
781     require(operator != _msgSender(), "ERC721A: approve to caller");
782 
783     _operatorApprovals[_msgSender()][operator] = approved;
784     emit ApprovalForAll(_msgSender(), operator, approved);
785   }
786 
787   /**
788    * @dev See {IERC721-isApprovedForAll}.
789    */
790   function isApprovedForAll(address owner, address operator)
791     public
792     view
793     virtual
794     override
795     returns (bool)
796   {
797     return _operatorApprovals[owner][operator];
798   }
799 
800   /**
801    * @dev See {IERC721-transferFrom}.
802    */
803   function transferFrom(
804     address from,
805     address to,
806     uint256 tokenId
807   ) public override onlyAllowedOperator(from) {
808     _transfer(from, to, tokenId);
809   }
810 
811   /**
812    * @dev See {IERC721-safeTransferFrom}.
813    */
814   function safeTransferFrom(
815     address from,
816     address to,
817     uint256 tokenId
818   ) public override onlyAllowedOperator(from) {
819     safeTransferFrom(from, to, tokenId, "");
820   }
821 
822   /**
823    * @dev See {IERC721-safeTransferFrom}.
824    */
825   function safeTransferFrom(
826     address from,
827     address to,
828     uint256 tokenId,
829     bytes memory _data
830   ) public override onlyAllowedOperator(from) {
831     _transfer(from, to, tokenId);
832     require(
833       _checkOnERC721Received(from, to, tokenId, _data),
834       "ERC721A: transfer to non ERC721Receiver implementer"
835     );
836   }
837 
838   /**
839    * @dev Returns whether `tokenId` exists.
840    *
841    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
842    *
843    * Tokens start existing when they are minted (`_mint`),
844    */
845   function _exists(uint256 tokenId) internal view returns (bool) {
846     return tokenId < currentIndex;
847   }
848 
849   function _safeMint(address to, uint256 quantity) internal {
850     _safeMint(to, quantity, "");
851   }
852 
853   /**
854    * @dev Mints `quantity` tokens and transfers them to `to`.
855    *
856    * Requirements:
857    *
858    * - there must be `quantity` tokens remaining unminted in the total collection.
859    * - `to` cannot be the zero address.
860    * - `quantity` cannot be larger than the max batch size.
861    *
862    * Emits a {Transfer} event.
863    */
864   function _safeMint(
865     address to,
866     uint256 quantity,
867     bytes memory _data
868   ) internal {
869     uint256 startTokenId = currentIndex;
870     require(to != address(0), "ERC721A: mint to the zero address");
871     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
872     require(!_exists(startTokenId), "ERC721A: token already minted");
873     // require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
874 
875     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
876 
877     AddressData memory addressData = _addressData[to];
878     _addressData[to] = AddressData(
879       addressData.balance + uint128(quantity),
880       addressData.numberMinted + uint128(quantity)
881     );
882     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
883 
884     uint256 updatedIndex = startTokenId;
885 
886     for (uint256 i = 0; i < quantity; i++) {
887       emit Transfer(address(0), to, updatedIndex);
888       require(
889         _checkOnERC721Received(address(0), to, updatedIndex, _data),
890         "ERC721A: transfer to non ERC721Receiver implementer"
891       );
892       updatedIndex++;
893     }
894 
895     currentIndex = updatedIndex;
896     _afterTokenTransfers(address(0), to, startTokenId, quantity);
897   }
898 
899   /**
900    * @dev Transfers `tokenId` from `from` to `to`.
901    *
902    * Requirements:
903    *
904    * - `to` cannot be the zero address.
905    * - `tokenId` token must be owned by `from`.
906    *
907    * Emits a {Transfer} event.
908    */
909   function _transfer(
910     address from,
911     address to,
912     uint256 tokenId
913   ) private {
914     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
915 
916     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
917       getApproved(tokenId) == _msgSender() ||
918       isApprovedForAll(prevOwnership.addr, _msgSender()));
919 
920     require(
921       isApprovedOrOwner,
922       "ERC721A: transfer caller is not owner nor approved"
923     );
924 
925     require(
926       prevOwnership.addr == from,
927       "ERC721A: transfer from incorrect owner"
928     );
929     require(to != address(0), "ERC721A: transfer to the zero address");
930 
931     _beforeTokenTransfers(from, to, tokenId, 1);
932 
933     // Clear approvals from the previous owner
934     _approve(address(0), tokenId, prevOwnership.addr);
935 
936     _addressData[from].balance -= 1;
937     _addressData[to].balance += 1;
938     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
939 
940     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
941     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
942     uint256 nextTokenId = tokenId + 1;
943     if (_ownerships[nextTokenId].addr == address(0)) {
944       if (_exists(nextTokenId)) {
945         _ownerships[nextTokenId] = TokenOwnership(
946           prevOwnership.addr,
947           prevOwnership.startTimestamp
948         );
949       }
950     }
951 
952     emit Transfer(from, to, tokenId);
953     _afterTokenTransfers(from, to, tokenId, 1);
954   }
955 
956   /**
957    * @dev Approve `to` to operate on `tokenId`
958    *
959    * Emits a {Approval} event.
960    */
961   function _approve(
962     address to,
963     uint256 tokenId,
964     address owner
965   ) private {
966     _tokenApprovals[tokenId] = to;
967     emit Approval(owner, to, tokenId);
968   }
969 
970   uint256 public nextOwnerToExplicitlySet = 0;
971 
972   /**
973    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
974    */
975   function _setOwnersExplicit(uint256 quantity) internal {
976     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
977     require(quantity > 0, "quantity must be nonzero");
978     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
979     if (endIndex > collectionSize - 1) {
980       endIndex = collectionSize - 1;
981     }
982     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
983     require(_exists(endIndex), "not enough minted yet for this cleanup");
984     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
985       if (_ownerships[i].addr == address(0)) {
986         TokenOwnership memory ownership = ownershipOf(i);
987         _ownerships[i] = TokenOwnership(
988           ownership.addr,
989           ownership.startTimestamp
990         );
991       }
992     }
993     nextOwnerToExplicitlySet = endIndex + 1;
994   }
995 
996   /**
997    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
998    * The call is not executed if the target address is not a contract.
999    *
1000    * @param from address representing the previous owner of the given token ID
1001    * @param to target address that will receive the tokens
1002    * @param tokenId uint256 ID of the token to be transferred
1003    * @param _data bytes optional data to send along with the call
1004    * @return bool whether the call correctly returned the expected magic value
1005    */
1006   function _checkOnERC721Received(
1007     address from,
1008     address to,
1009     uint256 tokenId,
1010     bytes memory _data
1011   ) private returns (bool) {
1012     if (to.isContract()) {
1013       try
1014         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1015       returns (bytes4 retval) {
1016         return retval == IERC721Receiver(to).onERC721Received.selector;
1017       } catch (bytes memory reason) {
1018         if (reason.length == 0) {
1019           revert("ERC721A: transfer to non ERC721Receiver implementer");
1020         } else {
1021           assembly {
1022             revert(add(32, reason), mload(reason))
1023           }
1024         }
1025       }
1026     } else {
1027       return true;
1028     }
1029   }
1030 
1031   /**
1032    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1033    *
1034    * startTokenId - the first token id to be transferred
1035    * quantity - the amount to be transferred
1036    *
1037    * Calling conditions:
1038    *
1039    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1040    * transferred to `to`.
1041    * - When `from` is zero, `tokenId` will be minted for `to`.
1042    */
1043   function _beforeTokenTransfers(
1044     address from,
1045     address to,
1046     uint256 startTokenId,
1047     uint256 quantity
1048   ) internal virtual {}
1049 
1050   /**
1051    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1052    * minting.
1053    *
1054    * startTokenId - the first token id to be transferred
1055    * quantity - the amount to be transferred
1056    *
1057    * Calling conditions:
1058    *
1059    * - when `from` and `to` are both non-zero.
1060    * - `from` and `to` are never both zero.
1061    */
1062   function _afterTokenTransfers(
1063     address from,
1064     address to,
1065     uint256 startTokenId,
1066     uint256 quantity
1067   ) internal virtual {}
1068 }
1069 // /MerkleProof.sol
1070 
1071 
1072 pragma solidity ^0.8.0;
1073 
1074 library MerkleProof {
1075     /**
1076      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1077      * defined by `root`. For this, a `proof` must be provided, containing
1078      * sibling hashes on the branch from the leaf to the root of the tree. Each
1079      * pair of leaves and each pair of pre-images are assumed to be sorted.
1080      */
1081     function verify(
1082         bytes32[] memory proof,
1083         bytes32 root,
1084         bytes32 leaf
1085     ) internal pure returns (bool) {
1086         return processProof(proof, leaf) == root;
1087     }
1088 
1089     /**
1090      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1091      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1092      * hash matches the root of the tree. When processing the proof, the pairs
1093      * of leafs & pre-images are assumed to be sorted.
1094      *
1095      * _Available since v4.4._
1096      */
1097     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1098         bytes32 computedHash = leaf;
1099         for (uint256 i = 0; i < proof.length; i++) {
1100             bytes32 proofElement = proof[i];
1101             if (computedHash <= proofElement) {
1102                 // Hash(current computed hash + current element of the proof)
1103                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1104             } else {
1105                 // Hash(current element of the proof + current computed hash)
1106                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1107             }
1108         }
1109         return computedHash;
1110     }
1111 }
1112 // File: ZERO/ZERO.sol
1113 
1114 
1115 /*
1116 
1117 8888888888P 8888888888 8888888b.   .d88888b.  
1118       d88P  888        888   Y88b d88P" "Y88b 
1119      d88P   888        888    888 888     888 
1120     d88P    8888888    888   d88P 888     888 
1121    d88P     888        8888888P"  888     888 
1122   d88P      888        888 T88b   888     888 
1123  d88P       888        888  T88b  Y88b. .d88P 
1124 d8888888888 8888888888 888   T88b  "Y88888P"  
1125 
1126 It's Zero's mission to help the world onboard onto crypto.
1127 
1128 The Zeros collection consists of over 200+ hand drawn traits
1129 and backgrounds that we've been working on for the last few months.
1130 
1131 In a world where humans and robots coexist. Zero was created to advance
1132 the world's technology. Some humans have rejected the new technology.
1133 Those that have joined the new world are called Zeroes.The world rejects
1134 these new tools and advancements out of fear.
1135 
1136 
1137 Learn more:
1138 https://usezero.io/
1139 
1140 */
1141 
1142 pragma solidity ^0.8.17;
1143 contract Zero is Ownable, ERC721A, ReentrancyGuard {
1144 
1145     uint256 private _publicPrice;
1146     uint256 private _presalePrice;
1147 
1148     uint256 private _maxPurchaseDuringWhitelist;
1149     uint256 private _maxPurchaseDuringSale;
1150     uint256 private _maxPerTransaction;
1151 
1152     uint256 private _maxMint;
1153     address private _team;
1154 
1155     bytes32 public _merkleRoot;
1156     bytes32 public _zeroListMerkleRoot;
1157 
1158     mapping(address => uint256) public presaleAddressMintCount;
1159     mapping(address => uint256) public zeroListMintAddressCount;
1160 
1161     bool public isPaused = false;
1162     bool public isPublicMint = false;
1163     bool public isWhitelistMint = false;
1164 
1165     string private _tokenURI;
1166     
1167     constructor(
1168         uint256 publicPrice,
1169         uint256 presalePrice,
1170 
1171         uint256 maxPurchaseDuringWhitelist,
1172         uint256 maxPurchaseDuringSale,
1173         uint256 maxPerTransaction,
1174 
1175         uint256 maxMint,
1176         address team,
1177 
1178         bytes32 merkleRoot,
1179         bytes32 zeroListMerkleRoot
1180 
1181     ) ERC721A("ZERO", "ZERO", maxPerTransaction, maxMint) {
1182         _publicPrice = publicPrice;
1183         _presalePrice = presalePrice;
1184 
1185         _maxPurchaseDuringWhitelist = maxPurchaseDuringWhitelist;
1186         _maxPurchaseDuringSale = maxPurchaseDuringSale;
1187         _maxPerTransaction = maxPerTransaction;
1188 
1189         _maxMint = maxMint;
1190         _team = team;
1191 
1192         _merkleRoot = merkleRoot;
1193         _zeroListMerkleRoot = zeroListMerkleRoot;
1194     }
1195 
1196     function setParams (uint256 publicPrice,
1197         uint256 presalePrice,
1198 
1199         uint256 maxPurchaseDuringWhitelist,
1200         uint256 maxPurchaseDuringSale,
1201         uint256 maxPerTransaction,
1202 
1203         uint256 maxMint,
1204         address team,
1205 
1206         bytes32 merkleRoot,
1207         bytes32 zeroListMerkleRoot
1208     ) external onlyOwner {
1209         _publicPrice = publicPrice;
1210         _presalePrice = presalePrice;
1211 
1212         _maxPurchaseDuringWhitelist = maxPurchaseDuringWhitelist;
1213         _maxPurchaseDuringSale = maxPurchaseDuringSale;
1214         _maxPerTransaction = maxPerTransaction;
1215 
1216         _maxMint = maxMint;
1217         _team = team;
1218 
1219         _merkleRoot = merkleRoot;
1220         _zeroListMerkleRoot = zeroListMerkleRoot;
1221     }
1222 
1223     function setMaxMintPerWalletWhitelist (uint256 val) external onlyOwner {
1224         _maxPurchaseDuringWhitelist = val;
1225     }
1226 
1227     function setMaxMintPerWalletSale (uint256 val) external onlyOwner {
1228         _maxPurchaseDuringSale = val;
1229     }
1230 
1231     function checkIsPublicMint () external view returns (bool) {
1232         return isPublicMint;
1233     }
1234 
1235     function pause() external onlyOwner {
1236         isPaused = true;
1237     }
1238 
1239     function unpause() external onlyOwner {
1240         isPaused = false;
1241     }
1242 
1243     function setTeam(address team) external onlyOwner {
1244         _team = team;
1245     }
1246 
1247     function getPublicPrice() external view returns(uint256) {
1248         return _publicPrice;
1249     }
1250 
1251     function setPublicMint (bool value) external onlyOwner {
1252         isPublicMint = value;
1253     }
1254 
1255     function setWhitelistMint (bool value) external onlyOwner {
1256         isWhitelistMint = value;
1257     }
1258 
1259     function setPresalePrice (uint256 price) external onlyOwner {
1260         _presalePrice = price;
1261     }
1262 
1263     function setPublicPrice (uint256 price) external onlyOwner {
1264         _publicPrice = price;
1265     }
1266 
1267     function setCollectionSize (uint256 size) external onlyOwner {
1268         collectionSize = size;
1269         _maxMint = size;
1270     }
1271 
1272     modifier mintGuard(uint256 tokenCount) {
1273         require(!isPaused, "Paused!");
1274         
1275         require(tokenCount > 0 && tokenCount <= _maxPerTransaction, "You cannot mint this many");
1276         require(msg.sender == tx.origin, "Sender not origin");
1277         // Price check
1278         if (isPublicMint) {
1279             require(_publicPrice * tokenCount <= msg.value, "Insufficient funds");
1280         } else {
1281             require(_presalePrice * tokenCount <= msg.value, "Insufficient funds");
1282         }
1283         require(totalSupply() + tokenCount <= _maxMint+1, "Sold out!");
1284         _;
1285     }
1286 
1287     function mint(uint256 amount) external payable mintGuard(amount) {
1288         require(isPublicMint, "Mint has not started");
1289         _safeMint(msg.sender, amount);
1290     }
1291 
1292     function mintPresale(uint256 amount, bytes32[] calldata proof) external payable mintGuard(amount) {
1293         require(MerkleProof.verify(proof, _merkleRoot, keccak256(abi.encodePacked(msg.sender))), "You're not eligible for presale.");
1294         require(isWhitelistMint, "Mint has not started");
1295         require(presaleAddressMintCount[msg.sender] + amount <= _maxPurchaseDuringWhitelist, "Only one NFT can be minted");
1296         presaleAddressMintCount[msg.sender] += amount;
1297 
1298         _safeMint(msg.sender, amount);
1299     }
1300 
1301     function zeroListMint(bytes32[] calldata proof) external payable {
1302         uint256 amount = 1;
1303         require(!isPaused, "Paused!");
1304         require(msg.sender == tx.origin, "Sender not origin");
1305 
1306         require(MerkleProof.verify(proof, _zeroListMerkleRoot, keccak256(abi.encodePacked(msg.sender))), "You're not on the Zero List");
1307         require(isWhitelistMint, "Mint has not started");
1308         require(zeroListMintAddressCount[msg.sender] + amount <= 1, "Only one NFT can be claimed on the Zero List.");
1309         zeroListMintAddressCount[msg.sender] += amount;
1310 
1311         _safeMint(msg.sender, amount);
1312     }
1313 
1314     function setMaxBatchSize (uint256 val) external onlyOwner {
1315         maxBatchSize = val;
1316         _maxPerTransaction = val;
1317     }
1318 
1319     function payout() external onlyOwner {
1320         payable(_team).transfer(address(this).balance);
1321     }
1322 
1323     function setPayout(address addr) external onlyOwner returns(address) {
1324         _team = addr;
1325         return addr;
1326     }
1327 
1328     function devMint(uint32 qty) external onlyOwner {
1329         _safeMint(msg.sender, qty);
1330     }
1331 
1332     function setMerkleRoots(bytes32 zeroList, bytes32 allowList) external onlyOwner {
1333         _merkleRoot = allowList;
1334         _zeroListMerkleRoot = zeroList;
1335     }
1336 
1337     function setMaxMint(uint256 maxMint) external onlyOwner {
1338         _maxMint = maxMint;
1339     }
1340 
1341     function setBaseURI(string calldata baseURI) external onlyOwner {
1342         _tokenURI = baseURI;
1343     }
1344 
1345     function _baseURI() internal view virtual override returns (string memory) {
1346         return _tokenURI;
1347     }
1348 }