1 // Sources flattened with hardhat v2.9.9 https://hardhat.org
2 
3 
4 /*
5  *
6  *    ________                                                              
7  *    `MMMMMMMb.                           68b                              
8  *     MM    `Mb                           Y89                              
9  *     MM     MM   _____   ___  __    __   ___ ___  __   ___   ___   ____   
10  *     MM     MM  6MMMMMb  `MM 6MMb  6MMb  `MM `MM 6MMb  `MM    MM  6MMMMb\ 
11  *     MM     MM 6M'   `Mb  MM69 `MM69 `Mb  MM  MMM9 `Mb  MM    MM MM'    ` 
12  *     MM     MM MM     MM  MM'   MM'   MM  MM  MM'   MM  MM    MM YM.      
13  *     MM     MM MM     MM  MM    MM    MM  MM  MM    MM  MM    MM  YMMMMb  
14  *     MM     MM MM     MM  MM    MM    MM  MM  MM    MM  MM    MM      `Mb 
15  *     MM    .M9 YM.   ,M9  MM    MM    MM  MM  MM    MM  YM.   MM L    ,MM 
16  *    _MMMMMMM9'  YMMMMM9  _MM_  _MM_  _MM__MM__MM_  _MM_  YMMM9MM_MYMMMM9   
17  *   
18  * #####################S?+:::::::::::::::::::::::::::::;?S#################@##
19  * ###################S%+:::::::::::::::::::::,,::::::::::+%S##################
20  * ##################S*:,:::::::,:;;;;;;;;;+++++;:,:::::::,:?S#################
21  * #################S+:::::::::;++;::::::::::::;+*+:,::::::::*S################
22  * ################S+:::::::::++;:::::::::::::::,:;*;:::::::::?S###############
23  * ###############S*:::::::::+;:::::::::::::::::::,:++::::::::;%S##############
24  * ###############%;::::::::+;:::::::::::::::::::::::++:::::::,*S##############
25  * ##############S?::::::::++:::::::::::::::::::::::::+;::::::,;S##############
26  * ##############S*::::::::+;:::::::::::::::::::::::::+;:::::::;%S#############
27  * ##############S?::::::::+;,::::::::,::::,::::::::::+;::::::,;%##############
28  * ##############S%;:::::::;+:::::::::+*****::::::::::+;::::::,+S##############
29  * ###############S*::::::::+;,::::::*#%*+?#?::::::,:+;::::::,:%S##############
30  * ###############S%+,::::::;*+:,::::S@@SS#@#;:::,,;++::::::::*S###############
31  * ################S%;,::::::;??;:,,:S#@@@@##;,,,:+?+::::::::*S################
32  * #################S%+::::::::*%?+:;%#@@@@#%+:;*?*;::::::,:*S#################
33  * #####S############SS?;,::::::;*%S%##@@#@##SS%?+::::::,:;%S##################
34  * ####################S%*;:,::::+S#@###########?;::::,:;?S####################
35  * #####################SS%?+:;*S#################?+:;+?SS#####################
36  * ######################SSSS%%%##################S%?%SSSS#####################
37  * #######################SSSS%#@@@@@#########@@#@#%%%SSSS#####SS##############
38  * ######################SSSSS#@@@@@#@@####@@#@##@@#%%SSSS#####################
39  * #####################SSSSS#@@@@@#@@@#@@#@@####@@@S%SSSSS####################
40  * #####################SSSSSS#@@@@#@@@@#@@@@##@#@@@#SSSSSS########S###########
41  * ####################SSSSSS###@@@#@@@@@@@@@@#@#@@@@#SSSSSSSSS#SSSSS##########
42  * #######SSSS######S#SSSSS####@@@@@@@@@@@@@@@@@@@@@##SSSSSSSSSSSSSSSS#########
43  * #######S#S###SSSSSSSSSS###S#@@@@@@@@@@@@@@@@@@@@@@####SSSSSSSSSSSSSSSS######
44  * #######SSSSSSSSSSSSS#S#@#SS#@@@@@@@@@@@@@@@@@@@@@@@S###SSSSSSSSSSSSSSSS#SSSS
45  * ##SSSSSSSSSSSS%%%SSS###SSSS#@@@@@@@@@@@@@@@@@@@@@@@#SS##SSSSSSSSSSSSSSSSSSSS
46  * SSSSSSSSSSSSSS%%SSSSS%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@S%SSSSSSSSSSSSSSSSSSSSS
47  * SSSSSSSS%SSSSS%%%%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@S%%SSSSSSSSSSSSSSSSSSS
48  * SSSSSSSSSSSSSSSS%%%%%%%%%%S@@@@@@@@@@@@@@@@@@@@@@@@@@@@S%%%SSSSSSS%%SSSSSSSS
49  * SSSSSSSSSSS%%%%%%%%%%%%%%%#@@@@@@@@@@@@@@@@@@@@@@@@@@##@#S%%%%%%%%%%%%%%%%%%
50  * SSSSSSSS%%%%%%%%%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@####S%%???%%%%%%%%%%%%
51  * %%%%%%%%%%%%%%%%%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#SS%%???????%%%%%%%%
52  * SS%%%S#@@@S%%%%%%%%%%%%%?%@@@@@@@@@@@@@@@@@@@@@#@@@###@@@@##SS%%%??????????*
53  * @@#S#@@@@@@%%%%%%%%%%%%%%#@@@@@@@@@@@@@@@@@@@@@#@@@%%%%%%SS#####SSS%???*****
54  * @@@@@@@@@@@SSSSS%%%%SSSS#@@@@@@@@@@@@@@@@@@@@@@#@@@SSS%%????%SSSS%%%??%%%S#@
55  * @@@@@@#@@@@@@@##SSSSSSSSSSSSSSSSS########SSSS%%%SSS%%%%%%%??*%S#@######S#@@@
56  * @@@@@@@@@@@@@@@@@#SS%%%%%%%%%%%%%%%%%%%%%????????********????S##SSSSS###@@@@
57  * @@@@@@@@@@@@@@@@@@@##S%?????????%%%%??????**************??%S#@@###@@@#@@@@@@
58  * @@@@@@@@@@@@@@@@@@@@@@@#S%%%??????*******************?%S##@@@@#S@@@####@@@@@
59  * @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@###SSSSSSSSSSSS####@@@@@@@@@######@@###@@@@@
60  * @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@####S@@@@@@@@@@@####
61 */
62 
63 
64 // File erc721a/contracts/IERC721A.sol@v4.1.0
65 
66 // SPDX-License-Identifier: MIT
67 // ERC721A Contracts v4.1.0
68 // Creator: Chiru Labs
69 
70 pragma solidity ^0.8.4;
71 
72 /**
73  * @dev Interface of an ERC721A compliant contract.
74  */
75 interface IERC721A {
76     /**
77      * The caller must own the token or be an approved operator.
78      */
79     error ApprovalCallerNotOwnerNorApproved();
80 
81     /**
82      * The token does not exist.
83      */
84     error ApprovalQueryForNonexistentToken();
85 
86     /**
87      * The caller cannot approve to their own address.
88      */
89     error ApproveToCaller();
90 
91     /**
92      * Cannot query the balance for the zero address.
93      */
94     error BalanceQueryForZeroAddress();
95 
96     /**
97      * Cannot mint to the zero address.
98      */
99     error MintToZeroAddress();
100 
101     /**
102      * The quantity of tokens minted must be more than zero.
103      */
104     error MintZeroQuantity();
105 
106     /**
107      * The token does not exist.
108      */
109     error OwnerQueryForNonexistentToken();
110 
111     /**
112      * The caller must own the token or be an approved operator.
113      */
114     error TransferCallerNotOwnerNorApproved();
115 
116     /**
117      * The token must be owned by `from`.
118      */
119     error TransferFromIncorrectOwner();
120 
121     /**
122      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
123      */
124     error TransferToNonERC721ReceiverImplementer();
125 
126     /**
127      * Cannot transfer to the zero address.
128      */
129     error TransferToZeroAddress();
130 
131     /**
132      * The token does not exist.
133      */
134     error URIQueryForNonexistentToken();
135 
136     /**
137      * The `quantity` minted with ERC2309 exceeds the safety limit.
138      */
139     error MintERC2309QuantityExceedsLimit();
140 
141     /**
142      * The `extraData` cannot be set on an unintialized ownership slot.
143      */
144     error OwnershipNotInitializedForExtraData();
145 
146     struct TokenOwnership {
147         // The address of the owner.
148         address addr;
149         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
150         uint64 startTimestamp;
151         // Whether the token has been burned.
152         bool burned;
153         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
154         uint24 extraData;
155     }
156 
157     /**
158      * @dev Returns the total amount of tokens stored by the contract.
159      *
160      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
161      */
162     function totalSupply() external view returns (uint256);
163 
164     // ==============================
165     //            IERC165
166     // ==============================
167 
168     /**
169      * @dev Returns true if this contract implements the interface defined by
170      * `interfaceId`. See the corresponding
171      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
172      * to learn more about how these ids are created.
173      *
174      * This function call must use less than 30 000 gas.
175      */
176     function supportsInterface(bytes4 interfaceId) external view returns (bool);
177 
178     // ==============================
179     //            IERC721
180     // ==============================
181 
182     /**
183      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
184      */
185     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
186 
187     /**
188      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
189      */
190     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
191 
192     /**
193      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
194      */
195     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
196 
197     /**
198      * @dev Returns the number of tokens in ``owner``'s account.
199      */
200     function balanceOf(address owner) external view returns (uint256 balance);
201 
202     /**
203      * @dev Returns the owner of the `tokenId` token.
204      *
205      * Requirements:
206      *
207      * - `tokenId` must exist.
208      */
209     function ownerOf(uint256 tokenId) external view returns (address owner);
210 
211     /**
212      * @dev Safely transfers `tokenId` token from `from` to `to`.
213      *
214      * Requirements:
215      *
216      * - `from` cannot be the zero address.
217      * - `to` cannot be the zero address.
218      * - `tokenId` token must exist and be owned by `from`.
219      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
220      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
221      *
222      * Emits a {Transfer} event.
223      */
224     function safeTransferFrom(
225         address from,
226         address to,
227         uint256 tokenId,
228         bytes calldata data
229     ) external;
230 
231     /**
232      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
233      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
234      *
235      * Requirements:
236      *
237      * - `from` cannot be the zero address.
238      * - `to` cannot be the zero address.
239      * - `tokenId` token must exist and be owned by `from`.
240      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
241      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
242      *
243      * Emits a {Transfer} event.
244      */
245     function safeTransferFrom(
246         address from,
247         address to,
248         uint256 tokenId
249     ) external;
250 
251     /**
252      * @dev Transfers `tokenId` token from `from` to `to`.
253      *
254      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
255      *
256      * Requirements:
257      *
258      * - `from` cannot be the zero address.
259      * - `to` cannot be the zero address.
260      * - `tokenId` token must be owned by `from`.
261      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
262      *
263      * Emits a {Transfer} event.
264      */
265     function transferFrom(
266         address from,
267         address to,
268         uint256 tokenId
269     ) external;
270 
271     /**
272      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
273      * The approval is cleared when the token is transferred.
274      *
275      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
276      *
277      * Requirements:
278      *
279      * - The caller must own the token or be an approved operator.
280      * - `tokenId` must exist.
281      *
282      * Emits an {Approval} event.
283      */
284     function approve(address to, uint256 tokenId) external;
285 
286     /**
287      * @dev Approve or remove `operator` as an operator for the caller.
288      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
289      *
290      * Requirements:
291      *
292      * - The `operator` cannot be the caller.
293      *
294      * Emits an {ApprovalForAll} event.
295      */
296     function setApprovalForAll(address operator, bool _approved) external;
297 
298     /**
299      * @dev Returns the account approved for `tokenId` token.
300      *
301      * Requirements:
302      *
303      * - `tokenId` must exist.
304      */
305     function getApproved(uint256 tokenId) external view returns (address operator);
306 
307     /**
308      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
309      *
310      * See {setApprovalForAll}
311      */
312     function isApprovedForAll(address owner, address operator) external view returns (bool);
313 
314     // ==============================
315     //        IERC721Metadata
316     // ==============================
317 
318     /**
319      * @dev Returns the token collection name.
320      */
321     function name() external view returns (string memory);
322 
323     /**
324      * @dev Returns the token collection symbol.
325      */
326     function symbol() external view returns (string memory);
327 
328     /**
329      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
330      */
331     function tokenURI(uint256 tokenId) external view returns (string memory);
332 
333     // ==============================
334     //            IERC2309
335     // ==============================
336 
337     /**
338      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
339      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
340      */
341     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
342 }
343 
344 
345 // File erc721a/contracts/ERC721A.sol@v4.1.0
346 
347 // ERC721A Contracts v4.1.0
348 // Creator: Chiru Labs
349 
350 pragma solidity ^0.8.4;
351 
352 /**
353  * @dev ERC721 token receiver interface.
354  */
355 interface ERC721A__IERC721Receiver {
356     function onERC721Received(
357         address operator,
358         address from,
359         uint256 tokenId,
360         bytes calldata data
361     ) external returns (bytes4);
362 }
363 
364 /**
365  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
366  * including the Metadata extension. Built to optimize for lower gas during batch mints.
367  *
368  * Assumes serials are sequentially minted starting at `_startTokenId()`
369  * (defaults to 0, e.g. 0, 1, 2, 3..).
370  *
371  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
372  *
373  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
374  */
375 contract ERC721A is IERC721A {
376     // Mask of an entry in packed address data.
377     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
378 
379     // The bit position of `numberMinted` in packed address data.
380     uint256 private constant BITPOS_NUMBER_MINTED = 64;
381 
382     // The bit position of `numberBurned` in packed address data.
383     uint256 private constant BITPOS_NUMBER_BURNED = 128;
384 
385     // The bit position of `aux` in packed address data.
386     uint256 private constant BITPOS_AUX = 192;
387 
388     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
389     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
390 
391     // The bit position of `startTimestamp` in packed ownership.
392     uint256 private constant BITPOS_START_TIMESTAMP = 160;
393 
394     // The bit mask of the `burned` bit in packed ownership.
395     uint256 private constant BITMASK_BURNED = 1 << 224;
396 
397     // The bit position of the `nextInitialized` bit in packed ownership.
398     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
399 
400     // The bit mask of the `nextInitialized` bit in packed ownership.
401     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
402 
403     // The bit position of `extraData` in packed ownership.
404     uint256 private constant BITPOS_EXTRA_DATA = 232;
405 
406     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
407     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
408 
409     // The mask of the lower 160 bits for addresses.
410     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
411 
412     // The maximum `quantity` that can be minted with `_mintERC2309`.
413     // This limit is to prevent overflows on the address data entries.
414     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
415     // is required to cause an overflow, which is unrealistic.
416     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
417 
418     // The tokenId of the next token to be minted.
419     uint256 private _currentIndex;
420 
421     // The number of tokens burned.
422     uint256 private _burnCounter;
423 
424     // Token name
425     string private _name;
426 
427     // Token symbol
428     string private _symbol;
429 
430     // Mapping from token ID to ownership details
431     // An empty struct value does not necessarily mean the token is unowned.
432     // See `_packedOwnershipOf` implementation for details.
433     //
434     // Bits Layout:
435     // - [0..159]   `addr`
436     // - [160..223] `startTimestamp`
437     // - [224]      `burned`
438     // - [225]      `nextInitialized`
439     // - [232..255] `extraData`
440     mapping(uint256 => uint256) private _packedOwnerships;
441 
442     // Mapping owner address to address data.
443     //
444     // Bits Layout:
445     // - [0..63]    `balance`
446     // - [64..127]  `numberMinted`
447     // - [128..191] `numberBurned`
448     // - [192..255] `aux`
449     mapping(address => uint256) private _packedAddressData;
450 
451     // Mapping from token ID to approved address.
452     mapping(uint256 => address) private _tokenApprovals;
453 
454     // Mapping from owner to operator approvals
455     mapping(address => mapping(address => bool)) private _operatorApprovals;
456 
457     constructor(string memory name_, string memory symbol_) {
458         _name = name_;
459         _symbol = symbol_;
460         _currentIndex = _startTokenId();
461     }
462 
463     /**
464      * @dev Returns the starting token ID.
465      * To change the starting token ID, please override this function.
466      */
467     function _startTokenId() internal view virtual returns (uint256) {
468         return 0;
469     }
470 
471     /**
472      * @dev Returns the next token ID to be minted.
473      */
474     function _nextTokenId() internal view returns (uint256) {
475         return _currentIndex;
476     }
477 
478     /**
479      * @dev Returns the total number of tokens in existence.
480      * Burned tokens will reduce the count.
481      * To get the total number of tokens minted, please see `_totalMinted`.
482      */
483     function totalSupply() public view override returns (uint256) {
484         // Counter underflow is impossible as _burnCounter cannot be incremented
485         // more than `_currentIndex - _startTokenId()` times.
486         unchecked {
487             return _currentIndex - _burnCounter - _startTokenId();
488         }
489     }
490 
491     /**
492      * @dev Returns the total amount of tokens minted in the contract.
493      */
494     function _totalMinted() internal view returns (uint256) {
495         // Counter underflow is impossible as _currentIndex does not decrement,
496         // and it is initialized to `_startTokenId()`
497         unchecked {
498             return _currentIndex - _startTokenId();
499         }
500     }
501 
502     /**
503      * @dev Returns the total number of tokens burned.
504      */
505     function _totalBurned() internal view returns (uint256) {
506         return _burnCounter;
507     }
508 
509     /**
510      * @dev See {IERC165-supportsInterface}.
511      */
512     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
513         // The interface IDs are constants representing the first 4 bytes of the XOR of
514         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
515         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
516         return
517             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
518             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
519             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
520     }
521 
522     /**
523      * @dev See {IERC721-balanceOf}.
524      */
525     function balanceOf(address owner) public view override returns (uint256) {
526         if (owner == address(0)) revert BalanceQueryForZeroAddress();
527         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
528     }
529 
530     /**
531      * Returns the number of tokens minted by `owner`.
532      */
533     function _numberMinted(address owner) internal view returns (uint256) {
534         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
535     }
536 
537     /**
538      * Returns the number of tokens burned by or on behalf of `owner`.
539      */
540     function _numberBurned(address owner) internal view returns (uint256) {
541         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
542     }
543 
544     /**
545      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
546      */
547     function _getAux(address owner) internal view returns (uint64) {
548         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
549     }
550 
551     /**
552      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
553      * If there are multiple variables, please pack them into a uint64.
554      */
555     function _setAux(address owner, uint64 aux) internal {
556         uint256 packed = _packedAddressData[owner];
557         uint256 auxCasted;
558         // Cast `aux` with assembly to avoid redundant masking.
559         assembly {
560             auxCasted := aux
561         }
562         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
563         _packedAddressData[owner] = packed;
564     }
565 
566     /**
567      * Returns the packed ownership data of `tokenId`.
568      */
569     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
570         uint256 curr = tokenId;
571 
572         unchecked {
573             if (_startTokenId() <= curr)
574                 if (curr < _currentIndex) {
575                     uint256 packed = _packedOwnerships[curr];
576                     // If not burned.
577                     if (packed & BITMASK_BURNED == 0) {
578                         // Invariant:
579                         // There will always be an ownership that has an address and is not burned
580                         // before an ownership that does not have an address and is not burned.
581                         // Hence, curr will not underflow.
582                         //
583                         // We can directly compare the packed value.
584                         // If the address is zero, packed is zero.
585                         while (packed == 0) {
586                             packed = _packedOwnerships[--curr];
587                         }
588                         return packed;
589                     }
590                 }
591         }
592         revert OwnerQueryForNonexistentToken();
593     }
594 
595     /**
596      * Returns the unpacked `TokenOwnership` struct from `packed`.
597      */
598     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
599         ownership.addr = address(uint160(packed));
600         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
601         ownership.burned = packed & BITMASK_BURNED != 0;
602         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
603     }
604 
605     /**
606      * Returns the unpacked `TokenOwnership` struct at `index`.
607      */
608     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
609         return _unpackedOwnership(_packedOwnerships[index]);
610     }
611 
612     /**
613      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
614      */
615     function _initializeOwnershipAt(uint256 index) internal {
616         if (_packedOwnerships[index] == 0) {
617             _packedOwnerships[index] = _packedOwnershipOf(index);
618         }
619     }
620 
621     /**
622      * Gas spent here starts off proportional to the maximum mint batch size.
623      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
624      */
625     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
626         return _unpackedOwnership(_packedOwnershipOf(tokenId));
627     }
628 
629     /**
630      * @dev Packs ownership data into a single uint256.
631      */
632     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
633         assembly {
634             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
635             owner := and(owner, BITMASK_ADDRESS)
636             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
637             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
638         }
639     }
640 
641     /**
642      * @dev See {IERC721-ownerOf}.
643      */
644     function ownerOf(uint256 tokenId) public view override returns (address) {
645         return address(uint160(_packedOwnershipOf(tokenId)));
646     }
647 
648     /**
649      * @dev See {IERC721Metadata-name}.
650      */
651     function name() public view virtual override returns (string memory) {
652         return _name;
653     }
654 
655     /**
656      * @dev See {IERC721Metadata-symbol}.
657      */
658     function symbol() public view virtual override returns (string memory) {
659         return _symbol;
660     }
661 
662     /**
663      * @dev See {IERC721Metadata-tokenURI}.
664      */
665     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
666         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
667 
668         string memory baseURI = _baseURI();
669         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
670     }
671 
672     /**
673      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
674      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
675      * by default, it can be overridden in child contracts.
676      */
677     function _baseURI() internal view virtual returns (string memory) {
678         return '';
679     }
680 
681     /**
682      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
683      */
684     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
685         // For branchless setting of the `nextInitialized` flag.
686         assembly {
687             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
688             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
689         }
690     }
691 
692     /**
693      * @dev See {IERC721-approve}.
694      */
695     function approve(address to, uint256 tokenId) public override {
696         address owner = ownerOf(tokenId);
697 
698         if (_msgSenderERC721A() != owner)
699             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
700                 revert ApprovalCallerNotOwnerNorApproved();
701             }
702 
703         _tokenApprovals[tokenId] = to;
704         emit Approval(owner, to, tokenId);
705     }
706 
707     /**
708      * @dev See {IERC721-getApproved}.
709      */
710     function getApproved(uint256 tokenId) public view override returns (address) {
711         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
712 
713         return _tokenApprovals[tokenId];
714     }
715 
716     /**
717      * @dev See {IERC721-setApprovalForAll}.
718      */
719     function setApprovalForAll(address operator, bool approved) public virtual override {
720         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
721 
722         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
723         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
724     }
725 
726     /**
727      * @dev See {IERC721-isApprovedForAll}.
728      */
729     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
730         return _operatorApprovals[owner][operator];
731     }
732 
733     /**
734      * @dev See {IERC721-safeTransferFrom}.
735      */
736     function safeTransferFrom(
737         address from,
738         address to,
739         uint256 tokenId
740     ) public virtual override {
741         safeTransferFrom(from, to, tokenId, '');
742     }
743 
744     /**
745      * @dev See {IERC721-safeTransferFrom}.
746      */
747     function safeTransferFrom(
748         address from,
749         address to,
750         uint256 tokenId,
751         bytes memory _data
752     ) public virtual override {
753         transferFrom(from, to, tokenId);
754         if (to.code.length != 0)
755             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
756                 revert TransferToNonERC721ReceiverImplementer();
757             }
758     }
759 
760     /**
761      * @dev Returns whether `tokenId` exists.
762      *
763      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
764      *
765      * Tokens start existing when they are minted (`_mint`),
766      */
767     function _exists(uint256 tokenId) internal view returns (bool) {
768         return
769             _startTokenId() <= tokenId &&
770             tokenId < _currentIndex && // If within bounds,
771             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
772     }
773 
774     /**
775      * @dev Equivalent to `_safeMint(to, quantity, '')`.
776      */
777     function _safeMint(address to, uint256 quantity) internal {
778         _safeMint(to, quantity, '');
779     }
780 
781     /**
782      * @dev Safely mints `quantity` tokens and transfers them to `to`.
783      *
784      * Requirements:
785      *
786      * - If `to` refers to a smart contract, it must implement
787      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
788      * - `quantity` must be greater than 0.
789      *
790      * See {_mint}.
791      *
792      * Emits a {Transfer} event for each mint.
793      */
794     function _safeMint(
795         address to,
796         uint256 quantity,
797         bytes memory _data
798     ) internal {
799         _mint(to, quantity);
800 
801         unchecked {
802             if (to.code.length != 0) {
803                 uint256 end = _currentIndex;
804                 uint256 index = end - quantity;
805                 do {
806                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
807                         revert TransferToNonERC721ReceiverImplementer();
808                     }
809                 } while (index < end);
810                 // Reentrancy protection.
811                 if (_currentIndex != end) revert();
812             }
813         }
814     }
815 
816     /**
817      * @dev Mints `quantity` tokens and transfers them to `to`.
818      *
819      * Requirements:
820      *
821      * - `to` cannot be the zero address.
822      * - `quantity` must be greater than 0.
823      *
824      * Emits a {Transfer} event for each mint.
825      */
826     function _mint(address to, uint256 quantity) internal {
827         uint256 startTokenId = _currentIndex;
828         if (to == address(0)) revert MintToZeroAddress();
829         if (quantity == 0) revert MintZeroQuantity();
830 
831         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
832 
833         // Overflows are incredibly unrealistic.
834         // `balance` and `numberMinted` have a maximum limit of 2**64.
835         // `tokenId` has a maximum limit of 2**256.
836         unchecked {
837             // Updates:
838             // - `balance += quantity`.
839             // - `numberMinted += quantity`.
840             //
841             // We can directly add to the `balance` and `numberMinted`.
842             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
843 
844             // Updates:
845             // - `address` to the owner.
846             // - `startTimestamp` to the timestamp of minting.
847             // - `burned` to `false`.
848             // - `nextInitialized` to `quantity == 1`.
849             _packedOwnerships[startTokenId] = _packOwnershipData(
850                 to,
851                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
852             );
853 
854             uint256 tokenId = startTokenId;
855             uint256 end = startTokenId + quantity;
856             do {
857                 emit Transfer(address(0), to, tokenId++);
858             } while (tokenId < end);
859 
860             _currentIndex = end;
861         }
862         _afterTokenTransfers(address(0), to, startTokenId, quantity);
863     }
864 
865     /**
866      * @dev Mints `quantity` tokens and transfers them to `to`.
867      *
868      * This function is intended for efficient minting only during contract creation.
869      *
870      * It emits only one {ConsecutiveTransfer} as defined in
871      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
872      * instead of a sequence of {Transfer} event(s).
873      *
874      * Calling this function outside of contract creation WILL make your contract
875      * non-compliant with the ERC721 standard.
876      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
877      * {ConsecutiveTransfer} event is only permissible during contract creation.
878      *
879      * Requirements:
880      *
881      * - `to` cannot be the zero address.
882      * - `quantity` must be greater than 0.
883      *
884      * Emits a {ConsecutiveTransfer} event.
885      */
886     function _mintERC2309(address to, uint256 quantity) internal {
887         uint256 startTokenId = _currentIndex;
888         if (to == address(0)) revert MintToZeroAddress();
889         if (quantity == 0) revert MintZeroQuantity();
890         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
891 
892         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
893 
894         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
895         unchecked {
896             // Updates:
897             // - `balance += quantity`.
898             // - `numberMinted += quantity`.
899             //
900             // We can directly add to the `balance` and `numberMinted`.
901             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
902 
903             // Updates:
904             // - `address` to the owner.
905             // - `startTimestamp` to the timestamp of minting.
906             // - `burned` to `false`.
907             // - `nextInitialized` to `quantity == 1`.
908             _packedOwnerships[startTokenId] = _packOwnershipData(
909                 to,
910                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
911             );
912 
913             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
914 
915             _currentIndex = startTokenId + quantity;
916         }
917         _afterTokenTransfers(address(0), to, startTokenId, quantity);
918     }
919 
920     /**
921      * @dev Returns the storage slot and value for the approved address of `tokenId`.
922      */
923     function _getApprovedAddress(uint256 tokenId)
924         private
925         view
926         returns (uint256 approvedAddressSlot, address approvedAddress)
927     {
928         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
929         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
930         assembly {
931             // Compute the slot.
932             mstore(0x00, tokenId)
933             mstore(0x20, tokenApprovalsPtr.slot)
934             approvedAddressSlot := keccak256(0x00, 0x40)
935             // Load the slot's value from storage.
936             approvedAddress := sload(approvedAddressSlot)
937         }
938     }
939 
940     /**
941      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
942      */
943     function _isOwnerOrApproved(
944         address approvedAddress,
945         address from,
946         address msgSender
947     ) private pure returns (bool result) {
948         assembly {
949             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
950             from := and(from, BITMASK_ADDRESS)
951             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
952             msgSender := and(msgSender, BITMASK_ADDRESS)
953             // `msgSender == from || msgSender == approvedAddress`.
954             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
955         }
956     }
957 
958     /**
959      * @dev Transfers `tokenId` from `from` to `to`.
960      *
961      * Requirements:
962      *
963      * - `to` cannot be the zero address.
964      * - `tokenId` token must be owned by `from`.
965      *
966      * Emits a {Transfer} event.
967      */
968     function transferFrom(
969         address from,
970         address to,
971         uint256 tokenId
972     ) public virtual override {
973         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
974 
975         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
976 
977         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
978 
979         // The nested ifs save around 20+ gas over a compound boolean condition.
980         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
981             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
982 
983         if (to == address(0)) revert TransferToZeroAddress();
984 
985         _beforeTokenTransfers(from, to, tokenId, 1);
986 
987         // Clear approvals from the previous owner.
988         assembly {
989             if approvedAddress {
990                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
991                 sstore(approvedAddressSlot, 0)
992             }
993         }
994 
995         // Underflow of the sender's balance is impossible because we check for
996         // ownership above and the recipient's balance can't realistically overflow.
997         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
998         unchecked {
999             // We can directly increment and decrement the balances.
1000             --_packedAddressData[from]; // Updates: `balance -= 1`.
1001             ++_packedAddressData[to]; // Updates: `balance += 1`.
1002 
1003             // Updates:
1004             // - `address` to the next owner.
1005             // - `startTimestamp` to the timestamp of transfering.
1006             // - `burned` to `false`.
1007             // - `nextInitialized` to `true`.
1008             _packedOwnerships[tokenId] = _packOwnershipData(
1009                 to,
1010                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1011             );
1012 
1013             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1014             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1015                 uint256 nextTokenId = tokenId + 1;
1016                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1017                 if (_packedOwnerships[nextTokenId] == 0) {
1018                     // If the next slot is within bounds.
1019                     if (nextTokenId != _currentIndex) {
1020                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1021                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1022                     }
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
1049         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1050 
1051         address from = address(uint160(prevOwnershipPacked));
1052 
1053         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1054 
1055         if (approvalCheck) {
1056             // The nested ifs save around 20+ gas over a compound boolean condition.
1057             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1058                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1059         }
1060 
1061         _beforeTokenTransfers(from, address(0), tokenId, 1);
1062 
1063         // Clear approvals from the previous owner.
1064         assembly {
1065             if approvedAddress {
1066                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1067                 sstore(approvedAddressSlot, 0)
1068             }
1069         }
1070 
1071         // Underflow of the sender's balance is impossible because we check for
1072         // ownership above and the recipient's balance can't realistically overflow.
1073         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1074         unchecked {
1075             // Updates:
1076             // - `balance -= 1`.
1077             // - `numberBurned += 1`.
1078             //
1079             // We can directly decrement the balance, and increment the number burned.
1080             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1081             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1082 
1083             // Updates:
1084             // - `address` to the last owner.
1085             // - `startTimestamp` to the timestamp of burning.
1086             // - `burned` to `true`.
1087             // - `nextInitialized` to `true`.
1088             _packedOwnerships[tokenId] = _packOwnershipData(
1089                 from,
1090                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1091             );
1092 
1093             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1094             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1095                 uint256 nextTokenId = tokenId + 1;
1096                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1097                 if (_packedOwnerships[nextTokenId] == 0) {
1098                     // If the next slot is within bounds.
1099                     if (nextTokenId != _currentIndex) {
1100                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1101                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1102                     }
1103                 }
1104             }
1105         }
1106 
1107         emit Transfer(from, address(0), tokenId);
1108         _afterTokenTransfers(from, address(0), tokenId, 1);
1109 
1110         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1111         unchecked {
1112             _burnCounter++;
1113         }
1114     }
1115 
1116     /**
1117      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1118      *
1119      * @param from address representing the previous owner of the given token ID
1120      * @param to target address that will receive the tokens
1121      * @param tokenId uint256 ID of the token to be transferred
1122      * @param _data bytes optional data to send along with the call
1123      * @return bool whether the call correctly returned the expected magic value
1124      */
1125     function _checkContractOnERC721Received(
1126         address from,
1127         address to,
1128         uint256 tokenId,
1129         bytes memory _data
1130     ) private returns (bool) {
1131         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1132             bytes4 retval
1133         ) {
1134             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1135         } catch (bytes memory reason) {
1136             if (reason.length == 0) {
1137                 revert TransferToNonERC721ReceiverImplementer();
1138             } else {
1139                 assembly {
1140                     revert(add(32, reason), mload(reason))
1141                 }
1142             }
1143         }
1144     }
1145 
1146     /**
1147      * @dev Directly sets the extra data for the ownership data `index`.
1148      */
1149     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1150         uint256 packed = _packedOwnerships[index];
1151         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1152         uint256 extraDataCasted;
1153         // Cast `extraData` with assembly to avoid redundant masking.
1154         assembly {
1155             extraDataCasted := extraData
1156         }
1157         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1158         _packedOwnerships[index] = packed;
1159     }
1160 
1161     /**
1162      * @dev Returns the next extra data for the packed ownership data.
1163      * The returned result is shifted into position.
1164      */
1165     function _nextExtraData(
1166         address from,
1167         address to,
1168         uint256 prevOwnershipPacked
1169     ) private view returns (uint256) {
1170         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1171         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1172     }
1173 
1174     /**
1175      * @dev Called during each token transfer to set the 24bit `extraData` field.
1176      * Intended to be overridden by the cosumer contract.
1177      *
1178      * `previousExtraData` - the value of `extraData` before transfer.
1179      *
1180      * Calling conditions:
1181      *
1182      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1183      * transferred to `to`.
1184      * - When `from` is zero, `tokenId` will be minted for `to`.
1185      * - When `to` is zero, `tokenId` will be burned by `from`.
1186      * - `from` and `to` are never both zero.
1187      */
1188     function _extraData(
1189         address from,
1190         address to,
1191         uint24 previousExtraData
1192     ) internal view virtual returns (uint24) {}
1193 
1194     /**
1195      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1196      * This includes minting.
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
1218      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1219      * This includes minting.
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
1239 
1240     /**
1241      * @dev Returns the message sender (defaults to `msg.sender`).
1242      *
1243      * If you are writing GSN compatible contracts, you need to override this function.
1244      */
1245     function _msgSenderERC721A() internal view virtual returns (address) {
1246         return msg.sender;
1247     }
1248 
1249     /**
1250      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1251      */
1252     function _toString(uint256 value) internal pure returns (string memory ptr) {
1253         assembly {
1254             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1255             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1256             // We will need 1 32-byte word to store the length,
1257             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1258             ptr := add(mload(0x40), 128)
1259             // Update the free memory pointer to allocate.
1260             mstore(0x40, ptr)
1261 
1262             // Cache the end of the memory to calculate the length later.
1263             let end := ptr
1264 
1265             // We write the string from the rightmost digit to the leftmost digit.
1266             // The following is essentially a do-while loop that also handles the zero case.
1267             // Costs a bit more than early returning for the zero case,
1268             // but cheaper in terms of deployment and overall runtime costs.
1269             for {
1270                 // Initialize and perform the first pass without check.
1271                 let temp := value
1272                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1273                 ptr := sub(ptr, 1)
1274                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1275                 mstore8(ptr, add(48, mod(temp, 10)))
1276                 temp := div(temp, 10)
1277             } temp {
1278                 // Keep dividing `temp` until zero.
1279                 temp := div(temp, 10)
1280             } {
1281                 // Body of the for loop.
1282                 ptr := sub(ptr, 1)
1283                 mstore8(ptr, add(48, mod(temp, 10)))
1284             }
1285 
1286             let length := sub(end, ptr)
1287             // Move the pointer 32 bytes leftwards to make room for the length.
1288             ptr := sub(ptr, 32)
1289             // Store the length.
1290             mstore(ptr, length)
1291         }
1292     }
1293 }
1294 
1295 
1296 // File erc721a/contracts/extensions/IERC721ABurnable.sol@v4.1.0
1297 
1298 // ERC721A Contracts v4.1.0
1299 // Creator: Chiru Labs
1300 
1301 pragma solidity ^0.8.4;
1302 
1303 /**
1304  * @dev Interface of an ERC721ABurnable compliant contract.
1305  */
1306 interface IERC721ABurnable is IERC721A {
1307     /**
1308      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1309      *
1310      * Requirements:
1311      *
1312      * - The caller must own `tokenId` or be an approved operator.
1313      */
1314     function burn(uint256 tokenId) external;
1315 }
1316 
1317 
1318 // File erc721a/contracts/extensions/ERC721ABurnable.sol@v4.1.0
1319 
1320 // ERC721A Contracts v4.1.0
1321 // Creator: Chiru Labs
1322 
1323 pragma solidity ^0.8.4;
1324 
1325 
1326 /**
1327  * @title ERC721A Burnable Token
1328  * @dev ERC721A Token that can be irreversibly burned (destroyed).
1329  */
1330 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
1331     /**
1332      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1333      *
1334      * Requirements:
1335      *
1336      * - The caller must own `tokenId` or be an approved operator.
1337      */
1338     function burn(uint256 tokenId) public virtual override {
1339         _burn(tokenId, true);
1340     }
1341 }
1342 
1343 
1344 // File erc721a/contracts/extensions/IERC721AQueryable.sol@v4.1.0
1345 
1346 // ERC721A Contracts v4.1.0
1347 // Creator: Chiru Labs
1348 
1349 pragma solidity ^0.8.4;
1350 
1351 /**
1352  * @dev Interface of an ERC721AQueryable compliant contract.
1353  */
1354 interface IERC721AQueryable is IERC721A {
1355     /**
1356      * Invalid query range (`start` >= `stop`).
1357      */
1358     error InvalidQueryRange();
1359 
1360     /**
1361      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1362      *
1363      * If the `tokenId` is out of bounds:
1364      *   - `addr` = `address(0)`
1365      *   - `startTimestamp` = `0`
1366      *   - `burned` = `false`
1367      *
1368      * If the `tokenId` is burned:
1369      *   - `addr` = `<Address of owner before token was burned>`
1370      *   - `startTimestamp` = `<Timestamp when token was burned>`
1371      *   - `burned = `true`
1372      *
1373      * Otherwise:
1374      *   - `addr` = `<Address of owner>`
1375      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1376      *   - `burned = `false`
1377      */
1378     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1379 
1380     /**
1381      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1382      * See {ERC721AQueryable-explicitOwnershipOf}
1383      */
1384     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1385 
1386     /**
1387      * @dev Returns an array of token IDs owned by `owner`,
1388      * in the range [`start`, `stop`)
1389      * (i.e. `start <= tokenId < stop`).
1390      *
1391      * This function allows for tokens to be queried if the collection
1392      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1393      *
1394      * Requirements:
1395      *
1396      * - `start` < `stop`
1397      */
1398     function tokensOfOwnerIn(
1399         address owner,
1400         uint256 start,
1401         uint256 stop
1402     ) external view returns (uint256[] memory);
1403 
1404     /**
1405      * @dev Returns an array of token IDs owned by `owner`.
1406      *
1407      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1408      * It is meant to be called off-chain.
1409      *
1410      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1411      * multiple smaller scans if the collection is large enough to cause
1412      * an out-of-gas error (10K pfp collections should be fine).
1413      */
1414     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1415 }
1416 
1417 
1418 // File erc721a/contracts/extensions/ERC721AQueryable.sol@v4.1.0
1419 
1420 // ERC721A Contracts v4.1.0
1421 // Creator: Chiru Labs
1422 
1423 pragma solidity ^0.8.4;
1424 
1425 
1426 /**
1427  * @title ERC721A Queryable
1428  * @dev ERC721A subclass with convenience query functions.
1429  */
1430 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1431     /**
1432      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1433      *
1434      * If the `tokenId` is out of bounds:
1435      *   - `addr` = `address(0)`
1436      *   - `startTimestamp` = `0`
1437      *   - `burned` = `false`
1438      *   - `extraData` = `0`
1439      *
1440      * If the `tokenId` is burned:
1441      *   - `addr` = `<Address of owner before token was burned>`
1442      *   - `startTimestamp` = `<Timestamp when token was burned>`
1443      *   - `burned = `true`
1444      *   - `extraData` = `<Extra data when token was burned>`
1445      *
1446      * Otherwise:
1447      *   - `addr` = `<Address of owner>`
1448      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1449      *   - `burned = `false`
1450      *   - `extraData` = `<Extra data at start of ownership>`
1451      */
1452     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1453         TokenOwnership memory ownership;
1454         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1455             return ownership;
1456         }
1457         ownership = _ownershipAt(tokenId);
1458         if (ownership.burned) {
1459             return ownership;
1460         }
1461         return _ownershipOf(tokenId);
1462     }
1463 
1464     /**
1465      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1466      * See {ERC721AQueryable-explicitOwnershipOf}
1467      */
1468     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1469         unchecked {
1470             uint256 tokenIdsLength = tokenIds.length;
1471             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1472             for (uint256 i; i != tokenIdsLength; ++i) {
1473                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1474             }
1475             return ownerships;
1476         }
1477     }
1478 
1479     /**
1480      * @dev Returns an array of token IDs owned by `owner`,
1481      * in the range [`start`, `stop`)
1482      * (i.e. `start <= tokenId < stop`).
1483      *
1484      * This function allows for tokens to be queried if the collection
1485      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1486      *
1487      * Requirements:
1488      *
1489      * - `start` < `stop`
1490      */
1491     function tokensOfOwnerIn(
1492         address owner,
1493         uint256 start,
1494         uint256 stop
1495     ) external view override returns (uint256[] memory) {
1496         unchecked {
1497             if (start >= stop) revert InvalidQueryRange();
1498             uint256 tokenIdsIdx;
1499             uint256 stopLimit = _nextTokenId();
1500             // Set `start = max(start, _startTokenId())`.
1501             if (start < _startTokenId()) {
1502                 start = _startTokenId();
1503             }
1504             // Set `stop = min(stop, stopLimit)`.
1505             if (stop > stopLimit) {
1506                 stop = stopLimit;
1507             }
1508             uint256 tokenIdsMaxLength = balanceOf(owner);
1509             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1510             // to cater for cases where `balanceOf(owner)` is too big.
1511             if (start < stop) {
1512                 uint256 rangeLength = stop - start;
1513                 if (rangeLength < tokenIdsMaxLength) {
1514                     tokenIdsMaxLength = rangeLength;
1515                 }
1516             } else {
1517                 tokenIdsMaxLength = 0;
1518             }
1519             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1520             if (tokenIdsMaxLength == 0) {
1521                 return tokenIds;
1522             }
1523             // We need to call `explicitOwnershipOf(start)`,
1524             // because the slot at `start` may not be initialized.
1525             TokenOwnership memory ownership = explicitOwnershipOf(start);
1526             address currOwnershipAddr;
1527             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1528             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1529             if (!ownership.burned) {
1530                 currOwnershipAddr = ownership.addr;
1531             }
1532             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1533                 ownership = _ownershipAt(i);
1534                 if (ownership.burned) {
1535                     continue;
1536                 }
1537                 if (ownership.addr != address(0)) {
1538                     currOwnershipAddr = ownership.addr;
1539                 }
1540                 if (currOwnershipAddr == owner) {
1541                     tokenIds[tokenIdsIdx++] = i;
1542                 }
1543             }
1544             // Downsize the array to fit.
1545             assembly {
1546                 mstore(tokenIds, tokenIdsIdx)
1547             }
1548             return tokenIds;
1549         }
1550     }
1551 
1552     /**
1553      * @dev Returns an array of token IDs owned by `owner`.
1554      *
1555      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1556      * It is meant to be called off-chain.
1557      *
1558      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1559      * multiple smaller scans if the collection is large enough to cause
1560      * an out-of-gas error (10K pfp collections should be fine).
1561      */
1562     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1563         unchecked {
1564             uint256 tokenIdsIdx;
1565             address currOwnershipAddr;
1566             uint256 tokenIdsLength = balanceOf(owner);
1567             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1568             TokenOwnership memory ownership;
1569             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1570                 ownership = _ownershipAt(i);
1571                 if (ownership.burned) {
1572                     continue;
1573                 }
1574                 if (ownership.addr != address(0)) {
1575                     currOwnershipAddr = ownership.addr;
1576                 }
1577                 if (currOwnershipAddr == owner) {
1578                     tokenIds[tokenIdsIdx++] = i;
1579                 }
1580             }
1581             return tokenIds;
1582         }
1583     }
1584 }
1585 
1586 
1587 // File @openzeppelin/contracts/utils/Strings.sol@v4.6.0
1588 
1589 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1590 
1591 pragma solidity ^0.8.0;
1592 
1593 /**
1594  * @dev String operations.
1595  */
1596 library Strings {
1597     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1598 
1599     /**
1600      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1601      */
1602     function toString(uint256 value) internal pure returns (string memory) {
1603         // Inspired by OraclizeAPI's implementation - MIT licence
1604         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1605 
1606         if (value == 0) {
1607             return "0";
1608         }
1609         uint256 temp = value;
1610         uint256 digits;
1611         while (temp != 0) {
1612             digits++;
1613             temp /= 10;
1614         }
1615         bytes memory buffer = new bytes(digits);
1616         while (value != 0) {
1617             digits -= 1;
1618             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1619             value /= 10;
1620         }
1621         return string(buffer);
1622     }
1623 
1624     /**
1625      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1626      */
1627     function toHexString(uint256 value) internal pure returns (string memory) {
1628         if (value == 0) {
1629             return "0x00";
1630         }
1631         uint256 temp = value;
1632         uint256 length = 0;
1633         while (temp != 0) {
1634             length++;
1635             temp >>= 8;
1636         }
1637         return toHexString(value, length);
1638     }
1639 
1640     /**
1641      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1642      */
1643     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1644         bytes memory buffer = new bytes(2 * length + 2);
1645         buffer[0] = "0";
1646         buffer[1] = "x";
1647         for (uint256 i = 2 * length + 1; i > 1; --i) {
1648             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1649             value >>= 4;
1650         }
1651         require(value == 0, "Strings: hex length insufficient");
1652         return string(buffer);
1653     }
1654 }
1655 
1656 
1657 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.6.0
1658 
1659 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
1660 
1661 pragma solidity ^0.8.0;
1662 
1663 /**
1664  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1665  *
1666  * These functions can be used to verify that a message was signed by the holder
1667  * of the private keys of a given address.
1668  */
1669 library ECDSA {
1670     enum RecoverError {
1671         NoError,
1672         InvalidSignature,
1673         InvalidSignatureLength,
1674         InvalidSignatureS,
1675         InvalidSignatureV
1676     }
1677 
1678     function _throwError(RecoverError error) private pure {
1679         if (error == RecoverError.NoError) {
1680             return; // no error: do nothing
1681         } else if (error == RecoverError.InvalidSignature) {
1682             revert("ECDSA: invalid signature");
1683         } else if (error == RecoverError.InvalidSignatureLength) {
1684             revert("ECDSA: invalid signature length");
1685         } else if (error == RecoverError.InvalidSignatureS) {
1686             revert("ECDSA: invalid signature 's' value");
1687         } else if (error == RecoverError.InvalidSignatureV) {
1688             revert("ECDSA: invalid signature 'v' value");
1689         }
1690     }
1691 
1692     /**
1693      * @dev Returns the address that signed a hashed message (`hash`) with
1694      * `signature` or error string. This address can then be used for verification purposes.
1695      *
1696      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1697      * this function rejects them by requiring the `s` value to be in the lower
1698      * half order, and the `v` value to be either 27 or 28.
1699      *
1700      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1701      * verification to be secure: it is possible to craft signatures that
1702      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1703      * this is by receiving a hash of the original message (which may otherwise
1704      * be too long), and then calling {toEthSignedMessageHash} on it.
1705      *
1706      * Documentation for signature generation:
1707      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1708      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1709      *
1710      * _Available since v4.3._
1711      */
1712     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1713         // Check the signature length
1714         // - case 65: r,s,v signature (standard)
1715         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1716         if (signature.length == 65) {
1717             bytes32 r;
1718             bytes32 s;
1719             uint8 v;
1720             // ecrecover takes the signature parameters, and the only way to get them
1721             // currently is to use assembly.
1722             assembly {
1723                 r := mload(add(signature, 0x20))
1724                 s := mload(add(signature, 0x40))
1725                 v := byte(0, mload(add(signature, 0x60)))
1726             }
1727             return tryRecover(hash, v, r, s);
1728         } else if (signature.length == 64) {
1729             bytes32 r;
1730             bytes32 vs;
1731             // ecrecover takes the signature parameters, and the only way to get them
1732             // currently is to use assembly.
1733             assembly {
1734                 r := mload(add(signature, 0x20))
1735                 vs := mload(add(signature, 0x40))
1736             }
1737             return tryRecover(hash, r, vs);
1738         } else {
1739             return (address(0), RecoverError.InvalidSignatureLength);
1740         }
1741     }
1742 
1743     /**
1744      * @dev Returns the address that signed a hashed message (`hash`) with
1745      * `signature`. This address can then be used for verification purposes.
1746      *
1747      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1748      * this function rejects them by requiring the `s` value to be in the lower
1749      * half order, and the `v` value to be either 27 or 28.
1750      *
1751      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1752      * verification to be secure: it is possible to craft signatures that
1753      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1754      * this is by receiving a hash of the original message (which may otherwise
1755      * be too long), and then calling {toEthSignedMessageHash} on it.
1756      */
1757     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1758         (address recovered, RecoverError error) = tryRecover(hash, signature);
1759         _throwError(error);
1760         return recovered;
1761     }
1762 
1763     /**
1764      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1765      *
1766      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1767      *
1768      * _Available since v4.3._
1769      */
1770     function tryRecover(
1771         bytes32 hash,
1772         bytes32 r,
1773         bytes32 vs
1774     ) internal pure returns (address, RecoverError) {
1775         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1776         uint8 v = uint8((uint256(vs) >> 255) + 27);
1777         return tryRecover(hash, v, r, s);
1778     }
1779 
1780     /**
1781      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1782      *
1783      * _Available since v4.2._
1784      */
1785     function recover(
1786         bytes32 hash,
1787         bytes32 r,
1788         bytes32 vs
1789     ) internal pure returns (address) {
1790         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1791         _throwError(error);
1792         return recovered;
1793     }
1794 
1795     /**
1796      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1797      * `r` and `s` signature fields separately.
1798      *
1799      * _Available since v4.3._
1800      */
1801     function tryRecover(
1802         bytes32 hash,
1803         uint8 v,
1804         bytes32 r,
1805         bytes32 s
1806     ) internal pure returns (address, RecoverError) {
1807         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1808         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1809         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1810         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1811         //
1812         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1813         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1814         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1815         // these malleable signatures as well.
1816         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1817             return (address(0), RecoverError.InvalidSignatureS);
1818         }
1819         if (v != 27 && v != 28) {
1820             return (address(0), RecoverError.InvalidSignatureV);
1821         }
1822 
1823         // If the signature is valid (and not malleable), return the signer address
1824         address signer = ecrecover(hash, v, r, s);
1825         if (signer == address(0)) {
1826             return (address(0), RecoverError.InvalidSignature);
1827         }
1828 
1829         return (signer, RecoverError.NoError);
1830     }
1831 
1832     /**
1833      * @dev Overload of {ECDSA-recover} that receives the `v`,
1834      * `r` and `s` signature fields separately.
1835      */
1836     function recover(
1837         bytes32 hash,
1838         uint8 v,
1839         bytes32 r,
1840         bytes32 s
1841     ) internal pure returns (address) {
1842         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1843         _throwError(error);
1844         return recovered;
1845     }
1846 
1847     /**
1848      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1849      * produces hash corresponding to the one signed with the
1850      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1851      * JSON-RPC method as part of EIP-191.
1852      *
1853      * See {recover}.
1854      */
1855     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1856         // 32 is the length in bytes of hash,
1857         // enforced by the type signature above
1858         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1859     }
1860 
1861     /**
1862      * @dev Returns an Ethereum Signed Message, created from `s`. This
1863      * produces hash corresponding to the one signed with the
1864      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1865      * JSON-RPC method as part of EIP-191.
1866      *
1867      * See {recover}.
1868      */
1869     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1870         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1871     }
1872 
1873     /**
1874      * @dev Returns an Ethereum Signed Typed Data, created from a
1875      * `domainSeparator` and a `structHash`. This produces hash corresponding
1876      * to the one signed with the
1877      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1878      * JSON-RPC method as part of EIP-712.
1879      *
1880      * See {recover}.
1881      */
1882     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1883         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1884     }
1885 }
1886 
1887 
1888 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
1889 
1890 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1891 
1892 pragma solidity ^0.8.0;
1893 
1894 /**
1895  * @dev Provides information about the current execution context, including the
1896  * sender of the transaction and its data. While these are generally available
1897  * via msg.sender and msg.data, they should not be accessed in such a direct
1898  * manner, since when dealing with meta-transactions the account sending and
1899  * paying for execution may not be the actual sender (as far as an application
1900  * is concerned).
1901  *
1902  * This contract is only required for intermediate, library-like contracts.
1903  */
1904 abstract contract Context {
1905     function _msgSender() internal view virtual returns (address) {
1906         return msg.sender;
1907     }
1908 
1909     function _msgData() internal view virtual returns (bytes calldata) {
1910         return msg.data;
1911     }
1912 }
1913 
1914 
1915 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
1916 
1917 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1918 
1919 pragma solidity ^0.8.0;
1920 
1921 /**
1922  * @dev Contract module which provides a basic access control mechanism, where
1923  * there is an account (an owner) that can be granted exclusive access to
1924  * specific functions.
1925  *
1926  * By default, the owner account will be the one that deploys the contract. This
1927  * can later be changed with {transferOwnership}.
1928  *
1929  * This module is used through inheritance. It will make available the modifier
1930  * `onlyOwner`, which can be applied to your functions to restrict their use to
1931  * the owner.
1932  */
1933 abstract contract Ownable is Context {
1934     address private _owner;
1935 
1936     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1937 
1938     /**
1939      * @dev Initializes the contract setting the deployer as the initial owner.
1940      */
1941     constructor() {
1942         _transferOwnership(_msgSender());
1943     }
1944 
1945     /**
1946      * @dev Returns the address of the current owner.
1947      */
1948     function owner() public view virtual returns (address) {
1949         return _owner;
1950     }
1951 
1952     /**
1953      * @dev Throws if called by any account other than the owner.
1954      */
1955     modifier onlyOwner() {
1956         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1957         _;
1958     }
1959 
1960     /**
1961      * @dev Leaves the contract without owner. It will not be possible to call
1962      * `onlyOwner` functions anymore. Can only be called by the current owner.
1963      *
1964      * NOTE: Renouncing ownership will leave the contract without an owner,
1965      * thereby removing any functionality that is only available to the owner.
1966      */
1967     function renounceOwnership() public virtual onlyOwner {
1968         _transferOwnership(address(0));
1969     }
1970 
1971     /**
1972      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1973      * Can only be called by the current owner.
1974      */
1975     function transferOwnership(address newOwner) public virtual onlyOwner {
1976         require(newOwner != address(0), "Ownable: new owner is the zero address");
1977         _transferOwnership(newOwner);
1978     }
1979 
1980     /**
1981      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1982      * Internal function without access restriction.
1983      */
1984     function _transferOwnership(address newOwner) internal virtual {
1985         address oldOwner = _owner;
1986         _owner = newOwner;
1987         emit OwnershipTransferred(oldOwner, newOwner);
1988     }
1989 }
1990 
1991 
1992 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.6.0
1993 
1994 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1995 
1996 pragma solidity ^0.8.0;
1997 
1998 /**
1999  * @dev Contract module that helps prevent reentrant calls to a function.
2000  *
2001  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2002  * available, which can be applied to functions to make sure there are no nested
2003  * (reentrant) calls to them.
2004  *
2005  * Note that because there is a single `nonReentrant` guard, functions marked as
2006  * `nonReentrant` may not call one another. This can be worked around by making
2007  * those functions `private`, and then adding `external` `nonReentrant` entry
2008  * points to them.
2009  *
2010  * TIP: If you would like to learn more about reentrancy and alternative ways
2011  * to protect against it, check out our blog post
2012  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2013  */
2014 abstract contract ReentrancyGuard {
2015     // Booleans are more expensive than uint256 or any type that takes up a full
2016     // word because each write operation emits an extra SLOAD to first read the
2017     // slot's contents, replace the bits taken up by the boolean, and then write
2018     // back. This is the compiler's defense against contract upgrades and
2019     // pointer aliasing, and it cannot be disabled.
2020 
2021     // The values being non-zero value makes deployment a bit more expensive,
2022     // but in exchange the refund on every call to nonReentrant will be lower in
2023     // amount. Since refunds are capped to a percentage of the total
2024     // transaction's gas, it is best to keep them low in cases like this one, to
2025     // increase the likelihood of the full refund coming into effect.
2026     uint256 private constant _NOT_ENTERED = 1;
2027     uint256 private constant _ENTERED = 2;
2028 
2029     uint256 private _status;
2030 
2031     constructor() {
2032         _status = _NOT_ENTERED;
2033     }
2034 
2035     /**
2036      * @dev Prevents a contract from calling itself, directly or indirectly.
2037      * Calling a `nonReentrant` function from another `nonReentrant`
2038      * function is not supported. It is possible to prevent this from happening
2039      * by making the `nonReentrant` function external, and making it call a
2040      * `private` function that does the actual work.
2041      */
2042     modifier nonReentrant() {
2043         // On the first call to nonReentrant, _notEntered will be true
2044         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2045 
2046         // Any calls to nonReentrant after this point will fail
2047         _status = _ENTERED;
2048 
2049         _;
2050 
2051         // By storing the original value once again, a refund is triggered (see
2052         // https://eips.ethereum.org/EIPS/eip-2200)
2053         _status = _NOT_ENTERED;
2054     }
2055 }
2056 
2057 
2058 // File contracts/library/AddressString.sol
2059 
2060 
2061 pragma solidity >=0.5.0;
2062 
2063 library AddressString {
2064     // converts an address to the uppercase hex string, extracting only len bytes (up to 20, multiple of 2)
2065     function toAsciiString(address addr) internal pure returns (string memory) {
2066         bytes memory s = new bytes(42);
2067         uint160 addrNum = uint160(addr);
2068         s[0] = '0';
2069         s[1] = 'X';
2070         for (uint256 i = 0; i < 40 / 2; i++) {
2071             // shift right and truncate all but the least significant byte to extract the byte at position 19-i
2072             uint8 b = uint8(addrNum >> (8 * (19 - i)));
2073             // first hex character is the most significant 4 bits
2074             uint8 hi = b >> 4;
2075             // second hex character is the least significant 4 bits
2076             uint8 lo = b - (hi << 4);
2077             s[2 * i + 2] = char(hi);
2078             s[2 * i + 3] = char(lo);
2079         }
2080         return string(s);
2081     }
2082 
2083     // hi and lo are only 4 bits and between 0 and 16
2084     // this method converts those values to the unicode/ascii code point for the hex representation
2085     // uses upper case for the characters
2086     function char(uint8 b) private pure returns (bytes1 c) {
2087         if (b < 10) {
2088             return bytes1(b + 0x30);
2089         } else {
2090             return bytes1(b + 0x37);
2091         }
2092     }
2093 }
2094 
2095 
2096 // File contracts/Dominus.sol
2097 
2098 pragma solidity ^0.8.17;
2099 
2100 contract Dominus is Ownable, ERC721A, ERC721AQueryable, ERC721ABurnable, ReentrancyGuard {
2101     // metadata URI
2102     string private _baseTokenURI;
2103     uint256 public immutable maxPerAddressDuringMint;
2104     uint256 public collectionSize;
2105     uint256 public immutable maxBatchSize;
2106     uint256 public priceWei;
2107     address public signer;
2108 
2109 
2110     modifier callerIsUser() {
2111         require(tx.origin == msg.sender, "The caller is another contract");
2112         _;
2113     }
2114 
2115     constructor()
2116     ERC721A("Dominus", "DOMINUS")
2117     {
2118         maxBatchSize = 1;
2119         collectionSize = 1000 + 100 + 10 + 1;
2120         maxPerAddressDuringMint = 2;
2121         priceWei = 0.099 ether;
2122     }
2123 
2124     function version()
2125     public 
2126     pure 
2127     returns (string memory)
2128     {
2129         return "1.0.0";
2130     }
2131 
2132     function sudoUpdateSigner(
2133         address _signer
2134     )
2135     onlyOwner
2136     public
2137     {
2138         signer = _signer;
2139     }
2140 
2141     function sudoMint(
2142         address to,
2143         uint256 quantity 
2144     )
2145     external
2146     onlyOwner
2147     {
2148         require(
2149             totalSupply() + quantity <= collectionSize,
2150             "too many already minted before dev mint"
2151         );
2152         _safeMint(to, quantity);
2153     }
2154 
2155     function mint(
2156         uint256 quantity,
2157         bytes memory signature
2158     )
2159     external
2160     payable
2161     callerIsUser
2162     {
2163         require(totalSupply() + quantity <= collectionSize, "reached max supply");
2164         require(
2165             numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
2166             "can not mint this many"
2167         );
2168 
2169         bytes memory data = abi.encodePacked(
2170             AddressString.toAsciiString(msg.sender),
2171             ":",
2172             Strings.toString(block.chainid)
2173         );
2174         address _signer = ECDSA.recover(ECDSA.toEthSignedMessageHash(data), signature);
2175         require(_signer == signer, "wrong sig");
2176 
2177 
2178         _safeMint(msg.sender, quantity);
2179         refundIfOver(priceWei * quantity);
2180     }
2181 
2182     // URI
2183 
2184     /**
2185      * @dev See {IERC721Metadata-tokenURI}.
2186      */
2187     function tokenURI(uint256 tokenId) public view virtual override (ERC721A, IERC721A) returns (string memory) {
2188         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2189         string memory baseURI = _baseURI();
2190         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId), ".json")) : '';
2191     }
2192 
2193     function _baseURI()
2194     internal
2195     view
2196     virtual
2197     override
2198     returns (string memory)
2199     {
2200         return _baseTokenURI;
2201     }
2202 
2203     function setBaseURI(string calldata baseURI)
2204     external
2205     onlyOwner
2206     {
2207         _baseTokenURI = baseURI;
2208     }
2209 
2210     function refundIfOver(uint256 price)
2211     private
2212     {
2213         require(msg.value >= price, "Need to send more ETH.");
2214         if (msg.value > price) {
2215             payable(msg.sender).transfer(msg.value - price);
2216         }
2217     }
2218 
2219     function isSaleOn(uint256 _price, uint256 _startTime)
2220     public
2221     view
2222     returns (bool)
2223     {
2224         return _price != 0 && _startTime != 0 && block.timestamp >= _startTime;
2225     }
2226 
2227     function withdraw()
2228     external
2229     onlyOwner
2230     nonReentrant
2231     {
2232         (bool success, ) = msg.sender.call{value: address(this).balance}("");
2233         require(success, "Transfer failed.");
2234     }
2235 
2236     // TokenID
2237 
2238     function startTokenId()
2239     public
2240     view
2241     returns (uint256)
2242     {
2243         return _startTokenId();
2244     }
2245 
2246     function _startTokenId()
2247     internal
2248     override
2249     view
2250     virtual
2251     returns (uint256)
2252     {
2253         return 1;
2254     }
2255 
2256     // Misc
2257 
2258     function numberMinted(address owner)
2259     public
2260     view
2261     returns (uint256)
2262     {
2263         return _numberMinted(owner);
2264     }
2265 
2266     function getOwnershipData(uint256 tokenId)
2267     external
2268     view
2269     returns (TokenOwnership memory)
2270     {
2271         return _ownershipOf(tokenId);
2272     }
2273 
2274     function totalMinted()
2275     public
2276     view
2277     returns (uint256)
2278     {
2279         return _totalMinted();
2280     }
2281 }