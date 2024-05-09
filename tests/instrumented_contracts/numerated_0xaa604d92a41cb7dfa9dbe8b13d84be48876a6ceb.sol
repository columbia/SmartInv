1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.16;
3 
4 
5 /**
6  * @dev Interface of ERC721A.
7  */
8 interface IERC721A {
9     /**
10      * The caller must own the token or be an approved operator.
11      */
12     error ApprovalCallerNotOwnerNorApproved();
13 
14     /**
15      * The token does not exist.
16      */
17     error ApprovalQueryForNonexistentToken();
18 
19     /**
20      * The caller cannot approve to their own address.
21      */
22     error ApproveToCaller();
23 
24     /**
25      * Cannot query the balance for the zero address.
26      */
27     error BalanceQueryForZeroAddress();
28 
29     /**
30      * Cannot mint to the zero address.
31      */
32     error MintToZeroAddress();
33 
34     /**
35      * The quantity of tokens minted must be more than zero.
36      */
37     error MintZeroQuantity();
38 
39     /**
40      * The token does not exist.
41      */
42     error OwnerQueryForNonexistentToken();
43 
44     /**
45      * The caller must own the token or be an approved operator.
46      */
47     error TransferCallerNotOwnerNorApproved();
48 
49     /**
50      * The token must be owned by `from`.
51      */
52     error TransferFromIncorrectOwner();
53 
54     /**
55      * Cannot safely transfer to a contract that does not implement the
56      * ERC721Receiver interface.
57      */
58     error TransferToNonERC721ReceiverImplementer();
59 
60     /**
61      * Cannot transfer to the zero address.
62      */
63     error TransferToZeroAddress();
64 
65     /**
66      * The token does not exist.
67      */
68     error URIQueryForNonexistentToken();
69 
70     /**
71      * The `quantity` minted with ERC2309 exceeds the safety limit.
72      */
73     error MintERC2309QuantityExceedsLimit();
74 
75     /**
76      * The `extraData` cannot be set on an unintialized ownership slot.
77      */
78     error OwnershipNotInitializedForExtraData();
79 
80     // =============================================================
81     //                            STRUCTS
82     // =============================================================
83 
84     struct TokenOwnership {
85         // The address of the owner.
86         address addr;
87         // Stores the start time of ownership with minimal overhead for tokenomics.
88         uint64 startTimestamp;
89         // Whether the token has been burned.
90         bool burned;
91         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
92         uint24 extraData;
93     }
94 
95     // =============================================================
96     //                         TOKEN COUNTERS
97     // =============================================================
98 
99     /**
100      * @dev Returns the total number of tokens in existence.
101      * Burned tokens will reduce the count.
102      * To get the total number of tokens minted, please see {_totalMinted}.
103      */
104     function totalSupply() external view returns (uint256);
105 
106     // =============================================================
107     //                            IERC165
108     // =============================================================
109 
110     /**
111      * @dev Returns true if this contract implements the interface defined by
112      * `interfaceId`. See the corresponding
113      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
114      * to learn more about how these ids are created.
115      *
116      * This function call must use less than 30000 gas.
117      */
118     function supportsInterface(bytes4 interfaceId) external view returns (bool);
119 
120     // =============================================================
121     //                            IERC721
122     // =============================================================
123 
124     /**
125      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
126      */
127     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
128 
129     /**
130      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
131      */
132     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
133 
134     /**
135      * @dev Emitted when `owner` enables or disables
136      * (`approved`) `operator` to manage all of its assets.
137      */
138     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
139 
140     /**
141      * @dev Returns the number of tokens in `owner`'s account.
142      */
143     function balanceOf(address owner) external view returns (uint256 balance);
144 
145     /**
146      * @dev Returns the owner of the `tokenId` token.
147      *
148      * Requirements:
149      *
150      * - `tokenId` must exist.
151      */
152     function ownerOf(uint256 tokenId) external view returns (address owner);
153 
154     /**
155      * @dev Safely transfers `tokenId` token from `from` to `to`,
156      * checking first that contract recipients are aware of the ERC721 protocol
157      * to prevent tokens from being forever locked.
158      *
159      * Requirements:
160      *
161      * - `from` cannot be the zero address.
162      * - `to` cannot be the zero address.
163      * - `tokenId` token must exist and be owned by `from`.
164      * - If the caller is not `from`, it must be have been allowed to move
165      * this token by either {approve} or {setApprovalForAll}.
166      * - If `to` refers to a smart contract, it must implement
167      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
168      *
169      * Emits a {Transfer} event.
170      */
171     function safeTransferFrom(
172         address from,
173         address to,
174         uint256 tokenId,
175         bytes calldata data
176     ) external;
177 
178     /**
179      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
180      */
181     function safeTransferFrom(
182         address from,
183         address to,
184         uint256 tokenId
185     ) external;
186 
187     /**
188      * @dev Transfers `tokenId` from `from` to `to`.
189      *
190      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
191      * whenever possible.
192      *
193      * Requirements:
194      *
195      * - `from` cannot be the zero address.
196      * - `to` cannot be the zero address.
197      * - `tokenId` token must be owned by `from`.
198      * - If the caller is not `from`, it must be approved to move this token
199      * by either {approve} or {setApprovalForAll}.
200      *
201      * Emits a {Transfer} event.
202      */
203     function transferFrom(
204         address from,
205         address to,
206         uint256 tokenId
207     ) external;
208 
209     /**
210      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
211      * The approval is cleared when the token is transferred.
212      *
213      * Only a single account can be approved at a time, so approving the
214      * zero address clears previous approvals.
215      *
216      * Requirements:
217      *
218      * - The caller must own the token or be an approved operator.
219      * - `tokenId` must exist.
220      *
221      * Emits an {Approval} event.
222      */
223     function approve(address to, uint256 tokenId) external;
224 
225     /**
226      * @dev Approve or remove `operator` as an operator for the caller.
227      * Operators can call {transferFrom} or {safeTransferFrom}
228      * for any token owned by the caller.
229      *
230      * Requirements:
231      *
232      * - The `operator` cannot be the caller.
233      *
234      * Emits an {ApprovalForAll} event.
235      */
236     function setApprovalForAll(address operator, bool _approved) external;
237 
238     /**
239      * @dev Returns the account approved for `tokenId` token.
240      *
241      * Requirements:
242      *
243      * - `tokenId` must exist.
244      */
245     function getApproved(uint256 tokenId) external view returns (address operator);
246 
247     /**
248      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
249      *
250      * See {setApprovalForAll}.
251      */
252     function isApprovedForAll(address owner, address operator) external view returns (bool);
253 
254     // =============================================================
255     //                        IERC721Metadata
256     // =============================================================
257 
258     /**
259      * @dev Returns the token collection name.
260      */
261     function name() external view returns (string memory);
262 
263     /**
264      * @dev Returns the token collection symbol.
265      */
266     function symbol() external view returns (string memory);
267 
268     /**
269      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
270      */
271     function tokenURI(uint256 tokenId) external view returns (string memory);
272 
273     // =============================================================
274     //                           IERC2309
275     // =============================================================
276 
277     /**
278      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
279      * (inclusive) is transferred from `from` to `to`, as defined in the
280      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
281      *
282      * See {_mintERC2309} for more details.
283      */
284     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
285 }
286 
287 /**
288  * @dev String operations.
289  */
290 library Strings {
291     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
292 
293     /**
294      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
295      */
296     function toString(uint256 value) internal pure returns (string memory) {
297         // Inspired by OraclizeAPI's implementation - MIT licence
298         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
299 
300         if (value == 0) {
301             return "0";
302         }
303         uint256 temp = value;
304         uint256 digits;
305         while (temp != 0) {
306             digits++;
307             temp /= 10;
308         }
309         bytes memory buffer = new bytes(digits);
310         while (value != 0) {
311             digits -= 1;
312             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
313             value /= 10;
314         }
315         return string(buffer);
316     }
317 
318     /**
319      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
320      */
321     function toHexString(uint256 value) internal pure returns (string memory) {
322         if (value == 0) {
323             return "0x00";
324         }
325         uint256 temp = value;
326         uint256 length = 0;
327         while (temp != 0) {
328             length++;
329             temp >>= 8;
330         }
331         return toHexString(value, length);
332     }
333 
334     /**
335      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
336      */
337     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
338         bytes memory buffer = new bytes(2 * length + 2);
339         buffer[0] = "0";
340         buffer[1] = "x";
341         for (uint256 i = 2 * length + 1; i > 1; --i) {
342             buffer[i] = _HEX_SYMBOLS[value & 0xf];
343             value >>= 4;
344         }
345         require(value == 0, "Strings: hex length insufficient");
346         return string(buffer);
347     }
348 }
349 
350 library Base64 {
351     /**
352      * @dev Base64 Encoding/Decoding Table
353      */
354     string internal constant _TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
355 
356     /**
357      * @dev Converts a `bytes` to its Bytes64 `string` representation.
358      */
359     function encode(bytes memory data) internal pure returns (string memory) {
360         /**
361          * Inspired by Brecht Devos (Brechtpd) implementation - MIT licence
362          * https://github.com/Brechtpd/base64/blob/e78d9fd951e7b0977ddca77d92dc85183770daf4/base64.sol
363          */
364         if (data.length == 0) return "";
365 
366         // Loads the table into memory
367         string memory table = _TABLE;
368 
369         // Encoding takes 3 bytes chunks of binary data from `bytes` data parameter
370         // and split into 4 numbers of 6 bits.
371         // The final Base64 length should be `bytes` data length multiplied by 4/3 rounded up
372         // - `data.length + 2`  -> Round up
373         // - `/ 3`              -> Number of 3-bytes chunks
374         // - `4 *`              -> 4 characters for each chunk
375         string memory result = new string(4 * ((data.length + 2) / 3));
376 
377         /// @solidity memory-safe-assembly
378         assembly {
379             // Prepare the lookup table (skip the first "length" byte)
380             let tablePtr := add(table, 1)
381 
382             // Prepare result pointer, jump over length
383             let resultPtr := add(result, 32)
384 
385             // Run over the input, 3 bytes at a time
386             for {
387                 let dataPtr := data
388                 let endPtr := add(data, mload(data))
389             } lt(dataPtr, endPtr) {
390 
391             } {
392                 // Advance 3 bytes
393                 dataPtr := add(dataPtr, 3)
394                 let input := mload(dataPtr)
395 
396                 // To write each character, shift the 3 bytes (18 bits) chunk
397                 // 4 times in blocks of 6 bits for each character (18, 12, 6, 0)
398                 // and apply logical AND with 0x3F which is the number of
399                 // the previous character in the ASCII table prior to the Base64 Table
400                 // The result is then added to the table to get the character to write,
401                 // and finally write it in the result pointer but with a left shift
402                 // of 256 (1 byte) - 8 (1 ASCII char) = 248 bits
403 
404                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
405                 resultPtr := add(resultPtr, 1) // Advance
406 
407                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
408                 resultPtr := add(resultPtr, 1) // Advance
409 
410                 mstore8(resultPtr, mload(add(tablePtr, and(shr(6, input), 0x3F))))
411                 resultPtr := add(resultPtr, 1) // Advance
412 
413                 mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
414                 resultPtr := add(resultPtr, 1) // Advance
415             }
416 
417             // When data `bytes` is not exactly 3 bytes long
418             // it is padded with `=` characters at the end
419             switch mod(mload(data), 3)
420             case 1 {
421                 mstore8(sub(resultPtr, 1), 0x3d)
422                 mstore8(sub(resultPtr, 2), 0x3d)
423             }
424             case 2 {
425                 mstore8(sub(resultPtr, 1), 0x3d)
426             }
427         }
428 
429         return result;
430     }
431 }
432 
433 library SafeMath {
434     /**
435      * @dev Returns the addition of two unsigned integers, with an overflow flag.
436      *
437      * _Available since v3.4._
438      */
439     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
440         unchecked {
441             uint256 c = a + b;
442             if (c < a) return (false, 0);
443             return (true, c);
444         }
445     }
446 
447     /**
448      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
449      *
450      * _Available since v3.4._
451      */
452     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
453         unchecked {
454             if (b > a) return (false, 0);
455             return (true, a - b);
456         }
457     }
458 
459     /**
460      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
461      *
462      * _Available since v3.4._
463      */
464     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
465         unchecked {
466             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
467             // benefit is lost if 'b' is also tested.
468             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
469             if (a == 0) return (true, 0);
470             uint256 c = a * b;
471             if (c / a != b) return (false, 0);
472             return (true, c);
473         }
474     }
475 
476     /**
477      * @dev Returns the division of two unsigned integers, with a division by zero flag.
478      *
479      * _Available since v3.4._
480      */
481     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
482         unchecked {
483             if (b == 0) return (false, 0);
484             return (true, a / b);
485         }
486     }
487 
488     /**
489      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
490      *
491      * _Available since v3.4._
492      */
493     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
494         unchecked {
495             if (b == 0) return (false, 0);
496             return (true, a % b);
497         }
498     }
499 
500     /**
501      * @dev Returns the addition of two unsigned integers, reverting on
502      * overflow.
503      *
504      * Counterpart to Solidity's `+` operator.
505      *
506      * Requirements:
507      *
508      * - Addition cannot overflow.
509      */
510     function add(uint256 a, uint256 b) internal pure returns (uint256) {
511         return a + b;
512     }
513 
514     /**
515      * @dev Returns the subtraction of two unsigned integers, reverting on
516      * overflow (when the result is negative).
517      *
518      * Counterpart to Solidity's `-` operator.
519      *
520      * Requirements:
521      *
522      * - Subtraction cannot overflow.
523      */
524     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
525         return a - b;
526     }
527 
528     /**
529      * @dev Returns the multiplication of two unsigned integers, reverting on
530      * overflow.
531      *
532      * Counterpart to Solidity's `*` operator.
533      *
534      * Requirements:
535      *
536      * - Multiplication cannot overflow.
537      */
538     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
539         return a * b;
540     }
541 
542     /**
543      * @dev Returns the integer division of two unsigned integers, reverting on
544      * division by zero. The result is rounded towards zero.
545      *
546      * Counterpart to Solidity's `/` operator.
547      *
548      * Requirements:
549      *
550      * - The divisor cannot be zero.
551      */
552     function div(uint256 a, uint256 b) internal pure returns (uint256) {
553         return a / b;
554     }
555 
556     /**
557      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
558      * reverting when dividing by zero.
559      *
560      * Counterpart to Solidity's `%` operator. This function uses a `revert`
561      * opcode (which leaves remaining gas untouched) while Solidity uses an
562      * invalid opcode to revert (consuming all remaining gas).
563      *
564      * Requirements:
565      *
566      * - The divisor cannot be zero.
567      */
568     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
569         return a % b;
570     }
571 
572     /**
573      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
574      * overflow (when the result is negative).
575      *
576      * CAUTION: This function is deprecated because it requires allocating memory for the error
577      * message unnecessarily. For custom revert reasons use {trySub}.
578      *
579      * Counterpart to Solidity's `-` operator.
580      *
581      * Requirements:
582      *
583      * - Subtraction cannot overflow.
584      */
585     function sub(
586         uint256 a,
587         uint256 b,
588         string memory errorMessage
589     ) internal pure returns (uint256) {
590         unchecked {
591             require(b <= a, errorMessage);
592             return a - b;
593         }
594     }
595 
596     /**
597      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
598      * division by zero. The result is rounded towards zero.
599      *
600      * Counterpart to Solidity's `/` operator. Note: this function uses a
601      * `revert` opcode (which leaves remaining gas untouched) while Solidity
602      * uses an invalid opcode to revert (consuming all remaining gas).
603      *
604      * Requirements:
605      *
606      * - The divisor cannot be zero.
607      */
608     function div(
609         uint256 a,
610         uint256 b,
611         string memory errorMessage
612     ) internal pure returns (uint256) {
613         unchecked {
614             require(b > 0, errorMessage);
615             return a / b;
616         }
617     }
618 
619     /**
620      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
621      * reverting with custom message when dividing by zero.
622      *
623      * CAUTION: This function is deprecated because it requires allocating memory for the error
624      * message unnecessarily. For custom revert reasons use {tryMod}.
625      *
626      * Counterpart to Solidity's `%` operator. This function uses a `revert`
627      * opcode (which leaves remaining gas untouched) while Solidity uses an
628      * invalid opcode to revert (consuming all remaining gas).
629      *
630      * Requirements:
631      *
632      * - The divisor cannot be zero.
633      */
634     function mod(
635         uint256 a,
636         uint256 b,
637         string memory errorMessage
638     ) internal pure returns (uint256) {
639         unchecked {
640             require(b > 0, errorMessage);
641             return a % b;
642         }
643     }
644 }
645 
646 
647 
648 
649 contract ProofOfGas is IERC721A { 
650     using SafeMath for uint256;
651 
652     address private _owner;
653     modifier onlyOwner() { 
654         require(_owner==msg.sender, "No!"); 
655         _; 
656     }
657 
658     uint256 public constant MAX_PER_WALLET = 1;
659     uint256 public constant COST = 0 ether;
660     uint256 public constant MAX_SUPPLY = 987;
661 
662     string private constant _name = "ProofOfGas";
663     string private constant _symbol = "PoG";
664     string private constant _contractURI = "QmbVTsDCS78ATXJa5QMJsTQm7hjnrAgrrKP758WikDv4MC";
665     mapping (uint256 => string) public historyOfColor;
666 
667     constructor() {
668         _owner = msg.sender;
669     }
670 
671     function random() internal view returns (string memory) {
672         string memory input = Strings.toHexString(uint256(uint160(msg.sender)), 20);
673         string memory output = substring(input, 2, 8);
674         return output;
675     }
676 
677     uint256 public lastPrime = 1;
678 	function nextPrime() public returns (uint256){
679 		uint runs = 10000;
680         for (uint num = (lastPrime/3 + lastPrime/2); num < runs; num++) {
681 			for( uint j = 2; j * j <= num; j++){
682 				if((num.mod(j)==0))
683 				{
684 					continue;
685 				}
686 				else if(num>lastPrime){ 
687 					lastPrime = num;
688 					return num;
689 				}
690 			}
691 		}
692 	}
693 
694     function mint() external{
695         address _caller = _msgSenderERC721A();
696         uint256 amount = 1;
697 
698         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
699         require(amount + _numberMinted(msg.sender) <= MAX_PER_WALLET, "AccLimit");
700         historyOfColor[_currentIndex] = random();
701         nextPrime();
702 
703         _mint(_caller, amount);
704     }
705 
706     function substring(string memory str, uint startIndex, uint endIndex) internal view returns (string memory) { 
707         bytes memory strBytes = bytes(str); 
708         bytes memory result = new bytes(endIndex-startIndex); 
709         for(uint i = startIndex; i < endIndex; i++) 
710         {
711             result[i-startIndex] = strBytes[i]; 
712         } 
713         return string(result); 
714     }
715 
716 
717     // Mask of an entry in packed address data.
718     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
719 
720     // The bit position of `numberMinted` in packed address data.
721     uint256 private constant BITPOS_NUMBER_MINTED = 64;
722 
723     // The bit position of `numberBurned` in packed address data.
724     uint256 private constant BITPOS_NUMBER_BURNED = 128;
725 
726     // The bit position of `aux` in packed address data.
727     uint256 private constant BITPOS_AUX = 192;
728 
729     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
730     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
731 
732     // The bit position of `startTimestamp` in packed ownership.
733     uint256 private constant BITPOS_START_TIMESTAMP = 160;
734 
735     // The bit mask of the `burned` bit in packed ownership.
736     uint256 private constant BITMASK_BURNED = 1 << 224;
737 
738     // The bit position of the `nextInitialized` bit in packed ownership.
739     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
740 
741     // The bit mask of the `nextInitialized` bit in packed ownership.
742     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
743 
744     // The tokenId of the next token to be minted.
745     uint256 private _currentIndex = 0;
746 
747     // The number of tokens burned.
748     // uint256 private _burnCounter;
749 
750 
751     // Mapping from token ID to ownership details
752     // An empty struct value does not necessarily mean the token is unowned.
753     // See `_packedOwnershipOf` implementation for details.
754     //
755     // Bits Layout:
756     // - [0..159] `addr`
757     // - [160..223] `startTimestamp`
758     // - [224] `burned`
759     // - [225] `nextInitialized`
760     mapping(uint256 => uint256) private _packedOwnerships;
761 
762     // Mapping owner address to address data.
763     //
764     // Bits Layout:
765     // - [0..63] `balance`
766     // - [64..127] `numberMinted`
767     // - [128..191] `numberBurned`
768     // - [192..255] `aux`
769     mapping(address => uint256) private _packedAddressData;
770 
771     // Mapping from token ID to approved address.
772     mapping(uint256 => address) private _tokenApprovals;
773 
774     // Mapping from owner to operator approvals
775     mapping(address => mapping(address => bool)) private _operatorApprovals;
776 
777    
778 
779     /**
780      * @dev Returns the starting token ID. 
781      * To change the starting token ID, please override this function.
782      */
783     function _startTokenId() internal view virtual returns (uint256) {
784         return 0;
785     }
786 
787     /**
788      * @dev Returns the next token ID to be minted.
789      */
790     function _nextTokenId() internal view returns (uint256) {
791         return _currentIndex;
792     }
793 
794     /**
795      * @dev Returns the total number of tokens in existence.
796      * Burned tokens will reduce the count. 
797      * To get the total number of tokens minted, please see `_totalMinted`.
798      */
799     function totalSupply() public view override returns (uint256) {
800         // Counter underflow is impossible as _burnCounter cannot be incremented
801         // more than `_currentIndex - _startTokenId()` times.
802         unchecked {
803             return _currentIndex - _startTokenId();
804         }
805     }
806 
807     /**
808      * @dev Returns the total amount of tokens minted in the contract.
809      */
810     function _totalMinted() internal view returns (uint256) {
811         // Counter underflow is impossible as _currentIndex does not decrement,
812         // and it is initialized to `_startTokenId()`
813         unchecked {
814             return _currentIndex - _startTokenId();
815         }
816     }
817 
818 
819     /**
820      * @dev See {IERC165-supportsInterface}.
821      */
822     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
823         // The interface IDs are constants representing the first 4 bytes of the XOR of
824         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
825         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
826         return
827             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
828             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
829             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
830     }
831 
832     /**
833      * @dev See {IERC721-balanceOf}.
834      */
835     function balanceOf(address owner) public view override returns (uint256) {
836         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
837         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
838     }
839 
840     /**
841      * Returns the number of tokens minted by `owner`.
842      */
843     function _numberMinted(address owner) internal view returns (uint256) {
844         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
845     }
846 
847 
848 
849     /**
850      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
851      */
852     function _getAux(address owner) internal view returns (uint64) {
853         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
854     }
855 
856     /**
857      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
858      * If there are multiple variables, please pack them into a uint64.
859      */
860     function _setAux(address owner, uint64 aux) internal {
861         uint256 packed = _packedAddressData[owner];
862         uint256 auxCasted;
863         assembly { // Cast aux without masking.
864             auxCasted := aux
865         }
866         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
867         _packedAddressData[owner] = packed;
868     }
869 
870     /**
871      * Returns the packed ownership data of `tokenId`.
872      */
873     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
874         uint256 curr = tokenId;
875 
876         unchecked {
877             if (_startTokenId() <= curr)
878                 if (curr < _currentIndex) {
879                     uint256 packed = _packedOwnerships[curr];
880                     // If not burned.
881                     if (packed & BITMASK_BURNED == 0) {
882                         // Invariant:
883                         // There will always be an ownership that has an address and is not burned
884                         // before an ownership that does not have an address and is not burned.
885                         // Hence, curr will not underflow.
886                         //
887                         // We can directly compare the packed value.
888                         // If the address is zero, packed is zero.
889                         while (packed == 0) {
890                             packed = _packedOwnerships[--curr];
891                         }
892                         return packed;
893                     }
894                 }
895         }
896         revert OwnerQueryForNonexistentToken();
897     }
898 
899     /**
900      * Returns the unpacked `TokenOwnership` struct from `packed`.
901      */
902     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
903         ownership.addr = address(uint160(packed));
904         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
905         ownership.burned = packed & BITMASK_BURNED != 0;
906     }
907 
908     /**
909      * Returns the unpacked `TokenOwnership` struct at `index`.
910      */
911     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
912         return _unpackedOwnership(_packedOwnerships[index]);
913     }
914 
915     /**
916      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
917      */
918     function _initializeOwnershipAt(uint256 index) internal {
919         if (_packedOwnerships[index] == 0) {
920             _packedOwnerships[index] = _packedOwnershipOf(index);
921         }
922     }
923 
924     /**
925      * Gas spent here starts off proportional to the maximum mint batch size.
926      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
927      */
928     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
929         return _unpackedOwnership(_packedOwnershipOf(tokenId));
930     }
931 
932     /**
933      * @dev See {IERC721-ownerOf}.
934      */
935     function ownerOf(uint256 tokenId) public view override returns (address) {
936         return address(uint160(_packedOwnershipOf(tokenId)));
937     }
938 
939     /**
940      * @dev See {IERC721Metadata-name}.
941      */
942     function name() public view virtual override returns (string memory) {
943         return _name;
944     }
945 
946     /**
947      * @dev See {IERC721Metadata-symbol}.
948      */
949     function symbol() public view virtual override returns (string memory) {
950         return _symbol;
951     }
952 
953     function render(uint256 _tokenId) internal view returns (string memory) {
954         string memory body = historyOfColor[_tokenId];
955         return string.concat(
956             '<svg height="200" width="200" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="-100 -100 200 200">',
957             '<defs><radialGradient id="glow" cx="0.25" cy="0.25" r="0.35"><stop offset="0%" stop-color="#e3a8b0" /><stop offset="100%" stop-color="#',body,'" /></radialGradient></defs>',
958             '<rect xmlns="http://www.w3.org/2000/svg" width="100%" height="100%" fill="white" />',
959             '<circle cx="0" cy="20" r="70" fill="url(#glow)" />',
960             '</svg>'
961         );
962     }
963 
964     function tokenURI(uint256 _tokenId)
965         public
966         view
967         override
968         returns (string memory)
969     {
970         require(_exists(_tokenId), "token does not exists");
971 
972         string memory svg = string(abi.encodePacked(render(_tokenId)));
973         string memory json = Base64.encode(
974             abi.encodePacked(
975                 '{"name": "PoG #', Strings.toString(_tokenId),
976                 '", "description": "Proof of Gas on Chain", "image": "data:image/svg+xml;base64,',
977                 Base64.encode(bytes(svg)),
978                 '"}'
979             )
980         );
981 
982         return string(abi.encodePacked("data:application/json;base64,", json));
983     }
984 
985 
986 
987     function contractURI() public view returns (string memory) {
988         return string(abi.encodePacked("ipfs://", _contractURI));
989     }
990 
991     /**
992      * @dev Casts the address to uint256 without masking.
993      */
994     function _addressToUint256(address value) private pure returns (uint256 result) {
995         assembly {
996             result := value
997         }
998     }
999 
1000     /**
1001      * @dev Casts the boolean to uint256 without branching.
1002      */
1003     function _boolToUint256(bool value) private pure returns (uint256 result) {
1004         assembly {
1005             result := value
1006         }
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-approve}.
1011      */
1012     function approve(address to, uint256 tokenId) public override {
1013         address owner = address(uint160(_packedOwnershipOf(tokenId)));
1014         if (to == owner) revert();
1015 
1016         if (_msgSenderERC721A() != owner)
1017             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1018                 revert ApprovalCallerNotOwnerNorApproved();
1019             }
1020 
1021         _tokenApprovals[tokenId] = to;
1022         emit Approval(owner, to, tokenId);
1023     }
1024 
1025     /**
1026      * @dev See {IERC721-getApproved}.
1027      */
1028     function getApproved(uint256 tokenId) public view override returns (address) {
1029         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1030 
1031         return _tokenApprovals[tokenId];
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-setApprovalForAll}.
1036      */
1037     function setApprovalForAll(address operator, bool approved) public virtual override {
1038         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1039 
1040         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1041         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1042     }
1043 
1044     /**
1045      * @dev See {IERC721-isApprovedForAll}.
1046      */
1047     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1048         return _operatorApprovals[owner][operator];
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-transferFrom}.
1053      */
1054     function transferFrom(
1055             address from,
1056             address to,
1057             uint256 tokenId
1058             ) public virtual override {
1059         _transfer(from, to, tokenId);
1060     }
1061 
1062     /**
1063      * @dev See {IERC721-safeTransferFrom}.
1064      */
1065     function safeTransferFrom(
1066             address from,
1067             address to,
1068             uint256 tokenId
1069             ) public virtual override {
1070         safeTransferFrom(from, to, tokenId, '');
1071     }
1072 
1073     /**
1074      * @dev See {IERC721-safeTransferFrom}.
1075      */
1076     function safeTransferFrom(
1077             address from,
1078             address to,
1079             uint256 tokenId,
1080             bytes memory _data
1081             ) public virtual override {
1082         _transfer(from, to, tokenId);
1083     }
1084 
1085     /**
1086      * @dev Returns whether `tokenId` exists.
1087      *
1088      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1089      *
1090      * Tokens start existing when they are minted (`_mint`),
1091      */
1092     function _exists(uint256 tokenId) internal view returns (bool) {
1093         return
1094             _startTokenId() <= tokenId &&
1095             tokenId < _currentIndex;
1096     }
1097 
1098     /**
1099      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1100      */
1101      /*
1102     function _safeMint(address to, uint256 quantity) internal {
1103         _safeMint(to, quantity, '');
1104     }
1105     */
1106 
1107     /**
1108      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1109      *
1110      * Requirements:
1111      *
1112      * - If `to` refers to a smart contract, it must implement
1113      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1114      * - `quantity` must be greater than 0.
1115      *
1116      * Emits a {Transfer} event.
1117      */
1118      /*
1119     function _safeMint(
1120             address to,
1121             uint256 quantity,
1122             bytes memory _data
1123             ) internal {
1124         uint256 startTokenId = _currentIndex;
1125         //if (_addressToUint256(to) == 0) revert MintToZeroAddress();
1126         if (quantity == 0) revert MintZeroQuantity();
1127 
1128 
1129         // Overflows are incredibly unrealistic.
1130         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1131         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1132         unchecked {
1133             // Updates:
1134             // - `balance += quantity`.
1135             // - `numberMinted += quantity`.
1136             //
1137             // We can directly add to the balance and number minted.
1138             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1139 
1140             // Updates:
1141             // - `address` to the owner.
1142             // - `startTimestamp` to the timestamp of minting.
1143             // - `burned` to `false`.
1144             // - `nextInitialized` to `quantity == 1`.
1145             _packedOwnerships[startTokenId] =
1146                 _addressToUint256(to) |
1147                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1148                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1149 
1150             uint256 updatedIndex = startTokenId;
1151             uint256 end = updatedIndex + quantity;
1152 
1153             if (to.code.length != 0) {
1154                 do {
1155                     emit Transfer(address(0), to, updatedIndex);
1156                 } while (updatedIndex < end);
1157                 // Reentrancy protection
1158                 if (_currentIndex != startTokenId) revert();
1159             } else {
1160                 do {
1161                     emit Transfer(address(0), to, updatedIndex++);
1162                 } while (updatedIndex < end);
1163             }
1164             _currentIndex = updatedIndex;
1165         }
1166         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1167     }
1168     */
1169 
1170     /**
1171      * @dev Mints `quantity` tokens and transfers them to `to`.
1172      *
1173      * Requirements:
1174      *
1175      * - `to` cannot be the zero address.
1176      * - `quantity` must be greater than 0.
1177      *
1178      * Emits a {Transfer} event.
1179      */
1180     function _mint(address to, uint256 quantity) internal {
1181         uint256 startTokenId = _currentIndex;
1182         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
1183         if (quantity == 0) revert MintZeroQuantity();
1184 
1185 
1186         // Overflows are incredibly unrealistic.
1187         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1188         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1189         unchecked {
1190             // Updates:
1191             // - `balance += quantity`.
1192             // - `numberMinted += quantity`.
1193             //
1194             // We can directly add to the balance and number minted.
1195             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1196 
1197             // Updates:
1198             // - `address` to the owner.
1199             // - `startTimestamp` to the timestamp of minting.
1200             // - `burned` to `false`.
1201             // - `nextInitialized` to `quantity == 1`.
1202             _packedOwnerships[startTokenId] =
1203                 _addressToUint256(to) |
1204                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1205                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1206 
1207             uint256 updatedIndex = startTokenId;
1208             uint256 end = updatedIndex + quantity;
1209 
1210             do {
1211                 emit Transfer(address(0), to, updatedIndex++);
1212             } while (updatedIndex < end);
1213 
1214             _currentIndex = updatedIndex;
1215         }
1216         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1217     }
1218 
1219     /**
1220      * @dev Transfers `tokenId` from `from` to `to`.
1221      *
1222      * Requirements:
1223      *
1224      * - `to` cannot be the zero address.
1225      * - `tokenId` token must be owned by `from`.
1226      *
1227      * Emits a {Transfer} event.
1228      */
1229     function _transfer(
1230             address from,
1231             address to,
1232             uint256 tokenId
1233             ) private {
1234 
1235         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1236 
1237         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1238 
1239         address approvedAddress = _tokenApprovals[tokenId];
1240 
1241         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1242                 isApprovedForAll(from, _msgSenderERC721A()) ||
1243                 approvedAddress == _msgSenderERC721A());
1244 
1245         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1246 
1247         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
1248 
1249 
1250         // Clear approvals from the previous owner.
1251         if (_addressToUint256(approvedAddress) != 0) {
1252             delete _tokenApprovals[tokenId];
1253         }
1254 
1255         // Underflow of the sender's balance is impossible because we check for
1256         // ownership above and the recipient's balance can't realistically overflow.
1257         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1258         unchecked {
1259             // We can directly increment and decrement the balances.
1260             --_packedAddressData[from]; // Updates: `balance -= 1`.
1261             ++_packedAddressData[to]; // Updates: `balance += 1`.
1262 
1263             // Updates:
1264             // - `address` to the next owner.
1265             // - `startTimestamp` to the timestamp of transfering.
1266             // - `burned` to `false`.
1267             // - `nextInitialized` to `true`.
1268             _packedOwnerships[tokenId] =
1269                 _addressToUint256(to) |
1270                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1271                 BITMASK_NEXT_INITIALIZED;
1272 
1273             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1274             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1275                 uint256 nextTokenId = tokenId + 1;
1276                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1277                 if (_packedOwnerships[nextTokenId] == 0) {
1278                     // If the next slot is within bounds.
1279                     if (nextTokenId != _currentIndex) {
1280                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1281                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1282                     }
1283                 }
1284             }
1285         }
1286 
1287         emit Transfer(from, to, tokenId);
1288         _afterTokenTransfers(from, to, tokenId, 1);
1289     }
1290 
1291 
1292 
1293 
1294     /**
1295      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1296      * minting.
1297      * And also called after one token has been burned.
1298      *
1299      * startTokenId - the first token id to be transferred
1300      * quantity - the amount to be transferred
1301      *
1302      * Calling conditions:
1303      *
1304      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1305      * transferred to `to`.
1306      * - When `from` is zero, `tokenId` has been minted for `to`.
1307      * - When `to` is zero, `tokenId` has been burned by `from`.
1308      * - `from` and `to` are never both zero.
1309      */
1310     function _afterTokenTransfers(
1311             address from,
1312             address to,
1313             uint256 startTokenId,
1314             uint256 quantity
1315             ) internal virtual {}
1316 
1317     /**
1318      * @dev Returns the message sender (defaults to `msg.sender`).
1319      *
1320      * If you are writing GSN compatible contracts, you need to override this function.
1321      */
1322     function _msgSenderERC721A() internal view virtual returns (address) {
1323         return msg.sender;
1324     }
1325 
1326     /**
1327      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1328      */
1329     function _toString(uint256 value) internal pure returns (string memory ptr) {
1330         assembly {
1331             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1332             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1333             // We will need 1 32-byte word to store the length, 
1334             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1335             ptr := add(mload(0x40), 128)
1336 
1337          // Update the free memory pointer to allocate.
1338          mstore(0x40, ptr)
1339 
1340          // Cache the end of the memory to calculate the length later.
1341          let end := ptr
1342 
1343          // We write the string from the rightmost digit to the leftmost digit.
1344          // The following is essentially a do-while loop that also handles the zero case.
1345          // Costs a bit more than early returning for the zero case,
1346          // but cheaper in terms of deployment and overall runtime costs.
1347          for { 
1348              // Initialize and perform the first pass without check.
1349              let temp := value
1350                  // Move the pointer 1 byte leftwards to point to an empty character slot.
1351                  ptr := sub(ptr, 1)
1352                  // Write the character to the pointer. 48 is the ASCII index of '0'.
1353                  mstore8(ptr, add(48, mod(temp, 10)))
1354                  temp := div(temp, 10)
1355          } temp { 
1356              // Keep dividing `temp` until zero.
1357         temp := div(temp, 10)
1358          } { 
1359              // Body of the for loop.
1360         ptr := sub(ptr, 1)
1361          mstore8(ptr, add(48, mod(temp, 10)))
1362          }
1363 
1364      let length := sub(end, ptr)
1365          // Move the pointer 32 bytes leftwards to make room for the length.
1366          ptr := sub(ptr, 32)
1367          // Store the length.
1368          mstore(ptr, length)
1369         }
1370     }
1371 }