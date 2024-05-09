1 // SPDX-License-Identifier: MIT
2 
3 //░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
4 //░░░░░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
5 //░░░░░░░░░░░░░░░░▐███████████▄▄▄▄█████████████████████▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
6 //░░░░░░░░░░░░░░░░███░░░░░░░▀███████▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀███████████████████▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
7 //░░░░░░░░░░░░░░░▐██▄░░░░░░░░██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██▌░░░░▀▀▀████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
8 //░░░░░░░░░░░░░░░░█████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█▌░░░░░░░░░██▌░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
9 //░░░░░░░░░░░░░░░░████▀▀▀▀▀█████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▐█▌░░░░▄▄▄████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
10 //░░░░░░░░░░░░░░░███░░░░░░░░░▐███████████████████████████████████████████▀░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
11 //░░░░░░░░░░░░░░░███▄░░░░░░░░███▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
12 //░░░░░░░░░░░░░░░░██████▄▄▄████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
13 //░░░░░░░░░░░░░░░░░░▀▀███████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
14 //░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
15 //░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
16 //░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
17 //░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
18 
19 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
20 
21 
22 // ERC721A Contracts v3.3.0
23 // Creator: Chiru Labs
24 
25 pragma solidity ^0.8.4;
26 
27 /**
28  * @dev Interface of an ERC721A compliant contract.
29  */
30 interface IERC721A {
31     /**
32      * The caller must own the token or be an approved operator.
33      */
34     error ApprovalCallerNotOwnerNorApproved();
35 
36     /**
37      * The token does not exist.
38      */
39     error ApprovalQueryForNonexistentToken();
40 
41     /**
42      * The caller cannot approve to their own address.
43      */
44     error ApproveToCaller();
45 
46     /**
47      * The caller cannot approve to the current owner.
48      */
49     error ApprovalToCurrentOwner();
50 
51     /**
52      * Cannot query the balance for the zero address.
53      */
54     error BalanceQueryForZeroAddress();
55 
56     /**
57      * Cannot mint to the zero address.
58      */
59     error MintToZeroAddress();
60 
61     /**
62      * The quantity of tokens minted must be more than zero.
63      */
64     error MintZeroQuantity();
65 
66     /**
67      * The token does not exist.
68      */
69     error OwnerQueryForNonexistentToken();
70 
71     /**
72      * The caller must own the token or be an approved operator.
73      */
74     error TransferCallerNotOwnerNorApproved();
75 
76     /**
77      * The token must be owned by `from`.
78      */
79     error TransferFromIncorrectOwner();
80 
81     /**
82      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
83      */
84     error TransferToNonERC721ReceiverImplementer();
85 
86     /**
87      * Cannot transfer to the zero address.
88      */
89     error TransferToZeroAddress();
90 
91     /**
92      * The token does not exist.
93      */
94     error URIQueryForNonexistentToken();
95 
96     struct TokenOwnership {
97         // The address of the owner.
98         address addr;
99         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
100         uint64 startTimestamp;
101         // Whether the token has been burned.
102         bool burned;
103     }
104 
105     /**
106      * @dev Returns the total amount of tokens stored by the contract.
107      *
108      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
109      */
110     function totalSupply() external view returns (uint256);
111 
112     // ==============================
113     //            IERC165
114     // ==============================
115 
116     /**
117      * @dev Returns true if this contract implements the interface defined by
118      * `interfaceId`. See the corresponding
119      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
120      * to learn more about how these ids are created.
121      *
122      * This function call must use less than 30 000 gas.
123      */
124     function supportsInterface(bytes4 interfaceId) external view returns (bool);
125 
126     // ==============================
127     //            IERC721
128     // ==============================
129 
130     /**
131      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
132      */
133     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
134 
135     /**
136      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
137      */
138     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
139 
140     /**
141      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
142      */
143     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
144 
145     /**
146      * @dev Returns the number of tokens in ``owner``'s account.
147      */
148     function balanceOf(address owner) external view returns (uint256 balance);
149 
150     /**
151      * @dev Returns the owner of the `tokenId` token.
152      *
153      * Requirements:
154      *
155      * - `tokenId` must exist.
156      */
157     function ownerOf(uint256 tokenId) external view returns (address owner);
158 
159     /**
160      * @dev Safely transfers `tokenId` token from `from` to `to`.
161      *
162      * Requirements:
163      *
164      * - `from` cannot be the zero address.
165      * - `to` cannot be the zero address.
166      * - `tokenId` token must exist and be owned by `from`.
167      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
168      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
169      *
170      * Emits a {Transfer} event.
171      */
172     function safeTransferFrom(
173         address from,
174         address to,
175         uint256 tokenId,
176         bytes calldata data
177     ) external;
178 
179     /**
180      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
181      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
182      *
183      * Requirements:
184      *
185      * - `from` cannot be the zero address.
186      * - `to` cannot be the zero address.
187      * - `tokenId` token must exist and be owned by `from`.
188      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
189      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
190      *
191      * Emits a {Transfer} event.
192      */
193     function safeTransferFrom(
194         address from,
195         address to,
196         uint256 tokenId
197     ) external;
198 
199     /**
200      * @dev Transfers `tokenId` token from `from` to `to`.
201      *
202      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
203      *
204      * Requirements:
205      *
206      * - `from` cannot be the zero address.
207      * - `to` cannot be the zero address.
208      * - `tokenId` token must be owned by `from`.
209      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
210      *
211      * Emits a {Transfer} event.
212      */
213     function transferFrom(
214         address from,
215         address to,
216         uint256 tokenId
217     ) external;
218 
219     /**
220      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
221      * The approval is cleared when the token is transferred.
222      *
223      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
224      *
225      * Requirements:
226      *
227      * - The caller must own the token or be an approved operator.
228      * - `tokenId` must exist.
229      *
230      * Emits an {Approval} event.
231      */
232     function approve(address to, uint256 tokenId) external;
233 
234     /**
235      * @dev Approve or remove `operator` as an operator for the caller.
236      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
237      *
238      * Requirements:
239      *
240      * - The `operator` cannot be the caller.
241      *
242      * Emits an {ApprovalForAll} event.
243      */
244     function setApprovalForAll(address operator, bool _approved) external;
245 
246     /**
247      * @dev Returns the account approved for `tokenId` token.
248      *
249      * Requirements:
250      *
251      * - `tokenId` must exist.
252      */
253     function getApproved(uint256 tokenId) external view returns (address operator);
254 
255     /**
256      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
257      *
258      * See {setApprovalForAll}
259      */
260     function isApprovedForAll(address owner, address operator) external view returns (bool);
261 
262     // ==============================
263     //        IERC721Metadata
264     // ==============================
265 
266     /**
267      * @dev Returns the token collection name.
268      */
269     function name() external view returns (string memory);
270 
271     /**
272      * @dev Returns the token collection symbol.
273      */
274     function symbol() external view returns (string memory);
275 
276     /**
277      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
278      */
279     function tokenURI(uint256 tokenId) external view returns (string memory);
280 }
281 
282 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
283 
284 
285 // ERC721A Contracts v3.3.0
286 // Creator: Chiru Labs
287 
288 pragma solidity ^0.8.4;
289 
290 
291 /**
292  * @dev ERC721 token receiver interface.
293  */
294 interface ERC721A__IERC721Receiver {
295     function onERC721Received(
296         address operator,
297         address from,
298         uint256 tokenId,
299         bytes calldata data
300     ) external returns (bytes4);
301 }
302 
303 /**
304  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
305  * the Metadata extension. Built to optimize for lower gas during batch mints.
306  *
307  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
308  *
309  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
310  *
311  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
312  */
313 contract ERC721A is IERC721A {
314     // Mask of an entry in packed address data.
315     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
316 
317     // The bit position of `numberMinted` in packed address data.
318     uint256 private constant BITPOS_NUMBER_MINTED = 64;
319 
320     // The bit position of `numberBurned` in packed address data.
321     uint256 private constant BITPOS_NUMBER_BURNED = 128;
322 
323     // The bit position of `aux` in packed address data.
324     uint256 private constant BITPOS_AUX = 192;
325 
326     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
327     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
328 
329     // The bit position of `startTimestamp` in packed ownership.
330     uint256 private constant BITPOS_START_TIMESTAMP = 160;
331 
332     // The bit mask of the `burned` bit in packed ownership.
333     uint256 private constant BITMASK_BURNED = 1 << 224;
334     
335     // The bit position of the `nextInitialized` bit in packed ownership.
336     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
337 
338     // The bit mask of the `nextInitialized` bit in packed ownership.
339     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
340 
341     // The tokenId of the next token to be minted.
342     uint256 private _currentIndex;
343 
344     // The number of tokens burned.
345     uint256 private _burnCounter;
346 
347     // Token name
348     string private _name;
349 
350     // Token symbol
351     string private _symbol;
352 
353     // Mapping from token ID to ownership details
354     // An empty struct value does not necessarily mean the token is unowned.
355     // See `_packedOwnershipOf` implementation for details.
356     //
357     // Bits Layout:
358     // - [0..159]   `addr`
359     // - [160..223] `startTimestamp`
360     // - [224]      `burned`
361     // - [225]      `nextInitialized`
362     mapping(uint256 => uint256) private _packedOwnerships;
363 
364     // Mapping owner address to address data.
365     //
366     // Bits Layout:
367     // - [0..63]    `balance`
368     // - [64..127]  `numberMinted`
369     // - [128..191] `numberBurned`
370     // - [192..255] `aux`
371     mapping(address => uint256) private _packedAddressData;
372 
373     // Mapping from token ID to approved address.
374     mapping(uint256 => address) private _tokenApprovals;
375 
376     // Mapping from owner to operator approvals
377     mapping(address => mapping(address => bool)) private _operatorApprovals;
378 
379     constructor(string memory name_, string memory symbol_) {
380         _name = name_;
381         _symbol = symbol_;
382         _currentIndex = _startTokenId();
383     }
384 
385     /**
386      * @dev Returns the starting token ID. 
387      * To change the starting token ID, please override this function.
388      */
389     function _startTokenId() internal view virtual returns (uint256) {
390         return 1;
391     }
392 
393     /**
394      * @dev Returns the next token ID to be minted.
395      */
396     function _nextTokenId() internal view returns (uint256) {
397         return _currentIndex;
398     }
399 
400     /**
401      * @dev Returns the total number of tokens in existence.
402      * Burned tokens will reduce the count. 
403      * To get the total number of tokens minted, please see `_totalMinted`.
404      */
405     function totalSupply() public view override returns (uint256) {
406         // Counter underflow is impossible as _burnCounter cannot be incremented
407         // more than `_currentIndex - _startTokenId()` times.
408         unchecked {
409             return _currentIndex - _burnCounter - _startTokenId();
410         }
411     }
412 
413     /**
414      * @dev Returns the total amount of tokens minted in the contract.
415      */
416     function _totalMinted() internal view returns (uint256) {
417         // Counter underflow is impossible as _currentIndex does not decrement,
418         // and it is initialized to `_startTokenId()`
419         unchecked {
420             return _currentIndex - _startTokenId();
421         }
422     }
423 
424     /**
425      * @dev Returns the total number of tokens burned.
426      */
427     function _totalBurned() internal view returns (uint256) {
428         return _burnCounter;
429     }
430 
431     /**
432      * @dev See {IERC165-supportsInterface}.
433      */
434     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
435         // The interface IDs are constants representing the first 4 bytes of the XOR of
436         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
437         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
438         return
439             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
440             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
441             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
442     }
443 
444     /**
445      * @dev See {IERC721-balanceOf}.
446      */
447     function balanceOf(address owner) public view override returns (uint256) {
448         if (owner == address(0)) revert BalanceQueryForZeroAddress();
449         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
450     }
451 
452     /**
453      * Returns the number of tokens minted by `owner`.
454      */
455     function _numberMinted(address owner) internal view returns (uint256) {
456         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
457     }
458 
459     /**
460      * Returns the number of tokens burned by or on behalf of `owner`.
461      */
462     function _numberBurned(address owner) internal view returns (uint256) {
463         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
464     }
465 
466     /**
467      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
468      */
469     function _getAux(address owner) internal view returns (uint64) {
470         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
471     }
472 
473     /**
474      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
475      * If there are multiple variables, please pack them into a uint64.
476      */
477     function _setAux(address owner, uint64 aux) internal {
478         uint256 packed = _packedAddressData[owner];
479         uint256 auxCasted;
480         assembly { // Cast aux without masking.
481             auxCasted := aux
482         }
483         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
484         _packedAddressData[owner] = packed;
485     }
486 
487     /**
488      * Returns the packed ownership data of `tokenId`.
489      */
490     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
491         uint256 curr = tokenId;
492 
493         unchecked {
494             if (_startTokenId() <= curr)
495                 if (curr < _currentIndex) {
496                     uint256 packed = _packedOwnerships[curr];
497                     // If not burned.
498                     if (packed & BITMASK_BURNED == 0) {
499                         // Invariant:
500                         // There will always be an ownership that has an address and is not burned
501                         // before an ownership that does not have an address and is not burned.
502                         // Hence, curr will not underflow.
503                         //
504                         // We can directly compare the packed value.
505                         // If the address is zero, packed is zero.
506                         while (packed == 0) {
507                             packed = _packedOwnerships[--curr];
508                         }
509                         return packed;
510                     }
511                 }
512         }
513         revert OwnerQueryForNonexistentToken();
514     }
515 
516     /**
517      * Returns the unpacked `TokenOwnership` struct from `packed`.
518      */
519     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
520         ownership.addr = address(uint160(packed));
521         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
522         ownership.burned = packed & BITMASK_BURNED != 0;
523     }
524 
525     /**
526      * Returns the unpacked `TokenOwnership` struct at `index`.
527      */
528     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
529         return _unpackedOwnership(_packedOwnerships[index]);
530     }
531 
532     /**
533      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
534      */
535     function _initializeOwnershipAt(uint256 index) internal {
536         if (_packedOwnerships[index] == 0) {
537             _packedOwnerships[index] = _packedOwnershipOf(index);
538         }
539     }
540 
541     /**
542      * Gas spent here starts off proportional to the maximum mint batch size.
543      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
544      */
545     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
546         return _unpackedOwnership(_packedOwnershipOf(tokenId));
547     }
548 
549     /**
550      * @dev See {IERC721-ownerOf}.
551      */
552     function ownerOf(uint256 tokenId) public view override returns (address) {
553         return address(uint160(_packedOwnershipOf(tokenId)));
554     }
555 
556     /**
557      * @dev See {IERC721Metadata-name}.
558      */
559     function name() public view virtual override returns (string memory) {
560         return _name;
561     }
562 
563     /**
564      * @dev See {IERC721Metadata-symbol}.
565      */
566     function symbol() public view virtual override returns (string memory) {
567         return _symbol;
568     }
569 
570     /**
571      * @dev See {IERC721Metadata-tokenURI}.
572      */
573     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
574         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
575 
576         string memory baseURI = _baseURI();
577         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
578     }
579 
580     /**
581      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
582      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
583      * by default, can be overriden in child contracts.
584      */
585     function _baseURI() internal view virtual returns (string memory) {
586         return '';
587     }
588 
589     /**
590      * @dev Casts the address to uint256 without masking.
591      */
592     function _addressToUint256(address value) private pure returns (uint256 result) {
593         assembly {
594             result := value
595         }
596     }
597 
598     /**
599      * @dev Casts the boolean to uint256 without branching.
600      */
601     function _boolToUint256(bool value) private pure returns (uint256 result) {
602         assembly {
603             result := value
604         }
605     }
606 
607     /**
608      * @dev See {IERC721-approve}.
609      */
610     function approve(address to, uint256 tokenId) public override {
611         address owner = address(uint160(_packedOwnershipOf(tokenId)));
612         if (to == owner) revert ApprovalToCurrentOwner();
613 
614         if (_msgSenderERC721A() != owner)
615             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
616                 revert ApprovalCallerNotOwnerNorApproved();
617             }
618 
619         _tokenApprovals[tokenId] = to;
620         emit Approval(owner, to, tokenId);
621     }
622 
623     /**
624      * @dev See {IERC721-getApproved}.
625      */
626     function getApproved(uint256 tokenId) public view override returns (address) {
627         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
628 
629         return _tokenApprovals[tokenId];
630     }
631 
632     /**
633      * @dev See {IERC721-setApprovalForAll}.
634      */
635     function setApprovalForAll(address operator, bool approved) public virtual override {
636         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
637 
638         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
639         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
640     }
641 
642     /**
643      * @dev See {IERC721-isApprovedForAll}.
644      */
645     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
646         return _operatorApprovals[owner][operator];
647     }
648 
649     /**
650      * @dev See {IERC721-transferFrom}.
651      */
652     function transferFrom(
653         address from,
654         address to,
655         uint256 tokenId
656     ) public virtual override {
657         _transfer(from, to, tokenId);
658     }
659 
660     /**
661      * @dev See {IERC721-safeTransferFrom}.
662      */
663     function safeTransferFrom(
664         address from,
665         address to,
666         uint256 tokenId
667     ) public virtual override {
668         safeTransferFrom(from, to, tokenId, '');
669     }
670 
671     /**
672      * @dev See {IERC721-safeTransferFrom}.
673      */
674     function safeTransferFrom(
675         address from,
676         address to,
677         uint256 tokenId,
678         bytes memory _data
679     ) public virtual override {
680         _transfer(from, to, tokenId);
681         if (to.code.length != 0)
682             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
683                 revert TransferToNonERC721ReceiverImplementer();
684             }
685     }
686 
687     /**
688      * @dev Returns whether `tokenId` exists.
689      *
690      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
691      *
692      * Tokens start existing when they are minted (`_mint`),
693      */
694     function _exists(uint256 tokenId) internal view returns (bool) {
695         return
696             _startTokenId() <= tokenId &&
697             tokenId < _currentIndex && // If within bounds,
698             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
699     }
700 
701     /**
702      * @dev Equivalent to `_safeMint(to, quantity, '')`.
703      */
704     function _safeMint(address to, uint256 quantity) internal {
705         _safeMint(to, quantity, '');
706     }
707 
708     /**
709      * @dev Safely mints `quantity` tokens and transfers them to `to`.
710      *
711      * Requirements:
712      *
713      * - If `to` refers to a smart contract, it must implement
714      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
715      * - `quantity` must be greater than 0.
716      *
717      * Emits a {Transfer} event.
718      */
719     function _safeMint(
720         address to,
721         uint256 quantity,
722         bytes memory _data
723     ) internal {
724         uint256 startTokenId = _currentIndex;
725         if (to == address(0)) revert MintToZeroAddress();
726         if (quantity == 0) revert MintZeroQuantity();
727 
728         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
729 
730         // Overflows are incredibly unrealistic.
731         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
732         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
733         unchecked {
734             // Updates:
735             // - `balance += quantity`.
736             // - `numberMinted += quantity`.
737             //
738             // We can directly add to the balance and number minted.
739             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
740 
741             // Updates:
742             // - `address` to the owner.
743             // - `startTimestamp` to the timestamp of minting.
744             // - `burned` to `false`.
745             // - `nextInitialized` to `quantity == 1`.
746             _packedOwnerships[startTokenId] =
747                 _addressToUint256(to) |
748                 (block.timestamp << BITPOS_START_TIMESTAMP) |
749                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
750 
751             uint256 updatedIndex = startTokenId;
752             uint256 end = updatedIndex + quantity;
753 
754             if (to.code.length != 0) {
755                 do {
756                     emit Transfer(address(0), to, updatedIndex);
757                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
758                         revert TransferToNonERC721ReceiverImplementer();
759                     }
760                 } while (updatedIndex < end);
761                 // Reentrancy protection
762                 if (_currentIndex != startTokenId) revert();
763             } else {
764                 do {
765                     emit Transfer(address(0), to, updatedIndex++);
766                 } while (updatedIndex < end);
767             }
768             _currentIndex = updatedIndex;
769         }
770         _afterTokenTransfers(address(0), to, startTokenId, quantity);
771     }
772 
773     /**
774      * @dev Mints `quantity` tokens and transfers them to `to`.
775      *
776      * Requirements:
777      *
778      * - `to` cannot be the zero address.
779      * - `quantity` must be greater than 0.
780      *
781      * Emits a {Transfer} event.
782      */
783     function _mint(address to, uint256 quantity) internal {
784         uint256 startTokenId = _currentIndex;
785         if (to == address(0)) revert MintToZeroAddress();
786         if (quantity == 0) revert MintZeroQuantity();
787 
788         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
789 
790         // Overflows are incredibly unrealistic.
791         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
792         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
793         unchecked {
794             // Updates:
795             // - `balance += quantity`.
796             // - `numberMinted += quantity`.
797             //
798             // We can directly add to the balance and number minted.
799             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
800 
801             // Updates:
802             // - `address` to the owner.
803             // - `startTimestamp` to the timestamp of minting.
804             // - `burned` to `false`.
805             // - `nextInitialized` to `quantity == 1`.
806             _packedOwnerships[startTokenId] =
807                 _addressToUint256(to) |
808                 (block.timestamp << BITPOS_START_TIMESTAMP) |
809                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
810 
811             uint256 updatedIndex = startTokenId;
812             uint256 end = updatedIndex + quantity;
813 
814             do {
815                 emit Transfer(address(0), to, updatedIndex++);
816             } while (updatedIndex < end);
817 
818             _currentIndex = updatedIndex;
819         }
820         _afterTokenTransfers(address(0), to, startTokenId, quantity);
821     }
822 
823     /**
824      * @dev Transfers `tokenId` from `from` to `to`.
825      *
826      * Requirements:
827      *
828      * - `to` cannot be the zero address.
829      * - `tokenId` token must be owned by `from`.
830      *
831      * Emits a {Transfer} event.
832      */
833     function _transfer(
834         address from,
835         address to,
836         uint256 tokenId
837     ) private {
838         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
839 
840         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
841 
842         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
843             isApprovedForAll(from, _msgSenderERC721A()) ||
844             getApproved(tokenId) == _msgSenderERC721A());
845 
846         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
847         if (to == address(0)) revert TransferToZeroAddress();
848 
849         _beforeTokenTransfers(from, to, tokenId, 1);
850 
851         // Clear approvals from the previous owner.
852         delete _tokenApprovals[tokenId];
853 
854         // Underflow of the sender's balance is impossible because we check for
855         // ownership above and the recipient's balance can't realistically overflow.
856         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
857         unchecked {
858             // We can directly increment and decrement the balances.
859             --_packedAddressData[from]; // Updates: `balance -= 1`.
860             ++_packedAddressData[to]; // Updates: `balance += 1`.
861 
862             // Updates:
863             // - `address` to the next owner.
864             // - `startTimestamp` to the timestamp of transfering.
865             // - `burned` to `false`.
866             // - `nextInitialized` to `true`.
867             _packedOwnerships[tokenId] =
868                 _addressToUint256(to) |
869                 (block.timestamp << BITPOS_START_TIMESTAMP) |
870                 BITMASK_NEXT_INITIALIZED;
871 
872             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
873             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
874                 uint256 nextTokenId = tokenId + 1;
875                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
876                 if (_packedOwnerships[nextTokenId] == 0) {
877                     // If the next slot is within bounds.
878                     if (nextTokenId != _currentIndex) {
879                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
880                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
881                     }
882                 }
883             }
884         }
885 
886         emit Transfer(from, to, tokenId);
887         _afterTokenTransfers(from, to, tokenId, 1);
888     }
889 
890     /**
891      * @dev Equivalent to `_burn(tokenId, false)`.
892      */
893     function _burn(uint256 tokenId) internal virtual {
894         _burn(tokenId, false);
895     }
896 
897     /**
898      * @dev Destroys `tokenId`.
899      * The approval is cleared when the token is burned.
900      *
901      * Requirements:
902      *
903      * - `tokenId` must exist.
904      *
905      * Emits a {Transfer} event.
906      */
907     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
908         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
909 
910         address from = address(uint160(prevOwnershipPacked));
911 
912         if (approvalCheck) {
913             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
914                 isApprovedForAll(from, _msgSenderERC721A()) ||
915                 getApproved(tokenId) == _msgSenderERC721A());
916 
917             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
918         }
919 
920         _beforeTokenTransfers(from, address(0), tokenId, 1);
921 
922         // Clear approvals from the previous owner.
923         delete _tokenApprovals[tokenId];
924 
925         // Underflow of the sender's balance is impossible because we check for
926         // ownership above and the recipient's balance can't realistically overflow.
927         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
928         unchecked {
929             // Updates:
930             // - `balance -= 1`.
931             // - `numberBurned += 1`.
932             //
933             // We can directly decrement the balance, and increment the number burned.
934             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
935             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
936 
937             // Updates:
938             // - `address` to the last owner.
939             // - `startTimestamp` to the timestamp of burning.
940             // - `burned` to `true`.
941             // - `nextInitialized` to `true`.
942             _packedOwnerships[tokenId] =
943                 _addressToUint256(from) |
944                 (block.timestamp << BITPOS_START_TIMESTAMP) |
945                 BITMASK_BURNED | 
946                 BITMASK_NEXT_INITIALIZED;
947 
948             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
949             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
950                 uint256 nextTokenId = tokenId + 1;
951                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
952                 if (_packedOwnerships[nextTokenId] == 0) {
953                     // If the next slot is within bounds.
954                     if (nextTokenId != _currentIndex) {
955                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
956                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
957                     }
958                 }
959             }
960         }
961 
962         emit Transfer(from, address(0), tokenId);
963         _afterTokenTransfers(from, address(0), tokenId, 1);
964 
965         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
966         unchecked {
967             _burnCounter++;
968         }
969     }
970 
971     /**
972      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
973      *
974      * @param from address representing the previous owner of the given token ID
975      * @param to target address that will receive the tokens
976      * @param tokenId uint256 ID of the token to be transferred
977      * @param _data bytes optional data to send along with the call
978      * @return bool whether the call correctly returned the expected magic value
979      */
980     function _checkContractOnERC721Received(
981         address from,
982         address to,
983         uint256 tokenId,
984         bytes memory _data
985     ) private returns (bool) {
986         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
987             bytes4 retval
988         ) {
989             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
990         } catch (bytes memory reason) {
991             if (reason.length == 0) {
992                 revert TransferToNonERC721ReceiverImplementer();
993             } else {
994                 assembly {
995                     revert(add(32, reason), mload(reason))
996                 }
997             }
998         }
999     }
1000 
1001     /**
1002      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1003      * And also called before burning one token.
1004      *
1005      * startTokenId - the first token id to be transferred
1006      * quantity - the amount to be transferred
1007      *
1008      * Calling conditions:
1009      *
1010      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1011      * transferred to `to`.
1012      * - When `from` is zero, `tokenId` will be minted for `to`.
1013      * - When `to` is zero, `tokenId` will be burned by `from`.
1014      * - `from` and `to` are never both zero.
1015      */
1016     function _beforeTokenTransfers(
1017         address from,
1018         address to,
1019         uint256 startTokenId,
1020         uint256 quantity
1021     ) internal virtual {}
1022 
1023     /**
1024      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1025      * minting.
1026      * And also called after one token has been burned.
1027      *
1028      * startTokenId - the first token id to be transferred
1029      * quantity - the amount to be transferred
1030      *
1031      * Calling conditions:
1032      *
1033      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1034      * transferred to `to`.
1035      * - When `from` is zero, `tokenId` has been minted for `to`.
1036      * - When `to` is zero, `tokenId` has been burned by `from`.
1037      * - `from` and `to` are never both zero.
1038      */
1039     function _afterTokenTransfers(
1040         address from,
1041         address to,
1042         uint256 startTokenId,
1043         uint256 quantity
1044     ) internal virtual {}
1045 
1046     /**
1047      * @dev Returns the message sender (defaults to `msg.sender`).
1048      *
1049      * If you are writing GSN compatible contracts, you need to override this function.
1050      */
1051     function _msgSenderERC721A() internal view virtual returns (address) {
1052         return msg.sender;
1053     }
1054 
1055     /**
1056      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1057      */
1058     function _toString(uint256 value) internal pure returns (string memory ptr) {
1059         assembly {
1060             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1061             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1062             // We will need 1 32-byte word to store the length, 
1063             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1064             ptr := add(mload(0x40), 128)
1065             // Update the free memory pointer to allocate.
1066             mstore(0x40, ptr)
1067 
1068             // Cache the end of the memory to calculate the length later.
1069             let end := ptr
1070 
1071             // We write the string from the rightmost digit to the leftmost digit.
1072             // The following is essentially a do-while loop that also handles the zero case.
1073             // Costs a bit more than early returning for the zero case,
1074             // but cheaper in terms of deployment and overall runtime costs.
1075             for { 
1076                 // Initialize and perform the first pass without check.
1077                 let temp := value
1078                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1079                 ptr := sub(ptr, 1)
1080                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1081                 mstore8(ptr, add(48, mod(temp, 10)))
1082                 temp := div(temp, 10)
1083             } temp { 
1084                 // Keep dividing `temp` until zero.
1085                 temp := div(temp, 10)
1086             } { // Body of the for loop.
1087                 ptr := sub(ptr, 1)
1088                 mstore8(ptr, add(48, mod(temp, 10)))
1089             }
1090             
1091             let length := sub(end, ptr)
1092             // Move the pointer 32 bytes leftwards to make room for the length.
1093             ptr := sub(ptr, 32)
1094             // Store the length.
1095             mstore(ptr, length)
1096         }
1097     }
1098 }
1099 
1100 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
1101 
1102 
1103 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1104 
1105 pragma solidity ^0.8.0;
1106 
1107 /**
1108  * @dev String operations.
1109  */
1110 library Strings {
1111     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1112     uint8 private constant _ADDRESS_LENGTH = 20;
1113 
1114     /**
1115      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1116      */
1117     function toString(uint256 value) internal pure returns (string memory) {
1118         // Inspired by OraclizeAPI's implementation - MIT licence
1119         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1120 
1121         if (value == 0) {
1122             return "0";
1123         }
1124         uint256 temp = value;
1125         uint256 digits;
1126         while (temp != 0) {
1127             digits++;
1128             temp /= 10;
1129         }
1130         bytes memory buffer = new bytes(digits);
1131         while (value != 0) {
1132             digits -= 1;
1133             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1134             value /= 10;
1135         }
1136         return string(buffer);
1137     }
1138 
1139     /**
1140      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1141      */
1142     function toHexString(uint256 value) internal pure returns (string memory) {
1143         if (value == 0) {
1144             return "0x00";
1145         }
1146         uint256 temp = value;
1147         uint256 length = 0;
1148         while (temp != 0) {
1149             length++;
1150             temp >>= 8;
1151         }
1152         return toHexString(value, length);
1153     }
1154 
1155     /**
1156      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1157      */
1158     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1159         bytes memory buffer = new bytes(2 * length + 2);
1160         buffer[0] = "0";
1161         buffer[1] = "x";
1162         for (uint256 i = 2 * length + 1; i > 1; --i) {
1163             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1164             value >>= 4;
1165         }
1166         require(value == 0, "Strings: hex length insufficient");
1167         return string(buffer);
1168     }
1169 
1170     /**
1171      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1172      */
1173     function toHexString(address addr) internal pure returns (string memory) {
1174         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1175     }
1176 }
1177 
1178 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1179 
1180 
1181 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1182 
1183 pragma solidity ^0.8.0;
1184 
1185 /**
1186  * @dev Provides information about the current execution context, including the
1187  * sender of the transaction and its data. While these are generally available
1188  * via msg.sender and msg.data, they should not be accessed in such a direct
1189  * manner, since when dealing with meta-transactions the account sending and
1190  * paying for execution may not be the actual sender (as far as an application
1191  * is concerned).
1192  *
1193  * This contract is only required for intermediate, library-like contracts.
1194  */
1195 abstract contract Context {
1196     function _msgSender() internal view virtual returns (address) {
1197         return msg.sender;
1198     }
1199 
1200     function _msgData() internal view virtual returns (bytes calldata) {
1201         return msg.data;
1202     }
1203 }
1204 
1205 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1206 
1207 
1208 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1209 
1210 pragma solidity ^0.8.0;
1211 
1212 
1213 /**
1214  * @dev Contract module which provides a basic access control mechanism, where
1215  * there is an account (an owner) that can be granted exclusive access to
1216  * specific functions.
1217  *
1218  * By default, the owner account will be the one that deploys the contract. This
1219  * can later be changed with {transferOwnership}.
1220  *
1221  * This module is used through inheritance. It will make available the modifier
1222  * `onlyOwner`, which can be applied to your functions to restrict their use to
1223  * the owner.
1224  */
1225 abstract contract Ownable is Context {
1226     address private _owner;
1227 
1228     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1229 
1230     /**
1231      * @dev Initializes the contract setting the deployer as the initial owner.
1232      */
1233     constructor() {
1234         _transferOwnership(_msgSender());
1235     }
1236 
1237     /**
1238      * @dev Returns the address of the current owner.
1239      */
1240     function owner() public view virtual returns (address) {
1241         return _owner;
1242     }
1243 
1244     /**
1245      * @dev Throws if called by any account other than the owner.
1246      */
1247     modifier onlyOwner() {
1248         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1249         _;
1250     }
1251 
1252     /**
1253      * @dev Leaves the contract without owner. It will not be possible to call
1254      * `onlyOwner` functions anymore. Can only be called by the current owner.
1255      *
1256      * NOTE: Renouncing ownership will leave the contract without an owner,
1257      * thereby removing any functionality that is only available to the owner.
1258      */
1259     function renounceOwnership() public virtual onlyOwner {
1260         _transferOwnership(address(0));
1261     }
1262 
1263     /**
1264      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1265      * Can only be called by the current owner.
1266      */
1267     function transferOwnership(address newOwner) public virtual onlyOwner {
1268         require(newOwner != address(0), "Ownable: new owner is the zero address");
1269         _transferOwnership(newOwner);
1270     }
1271 
1272     /**
1273      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1274      * Internal function without access restriction.
1275      */
1276     function _transferOwnership(address newOwner) internal virtual {
1277         address oldOwner = _owner;
1278         _owner = newOwner;
1279         emit OwnershipTransferred(oldOwner, newOwner);
1280     }
1281 }
1282 
1283 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
1284 
1285 
1286 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1287 
1288 pragma solidity ^0.8.1;
1289 
1290 /**
1291  * @dev Collection of functions related to the address type
1292  */
1293 library Address {
1294     /**
1295      * @dev Returns true if `account` is a contract.
1296      *
1297      * [IMPORTANT]
1298      * ====
1299      * It is unsafe to assume that an address for which this function returns
1300      * false is an externally-owned account (EOA) and not a contract.
1301      *
1302      * Among others, `isContract` will return false for the following
1303      * types of addresses:
1304      *
1305      *  - an externally-owned account
1306      *  - a contract in construction
1307      *  - an address where a contract will be created
1308      *  - an address where a contract lived, but was destroyed
1309      * ====
1310      *
1311      * [IMPORTANT]
1312      * ====
1313      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1314      *
1315      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1316      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1317      * constructor.
1318      * ====
1319      */
1320     function isContract(address account) internal view returns (bool) {
1321         // This method relies on extcodesize/address.code.length, which returns 0
1322         // for contracts in construction, since the code is only stored at the end
1323         // of the constructor execution.
1324 
1325         return account.code.length > 0;
1326     }
1327 
1328     /**
1329      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1330      * `recipient`, forwarding all available gas and reverting on errors.
1331      *
1332      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1333      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1334      * imposed by `transfer`, making them unable to receive funds via
1335      * `transfer`. {sendValue} removes this limitation.
1336      *
1337      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1338      *
1339      * IMPORTANT: because control is transferred to `recipient`, care must be
1340      * taken to not create reentrancy vulnerabilities. Consider using
1341      * {ReentrancyGuard} or the
1342      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1343      */
1344     function sendValue(address payable recipient, uint256 amount) internal {
1345         require(address(this).balance >= amount, "Address: insufficient balance");
1346 
1347         (bool success, ) = recipient.call{value: amount}("");
1348         require(success, "Address: unable to send value, recipient may have reverted");
1349     }
1350 
1351     /**
1352      * @dev Performs a Solidity function call using a low level `call`. A
1353      * plain `call` is an unsafe replacement for a function call: use this
1354      * function instead.
1355      *
1356      * If `target` reverts with a revert reason, it is bubbled up by this
1357      * function (like regular Solidity function calls).
1358      *
1359      * Returns the raw returned data. To convert to the expected return value,
1360      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1361      *
1362      * Requirements:
1363      *
1364      * - `target` must be a contract.
1365      * - calling `target` with `data` must not revert.
1366      *
1367      * _Available since v3.1._
1368      */
1369     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1370         return functionCall(target, data, "Address: low-level call failed");
1371     }
1372 
1373     /**
1374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1375      * `errorMessage` as a fallback revert reason when `target` reverts.
1376      *
1377      * _Available since v3.1._
1378      */
1379     function functionCall(
1380         address target,
1381         bytes memory data,
1382         string memory errorMessage
1383     ) internal returns (bytes memory) {
1384         return functionCallWithValue(target, data, 0, errorMessage);
1385     }
1386 
1387     /**
1388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1389      * but also transferring `value` wei to `target`.
1390      *
1391      * Requirements:
1392      *
1393      * - the calling contract must have an ETH balance of at least `value`.
1394      * - the called Solidity function must be `payable`.
1395      *
1396      * _Available since v3.1._
1397      */
1398     function functionCallWithValue(
1399         address target,
1400         bytes memory data,
1401         uint256 value
1402     ) internal returns (bytes memory) {
1403         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1404     }
1405 
1406     /**
1407      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1408      * with `errorMessage` as a fallback revert reason when `target` reverts.
1409      *
1410      * _Available since v3.1._
1411      */
1412     function functionCallWithValue(
1413         address target,
1414         bytes memory data,
1415         uint256 value,
1416         string memory errorMessage
1417     ) internal returns (bytes memory) {
1418         require(address(this).balance >= value, "Address: insufficient balance for call");
1419         require(isContract(target), "Address: call to non-contract");
1420 
1421         (bool success, bytes memory returndata) = target.call{value: value}(data);
1422         return verifyCallResult(success, returndata, errorMessage);
1423     }
1424 
1425     /**
1426      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1427      * but performing a static call.
1428      *
1429      * _Available since v3.3._
1430      */
1431     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1432         return functionStaticCall(target, data, "Address: low-level static call failed");
1433     }
1434 
1435     /**
1436      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1437      * but performing a static call.
1438      *
1439      * _Available since v3.3._
1440      */
1441     function functionStaticCall(
1442         address target,
1443         bytes memory data,
1444         string memory errorMessage
1445     ) internal view returns (bytes memory) {
1446         require(isContract(target), "Address: static call to non-contract");
1447 
1448         (bool success, bytes memory returndata) = target.staticcall(data);
1449         return verifyCallResult(success, returndata, errorMessage);
1450     }
1451 
1452     /**
1453      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1454      * but performing a delegate call.
1455      *
1456      * _Available since v3.4._
1457      */
1458     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1459         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1460     }
1461 
1462     /**
1463      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1464      * but performing a delegate call.
1465      *
1466      * _Available since v3.4._
1467      */
1468     function functionDelegateCall(
1469         address target,
1470         bytes memory data,
1471         string memory errorMessage
1472     ) internal returns (bytes memory) {
1473         require(isContract(target), "Address: delegate call to non-contract");
1474 
1475         (bool success, bytes memory returndata) = target.delegatecall(data);
1476         return verifyCallResult(success, returndata, errorMessage);
1477     }
1478 
1479     /**
1480      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1481      * revert reason using the provided one.
1482      *
1483      * _Available since v4.3._
1484      */
1485     function verifyCallResult(
1486         bool success,
1487         bytes memory returndata,
1488         string memory errorMessage
1489     ) internal pure returns (bytes memory) {
1490         if (success) {
1491             return returndata;
1492         } else {
1493             // Look for revert reason and bubble it up if present
1494             if (returndata.length > 0) {
1495                 // The easiest way to bubble the revert reason is using memory via assembly
1496 
1497                 assembly {
1498                     let returndata_size := mload(returndata)
1499                     revert(add(32, returndata), returndata_size)
1500                 }
1501             } else {
1502                 revert(errorMessage);
1503             }
1504         }
1505     }
1506 }
1507 
1508 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
1509 
1510 
1511 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1512 
1513 pragma solidity ^0.8.0;
1514 
1515 /**
1516  * @title ERC721 token receiver interface
1517  * @dev Interface for any contract that wants to support safeTransfers
1518  * from ERC721 asset contracts.
1519  */
1520 interface IERC721Receiver {
1521     /**
1522      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1523      * by `operator` from `from`, this function is called.
1524      *
1525      * It must return its Solidity selector to confirm the token transfer.
1526      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1527      *
1528      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1529      */
1530     function onERC721Received(
1531         address operator,
1532         address from,
1533         uint256 tokenId,
1534         bytes calldata data
1535     ) external returns (bytes4);
1536 }
1537 
1538 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
1539 
1540 
1541 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1542 
1543 pragma solidity ^0.8.0;
1544 
1545 /**
1546  * @dev Interface of the ERC165 standard, as defined in the
1547  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1548  *
1549  * Implementers can declare support of contract interfaces, which can then be
1550  * queried by others ({ERC165Checker}).
1551  *
1552  * For an implementation, see {ERC165}.
1553  */
1554 interface IERC165 {
1555     /**
1556      * @dev Returns true if this contract implements the interface defined by
1557      * `interfaceId`. See the corresponding
1558      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1559      * to learn more about how these ids are created.
1560      *
1561      * This function call must use less than 30 000 gas.
1562      */
1563     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1564 }
1565 
1566 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
1567 
1568 
1569 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1570 
1571 pragma solidity ^0.8.0;
1572 
1573 
1574 /**
1575  * @dev Implementation of the {IERC165} interface.
1576  *
1577  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1578  * for the additional interface id that will be supported. For example:
1579  *
1580  * ```solidity
1581  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1582  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1583  * }
1584  * ```
1585  *
1586  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1587  */
1588 abstract contract ERC165 is IERC165 {
1589     /**
1590      * @dev See {IERC165-supportsInterface}.
1591      */
1592     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1593         return interfaceId == type(IERC165).interfaceId;
1594     }
1595 }
1596 
1597 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1598 
1599 
1600 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1601 
1602 pragma solidity ^0.8.0;
1603 
1604 
1605 /**
1606  * @dev Required interface of an ERC721 compliant contract.
1607  */
1608 interface IERC721 is IERC165 {
1609     /**
1610      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1611      */
1612     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1613 
1614     /**
1615      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1616      */
1617     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1618 
1619     /**
1620      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1621      */
1622     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1623 
1624     /**
1625      * @dev Returns the number of tokens in ``owner``'s account.
1626      */
1627     function balanceOf(address owner) external view returns (uint256 balance);
1628 
1629     /**
1630      * @dev Returns the owner of the `tokenId` token.
1631      *
1632      * Requirements:
1633      *
1634      * - `tokenId` must exist.
1635      */
1636     function ownerOf(uint256 tokenId) external view returns (address owner);
1637 
1638     /**
1639      * @dev Safely transfers `tokenId` token from `from` to `to`.
1640      *
1641      * Requirements:
1642      *
1643      * - `from` cannot be the zero address.
1644      * - `to` cannot be the zero address.
1645      * - `tokenId` token must exist and be owned by `from`.
1646      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1647      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1648      *
1649      * Emits a {Transfer} event.
1650      */
1651     function safeTransferFrom(
1652         address from,
1653         address to,
1654         uint256 tokenId,
1655         bytes calldata data
1656     ) external;
1657 
1658     /**
1659      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1660      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1661      *
1662      * Requirements:
1663      *
1664      * - `from` cannot be the zero address.
1665      * - `to` cannot be the zero address.
1666      * - `tokenId` token must exist and be owned by `from`.
1667      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1668      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1669      *
1670      * Emits a {Transfer} event.
1671      */
1672     function safeTransferFrom(
1673         address from,
1674         address to,
1675         uint256 tokenId
1676     ) external;
1677 
1678     /**
1679      * @dev Transfers `tokenId` token from `from` to `to`.
1680      *
1681      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1682      *
1683      * Requirements:
1684      *
1685      * - `from` cannot be the zero address.
1686      * - `to` cannot be the zero address.
1687      * - `tokenId` token must be owned by `from`.
1688      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1689      *
1690      * Emits a {Transfer} event.
1691      */
1692     function transferFrom(
1693         address from,
1694         address to,
1695         uint256 tokenId
1696     ) external;
1697 
1698     /**
1699      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1700      * The approval is cleared when the token is transferred.
1701      *
1702      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1703      *
1704      * Requirements:
1705      *
1706      * - The caller must own the token or be an approved operator.
1707      * - `tokenId` must exist.
1708      *
1709      * Emits an {Approval} event.
1710      */
1711     function approve(address to, uint256 tokenId) external;
1712 
1713     /**
1714      * @dev Approve or remove `operator` as an operator for the caller.
1715      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1716      *
1717      * Requirements:
1718      *
1719      * - The `operator` cannot be the caller.
1720      *
1721      * Emits an {ApprovalForAll} event.
1722      */
1723     function setApprovalForAll(address operator, bool _approved) external;
1724 
1725     /**
1726      * @dev Returns the account approved for `tokenId` token.
1727      *
1728      * Requirements:
1729      *
1730      * - `tokenId` must exist.
1731      */
1732     function getApproved(uint256 tokenId) external view returns (address operator);
1733 
1734     /**
1735      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1736      *
1737      * See {setApprovalForAll}
1738      */
1739     function isApprovedForAll(address owner, address operator) external view returns (bool);
1740 }
1741 
1742 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1743 
1744 
1745 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1746 
1747 pragma solidity ^0.8.0;
1748 
1749 
1750 /**
1751  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1752  * @dev See https://eips.ethereum.org/EIPS/eip-721
1753  */
1754 interface IERC721Metadata is IERC721 {
1755     /**
1756      * @dev Returns the token collection name.
1757      */
1758     function name() external view returns (string memory);
1759 
1760     /**
1761      * @dev Returns the token collection symbol.
1762      */
1763     function symbol() external view returns (string memory);
1764 
1765     /**
1766      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1767      */
1768     function tokenURI(uint256 tokenId) external view returns (string memory);
1769 }
1770 
1771 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1772 
1773 
1774 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1775 
1776 pragma solidity ^0.8.0;
1777 
1778 
1779 
1780 
1781 
1782 
1783 
1784 
1785 /**
1786  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1787  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1788  * {ERC721Enumerable}.
1789  */
1790 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1791     using Address for address;
1792     using Strings for uint256;
1793 
1794     // Token name
1795     string private _name;
1796 
1797     // Token symbol
1798     string private _symbol;
1799 
1800     // Mapping from token ID to owner address
1801     mapping(uint256 => address) private _owners;
1802 
1803     // Mapping owner address to token count
1804     mapping(address => uint256) private _balances;
1805 
1806     // Mapping from token ID to approved address
1807     mapping(uint256 => address) private _tokenApprovals;
1808 
1809     // Mapping from owner to operator approvals
1810     mapping(address => mapping(address => bool)) private _operatorApprovals;
1811 
1812     /**
1813      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1814      */
1815     constructor(string memory name_, string memory symbol_) {
1816         _name = name_;
1817         _symbol = symbol_;
1818     }
1819 
1820     /**
1821      * @dev See {IERC165-supportsInterface}.
1822      */
1823     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1824         return
1825             interfaceId == type(IERC721).interfaceId ||
1826             interfaceId == type(IERC721Metadata).interfaceId ||
1827             super.supportsInterface(interfaceId);
1828     }
1829 
1830     /**
1831      * @dev See {IERC721-balanceOf}.
1832      */
1833     function balanceOf(address owner) public view virtual override returns (uint256) {
1834         require(owner != address(0), "ERC721: address zero is not a valid owner");
1835         return _balances[owner];
1836     }
1837 
1838     /**
1839      * @dev See {IERC721-ownerOf}.
1840      */
1841     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1842         address owner = _owners[tokenId];
1843         require(owner != address(0), "ERC721: owner query for nonexistent token");
1844         return owner;
1845     }
1846 
1847     /**
1848      * @dev See {IERC721Metadata-name}.
1849      */
1850     function name() public view virtual override returns (string memory) {
1851         return _name;
1852     }
1853 
1854     /**
1855      * @dev See {IERC721Metadata-symbol}.
1856      */
1857     function symbol() public view virtual override returns (string memory) {
1858         return _symbol;
1859     }
1860 
1861     /**
1862      * @dev See {IERC721Metadata-tokenURI}.
1863      */
1864     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1865         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1866 
1867         string memory baseURI = _baseURI();
1868         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1869     }
1870 
1871     /**
1872      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1873      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1874      * by default, can be overridden in child contracts.
1875      */
1876     function _baseURI() internal view virtual returns (string memory) {
1877         return "";
1878     }
1879 
1880     /**
1881      * @dev See {IERC721-approve}.
1882      */
1883     function approve(address to, uint256 tokenId) public virtual override {
1884         address owner = ERC721.ownerOf(tokenId);
1885         require(to != owner, "ERC721: approval to current owner");
1886 
1887         require(
1888             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1889             "ERC721: approve caller is not owner nor approved for all"
1890         );
1891 
1892         _approve(to, tokenId);
1893     }
1894 
1895     /**
1896      * @dev See {IERC721-getApproved}.
1897      */
1898     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1899         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1900 
1901         return _tokenApprovals[tokenId];
1902     }
1903 
1904     /**
1905      * @dev See {IERC721-setApprovalForAll}.
1906      */
1907     function setApprovalForAll(address operator, bool approved) public virtual override {
1908         _setApprovalForAll(_msgSender(), operator, approved);
1909     }
1910 
1911     /**
1912      * @dev See {IERC721-isApprovedForAll}.
1913      */
1914     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1915         return _operatorApprovals[owner][operator];
1916     }
1917 
1918     /**
1919      * @dev See {IERC721-transferFrom}.
1920      */
1921     function transferFrom(
1922         address from,
1923         address to,
1924         uint256 tokenId
1925     ) public virtual override {
1926         //solhint-disable-next-line max-line-length
1927         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1928 
1929         _transfer(from, to, tokenId);
1930     }
1931 
1932     /**
1933      * @dev See {IERC721-safeTransferFrom}.
1934      */
1935     function safeTransferFrom(
1936         address from,
1937         address to,
1938         uint256 tokenId
1939     ) public virtual override {
1940         safeTransferFrom(from, to, tokenId, "");
1941     }
1942 
1943     /**
1944      * @dev See {IERC721-safeTransferFrom}.
1945      */
1946     function safeTransferFrom(
1947         address from,
1948         address to,
1949         uint256 tokenId,
1950         bytes memory data
1951     ) public virtual override {
1952         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1953         _safeTransfer(from, to, tokenId, data);
1954     }
1955 
1956     /**
1957      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1958      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1959      *
1960      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1961      *
1962      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1963      * implement alternative mechanisms to perform token transfer, such as signature-based.
1964      *
1965      * Requirements:
1966      *
1967      * - `from` cannot be the zero address.
1968      * - `to` cannot be the zero address.
1969      * - `tokenId` token must exist and be owned by `from`.
1970      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1971      *
1972      * Emits a {Transfer} event.
1973      */
1974     function _safeTransfer(
1975         address from,
1976         address to,
1977         uint256 tokenId,
1978         bytes memory data
1979     ) internal virtual {
1980         _transfer(from, to, tokenId);
1981         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1982     }
1983 
1984     /**
1985      * @dev Returns whether `tokenId` exists.
1986      *
1987      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1988      *
1989      * Tokens start existing when they are minted (`_mint`),
1990      * and stop existing when they are burned (`_burn`).
1991      */
1992     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1993         return _owners[tokenId] != address(0);
1994     }
1995 
1996     /**
1997      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1998      *
1999      * Requirements:
2000      *
2001      * - `tokenId` must exist.
2002      */
2003     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2004         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2005         address owner = ERC721.ownerOf(tokenId);
2006         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
2007     }
2008 
2009     /**
2010      * @dev Safely mints `tokenId` and transfers it to `to`.
2011      *
2012      * Requirements:
2013      *
2014      * - `tokenId` must not exist.
2015      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2016      *
2017      * Emits a {Transfer} event.
2018      */
2019     function _safeMint(address to, uint256 tokenId) internal virtual {
2020         _safeMint(to, tokenId, "");
2021     }
2022 
2023     /**
2024      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2025      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2026      */
2027     function _safeMint(
2028         address to,
2029         uint256 tokenId,
2030         bytes memory data
2031     ) internal virtual {
2032         _mint(to, tokenId);
2033         require(
2034             _checkOnERC721Received(address(0), to, tokenId, data),
2035             "ERC721: transfer to non ERC721Receiver implementer"
2036         );
2037     }
2038 
2039     /**
2040      * @dev Mints `tokenId` and transfers it to `to`.
2041      *
2042      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2043      *
2044      * Requirements:
2045      *
2046      * - `tokenId` must not exist.
2047      * - `to` cannot be the zero address.
2048      *
2049      * Emits a {Transfer} event.
2050      */
2051     function _mint(address to, uint256 tokenId) internal virtual {
2052         require(to != address(0), "ERC721: mint to the zero address");
2053         require(!_exists(tokenId), "ERC721: token already minted");
2054 
2055         _beforeTokenTransfer(address(0), to, tokenId);
2056 
2057         _balances[to] += 1;
2058         _owners[tokenId] = to;
2059 
2060         emit Transfer(address(0), to, tokenId);
2061 
2062         _afterTokenTransfer(address(0), to, tokenId);
2063     }
2064 
2065     /**
2066      * @dev Destroys `tokenId`.
2067      * The approval is cleared when the token is burned.
2068      *
2069      * Requirements:
2070      *
2071      * - `tokenId` must exist.
2072      *
2073      * Emits a {Transfer} event.
2074      */
2075     function _burn(uint256 tokenId) internal virtual {
2076         address owner = ERC721.ownerOf(tokenId);
2077 
2078         _beforeTokenTransfer(owner, address(0), tokenId);
2079 
2080         // Clear approvals
2081         _approve(address(0), tokenId);
2082 
2083         _balances[owner] -= 1;
2084         delete _owners[tokenId];
2085 
2086         emit Transfer(owner, address(0), tokenId);
2087 
2088         _afterTokenTransfer(owner, address(0), tokenId);
2089     }
2090 
2091     /**
2092      * @dev Transfers `tokenId` from `from` to `to`.
2093      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2094      *
2095      * Requirements:
2096      *
2097      * - `to` cannot be the zero address.
2098      * - `tokenId` token must be owned by `from`.
2099      *
2100      * Emits a {Transfer} event.
2101      */
2102     function _transfer(
2103         address from,
2104         address to,
2105         uint256 tokenId
2106     ) internal virtual {
2107         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2108         require(to != address(0), "ERC721: transfer to the zero address");
2109 
2110         _beforeTokenTransfer(from, to, tokenId);
2111 
2112         // Clear approvals from the previous owner
2113         _approve(address(0), tokenId);
2114 
2115         _balances[from] -= 1;
2116         _balances[to] += 1;
2117         _owners[tokenId] = to;
2118 
2119         emit Transfer(from, to, tokenId);
2120 
2121         _afterTokenTransfer(from, to, tokenId);
2122     }
2123 
2124     /**
2125      * @dev Approve `to` to operate on `tokenId`
2126      *
2127      * Emits an {Approval} event.
2128      */
2129     function _approve(address to, uint256 tokenId) internal virtual {
2130         _tokenApprovals[tokenId] = to;
2131         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2132     }
2133 
2134     /**
2135      * @dev Approve `operator` to operate on all of `owner` tokens
2136      *
2137      * Emits an {ApprovalForAll} event.
2138      */
2139     function _setApprovalForAll(
2140         address owner,
2141         address operator,
2142         bool approved
2143     ) internal virtual {
2144         require(owner != operator, "ERC721: approve to caller");
2145         _operatorApprovals[owner][operator] = approved;
2146         emit ApprovalForAll(owner, operator, approved);
2147     }
2148 
2149     /**
2150      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2151      * The call is not executed if the target address is not a contract.
2152      *
2153      * @param from address representing the previous owner of the given token ID
2154      * @param to target address that will receive the tokens
2155      * @param tokenId uint256 ID of the token to be transferred
2156      * @param data bytes optional data to send along with the call
2157      * @return bool whether the call correctly returned the expected magic value
2158      */
2159     function _checkOnERC721Received(
2160         address from,
2161         address to,
2162         uint256 tokenId,
2163         bytes memory data
2164     ) private returns (bool) {
2165         if (to.isContract()) {
2166             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2167                 return retval == IERC721Receiver.onERC721Received.selector;
2168             } catch (bytes memory reason) {
2169                 if (reason.length == 0) {
2170                     revert("ERC721: transfer to non ERC721Receiver implementer");
2171                 } else {
2172                     assembly {
2173                         revert(add(32, reason), mload(reason))
2174                     }
2175                 }
2176             }
2177         } else {
2178             return true;
2179         }
2180     }
2181 
2182     /**
2183      * @dev Hook that is called before any token transfer. This includes minting
2184      * and burning.
2185      *
2186      * Calling conditions:
2187      *
2188      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2189      * transferred to `to`.
2190      * - When `from` is zero, `tokenId` will be minted for `to`.
2191      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2192      * - `from` and `to` are never both zero.
2193      *
2194      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2195      */
2196     function _beforeTokenTransfer(
2197         address from,
2198         address to,
2199         uint256 tokenId
2200     ) internal virtual {}
2201 
2202     /**
2203      * @dev Hook that is called after any transfer of tokens. This includes
2204      * minting and burning.
2205      *
2206      * Calling conditions:
2207      *
2208      * - when `from` and `to` are both non-zero.
2209      * - `from` and `to` are never both zero.
2210      *
2211      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2212      */
2213     function _afterTokenTransfer(
2214         address from,
2215         address to,
2216         uint256 tokenId
2217     ) internal virtual {}
2218 }
2219 
2220 
2221 pragma solidity ^0.8.0;
2222 
2223 
2224 contract Dicks is ERC721A, Ownable {
2225     using Strings for uint256;
2226 
2227     string private baseURI;
2228 
2229     uint256 public price = 0.003 ether;
2230 
2231     uint256 public maxPerTx = 20;
2232 
2233     uint256 public maxFreePerWallet = 2;
2234 
2235     uint256 public totalFree = 1500;
2236 
2237     uint256 public maxSupply = 5555;
2238 
2239     bool public mintEnabled = false;
2240 
2241     mapping(address => uint256) private _mintedFreeAmount;
2242 
2243     constructor() ERC721A("Nonnys Dicks", "DICKS") {
2244         _safeMint(msg.sender, 25);
2245         setBaseURI("ipfs://bafybeib5wtyb5lswojh7qbcoflnvc7sedd6qtuvxzicbd5xri4gbis4uwy/");
2246     }
2247 
2248     function mintdick(uint256 count) external payable {
2249         uint256 cost = price;
2250         bool isFree = ((totalSupply() + count < totalFree + 1) &&
2251             (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
2252 
2253         if (isFree) {
2254             cost = 0;
2255         }
2256 
2257         require(msg.sender == tx.origin);
2258         require(msg.value >= count * cost, "Please send the exact amount.");
2259         require(totalSupply() + count < maxSupply + 1, "No more");
2260         require(mintEnabled, "Minting is not live yet");
2261         require(count < maxPerTx + 1, "Max per TX reached.");
2262 
2263         if (isFree) {
2264             _mintedFreeAmount[msg.sender] += count;
2265         }
2266 
2267         _safeMint(msg.sender, count);
2268     }
2269 
2270     function makedicknfly(address[] calldata _to, uint256[] calldata _amount)
2271         external
2272         payable
2273         onlyOwner
2274     {
2275         for (uint256 i; i < _to.length; ) {
2276             require(
2277                 totalSupply() + _amount[i] - 1 <= maxSupply,
2278                 "Not enough supply"
2279             );
2280             _safeMint(_to[i], _amount[i]);
2281 
2282             unchecked {
2283                 i++;
2284             }
2285         }
2286     }
2287 
2288     function _baseURI() internal view virtual override returns (string memory) {
2289         return baseURI;
2290     }
2291 
2292     function walletOfOwner(address _owner)
2293         public
2294         view
2295         returns (uint256[] memory)
2296     {
2297         uint256 ownerTokenCount = balanceOf(_owner);
2298         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
2299         uint256 currentTokenId = 1;
2300         uint256 ownedTokenIndex = 0;
2301 
2302         while (
2303             ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply
2304         ) {
2305             address currentTokenOwner = ownerOf(currentTokenId);
2306             if (currentTokenOwner == _owner) {
2307                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
2308                 ownedTokenIndex++;
2309             }
2310 
2311             currentTokenId++;
2312         }
2313 
2314         return ownedTokenIds;
2315     }
2316 
2317     function tokenURI(uint256 tokenId)
2318         public
2319         view
2320         virtual
2321         override
2322         returns (string memory)
2323     {
2324         require(
2325             _exists(tokenId),
2326             "ERC721Metadata: URI query for nonexistent token"
2327         );
2328         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
2329     }
2330 
2331     function setBaseURI(string memory uri) public onlyOwner {
2332         baseURI = uri;
2333     }
2334 
2335     function setFreeAmount(uint256 amount) external onlyOwner {
2336         totalFree = amount;
2337     }
2338 
2339     function setPrice(uint256 _newPrice) external onlyOwner {
2340         price = _newPrice;
2341     }
2342 
2343     function flipSale() external onlyOwner {
2344         mintEnabled = !mintEnabled;
2345     }
2346 
2347     function withdraw() external onlyOwner {
2348         (bool success, ) = payable(msg.sender).call{
2349             value: address(this).balance
2350         }("");
2351         require(success, "Transfer failed.");
2352     }
2353 }