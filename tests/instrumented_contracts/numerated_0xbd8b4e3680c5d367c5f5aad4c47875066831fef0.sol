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
509 contract DeathProof501 is IERC721A { 
510     using SafeMath for uint256;
511 
512     address private _owner;
513     modifier onlyOwner() { 
514         require(_owner==msg.sender, "No!"); 
515         _; 
516     }
517 
518     bool public saleIsActive = true;
519 
520     uint256 public constant MAX_SUPPLY = 501;
521     uint256 public constant MAX_TEAM_SUPPLY = 10;
522     uint256 public constant MAX_PER_WALLET = 1;
523     uint256 public constant COST = 0 ether;
524 
525     string private constant _name = "Death Proof 501";
526     string private constant _symbol = "DP501";
527     string private _contractURI = "QmVcuAzwLeqxAUsBuJhcwRJZi898PaaD1iawcfTcdNrrmg";
528     string private _baseURI = "QmPE1C5kr9x1bGmowacKzhkTvAY17cU7sfpsNa1ZmqLQDa";
529 
530     constructor() {
531         _owner = msg.sender;
532     }
533 
534     
535 
536     function mint() external{
537         address _caller = _msgSenderERC721A();
538         uint256 amount = 1;
539 
540         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
541         require(amount + _numberMinted(msg.sender) <= MAX_PER_WALLET, "AccLimit");
542         nextPrime();
543 
544         _mint(_caller, amount);
545     }
546 
547     function teamMint() external onlyOwner{
548         uint256 amount = MAX_TEAM_SUPPLY;
549         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
550         require(amount + _numberMinted(msg.sender) <= MAX_TEAM_SUPPLY, "AccLimit");
551         _mint(msg.sender, amount);
552     }
553 
554     uint256 public lastPrime = 1;
555 	function nextPrime() public returns (uint256){
556 		uint runs = 10000;
557         for (uint num = (lastPrime/3 + lastPrime/2 + lastPrime/4); num < runs; num++) {
558 			for( uint j = 2; j * j <= num; j++){
559 				if((num.mod(j)==0))
560 				{
561 					continue;
562 				}
563 				else if(num>lastPrime){ 
564 					lastPrime = num;
565 					return num;
566 				}
567 			}
568 		}
569 	}
570 
571     // Mask of an entry in packed address data.
572     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
573 
574     // The bit position of `numberMinted` in packed address data.
575     uint256 private constant BITPOS_NUMBER_MINTED = 64;
576 
577     // The bit position of `numberBurned` in packed address data.
578     uint256 private constant BITPOS_NUMBER_BURNED = 128;
579 
580     // The bit position of `aux` in packed address data.
581     uint256 private constant BITPOS_AUX = 192;
582 
583     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
584     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
585 
586     // The bit position of `startTimestamp` in packed ownership.
587     uint256 private constant BITPOS_START_TIMESTAMP = 160;
588 
589     // The bit mask of the `burned` bit in packed ownership.
590     uint256 private constant BITMASK_BURNED = 1 << 224;
591 
592     // The bit position of the `nextInitialized` bit in packed ownership.
593     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
594 
595     // The bit mask of the `nextInitialized` bit in packed ownership.
596     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
597 
598     // The tokenId of the next token to be minted.
599     uint256 private _currentIndex = 0;
600 
601     // The number of tokens burned.
602     // uint256 private _burnCounter;
603 
604 
605     // Mapping from token ID to ownership details
606     // An empty struct value does not necessarily mean the token is unowned.
607     // See `_packedOwnershipOf` implementation for details.
608     //
609     // Bits Layout:
610     // - [0..159] `addr`
611     // - [160..223] `startTimestamp`
612     // - [224] `burned`
613     // - [225] `nextInitialized`
614     mapping(uint256 => uint256) private _packedOwnerships;
615 
616     // Mapping owner address to address data.
617     //
618     // Bits Layout:
619     // - [0..63] `balance`
620     // - [64..127] `numberMinted`
621     // - [128..191] `numberBurned`
622     // - [192..255] `aux`
623     mapping(address => uint256) private _packedAddressData;
624 
625     // Mapping from token ID to approved address.
626     mapping(uint256 => address) private _tokenApprovals;
627 
628     // Mapping from owner to operator approvals
629     mapping(address => mapping(address => bool)) private _operatorApprovals;
630 
631    
632     function setSale(bool _saleIsActive) external onlyOwner{
633         saleIsActive = _saleIsActive;
634     }
635 
636     function setBaseURI(string memory _new) external onlyOwner{
637         _baseURI = _new;
638     }
639 
640     function setContractURI(string memory _new) external onlyOwner{
641         _contractURI = _new;
642     }
643 
644     /**
645      * @dev Returns the starting token ID. 
646      * To change the starting token ID, please override this function.
647      */
648     function _startTokenId() internal view virtual returns (uint256) {
649         return 0;
650     }
651 
652     /**
653      * @dev Returns the next token ID to be minted.
654      */
655     function _nextTokenId() internal view returns (uint256) {
656         return _currentIndex;
657     }
658 
659     /**
660      * @dev Returns the total number of tokens in existence.
661      * Burned tokens will reduce the count. 
662      * To get the total number of tokens minted, please see `_totalMinted`.
663      */
664     function totalSupply() public view override returns (uint256) {
665         // Counter underflow is impossible as _burnCounter cannot be incremented
666         // more than `_currentIndex - _startTokenId()` times.
667         unchecked {
668             return _currentIndex - _startTokenId();
669         }
670     }
671 
672     /**
673      * @dev Returns the total amount of tokens minted in the contract.
674      */
675     function _totalMinted() internal view returns (uint256) {
676         // Counter underflow is impossible as _currentIndex does not decrement,
677         // and it is initialized to `_startTokenId()`
678         unchecked {
679             return _currentIndex - _startTokenId();
680         }
681     }
682 
683 
684     /**
685      * @dev See {IERC165-supportsInterface}.
686      */
687     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
688         // The interface IDs are constants representing the first 4 bytes of the XOR of
689         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
690         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
691         return
692             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
693             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
694             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
695     }
696 
697     /**
698      * @dev See {IERC721-balanceOf}.
699      */
700     function balanceOf(address owner) public view override returns (uint256) {
701         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
702         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
703     }
704 
705     /**
706      * Returns the number of tokens minted by `owner`.
707      */
708     function _numberMinted(address owner) internal view returns (uint256) {
709         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
710     }
711 
712 
713 
714     /**
715      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
716      */
717     function _getAux(address owner) internal view returns (uint64) {
718         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
719     }
720 
721     /**
722      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
723      * If there are multiple variables, please pack them into a uint64.
724      */
725     function _setAux(address owner, uint64 aux) internal {
726         uint256 packed = _packedAddressData[owner];
727         uint256 auxCasted;
728         assembly { // Cast aux without masking.
729             auxCasted := aux
730         }
731         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
732         _packedAddressData[owner] = packed;
733     }
734 
735     /**
736      * Returns the packed ownership data of `tokenId`.
737      */
738     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
739         uint256 curr = tokenId;
740 
741         unchecked {
742             if (_startTokenId() <= curr)
743                 if (curr < _currentIndex) {
744                     uint256 packed = _packedOwnerships[curr];
745                     // If not burned.
746                     if (packed & BITMASK_BURNED == 0) {
747                         // Invariant:
748                         // There will always be an ownership that has an address and is not burned
749                         // before an ownership that does not have an address and is not burned.
750                         // Hence, curr will not underflow.
751                         //
752                         // We can directly compare the packed value.
753                         // If the address is zero, packed is zero.
754                         while (packed == 0) {
755                             packed = _packedOwnerships[--curr];
756                         }
757                         return packed;
758                     }
759                 }
760         }
761         revert OwnerQueryForNonexistentToken();
762     }
763 
764     /**
765      * Returns the unpacked `TokenOwnership` struct from `packed`.
766      */
767     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
768         ownership.addr = address(uint160(packed));
769         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
770         ownership.burned = packed & BITMASK_BURNED != 0;
771     }
772 
773     /**
774      * Returns the unpacked `TokenOwnership` struct at `index`.
775      */
776     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
777         return _unpackedOwnership(_packedOwnerships[index]);
778     }
779 
780     /**
781      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
782      */
783     function _initializeOwnershipAt(uint256 index) internal {
784         if (_packedOwnerships[index] == 0) {
785             _packedOwnerships[index] = _packedOwnershipOf(index);
786         }
787     }
788 
789     /**
790      * Gas spent here starts off proportional to the maximum mint batch size.
791      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
792      */
793     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
794         return _unpackedOwnership(_packedOwnershipOf(tokenId));
795     }
796 
797     /**
798      * @dev See {IERC721-ownerOf}.
799      */
800     function ownerOf(uint256 tokenId) public view override returns (address) {
801         return address(uint160(_packedOwnershipOf(tokenId)));
802     }
803 
804     /**
805      * @dev See {IERC721Metadata-name}.
806      */
807     function name() public view virtual override returns (string memory) {
808         return _name;
809     }
810 
811     /**
812      * @dev See {IERC721Metadata-symbol}.
813      */
814     function symbol() public view virtual override returns (string memory) {
815         return _symbol;
816     }
817 
818     
819     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
820         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
821         string memory baseURI = _baseURI;
822         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
823     }
824 
825     function contractURI() public view returns (string memory) {
826         return string(abi.encodePacked("ipfs://", _contractURI));
827     }
828 
829     /**
830      * @dev Casts the address to uint256 without masking.
831      */
832     function _addressToUint256(address value) private pure returns (uint256 result) {
833         assembly {
834             result := value
835         }
836     }
837 
838     /**
839      * @dev Casts the boolean to uint256 without branching.
840      */
841     function _boolToUint256(bool value) private pure returns (uint256 result) {
842         assembly {
843             result := value
844         }
845     }
846 
847     /**
848      * @dev See {IERC721-approve}.
849      */
850     function approve(address to, uint256 tokenId) public override {
851         address owner = address(uint160(_packedOwnershipOf(tokenId)));
852         if (to == owner) revert();
853 
854         if (_msgSenderERC721A() != owner)
855             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
856                 revert ApprovalCallerNotOwnerNorApproved();
857             }
858 
859         _tokenApprovals[tokenId] = to;
860         emit Approval(owner, to, tokenId);
861     }
862 
863     /**
864      * @dev See {IERC721-getApproved}.
865      */
866     function getApproved(uint256 tokenId) public view override returns (address) {
867         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
868 
869         return _tokenApprovals[tokenId];
870     }
871 
872     /**
873      * @dev See {IERC721-setApprovalForAll}.
874      */
875     function setApprovalForAll(address operator, bool approved) public virtual override {
876         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
877 
878         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
879         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
880     }
881 
882     /**
883      * @dev See {IERC721-isApprovedForAll}.
884      */
885     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
886         return _operatorApprovals[owner][operator];
887     }
888 
889     /**
890      * @dev See {IERC721-transferFrom}.
891      */
892     function transferFrom(
893             address from,
894             address to,
895             uint256 tokenId
896             ) public virtual override {
897         _transfer(from, to, tokenId);
898     }
899 
900     /**
901      * @dev See {IERC721-safeTransferFrom}.
902      */
903     function safeTransferFrom(
904             address from,
905             address to,
906             uint256 tokenId
907             ) public virtual override {
908         safeTransferFrom(from, to, tokenId, '');
909     }
910 
911     /**
912      * @dev See {IERC721-safeTransferFrom}.
913      */
914     function safeTransferFrom(
915             address from,
916             address to,
917             uint256 tokenId,
918             bytes memory _data
919             ) public virtual override {
920         _transfer(from, to, tokenId);
921     }
922 
923     /**
924      * @dev Returns whether `tokenId` exists.
925      *
926      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
927      *
928      * Tokens start existing when they are minted (`_mint`),
929      */
930     function _exists(uint256 tokenId) internal view returns (bool) {
931         return
932             _startTokenId() <= tokenId &&
933             tokenId < _currentIndex;
934     }
935 
936     /**
937      * @dev Equivalent to `_safeMint(to, quantity, '')`.
938      */
939      /*
940     function _safeMint(address to, uint256 quantity) internal {
941         _safeMint(to, quantity, '');
942     }
943     */
944 
945     /**
946      * @dev Safely mints `quantity` tokens and transfers them to `to`.
947      *
948      * Requirements:
949      *
950      * - If `to` refers to a smart contract, it must implement
951      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
952      * - `quantity` must be greater than 0.
953      *
954      * Emits a {Transfer} event.
955      */
956      /*
957     function _safeMint(
958             address to,
959             uint256 quantity,
960             bytes memory _data
961             ) internal {
962         uint256 startTokenId = _currentIndex;
963         //if (_addressToUint256(to) == 0) revert MintToZeroAddress();
964         if (quantity == 0) revert MintZeroQuantity();
965 
966 
967         // Overflows are incredibly unrealistic.
968         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
969         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
970         unchecked {
971             // Updates:
972             // - `balance += quantity`.
973             // - `numberMinted += quantity`.
974             //
975             // We can directly add to the balance and number minted.
976             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
977 
978             // Updates:
979             // - `address` to the owner.
980             // - `startTimestamp` to the timestamp of minting.
981             // - `burned` to `false`.
982             // - `nextInitialized` to `quantity == 1`.
983             _packedOwnerships[startTokenId] =
984                 _addressToUint256(to) |
985                 (block.timestamp << BITPOS_START_TIMESTAMP) |
986                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
987 
988             uint256 updatedIndex = startTokenId;
989             uint256 end = updatedIndex + quantity;
990 
991             if (to.code.length != 0) {
992                 do {
993                     emit Transfer(address(0), to, updatedIndex);
994                 } while (updatedIndex < end);
995                 // Reentrancy protection
996                 if (_currentIndex != startTokenId) revert();
997             } else {
998                 do {
999                     emit Transfer(address(0), to, updatedIndex++);
1000                 } while (updatedIndex < end);
1001             }
1002             _currentIndex = updatedIndex;
1003         }
1004         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1005     }
1006     */
1007 
1008     /**
1009      * @dev Mints `quantity` tokens and transfers them to `to`.
1010      *
1011      * Requirements:
1012      *
1013      * - `to` cannot be the zero address.
1014      * - `quantity` must be greater than 0.
1015      *
1016      * Emits a {Transfer} event.
1017      */
1018     function _mint(address to, uint256 quantity) internal {
1019         uint256 startTokenId = _currentIndex;
1020         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
1021         if (quantity == 0) revert MintZeroQuantity();
1022 
1023 
1024         // Overflows are incredibly unrealistic.
1025         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1026         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1027         unchecked {
1028             // Updates:
1029             // - `balance += quantity`.
1030             // - `numberMinted += quantity`.
1031             //
1032             // We can directly add to the balance and number minted.
1033             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1034 
1035             // Updates:
1036             // - `address` to the owner.
1037             // - `startTimestamp` to the timestamp of minting.
1038             // - `burned` to `false`.
1039             // - `nextInitialized` to `quantity == 1`.
1040             _packedOwnerships[startTokenId] =
1041                 _addressToUint256(to) |
1042                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1043                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1044 
1045             uint256 updatedIndex = startTokenId;
1046             uint256 end = updatedIndex + quantity;
1047 
1048             do {
1049                 emit Transfer(address(0), to, updatedIndex++);
1050             } while (updatedIndex < end);
1051 
1052             _currentIndex = updatedIndex;
1053         }
1054         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1055     }
1056 
1057     /**
1058      * @dev Transfers `tokenId` from `from` to `to`.
1059      *
1060      * Requirements:
1061      *
1062      * - `to` cannot be the zero address.
1063      * - `tokenId` token must be owned by `from`.
1064      *
1065      * Emits a {Transfer} event.
1066      */
1067     function _transfer(
1068             address from,
1069             address to,
1070             uint256 tokenId
1071             ) private {
1072 
1073         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1074 
1075         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1076 
1077         address approvedAddress = _tokenApprovals[tokenId];
1078 
1079         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1080                 isApprovedForAll(from, _msgSenderERC721A()) ||
1081                 approvedAddress == _msgSenderERC721A());
1082 
1083         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1084 
1085         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
1086 
1087 
1088         // Clear approvals from the previous owner.
1089         if (_addressToUint256(approvedAddress) != 0) {
1090             delete _tokenApprovals[tokenId];
1091         }
1092 
1093         // Underflow of the sender's balance is impossible because we check for
1094         // ownership above and the recipient's balance can't realistically overflow.
1095         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1096         unchecked {
1097             // We can directly increment and decrement the balances.
1098             --_packedAddressData[from]; // Updates: `balance -= 1`.
1099             ++_packedAddressData[to]; // Updates: `balance += 1`.
1100 
1101             // Updates:
1102             // - `address` to the next owner.
1103             // - `startTimestamp` to the timestamp of transfering.
1104             // - `burned` to `false`.
1105             // - `nextInitialized` to `true`.
1106             _packedOwnerships[tokenId] =
1107                 _addressToUint256(to) |
1108                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1109                 BITMASK_NEXT_INITIALIZED;
1110 
1111             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1112             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1113                 uint256 nextTokenId = tokenId + 1;
1114                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1115                 if (_packedOwnerships[nextTokenId] == 0) {
1116                     // If the next slot is within bounds.
1117                     if (nextTokenId != _currentIndex) {
1118                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1119                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1120                     }
1121                 }
1122             }
1123         }
1124 
1125         emit Transfer(from, to, tokenId);
1126         _afterTokenTransfers(from, to, tokenId, 1);
1127     }
1128 
1129 
1130 
1131 
1132     /**
1133      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1134      * minting.
1135      * And also called after one token has been burned.
1136      *
1137      * startTokenId - the first token id to be transferred
1138      * quantity - the amount to be transferred
1139      *
1140      * Calling conditions:
1141      *
1142      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1143      * transferred to `to`.
1144      * - When `from` is zero, `tokenId` has been minted for `to`.
1145      * - When `to` is zero, `tokenId` has been burned by `from`.
1146      * - `from` and `to` are never both zero.
1147      */
1148     function _afterTokenTransfers(
1149             address from,
1150             address to,
1151             uint256 startTokenId,
1152             uint256 quantity
1153             ) internal virtual {}
1154 
1155     /**
1156      * @dev Returns the message sender (defaults to `msg.sender`).
1157      *
1158      * If you are writing GSN compatible contracts, you need to override this function.
1159      */
1160     function _msgSenderERC721A() internal view virtual returns (address) {
1161         return msg.sender;
1162     }
1163 
1164     /**
1165      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1166      */
1167     function _toString(uint256 value) internal pure returns (string memory ptr) {
1168         assembly {
1169             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1170             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1171             // We will need 1 32-byte word to store the length, 
1172             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1173             ptr := add(mload(0x40), 128)
1174 
1175          // Update the free memory pointer to allocate.
1176          mstore(0x40, ptr)
1177 
1178          // Cache the end of the memory to calculate the length later.
1179          let end := ptr
1180 
1181          // We write the string from the rightmost digit to the leftmost digit.
1182          // The following is essentially a do-while loop that also handles the zero case.
1183          // Costs a bit more than early returning for the zero case,
1184          // but cheaper in terms of deployment and overall runtime costs.
1185          for { 
1186              // Initialize and perform the first pass without check.
1187              let temp := value
1188                  // Move the pointer 1 byte leftwards to point to an empty character slot.
1189                  ptr := sub(ptr, 1)
1190                  // Write the character to the pointer. 48 is the ASCII index of '0'.
1191                  mstore8(ptr, add(48, mod(temp, 10)))
1192                  temp := div(temp, 10)
1193          } temp { 
1194              // Keep dividing `temp` until zero.
1195         temp := div(temp, 10)
1196          } { 
1197              // Body of the for loop.
1198         ptr := sub(ptr, 1)
1199          mstore8(ptr, add(48, mod(temp, 10)))
1200          }
1201 
1202      let length := sub(end, ptr)
1203          // Move the pointer 32 bytes leftwards to make room for the length.
1204          ptr := sub(ptr, 32)
1205          // Store the length.
1206          mstore(ptr, length)
1207         }
1208     }
1209 
1210 
1211 }