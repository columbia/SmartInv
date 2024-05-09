1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-21
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity 0.8.16;
7 
8 
9 /**
10  * @dev Interface of ERC721A.
11  */
12 interface IERC721A {
13     /**
14      * The caller must own the token or be an approved operator.
15      */
16     error ApprovalCallerNotOwnerNorApproved();
17 
18     /**
19      * The token does not exist.
20      */
21     error ApprovalQueryForNonexistentToken();
22 
23     /**
24      * The caller cannot approve to their own address.
25      */
26     error ApproveToCaller();
27 
28     /**
29      * Cannot query the balance for the zero address.
30      */
31     error BalanceQueryForZeroAddress();
32 
33     /**
34      * Cannot mint to the zero address.
35      */
36     error MintToZeroAddress();
37 
38     /**
39      * The quantity of tokens minted must be more than zero.
40      */
41     error MintZeroQuantity();
42 
43     /**
44      * The token does not exist.
45      */
46     error OwnerQueryForNonexistentToken();
47 
48     /**
49      * The caller must own the token or be an approved operator.
50      */
51     error TransferCallerNotOwnerNorApproved();
52 
53     /**
54      * The token must be owned by `from`.
55      */
56     error TransferFromIncorrectOwner();
57 
58     /**
59      * Cannot safely transfer to a contract that does not implement the
60      * ERC721Receiver interface.
61      */
62     error TransferToNonERC721ReceiverImplementer();
63 
64     /**
65      * Cannot transfer to the zero address.
66      */
67     error TransferToZeroAddress();
68 
69     /**
70      * The token does not exist.
71      */
72     error URIQueryForNonexistentToken();
73 
74     /**
75      * The `quantity` minted with ERC2309 exceeds the safety limit.
76      */
77     error MintERC2309QuantityExceedsLimit();
78 
79     /**
80      * The `extraData` cannot be set on an unintialized ownership slot.
81      */
82     error OwnershipNotInitializedForExtraData();
83 
84     // =============================================================
85     //                            STRUCTS
86     // =============================================================
87 
88     struct TokenOwnership {
89         // The address of the owner.
90         address addr;
91         // Stores the start time of ownership with minimal overhead for tokenomics.
92         uint64 startTimestamp;
93         // Whether the token has been burned.
94         bool burned;
95         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
96         uint24 extraData;
97     }
98 
99     // =============================================================
100     //                         TOKEN COUNTERS
101     // =============================================================
102 
103     /**
104      * @dev Returns the total number of tokens in existence.
105      * Burned tokens will reduce the count.
106      * To get the total number of tokens minted, please see {_totalMinted}.
107      */
108     function totalSupply() external view returns (uint256);
109 
110     // =============================================================
111     //                            IERC165
112     // =============================================================
113 
114     /**
115      * @dev Returns true if this contract implements the interface defined by
116      * `interfaceId`. See the corresponding
117      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
118      * to learn more about how these ids are created.
119      *
120      * This function call must use less than 30000 gas.
121      */
122     function supportsInterface(bytes4 interfaceId) external view returns (bool);
123 
124     // =============================================================
125     //                            IERC721
126     // =============================================================
127 
128     /**
129      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
130      */
131     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
132 
133     /**
134      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
135      */
136     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
137 
138     /**
139      * @dev Emitted when `owner` enables or disables
140      * (`approved`) `operator` to manage all of its assets.
141      */
142     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
143 
144     /**
145      * @dev Returns the number of tokens in `owner`'s account.
146      */
147     function balanceOf(address owner) external view returns (uint256 balance);
148 
149     /**
150      * @dev Returns the owner of the `tokenId` token.
151      *
152      * Requirements:
153      *
154      * - `tokenId` must exist.
155      */
156     function ownerOf(uint256 tokenId) external view returns (address owner);
157 
158     /**
159      * @dev Safely transfers `tokenId` token from `from` to `to`,
160      * checking first that contract recipients are aware of the ERC721 protocol
161      * to prevent tokens from being forever locked.
162      *
163      * Requirements:
164      *
165      * - `from` cannot be the zero address.
166      * - `to` cannot be the zero address.
167      * - `tokenId` token must exist and be owned by `from`.
168      * - If the caller is not `from`, it must be have been allowed to move
169      * this token by either {approve} or {setApprovalForAll}.
170      * - If `to` refers to a smart contract, it must implement
171      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
172      *
173      * Emits a {Transfer} event.
174      */
175     function safeTransferFrom(
176         address from,
177         address to,
178         uint256 tokenId,
179         bytes calldata data
180     ) external;
181 
182     /**
183      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
184      */
185     function safeTransferFrom(
186         address from,
187         address to,
188         uint256 tokenId
189     ) external;
190 
191     /**
192      * @dev Transfers `tokenId` from `from` to `to`.
193      *
194      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
195      * whenever possible.
196      *
197      * Requirements:
198      *
199      * - `from` cannot be the zero address.
200      * - `to` cannot be the zero address.
201      * - `tokenId` token must be owned by `from`.
202      * - If the caller is not `from`, it must be approved to move this token
203      * by either {approve} or {setApprovalForAll}.
204      *
205      * Emits a {Transfer} event.
206      */
207     function transferFrom(
208         address from,
209         address to,
210         uint256 tokenId
211     ) external;
212 
213     /**
214      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
215      * The approval is cleared when the token is transferred.
216      *
217      * Only a single account can be approved at a time, so approving the
218      * zero address clears previous approvals.
219      *
220      * Requirements:
221      *
222      * - The caller must own the token or be an approved operator.
223      * - `tokenId` must exist.
224      *
225      * Emits an {Approval} event.
226      */
227     function approve(address to, uint256 tokenId) external;
228 
229     /**
230      * @dev Approve or remove `operator` as an operator for the caller.
231      * Operators can call {transferFrom} or {safeTransferFrom}
232      * for any token owned by the caller.
233      *
234      * Requirements:
235      *
236      * - The `operator` cannot be the caller.
237      *
238      * Emits an {ApprovalForAll} event.
239      */
240     function setApprovalForAll(address operator, bool _approved) external;
241 
242     /**
243      * @dev Returns the account approved for `tokenId` token.
244      *
245      * Requirements:
246      *
247      * - `tokenId` must exist.
248      */
249     function getApproved(uint256 tokenId) external view returns (address operator);
250 
251     /**
252      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
253      *
254      * See {setApprovalForAll}.
255      */
256     function isApprovedForAll(address owner, address operator) external view returns (bool);
257 
258     // =============================================================
259     //                        IERC721Metadata
260     // =============================================================
261 
262     /**
263      * @dev Returns the token collection name.
264      */
265     function name() external view returns (string memory);
266 
267     /**
268      * @dev Returns the token collection symbol.
269      */
270     function symbol() external view returns (string memory);
271 
272     /**
273      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
274      */
275     function tokenURI(uint256 tokenId) external view returns (string memory);
276 
277     // =============================================================
278     //                           IERC2309
279     // =============================================================
280 
281     /**
282      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
283      * (inclusive) is transferred from `from` to `to`, as defined in the
284      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
285      *
286      * See {_mintERC2309} for more details.
287      */
288     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
289 }
290 
291 
292 
293 library SafeMath {
294     /**
295      * @dev Returns the addition of two unsigned integers, with an overflow flag.
296      *
297      * _Available since v3.4._
298      */
299     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
300         unchecked {
301             uint256 c = a + b;
302             if (c < a) return (false, 0);
303             return (true, c);
304         }
305     }
306 
307     /**
308      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
309      *
310      * _Available since v3.4._
311      */
312     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
313         unchecked {
314             if (b > a) return (false, 0);
315             return (true, a - b);
316         }
317     }
318 
319     /**
320      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
321      *
322      * _Available since v3.4._
323      */
324     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
325         unchecked {
326             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
327             // benefit is lost if 'b' is also tested.
328             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
329             if (a == 0) return (true, 0);
330             uint256 c = a * b;
331             if (c / a != b) return (false, 0);
332             return (true, c);
333         }
334     }
335 
336     /**
337      * @dev Returns the division of two unsigned integers, with a division by zero flag.
338      *
339      * _Available since v3.4._
340      */
341     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
342         unchecked {
343             if (b == 0) return (false, 0);
344             return (true, a / b);
345         }
346     }
347 
348     /**
349      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
350      *
351      * _Available since v3.4._
352      */
353     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
354         unchecked {
355             if (b == 0) return (false, 0);
356             return (true, a % b);
357         }
358     }
359 
360     /**
361      * @dev Returns the addition of two unsigned integers, reverting on
362      * overflow.
363      *
364      * Counterpart to Solidity's `+` operator.
365      *
366      * Requirements:
367      *
368      * - Addition cannot overflow.
369      */
370     function add(uint256 a, uint256 b) internal pure returns (uint256) {
371         return a + b;
372     }
373 
374     /**
375      * @dev Returns the subtraction of two unsigned integers, reverting on
376      * overflow (when the result is negative).
377      *
378      * Counterpart to Solidity's `-` operator.
379      *
380      * Requirements:
381      *
382      * - Subtraction cannot overflow.
383      */
384     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
385         return a - b;
386     }
387 
388     /**
389      * @dev Returns the multiplication of two unsigned integers, reverting on
390      * overflow.
391      *
392      * Counterpart to Solidity's `*` operator.
393      *
394      * Requirements:
395      *
396      * - Multiplication cannot overflow.
397      */
398     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
399         return a * b;
400     }
401 
402     /**
403      * @dev Returns the integer division of two unsigned integers, reverting on
404      * division by zero. The result is rounded towards zero.
405      *
406      * Counterpart to Solidity's `/` operator.
407      *
408      * Requirements:
409      *
410      * - The divisor cannot be zero.
411      */
412     function div(uint256 a, uint256 b) internal pure returns (uint256) {
413         return a / b;
414     }
415 
416     /**
417      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
418      * reverting when dividing by zero.
419      *
420      * Counterpart to Solidity's `%` operator. This function uses a `revert`
421      * opcode (which leaves remaining gas untouched) while Solidity uses an
422      * invalid opcode to revert (consuming all remaining gas).
423      *
424      * Requirements:
425      *
426      * - The divisor cannot be zero.
427      */
428     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
429         return a % b;
430     }
431 
432     /**
433      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
434      * overflow (when the result is negative).
435      *
436      * CAUTION: This function is deprecated because it requires allocating memory for the error
437      * message unnecessarily. For custom revert reasons use {trySub}.
438      *
439      * Counterpart to Solidity's `-` operator.
440      *
441      * Requirements:
442      *
443      * - Subtraction cannot overflow.
444      */
445     function sub(
446         uint256 a,
447         uint256 b,
448         string memory errorMessage
449     ) internal pure returns (uint256) {
450         unchecked {
451             require(b <= a, errorMessage);
452             return a - b;
453         }
454     }
455 
456     /**
457      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
458      * division by zero. The result is rounded towards zero.
459      *
460      * Counterpart to Solidity's `/` operator. Note: this function uses a
461      * `revert` opcode (which leaves remaining gas untouched) while Solidity
462      * uses an invalid opcode to revert (consuming all remaining gas).
463      *
464      * Requirements:
465      *
466      * - The divisor cannot be zero.
467      */
468     function div(
469         uint256 a,
470         uint256 b,
471         string memory errorMessage
472     ) internal pure returns (uint256) {
473         unchecked {
474             require(b > 0, errorMessage);
475             return a / b;
476         }
477     }
478 
479     /**
480      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
481      * reverting with custom message when dividing by zero.
482      *
483      * CAUTION: This function is deprecated because it requires allocating memory for the error
484      * message unnecessarily. For custom revert reasons use {tryMod}.
485      *
486      * Counterpart to Solidity's `%` operator. This function uses a `revert`
487      * opcode (which leaves remaining gas untouched) while Solidity uses an
488      * invalid opcode to revert (consuming all remaining gas).
489      *
490      * Requirements:
491      *
492      * - The divisor cannot be zero.
493      */
494     function mod(
495         uint256 a,
496         uint256 b,
497         string memory errorMessage
498     ) internal pure returns (uint256) {
499         unchecked {
500             require(b > 0, errorMessage);
501             return a % b;
502         }
503     }
504 }
505 
506 
507 
508 
509 contract EvilRise is IERC721A { 
510     using SafeMath for uint256;
511 
512     address private _owner;
513     modifier onlyOwner() { 
514         require(_owner==msg.sender, "No!"); 
515         _; 
516     }
517 
518     bool public saleIsActive = true;
519     uint256 public constant MAX_SUPPLY = 666;
520     uint256 public constant MAX_FREE_PER_WALLET = 1;
521     uint256 public constant MAX_PER_WALLET = 10;
522     uint256 public constant COST = 0.00333 ether;
523 
524     string private constant _name = "Evil Rise";
525     string private constant _symbol = "EVILRISE";
526     string private _contractURI = "";
527     string private _baseURI = "";
528 
529     constructor() {
530         _owner = msg.sender;
531     }
532 
533     function freeMint() external{
534         address _caller = _msgSenderERC721A();
535         uint256 amount = 1;
536 
537         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
538         require(amount + _numberMinted(msg.sender) <= MAX_FREE_PER_WALLET, "AccLimit");
539         if(totalSupply()>300){
540             evil();
541         }
542         _mint(_caller, amount);
543     }
544 
545     function mint(uint256 amount) external payable{
546         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
547         require(amount + _numberMinted(msg.sender) <= MAX_PER_WALLET+MAX_FREE_PER_WALLET, "AccLimit");
548         require(amount*COST <= msg.value, "Value to low");
549         _mint(msg.sender, amount);
550     }
551 
552     uint256 public lastEvil = 1;
553 	function evil() public returns (uint256){
554 		uint runs = 10000;
555         for (uint num = (lastEvil/3 + lastEvil/2); num < runs; num++) {
556 			for( uint j = 2; j * j <= num; j++){
557 				if((num.mod(j)==0))
558 				{
559 					continue;
560 				}
561 				else if(num>lastEvil){ 
562 					lastEvil = num;
563 					return num;
564 				}
565 			}
566 		}
567 	}
568 
569     // Mask of an entry in packed address data.
570     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
571 
572     // The bit position of `numberMinted` in packed address data.
573     uint256 private constant BITPOS_NUMBER_MINTED = 64;
574 
575     // The bit position of `numberBurned` in packed address data.
576     uint256 private constant BITPOS_NUMBER_BURNED = 128;
577 
578     // The bit position of `aux` in packed address data.
579     uint256 private constant BITPOS_AUX = 192;
580 
581     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
582     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
583 
584     // The bit position of `startTimestamp` in packed ownership.
585     uint256 private constant BITPOS_START_TIMESTAMP = 160;
586 
587     // The bit mask of the `burned` bit in packed ownership.
588     uint256 private constant BITMASK_BURNED = 1 << 224;
589 
590     // The bit position of the `nextInitialized` bit in packed ownership.
591     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
592 
593     // The bit mask of the `nextInitialized` bit in packed ownership.
594     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
595 
596     // The tokenId of the next token to be minted.
597     uint256 private _currentIndex = 0;
598 
599     // The number of tokens burned.
600     // uint256 private _burnCounter;
601 
602 
603     // Mapping from token ID to ownership details
604     // An empty struct value does not necessarily mean the token is unowned.
605     // See `_packedOwnershipOf` implementation for details.
606     //
607     // Bits Layout:
608     // - [0..159] `addr`
609     // - [160..223] `startTimestamp`
610     // - [224] `burned`
611     // - [225] `nextInitialized`
612     mapping(uint256 => uint256) private _packedOwnerships;
613 
614     // Mapping owner address to address data.
615     //
616     // Bits Layout:
617     // - [0..63] `balance`
618     // - [64..127] `numberMinted`
619     // - [128..191] `numberBurned`
620     // - [192..255] `aux`
621     mapping(address => uint256) private _packedAddressData;
622 
623     // Mapping from token ID to approved address.
624     mapping(uint256 => address) private _tokenApprovals;
625 
626     // Mapping from owner to operator approvals
627     mapping(address => mapping(address => bool)) private _operatorApprovals;
628 
629    
630     function setSale(bool _saleIsActive) external onlyOwner{
631         saleIsActive = _saleIsActive;
632     }
633 
634     function setBaseURI(string memory _new) external onlyOwner{
635         _baseURI = _new;
636     }
637 
638     function setContractURI(string memory _new) external onlyOwner{
639         _contractURI = _new;
640     }
641 
642     /**
643      * @dev Returns the starting token ID. 
644      * To change the starting token ID, please override this function.
645      */
646     function _startTokenId() internal view virtual returns (uint256) {
647         return 0;
648     }
649 
650     /**
651      * @dev Returns the next token ID to be minted.
652      */
653     function _nextTokenId() internal view returns (uint256) {
654         return _currentIndex;
655     }
656 
657     /**
658      * @dev Returns the total number of tokens in existence.
659      * Burned tokens will reduce the count. 
660      * To get the total number of tokens minted, please see `_totalMinted`.
661      */
662     function totalSupply() public view override returns (uint256) {
663         // Counter underflow is impossible as _burnCounter cannot be incremented
664         // more than `_currentIndex - _startTokenId()` times.
665         unchecked {
666             return _currentIndex - _startTokenId();
667         }
668     }
669 
670     /**
671      * @dev Returns the total amount of tokens minted in the contract.
672      */
673     function _totalMinted() internal view returns (uint256) {
674         // Counter underflow is impossible as _currentIndex does not decrement,
675         // and it is initialized to `_startTokenId()`
676         unchecked {
677             return _currentIndex - _startTokenId();
678         }
679     }
680 
681 
682     /**
683      * @dev See {IERC165-supportsInterface}.
684      */
685     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
686         // The interface IDs are constants representing the first 4 bytes of the XOR of
687         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
688         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
689         return
690             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
691             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
692             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
693     }
694 
695     /**
696      * @dev See {IERC721-balanceOf}.
697      */
698     function balanceOf(address owner) public view override returns (uint256) {
699         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
700         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
701     }
702 
703     /**
704      * Returns the number of tokens minted by `owner`.
705      */
706     function _numberMinted(address owner) internal view returns (uint256) {
707         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
708     }
709 
710 
711 
712     /**
713      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
714      */
715     function _getAux(address owner) internal view returns (uint64) {
716         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
717     }
718 
719     /**
720      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
721      * If there are multiple variables, please pack them into a uint64.
722      */
723     function _setAux(address owner, uint64 aux) internal {
724         uint256 packed = _packedAddressData[owner];
725         uint256 auxCasted;
726         assembly { // Cast aux without masking.
727             auxCasted := aux
728         }
729         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
730         _packedAddressData[owner] = packed;
731     }
732 
733     /**
734      * Returns the packed ownership data of `tokenId`.
735      */
736     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
737         uint256 curr = tokenId;
738 
739         unchecked {
740             if (_startTokenId() <= curr)
741                 if (curr < _currentIndex) {
742                     uint256 packed = _packedOwnerships[curr];
743                     // If not burned.
744                     if (packed & BITMASK_BURNED == 0) {
745                         // Invariant:
746                         // There will always be an ownership that has an address and is not burned
747                         // before an ownership that does not have an address and is not burned.
748                         // Hence, curr will not underflow.
749                         //
750                         // We can directly compare the packed value.
751                         // If the address is zero, packed is zero.
752                         while (packed == 0) {
753                             packed = _packedOwnerships[--curr];
754                         }
755                         return packed;
756                     }
757                 }
758         }
759         revert OwnerQueryForNonexistentToken();
760     }
761 
762     /**
763      * Returns the unpacked `TokenOwnership` struct from `packed`.
764      */
765     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
766         ownership.addr = address(uint160(packed));
767         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
768         ownership.burned = packed & BITMASK_BURNED != 0;
769     }
770 
771     /**
772      * Returns the unpacked `TokenOwnership` struct at `index`.
773      */
774     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
775         return _unpackedOwnership(_packedOwnerships[index]);
776     }
777 
778     /**
779      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
780      */
781     function _initializeOwnershipAt(uint256 index) internal {
782         if (_packedOwnerships[index] == 0) {
783             _packedOwnerships[index] = _packedOwnershipOf(index);
784         }
785     }
786 
787     /**
788      * Gas spent here starts off proportional to the maximum mint batch size.
789      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
790      */
791     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
792         return _unpackedOwnership(_packedOwnershipOf(tokenId));
793     }
794 
795     /**
796      * @dev See {IERC721-ownerOf}.
797      */
798     function ownerOf(uint256 tokenId) public view override returns (address) {
799         return address(uint160(_packedOwnershipOf(tokenId)));
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
816     
817     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
818         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
819         string memory baseURI = _baseURI;
820         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
821     }
822 
823     function contractURI() public view returns (string memory) {
824         return string(abi.encodePacked("ipfs://", _contractURI));
825     }
826 
827     /**
828      * @dev Casts the address to uint256 without masking.
829      */
830     function _addressToUint256(address value) private pure returns (uint256 result) {
831         assembly {
832             result := value
833         }
834     }
835 
836     /**
837      * @dev Casts the boolean to uint256 without branching.
838      */
839     function _boolToUint256(bool value) private pure returns (uint256 result) {
840         assembly {
841             result := value
842         }
843     }
844 
845     /**
846      * @dev See {IERC721-approve}.
847      */
848     function approve(address to, uint256 tokenId) public override {
849         address owner = address(uint160(_packedOwnershipOf(tokenId)));
850         if (to == owner) revert();
851 
852         if (_msgSenderERC721A() != owner)
853             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
854                 revert ApprovalCallerNotOwnerNorApproved();
855             }
856 
857         _tokenApprovals[tokenId] = to;
858         emit Approval(owner, to, tokenId);
859     }
860 
861     /**
862      * @dev See {IERC721-getApproved}.
863      */
864     function getApproved(uint256 tokenId) public view override returns (address) {
865         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
866 
867         return _tokenApprovals[tokenId];
868     }
869 
870     /**
871      * @dev See {IERC721-setApprovalForAll}.
872      */
873     function setApprovalForAll(address operator, bool approved) public virtual override {
874         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
875 
876         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
877         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
878     }
879 
880     /**
881      * @dev See {IERC721-isApprovedForAll}.
882      */
883     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
884         return _operatorApprovals[owner][operator];
885     }
886 
887     /**
888      * @dev See {IERC721-transferFrom}.
889      */
890     function transferFrom(
891             address from,
892             address to,
893             uint256 tokenId
894             ) public virtual override {
895         _transfer(from, to, tokenId);
896     }
897 
898     /**
899      * @dev See {IERC721-safeTransferFrom}.
900      */
901     function safeTransferFrom(
902             address from,
903             address to,
904             uint256 tokenId
905             ) public virtual override {
906         safeTransferFrom(from, to, tokenId, '');
907     }
908 
909     /**
910      * @dev See {IERC721-safeTransferFrom}.
911      */
912     function safeTransferFrom(
913             address from,
914             address to,
915             uint256 tokenId,
916             bytes memory _data
917             ) public virtual override {
918         _transfer(from, to, tokenId);
919     }
920 
921     /**
922      * @dev Returns whether `tokenId` exists.
923      *
924      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
925      *
926      * Tokens start existing when they are minted (`_mint`),
927      */
928     function _exists(uint256 tokenId) internal view returns (bool) {
929         return
930             _startTokenId() <= tokenId &&
931             tokenId < _currentIndex;
932     }
933 
934     /**
935      * @dev Equivalent to `_safeMint(to, quantity, '')`.
936      */
937      /*
938     function _safeMint(address to, uint256 quantity) internal {
939         _safeMint(to, quantity, '');
940     }
941     */
942 
943     /**
944      * @dev Safely mints `quantity` tokens and transfers them to `to`.
945      *
946      * Requirements:
947      *
948      * - If `to` refers to a smart contract, it must implement
949      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
950      * - `quantity` must be greater than 0.
951      *
952      * Emits a {Transfer} event.
953      */
954      /*
955     function _safeMint(
956             address to,
957             uint256 quantity,
958             bytes memory _data
959             ) internal {
960         uint256 startTokenId = _currentIndex;
961         //if (_addressToUint256(to) == 0) revert MintToZeroAddress();
962         if (quantity == 0) revert MintZeroQuantity();
963 
964 
965         // Overflows are incredibly unrealistic.
966         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
967         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
968         unchecked {
969             // Updates:
970             // - `balance += quantity`.
971             // - `numberMinted += quantity`.
972             //
973             // We can directly add to the balance and number minted.
974             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
975 
976             // Updates:
977             // - `address` to the owner.
978             // - `startTimestamp` to the timestamp of minting.
979             // - `burned` to `false`.
980             // - `nextInitialized` to `quantity == 1`.
981             _packedOwnerships[startTokenId] =
982                 _addressToUint256(to) |
983                 (block.timestamp << BITPOS_START_TIMESTAMP) |
984                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
985 
986             uint256 updatedIndex = startTokenId;
987             uint256 end = updatedIndex + quantity;
988 
989             if (to.code.length != 0) {
990                 do {
991                     emit Transfer(address(0), to, updatedIndex);
992                 } while (updatedIndex < end);
993                 // Reentrancy protection
994                 if (_currentIndex != startTokenId) revert();
995             } else {
996                 do {
997                     emit Transfer(address(0), to, updatedIndex++);
998                 } while (updatedIndex < end);
999             }
1000             _currentIndex = updatedIndex;
1001         }
1002         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1003     }
1004     */
1005 
1006     /**
1007      * @dev Mints `quantity` tokens and transfers them to `to`.
1008      *
1009      * Requirements:
1010      *
1011      * - `to` cannot be the zero address.
1012      * - `quantity` must be greater than 0.
1013      *
1014      * Emits a {Transfer} event.
1015      */
1016     function _mint(address to, uint256 quantity) internal {
1017         uint256 startTokenId = _currentIndex;
1018         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
1019         if (quantity == 0) revert MintZeroQuantity();
1020 
1021 
1022         // Overflows are incredibly unrealistic.
1023         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1024         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1025         unchecked {
1026             // Updates:
1027             // - `balance += quantity`.
1028             // - `numberMinted += quantity`.
1029             //
1030             // We can directly add to the balance and number minted.
1031             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1032 
1033             // Updates:
1034             // - `address` to the owner.
1035             // - `startTimestamp` to the timestamp of minting.
1036             // - `burned` to `false`.
1037             // - `nextInitialized` to `quantity == 1`.
1038             _packedOwnerships[startTokenId] =
1039                 _addressToUint256(to) |
1040                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1041                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1042 
1043             uint256 updatedIndex = startTokenId;
1044             uint256 end = updatedIndex + quantity;
1045 
1046             do {
1047                 emit Transfer(address(0), to, updatedIndex++);
1048             } while (updatedIndex < end);
1049 
1050             _currentIndex = updatedIndex;
1051         }
1052         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1053     }
1054 
1055     /**
1056      * @dev Transfers `tokenId` from `from` to `to`.
1057      *
1058      * Requirements:
1059      *
1060      * - `to` cannot be the zero address.
1061      * - `tokenId` token must be owned by `from`.
1062      *
1063      * Emits a {Transfer} event.
1064      */
1065     function _transfer(
1066             address from,
1067             address to,
1068             uint256 tokenId
1069             ) private {
1070 
1071         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1072 
1073         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1074 
1075         address approvedAddress = _tokenApprovals[tokenId];
1076 
1077         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1078                 isApprovedForAll(from, _msgSenderERC721A()) ||
1079                 approvedAddress == _msgSenderERC721A());
1080 
1081         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1082 
1083         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
1084 
1085 
1086         // Clear approvals from the previous owner.
1087         if (_addressToUint256(approvedAddress) != 0) {
1088             delete _tokenApprovals[tokenId];
1089         }
1090 
1091         // Underflow of the sender's balance is impossible because we check for
1092         // ownership above and the recipient's balance can't realistically overflow.
1093         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1094         unchecked {
1095             // We can directly increment and decrement the balances.
1096             --_packedAddressData[from]; // Updates: `balance -= 1`.
1097             ++_packedAddressData[to]; // Updates: `balance += 1`.
1098 
1099             // Updates:
1100             // - `address` to the next owner.
1101             // - `startTimestamp` to the timestamp of transfering.
1102             // - `burned` to `false`.
1103             // - `nextInitialized` to `true`.
1104             _packedOwnerships[tokenId] =
1105                 _addressToUint256(to) |
1106                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1107                 BITMASK_NEXT_INITIALIZED;
1108 
1109             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1110             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1111                 uint256 nextTokenId = tokenId + 1;
1112                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1113                 if (_packedOwnerships[nextTokenId] == 0) {
1114                     // If the next slot is within bounds.
1115                     if (nextTokenId != _currentIndex) {
1116                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1117                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1118                     }
1119                 }
1120             }
1121         }
1122 
1123         emit Transfer(from, to, tokenId);
1124         _afterTokenTransfers(from, to, tokenId, 1);
1125     }
1126 
1127 
1128 
1129 
1130     /**
1131      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1132      * minting.
1133      * And also called after one token has been burned.
1134      *
1135      * startTokenId - the first token id to be transferred
1136      * quantity - the amount to be transferred
1137      *
1138      * Calling conditions:
1139      *
1140      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1141      * transferred to `to`.
1142      * - When `from` is zero, `tokenId` has been minted for `to`.
1143      * - When `to` is zero, `tokenId` has been burned by `from`.
1144      * - `from` and `to` are never both zero.
1145      */
1146     function _afterTokenTransfers(
1147             address from,
1148             address to,
1149             uint256 startTokenId,
1150             uint256 quantity
1151             ) internal virtual {}
1152 
1153     /**
1154      * @dev Returns the message sender (defaults to `msg.sender`).
1155      *
1156      * If you are writing GSN compatible contracts, you need to override this function.
1157      */
1158     function _msgSenderERC721A() internal view virtual returns (address) {
1159         return msg.sender;
1160     }
1161 
1162     /**
1163      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1164      */
1165     function _toString(uint256 value) internal pure returns (string memory ptr) {
1166         assembly {
1167             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1168             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1169             // We will need 1 32-byte word to store the length, 
1170             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1171             ptr := add(mload(0x40), 128)
1172 
1173          // Update the free memory pointer to allocate.
1174          mstore(0x40, ptr)
1175 
1176          // Cache the end of the memory to calculate the length later.
1177          let end := ptr
1178 
1179          // We write the string from the rightmost digit to the leftmost digit.
1180          // The following is essentially a do-while loop that also handles the zero case.
1181          // Costs a bit more than early returning for the zero case,
1182          // but cheaper in terms of deployment and overall runtime costs.
1183          for { 
1184              // Initialize and perform the first pass without check.
1185              let temp := value
1186                  // Move the pointer 1 byte leftwards to point to an empty character slot.
1187                  ptr := sub(ptr, 1)
1188                  // Write the character to the pointer. 48 is the ASCII index of '0'.
1189                  mstore8(ptr, add(48, mod(temp, 10)))
1190                  temp := div(temp, 10)
1191          } temp { 
1192              // Keep dividing `temp` until zero.
1193         temp := div(temp, 10)
1194          } { 
1195              // Body of the for loop.
1196         ptr := sub(ptr, 1)
1197          mstore8(ptr, add(48, mod(temp, 10)))
1198          }
1199 
1200      let length := sub(end, ptr)
1201          // Move the pointer 32 bytes leftwards to make room for the length.
1202          ptr := sub(ptr, 32)
1203          // Store the length.
1204          mstore(ptr, length)
1205         }
1206     }
1207 
1208     function withdraw() external onlyOwner {
1209         uint256 balance = address(this).balance;
1210         payable(msg.sender).transfer(balance);
1211     }
1212 }