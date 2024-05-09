1 // Sources flattened with hardhat v2.12.4 https://hardhat.org
2 
3 /*
4 ==========---------------:::::::::::::::::::...:::.-...:::::............. .         .                          ...
5 ==========--------------::::::::::::::::::..:::*=:=#--*+:..-=..:-.:=:.--.=-:. :+:..=+  :  :.                 .....
6 =========--------------:::::::::::::::..:::+*=##+#%**%#**+#+--+*=*#=+***#+**+***=+**--+-.=*+. .-=: .   ..  .......
7 ========--------------:::::::::::::..:=*#+*%#%%#%%%%%%*#%%#####*#%##%##################*##*#**##+.-++++:  ..-.....
8 =======--------------::::::::::::::=*#####%%%%%%%%%%%%%%%%%%%%%%%#%%%#%%%%%####%%#%%###%####%%%#+####*--+*#=.. .-=
9 ======--------------:::::::::::.:+###%%%%%%%%%%%%%%%%%#%%%%%%%%%%##%%%%###%%%%%%%%%###%%%#%%%#########%%%#=.-+*###
10 =====------------::::::::::::::=*#%%#%%%%%%%%%%%%%%%%%%##%%%%%%%%%%%%##%%%%%#%%%%%%%%%%%%%%%#%%%%#%%#######*%%%#%#
11 =====-------------:::::::.-++*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%##%%%%%%#%%%%%#%%%%%%%#%%#######
12 =====-------------::::-:-*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%##%%%%%%
13 =====------------::::++-+*###%%%%#%%#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%####%
14 ====------------:::::+*+#%@@%%%%%%#*%*%%%%%%%%%%%%%%%%%%%%%%##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#%%%
15 ===--------------:::::=#%*-=*#*%**+*%%%%%%%%*%-%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
16 ==---------------::::::=::=++#++#%%%%%%+*++=:=.=**==%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%##*****#####*###%
17 ===---------------:::::::::*%%%%%%****-..-.... ..: ::%#+%%%%%%%%%%%%%%%%%%%%%#%%%%%%%%%%%%%%%%%%%%*=-...:- =.:====
18 ==----------------::::::::::=++=-=-..-........      .-: .-#%%%%%%%%%%%%%%##%%%%%%%%%%%%%%%%%%%%%%%%#-==.          
19 ==----------------:::::::::::::................     .     :+%%%%%%%%%%%%%##%%%#%%%%%%%%%%%%%%%%%%%%%%%=---.       
20 ==----------------::::::::::::::................            -*%%%%%%%%%%###%%%%%%%%%%%%%%%%%%%%%%%%%%%%####+:     
21 ==-----------------::::::::::::::.................           .+%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#%%%%%%%%%%%%#**+==: 
22 ==-----------------::::::::::::::::.................          .-*%%%%%%%%%%%%%%%%%%%%%%%%%%%%##%%%%%%%%%%%%%%####=
23 -------------------::::::::::::::::::................            =#%%%%%%%%%%%%%%%%%%%%%%%%%%%#%%%%%%%%%%%%%%%##*=
24 -------------------::::::::::::::::::.................            -##%%%%%%%%%%%%%%%%%%%%%%%%%%%##%%%%%%%%%%%%%###
25 -------------------::::::::::::::::::::................           =#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#
26 -------------------:::::::::::::::::::::.................         :#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#%%%%%#
27 --------------------:-:::::::::::::::::::................          =%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
28 -----------------------:::::::::::::::::::..................        -#%%%%%%%%%#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
29 -------------------------::::::::::::::::::.....................     .+%%%%%%%%##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
30 ------------------------:::::::::::::::::::::.......................  .+%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
31 --------------------::::::::::::::::::::::::::..........................+#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
32 --------------------::::::::::::::::::::::::::::....................:::=*#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
33 --------------------:::::--::::::::::::::::::::::::........::-==++*###%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%##
34 -----------------------------::::::::::::::::::::::::.::=+*####%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#%%%%%%%%%%%%%%%%#
35 --------------------------------:::::::::::::::::::::=+**#%%##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#%%%%%%%%%%%%%%##%
36 --------------------------------:::::::::::::::::::=**#*#%%%#%%%%%%%%%%%%%%%%%%%%%%%%*:::#%%%%%%%%%%%%%%%%%%%%%%#%
37 -----------------------------------:::::::::::::::+#*###%%%%%%%%%%%%%%%%%%%#****+----.. .*%%%%%%%%%%%%%%%%%%%%%%#%
38 -------------------------------------::::::::::=+*%%+%##%%%%%#:::-:::--:...:............:*%%%%%%%%%%%%%%%%%%%%%###
39 ----------------------------------------::::::-#*@#=%%**%%*%#-...........................=%%%%%%%#%%%%%%%%%%%%#%%%
40 ------------------------------------------::::+%#@-=#%-*@%=%:.::::.......................:#%#%%%%%%#%%%%%%%%%%##%%
41 --------------------------------------------::=@*%--+%:-#%%%#:::::::......................:+#%%%%%%%##%%%%%%%%%###
42 ---------------------------------------------::*-++-+--::=*#%+:::::::::::::.................:+#%%%%%%#%%%%%%%%%###
43 ----------------------------------------:-----:-=:-::-:::::::::::::::::::::::::::::...........:-+=+#%%%%%%%%%%####
44 ----------------------::::------------:::::::::-=====+--::::::-::::::::::::::::::::::::-::::-:--===+#######%%%####
45 -----------:--------:::::::::---:---:---:::---++#***###*==-==+******+++++++===++****##*#****######################
46 ---------::::---::----=-:-==++++=*#*****++*##**###########*########**********#*###################################
47 :::::::---:::-==-=+*******##############################################***######*################################
48 -:-===+**#****###################################%######################################################%#########
49 +=*###########################################%%%%################################################################
50 ##################################################################################################################
51 ################%##########%%%####################%###############################################################
52 #%%%%%#%%###############%%#################################%%#############################%##%###%####%%%%%%%%%%%%
53 %%%%%#%%%######%###########################################%%%###################%%######%%%%#%#%%%%%%%%%%%%%%%%%%
54 .s####s.                                                                                                          
55 #########s. #####       .s####s.    .s### ##### .s####s.    #########s. ##### #####       #####       .s####s.    
56 # ### ##### # ###       # #######s. # ### ##### # #######s. ###### ###' # ### # ###       # ###       # #######s. 
57 #  ## ##### #  ##       #  ## ##### #  ## ##### #  ## #####     #  ##   #  ## #  ##       #  ##       #  ## ##### 
58 #..##s##### #..##       #..## ##### #..##s##### #..##s#####    #..##    #..## #..##       #..##       #..##s##### 
59 #:::# ##### #:::#       #:::#s##### #:::# ##### #:::# #####   #:::#     #:::# #:::#       #:::#       #:::# ##### 
60 #;;;# ##### #;;;#       #;;;#       #;;;# ##### #;;;# #####  #;;;#      #;;;# #;;;#       #;;;#       #;;;# ##### 
61 #%%%# ##### #%%%# ##### #%%%#       #%%%# ##### #%%%# ##### #%%%####### #%%%# #%%%# ##### #%%%# ##### #%%%# ##### 
62 ##### ##### #####s##;:' #####       ##### ##### ##### ##### ########### ##### #####s##;:' #####s##;:' ##### ##### 
63 ###%####%#############%######%##%####%%################################################%%%###%%%%%%%%%%%%%%%%%%%%%
64 %#%%%%##%%%%%%########%%%###########%%%%%#################################%%%####%######%%%%%#%%###%%%#%%%%%%%%%%%
65 %%%%%%##%%%##########################%%%%%%%#####################################%#%#%%#%%%%%%%######%##########%%
66 %%%#%%%%%%%#################%######%%%#######%########################%%#############%###%%%%################%%%%#
67 %%%%%%%%%%%%#%######%#########%%%%%%%#########################%%%####%%%#########%###%######################%%%%##
68 %#%%%############################%%%##%########################%%%%%%%%%%%%%##%%%%%%%####%###################%%%##
69 ##%%%#############%%%%%%%##%####################%%#####%%%%#%%%%%%%%#%%%%%%%%%%%%%%%%######%#################%#%%%
70                                                                                                                   
71 
72 */
73 // File contracts/library/AddressString.sol
74 
75 // SPDX-License-Identifier: GPL-3.0-or-later
76 
77 pragma solidity >=0.5.0;
78 
79 library AddressString {
80     // converts an address to the uppercase hex string, extracting only len bytes (up to 20, multiple of 2)
81     function toAsciiString(address addr) internal pure returns (string memory) {
82         bytes memory s = new bytes(42);
83         uint160 addrNum = uint160(addr);
84         s[0] = '0';
85         s[1] = 'X';
86         for (uint256 i = 0; i < 40 / 2; i++) {
87             // shift right and truncate all but the least significant byte to extract the byte at position 19-i
88             uint8 b = uint8(addrNum >> (8 * (19 - i)));
89             // first hex character is the most significant 4 bits
90             uint8 hi = b >> 4;
91             // second hex character is the least significant 4 bits
92             uint8 lo = b - (hi << 4);
93             s[2 * i + 2] = char(hi);
94             s[2 * i + 3] = char(lo);
95         }
96         return string(s);
97     }
98 
99     // hi and lo are only 4 bits and between 0 and 16
100     // this method converts those values to the unicode/ascii code point for the hex representation
101     // uses upper case for the characters
102     function char(uint8 b) private pure returns (bytes1 c) {
103         if (b < 10) {
104             return bytes1(b + 0x30);
105         } else {
106             return bytes1(b + 0x37);
107         }
108     }
109 }
110 
111 
112 // File erc721a/contracts/IERC721A.sol@v4.2.3
113 
114 // ERC721A Contracts v4.2.3
115 // Creator: Chiru Labs
116 
117 pragma solidity ^0.8.4;
118 
119 /**
120  * @dev Interface of ERC721A.
121  */
122 interface IERC721A {
123     /**
124      * The caller must own the token or be an approved operator.
125      */
126     error ApprovalCallerNotOwnerNorApproved();
127 
128     /**
129      * The token does not exist.
130      */
131     error ApprovalQueryForNonexistentToken();
132 
133     /**
134      * Cannot query the balance for the zero address.
135      */
136     error BalanceQueryForZeroAddress();
137 
138     /**
139      * Cannot mint to the zero address.
140      */
141     error MintToZeroAddress();
142 
143     /**
144      * The quantity of tokens minted must be more than zero.
145      */
146     error MintZeroQuantity();
147 
148     /**
149      * The token does not exist.
150      */
151     error OwnerQueryForNonexistentToken();
152 
153     /**
154      * The caller must own the token or be an approved operator.
155      */
156     error TransferCallerNotOwnerNorApproved();
157 
158     /**
159      * The token must be owned by `from`.
160      */
161     error TransferFromIncorrectOwner();
162 
163     /**
164      * Cannot safely transfer to a contract that does not implement the
165      * ERC721Receiver interface.
166      */
167     error TransferToNonERC721ReceiverImplementer();
168 
169     /**
170      * Cannot transfer to the zero address.
171      */
172     error TransferToZeroAddress();
173 
174     /**
175      * The token does not exist.
176      */
177     error URIQueryForNonexistentToken();
178 
179     /**
180      * The `quantity` minted with ERC2309 exceeds the safety limit.
181      */
182     error MintERC2309QuantityExceedsLimit();
183 
184     /**
185      * The `extraData` cannot be set on an unintialized ownership slot.
186      */
187     error OwnershipNotInitializedForExtraData();
188 
189     // =============================================================
190     //                            STRUCTS
191     // =============================================================
192 
193     struct TokenOwnership {
194         // The address of the owner.
195         address addr;
196         // Stores the start time of ownership with minimal overhead for tokenomics.
197         uint64 startTimestamp;
198         // Whether the token has been burned.
199         bool burned;
200         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
201         uint24 extraData;
202     }
203 
204     // =============================================================
205     //                         TOKEN COUNTERS
206     // =============================================================
207 
208     /**
209      * @dev Returns the total number of tokens in existence.
210      * Burned tokens will reduce the count.
211      * To get the total number of tokens minted, please see {_totalMinted}.
212      */
213     function totalSupply() external view returns (uint256);
214 
215     // =============================================================
216     //                            IERC165
217     // =============================================================
218 
219     /**
220      * @dev Returns true if this contract implements the interface defined by
221      * `interfaceId`. See the corresponding
222      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
223      * to learn more about how these ids are created.
224      *
225      * This function call must use less than 30000 gas.
226      */
227     function supportsInterface(bytes4 interfaceId) external view returns (bool);
228 
229     // =============================================================
230     //                            IERC721
231     // =============================================================
232 
233     /**
234      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
235      */
236     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
237 
238     /**
239      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
240      */
241     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
242 
243     /**
244      * @dev Emitted when `owner` enables or disables
245      * (`approved`) `operator` to manage all of its assets.
246      */
247     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
248 
249     /**
250      * @dev Returns the number of tokens in `owner`'s account.
251      */
252     function balanceOf(address owner) external view returns (uint256 balance);
253 
254     /**
255      * @dev Returns the owner of the `tokenId` token.
256      *
257      * Requirements:
258      *
259      * - `tokenId` must exist.
260      */
261     function ownerOf(uint256 tokenId) external view returns (address owner);
262 
263     /**
264      * @dev Safely transfers `tokenId` token from `from` to `to`,
265      * checking first that contract recipients are aware of the ERC721 protocol
266      * to prevent tokens from being forever locked.
267      *
268      * Requirements:
269      *
270      * - `from` cannot be the zero address.
271      * - `to` cannot be the zero address.
272      * - `tokenId` token must exist and be owned by `from`.
273      * - If the caller is not `from`, it must be have been allowed to move
274      * this token by either {approve} or {setApprovalForAll}.
275      * - If `to` refers to a smart contract, it must implement
276      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
277      *
278      * Emits a {Transfer} event.
279      */
280     function safeTransferFrom(
281         address from,
282         address to,
283         uint256 tokenId,
284         bytes calldata data
285     ) external payable;
286 
287     /**
288      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
289      */
290     function safeTransferFrom(
291         address from,
292         address to,
293         uint256 tokenId
294     ) external payable;
295 
296     /**
297      * @dev Transfers `tokenId` from `from` to `to`.
298      *
299      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
300      * whenever possible.
301      *
302      * Requirements:
303      *
304      * - `from` cannot be the zero address.
305      * - `to` cannot be the zero address.
306      * - `tokenId` token must be owned by `from`.
307      * - If the caller is not `from`, it must be approved to move this token
308      * by either {approve} or {setApprovalForAll}.
309      *
310      * Emits a {Transfer} event.
311      */
312     function transferFrom(
313         address from,
314         address to,
315         uint256 tokenId
316     ) external payable;
317 
318     /**
319      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
320      * The approval is cleared when the token is transferred.
321      *
322      * Only a single account can be approved at a time, so approving the
323      * zero address clears previous approvals.
324      *
325      * Requirements:
326      *
327      * - The caller must own the token or be an approved operator.
328      * - `tokenId` must exist.
329      *
330      * Emits an {Approval} event.
331      */
332     function approve(address to, uint256 tokenId) external payable;
333 
334     /**
335      * @dev Approve or remove `operator` as an operator for the caller.
336      * Operators can call {transferFrom} or {safeTransferFrom}
337      * for any token owned by the caller.
338      *
339      * Requirements:
340      *
341      * - The `operator` cannot be the caller.
342      *
343      * Emits an {ApprovalForAll} event.
344      */
345     function setApprovalForAll(address operator, bool _approved) external;
346 
347     /**
348      * @dev Returns the account approved for `tokenId` token.
349      *
350      * Requirements:
351      *
352      * - `tokenId` must exist.
353      */
354     function getApproved(uint256 tokenId) external view returns (address operator);
355 
356     /**
357      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
358      *
359      * See {setApprovalForAll}.
360      */
361     function isApprovedForAll(address owner, address operator) external view returns (bool);
362 
363     // =============================================================
364     //                        IERC721Metadata
365     // =============================================================
366 
367     /**
368      * @dev Returns the token collection name.
369      */
370     function name() external view returns (string memory);
371 
372     /**
373      * @dev Returns the token collection symbol.
374      */
375     function symbol() external view returns (string memory);
376 
377     /**
378      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
379      */
380     function tokenURI(uint256 tokenId) external view returns (string memory);
381 
382     // =============================================================
383     //                           IERC2309
384     // =============================================================
385 
386     /**
387      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
388      * (inclusive) is transferred from `from` to `to`, as defined in the
389      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
390      *
391      * See {_mintERC2309} for more details.
392      */
393     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
394 }
395 
396 
397 // File erc721a/contracts/ERC721A.sol@v4.2.3
398 
399 // ERC721A Contracts v4.2.3
400 // Creator: Chiru Labs
401 
402 pragma solidity ^0.8.4;
403 
404 /**
405  * @dev Interface of ERC721 token receiver.
406  */
407 interface ERC721A__IERC721Receiver {
408     function onERC721Received(
409         address operator,
410         address from,
411         uint256 tokenId,
412         bytes calldata data
413     ) external returns (bytes4);
414 }
415 
416 /**
417  * @title ERC721A
418  *
419  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
420  * Non-Fungible Token Standard, including the Metadata extension.
421  * Optimized for lower gas during batch mints.
422  *
423  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
424  * starting from `_startTokenId()`.
425  *
426  * Assumptions:
427  *
428  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
429  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
430  */
431 contract ERC721A is IERC721A {
432     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
433     struct TokenApprovalRef {
434         address value;
435     }
436 
437     // =============================================================
438     //                           CONSTANTS
439     // =============================================================
440 
441     // Mask of an entry in packed address data.
442     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
443 
444     // The bit position of `numberMinted` in packed address data.
445     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
446 
447     // The bit position of `numberBurned` in packed address data.
448     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
449 
450     // The bit position of `aux` in packed address data.
451     uint256 private constant _BITPOS_AUX = 192;
452 
453     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
454     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
455 
456     // The bit position of `startTimestamp` in packed ownership.
457     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
458 
459     // The bit mask of the `burned` bit in packed ownership.
460     uint256 private constant _BITMASK_BURNED = 1 << 224;
461 
462     // The bit position of the `nextInitialized` bit in packed ownership.
463     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
464 
465     // The bit mask of the `nextInitialized` bit in packed ownership.
466     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
467 
468     // The bit position of `extraData` in packed ownership.
469     uint256 private constant _BITPOS_EXTRA_DATA = 232;
470 
471     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
472     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
473 
474     // The mask of the lower 160 bits for addresses.
475     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
476 
477     // The maximum `quantity` that can be minted with {_mintERC2309}.
478     // This limit is to prevent overflows on the address data entries.
479     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
480     // is required to cause an overflow, which is unrealistic.
481     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
482 
483     // The `Transfer` event signature is given by:
484     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
485     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
486         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
487 
488     // =============================================================
489     //                            STORAGE
490     // =============================================================
491 
492     // The next token ID to be minted.
493     uint256 private _currentIndex;
494 
495     // The number of tokens burned.
496     uint256 private _burnCounter;
497 
498     // Token name
499     string private _name;
500 
501     // Token symbol
502     string private _symbol;
503 
504     // Mapping from token ID to ownership details
505     // An empty struct value does not necessarily mean the token is unowned.
506     // See {_packedOwnershipOf} implementation for details.
507     //
508     // Bits Layout:
509     // - [0..159]   `addr`
510     // - [160..223] `startTimestamp`
511     // - [224]      `burned`
512     // - [225]      `nextInitialized`
513     // - [232..255] `extraData`
514     mapping(uint256 => uint256) private _packedOwnerships;
515 
516     // Mapping owner address to address data.
517     //
518     // Bits Layout:
519     // - [0..63]    `balance`
520     // - [64..127]  `numberMinted`
521     // - [128..191] `numberBurned`
522     // - [192..255] `aux`
523     mapping(address => uint256) private _packedAddressData;
524 
525     // Mapping from token ID to approved address.
526     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
527 
528     // Mapping from owner to operator approvals
529     mapping(address => mapping(address => bool)) private _operatorApprovals;
530 
531     // =============================================================
532     //                          CONSTRUCTOR
533     // =============================================================
534 
535     constructor(string memory name_, string memory symbol_) {
536         _name = name_;
537         _symbol = symbol_;
538         _currentIndex = _startTokenId();
539     }
540 
541     // =============================================================
542     //                   TOKEN COUNTING OPERATIONS
543     // =============================================================
544 
545     /**
546      * @dev Returns the starting token ID.
547      * To change the starting token ID, please override this function.
548      */
549     function _startTokenId() internal view virtual returns (uint256) {
550         return 0;
551     }
552 
553     /**
554      * @dev Returns the next token ID to be minted.
555      */
556     function _nextTokenId() internal view virtual returns (uint256) {
557         return _currentIndex;
558     }
559 
560     /**
561      * @dev Returns the total number of tokens in existence.
562      * Burned tokens will reduce the count.
563      * To get the total number of tokens minted, please see {_totalMinted}.
564      */
565     function totalSupply() public view virtual override returns (uint256) {
566         // Counter underflow is impossible as _burnCounter cannot be incremented
567         // more than `_currentIndex - _startTokenId()` times.
568         unchecked {
569             return _currentIndex - _burnCounter - _startTokenId();
570         }
571     }
572 
573     /**
574      * @dev Returns the total amount of tokens minted in the contract.
575      */
576     function _totalMinted() internal view virtual returns (uint256) {
577         // Counter underflow is impossible as `_currentIndex` does not decrement,
578         // and it is initialized to `_startTokenId()`.
579         unchecked {
580             return _currentIndex - _startTokenId();
581         }
582     }
583 
584     /**
585      * @dev Returns the total number of tokens burned.
586      */
587     function _totalBurned() internal view virtual returns (uint256) {
588         return _burnCounter;
589     }
590 
591     // =============================================================
592     //                    ADDRESS DATA OPERATIONS
593     // =============================================================
594 
595     /**
596      * @dev Returns the number of tokens in `owner`'s account.
597      */
598     function balanceOf(address owner) public view virtual override returns (uint256) {
599         if (owner == address(0)) revert BalanceQueryForZeroAddress();
600         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
601     }
602 
603     /**
604      * Returns the number of tokens minted by `owner`.
605      */
606     function _numberMinted(address owner) internal view returns (uint256) {
607         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
608     }
609 
610     /**
611      * Returns the number of tokens burned by or on behalf of `owner`.
612      */
613     function _numberBurned(address owner) internal view returns (uint256) {
614         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
615     }
616 
617     /**
618      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
619      */
620     function _getAux(address owner) internal view returns (uint64) {
621         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
622     }
623 
624     /**
625      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
626      * If there are multiple variables, please pack them into a uint64.
627      */
628     function _setAux(address owner, uint64 aux) internal virtual {
629         uint256 packed = _packedAddressData[owner];
630         uint256 auxCasted;
631         // Cast `aux` with assembly to avoid redundant masking.
632         assembly {
633             auxCasted := aux
634         }
635         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
636         _packedAddressData[owner] = packed;
637     }
638 
639     // =============================================================
640     //                            IERC165
641     // =============================================================
642 
643     /**
644      * @dev Returns true if this contract implements the interface defined by
645      * `interfaceId`. See the corresponding
646      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
647      * to learn more about how these ids are created.
648      *
649      * This function call must use less than 30000 gas.
650      */
651     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
652         // The interface IDs are constants representing the first 4 bytes
653         // of the XOR of all function selectors in the interface.
654         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
655         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
656         return
657             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
658             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
659             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
660     }
661 
662     // =============================================================
663     //                        IERC721Metadata
664     // =============================================================
665 
666     /**
667      * @dev Returns the token collection name.
668      */
669     function name() public view virtual override returns (string memory) {
670         return _name;
671     }
672 
673     /**
674      * @dev Returns the token collection symbol.
675      */
676     function symbol() public view virtual override returns (string memory) {
677         return _symbol;
678     }
679 
680     /**
681      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
682      */
683     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
684         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
685 
686         string memory baseURI = _baseURI();
687         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
688     }
689 
690     /**
691      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
692      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
693      * by default, it can be overridden in child contracts.
694      */
695     function _baseURI() internal view virtual returns (string memory) {
696         return '';
697     }
698 
699     // =============================================================
700     //                     OWNERSHIPS OPERATIONS
701     // =============================================================
702 
703     /**
704      * @dev Returns the owner of the `tokenId` token.
705      *
706      * Requirements:
707      *
708      * - `tokenId` must exist.
709      */
710     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
711         return address(uint160(_packedOwnershipOf(tokenId)));
712     }
713 
714     /**
715      * @dev Gas spent here starts off proportional to the maximum mint batch size.
716      * It gradually moves to O(1) as tokens get transferred around over time.
717      */
718     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
719         return _unpackedOwnership(_packedOwnershipOf(tokenId));
720     }
721 
722     /**
723      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
724      */
725     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
726         return _unpackedOwnership(_packedOwnerships[index]);
727     }
728 
729     /**
730      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
731      */
732     function _initializeOwnershipAt(uint256 index) internal virtual {
733         if (_packedOwnerships[index] == 0) {
734             _packedOwnerships[index] = _packedOwnershipOf(index);
735         }
736     }
737 
738     /**
739      * Returns the packed ownership data of `tokenId`.
740      */
741     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
742         uint256 curr = tokenId;
743 
744         unchecked {
745             if (_startTokenId() <= curr)
746                 if (curr < _currentIndex) {
747                     uint256 packed = _packedOwnerships[curr];
748                     // If not burned.
749                     if (packed & _BITMASK_BURNED == 0) {
750                         // Invariant:
751                         // There will always be an initialized ownership slot
752                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
753                         // before an unintialized ownership slot
754                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
755                         // Hence, `curr` will not underflow.
756                         //
757                         // We can directly compare the packed value.
758                         // If the address is zero, packed will be zero.
759                         while (packed == 0) {
760                             packed = _packedOwnerships[--curr];
761                         }
762                         return packed;
763                     }
764                 }
765         }
766         revert OwnerQueryForNonexistentToken();
767     }
768 
769     /**
770      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
771      */
772     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
773         ownership.addr = address(uint160(packed));
774         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
775         ownership.burned = packed & _BITMASK_BURNED != 0;
776         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
777     }
778 
779     /**
780      * @dev Packs ownership data into a single uint256.
781      */
782     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
783         assembly {
784             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
785             owner := and(owner, _BITMASK_ADDRESS)
786             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
787             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
788         }
789     }
790 
791     /**
792      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
793      */
794     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
795         // For branchless setting of the `nextInitialized` flag.
796         assembly {
797             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
798             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
799         }
800     }
801 
802     // =============================================================
803     //                      APPROVAL OPERATIONS
804     // =============================================================
805 
806     /**
807      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
808      * The approval is cleared when the token is transferred.
809      *
810      * Only a single account can be approved at a time, so approving the
811      * zero address clears previous approvals.
812      *
813      * Requirements:
814      *
815      * - The caller must own the token or be an approved operator.
816      * - `tokenId` must exist.
817      *
818      * Emits an {Approval} event.
819      */
820     function approve(address to, uint256 tokenId) public payable virtual override {
821         address owner = ownerOf(tokenId);
822 
823         if (_msgSenderERC721A() != owner)
824             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
825                 revert ApprovalCallerNotOwnerNorApproved();
826             }
827 
828         _tokenApprovals[tokenId].value = to;
829         emit Approval(owner, to, tokenId);
830     }
831 
832     /**
833      * @dev Returns the account approved for `tokenId` token.
834      *
835      * Requirements:
836      *
837      * - `tokenId` must exist.
838      */
839     function getApproved(uint256 tokenId) public view virtual override returns (address) {
840         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
841 
842         return _tokenApprovals[tokenId].value;
843     }
844 
845     /**
846      * @dev Approve or remove `operator` as an operator for the caller.
847      * Operators can call {transferFrom} or {safeTransferFrom}
848      * for any token owned by the caller.
849      *
850      * Requirements:
851      *
852      * - The `operator` cannot be the caller.
853      *
854      * Emits an {ApprovalForAll} event.
855      */
856     function setApprovalForAll(address operator, bool approved) public virtual override {
857         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
858         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
859     }
860 
861     /**
862      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
863      *
864      * See {setApprovalForAll}.
865      */
866     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
867         return _operatorApprovals[owner][operator];
868     }
869 
870     /**
871      * @dev Returns whether `tokenId` exists.
872      *
873      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
874      *
875      * Tokens start existing when they are minted. See {_mint}.
876      */
877     function _exists(uint256 tokenId) internal view virtual returns (bool) {
878         return
879             _startTokenId() <= tokenId &&
880             tokenId < _currentIndex && // If within bounds,
881             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
882     }
883 
884     /**
885      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
886      */
887     function _isSenderApprovedOrOwner(
888         address approvedAddress,
889         address owner,
890         address msgSender
891     ) private pure returns (bool result) {
892         assembly {
893             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
894             owner := and(owner, _BITMASK_ADDRESS)
895             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
896             msgSender := and(msgSender, _BITMASK_ADDRESS)
897             // `msgSender == owner || msgSender == approvedAddress`.
898             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
899         }
900     }
901 
902     /**
903      * @dev Returns the storage slot and value for the approved address of `tokenId`.
904      */
905     function _getApprovedSlotAndAddress(uint256 tokenId)
906         private
907         view
908         returns (uint256 approvedAddressSlot, address approvedAddress)
909     {
910         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
911         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
912         assembly {
913             approvedAddressSlot := tokenApproval.slot
914             approvedAddress := sload(approvedAddressSlot)
915         }
916     }
917 
918     // =============================================================
919     //                      TRANSFER OPERATIONS
920     // =============================================================
921 
922     /**
923      * @dev Transfers `tokenId` from `from` to `to`.
924      *
925      * Requirements:
926      *
927      * - `from` cannot be the zero address.
928      * - `to` cannot be the zero address.
929      * - `tokenId` token must be owned by `from`.
930      * - If the caller is not `from`, it must be approved to move this token
931      * by either {approve} or {setApprovalForAll}.
932      *
933      * Emits a {Transfer} event.
934      */
935     function transferFrom(
936         address from,
937         address to,
938         uint256 tokenId
939     ) public payable virtual override {
940         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
941 
942         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
943 
944         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
945 
946         // The nested ifs save around 20+ gas over a compound boolean condition.
947         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
948             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
949 
950         if (to == address(0)) revert TransferToZeroAddress();
951 
952         _beforeTokenTransfers(from, to, tokenId, 1);
953 
954         // Clear approvals from the previous owner.
955         assembly {
956             if approvedAddress {
957                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
958                 sstore(approvedAddressSlot, 0)
959             }
960         }
961 
962         // Underflow of the sender's balance is impossible because we check for
963         // ownership above and the recipient's balance can't realistically overflow.
964         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
965         unchecked {
966             // We can directly increment and decrement the balances.
967             --_packedAddressData[from]; // Updates: `balance -= 1`.
968             ++_packedAddressData[to]; // Updates: `balance += 1`.
969 
970             // Updates:
971             // - `address` to the next owner.
972             // - `startTimestamp` to the timestamp of transfering.
973             // - `burned` to `false`.
974             // - `nextInitialized` to `true`.
975             _packedOwnerships[tokenId] = _packOwnershipData(
976                 to,
977                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
978             );
979 
980             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
981             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
982                 uint256 nextTokenId = tokenId + 1;
983                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
984                 if (_packedOwnerships[nextTokenId] == 0) {
985                     // If the next slot is within bounds.
986                     if (nextTokenId != _currentIndex) {
987                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
988                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
989                     }
990                 }
991             }
992         }
993 
994         emit Transfer(from, to, tokenId);
995         _afterTokenTransfers(from, to, tokenId, 1);
996     }
997 
998     /**
999      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1000      */
1001     function safeTransferFrom(
1002         address from,
1003         address to,
1004         uint256 tokenId
1005     ) public payable virtual override {
1006         safeTransferFrom(from, to, tokenId, '');
1007     }
1008 
1009     /**
1010      * @dev Safely transfers `tokenId` token from `from` to `to`.
1011      *
1012      * Requirements:
1013      *
1014      * - `from` cannot be the zero address.
1015      * - `to` cannot be the zero address.
1016      * - `tokenId` token must exist and be owned by `from`.
1017      * - If the caller is not `from`, it must be approved to move this token
1018      * by either {approve} or {setApprovalForAll}.
1019      * - If `to` refers to a smart contract, it must implement
1020      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1021      *
1022      * Emits a {Transfer} event.
1023      */
1024     function safeTransferFrom(
1025         address from,
1026         address to,
1027         uint256 tokenId,
1028         bytes memory _data
1029     ) public payable virtual override {
1030         transferFrom(from, to, tokenId);
1031         if (to.code.length != 0)
1032             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1033                 revert TransferToNonERC721ReceiverImplementer();
1034             }
1035     }
1036 
1037     /**
1038      * @dev Hook that is called before a set of serially-ordered token IDs
1039      * are about to be transferred. This includes minting.
1040      * And also called before burning one token.
1041      *
1042      * `startTokenId` - the first token ID to be transferred.
1043      * `quantity` - the amount to be transferred.
1044      *
1045      * Calling conditions:
1046      *
1047      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1048      * transferred to `to`.
1049      * - When `from` is zero, `tokenId` will be minted for `to`.
1050      * - When `to` is zero, `tokenId` will be burned by `from`.
1051      * - `from` and `to` are never both zero.
1052      */
1053     function _beforeTokenTransfers(
1054         address from,
1055         address to,
1056         uint256 startTokenId,
1057         uint256 quantity
1058     ) internal virtual {}
1059 
1060     /**
1061      * @dev Hook that is called after a set of serially-ordered token IDs
1062      * have been transferred. This includes minting.
1063      * And also called after one token has been burned.
1064      *
1065      * `startTokenId` - the first token ID to be transferred.
1066      * `quantity` - the amount to be transferred.
1067      *
1068      * Calling conditions:
1069      *
1070      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1071      * transferred to `to`.
1072      * - When `from` is zero, `tokenId` has been minted for `to`.
1073      * - When `to` is zero, `tokenId` has been burned by `from`.
1074      * - `from` and `to` are never both zero.
1075      */
1076     function _afterTokenTransfers(
1077         address from,
1078         address to,
1079         uint256 startTokenId,
1080         uint256 quantity
1081     ) internal virtual {}
1082 
1083     /**
1084      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1085      *
1086      * `from` - Previous owner of the given token ID.
1087      * `to` - Target address that will receive the token.
1088      * `tokenId` - Token ID to be transferred.
1089      * `_data` - Optional data to send along with the call.
1090      *
1091      * Returns whether the call correctly returned the expected magic value.
1092      */
1093     function _checkContractOnERC721Received(
1094         address from,
1095         address to,
1096         uint256 tokenId,
1097         bytes memory _data
1098     ) private returns (bool) {
1099         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1100             bytes4 retval
1101         ) {
1102             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1103         } catch (bytes memory reason) {
1104             if (reason.length == 0) {
1105                 revert TransferToNonERC721ReceiverImplementer();
1106             } else {
1107                 assembly {
1108                     revert(add(32, reason), mload(reason))
1109                 }
1110             }
1111         }
1112     }
1113 
1114     // =============================================================
1115     //                        MINT OPERATIONS
1116     // =============================================================
1117 
1118     /**
1119      * @dev Mints `quantity` tokens and transfers them to `to`.
1120      *
1121      * Requirements:
1122      *
1123      * - `to` cannot be the zero address.
1124      * - `quantity` must be greater than 0.
1125      *
1126      * Emits a {Transfer} event for each mint.
1127      */
1128     function _mint(address to, uint256 quantity) internal virtual {
1129         uint256 startTokenId = _currentIndex;
1130         if (quantity == 0) revert MintZeroQuantity();
1131 
1132         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1133 
1134         // Overflows are incredibly unrealistic.
1135         // `balance` and `numberMinted` have a maximum limit of 2**64.
1136         // `tokenId` has a maximum limit of 2**256.
1137         unchecked {
1138             // Updates:
1139             // - `balance += quantity`.
1140             // - `numberMinted += quantity`.
1141             //
1142             // We can directly add to the `balance` and `numberMinted`.
1143             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1144 
1145             // Updates:
1146             // - `address` to the owner.
1147             // - `startTimestamp` to the timestamp of minting.
1148             // - `burned` to `false`.
1149             // - `nextInitialized` to `quantity == 1`.
1150             _packedOwnerships[startTokenId] = _packOwnershipData(
1151                 to,
1152                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1153             );
1154 
1155             uint256 toMasked;
1156             uint256 end = startTokenId + quantity;
1157 
1158             // Use assembly to loop and emit the `Transfer` event for gas savings.
1159             // The duplicated `log4` removes an extra check and reduces stack juggling.
1160             // The assembly, together with the surrounding Solidity code, have been
1161             // delicately arranged to nudge the compiler into producing optimized opcodes.
1162             assembly {
1163                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1164                 toMasked := and(to, _BITMASK_ADDRESS)
1165                 // Emit the `Transfer` event.
1166                 log4(
1167                     0, // Start of data (0, since no data).
1168                     0, // End of data (0, since no data).
1169                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1170                     0, // `address(0)`.
1171                     toMasked, // `to`.
1172                     startTokenId // `tokenId`.
1173                 )
1174 
1175                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1176                 // that overflows uint256 will make the loop run out of gas.
1177                 // The compiler will optimize the `iszero` away for performance.
1178                 for {
1179                     let tokenId := add(startTokenId, 1)
1180                 } iszero(eq(tokenId, end)) {
1181                     tokenId := add(tokenId, 1)
1182                 } {
1183                     // Emit the `Transfer` event. Similar to above.
1184                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1185                 }
1186             }
1187             if (toMasked == 0) revert MintToZeroAddress();
1188 
1189             _currentIndex = end;
1190         }
1191         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1192     }
1193 
1194     /**
1195      * @dev Mints `quantity` tokens and transfers them to `to`.
1196      *
1197      * This function is intended for efficient minting only during contract creation.
1198      *
1199      * It emits only one {ConsecutiveTransfer} as defined in
1200      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1201      * instead of a sequence of {Transfer} event(s).
1202      *
1203      * Calling this function outside of contract creation WILL make your contract
1204      * non-compliant with the ERC721 standard.
1205      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1206      * {ConsecutiveTransfer} event is only permissible during contract creation.
1207      *
1208      * Requirements:
1209      *
1210      * - `to` cannot be the zero address.
1211      * - `quantity` must be greater than 0.
1212      *
1213      * Emits a {ConsecutiveTransfer} event.
1214      */
1215     function _mintERC2309(address to, uint256 quantity) internal virtual {
1216         uint256 startTokenId = _currentIndex;
1217         if (to == address(0)) revert MintToZeroAddress();
1218         if (quantity == 0) revert MintZeroQuantity();
1219         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1220 
1221         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1222 
1223         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1224         unchecked {
1225             // Updates:
1226             // - `balance += quantity`.
1227             // - `numberMinted += quantity`.
1228             //
1229             // We can directly add to the `balance` and `numberMinted`.
1230             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1231 
1232             // Updates:
1233             // - `address` to the owner.
1234             // - `startTimestamp` to the timestamp of minting.
1235             // - `burned` to `false`.
1236             // - `nextInitialized` to `quantity == 1`.
1237             _packedOwnerships[startTokenId] = _packOwnershipData(
1238                 to,
1239                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1240             );
1241 
1242             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1243 
1244             _currentIndex = startTokenId + quantity;
1245         }
1246         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1247     }
1248 
1249     /**
1250      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1251      *
1252      * Requirements:
1253      *
1254      * - If `to` refers to a smart contract, it must implement
1255      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1256      * - `quantity` must be greater than 0.
1257      *
1258      * See {_mint}.
1259      *
1260      * Emits a {Transfer} event for each mint.
1261      */
1262     function _safeMint(
1263         address to,
1264         uint256 quantity,
1265         bytes memory _data
1266     ) internal virtual {
1267         _mint(to, quantity);
1268 
1269         unchecked {
1270             if (to.code.length != 0) {
1271                 uint256 end = _currentIndex;
1272                 uint256 index = end - quantity;
1273                 do {
1274                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1275                         revert TransferToNonERC721ReceiverImplementer();
1276                     }
1277                 } while (index < end);
1278                 // Reentrancy protection.
1279                 if (_currentIndex != end) revert();
1280             }
1281         }
1282     }
1283 
1284     /**
1285      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1286      */
1287     function _safeMint(address to, uint256 quantity) internal virtual {
1288         _safeMint(to, quantity, '');
1289     }
1290 
1291     // =============================================================
1292     //                        BURN OPERATIONS
1293     // =============================================================
1294 
1295     /**
1296      * @dev Equivalent to `_burn(tokenId, false)`.
1297      */
1298     function _burn(uint256 tokenId) internal virtual {
1299         _burn(tokenId, false);
1300     }
1301 
1302     /**
1303      * @dev Destroys `tokenId`.
1304      * The approval is cleared when the token is burned.
1305      *
1306      * Requirements:
1307      *
1308      * - `tokenId` must exist.
1309      *
1310      * Emits a {Transfer} event.
1311      */
1312     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1313         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1314 
1315         address from = address(uint160(prevOwnershipPacked));
1316 
1317         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1318 
1319         if (approvalCheck) {
1320             // The nested ifs save around 20+ gas over a compound boolean condition.
1321             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1322                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1323         }
1324 
1325         _beforeTokenTransfers(from, address(0), tokenId, 1);
1326 
1327         // Clear approvals from the previous owner.
1328         assembly {
1329             if approvedAddress {
1330                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1331                 sstore(approvedAddressSlot, 0)
1332             }
1333         }
1334 
1335         // Underflow of the sender's balance is impossible because we check for
1336         // ownership above and the recipient's balance can't realistically overflow.
1337         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1338         unchecked {
1339             // Updates:
1340             // - `balance -= 1`.
1341             // - `numberBurned += 1`.
1342             //
1343             // We can directly decrement the balance, and increment the number burned.
1344             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1345             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1346 
1347             // Updates:
1348             // - `address` to the last owner.
1349             // - `startTimestamp` to the timestamp of burning.
1350             // - `burned` to `true`.
1351             // - `nextInitialized` to `true`.
1352             _packedOwnerships[tokenId] = _packOwnershipData(
1353                 from,
1354                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1355             );
1356 
1357             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1358             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1359                 uint256 nextTokenId = tokenId + 1;
1360                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1361                 if (_packedOwnerships[nextTokenId] == 0) {
1362                     // If the next slot is within bounds.
1363                     if (nextTokenId != _currentIndex) {
1364                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1365                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1366                     }
1367                 }
1368             }
1369         }
1370 
1371         emit Transfer(from, address(0), tokenId);
1372         _afterTokenTransfers(from, address(0), tokenId, 1);
1373 
1374         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1375         unchecked {
1376             _burnCounter++;
1377         }
1378     }
1379 
1380     // =============================================================
1381     //                     EXTRA DATA OPERATIONS
1382     // =============================================================
1383 
1384     /**
1385      * @dev Directly sets the extra data for the ownership data `index`.
1386      */
1387     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1388         uint256 packed = _packedOwnerships[index];
1389         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1390         uint256 extraDataCasted;
1391         // Cast `extraData` with assembly to avoid redundant masking.
1392         assembly {
1393             extraDataCasted := extraData
1394         }
1395         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1396         _packedOwnerships[index] = packed;
1397     }
1398 
1399     /**
1400      * @dev Called during each token transfer to set the 24bit `extraData` field.
1401      * Intended to be overridden by the cosumer contract.
1402      *
1403      * `previousExtraData` - the value of `extraData` before transfer.
1404      *
1405      * Calling conditions:
1406      *
1407      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1408      * transferred to `to`.
1409      * - When `from` is zero, `tokenId` will be minted for `to`.
1410      * - When `to` is zero, `tokenId` will be burned by `from`.
1411      * - `from` and `to` are never both zero.
1412      */
1413     function _extraData(
1414         address from,
1415         address to,
1416         uint24 previousExtraData
1417     ) internal view virtual returns (uint24) {}
1418 
1419     /**
1420      * @dev Returns the next extra data for the packed ownership data.
1421      * The returned result is shifted into position.
1422      */
1423     function _nextExtraData(
1424         address from,
1425         address to,
1426         uint256 prevOwnershipPacked
1427     ) private view returns (uint256) {
1428         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1429         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1430     }
1431 
1432     // =============================================================
1433     //                       OTHER OPERATIONS
1434     // =============================================================
1435 
1436     /**
1437      * @dev Returns the message sender (defaults to `msg.sender`).
1438      *
1439      * If you are writing GSN compatible contracts, you need to override this function.
1440      */
1441     function _msgSenderERC721A() internal view virtual returns (address) {
1442         return msg.sender;
1443     }
1444 
1445     /**
1446      * @dev Converts a uint256 to its ASCII string decimal representation.
1447      */
1448     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1449         assembly {
1450             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1451             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1452             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1453             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1454             let m := add(mload(0x40), 0xa0)
1455             // Update the free memory pointer to allocate.
1456             mstore(0x40, m)
1457             // Assign the `str` to the end.
1458             str := sub(m, 0x20)
1459             // Zeroize the slot after the string.
1460             mstore(str, 0)
1461 
1462             // Cache the end of the memory to calculate the length later.
1463             let end := str
1464 
1465             // We write the string from rightmost digit to leftmost digit.
1466             // The following is essentially a do-while loop that also handles the zero case.
1467             // prettier-ignore
1468             for { let temp := value } 1 {} {
1469                 str := sub(str, 1)
1470                 // Write the character to the pointer.
1471                 // The ASCII index of the '0' character is 48.
1472                 mstore8(str, add(48, mod(temp, 10)))
1473                 // Keep dividing `temp` until zero.
1474                 temp := div(temp, 10)
1475                 // prettier-ignore
1476                 if iszero(temp) { break }
1477             }
1478 
1479             let length := sub(end, str)
1480             // Move the pointer 32 bytes leftwards to make room for the length.
1481             str := sub(str, 0x20)
1482             // Store the length.
1483             mstore(str, length)
1484         }
1485     }
1486 }
1487 
1488 
1489 // File operator-filter-registry/src/IOperatorFilterRegistry.sol@v1.3.1
1490 
1491 pragma solidity ^0.8.13;
1492 
1493 interface IOperatorFilterRegistry {
1494     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1495     function register(address registrant) external;
1496     function registerAndSubscribe(address registrant, address subscription) external;
1497     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1498     function unregister(address addr) external;
1499     function updateOperator(address registrant, address operator, bool filtered) external;
1500     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1501     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1502     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1503     function subscribe(address registrant, address registrantToSubscribe) external;
1504     function unsubscribe(address registrant, bool copyExistingEntries) external;
1505     function subscriptionOf(address addr) external returns (address registrant);
1506     function subscribers(address registrant) external returns (address[] memory);
1507     function subscriberAt(address registrant, uint256 index) external returns (address);
1508     function copyEntriesOf(address registrant, address registrantToCopy) external;
1509     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1510     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1511     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1512     function filteredOperators(address addr) external returns (address[] memory);
1513     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1514     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1515     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1516     function isRegistered(address addr) external returns (bool);
1517     function codeHashOf(address addr) external returns (bytes32);
1518 }
1519 
1520 
1521 // File operator-filter-registry/src/UpdatableOperatorFilterer.sol@v1.3.1
1522 
1523 pragma solidity ^0.8.13;
1524 
1525 /**
1526  * @title  UpdatableOperatorFilterer
1527  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1528  *         registrant's entries in the OperatorFilterRegistry. This contract allows the Owner to update the
1529  *         OperatorFilterRegistry address via updateOperatorFilterRegistryAddress, including to the zero address,
1530  *         which will bypass registry checks.
1531  *         Note that OpenSea will still disable creator fee enforcement if filtered operators begin fulfilling orders
1532  *         on-chain, eg, if the registry is revoked or bypassed.
1533  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1534  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1535  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1536  */
1537 abstract contract UpdatableOperatorFilterer {
1538     error OperatorNotAllowed(address operator);
1539     error OnlyOwner();
1540 
1541     IOperatorFilterRegistry public operatorFilterRegistry;
1542 
1543     constructor(address _registry, address subscriptionOrRegistrantToCopy, bool subscribe) {
1544         IOperatorFilterRegistry registry = IOperatorFilterRegistry(_registry);
1545         operatorFilterRegistry = registry;
1546         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1547         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1548         // order for the modifier to filter addresses.
1549         if (address(registry).code.length > 0) {
1550             if (subscribe) {
1551                 registry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1552             } else {
1553                 if (subscriptionOrRegistrantToCopy != address(0)) {
1554                     registry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1555                 } else {
1556                     registry.register(address(this));
1557                 }
1558             }
1559         }
1560     }
1561 
1562     modifier onlyAllowedOperator(address from) virtual {
1563         // Allow spending tokens from addresses with balance
1564         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1565         // from an EOA.
1566         if (from != msg.sender) {
1567             _checkFilterOperator(msg.sender);
1568         }
1569         _;
1570     }
1571 
1572     modifier onlyAllowedOperatorApproval(address operator) virtual {
1573         _checkFilterOperator(operator);
1574         _;
1575     }
1576 
1577     /**
1578      * @notice Update the address that the contract will make OperatorFilter checks against. When set to the zero
1579      *         address, checks will be bypassed. OnlyOwner.
1580      */
1581     function updateOperatorFilterRegistryAddress(address newRegistry) public virtual {
1582         if (msg.sender != owner()) {
1583             revert OnlyOwner();
1584         }
1585         operatorFilterRegistry = IOperatorFilterRegistry(newRegistry);
1586     }
1587 
1588     /**
1589      * @dev assume the contract has an owner, but leave specific Ownable implementation up to inheriting contract
1590      */
1591     function owner() public view virtual returns (address);
1592 
1593     function _checkFilterOperator(address operator) internal view virtual {
1594         IOperatorFilterRegistry registry = operatorFilterRegistry;
1595         // Check registry code length to facilitate testing in environments without a deployed registry.
1596         if (address(registry) != address(0) && address(registry).code.length > 0) {
1597             if (!registry.isOperatorAllowed(address(this), operator)) {
1598                 revert OperatorNotAllowed(operator);
1599             }
1600         }
1601     }
1602 }
1603 
1604 
1605 // File operator-filter-registry/src/RevokableOperatorFilterer.sol@v1.3.1
1606 
1607 pragma solidity ^0.8.13;
1608 
1609 
1610 /**
1611  * @title  RevokableOperatorFilterer
1612  * @notice This contract is meant to allow contracts to permanently skip OperatorFilterRegistry checks if desired. The
1613  *         Registry itself has an "unregister" function, but if the contract is ownable, the owner can re-register at
1614  *         any point. As implemented, this abstract contract allows the contract owner to permanently skip the
1615  *         OperatorFilterRegistry checks by calling revokeOperatorFilterRegistry. Once done, the registry
1616  *         address cannot be further updated.
1617  *         Note that OpenSea will still disable creator fee enforcement if filtered operators begin fulfilling orders
1618  *         on-chain, eg, if the registry is revoked or bypassed.
1619  */
1620 abstract contract RevokableOperatorFilterer is UpdatableOperatorFilterer {
1621     error RegistryHasBeenRevoked();
1622     error InitialRegistryAddressCannotBeZeroAddress();
1623 
1624     bool public isOperatorFilterRegistryRevoked;
1625 
1626     constructor(address _registry, address subscriptionOrRegistrantToCopy, bool subscribe)
1627         UpdatableOperatorFilterer(_registry, subscriptionOrRegistrantToCopy, subscribe)
1628     {
1629         // don't allow creating a contract with a permanently revoked registry
1630         if (_registry == address(0)) {
1631             revert InitialRegistryAddressCannotBeZeroAddress();
1632         }
1633     }
1634 
1635     function _checkFilterOperator(address operator) internal view virtual override {
1636         if (address(operatorFilterRegistry) != address(0)) {
1637             super._checkFilterOperator(operator);
1638         }
1639     }
1640 
1641     /**
1642      * @notice Update the address that the contract will make OperatorFilter checks against. When set to the zero
1643      *         address, checks will be permanently bypassed, and the address cannot be updated again. OnlyOwner.
1644      */
1645     function updateOperatorFilterRegistryAddress(address newRegistry) public override {
1646         if (msg.sender != owner()) {
1647             revert OnlyOwner();
1648         }
1649         // if registry has been revoked, do not allow further updates
1650         if (isOperatorFilterRegistryRevoked) {
1651             revert RegistryHasBeenRevoked();
1652         }
1653 
1654         operatorFilterRegistry = IOperatorFilterRegistry(newRegistry);
1655     }
1656 
1657     /**
1658      * @notice Revoke the OperatorFilterRegistry address, permanently bypassing checks. OnlyOwner.
1659      */
1660     function revokeOperatorFilterRegistry() public {
1661         if (msg.sender != owner()) {
1662             revert OnlyOwner();
1663         }
1664         // if registry has been revoked, do not allow further updates
1665         if (isOperatorFilterRegistryRevoked) {
1666             revert RegistryHasBeenRevoked();
1667         }
1668 
1669         // set to zero address to bypass checks
1670         operatorFilterRegistry = IOperatorFilterRegistry(address(0));
1671         isOperatorFilterRegistryRevoked = true;
1672     }
1673 }
1674 
1675 
1676 // File operator-filter-registry/src/RevokableDefaultOperatorFilterer.sol@v1.3.1
1677 
1678 pragma solidity ^0.8.13;
1679 
1680 /**
1681  * @title  RevokableDefaultOperatorFilterer
1682  * @notice Inherits from RevokableOperatorFilterer and automatically subscribes to the default OpenSea subscription.
1683  *         Note that OpenSea will disable creator fee enforcement if filtered operators begin fulfilling orders
1684  *         on-chain, eg, if the registry is revoked or bypassed.
1685  */
1686 abstract contract RevokableDefaultOperatorFilterer is RevokableOperatorFilterer {
1687     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1688 
1689     constructor() RevokableOperatorFilterer(0x000000000000AAeB6D7670E522A718067333cd4E, DEFAULT_SUBSCRIPTION, true) {}
1690 }
1691 
1692 
1693 // File erc721a/contracts/extensions/IERC721ABurnable.sol@v4.2.3
1694 
1695 // ERC721A Contracts v4.2.3
1696 // Creator: Chiru Labs
1697 
1698 pragma solidity ^0.8.4;
1699 
1700 /**
1701  * @dev Interface of ERC721ABurnable.
1702  */
1703 interface IERC721ABurnable is IERC721A {
1704     /**
1705      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1706      *
1707      * Requirements:
1708      *
1709      * - The caller must own `tokenId` or be an approved operator.
1710      */
1711     function burn(uint256 tokenId) external;
1712 }
1713 
1714 
1715 // File erc721a/contracts/extensions/ERC721ABurnable.sol@v4.2.3
1716 
1717 // ERC721A Contracts v4.2.3
1718 // Creator: Chiru Labs
1719 
1720 pragma solidity ^0.8.4;
1721 
1722 
1723 /**
1724  * @title ERC721ABurnable.
1725  *
1726  * @dev ERC721A token that can be irreversibly burned (destroyed).
1727  */
1728 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
1729     /**
1730      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1731      *
1732      * Requirements:
1733      *
1734      * - The caller must own `tokenId` or be an approved operator.
1735      */
1736     function burn(uint256 tokenId) public virtual override {
1737         _burn(tokenId, true);
1738     }
1739 }
1740 
1741 
1742 // File erc721a/contracts/extensions/IERC721AQueryable.sol@v4.2.3
1743 
1744 // ERC721A Contracts v4.2.3
1745 // Creator: Chiru Labs
1746 
1747 pragma solidity ^0.8.4;
1748 
1749 /**
1750  * @dev Interface of ERC721AQueryable.
1751  */
1752 interface IERC721AQueryable is IERC721A {
1753     /**
1754      * Invalid query range (`start` >= `stop`).
1755      */
1756     error InvalidQueryRange();
1757 
1758     /**
1759      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1760      *
1761      * If the `tokenId` is out of bounds:
1762      *
1763      * - `addr = address(0)`
1764      * - `startTimestamp = 0`
1765      * - `burned = false`
1766      * - `extraData = 0`
1767      *
1768      * If the `tokenId` is burned:
1769      *
1770      * - `addr = <Address of owner before token was burned>`
1771      * - `startTimestamp = <Timestamp when token was burned>`
1772      * - `burned = true`
1773      * - `extraData = <Extra data when token was burned>`
1774      *
1775      * Otherwise:
1776      *
1777      * - `addr = <Address of owner>`
1778      * - `startTimestamp = <Timestamp of start of ownership>`
1779      * - `burned = false`
1780      * - `extraData = <Extra data at start of ownership>`
1781      */
1782     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1783 
1784     /**
1785      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1786      * See {ERC721AQueryable-explicitOwnershipOf}
1787      */
1788     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1789 
1790     /**
1791      * @dev Returns an array of token IDs owned by `owner`,
1792      * in the range [`start`, `stop`)
1793      * (i.e. `start <= tokenId < stop`).
1794      *
1795      * This function allows for tokens to be queried if the collection
1796      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1797      *
1798      * Requirements:
1799      *
1800      * - `start < stop`
1801      */
1802     function tokensOfOwnerIn(
1803         address owner,
1804         uint256 start,
1805         uint256 stop
1806     ) external view returns (uint256[] memory);
1807 
1808     /**
1809      * @dev Returns an array of token IDs owned by `owner`.
1810      *
1811      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1812      * It is meant to be called off-chain.
1813      *
1814      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1815      * multiple smaller scans if the collection is large enough to cause
1816      * an out-of-gas error (10K collections should be fine).
1817      */
1818     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1819 }
1820 
1821 
1822 // File erc721a/contracts/extensions/ERC721AQueryable.sol@v4.2.3
1823 
1824 // ERC721A Contracts v4.2.3
1825 // Creator: Chiru Labs
1826 
1827 pragma solidity ^0.8.4;
1828 
1829 
1830 /**
1831  * @title ERC721AQueryable.
1832  *
1833  * @dev ERC721A subclass with convenience query functions.
1834  */
1835 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1836     /**
1837      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1838      *
1839      * If the `tokenId` is out of bounds:
1840      *
1841      * - `addr = address(0)`
1842      * - `startTimestamp = 0`
1843      * - `burned = false`
1844      * - `extraData = 0`
1845      *
1846      * If the `tokenId` is burned:
1847      *
1848      * - `addr = <Address of owner before token was burned>`
1849      * - `startTimestamp = <Timestamp when token was burned>`
1850      * - `burned = true`
1851      * - `extraData = <Extra data when token was burned>`
1852      *
1853      * Otherwise:
1854      *
1855      * - `addr = <Address of owner>`
1856      * - `startTimestamp = <Timestamp of start of ownership>`
1857      * - `burned = false`
1858      * - `extraData = <Extra data at start of ownership>`
1859      */
1860     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1861         TokenOwnership memory ownership;
1862         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1863             return ownership;
1864         }
1865         ownership = _ownershipAt(tokenId);
1866         if (ownership.burned) {
1867             return ownership;
1868         }
1869         return _ownershipOf(tokenId);
1870     }
1871 
1872     /**
1873      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1874      * See {ERC721AQueryable-explicitOwnershipOf}
1875      */
1876     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1877         external
1878         view
1879         virtual
1880         override
1881         returns (TokenOwnership[] memory)
1882     {
1883         unchecked {
1884             uint256 tokenIdsLength = tokenIds.length;
1885             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1886             for (uint256 i; i != tokenIdsLength; ++i) {
1887                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1888             }
1889             return ownerships;
1890         }
1891     }
1892 
1893     /**
1894      * @dev Returns an array of token IDs owned by `owner`,
1895      * in the range [`start`, `stop`)
1896      * (i.e. `start <= tokenId < stop`).
1897      *
1898      * This function allows for tokens to be queried if the collection
1899      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1900      *
1901      * Requirements:
1902      *
1903      * - `start < stop`
1904      */
1905     function tokensOfOwnerIn(
1906         address owner,
1907         uint256 start,
1908         uint256 stop
1909     ) external view virtual override returns (uint256[] memory) {
1910         unchecked {
1911             if (start >= stop) revert InvalidQueryRange();
1912             uint256 tokenIdsIdx;
1913             uint256 stopLimit = _nextTokenId();
1914             // Set `start = max(start, _startTokenId())`.
1915             if (start < _startTokenId()) {
1916                 start = _startTokenId();
1917             }
1918             // Set `stop = min(stop, stopLimit)`.
1919             if (stop > stopLimit) {
1920                 stop = stopLimit;
1921             }
1922             uint256 tokenIdsMaxLength = balanceOf(owner);
1923             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1924             // to cater for cases where `balanceOf(owner)` is too big.
1925             if (start < stop) {
1926                 uint256 rangeLength = stop - start;
1927                 if (rangeLength < tokenIdsMaxLength) {
1928                     tokenIdsMaxLength = rangeLength;
1929                 }
1930             } else {
1931                 tokenIdsMaxLength = 0;
1932             }
1933             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1934             if (tokenIdsMaxLength == 0) {
1935                 return tokenIds;
1936             }
1937             // We need to call `explicitOwnershipOf(start)`,
1938             // because the slot at `start` may not be initialized.
1939             TokenOwnership memory ownership = explicitOwnershipOf(start);
1940             address currOwnershipAddr;
1941             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1942             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1943             if (!ownership.burned) {
1944                 currOwnershipAddr = ownership.addr;
1945             }
1946             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1947                 ownership = _ownershipAt(i);
1948                 if (ownership.burned) {
1949                     continue;
1950                 }
1951                 if (ownership.addr != address(0)) {
1952                     currOwnershipAddr = ownership.addr;
1953                 }
1954                 if (currOwnershipAddr == owner) {
1955                     tokenIds[tokenIdsIdx++] = i;
1956                 }
1957             }
1958             // Downsize the array to fit.
1959             assembly {
1960                 mstore(tokenIds, tokenIdsIdx)
1961             }
1962             return tokenIds;
1963         }
1964     }
1965 
1966     /**
1967      * @dev Returns an array of token IDs owned by `owner`.
1968      *
1969      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1970      * It is meant to be called off-chain.
1971      *
1972      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1973      * multiple smaller scans if the collection is large enough to cause
1974      * an out-of-gas error (10K collections should be fine).
1975      */
1976     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
1977         unchecked {
1978             uint256 tokenIdsIdx;
1979             address currOwnershipAddr;
1980             uint256 tokenIdsLength = balanceOf(owner);
1981             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1982             TokenOwnership memory ownership;
1983             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1984                 ownership = _ownershipAt(i);
1985                 if (ownership.burned) {
1986                     continue;
1987                 }
1988                 if (ownership.addr != address(0)) {
1989                     currOwnershipAddr = ownership.addr;
1990                 }
1991                 if (currOwnershipAddr == owner) {
1992                     tokenIds[tokenIdsIdx++] = i;
1993                 }
1994             }
1995             return tokenIds;
1996         }
1997     }
1998 }
1999 
2000 
2001 // File @openzeppelin/contracts/utils/math/Math.sol@v4.8.0
2002 
2003 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
2004 
2005 pragma solidity ^0.8.0;
2006 
2007 /**
2008  * @dev Standard math utilities missing in the Solidity language.
2009  */
2010 library Math {
2011     enum Rounding {
2012         Down, // Toward negative infinity
2013         Up, // Toward infinity
2014         Zero // Toward zero
2015     }
2016 
2017     /**
2018      * @dev Returns the largest of two numbers.
2019      */
2020     function max(uint256 a, uint256 b) internal pure returns (uint256) {
2021         return a > b ? a : b;
2022     }
2023 
2024     /**
2025      * @dev Returns the smallest of two numbers.
2026      */
2027     function min(uint256 a, uint256 b) internal pure returns (uint256) {
2028         return a < b ? a : b;
2029     }
2030 
2031     /**
2032      * @dev Returns the average of two numbers. The result is rounded towards
2033      * zero.
2034      */
2035     function average(uint256 a, uint256 b) internal pure returns (uint256) {
2036         // (a + b) / 2 can overflow.
2037         return (a & b) + (a ^ b) / 2;
2038     }
2039 
2040     /**
2041      * @dev Returns the ceiling of the division of two numbers.
2042      *
2043      * This differs from standard division with `/` in that it rounds up instead
2044      * of rounding down.
2045      */
2046     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
2047         // (a + b - 1) / b can overflow on addition, so we distribute.
2048         return a == 0 ? 0 : (a - 1) / b + 1;
2049     }
2050 
2051     /**
2052      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
2053      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
2054      * with further edits by Uniswap Labs also under MIT license.
2055      */
2056     function mulDiv(
2057         uint256 x,
2058         uint256 y,
2059         uint256 denominator
2060     ) internal pure returns (uint256 result) {
2061         unchecked {
2062             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
2063             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
2064             // variables such that product = prod1 * 2^256 + prod0.
2065             uint256 prod0; // Least significant 256 bits of the product
2066             uint256 prod1; // Most significant 256 bits of the product
2067             assembly {
2068                 let mm := mulmod(x, y, not(0))
2069                 prod0 := mul(x, y)
2070                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
2071             }
2072 
2073             // Handle non-overflow cases, 256 by 256 division.
2074             if (prod1 == 0) {
2075                 return prod0 / denominator;
2076             }
2077 
2078             // Make sure the result is less than 2^256. Also prevents denominator == 0.
2079             require(denominator > prod1);
2080 
2081             ///////////////////////////////////////////////
2082             // 512 by 256 division.
2083             ///////////////////////////////////////////////
2084 
2085             // Make division exact by subtracting the remainder from [prod1 prod0].
2086             uint256 remainder;
2087             assembly {
2088                 // Compute remainder using mulmod.
2089                 remainder := mulmod(x, y, denominator)
2090 
2091                 // Subtract 256 bit number from 512 bit number.
2092                 prod1 := sub(prod1, gt(remainder, prod0))
2093                 prod0 := sub(prod0, remainder)
2094             }
2095 
2096             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
2097             // See https://cs.stackexchange.com/q/138556/92363.
2098 
2099             // Does not overflow because the denominator cannot be zero at this stage in the function.
2100             uint256 twos = denominator & (~denominator + 1);
2101             assembly {
2102                 // Divide denominator by twos.
2103                 denominator := div(denominator, twos)
2104 
2105                 // Divide [prod1 prod0] by twos.
2106                 prod0 := div(prod0, twos)
2107 
2108                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
2109                 twos := add(div(sub(0, twos), twos), 1)
2110             }
2111 
2112             // Shift in bits from prod1 into prod0.
2113             prod0 |= prod1 * twos;
2114 
2115             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
2116             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
2117             // four bits. That is, denominator * inv = 1 mod 2^4.
2118             uint256 inverse = (3 * denominator) ^ 2;
2119 
2120             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
2121             // in modular arithmetic, doubling the correct bits in each step.
2122             inverse *= 2 - denominator * inverse; // inverse mod 2^8
2123             inverse *= 2 - denominator * inverse; // inverse mod 2^16
2124             inverse *= 2 - denominator * inverse; // inverse mod 2^32
2125             inverse *= 2 - denominator * inverse; // inverse mod 2^64
2126             inverse *= 2 - denominator * inverse; // inverse mod 2^128
2127             inverse *= 2 - denominator * inverse; // inverse mod 2^256
2128 
2129             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
2130             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
2131             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
2132             // is no longer required.
2133             result = prod0 * inverse;
2134             return result;
2135         }
2136     }
2137 
2138     /**
2139      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
2140      */
2141     function mulDiv(
2142         uint256 x,
2143         uint256 y,
2144         uint256 denominator,
2145         Rounding rounding
2146     ) internal pure returns (uint256) {
2147         uint256 result = mulDiv(x, y, denominator);
2148         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
2149             result += 1;
2150         }
2151         return result;
2152     }
2153 
2154     /**
2155      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
2156      *
2157      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
2158      */
2159     function sqrt(uint256 a) internal pure returns (uint256) {
2160         if (a == 0) {
2161             return 0;
2162         }
2163 
2164         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
2165         //
2166         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
2167         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
2168         //
2169         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
2170         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
2171         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
2172         //
2173         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
2174         uint256 result = 1 << (log2(a) >> 1);
2175 
2176         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
2177         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
2178         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
2179         // into the expected uint128 result.
2180         unchecked {
2181             result = (result + a / result) >> 1;
2182             result = (result + a / result) >> 1;
2183             result = (result + a / result) >> 1;
2184             result = (result + a / result) >> 1;
2185             result = (result + a / result) >> 1;
2186             result = (result + a / result) >> 1;
2187             result = (result + a / result) >> 1;
2188             return min(result, a / result);
2189         }
2190     }
2191 
2192     /**
2193      * @notice Calculates sqrt(a), following the selected rounding direction.
2194      */
2195     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
2196         unchecked {
2197             uint256 result = sqrt(a);
2198             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
2199         }
2200     }
2201 
2202     /**
2203      * @dev Return the log in base 2, rounded down, of a positive value.
2204      * Returns 0 if given 0.
2205      */
2206     function log2(uint256 value) internal pure returns (uint256) {
2207         uint256 result = 0;
2208         unchecked {
2209             if (value >> 128 > 0) {
2210                 value >>= 128;
2211                 result += 128;
2212             }
2213             if (value >> 64 > 0) {
2214                 value >>= 64;
2215                 result += 64;
2216             }
2217             if (value >> 32 > 0) {
2218                 value >>= 32;
2219                 result += 32;
2220             }
2221             if (value >> 16 > 0) {
2222                 value >>= 16;
2223                 result += 16;
2224             }
2225             if (value >> 8 > 0) {
2226                 value >>= 8;
2227                 result += 8;
2228             }
2229             if (value >> 4 > 0) {
2230                 value >>= 4;
2231                 result += 4;
2232             }
2233             if (value >> 2 > 0) {
2234                 value >>= 2;
2235                 result += 2;
2236             }
2237             if (value >> 1 > 0) {
2238                 result += 1;
2239             }
2240         }
2241         return result;
2242     }
2243 
2244     /**
2245      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
2246      * Returns 0 if given 0.
2247      */
2248     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
2249         unchecked {
2250             uint256 result = log2(value);
2251             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
2252         }
2253     }
2254 
2255     /**
2256      * @dev Return the log in base 10, rounded down, of a positive value.
2257      * Returns 0 if given 0.
2258      */
2259     function log10(uint256 value) internal pure returns (uint256) {
2260         uint256 result = 0;
2261         unchecked {
2262             if (value >= 10**64) {
2263                 value /= 10**64;
2264                 result += 64;
2265             }
2266             if (value >= 10**32) {
2267                 value /= 10**32;
2268                 result += 32;
2269             }
2270             if (value >= 10**16) {
2271                 value /= 10**16;
2272                 result += 16;
2273             }
2274             if (value >= 10**8) {
2275                 value /= 10**8;
2276                 result += 8;
2277             }
2278             if (value >= 10**4) {
2279                 value /= 10**4;
2280                 result += 4;
2281             }
2282             if (value >= 10**2) {
2283                 value /= 10**2;
2284                 result += 2;
2285             }
2286             if (value >= 10**1) {
2287                 result += 1;
2288             }
2289         }
2290         return result;
2291     }
2292 
2293     /**
2294      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2295      * Returns 0 if given 0.
2296      */
2297     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
2298         unchecked {
2299             uint256 result = log10(value);
2300             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
2301         }
2302     }
2303 
2304     /**
2305      * @dev Return the log in base 256, rounded down, of a positive value.
2306      * Returns 0 if given 0.
2307      *
2308      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
2309      */
2310     function log256(uint256 value) internal pure returns (uint256) {
2311         uint256 result = 0;
2312         unchecked {
2313             if (value >> 128 > 0) {
2314                 value >>= 128;
2315                 result += 16;
2316             }
2317             if (value >> 64 > 0) {
2318                 value >>= 64;
2319                 result += 8;
2320             }
2321             if (value >> 32 > 0) {
2322                 value >>= 32;
2323                 result += 4;
2324             }
2325             if (value >> 16 > 0) {
2326                 value >>= 16;
2327                 result += 2;
2328             }
2329             if (value >> 8 > 0) {
2330                 result += 1;
2331             }
2332         }
2333         return result;
2334     }
2335 
2336     /**
2337      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2338      * Returns 0 if given 0.
2339      */
2340     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
2341         unchecked {
2342             uint256 result = log256(value);
2343             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
2344         }
2345     }
2346 }
2347 
2348 
2349 // File @openzeppelin/contracts/utils/Strings.sol@v4.8.0
2350 
2351 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
2352 
2353 pragma solidity ^0.8.0;
2354 
2355 /**
2356  * @dev String operations.
2357  */
2358 library Strings {
2359     bytes16 private constant _SYMBOLS = "0123456789abcdef";
2360     uint8 private constant _ADDRESS_LENGTH = 20;
2361 
2362     /**
2363      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2364      */
2365     function toString(uint256 value) internal pure returns (string memory) {
2366         unchecked {
2367             uint256 length = Math.log10(value) + 1;
2368             string memory buffer = new string(length);
2369             uint256 ptr;
2370             /// @solidity memory-safe-assembly
2371             assembly {
2372                 ptr := add(buffer, add(32, length))
2373             }
2374             while (true) {
2375                 ptr--;
2376                 /// @solidity memory-safe-assembly
2377                 assembly {
2378                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
2379                 }
2380                 value /= 10;
2381                 if (value == 0) break;
2382             }
2383             return buffer;
2384         }
2385     }
2386 
2387     /**
2388      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2389      */
2390     function toHexString(uint256 value) internal pure returns (string memory) {
2391         unchecked {
2392             return toHexString(value, Math.log256(value) + 1);
2393         }
2394     }
2395 
2396     /**
2397      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2398      */
2399     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2400         bytes memory buffer = new bytes(2 * length + 2);
2401         buffer[0] = "0";
2402         buffer[1] = "x";
2403         for (uint256 i = 2 * length + 1; i > 1; --i) {
2404             buffer[i] = _SYMBOLS[value & 0xf];
2405             value >>= 4;
2406         }
2407         require(value == 0, "Strings: hex length insufficient");
2408         return string(buffer);
2409     }
2410 
2411     /**
2412      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2413      */
2414     function toHexString(address addr) internal pure returns (string memory) {
2415         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2416     }
2417 }
2418 
2419 
2420 // File @openzeppelin/contracts/utils/Context.sol@v4.8.0
2421 
2422 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2423 
2424 pragma solidity ^0.8.0;
2425 
2426 /**
2427  * @dev Provides information about the current execution context, including the
2428  * sender of the transaction and its data. While these are generally available
2429  * via msg.sender and msg.data, they should not be accessed in such a direct
2430  * manner, since when dealing with meta-transactions the account sending and
2431  * paying for execution may not be the actual sender (as far as an application
2432  * is concerned).
2433  *
2434  * This contract is only required for intermediate, library-like contracts.
2435  */
2436 abstract contract Context {
2437     function _msgSender() internal view virtual returns (address) {
2438         return msg.sender;
2439     }
2440 
2441     function _msgData() internal view virtual returns (bytes calldata) {
2442         return msg.data;
2443     }
2444 }
2445 
2446 
2447 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.0
2448 
2449 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2450 
2451 pragma solidity ^0.8.0;
2452 
2453 /**
2454  * @dev Contract module which provides a basic access control mechanism, where
2455  * there is an account (an owner) that can be granted exclusive access to
2456  * specific functions.
2457  *
2458  * By default, the owner account will be the one that deploys the contract. This
2459  * can later be changed with {transferOwnership}.
2460  *
2461  * This module is used through inheritance. It will make available the modifier
2462  * `onlyOwner`, which can be applied to your functions to restrict their use to
2463  * the owner.
2464  */
2465 abstract contract Ownable is Context {
2466     address private _owner;
2467 
2468     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2469 
2470     /**
2471      * @dev Initializes the contract setting the deployer as the initial owner.
2472      */
2473     constructor() {
2474         _transferOwnership(_msgSender());
2475     }
2476 
2477     /**
2478      * @dev Throws if called by any account other than the owner.
2479      */
2480     modifier onlyOwner() {
2481         _checkOwner();
2482         _;
2483     }
2484 
2485     /**
2486      * @dev Returns the address of the current owner.
2487      */
2488     function owner() public view virtual returns (address) {
2489         return _owner;
2490     }
2491 
2492     /**
2493      * @dev Throws if the sender is not the owner.
2494      */
2495     function _checkOwner() internal view virtual {
2496         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2497     }
2498 
2499     /**
2500      * @dev Leaves the contract without owner. It will not be possible to call
2501      * `onlyOwner` functions anymore. Can only be called by the current owner.
2502      *
2503      * NOTE: Renouncing ownership will leave the contract without an owner,
2504      * thereby removing any functionality that is only available to the owner.
2505      */
2506     function renounceOwnership() public virtual onlyOwner {
2507         _transferOwnership(address(0));
2508     }
2509 
2510     /**
2511      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2512      * Can only be called by the current owner.
2513      */
2514     function transferOwnership(address newOwner) public virtual onlyOwner {
2515         require(newOwner != address(0), "Ownable: new owner is the zero address");
2516         _transferOwnership(newOwner);
2517     }
2518 
2519     /**
2520      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2521      * Internal function without access restriction.
2522      */
2523     function _transferOwnership(address newOwner) internal virtual {
2524         address oldOwner = _owner;
2525         _owner = newOwner;
2526         emit OwnershipTransferred(oldOwner, newOwner);
2527     }
2528 }
2529 
2530 
2531 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.8.0
2532 
2533 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
2534 
2535 pragma solidity ^0.8.0;
2536 
2537 /**
2538  * @dev Contract module that helps prevent reentrant calls to a function.
2539  *
2540  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2541  * available, which can be applied to functions to make sure there are no nested
2542  * (reentrant) calls to them.
2543  *
2544  * Note that because there is a single `nonReentrant` guard, functions marked as
2545  * `nonReentrant` may not call one another. This can be worked around by making
2546  * those functions `private`, and then adding `external` `nonReentrant` entry
2547  * points to them.
2548  *
2549  * TIP: If you would like to learn more about reentrancy and alternative ways
2550  * to protect against it, check out our blog post
2551  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2552  */
2553 abstract contract ReentrancyGuard {
2554     // Booleans are more expensive than uint256 or any type that takes up a full
2555     // word because each write operation emits an extra SLOAD to first read the
2556     // slot's contents, replace the bits taken up by the boolean, and then write
2557     // back. This is the compiler's defense against contract upgrades and
2558     // pointer aliasing, and it cannot be disabled.
2559 
2560     // The values being non-zero value makes deployment a bit more expensive,
2561     // but in exchange the refund on every call to nonReentrant will be lower in
2562     // amount. Since refunds are capped to a percentage of the total
2563     // transaction's gas, it is best to keep them low in cases like this one, to
2564     // increase the likelihood of the full refund coming into effect.
2565     uint256 private constant _NOT_ENTERED = 1;
2566     uint256 private constant _ENTERED = 2;
2567 
2568     uint256 private _status;
2569 
2570     constructor() {
2571         _status = _NOT_ENTERED;
2572     }
2573 
2574     /**
2575      * @dev Prevents a contract from calling itself, directly or indirectly.
2576      * Calling a `nonReentrant` function from another `nonReentrant`
2577      * function is not supported. It is possible to prevent this from happening
2578      * by making the `nonReentrant` function external, and making it call a
2579      * `private` function that does the actual work.
2580      */
2581     modifier nonReentrant() {
2582         _nonReentrantBefore();
2583         _;
2584         _nonReentrantAfter();
2585     }
2586 
2587     function _nonReentrantBefore() private {
2588         // On the first call to nonReentrant, _status will be _NOT_ENTERED
2589         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2590 
2591         // Any calls to nonReentrant after this point will fail
2592         _status = _ENTERED;
2593     }
2594 
2595     function _nonReentrantAfter() private {
2596         // By storing the original value once again, a refund is triggered (see
2597         // https://eips.ethereum.org/EIPS/eip-2200)
2598         _status = _NOT_ENTERED;
2599     }
2600 }
2601 
2602 
2603 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.8.0
2604 
2605 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
2606 
2607 pragma solidity ^0.8.0;
2608 
2609 /**
2610  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
2611  *
2612  * These functions can be used to verify that a message was signed by the holder
2613  * of the private keys of a given address.
2614  */
2615 library ECDSA {
2616     enum RecoverError {
2617         NoError,
2618         InvalidSignature,
2619         InvalidSignatureLength,
2620         InvalidSignatureS,
2621         InvalidSignatureV // Deprecated in v4.8
2622     }
2623 
2624     function _throwError(RecoverError error) private pure {
2625         if (error == RecoverError.NoError) {
2626             return; // no error: do nothing
2627         } else if (error == RecoverError.InvalidSignature) {
2628             revert("ECDSA: invalid signature");
2629         } else if (error == RecoverError.InvalidSignatureLength) {
2630             revert("ECDSA: invalid signature length");
2631         } else if (error == RecoverError.InvalidSignatureS) {
2632             revert("ECDSA: invalid signature 's' value");
2633         }
2634     }
2635 
2636     /**
2637      * @dev Returns the address that signed a hashed message (`hash`) with
2638      * `signature` or error string. This address can then be used for verification purposes.
2639      *
2640      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
2641      * this function rejects them by requiring the `s` value to be in the lower
2642      * half order, and the `v` value to be either 27 or 28.
2643      *
2644      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
2645      * verification to be secure: it is possible to craft signatures that
2646      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
2647      * this is by receiving a hash of the original message (which may otherwise
2648      * be too long), and then calling {toEthSignedMessageHash} on it.
2649      *
2650      * Documentation for signature generation:
2651      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
2652      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
2653      *
2654      * _Available since v4.3._
2655      */
2656     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
2657         if (signature.length == 65) {
2658             bytes32 r;
2659             bytes32 s;
2660             uint8 v;
2661             // ecrecover takes the signature parameters, and the only way to get them
2662             // currently is to use assembly.
2663             /// @solidity memory-safe-assembly
2664             assembly {
2665                 r := mload(add(signature, 0x20))
2666                 s := mload(add(signature, 0x40))
2667                 v := byte(0, mload(add(signature, 0x60)))
2668             }
2669             return tryRecover(hash, v, r, s);
2670         } else {
2671             return (address(0), RecoverError.InvalidSignatureLength);
2672         }
2673     }
2674 
2675     /**
2676      * @dev Returns the address that signed a hashed message (`hash`) with
2677      * `signature`. This address can then be used for verification purposes.
2678      *
2679      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
2680      * this function rejects them by requiring the `s` value to be in the lower
2681      * half order, and the `v` value to be either 27 or 28.
2682      *
2683      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
2684      * verification to be secure: it is possible to craft signatures that
2685      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
2686      * this is by receiving a hash of the original message (which may otherwise
2687      * be too long), and then calling {toEthSignedMessageHash} on it.
2688      */
2689     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
2690         (address recovered, RecoverError error) = tryRecover(hash, signature);
2691         _throwError(error);
2692         return recovered;
2693     }
2694 
2695     /**
2696      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
2697      *
2698      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
2699      *
2700      * _Available since v4.3._
2701      */
2702     function tryRecover(
2703         bytes32 hash,
2704         bytes32 r,
2705         bytes32 vs
2706     ) internal pure returns (address, RecoverError) {
2707         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
2708         uint8 v = uint8((uint256(vs) >> 255) + 27);
2709         return tryRecover(hash, v, r, s);
2710     }
2711 
2712     /**
2713      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
2714      *
2715      * _Available since v4.2._
2716      */
2717     function recover(
2718         bytes32 hash,
2719         bytes32 r,
2720         bytes32 vs
2721     ) internal pure returns (address) {
2722         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
2723         _throwError(error);
2724         return recovered;
2725     }
2726 
2727     /**
2728      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
2729      * `r` and `s` signature fields separately.
2730      *
2731      * _Available since v4.3._
2732      */
2733     function tryRecover(
2734         bytes32 hash,
2735         uint8 v,
2736         bytes32 r,
2737         bytes32 s
2738     ) internal pure returns (address, RecoverError) {
2739         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
2740         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
2741         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
2742         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
2743         //
2744         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
2745         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
2746         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
2747         // these malleable signatures as well.
2748         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
2749             return (address(0), RecoverError.InvalidSignatureS);
2750         }
2751 
2752         // If the signature is valid (and not malleable), return the signer address
2753         address signer = ecrecover(hash, v, r, s);
2754         if (signer == address(0)) {
2755             return (address(0), RecoverError.InvalidSignature);
2756         }
2757 
2758         return (signer, RecoverError.NoError);
2759     }
2760 
2761     /**
2762      * @dev Overload of {ECDSA-recover} that receives the `v`,
2763      * `r` and `s` signature fields separately.
2764      */
2765     function recover(
2766         bytes32 hash,
2767         uint8 v,
2768         bytes32 r,
2769         bytes32 s
2770     ) internal pure returns (address) {
2771         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
2772         _throwError(error);
2773         return recovered;
2774     }
2775 
2776     /**
2777      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
2778      * produces hash corresponding to the one signed with the
2779      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
2780      * JSON-RPC method as part of EIP-191.
2781      *
2782      * See {recover}.
2783      */
2784     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
2785         // 32 is the length in bytes of hash,
2786         // enforced by the type signature above
2787         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
2788     }
2789 
2790     /**
2791      * @dev Returns an Ethereum Signed Message, created from `s`. This
2792      * produces hash corresponding to the one signed with the
2793      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
2794      * JSON-RPC method as part of EIP-191.
2795      *
2796      * See {recover}.
2797      */
2798     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
2799         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
2800     }
2801 
2802     /**
2803      * @dev Returns an Ethereum Signed Typed Data, created from a
2804      * `domainSeparator` and a `structHash`. This produces hash corresponding
2805      * to the one signed with the
2806      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
2807      * JSON-RPC method as part of EIP-712.
2808      *
2809      * See {recover}.
2810      */
2811     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
2812         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
2813     }
2814 }
2815 
2816 
2817 // File contracts/Alphazilla.sol
2818 
2819 pragma solidity ^0.8.16;
2820 
2821 
2822 
2823 
2824 
2825 
2826 
2827 
2828 
2829 
2830 contract Alphazilla is Ownable, ERC721A, ERC721AQueryable, RevokableDefaultOperatorFilterer, ERC721ABurnable, ReentrancyGuard {
2831     // metadata URI
2832     string private _baseTokenURI;
2833     uint256 public immutable maxPerAddressDuringMint;
2834     uint256 public collectionSize;
2835     uint256 public immutable maxBatchSize;
2836     uint256 public priceWei;
2837     address public signer;
2838 
2839 
2840     modifier callerIsUser() {
2841         require(tx.origin == msg.sender, "The caller is another contract");
2842         _;
2843     }
2844 
2845     constructor()
2846     ERC721A("Alphazilla", "AZL")
2847     RevokableDefaultOperatorFilterer()
2848     {
2849         maxBatchSize = 1;
2850         collectionSize = 1000;
2851         maxPerAddressDuringMint = 1000;
2852         priceWei = 0.04 ether;
2853     }
2854 
2855     /* Support OpenSea registry */
2856     function owner() public view virtual override (Ownable, UpdatableOperatorFilterer) returns (address) {
2857         return Ownable.owner();
2858     }
2859 
2860     function setApprovalForAll(address operator, bool approved) public override(ERC721A, IERC721A) onlyAllowedOperatorApproval(operator) {
2861         super.setApprovalForAll(operator, approved);
2862     }
2863 
2864     function approve(address operator, uint256 tokenId) public payable override(ERC721A, IERC721A) onlyAllowedOperatorApproval(operator) {
2865         super.approve(operator, tokenId);
2866     }
2867 
2868     function transferFrom(address from, address to, uint256 tokenId) public payable override(ERC721A, IERC721A) onlyAllowedOperator(from) {
2869         super.transferFrom(from, to, tokenId);
2870     }
2871 
2872     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override(ERC721A, IERC721A) onlyAllowedOperator(from) {
2873         super.safeTransferFrom(from, to, tokenId);
2874     }
2875 
2876     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2877         public
2878         payable
2879         override(ERC721A, IERC721A)
2880         onlyAllowedOperator(from)
2881     {
2882         super.safeTransferFrom(from, to, tokenId, data);
2883     }
2884 
2885     function version()
2886     public 
2887     pure 
2888     returns (string memory)
2889     {
2890         return "1.1.0";
2891     }
2892 
2893     function sudoUpdateSigner(
2894         address _signer
2895     )
2896     onlyOwner
2897     public
2898     {
2899         signer = _signer;
2900     }
2901 
2902     function sudoMint(
2903         address to,
2904         uint256 quantity 
2905     )
2906     external
2907     onlyOwner
2908     {
2909         require(
2910             totalSupply() + quantity <= collectionSize,
2911             "too many already minted before dev mint"
2912         );
2913         _safeMint(to, quantity);
2914     }
2915 
2916     function mint(
2917         uint256 quantity,
2918         bytes memory signature
2919     )
2920     external
2921     payable
2922     callerIsUser
2923     {
2924         require(totalSupply() + quantity <= collectionSize, "reached max supply");
2925         require(
2926             numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
2927             "can not mint this many"
2928         );
2929 
2930         bytes memory data = abi.encodePacked(
2931             AddressString.toAsciiString(msg.sender),
2932             ":",
2933             Strings.toString(block.chainid)
2934         );
2935         address _signer = ECDSA.recover(ECDSA.toEthSignedMessageHash(data), signature);
2936         require(_signer == signer, "wrong sig");
2937 
2938 
2939         _safeMint(msg.sender, quantity);
2940         refundIfOver(priceWei * quantity);
2941     }
2942 
2943     // URI
2944 
2945     /**
2946      * @dev See {IERC721Metadata-tokenURI}.
2947      */
2948     function tokenURI(uint256 tokenId) public view virtual override (ERC721A, IERC721A) returns (string memory) {
2949         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2950         string memory baseURI = _baseURI();
2951         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId), ".json")) : '';
2952     }
2953 
2954     function _baseURI()
2955     internal
2956     view
2957     virtual
2958     override
2959     returns (string memory)
2960     {
2961         return _baseTokenURI;
2962     }
2963 
2964     function setBaseURI(string calldata baseURI)
2965     external
2966     onlyOwner
2967     {
2968         _baseTokenURI = baseURI;
2969     }
2970 
2971     function refundIfOver(uint256 price)
2972     private
2973     {
2974         require(msg.value >= price, "Need to send more ETH.");
2975         if (msg.value > price) {
2976             payable(msg.sender).transfer(msg.value - price);
2977         }
2978     }
2979 
2980     function isSaleOn(uint256 _price, uint256 _startTime)
2981     public
2982     view
2983     returns (bool)
2984     {
2985         return _price != 0 && _startTime != 0 && block.timestamp >= _startTime;
2986     }
2987 
2988     function withdraw()
2989     external
2990     onlyOwner
2991     nonReentrant
2992     {
2993         (bool success, ) = msg.sender.call{value: address(this).balance}("");
2994         require(success, "Transfer failed.");
2995     }
2996 
2997     // TokenID
2998 
2999     function startTokenId()
3000     public
3001     view
3002     returns (uint256)
3003     {
3004         return _startTokenId();
3005     }
3006 
3007     function _startTokenId()
3008     internal
3009     override
3010     view
3011     virtual
3012     returns (uint256)
3013     {
3014         return 1;
3015     }
3016 
3017     // Misc
3018 
3019     function numberMinted(address owner)
3020     public
3021     view
3022     returns (uint256)
3023     {
3024         return _numberMinted(owner);
3025     }
3026 
3027     function getOwnershipData(uint256 tokenId)
3028     external
3029     view
3030     returns (TokenOwnership memory)
3031     {
3032         return _ownershipOf(tokenId);
3033     }
3034 
3035     function totalMinted()
3036     public
3037     view
3038     returns (uint256)
3039     {
3040         return _totalMinted();
3041     }
3042 }