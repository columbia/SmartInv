1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.14;
4 
5 //  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _                         
6 // |   ____  _          ____                 |
7 // |  / ___|(_) _   _  |  _ \   ___ __   __  |
8 // | | |  _ | || | | | | | | | / _ \\ \ / /  |
9 // | | |_| || || |_| | | |_| ||  __/ \ V /   |
10 // |  \____||_| \__,_| |____/  \___|  \_/    |
11 // | _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ |    
12                                   
13 interface IERC721A {
14 
15     // The caller must own the token or be an approved operator
16     error ApprovalCallerNotOwnerNorApproved();
17 
18     //The token does not exist
19     error ApprovalQueryForNonexistentToken();
20 
21     //The caller cannot approve to their own address
22     error ApproveToCaller();
23 
24     //The caller cannot approve to the current owner
25     error ApprovalToCurrentOwner();
26 
27     //Cannot query the balance for the zero address
28     error BalanceQueryForZeroAddress();
29 
30     //Cannot mint to the zero address
31     error MintToZeroAddress();
32 
33     //The quantity of tokens minted must be more than zero
34     error MintZeroQuantity();
35 
36     //The token does not exist
37     error OwnerQueryForNonexistentToken();
38 
39     //The caller must own the token or be an approved operator.
40     error TransferCallerNotOwnerNorApproved();
41 
42     ///The token must be owned by `from`
43     error TransferFromIncorrectOwner();
44 
45     //Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
46     error TransferToNonERC721ReceiverImplementer();
47 
48     //Cannot transfer to the zero address
49     error TransferToZeroAddress();
50 
51     //The token does not exist
52     error URIQueryForNonexistentToken();
53 
54     struct TokenOwnership {
55         // The address of the owner.
56         address addr;
57         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
58         uint64 startTimestamp;
59         // Whether the token has been burned.
60         bool burned;}
61 
62     //Returns the total amount of tokens stored by the contract
63     //Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens
64     function totalSupply() external view returns (uint256);
65 
66     //Returns true if this contract implements the interface defined by `interfaceId`
67     function supportsInterface(bytes4 interfaceId) external view returns (bool);
68 
69     //Emitted when `tokenId` token is transferred from `from` to `to`
70     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
71 
72     //Emitted when `owner` enables `approved` to manage the `tokenId` token
73     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
74 
75     //Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets
76     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
77 
78     //Returns the number of tokens in `owner` account
79     function balanceOf(address owner) external view returns (uint256 balance);
80 
81     //Returns the owner of the `tokenId` token
82     function ownerOf(uint256 tokenId) external view returns (address owner);
83 
84     //Safely transfers `tokenId` token from `from` to `to`
85     //Requirements: `from` cannot be the zero address
86     //              `to` cannot be the zero address
87     //              `tokenId` token must exist and be owned by `from`
88     //              If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}
89     //              If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer
90     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
91 
92     //Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients are aware of the ERC721 protocol to prevent tokens from being forever locked.
93     //Requirements: `from` cannot be the zero address.
94     //              `to` cannot be the zero address.
95     //              `tokenId` token must exist and be owned by `from`
96     //              If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}
97     //              If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer
98     function safeTransferFrom(address from, address to, uint256 tokenId) external;
99 
100     //Transfers `tokenId` token from `from` to `to`
101     //Requirements: `from` cannot be the zero address
102     //              `to` cannot be the zero address
103     //              `tokenId` token must be owned by `from`
104     //              If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}
105     function transferFrom(address from, address to, uint256 tokenId) external;
106 
107     //Gives permission to `to` to transfer `tokenId` token to another account
108     function approve(address to, uint256 tokenId) external;
109 
110     //Approve or remove `operator` as an operator for the caller
111     //Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller
112     //Requirements: The `operator` cannot be the caller.
113     function setApprovalForAll(address operator, bool _approved) external;
114 
115     //Returns the account approved for `tokenId` token.
116     //Requirements: `tokenId` must exist
117     function getApproved(uint256 tokenId) external view returns (address operator);
118 
119     //Returns if the `operator` is allowed to manage all of the assets of `owner`
120     function isApprovedForAll(address owner, address operator) external view returns (bool);
121 
122     //Returns the token collection name
123     function name() external view returns (string memory);
124 
125     //Returns the token collection symbol
126     function symbol() external view returns (string memory);
127 
128     //Returns the Uniform Resource Identifier (URI) for `tokenId` token
129     function tokenURI(uint256 tokenId) external view returns (string memory);}
130 
131 interface ERC721A__IERC721Receiver {
132     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);}
133 
134 contract ERC721A is IERC721A {
135     // Mask of an entry in packed address data.
136     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
137 
138     // The bit position of `numberMinted` in packed address data.
139     uint256 private constant BITPOS_NUMBER_MINTED = 64;
140 
141     // The bit position of `numberBurned` in packed address data.
142     uint256 private constant BITPOS_NUMBER_BURNED = 128;
143 
144     // The bit position of `aux` in packed address data.
145     uint256 private constant BITPOS_AUX = 192;
146 
147     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
148     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
149 
150     // The bit position of `startTimestamp` in packed ownership.
151     uint256 private constant BITPOS_START_TIMESTAMP = 160;
152 
153     // The bit mask of the `burned` bit in packed ownership.
154     uint256 private constant BITMASK_BURNED = 1 << 224;
155     
156     // The bit position of the `nextInitialized` bit in packed ownership.
157     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
158 
159     // The bit mask of the `nextInitialized` bit in packed ownership.
160     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
161 
162     // The tokenId of the next token to be minted.
163     uint256 private _currentIndex;
164 
165     // The number of tokens burned.
166     uint256 private _burnCounter;
167 
168     // Token name
169     string private _name;
170 
171     // Token symbol
172     string private _symbol;
173 
174     // Mapping from token ID to ownership details
175     // An empty struct value does not necessarily mean the token is unowned.
176     // See `_packedOwnershipOf` implementation for details.
177     //
178     // Bits Layout:
179     // - [0..159]   `addr`
180     // - [160..223] `startTimestamp`
181     // - [224]      `burned`
182     // - [225]      `nextInitialized`
183     mapping(uint256 => uint256) private _packedOwnerships;
184 
185     // Mapping owner address to address data.
186     //
187     // Bits Layout:
188     // - [0..63]    `balance`
189     // - [64..127]  `numberMinted`
190     // - [128..191] `numberBurned`
191     // - [192..255] `aux`
192     mapping(address => uint256) private _packedAddressData;
193 
194     // Mapping from token ID to approved address.
195     mapping(uint256 => address) private _tokenApprovals;
196 
197     // Mapping from owner to operator approvals
198     mapping(address => mapping(address => bool)) private _operatorApprovals;
199 
200     constructor(string memory name_, string memory symbol_) {
201         _name = name_;
202         _symbol = symbol_;
203         _currentIndex = _startTokenId();}
204 
205     //Returns the starting token ID
206     function _startTokenId() internal view virtual returns (uint256) {
207         return 0;}
208 
209     //Returns the next token ID to be minted
210     function _nextTokenId() internal view returns (uint256) {
211         return _currentIndex;}
212 
213     //Returns the total number of tokens in existence
214     function totalSupply() public view override returns (uint256) {
215         // Counter underflow is impossible as _burnCounter cannot be incremented
216         // more than `_currentIndex - _startTokenId()` times.
217         unchecked {return _currentIndex - _burnCounter - _startTokenId();}}
218 
219     //Returns the total amount of tokens minted in the contract
220     function _totalMinted() internal view returns (uint256) {
221         // Counter underflow is impossible as _currentIndex does not decrement,
222         // and it is initialized to `_startTokenId()`
223         unchecked {
224             return _currentIndex - _startTokenId();}}
225 
226     //Returns the total number of tokens burned
227     function _totalBurned() internal view returns (uint256) {
228         return _burnCounter;}
229 
230     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
231         // The interface IDs are constants representing the first 4 bytes of the XOR of
232         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
233         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
234         return
235             interfaceId == 0x01ffc9a7 || interfaceId == 0x80ac58cd || interfaceId == 0x5b5e139f;}
236 
237     function balanceOf(address owner) public view override returns (uint256) {
238         if (owner == address(0)) revert BalanceQueryForZeroAddress();
239         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;}
240 
241     function _numberMinted(address owner) internal view returns (uint256) {
242         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;}
243 
244     function _numberBurned(address owner) internal view returns (uint256) {
245         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;}
246 
247     function _getAux(address owner) internal view returns (uint64) {
248         return uint64(_packedAddressData[owner] >> BITPOS_AUX);}
249 
250     function _setAux(address owner, uint64 aux) internal {
251         uint256 packed = _packedAddressData[owner];
252         uint256 auxCasted;
253         assembly { // Cast aux without masking.
254             auxCasted := aux}
255         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
256         _packedAddressData[owner] = packed;}
257 
258     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
259         uint256 curr = tokenId;
260         unchecked {
261             if (_startTokenId() <= curr)
262                 if (curr < _currentIndex) {
263                     uint256 packed = _packedOwnerships[curr];
264                     // If not burned.
265                     if (packed & BITMASK_BURNED == 0) {
266                         // Invariant:
267                         // There will always be an ownership that has an address and is not burned
268                         // before an ownership that does not have an address and is not burned.
269                         // Hence, curr will not underflow.
270                         //
271                         // We can directly compare the packed value.
272                         // If the address is zero, packed is zero.
273                         while (packed == 0) {
274                             packed = _packedOwnerships[--curr];}
275                         return packed;}}}
276         revert OwnerQueryForNonexistentToken();}
277 
278     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
279         ownership.addr = address(uint160(packed));
280         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
281         ownership.burned = packed & BITMASK_BURNED != 0;}
282 
283     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
284         return _unpackedOwnership(_packedOwnerships[index]);}
285 
286     function _initializeOwnershipAt(uint256 index) internal {
287         if (_packedOwnerships[index] == 0) {
288             _packedOwnerships[index] = _packedOwnershipOf(index);}}
289 
290     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
291         return _unpackedOwnership(_packedOwnershipOf(tokenId));}
292 
293     function ownerOf(uint256 tokenId) public view override returns (address) {
294         return address(uint160(_packedOwnershipOf(tokenId)));}
295 
296     function name() public view virtual override returns (string memory) {
297         return _name;}
298 
299     function symbol() public view virtual override returns (string memory) {
300         return _symbol;}
301 
302     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
303         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
304         string memory baseURI = _baseURI();
305         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';}
306 
307     //Base URI for computing {tokenURI}. 
308     function _baseURI() internal view virtual returns (string memory) {
309         return '';}
310 
311     function _addressToUint256(address value) private pure returns (uint256 result) {
312         assembly {
313             result := value}}
314 
315     function _boolToUint256(bool value) private pure returns (uint256 result) {
316         assembly {
317             result := value}}
318 
319     function approve(address to, uint256 tokenId) public override {
320         address owner = address(uint160(_packedOwnershipOf(tokenId)));
321         if (to == owner) revert ApprovalToCurrentOwner();
322         if (_msgSenderERC721A() != owner)
323             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
324                 revert ApprovalCallerNotOwnerNorApproved();}
325         _tokenApprovals[tokenId] = to;
326         emit Approval(owner, to, tokenId);}
327 
328     function getApproved(uint256 tokenId) public view override returns (address) {
329         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
330         return _tokenApprovals[tokenId];}
331 
332     function setApprovalForAll(address operator, bool approved) public virtual override {
333         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
334         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
335         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);}
336 
337     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
338         return _operatorApprovals[owner][operator];}
339 
340     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
341         _transfer(from, to, tokenId);}
342 
343     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
344         safeTransferFrom(from, to, tokenId, '');}
345 
346     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
347         _transfer(from, to, tokenId);
348         if (to.code.length != 0)
349             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
350                 revert TransferToNonERC721ReceiverImplementer();}}
351 
352     //Returns whether `tokenId` exists
353     function _exists(uint256 tokenId) internal view returns (bool) {
354         return _startTokenId() <= tokenId && tokenId < _currentIndex && _packedOwnerships[tokenId] & BITMASK_BURNED == 0;}
355 
356     //Equivalent to `_safeMint(to, quantity, '')`
357     function _safeMint(address to, uint256 quantity) internal {
358         _safeMint(to, quantity, '');}
359 
360     //Safely mints `quantity` tokens and transfers them to `to`
361     function _safeMint(address to, uint256 quantity, bytes memory _data) internal {
362         uint256 startTokenId = _currentIndex;
363         if (to == address(0)) revert MintToZeroAddress();
364         if (quantity == 0) revert MintZeroQuantity();
365         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
366         // Overflows are incredibly unrealistic.
367         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
368         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
369         unchecked {
370             // Updates:
371             // - `balance += quantity`.
372             // - `numberMinted += quantity`.
373             //
374             // We can directly add to the balance and number minted.
375             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
376             // Updates:
377             // - `address` to the owner.
378             // - `startTimestamp` to the timestamp of minting.
379             // - `burned` to `false`.
380             // - `nextInitialized` to `quantity == 1`.
381             _packedOwnerships[startTokenId] =
382                 _addressToUint256(to) |
383                 (block.timestamp << BITPOS_START_TIMESTAMP) |
384                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
385             uint256 updatedIndex = startTokenId;
386             uint256 end = updatedIndex + quantity;
387             if (to.code.length != 0) {
388                 do {
389                     emit Transfer(address(0), to, updatedIndex);
390                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
391                         revert TransferToNonERC721ReceiverImplementer();}} 
392                 while (updatedIndex < end);
393                 // Reentrancy protection
394                 if (_currentIndex != startTokenId) revert();} 
395                 else {
396                 do {emit Transfer(address(0), to, updatedIndex++);} while (updatedIndex < end);}
397             _currentIndex = updatedIndex;}
398         _afterTokenTransfers(address(0), to, startTokenId, quantity);}
399 
400     //Mints `quantity` tokens and transfers them to `to`
401     function _mint(address to, uint256 quantity) internal {
402         uint256 startTokenId = _currentIndex;
403         if (to == address(0)) revert MintToZeroAddress();
404         if (quantity == 0) revert MintZeroQuantity();
405         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
406         // Overflows are incredibly unrealistic.
407         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
408         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
409         unchecked {
410             // Updates:
411             // - `balance += quantity`.
412             // - `numberMinted += quantity`.
413             //
414             // We can directly add to the balance and number minted.
415             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
416             // Updates:
417             // - `address` to the owner.
418             // - `startTimestamp` to the timestamp of minting.
419             // - `burned` to `false`.
420             // - `nextInitialized` to `quantity == 1`.
421             _packedOwnerships[startTokenId] =
422                 _addressToUint256(to) |
423                 (block.timestamp << BITPOS_START_TIMESTAMP) |
424                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
425             uint256 updatedIndex = startTokenId;
426             uint256 end = updatedIndex + quantity;
427             do {emit Transfer(address(0), to, updatedIndex++);} while (updatedIndex < end);
428             _currentIndex = updatedIndex;}
429         _afterTokenTransfers(address(0), to, startTokenId, quantity);}
430 
431     //Transfers `tokenId` from `from` to `to`
432     function _transfer(address from, address to, uint256 tokenId) private {
433         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
434         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
435         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
436             isApprovedForAll(from, _msgSenderERC721A()) ||
437             getApproved(tokenId) == _msgSenderERC721A());
438         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
439         if (to == address(0)) revert TransferToZeroAddress();
440         _beforeTokenTransfers(from, to, tokenId, 1);
441         // Clear approvals from the previous owner.
442         delete _tokenApprovals[tokenId];
443         // Underflow of the sender's balance is impossible because we check for
444         // ownership above and the recipient's balance can't realistically overflow.
445         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
446         unchecked {
447             // We can directly increment and decrement the balances.
448             --_packedAddressData[from]; // Updates: `balance -= 1`.
449             ++_packedAddressData[to]; // Updates: `balance += 1`.
450             // Updates:
451             // - `address` to the next owner.
452             // - `startTimestamp` to the timestamp of transfering.
453             // - `burned` to `false`.
454             // - `nextInitialized` to `true`.
455             _packedOwnerships[tokenId] =
456                 _addressToUint256(to) |
457                 (block.timestamp << BITPOS_START_TIMESTAMP) |
458                 BITMASK_NEXT_INITIALIZED;
459             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
460             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
461                 uint256 nextTokenId = tokenId + 1;
462                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
463                 if (_packedOwnerships[nextTokenId] == 0) {
464                     // If the next slot is within bounds.
465                     if (nextTokenId != _currentIndex) {
466                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
467                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;}}}}
468         emit Transfer(from, to, tokenId);
469         _afterTokenTransfers(from, to, tokenId, 1);}
470 
471     //Equivalent to `_burn(tokenId, false)`
472     function _burn(uint256 tokenId) internal virtual {
473         _burn(tokenId, false);}
474 
475     //Destroys `tokenId`
476     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
477         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
478         address from = address(uint160(prevOwnershipPacked));
479         if (approvalCheck) {
480             bool isApprovedOrOwner = (_msgSenderERC721A() == from || isApprovedForAll(from, _msgSenderERC721A()) || getApproved(tokenId) == _msgSenderERC721A());
481             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();}
482         _beforeTokenTransfers(from, address(0), tokenId, 1);
483         // Clear approvals from the previous owner.
484         delete _tokenApprovals[tokenId];
485         // Underflow of the sender's balance is impossible because we check for
486         // ownership above and the recipient's balance can't realistically overflow.
487         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
488         unchecked {
489             // Updates:
490             // - `balance -= 1`.
491             // - `numberBurned += 1`.
492             //
493             // We can directly decrement the balance, and increment the number burned.
494             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
495             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
496             // Updates:
497             // - `address` to the last owner.
498             // - `startTimestamp` to the timestamp of burning.
499             // - `burned` to `true`.
500             // - `nextInitialized` to `true`.
501             _packedOwnerships[tokenId] =
502                 _addressToUint256(from) |
503                 (block.timestamp << BITPOS_START_TIMESTAMP) |
504                 BITMASK_BURNED | 
505                 BITMASK_NEXT_INITIALIZED;
506             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
507             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
508                 uint256 nextTokenId = tokenId + 1;
509                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
510                 if (_packedOwnerships[nextTokenId] == 0) {
511                     // If the next slot is within bounds.
512                     if (nextTokenId != _currentIndex) {
513                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
514                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;}}}}
515         emit Transfer(from, address(0), tokenId);
516         _afterTokenTransfers(from, address(0), tokenId, 1);
517         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
518         unchecked {_burnCounter++;}}
519 
520     //Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract
521     function _checkContractOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
522         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (bytes4 retval) {
523             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;} 
524             catch (bytes memory reason) {
525             if (reason.length == 0) {
526                 revert TransferToNonERC721ReceiverImplementer();} 
527             else {
528                 assembly {revert(add(32, reason), mload(reason))}}}}
529 
530     //Hook that is called before a set of serially-ordered token ids are about to be transferred
531     function _beforeTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {}
532 
533     //Hook that is called after a set of serially-ordered token ids have been transferred
534     function _afterTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {}
535 
536     //Returns the message sender (defaults to `msg.sender`)
537     function _msgSenderERC721A() internal view virtual returns (address) {
538         return msg.sender;}
539 
540     //Converts a `uint256` to its ASCII `string` decimal representation
541     function _toString(uint256 value) internal pure returns (string memory ptr) {
542         assembly {
543             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
544             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
545             // We will need 1 32-byte word to store the length, 
546             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
547             ptr := add(mload(0x40), 128)
548             // Update the free memory pointer to allocate.
549             mstore(0x40, ptr)
550 
551             // Cache the end of the memory to calculate the length later.
552             let end := ptr
553 
554             // We write the string from the rightmost digit to the leftmost digit.
555             // The following is essentially a do-while loop that also handles the zero case.
556             // Costs a bit more than early returning for the zero case,
557             // but cheaper in terms of deployment and overall runtime costs.
558             for { 
559                 // Initialize and perform the first pass without check.
560                 let temp := value
561                 // Move the pointer 1 byte leftwards to point to an empty character slot.
562                 ptr := sub(ptr, 1)
563                 // Write the character to the pointer. 48 is the ASCII index of '0'.
564                 mstore8(ptr, add(48, mod(temp, 10)))
565                 temp := div(temp, 10)} 
566             temp { 
567                 // Keep dividing `temp` until zero.
568                 temp := div(temp, 10)} { // Body of the for loop.
569                 ptr := sub(ptr, 1)
570                 mstore8(ptr, add(48, mod(temp, 10)))}
571             let length := sub(end, ptr)
572             // Move the pointer 32 bytes leftwards to make room for the length.
573             ptr := sub(ptr, 32)
574             // Store the length.
575             mstore(ptr, length)}}}
576 
577 abstract contract ReentrancyGuard {
578     uint256 private constant _NOT_ENTERED = 1;
579     uint256 private constant _ENTERED = 2;
580     uint256 private _status;
581 
582     constructor() {
583         _status = _NOT_ENTERED;}
584 
585     //Prevents a contract from calling itself, directly or indirectly.
586     //Calling a `nonReentrant` function from another `nonReentrant`function is not supported. 
587     modifier nonReentrant() {
588         // On the first call to nonReentrant, _notEntered will be true
589         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
590         // Any calls to nonReentrant after this point will fail
591         _status = _ENTERED;
592         _;
593         _status = _NOT_ENTERED;}}
594 
595 abstract contract Context {
596     function _msgSender() internal view virtual returns (address) {
597         return msg.sender;}
598 
599     function _msgData() internal view virtual returns (bytes calldata) {
600         return msg.data;}}
601 
602 abstract contract Ownable is Context {
603 
604     address private _owner;
605     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
606 
607     constructor() {
608         //dev Initializes the contract setting the deployer as the initial owner
609         _transferOwnership(_msgSender());}
610 
611     function owner() public view virtual returns (address) {
612         //Returns the address of the current owner
613         return _owner;}
614 
615     modifier onlyOwner() {
616         //Throws if called by any account other than the owner
617         require(owner() == _msgSender(), "Ownable: caller is not the owner");
618         _;}
619 
620     function renounceOwnership() public virtual onlyOwner {
621         //Leaves the contract without owner
622         _transferOwnership(address(0));}
623 
624     function transferOwnership(address newOwner) public virtual onlyOwner {
625         //Transfers ownership of the contract to a new account (`newOwner`)
626         require(newOwner != address(0), "Ownable: new owner is the zero address");
627         _transferOwnership(newOwner);}
628 
629     function _transferOwnership(address newOwner) internal virtual {
630         //Transfers ownership of the contract to a new account (`newOwner`)
631         address oldOwner = _owner;
632         _owner = newOwner;
633         emit OwnershipTransferred(oldOwner, newOwner);}}
634 
635 library Strings {
636     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
637     uint8 private constant _ADDRESS_LENGTH = 20;
638 
639     function toString(uint256 value) internal pure returns (string memory) {
640         if (value == 0) {
641             return "0";}
642         uint256 temp = value;
643         uint256 digits;
644         while (temp != 0) {
645             digits++;
646             temp /= 10;}
647         bytes memory buffer = new bytes(digits);
648         while (value != 0) {
649             digits -= 1;
650             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
651             value /= 10;}
652         return string(buffer);}
653     function toHexString(uint256 value) internal pure returns (string memory) {
654         if (value == 0) {
655             return "0x00";}
656         uint256 temp = value;
657         uint256 length = 0;
658         while (temp != 0) {
659             length++;
660             temp >>= 8;}
661         return toHexString(value, length);}
662     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
663         bytes memory buffer = new bytes(2 * length + 2);
664         buffer[0] = "0";
665         buffer[1] = "x";
666         for (uint256 i = 2 * length + 1; i > 1; --i) {
667             buffer[i] = _HEX_SYMBOLS[value & 0xf];
668             value >>= 4;}
669         require(value == 0, "Strings: hex length insufficient");
670         return string(buffer);}
671     function toHexString(address addr) internal pure returns (string memory) {
672         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);}}
673 
674 contract starfighter is ERC721A, Ownable, ReentrancyGuard {
675 
676     using Strings for uint256;
677 
678     string public uriPrefix = "";
679     string public uriSuffix = ".json";
680 
681     uint256 public costWhitelist = 0.05 ether;
682     uint256 public costNormal = 0.06 ether;
683     uint256 public NFTminted;
684 
685     bool public paused = true;
686     bool public whitelistMintEnabled = false;
687     bool public revealed = false;
688 
689     //mapping(address => bool) public whitelistClaimed;
690     mapping (address => bool) public whitelisted;
691     mapping(address => uint) public minted;
692 
693     string public tokenName = "STARFIGHTER CLUB";
694     string public tokenSymbol = "SFC";
695     uint256 public maxSupply = 333;
696     uint256 public maxMintAmountPerTx = 12;
697     string public hiddenMetadataUri = "ipfs://QmVUr53zcyrXr7VfBg7PLjmMcL17N5Xej8bKSBbRAro8tQ/hidden.json";
698     
699     constructor() ERC721A(tokenName, tokenSymbol) {
700             maxSupply = maxSupply;
701             setMaxMintAmountPerTx(maxMintAmountPerTx);
702             setHiddenMetadataUri(hiddenMetadataUri);}
703 
704     modifier mintCompliance(uint256 _mintAmount) {
705         require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
706         require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
707         _;}
708 
709     modifier mintPriceCompliance(uint256 _mintAmount) {
710         if(whitelistMintEnabled == true && paused == true){
711             require(msg.value >= costWhitelist * _mintAmount, 'Insufficient funds!');}
712         if(paused == false){
713             require(msg.value >= costNormal * _mintAmount, 'Insufficient funds!');}
714         _;}
715 
716     function setCostWhitelist(uint256 _cost) public onlyOwner {
717         //Ether cost
718         costWhitelist = _cost;}
719 
720     function setCostNormal(uint256 _cost) public onlyOwner {
721         //Ether cost
722         costNormal = _cost;}
723 
724     function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
725         require(!paused, 'The contract is paused!');
726         minted[_msgSender()] = minted[_msgSender()] + _mintAmount;//CHECK
727         require(minted[_msgSender()] <= maxMintAmountPerTx, "Max quantity reached");
728         NFTminted += _mintAmount;
729             _safeMint(_msgSender(), _mintAmount);}
730 
731     function burn(uint256 tokenId) public {
732         _burn(tokenId, true); }
733 
734     function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
735         require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
736         //Minted by Owner without any cost, doesn't count on minted quantity
737         NFTminted += _mintAmount;
738         _safeMint(_receiver, _mintAmount);}
739 
740     function _startTokenId() internal view virtual override returns (uint256) {
741         return 1;}
742 
743     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
744         require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
745         if (revealed == false) {
746             return hiddenMetadataUri;}
747         string memory currentBaseURI = _baseURI();
748         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix)): '';}
749     
750     function setRevealed(bool _state) public onlyOwner {
751         //Reveal the token URI of the NFTs
752         revealed = _state;}
753 
754     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
755         maxMintAmountPerTx = _maxMintAmountPerTx;}
756 
757     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
758         hiddenMetadataUri = _hiddenMetadataUri;}
759 
760     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
761         uriPrefix = _uriPrefix;}
762 
763     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
764         uriSuffix = _uriSuffix;}
765 
766     function setPaused(bool _state) public onlyOwner {
767         paused = _state;}
768 
769     function setWhitelistMintEnabled(bool _state) public onlyOwner {
770         whitelistMintEnabled = _state;}
771 
772     function whitelist(address _addr) public onlyOwner() {
773         require(!whitelisted[_addr], "Account is already Whitlisted");
774         whitelisted[_addr] = true;}
775 
776     function blacklist_A_whitelisted(address _addr) external onlyOwner() {
777         require(whitelisted[_addr], "Account is already Blacklisted");
778         whitelisted[_addr] = false;}
779 
780     function whitelistMint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
781         // Verify whitelist requirements
782         require(whitelistMintEnabled, 'The whitelist sale is not enabled!');
783         //require(!whitelistClaimed[_msgSender()], 'Address already claimed!');
784         require(whitelisted[_msgSender()], "Account is not in whitelist");
785         minted[_msgSender()] = minted[_msgSender()] + _mintAmount;//CHECK
786         require(minted[_msgSender()] <= maxMintAmountPerTx, "Max quantity reached");
787         NFTminted += _mintAmount;
788         //whitelistClaimed[_msgSender()] = true;
789         _safeMint(_msgSender(), _mintAmount);}
790 
791     function withdraw() public onlyOwner nonReentrant {
792     // This will transfer the remaining contract balance to the owner.
793     // Do not remove this otherwise you will not be able to withdraw the funds.
794     // =============================================================================
795         (bool os, ) = payable(owner()).call{value: address(this).balance}('');
796         require(os);}
797         
798     function _baseURI() internal view virtual override returns (string memory) {
799         return uriPrefix;}}