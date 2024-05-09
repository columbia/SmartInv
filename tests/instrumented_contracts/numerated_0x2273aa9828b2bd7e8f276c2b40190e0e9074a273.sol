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
291 /**
292  * @dev String operations.
293  */
294 library Strings {
295     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
296 
297     /**
298      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
299      */
300     function toString(uint256 value) internal pure returns (string memory) {
301         // Inspired by OraclizeAPI's implementation - MIT licence
302         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
303 
304         if (value == 0) {
305             return "0";
306         }
307         uint256 temp = value;
308         uint256 digits;
309         while (temp != 0) {
310             digits++;
311             temp /= 10;
312         }
313         bytes memory buffer = new bytes(digits);
314         while (value != 0) {
315             digits -= 1;
316             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
317             value /= 10;
318         }
319         return string(buffer);
320     }
321 
322     /**
323      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
324      */
325     function toHexString(uint256 value) internal pure returns (string memory) {
326         if (value == 0) {
327             return "0x00";
328         }
329         uint256 temp = value;
330         uint256 length = 0;
331         while (temp != 0) {
332             length++;
333             temp >>= 8;
334         }
335         return toHexString(value, length);
336     }
337 
338     /**
339      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
340      */
341     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
342         bytes memory buffer = new bytes(2 * length + 2);
343         buffer[0] = "0";
344         buffer[1] = "x";
345         for (uint256 i = 2 * length + 1; i > 1; --i) {
346             buffer[i] = _HEX_SYMBOLS[value & 0xf];
347             value >>= 4;
348         }
349         require(value == 0, "Strings: hex length insufficient");
350         return string(buffer);
351     }
352 }
353 
354 library Base64 {
355     /**
356      * @dev Base64 Encoding/Decoding Table
357      */
358     string internal constant _TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
359 
360     /**
361      * @dev Converts a `bytes` to its Bytes64 `string` representation.
362      */
363     function encode(bytes memory data) internal pure returns (string memory) {
364         /**
365          * Inspired by Brecht Devos (Brechtpd) implementation - MIT licence
366          * https://github.com/Brechtpd/base64/blob/e78d9fd951e7b0977ddca77d92dc85183770daf4/base64.sol
367          */
368         if (data.length == 0) return "";
369 
370         // Loads the table into memory
371         string memory table = _TABLE;
372 
373         // Encoding takes 3 bytes chunks of binary data from `bytes` data parameter
374         // and split into 4 numbers of 6 bits.
375         // The final Base64 length should be `bytes` data length multiplied by 4/3 rounded up
376         // - `data.length + 2`  -> Round up
377         // - `/ 3`              -> Number of 3-bytes chunks
378         // - `4 *`              -> 4 characters for each chunk
379         string memory result = new string(4 * ((data.length + 2) / 3));
380 
381         /// @solidity memory-safe-assembly
382         assembly {
383             // Prepare the lookup table (skip the first "length" byte)
384             let tablePtr := add(table, 1)
385 
386             // Prepare result pointer, jump over length
387             let resultPtr := add(result, 32)
388 
389             // Run over the input, 3 bytes at a time
390             for {
391                 let dataPtr := data
392                 let endPtr := add(data, mload(data))
393             } lt(dataPtr, endPtr) {
394 
395             } {
396                 // Advance 3 bytes
397                 dataPtr := add(dataPtr, 3)
398                 let input := mload(dataPtr)
399 
400                 // To write each character, shift the 3 bytes (18 bits) chunk
401                 // 4 times in blocks of 6 bits for each character (18, 12, 6, 0)
402                 // and apply logical AND with 0x3F which is the number of
403                 // the previous character in the ASCII table prior to the Base64 Table
404                 // The result is then added to the table to get the character to write,
405                 // and finally write it in the result pointer but with a left shift
406                 // of 256 (1 byte) - 8 (1 ASCII char) = 248 bits
407 
408                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
409                 resultPtr := add(resultPtr, 1) // Advance
410 
411                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
412                 resultPtr := add(resultPtr, 1) // Advance
413 
414                 mstore8(resultPtr, mload(add(tablePtr, and(shr(6, input), 0x3F))))
415                 resultPtr := add(resultPtr, 1) // Advance
416 
417                 mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
418                 resultPtr := add(resultPtr, 1) // Advance
419             }
420 
421             // When data `bytes` is not exactly 3 bytes long
422             // it is padded with `=` characters at the end
423             switch mod(mload(data), 3)
424             case 1 {
425                 mstore8(sub(resultPtr, 1), 0x3d)
426                 mstore8(sub(resultPtr, 2), 0x3d)
427             }
428             case 2 {
429                 mstore8(sub(resultPtr, 1), 0x3d)
430             }
431         }
432 
433         return result;
434     }
435 }
436 
437 library SafeMath {
438     /**
439      * @dev Returns the addition of two unsigned integers, with an overflow flag.
440      *
441      * _Available since v3.4._
442      */
443     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
444         unchecked {
445             uint256 c = a + b;
446             if (c < a) return (false, 0);
447             return (true, c);
448         }
449     }
450 
451     /**
452      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
453      *
454      * _Available since v3.4._
455      */
456     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
457         unchecked {
458             if (b > a) return (false, 0);
459             return (true, a - b);
460         }
461     }
462 
463     /**
464      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
465      *
466      * _Available since v3.4._
467      */
468     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
469         unchecked {
470             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
471             // benefit is lost if 'b' is also tested.
472             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
473             if (a == 0) return (true, 0);
474             uint256 c = a * b;
475             if (c / a != b) return (false, 0);
476             return (true, c);
477         }
478     }
479 
480     /**
481      * @dev Returns the division of two unsigned integers, with a division by zero flag.
482      *
483      * _Available since v3.4._
484      */
485     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
486         unchecked {
487             if (b == 0) return (false, 0);
488             return (true, a / b);
489         }
490     }
491 
492     /**
493      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
494      *
495      * _Available since v3.4._
496      */
497     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
498         unchecked {
499             if (b == 0) return (false, 0);
500             return (true, a % b);
501         }
502     }
503 
504     /**
505      * @dev Returns the addition of two unsigned integers, reverting on
506      * overflow.
507      *
508      * Counterpart to Solidity's `+` operator.
509      *
510      * Requirements:
511      *
512      * - Addition cannot overflow.
513      */
514     function add(uint256 a, uint256 b) internal pure returns (uint256) {
515         return a + b;
516     }
517 
518     /**
519      * @dev Returns the subtraction of two unsigned integers, reverting on
520      * overflow (when the result is negative).
521      *
522      * Counterpart to Solidity's `-` operator.
523      *
524      * Requirements:
525      *
526      * - Subtraction cannot overflow.
527      */
528     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
529         return a - b;
530     }
531 
532     /**
533      * @dev Returns the multiplication of two unsigned integers, reverting on
534      * overflow.
535      *
536      * Counterpart to Solidity's `*` operator.
537      *
538      * Requirements:
539      *
540      * - Multiplication cannot overflow.
541      */
542     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
543         return a * b;
544     }
545 
546     /**
547      * @dev Returns the integer division of two unsigned integers, reverting on
548      * division by zero. The result is rounded towards zero.
549      *
550      * Counterpart to Solidity's `/` operator.
551      *
552      * Requirements:
553      *
554      * - The divisor cannot be zero.
555      */
556     function div(uint256 a, uint256 b) internal pure returns (uint256) {
557         return a / b;
558     }
559 
560     /**
561      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
562      * reverting when dividing by zero.
563      *
564      * Counterpart to Solidity's `%` operator. This function uses a `revert`
565      * opcode (which leaves remaining gas untouched) while Solidity uses an
566      * invalid opcode to revert (consuming all remaining gas).
567      *
568      * Requirements:
569      *
570      * - The divisor cannot be zero.
571      */
572     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
573         return a % b;
574     }
575 
576     /**
577      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
578      * overflow (when the result is negative).
579      *
580      * CAUTION: This function is deprecated because it requires allocating memory for the error
581      * message unnecessarily. For custom revert reasons use {trySub}.
582      *
583      * Counterpart to Solidity's `-` operator.
584      *
585      * Requirements:
586      *
587      * - Subtraction cannot overflow.
588      */
589     function sub(
590         uint256 a,
591         uint256 b,
592         string memory errorMessage
593     ) internal pure returns (uint256) {
594         unchecked {
595             require(b <= a, errorMessage);
596             return a - b;
597         }
598     }
599 
600     /**
601      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
602      * division by zero. The result is rounded towards zero.
603      *
604      * Counterpart to Solidity's `/` operator. Note: this function uses a
605      * `revert` opcode (which leaves remaining gas untouched) while Solidity
606      * uses an invalid opcode to revert (consuming all remaining gas).
607      *
608      * Requirements:
609      *
610      * - The divisor cannot be zero.
611      */
612     function div(
613         uint256 a,
614         uint256 b,
615         string memory errorMessage
616     ) internal pure returns (uint256) {
617         unchecked {
618             require(b > 0, errorMessage);
619             return a / b;
620         }
621     }
622 
623     /**
624      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
625      * reverting with custom message when dividing by zero.
626      *
627      * CAUTION: This function is deprecated because it requires allocating memory for the error
628      * message unnecessarily. For custom revert reasons use {tryMod}.
629      *
630      * Counterpart to Solidity's `%` operator. This function uses a `revert`
631      * opcode (which leaves remaining gas untouched) while Solidity uses an
632      * invalid opcode to revert (consuming all remaining gas).
633      *
634      * Requirements:
635      *
636      * - The divisor cannot be zero.
637      */
638     function mod(
639         uint256 a,
640         uint256 b,
641         string memory errorMessage
642     ) internal pure returns (uint256) {
643         unchecked {
644             require(b > 0, errorMessage);
645             return a % b;
646         }
647     }
648 }
649 
650 
651 
652 
653 contract GasWork is IERC721A { 
654     using SafeMath for uint256;
655 
656     address private _owner;
657     modifier onlyOwner() { 
658         require(_owner==msg.sender, "No!"); 
659         _; 
660     }
661 
662     uint256 public constant MAX_PER_WALLET = 1;
663     uint256 public constant COST = 0 ether;
664     uint256 public constant MAX_SUPPLY = 987;
665 
666     string private constant _name = "Gas Work";
667     string private constant _symbol = "GW";
668     string private constant _contractURI = "QmZ1eWhY8mxJXeEFfacacQMpviSa6y6F3DsueRTWJs9ws2";
669     mapping (uint256 => string) public historyOfColor;
670 
671     constructor() {
672         _owner = msg.sender;
673     }
674 
675     function random() internal view returns (string memory) {
676         string memory input = Strings.toHexString(uint256(uint160(msg.sender)), 20);
677         string memory output = substring(input, 2, 8);
678         return output;
679     }
680 
681     function mint() external{
682         address _caller = _msgSenderERC721A();
683         uint256 amount = 1;
684 
685         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
686         require(amount + _numberMinted(msg.sender) <= MAX_PER_WALLET, "AccLimit");
687         historyOfColor[_currentIndex] = random();
688 
689         _mint(_caller, amount);
690     }
691 
692     function substring(string memory str, uint startIndex, uint endIndex) internal view returns (string memory) { 
693         bytes memory strBytes = bytes(str); 
694         bytes memory result = new bytes(endIndex-startIndex); 
695         for(uint i = startIndex; i < endIndex; i++) 
696         {
697             result[i-startIndex] = strBytes[i]; 
698         } 
699         return string(result); 
700     }
701 
702 
703     // Mask of an entry in packed address data.
704     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
705 
706     // The bit position of `numberMinted` in packed address data.
707     uint256 private constant BITPOS_NUMBER_MINTED = 64;
708 
709     // The bit position of `numberBurned` in packed address data.
710     uint256 private constant BITPOS_NUMBER_BURNED = 128;
711 
712     // The bit position of `aux` in packed address data.
713     uint256 private constant BITPOS_AUX = 192;
714 
715     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
716     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
717 
718     // The bit position of `startTimestamp` in packed ownership.
719     uint256 private constant BITPOS_START_TIMESTAMP = 160;
720 
721     // The bit mask of the `burned` bit in packed ownership.
722     uint256 private constant BITMASK_BURNED = 1 << 224;
723 
724     // The bit position of the `nextInitialized` bit in packed ownership.
725     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
726 
727     // The bit mask of the `nextInitialized` bit in packed ownership.
728     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
729 
730     // The tokenId of the next token to be minted.
731     uint256 private _currentIndex = 0;
732 
733     // The number of tokens burned.
734     // uint256 private _burnCounter;
735 
736 
737     // Mapping from token ID to ownership details
738     // An empty struct value does not necessarily mean the token is unowned.
739     // See `_packedOwnershipOf` implementation for details.
740     //
741     // Bits Layout:
742     // - [0..159] `addr`
743     // - [160..223] `startTimestamp`
744     // - [224] `burned`
745     // - [225] `nextInitialized`
746     mapping(uint256 => uint256) private _packedOwnerships;
747 
748     // Mapping owner address to address data.
749     //
750     // Bits Layout:
751     // - [0..63] `balance`
752     // - [64..127] `numberMinted`
753     // - [128..191] `numberBurned`
754     // - [192..255] `aux`
755     mapping(address => uint256) private _packedAddressData;
756 
757     // Mapping from token ID to approved address.
758     mapping(uint256 => address) private _tokenApprovals;
759 
760     // Mapping from owner to operator approvals
761     mapping(address => mapping(address => bool)) private _operatorApprovals;
762 
763    
764 
765     /**
766      * @dev Returns the starting token ID. 
767      * To change the starting token ID, please override this function.
768      */
769     function _startTokenId() internal view virtual returns (uint256) {
770         return 0;
771     }
772 
773     /**
774      * @dev Returns the next token ID to be minted.
775      */
776     function _nextTokenId() internal view returns (uint256) {
777         return _currentIndex;
778     }
779 
780     /**
781      * @dev Returns the total number of tokens in existence.
782      * Burned tokens will reduce the count. 
783      * To get the total number of tokens minted, please see `_totalMinted`.
784      */
785     function totalSupply() public view override returns (uint256) {
786         // Counter underflow is impossible as _burnCounter cannot be incremented
787         // more than `_currentIndex - _startTokenId()` times.
788         unchecked {
789             return _currentIndex - _startTokenId();
790         }
791     }
792 
793     /**
794      * @dev Returns the total amount of tokens minted in the contract.
795      */
796     function _totalMinted() internal view returns (uint256) {
797         // Counter underflow is impossible as _currentIndex does not decrement,
798         // and it is initialized to `_startTokenId()`
799         unchecked {
800             return _currentIndex - _startTokenId();
801         }
802     }
803 
804 
805     /**
806      * @dev See {IERC165-supportsInterface}.
807      */
808     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
809         // The interface IDs are constants representing the first 4 bytes of the XOR of
810         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
811         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
812         return
813             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
814             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
815             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
816     }
817 
818     /**
819      * @dev See {IERC721-balanceOf}.
820      */
821     function balanceOf(address owner) public view override returns (uint256) {
822         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
823         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
824     }
825 
826     /**
827      * Returns the number of tokens minted by `owner`.
828      */
829     function _numberMinted(address owner) internal view returns (uint256) {
830         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
831     }
832 
833 
834 
835     /**
836      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
837      */
838     function _getAux(address owner) internal view returns (uint64) {
839         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
840     }
841 
842     /**
843      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
844      * If there are multiple variables, please pack them into a uint64.
845      */
846     function _setAux(address owner, uint64 aux) internal {
847         uint256 packed = _packedAddressData[owner];
848         uint256 auxCasted;
849         assembly { // Cast aux without masking.
850             auxCasted := aux
851         }
852         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
853         _packedAddressData[owner] = packed;
854     }
855 
856     /**
857      * Returns the packed ownership data of `tokenId`.
858      */
859     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
860         uint256 curr = tokenId;
861 
862         unchecked {
863             if (_startTokenId() <= curr)
864                 if (curr < _currentIndex) {
865                     uint256 packed = _packedOwnerships[curr];
866                     // If not burned.
867                     if (packed & BITMASK_BURNED == 0) {
868                         // Invariant:
869                         // There will always be an ownership that has an address and is not burned
870                         // before an ownership that does not have an address and is not burned.
871                         // Hence, curr will not underflow.
872                         //
873                         // We can directly compare the packed value.
874                         // If the address is zero, packed is zero.
875                         while (packed == 0) {
876                             packed = _packedOwnerships[--curr];
877                         }
878                         return packed;
879                     }
880                 }
881         }
882         revert OwnerQueryForNonexistentToken();
883     }
884 
885     /**
886      * Returns the unpacked `TokenOwnership` struct from `packed`.
887      */
888     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
889         ownership.addr = address(uint160(packed));
890         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
891         ownership.burned = packed & BITMASK_BURNED != 0;
892     }
893 
894     /**
895      * Returns the unpacked `TokenOwnership` struct at `index`.
896      */
897     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
898         return _unpackedOwnership(_packedOwnerships[index]);
899     }
900 
901     /**
902      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
903      */
904     function _initializeOwnershipAt(uint256 index) internal {
905         if (_packedOwnerships[index] == 0) {
906             _packedOwnerships[index] = _packedOwnershipOf(index);
907         }
908     }
909 
910     /**
911      * Gas spent here starts off proportional to the maximum mint batch size.
912      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
913      */
914     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
915         return _unpackedOwnership(_packedOwnershipOf(tokenId));
916     }
917 
918     /**
919      * @dev See {IERC721-ownerOf}.
920      */
921     function ownerOf(uint256 tokenId) public view override returns (address) {
922         return address(uint160(_packedOwnershipOf(tokenId)));
923     }
924 
925     /**
926      * @dev See {IERC721Metadata-name}.
927      */
928     function name() public view virtual override returns (string memory) {
929         return _name;
930     }
931 
932     /**
933      * @dev See {IERC721Metadata-symbol}.
934      */
935     function symbol() public view virtual override returns (string memory) {
936         return _symbol;
937     }
938 
939     function render(uint256 _tokenId) internal view returns (string memory) {
940         string memory body = historyOfColor[_tokenId];
941         return string.concat(
942             '<svg height="200" width="200" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 1000 1000">',
943             '<defs><radialGradient id="glow" cx="0.25" cy="0.25" r="0.35"><stop offset="0%" stop-color="#e3a8b0" /><stop offset="100%" stop-color="#',body,'" /></radialGradient></defs>',
944             '<rect xmlns="http://www.w3.org/2000/svg" width="100%" height="100%" fill="white" />',
945             '<circle cx="500" cy="500" r="500" fill="url(#glow)" />',
946             '</svg>'
947         );
948     }
949 
950     function tokenURI(uint256 _tokenId)
951         public
952         view
953         override
954         returns (string memory)
955     {
956         require(_exists(_tokenId), "token does not exists");
957 
958         string memory svg = string(abi.encodePacked(render(_tokenId)));
959         string memory json = Base64.encode(
960             abi.encodePacked(
961                 '{"name": "GasWork #', Strings.toString(_tokenId),
962                 '", "description": "Gas Work on Chain", "image": "data:image/svg+xml;base64,',
963                 Base64.encode(bytes(svg)),
964                 '"}'
965             )
966         );
967 
968         return string(abi.encodePacked("data:application/json;base64,", json));
969     }
970 
971 
972 
973     function contractURI() public view returns (string memory) {
974         return string(abi.encodePacked("ipfs://", _contractURI));
975     }
976 
977     /**
978      * @dev Casts the address to uint256 without masking.
979      */
980     function _addressToUint256(address value) private pure returns (uint256 result) {
981         assembly {
982             result := value
983         }
984     }
985 
986     /**
987      * @dev Casts the boolean to uint256 without branching.
988      */
989     function _boolToUint256(bool value) private pure returns (uint256 result) {
990         assembly {
991             result := value
992         }
993     }
994 
995     /**
996      * @dev See {IERC721-approve}.
997      */
998     function approve(address to, uint256 tokenId) public override {
999         address owner = address(uint160(_packedOwnershipOf(tokenId)));
1000         if (to == owner) revert();
1001 
1002         if (_msgSenderERC721A() != owner)
1003             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1004                 revert ApprovalCallerNotOwnerNorApproved();
1005             }
1006 
1007         _tokenApprovals[tokenId] = to;
1008         emit Approval(owner, to, tokenId);
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-getApproved}.
1013      */
1014     function getApproved(uint256 tokenId) public view override returns (address) {
1015         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1016 
1017         return _tokenApprovals[tokenId];
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-setApprovalForAll}.
1022      */
1023     function setApprovalForAll(address operator, bool approved) public virtual override {
1024         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1025 
1026         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1027         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1028     }
1029 
1030     /**
1031      * @dev See {IERC721-isApprovedForAll}.
1032      */
1033     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1034         return _operatorApprovals[owner][operator];
1035     }
1036 
1037     /**
1038      * @dev See {IERC721-transferFrom}.
1039      */
1040     function transferFrom(
1041             address from,
1042             address to,
1043             uint256 tokenId
1044             ) public virtual override {
1045         _transfer(from, to, tokenId);
1046     }
1047 
1048     /**
1049      * @dev See {IERC721-safeTransferFrom}.
1050      */
1051     function safeTransferFrom(
1052             address from,
1053             address to,
1054             uint256 tokenId
1055             ) public virtual override {
1056         safeTransferFrom(from, to, tokenId, '');
1057     }
1058 
1059     /**
1060      * @dev See {IERC721-safeTransferFrom}.
1061      */
1062     function safeTransferFrom(
1063             address from,
1064             address to,
1065             uint256 tokenId,
1066             bytes memory _data
1067             ) public virtual override {
1068         _transfer(from, to, tokenId);
1069     }
1070 
1071     /**
1072      * @dev Returns whether `tokenId` exists.
1073      *
1074      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1075      *
1076      * Tokens start existing when they are minted (`_mint`),
1077      */
1078     function _exists(uint256 tokenId) internal view returns (bool) {
1079         return
1080             _startTokenId() <= tokenId &&
1081             tokenId < _currentIndex;
1082     }
1083 
1084     /**
1085      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1086      */
1087      /*
1088     function _safeMint(address to, uint256 quantity) internal {
1089         _safeMint(to, quantity, '');
1090     }
1091     */
1092 
1093     /**
1094      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1095      *
1096      * Requirements:
1097      *
1098      * - If `to` refers to a smart contract, it must implement
1099      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1100      * - `quantity` must be greater than 0.
1101      *
1102      * Emits a {Transfer} event.
1103      */
1104      /*
1105     function _safeMint(
1106             address to,
1107             uint256 quantity,
1108             bytes memory _data
1109             ) internal {
1110         uint256 startTokenId = _currentIndex;
1111         //if (_addressToUint256(to) == 0) revert MintToZeroAddress();
1112         if (quantity == 0) revert MintZeroQuantity();
1113 
1114 
1115         // Overflows are incredibly unrealistic.
1116         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1117         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1118         unchecked {
1119             // Updates:
1120             // - `balance += quantity`.
1121             // - `numberMinted += quantity`.
1122             //
1123             // We can directly add to the balance and number minted.
1124             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1125 
1126             // Updates:
1127             // - `address` to the owner.
1128             // - `startTimestamp` to the timestamp of minting.
1129             // - `burned` to `false`.
1130             // - `nextInitialized` to `quantity == 1`.
1131             _packedOwnerships[startTokenId] =
1132                 _addressToUint256(to) |
1133                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1134                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1135 
1136             uint256 updatedIndex = startTokenId;
1137             uint256 end = updatedIndex + quantity;
1138 
1139             if (to.code.length != 0) {
1140                 do {
1141                     emit Transfer(address(0), to, updatedIndex);
1142                 } while (updatedIndex < end);
1143                 // Reentrancy protection
1144                 if (_currentIndex != startTokenId) revert();
1145             } else {
1146                 do {
1147                     emit Transfer(address(0), to, updatedIndex++);
1148                 } while (updatedIndex < end);
1149             }
1150             _currentIndex = updatedIndex;
1151         }
1152         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1153     }
1154     */
1155 
1156     /**
1157      * @dev Mints `quantity` tokens and transfers them to `to`.
1158      *
1159      * Requirements:
1160      *
1161      * - `to` cannot be the zero address.
1162      * - `quantity` must be greater than 0.
1163      *
1164      * Emits a {Transfer} event.
1165      */
1166     function _mint(address to, uint256 quantity) internal {
1167         uint256 startTokenId = _currentIndex;
1168         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
1169         if (quantity == 0) revert MintZeroQuantity();
1170 
1171 
1172         // Overflows are incredibly unrealistic.
1173         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1174         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1175         unchecked {
1176             // Updates:
1177             // - `balance += quantity`.
1178             // - `numberMinted += quantity`.
1179             //
1180             // We can directly add to the balance and number minted.
1181             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1182 
1183             // Updates:
1184             // - `address` to the owner.
1185             // - `startTimestamp` to the timestamp of minting.
1186             // - `burned` to `false`.
1187             // - `nextInitialized` to `quantity == 1`.
1188             _packedOwnerships[startTokenId] =
1189                 _addressToUint256(to) |
1190                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1191                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1192 
1193             uint256 updatedIndex = startTokenId;
1194             uint256 end = updatedIndex + quantity;
1195 
1196             do {
1197                 emit Transfer(address(0), to, updatedIndex++);
1198             } while (updatedIndex < end);
1199 
1200             _currentIndex = updatedIndex;
1201         }
1202         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1203     }
1204 
1205     /**
1206      * @dev Transfers `tokenId` from `from` to `to`.
1207      *
1208      * Requirements:
1209      *
1210      * - `to` cannot be the zero address.
1211      * - `tokenId` token must be owned by `from`.
1212      *
1213      * Emits a {Transfer} event.
1214      */
1215     function _transfer(
1216             address from,
1217             address to,
1218             uint256 tokenId
1219             ) private {
1220 
1221         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1222 
1223         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1224 
1225         address approvedAddress = _tokenApprovals[tokenId];
1226 
1227         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1228                 isApprovedForAll(from, _msgSenderERC721A()) ||
1229                 approvedAddress == _msgSenderERC721A());
1230 
1231         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1232 
1233         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
1234 
1235 
1236         // Clear approvals from the previous owner.
1237         if (_addressToUint256(approvedAddress) != 0) {
1238             delete _tokenApprovals[tokenId];
1239         }
1240 
1241         // Underflow of the sender's balance is impossible because we check for
1242         // ownership above and the recipient's balance can't realistically overflow.
1243         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1244         unchecked {
1245             // We can directly increment and decrement the balances.
1246             --_packedAddressData[from]; // Updates: `balance -= 1`.
1247             ++_packedAddressData[to]; // Updates: `balance += 1`.
1248 
1249             // Updates:
1250             // - `address` to the next owner.
1251             // - `startTimestamp` to the timestamp of transfering.
1252             // - `burned` to `false`.
1253             // - `nextInitialized` to `true`.
1254             _packedOwnerships[tokenId] =
1255                 _addressToUint256(to) |
1256                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1257                 BITMASK_NEXT_INITIALIZED;
1258 
1259             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1260             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1261                 uint256 nextTokenId = tokenId + 1;
1262                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1263                 if (_packedOwnerships[nextTokenId] == 0) {
1264                     // If the next slot is within bounds.
1265                     if (nextTokenId != _currentIndex) {
1266                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1267                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1268                     }
1269                 }
1270             }
1271         }
1272 
1273         emit Transfer(from, to, tokenId);
1274         _afterTokenTransfers(from, to, tokenId, 1);
1275     }
1276 
1277 
1278 
1279 
1280     /**
1281      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1282      * minting.
1283      * And also called after one token has been burned.
1284      *
1285      * startTokenId - the first token id to be transferred
1286      * quantity - the amount to be transferred
1287      *
1288      * Calling conditions:
1289      *
1290      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1291      * transferred to `to`.
1292      * - When `from` is zero, `tokenId` has been minted for `to`.
1293      * - When `to` is zero, `tokenId` has been burned by `from`.
1294      * - `from` and `to` are never both zero.
1295      */
1296     function _afterTokenTransfers(
1297             address from,
1298             address to,
1299             uint256 startTokenId,
1300             uint256 quantity
1301             ) internal virtual {}
1302 
1303     /**
1304      * @dev Returns the message sender (defaults to `msg.sender`).
1305      *
1306      * If you are writing GSN compatible contracts, you need to override this function.
1307      */
1308     function _msgSenderERC721A() internal view virtual returns (address) {
1309         return msg.sender;
1310     }
1311 
1312     /**
1313      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1314      */
1315     function _toString(uint256 value) internal pure returns (string memory ptr) {
1316         assembly {
1317             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1318             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1319             // We will need 1 32-byte word to store the length, 
1320             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1321             ptr := add(mload(0x40), 128)
1322 
1323          // Update the free memory pointer to allocate.
1324          mstore(0x40, ptr)
1325 
1326          // Cache the end of the memory to calculate the length later.
1327          let end := ptr
1328 
1329          // We write the string from the rightmost digit to the leftmost digit.
1330          // The following is essentially a do-while loop that also handles the zero case.
1331          // Costs a bit more than early returning for the zero case,
1332          // but cheaper in terms of deployment and overall runtime costs.
1333          for { 
1334              // Initialize and perform the first pass without check.
1335              let temp := value
1336                  // Move the pointer 1 byte leftwards to point to an empty character slot.
1337                  ptr := sub(ptr, 1)
1338                  // Write the character to the pointer. 48 is the ASCII index of '0'.
1339                  mstore8(ptr, add(48, mod(temp, 10)))
1340                  temp := div(temp, 10)
1341          } temp { 
1342              // Keep dividing `temp` until zero.
1343         temp := div(temp, 10)
1344          } { 
1345              // Body of the for loop.
1346         ptr := sub(ptr, 1)
1347          mstore8(ptr, add(48, mod(temp, 10)))
1348          }
1349 
1350      let length := sub(end, ptr)
1351          // Move the pointer 32 bytes leftwards to make room for the length.
1352          ptr := sub(ptr, 32)
1353          // Store the length.
1354          mstore(ptr, length)
1355         }
1356     }
1357 }