1 // SPDX-License-Identifier: MIT
2 
3 // File: contracts/core/NiftyEntity.sol
4 
5 /**
6  * @dev Authenticator of state mutating operations for Nifty Gateway contracts. 
7  *
8  * addresses for stateful operations. 
9  *
10  * Rinkeby: 0xCefBf44ff649B6E0Bc63785699c6F1690b8cF73b
11  * Mainnet: 0x6e53130dDfF21E3BC963Ee902005223b9A202106
12  */
13 contract NiftyEntity {
14    
15    // Address of {NiftyRegistry} contract. 
16    address internal immutable niftyRegistryContract;
17    
18    /**
19     * @dev Determines whether accounts are allowed to invoke state mutating operations on child contracts.
20     */
21     modifier onlyValidSender() {
22         NiftyRegistry niftyRegistry = NiftyRegistry(niftyRegistryContract);
23         bool isValid = niftyRegistry.isValidNiftySender(msg.sender);
24         require(isValid, "NiftyEntity: Invalid msg.sender");
25         _;
26     }
27     
28    /**
29     * @param _niftyRegistryContract Points to the repository of authenticated
30     */
31     constructor(address _niftyRegistryContract) {
32         niftyRegistryContract = _niftyRegistryContract;
33     }
34 }
35 
36 /**
37  * @dev Defined to mediate interaction with externally deployed {NiftyRegistry} dependency. 
38  */
39 interface NiftyRegistry {
40    function isValidNiftySender(address sending_key) external view returns (bool);
41 }
42 
43 // File: contracts/interface/IERC165.sol
44 
45 /**
46  * @title IERC165
47  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
48  */
49 interface IERC165 {
50 
51   /**
52    * @notice Query if a contract implements an interface
53    * @param interfaceId The interface identifier, as specified in ERC-165
54    * @dev Interface identification is specified in ERC-165. This function
55    * uses less than 30,000 gas.
56    */
57   function supportsInterface(bytes4 interfaceId)
58     external
59     view
60     returns (bool);
61 }
62 
63 // File: contracts/interface/IERC721.sol
64 
65 /**
66  * @dev Required interface of an ERC721 compliant contract.
67  */
68 interface IERC721 is IERC165 {
69     /**
70      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
73 
74     /**
75      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
76      */
77     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
78 
79     /**
80      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
81      */
82     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
83 
84     /**
85      * @dev Returns the number of tokens in ``owner``'s account.
86      */
87     function balanceOf(address owner) external view returns (uint256 balance);
88 
89     /**
90      * @dev Returns the owner of the `tokenId` token.
91      *
92      * Requirements:
93      *
94      * - `tokenId` must exist.
95      */
96     function ownerOf(uint256 tokenId) external view returns (address owner);
97 
98     /**
99      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
100      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
101      *
102      * Requirements:
103      *
104      * - `from` cannot be the zero address.
105      * - `to` cannot be the zero address.
106      * - `tokenId` token must exist and be owned by `from`.
107      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
108      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
109      *
110      * Emits a {Transfer} event.
111      */
112     function safeTransferFrom(address from, address to, uint256 tokenId) external;
113 
114     /**
115      * @dev Transfers `tokenId` token from `from` to `to`.
116      *
117      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
118      *
119      * Requirements:
120      *
121      * - `from` cannot be the zero address.
122      * - `to` cannot be the zero address.
123      * - `tokenId` token must be owned by `from`.
124      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
125      *
126      * Emits a {Transfer} event.
127      */
128     function transferFrom(address from, address to, uint256 tokenId) external;
129 
130     /**
131      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
132      * The approval is cleared when the token is transferred.
133      *
134      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
135      *
136      * Requirements:
137      *
138      * - The caller must own the token or be an approved operator.
139      * - `tokenId` must exist.
140      *
141      * Emits an {Approval} event.
142      */
143     function approve(address to, uint256 tokenId) external;
144 
145     /**
146      * @dev Returns the account approved for `tokenId` token.
147      *
148      * Requirements:
149      *
150      * - `tokenId` must exist.
151      */
152     function getApproved(uint256 tokenId) external view returns (address operator);
153 
154     /**
155      * @dev Approve or remove `operator` as an operator for the caller.
156      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
157      *
158      * Requirements:
159      *
160      * - The `operator` cannot be the caller.
161      *
162      * Emits an {ApprovalForAll} event.
163      */
164     function setApprovalForAll(address operator, bool _approved) external;
165 
166     /**
167      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
168      *
169      * See {setApprovalForAll}
170      */
171     function isApprovedForAll(address owner, address operator) external view returns (bool);
172 
173     /**
174       * @dev Safely transfers `tokenId` token from `from` to `to`.
175       *
176       * Requirements:
177       *
178       * - `from` cannot be the zero address.
179       * - `to` cannot be the zero address.
180       * - `tokenId` token must exist and be owned by `from`.
181       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
182       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
183       *
184       * Emits a {Transfer} event.
185       */
186     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
187 }
188 
189 // File: contracts/interface/IERC721Receiver.sol
190 
191 /**
192  * @title ERC721 token receiver interface
193  * @dev Interface for any contract that wants to support safeTransfers
194  * from ERC721 asset contracts.
195  */
196 interface IERC721Receiver {
197     /**
198      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
199      * by `operator` from `from`, this function is called.
200      *
201      * It must return its Solidity selector to confirm the token transfer.
202      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
203      *
204      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
205      */
206     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
207 }
208 
209 // File: contracts/interface/IERC721Metadata.sol
210 
211 /**
212  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
213  * @dev See https://eips.ethereum.org/EIPS/eip-721
214  */
215 interface IERC721Metadata is IERC721 {
216 
217     /**
218      * @dev Returns the token collection name.
219      */
220     function name() external view returns (string memory);
221 
222     /**
223      * @dev Returns the token collection symbol.
224      */
225     function symbol() external view returns (string memory);
226 
227     /**
228      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
229      */
230     function tokenURI(uint256 tokenId) external view returns (string memory);
231 }
232 
233 // File: contracts/util/Context.sol
234 
235 pragma solidity ^0.8.0;
236 
237 /**
238  * @dev Provides information about the current execution context, including the
239  * sender of the transaction and its data. While these are generally available
240  * via msg.sender and msg.data, they should not be accessed in such a direct
241  * manner, since when dealing with meta-transactions the account sending and
242  * paying for execution may not be the actual sender (as far as an application
243  * is concerned).
244  *
245  * This contract is only required for intermediate, library-like contracts.
246  */
247 abstract contract Context {
248     function _msgSender() internal view virtual returns (address) {
249         return msg.sender;
250     }
251 
252     function _msgData() internal view virtual returns (bytes calldata) {
253         return msg.data;
254     }
255 }
256 
257 // File: contracts/util/Strings.sol
258 
259 /**
260  * @dev String operations.
261  */
262 library Strings {
263     bytes16 private constant alphabet = "0123456789abcdef";
264 
265     /**
266      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
267      */
268     function toString(uint256 value) internal pure returns (string memory) {
269         // Inspired by OraclizeAPI's implementation - MIT licence
270         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
271 
272         if (value == 0) {
273             return "0";
274         }
275         uint256 temp = value;
276         uint256 digits;
277         while (temp != 0) {
278             digits++;
279             temp /= 10;
280         }
281         bytes memory buffer = new bytes(digits);
282         while (value != 0) {
283             digits -= 1;
284             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
285             value /= 10;
286         }
287         return string(buffer);
288     }
289 
290 }
291 
292 // File: contracts/standard/ERC165.sol
293 
294 /**
295  * @dev Implementation of the {IERC165} interface.
296  *
297  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
298  * for the additional interface id that will be supported. For example:
299  *
300  * ```solidity
301  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
302  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
303  * }
304  * ```
305  *
306  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
307  */
308 abstract contract ERC165 is IERC165 {
309     /**
310      * @dev See {IERC165-supportsInterface}.
311      */
312     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
313         return interfaceId == type(IERC165).interfaceId;
314     }
315 }
316 
317 // File: contracts/core/ERC721.sol
318 
319 /**
320  * @dev Nifty Gateway implementation of Non-Fungible Token Standard.
321  */
322 contract ERC721 is NiftyEntity, Context, ERC165, IERC721, IERC721Metadata {
323 
324     // Tracked individual instance spawned by {BuilderShop} contract. 
325     uint immutable public _id;
326 
327     // Number of distinct NFTs housed in this contract. 
328     uint immutable public _typeCount;
329 
330     // Intial receiver of all newly minted NFTs.
331     address immutable public _defaultOwner;
332 
333     // Component(s) of 'tokenId' calculation. 
334     uint immutable public topLevelMultiplier;
335     uint immutable public midLevelMultiplier;
336 
337     // Token name.
338     string private _name;
339 
340     // Token symbol.
341     string private _symbol;
342 
343     // Token artifact location.
344     string private _baseURI;
345 
346     // Mapping from Nifty type to name of token.
347     mapping(uint256 => string) private _niftyTypeName;
348 
349     // Mapping from Nifty type to IPFS hash of canonical artifcat file.
350     mapping(uint256 => string) private _niftyTypeIPFSHashes;
351 
352     // Mapping from token ID to owner address.
353     mapping (uint256 => address) internal _owners;
354 
355     // Mapping owner address to token count, by aggregating all _typeCount NFTs in the contact.
356     mapping (address => uint256) internal _balances;
357 
358     // Mapping from token ID to approved address.
359     mapping (uint256 => address) private _tokenApprovals;
360 
361     // Mapping from owner to operator approvals.
362     mapping (address => mapping (address => bool)) private _operatorApprovals;
363 
364     /**
365      * @dev Initializes the token collection.
366      *
367      * @param name_ Of the collection being deployed.
368      * @param symbol_ Shorthand token identifier, for wallets, etc.
369      * @param id_ Number instance deployed by {BuilderShop} contract.
370      * @param baseURI_ The location where the artifact assets are stored.
371      * @param typeCount_ The number of different Nifty types (different 
372      * individual NFTs) associated with the deployed collection.
373      * @param defaultOwner_ Intial receiver of all newly minted NFTs.
374      * @param niftyRegistryContract Points to the repository of authenticated
375      * addresses for stateful operations. 
376      */
377     constructor(string memory name_, 
378                 string memory symbol_,
379                 uint256 id_,
380                 string memory baseURI_,
381                 uint256 typeCount_,
382                 address defaultOwner_, 
383                 address niftyRegistryContract) NiftyEntity(niftyRegistryContract) {
384         _name = name_;
385         _symbol = symbol_;
386         _id = id_;
387         _baseURI = baseURI_;
388         _typeCount = typeCount_;
389         _defaultOwner = defaultOwner_;
390 
391         midLevelMultiplier = 100000;
392         topLevelMultiplier = id_ * 1000000000;
393     }
394 
395     /**
396      * @dev See {IERC165-supportsInterface}.
397      */
398     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
399         return interfaceId == type(IERC721).interfaceId
400             || interfaceId == type(IERC721Metadata).interfaceId
401             || super.supportsInterface(interfaceId);
402     }
403 
404     /**
405      * @dev See {IERC721-balanceOf}.
406      */
407     function balanceOf(address owner) public view virtual override returns (uint256) {
408         require(owner != address(0), "ERC721: balance query for the zero address");
409         return _balances[owner];
410     }
411 
412     /**
413      * @dev See {IERC721-ownerOf}.
414      */
415     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
416         address owner = _owners[tokenId];
417         require(owner != address(0), "ERC721: owner query for nonexistent token");
418         return owner;
419     }
420 
421     /**
422      * @dev See {IERC721Metadata-name}.
423      */
424     function name() public view virtual override returns (string memory) {
425         return _name;
426     }
427 
428     /**
429      * @dev See {IERC721Metadata-symbol}.
430      */
431     function symbol() public view virtual override returns (string memory) {
432         return _symbol;
433     }
434 
435     /**
436      * @dev Returns the link to artificat location for a given token by 'tokenId'.
437      * Throws if the token ID does not exist. May return an empty string.
438      * @param tokenId uint256 ID of the token to query.
439      * @return The location where the artifact assets are stored.
440      */
441     function tokenURI(uint256 tokenId) external view override returns (string memory) {
442         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
443         string memory tokenIdStr = Strings.toString(tokenId);
444         return string(abi.encodePacked(_baseURI, tokenIdStr));
445     }
446 
447     /**
448      * @dev Returns an IPFS hash for a given token ID.
449      * Throws if the token ID does not exist. May return an empty string.
450      * @param tokenId uint256 ID of the token to query.
451      * @return IPFS hash for this (_typeCount) NFT. 
452      */
453     function tokenIPFSHash(uint256 tokenId) external view returns (string memory) {
454         require(_exists(tokenId), "ERC721Metadata: IPFS hash query for nonexistent token");
455         uint256 niftyType = _getNiftyTypeId(tokenId);
456         return _niftyTypeIPFSHashes[niftyType];
457     }
458     
459     /**
460      * @dev Determine which NFT in the contract (_typeCount) is associated 
461      * with this 'tokenId'.
462      */
463     function _getNiftyTypeId(uint256 tokenId) internal view returns (uint256) {
464         if(tokenId <= topLevelMultiplier) {
465             return 0;
466         } else {
467             return (tokenId - topLevelMultiplier) / midLevelMultiplier;
468         }        
469     }
470 
471     /**
472      * @dev Returns the Name for a given token ID.
473      * Throws if the token ID does not exist. May return an empty string.
474      * @param tokenId uint256 ID of the token to query
475      */
476     function tokenName(uint256 tokenId) external view returns (string memory) {
477         require(_exists(tokenId), "ERC721Metadata: Name query for nonexistent token");
478         uint256 niftyType = _getNiftyTypeId(tokenId);
479         return _niftyTypeName[niftyType];
480     }
481    
482     /**
483      * @dev Internal function to set the token IPFS hash for a nifty type.
484      * @param niftyType uint256 ID component of the token to set its IPFS hash
485      * @param ipfs_hash string IPFS link to assign
486      */
487     function _setTokenIPFSHashNiftyType(uint256 niftyType, string memory ipfs_hash) internal {
488         require(bytes(_niftyTypeIPFSHashes[niftyType]).length == 0, "ERC721Metadata: IPFS hash already set");
489         _niftyTypeIPFSHashes[niftyType] = ipfs_hash;
490     }
491 
492     /**
493      * @dev Internal function to set the name for a nifty type.
494      * @param niftyType uint256 of nifty type name to be set
495      * @param nifty_type_name name of nifty type
496      */
497     function _setNiftyTypeName(uint256 niftyType, string memory nifty_type_name) internal {
498         _niftyTypeName[niftyType] = nifty_type_name;
499     }
500 
501     /**
502      * @dev Base URI for computing {tokenURI}.
503      */
504     function _setBaseURI(string memory baseURI_) internal {
505         _baseURI = baseURI_;
506     }
507 
508     /**
509      * @dev See {IERC721-approve}.
510      */
511     function approve(address to, uint256 tokenId) public virtual override {
512         address owner = ERC721.ownerOf(tokenId);
513         require(to != owner, "ERC721: approval to current owner");
514 
515         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
516             "ERC721: approve caller is not owner nor approved for all"
517         );
518 
519         _approve(to, tokenId);
520     }
521 
522     /**
523      * @dev See {IERC721-getApproved}.
524      */
525     function getApproved(uint256 tokenId) public view virtual override returns (address) {
526         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
527         return _tokenApprovals[tokenId];
528     }
529 
530     /**
531      * @dev See {IERC721-setApprovalForAll}.
532      */
533     function setApprovalForAll(address operator, bool approved) public virtual override {
534         require(operator != _msgSender(), "ERC721: approve to caller");
535         _operatorApprovals[_msgSender()][operator] = approved;
536         emit ApprovalForAll(_msgSender(), operator, approved);
537     }
538 
539     /**
540      * @dev See {IERC721-isApprovedForAll}.
541      */
542     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
543         return _operatorApprovals[owner][operator];
544     }
545 
546     /**
547      * @dev See {IERC721-transferFrom}.
548      */
549     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
550         //solhint-disable-next-line max-line-length
551         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
552         _transfer(from, to, tokenId);
553     }
554 
555     /**
556      * @dev See {IERC721-safeTransferFrom}.
557      */
558     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
559         safeTransferFrom(from, to, tokenId, "");
560     }
561 
562     /**
563      * @dev See {IERC721-safeTransferFrom}.
564      */
565     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
566         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
567         _safeTransfer(from, to, tokenId, _data);
568     }
569 
570     /**
571      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
572      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
573      *
574      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
575      *
576      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
577      * implement alternative mechanisms to perform token transfer, such as signature-based.
578      *
579      * Requirements:
580      *
581      * - `from` cannot be the zero address.
582      * - `to` cannot be the zero address.
583      * - `tokenId` token must exist and be owned by `from`.
584      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
585      *
586      * Emits a {Transfer} event.
587      */
588     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
589         _transfer(from, to, tokenId);
590         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
591     }
592 
593     /**
594      * @dev Returns whether `tokenId` exists.
595      *
596      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
597      *
598      * Tokens start existing when they are minted (`_mint`),
599      * and stop existing when they are burned (`_burn`).
600      */
601     function _exists(uint256 tokenId) internal view virtual returns (bool) {
602         return _owners[tokenId] != address(0);
603     }
604 
605     /**
606      * @dev Returns whether `spender` is allowed to manage `tokenId`.
607      *
608      * Requirements:
609      *
610      * - `tokenId` must exist.
611      */
612     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
613         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
614         address owner = ERC721.ownerOf(tokenId);
615         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
616     }
617 
618     /**
619      * @dev Destroys `tokenId`.
620      * The approval is cleared when the token is burned.
621      *
622      * Requirements:
623      *
624      * - `tokenId` must exist.
625      *
626      * Emits a {Transfer} event.
627      */
628     function _burn(uint256 tokenId) internal virtual {
629         address owner = ERC721.ownerOf(tokenId);
630 
631         // Clear approvals
632         _approve(address(0), tokenId);
633 
634         _balances[owner] -= 1;
635         delete _owners[tokenId];
636 
637         emit Transfer(owner, address(0), tokenId);
638     }
639 
640     /**
641      * @dev Transfers `tokenId` from `from` to `to`.
642      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
643      *
644      * Requirements:
645      *
646      * - `to` cannot be the zero address.
647      * - `tokenId` token must be owned by `from`.
648      *
649      * Emits a {Transfer} event.
650      */
651     function _transfer(address from, address to, uint256 tokenId) internal virtual {
652         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
653         require(to != address(0), "ERC721: transfer to the zero address");
654 
655         // Clear approvals from the previous owner
656         _approve(address(0), tokenId);
657 
658         _balances[from] -= 1;
659         _balances[to] += 1;
660         _owners[tokenId] = to;
661 
662         emit Transfer(from, to, tokenId);
663     }
664 
665     /**
666      * @dev Approve `to` to operate on `tokenId`
667      *
668      * Emits a {Approval} event.
669      */
670     function _approve(address to, uint256 tokenId) internal virtual {
671         _tokenApprovals[tokenId] = to;
672         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
673     }
674 
675     /**
676      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
677      * The call is not executed if the target address is not a contract.
678      *
679      * @param from address representing the previous owner of the given token ID
680      * @param to target address that will receive the tokens
681      * @param tokenId uint256 ID of the token to be transferred
682      * @param _data bytes optional data to send along with the call
683      * @return bool whether the call correctly returned the expected magic value
684      */
685     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
686         private returns (bool)
687     {
688         if (isContract(to)) {
689             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
690                 return retval == IERC721Receiver(to).onERC721Received.selector;
691             } catch (bytes memory reason) {
692                 if (reason.length == 0) {
693                     revert("ERC721: transfer to non ERC721Receiver implementer");
694                 } else {
695                     // solhint-disable-next-line no-inline-assembly
696                     assembly {
697                         revert(add(32, reason), mload(reason))
698                     }
699                 }
700             }
701         } else {
702             return true;
703         }
704     }
705 
706     /**
707      * @dev Returns true if `account` is a contract.
708      *
709      * [IMPORTANT]
710      * ====
711      * It is unsafe to assume that an address for which this function returns
712      * false is an externally-owned account (EOA) and not a contract.
713      *
714      * Among others, `isContract` will return false for the following
715      * types of addresses:
716      *
717      *  - an externally-owned account
718      *  - a contract in construction
719      *  - an address where a contract will be created
720      *  - an address where a contract lived, but was destroyed
721      * ====
722      */
723     function isContract(address account) internal view returns (bool) {
724         // This method relies on extcodesize, which returns 0 for contracts in
725         // construction, since the code is only stored at the end of the
726         // constructor execution.
727 
728         uint256 size;
729         // solhint-disable-next-line no-inline-assembly
730         assembly { size := extcodesize(account) }
731         return size > 0;
732     }
733 }
734 
735 // File: contracts/interface/IERC20.sol
736 
737 pragma solidity ^0.8.0;
738 
739 /**
740  * @dev Interface of the ERC20 standard as defined in the EIP.
741  */
742 interface IERC20 {
743     /**
744      * @dev Returns the amount of tokens in existence.
745      */
746     function totalSupply() external view returns (uint256);
747 
748     /**
749      * @dev Returns the amount of tokens owned by `account`.
750      */
751     function balanceOf(address account) external view returns (uint256);
752 
753     /**
754      * @dev Moves `amount` tokens from the caller's account to `recipient`.
755      *
756      * Returns a boolean value indicating whether the operation succeeded.
757      *
758      * Emits a {Transfer} event.
759      */
760     function transfer(address recipient, uint256 amount) external returns (bool);
761 
762     /**
763      * @dev Returns the remaining number of tokens that `spender` will be
764      * allowed to spend on behalf of `owner` through {transferFrom}. This is
765      * zero by default.
766      *
767      * This value changes when {approve} or {transferFrom} are called.
768      */
769     function allowance(address owner, address spender) external view returns (uint256);
770 
771     /**
772      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
773      *
774      * Returns a boolean value indicating whether the operation succeeded.
775      *
776      * IMPORTANT: Beware that changing an allowance with this method brings the risk
777      * that someone may use both the old and the new allowance by unfortunate
778      * transaction ordering. One possible solution to mitigate this race
779      * condition is to first reduce the spender's allowance to 0 and set the
780      * desired value afterwards:
781      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
782      *
783      * Emits an {Approval} event.
784      */
785     function approve(address spender, uint256 amount) external returns (bool);
786 
787     /**
788      * @dev Moves `amount` tokens from `sender` to `recipient` using the
789      * allowance mechanism. `amount` is then deducted from the caller's
790      * allowance.
791      *
792      * Returns a boolean value indicating whether the operation succeeded.
793      *
794      * Emits a {Transfer} event.
795      */
796     function transferFrom(
797         address sender,
798         address recipient,
799         uint256 amount
800     ) external returns (bool);
801 
802     /**
803      * @dev Emitted when `value` tokens are moved from one account (`from`) to
804      * another (`to`).
805      *
806      * Note that `value` may be zero.
807      */
808     event Transfer(address indexed from, address indexed to, uint256 value);
809 
810     /**
811      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
812      * a call to {approve}. `value` is the new allowance.
813      */
814     event Approval(address indexed owner, address indexed spender, uint256 value);
815 }
816 
817 // File: contracts/util/Address.sol
818 
819 pragma solidity ^0.8.0;
820 
821 /**
822  * @dev Collection of functions related to the address type
823  */
824 library Address {
825     /**
826      * @dev Returns true if `account` is a contract.
827      *
828      * [IMPORTANT]
829      * ====
830      * It is unsafe to assume that an address for which this function returns
831      * false is an externally-owned account (EOA) and not a contract.
832      *
833      * Among others, `isContract` will return false for the following
834      * types of addresses:
835      *
836      *  - an externally-owned account
837      *  - a contract in construction
838      *  - an address where a contract will be created
839      *  - an address where a contract lived, but was destroyed
840      * ====
841      */
842     function isContract(address account) internal view returns (bool) {
843         // This method relies on extcodesize, which returns 0 for contracts in
844         // construction, since the code is only stored at the end of the
845         // constructor execution.
846 
847         uint256 size;
848         assembly {
849             size := extcodesize(account)
850         }
851         return size > 0;
852     }
853 
854     /**
855      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
856      * `recipient`, forwarding all available gas and reverting on errors.
857      *
858      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
859      * of certain opcodes, possibly making contracts go over the 2300 gas limit
860      * imposed by `transfer`, making them unable to receive funds via
861      * `transfer`. {sendValue} removes this limitation.
862      *
863      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
864      *
865      * IMPORTANT: because control is transferred to `recipient`, care must be
866      * taken to not create reentrancy vulnerabilities. Consider using
867      * {ReentrancyGuard} or the
868      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
869      */
870     function sendValue(address payable recipient, uint256 amount) internal {
871         require(address(this).balance >= amount, "Address: insufficient balance");
872 
873         (bool success, ) = recipient.call{value: amount}("");
874         require(success, "Address: unable to send value, recipient may have reverted");
875     }
876 
877     /**
878      * @dev Performs a Solidity function call using a low level `call`. A
879      * plain `call` is an unsafe replacement for a function call: use this
880      * function instead.
881      *
882      * If `target` reverts with a revert reason, it is bubbled up by this
883      * function (like regular Solidity function calls).
884      *
885      * Returns the raw returned data. To convert to the expected return value,
886      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
887      *
888      * Requirements:
889      *
890      * - `target` must be a contract.
891      * - calling `target` with `data` must not revert.
892      *
893      * _Available since v3.1._
894      */
895     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
896         return functionCall(target, data, "Address: low-level call failed");
897     }
898 
899     /**
900      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
901      * `errorMessage` as a fallback revert reason when `target` reverts.
902      *
903      * _Available since v3.1._
904      */
905     function functionCall(
906         address target,
907         bytes memory data,
908         string memory errorMessage
909     ) internal returns (bytes memory) {
910         return functionCallWithValue(target, data, 0, errorMessage);
911     }
912 
913     /**
914      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
915      * but also transferring `value` wei to `target`.
916      *
917      * Requirements:
918      *
919      * - the calling contract must have an ETH balance of at least `value`.
920      * - the called Solidity function must be `payable`.
921      *
922      * _Available since v3.1._
923      */
924     function functionCallWithValue(
925         address target,
926         bytes memory data,
927         uint256 value
928     ) internal returns (bytes memory) {
929         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
930     }
931 
932     /**
933      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
934      * with `errorMessage` as a fallback revert reason when `target` reverts.
935      *
936      * _Available since v3.1._
937      */
938     function functionCallWithValue(
939         address target,
940         bytes memory data,
941         uint256 value,
942         string memory errorMessage
943     ) internal returns (bytes memory) {
944         require(address(this).balance >= value, "Address: insufficient balance for call");
945         require(isContract(target), "Address: call to non-contract");
946 
947         (bool success, bytes memory returndata) = target.call{value: value}(data);
948         return verifyCallResult(success, returndata, errorMessage);
949     }
950 
951     /**
952      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
953      * but performing a static call.
954      *
955      * _Available since v3.3._
956      */
957     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
958         return functionStaticCall(target, data, "Address: low-level static call failed");
959     }
960 
961     /**
962      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
963      * but performing a static call.
964      *
965      * _Available since v3.3._
966      */
967     function functionStaticCall(
968         address target,
969         bytes memory data,
970         string memory errorMessage
971     ) internal view returns (bytes memory) {
972         require(isContract(target), "Address: static call to non-contract");
973 
974         (bool success, bytes memory returndata) = target.staticcall(data);
975         return verifyCallResult(success, returndata, errorMessage);
976     }
977 
978     /**
979      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
980      * but performing a delegate call.
981      *
982      * _Available since v3.4._
983      */
984     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
985         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
986     }
987 
988     /**
989      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
990      * but performing a delegate call.
991      *
992      * _Available since v3.4._
993      */
994     function functionDelegateCall(
995         address target,
996         bytes memory data,
997         string memory errorMessage
998     ) internal returns (bytes memory) {
999         require(isContract(target), "Address: delegate call to non-contract");
1000 
1001         (bool success, bytes memory returndata) = target.delegatecall(data);
1002         return verifyCallResult(success, returndata, errorMessage);
1003     }
1004 
1005     /**
1006      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1007      * revert reason using the provided one.
1008      *
1009      * _Available since v4.3._
1010      */
1011     function verifyCallResult(
1012         bool success,
1013         bytes memory returndata,
1014         string memory errorMessage
1015     ) internal pure returns (bytes memory) {
1016         if (success) {
1017             return returndata;
1018         } else {
1019             // Look for revert reason and bubble it up if present
1020             if (returndata.length > 0) {
1021                 // The easiest way to bubble the revert reason is using memory via assembly
1022 
1023                 assembly {
1024                     let returndata_size := mload(returndata)
1025                     revert(add(32, returndata), returndata_size)
1026                 }
1027             } else {
1028                 revert(errorMessage);
1029             }
1030         }
1031     }
1032 }
1033 
1034 // File: contracts/util/SafeERC20.sol
1035 
1036 pragma solidity ^0.8.0;
1037 
1038 
1039 
1040 /**
1041  * @title SafeERC20
1042  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1043  * contract returns false). Tokens that return no value (and instead revert or
1044  * throw on failure) are also supported, non-reverting calls are assumed to be
1045  * successful.
1046  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1047  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1048  */
1049 library SafeERC20 {
1050     using Address for address;
1051 
1052     function safeTransfer(
1053         IERC20 token,
1054         address to,
1055         uint256 value
1056     ) internal {
1057         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1058     }
1059 
1060     function safeTransferFrom(
1061         IERC20 token,
1062         address from,
1063         address to,
1064         uint256 value
1065     ) internal {
1066         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1067     }
1068 
1069     /**
1070      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1071      * on the return value: the return value is optional (but if data is returned, it must not be false).
1072      * @param token The token targeted by the call.
1073      * @param data The call data (encoded using abi.encode or one of its variants).
1074      */
1075     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1076         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1077         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1078         // the target address contains contract code and also asserts for success in the low-level call.
1079 
1080         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1081         if (returndata.length > 0) {
1082             // Return data is optional
1083             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1084         }
1085     }
1086 }
1087 
1088 // File: contracts/interface/ICloneablePaymentSplitter.sol
1089 
1090 interface ICloneablePaymentSplitter is IERC165 {
1091     
1092     event PayeeAdded(address account, uint256 shares);
1093     event PaymentReleased(address to, uint256 amount);
1094     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
1095     event PaymentReceived(address from, uint256 amount);
1096     
1097     function initialize(address[] calldata payees, uint256[] calldata shares_) external;        
1098     function totalShares() external view returns (uint256);    
1099     function totalReleased() external view returns (uint256);
1100     function totalReleased(IERC20 token) external view returns (uint256);
1101     function shares(address account) external view returns (uint256);    
1102     function released(address account) external view returns (uint256);
1103     function released(IERC20 token, address account) external view returns (uint256);
1104     function payee(uint256 index) external view returns (address);    
1105     function release(address payable account) external;
1106     function release(IERC20 token, address account) external;
1107     function pendingPayment(address account) external view returns (uint256);
1108     function pendingPayment(IERC20 token, address account) external view returns (uint256);
1109 }
1110 
1111 // File: contracts/interface/IERC2981.sol
1112 
1113 pragma solidity ^0.8.0;
1114 
1115 
1116 ///
1117 /// @dev Interface for the NFT Royalty Standard
1118 ///
1119 interface IERC2981 is IERC165 {
1120     /// ERC165 bytes to add to interface array - set in parent contract
1121     /// implementing this standard
1122     ///
1123     /// bytes4(keccak256("royaltyInfo(uint256,uint256)")) == 0x2a55205a
1124     /// bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
1125     /// _registerInterface(_INTERFACE_ID_ERC2981);
1126 
1127     /// @notice Called with the sale price to determine how much royalty
1128     //          is owed and to whom.
1129     /// @param _tokenId - the NFT asset queried for royalty information
1130     /// @param _salePrice - the sale price of the NFT asset specified by _tokenId
1131     /// @return receiver - address of who should be sent the royalty payment
1132     /// @return royaltyAmount - the royalty payment amount for _salePrice
1133     function royaltyInfo(
1134         uint256 _tokenId,
1135         uint256 _salePrice
1136     ) external view returns (
1137         address receiver,
1138         uint256 royaltyAmount
1139     );
1140 }
1141 
1142 // File: contracts/standard/ERC721Burnable.sol
1143 
1144 /**
1145  * @title ERC721 Burnable Token
1146  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1147  */
1148 abstract contract ERC721Burnable is Context, ERC721 {
1149     /**
1150      * @dev Burns `tokenId`. See {ERC721-_burn}.
1151      *
1152      * Requirements:
1153      *
1154      * - The caller must own `tokenId` or be an approved operator.
1155      */
1156     function burn(uint256 tokenId) public virtual {
1157         //solhint-disable-next-line max-line-length
1158         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1159         _burn(tokenId);
1160     }
1161 }
1162 
1163 // File: contracts/util/Clones.sol
1164 
1165 pragma solidity ^0.8.0;
1166 
1167 // OpenZeppelin Contracts v4.4.1 (proxy/Clones.sol)
1168 // OpenZeppelin Contract Commit Hash: 6bd6b76d1156e20e45d1016f355d154141c7e5b9                                      
1169 
1170 /**
1171  * @dev https://eips.ethereum.org/EIPS/eip-1167[EIP 1167] is a standard for
1172  * deploying minimal proxy contracts, also known as "clones".
1173  *
1174  * > To simply and cheaply clone contract functionality in an immutable way, this standard specifies
1175  * > a minimal bytecode implementation that delegates all calls to a known, fixed address.
1176  *
1177  * The library includes functions to deploy a proxy using either `create` (traditional deployment) or `create2`
1178  * (salted deterministic deployment). It also includes functions to predict the addresses of clones deployed using the
1179  * deterministic method.
1180  *
1181  * _Available since v3.4._
1182  */
1183 library Clones {
1184     /**
1185      * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
1186      *
1187      * This function uses the create opcode, which should never revert.
1188      */
1189     function clone(address implementation) internal returns (address instance) {
1190         assembly {
1191             let ptr := mload(0x40)
1192             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
1193             mstore(add(ptr, 0x14), shl(0x60, implementation))
1194             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
1195             instance := create(0, ptr, 0x37)
1196         }
1197         require(instance != address(0), "ERC1167: create failed");
1198     }
1199 
1200     /**
1201      * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
1202      *
1203      * This function uses the create2 opcode and a `salt` to deterministically deploy
1204      * the clone. Using the same `implementation` and `salt` multiple time will revert, since
1205      * the clones cannot be deployed twice at the same address.
1206      */
1207     function cloneDeterministic(address implementation, bytes32 salt) internal returns (address instance) {
1208         assembly {
1209             let ptr := mload(0x40)
1210             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
1211             mstore(add(ptr, 0x14), shl(0x60, implementation))
1212             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
1213             instance := create2(0, ptr, 0x37, salt)
1214         }
1215         require(instance != address(0), "ERC1167: create2 failed");
1216     }
1217 
1218     /**
1219      * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
1220      */
1221     function predictDeterministicAddress(
1222         address implementation,
1223         bytes32 salt,
1224         address deployer
1225     ) internal pure returns (address predicted) {
1226         assembly {
1227             let ptr := mload(0x40)
1228             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
1229             mstore(add(ptr, 0x14), shl(0x60, implementation))
1230             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf3ff00000000000000000000000000000000)
1231             mstore(add(ptr, 0x38), shl(0x60, deployer))
1232             mstore(add(ptr, 0x4c), salt)
1233             mstore(add(ptr, 0x6c), keccak256(ptr, 0x37))
1234             predicted := keccak256(add(ptr, 0x37), 0x55)
1235         }
1236     }
1237 
1238     /**
1239      * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
1240      */
1241     function predictDeterministicAddress(address implementation, bytes32 salt)
1242         internal
1243         view
1244         returns (address predicted)
1245     {
1246         return predictDeterministicAddress(implementation, salt, address(this));
1247     }
1248 }
1249 
1250 // File: contracts/core/NiftyBuilderInstance.sol
1251 
1252 /** 
1253  * XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
1254  * XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  .***   XXXXXXXXXXXXXXXXXX
1255  * XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  ,*********  XXXXXXXXXXXXXXXX
1256  * XXXXXXXXXXXXXXXXXXXXXXXXXXXX  ***************  XXXXXXXXXXXXX
1257  * XXXXXXXXXXXXXXXXXXXXXXXXX  .*******************  XXXXXXXXXXX
1258  * XXXXXXXXXXXXXXXXXXXXXXX  ***********    **********  XXXXXXXX
1259  * XXXXXXXXXXXXXXXXXXXX   ***********       ***********  XXXXXX
1260  * XXXXXXXXXXXXXXXXXX  ***********         ***************  XXX
1261  * XXXXXXXXXXXXXXXX  ***********           ****    ********* XX
1262  * XXXXXXXXXXXXXXXX *********      ***    ***      *********  X
1263  * XXXXXXXXXXXXXXXX  **********  *****          *********** XXX
1264  * XXXXXXXXXXXX   /////.*************         ***********  XXXX
1265  * XXXXXXXXX  /////////...***********      ************  XXXXXX
1266  * XXXXXXX/ ///////////..... /////////   ///////////   XXXXXXXX
1267  * XXXXXX  /    //////.........///////////////////   XXXXXXXXXX
1268  * XXXXXXXXXX .///////...........//////////////   XXXXXXXXXXXXX
1269  * XXXXXXXXX .///////.....//..////  /////////  XXXXXXXXXXXXXXXX
1270  * XXXXXXX# /////////////////////  XXXXXXXXXXXXXXXXXXXXXXXXXXXX
1271  * XXXXX   ////////////////////   XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
1272  * XX   ////////////// //////   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
1273  * XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
1274  *
1275  * @dev Nifty Gateway extension of customized NFT contract, encapsulates
1276  * logic for minting new tokens, and concluding the minting process. 
1277  */
1278 contract NiftyBuilderInstance is ERC721, ERC721Burnable, IERC2981 {
1279 
1280     event RoyaltyReceiverUpdated(uint256 indexed niftyType, address previousReceiver, address newReceiver);
1281     event PaymentReleased(address to, uint256 amount);
1282     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
1283 
1284     // The artist associated with the collection.
1285     string private _creator;    
1286 
1287     uint256 immutable public _percentageTotal;
1288     mapping(uint256 => uint256) public _percentageRoyalty;
1289 
1290     mapping (uint256 => address) _royaltySplitters;
1291     mapping (uint256 => address) _royaltyReceivers;
1292 
1293     // Number of NFTs minted for a given 'typeCount'. 
1294     mapping (uint256 => uint256) public _mintCount;
1295 
1296     /**
1297      * @dev Serves as a gas cost optimized boolean flag 
1298      * to indicate whether the minting process has been 
1299      * concluded for a given 'typeCount', correspinds 
1300      * to the {_getFinalized} and {setFinalized}.
1301      */
1302     mapping (uint256 => bytes32) private _finalized;    
1303 
1304     /**
1305      * @dev Emitted when tokens are created.
1306      */
1307     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed fromAddress, address indexed toAddress);
1308 
1309     /**
1310      * @dev Ultimate instantiation of a Nifty Gateway NFT collection. 
1311      * 
1312      * @param name Of the collection being deployed.
1313      * @param symbol Shorthand token identifier, for wallets, etc.
1314      * @param id Number instance deployed by {BuilderShop} contract.
1315      * @param typeCount The number of different Nifty types (different 
1316      * individual NFTs) associated with the deployed collection.
1317      * @param baseURI The location where the artifact assets are stored.
1318      * @param creator_ The artist associated with the collection.
1319      * @param niftyRegistryContract Points to the repository of authenticated
1320      * addresses for stateful operations. 
1321      * @param defaultOwner Intial receiver of all newly minted NFTs.
1322      */
1323     constructor(
1324         string memory name,
1325         string memory symbol,
1326         uint256 id,
1327         uint256 typeCount,
1328         string memory baseURI,
1329         string memory creator_,        
1330         address niftyRegistryContract,
1331         address defaultOwner) ERC721(name, symbol, id, baseURI, typeCount, defaultOwner, niftyRegistryContract) {
1332         
1333         _creator = creator_;
1334         _percentageTotal = 10000;        
1335     }
1336 
1337     function setRoyaltyBips(uint256 niftyType, uint256 percentageRoyalty_) external onlyValidSender {
1338         require(percentageRoyalty_ <= _percentageTotal, "NiftyBuilderInstance: Illegal argument more than 100%");
1339         _percentageRoyalty[niftyType] = percentageRoyalty_;
1340     }
1341 
1342     function royaltyInfo(uint256 tokenId, uint256 salePrice) public override view returns (address, uint256) {        
1343         require(_exists(tokenId), "NiftyBuilderInstance: operator query for nonexistent token");
1344         uint256 niftyType = _getNiftyTypeId(tokenId);
1345         uint256 royaltyAmount = (salePrice * _percentageRoyalty[niftyType]) / _percentageTotal;
1346         address royaltyReceiver = _getRoyaltyReceiverByNiftyType(niftyType);
1347         require(royaltyReceiver != address(0), "NiftyBuilderInstance: No royalty receiver");
1348         return (royaltyReceiver, royaltyAmount);
1349     }
1350 
1351     // This function must be called after builder shop instance is created - it can be called again
1352     // to change the split; call this once per nifty type to set up royalty payments properly
1353     function initializeRoyalties(address splitterImplementation, uint256 niftyType, address[] calldata payees, uint256[] calldata shares_) external onlyValidSender {
1354         address previousReceiver = _getRoyaltyReceiverByNiftyType(niftyType);
1355         address newReceiver = address(0);
1356         if(payees.length == 1) {
1357             newReceiver = payees[0];
1358             _royaltyReceivers[niftyType] = newReceiver;
1359             delete _royaltySplitters[niftyType];
1360         } else {            
1361             delete _royaltyReceivers[niftyType];
1362             require(IERC165(splitterImplementation).supportsInterface(type(ICloneablePaymentSplitter).interfaceId), "Not a valid payment splitter");
1363             newReceiver = payable (Clones.clone(splitterImplementation));
1364             ICloneablePaymentSplitter(newReceiver).initialize(payees, shares_);
1365             _royaltySplitters[niftyType] = newReceiver;        
1366         }
1367 
1368         emit RoyaltyReceiverUpdated(niftyType, previousReceiver, newReceiver);        
1369     }
1370 
1371     function getRoyaltyReceiverByTokenId(uint256 tokenId) public view returns (address) {        
1372         return _getRoyaltyReceiverByNiftyType(_getNiftyTypeId(tokenId));
1373     }
1374 
1375     function getRoyaltyReceiverByNiftyType(uint256 niftyType) public view returns (address) {
1376         return _getRoyaltyReceiverByNiftyType(niftyType);
1377     }
1378 
1379     function releaseRoyalties(address payable account) external {
1380         uint256 totalPaymentAmount = 0;
1381         for(uint256 niftyType = 1; niftyType <= _typeCount; niftyType++) {
1382             address paymentSplitterAddress = _royaltySplitters[niftyType];
1383             if(paymentSplitterAddress != address(0)) {
1384                 ICloneablePaymentSplitter paymentSplitter = ICloneablePaymentSplitter(paymentSplitterAddress);    
1385                 uint256 pendingPaymentAmount = paymentSplitter.pendingPayment(account);
1386                 if(pendingPaymentAmount > 0) {
1387                     totalPaymentAmount += pendingPaymentAmount;
1388                     paymentSplitter.release(account);
1389                 }
1390             }            
1391         }
1392 
1393         if(totalPaymentAmount > 0) {
1394             emit PaymentReleased(account, totalPaymentAmount);
1395         }    
1396     }
1397 
1398     function releaseRoyalties(IERC20 token, address account) external {
1399         uint256 totalPaymentAmount = 0;
1400         for(uint256 niftyType = 1; niftyType <= _typeCount; niftyType++) {
1401             address paymentSplitterAddress = _royaltySplitters[niftyType];
1402             if(paymentSplitterAddress != address(0)) {
1403                 ICloneablePaymentSplitter paymentSplitter = ICloneablePaymentSplitter(paymentSplitterAddress);    
1404                 uint256 pendingPaymentAmount = paymentSplitter.pendingPayment(token, account);
1405                 if(pendingPaymentAmount > 0) {
1406                     totalPaymentAmount += pendingPaymentAmount;
1407                     paymentSplitter.release(token, account);
1408                 }
1409             }            
1410         }
1411 
1412         if(totalPaymentAmount > 0) {
1413             emit ERC20PaymentReleased(token, account, totalPaymentAmount);
1414         }    
1415     }
1416     
1417     function pendingRoyaltyPayment(address account) external view returns (uint256) {
1418         uint256 totalPaymentAmount = 0;
1419         for(uint256 niftyType = 1; niftyType <= _typeCount; niftyType++) {
1420             address paymentSplitterAddress = _royaltySplitters[niftyType];
1421             if(paymentSplitterAddress != address(0)) {
1422                 ICloneablePaymentSplitter paymentSplitter = ICloneablePaymentSplitter(paymentSplitterAddress);    
1423                 totalPaymentAmount += paymentSplitter.pendingPayment(account);
1424             }            
1425         }
1426         return totalPaymentAmount;
1427     }
1428 
1429     function pendingRoyaltyPayment(IERC20 token, address account) external view returns (uint256) {
1430         uint256 totalPaymentAmount = 0;
1431         for(uint256 niftyType = 1; niftyType <= _typeCount; niftyType++) {
1432             address paymentSplitterAddress = _royaltySplitters[niftyType];
1433             if(paymentSplitterAddress != address(0)) {
1434                 ICloneablePaymentSplitter paymentSplitter = ICloneablePaymentSplitter(paymentSplitterAddress);    
1435                 totalPaymentAmount += paymentSplitter.pendingPayment(token, account);
1436             }            
1437         }
1438         return totalPaymentAmount;
1439     }
1440 
1441     /**
1442      * @dev Generate canonical Nifty Gateway token representation. 
1443      * Nifty contracts have a data model called a 'niftyType' (typeCount) 
1444      * The 'niftyType' refers to a specific nifty in our contract, note 
1445      * that it gives no information about the edition size. In a given 
1446      * contract, 'niftyType' 1 could be an edition of 10, while 'niftyType' 
1447      * 2 is a 1/1, etc.
1448      * The token IDs are encoded as follows: {id}{niftyType}{edition #}
1449      * 'niftyType' has 4 digits, and edition number has 5 digits, to allow 
1450      * for 99999 possible 'niftyType' and 99999 of each edition in each contract.
1451      * Example token id: [5000100270]
1452      * This is from contract #5, it is 'niftyType' 1 in the contract, and it is 
1453      * edition #270 of 'niftyType' 1.
1454      * Example token id: [5000110000]
1455      * This is from contract #5, it is 'niftyType' 1 in the contract, and it is 
1456      * edition #10000 of 'niftyType' 1.
1457      */
1458     function _encodeTokenId(uint256 niftyType, uint256 tokenNumber) private view returns (uint256) {
1459         return (topLevelMultiplier + (niftyType * midLevelMultiplier) + tokenNumber);
1460     }
1461 
1462     /**
1463      * @dev Determine whether it is possible to mint additional NFTs for this 'niftyType'.
1464      */
1465     function _getFinalized(uint256 niftyType) public view returns (bool) {
1466         bytes32 chunk = _finalized[niftyType / 256];
1467         return (chunk & bytes32(1 << (niftyType % 256))) != 0x0;
1468     }
1469 
1470     /**
1471      * @dev Prevent the minting of additional NFTs of this 'niftyType'.
1472      */
1473     function setFinalized(uint256 niftyType) public onlyValidSender {
1474         uint256 quotient = niftyType / 256;
1475         bytes32 chunk = _finalized[quotient];
1476         _finalized[quotient] = chunk | bytes32(1 << (niftyType % 256));
1477     }
1478 
1479     /**
1480      * @dev The artist of this collection.
1481      */
1482     function creator() public view virtual returns (string memory) {
1483         return _creator;
1484     }
1485 
1486     /**
1487      * @dev Assign the root location where the artifact assets are stored.
1488      */
1489     function setBaseURI(string memory baseURI) public onlyValidSender {
1490         _setBaseURI(baseURI);
1491     }
1492 
1493     /**
1494      * @dev Allow owner to change nifty name, by 'niftyType'.
1495      */
1496     function setNiftyName(uint256 niftyType, string memory niftyName) public onlyValidSender {
1497         _setNiftyTypeName(niftyType, niftyName);
1498     }
1499 
1500     /**
1501      * @dev Assign the IPFS hash of canonical artifcat file, by 'niftyType'.
1502      */   
1503     function setNiftyIPFSHash(uint256 niftyType, string memory hashIPFS) public onlyValidSender {
1504         _setTokenIPFSHashNiftyType(niftyType, hashIPFS);
1505     }
1506 
1507     /**
1508      * @dev Create specified number of nifties en masse.
1509      * Once an NFT collection is spawned by the factory contract, we make calls to set the IPFS
1510      * hash (above) for each Nifty type in the collection. 
1511      * Subsequently calls are issued to this function to mint the appropriate number of tokens 
1512      * for the project.
1513      */
1514     function mintNifty(uint256 niftyType, uint256 count) public onlyValidSender {
1515         require(!_getFinalized(niftyType), "NiftyBuilderInstance: minting concluded for nifty type");
1516             
1517         uint256 tokenNumber = _mintCount[niftyType] + 1;
1518         uint256 tokenId00 = _encodeTokenId(niftyType, tokenNumber);
1519         uint256 tokenId01 = tokenId00 + count - 1;
1520         
1521         for (uint256 tokenId = tokenId00; tokenId <= tokenId01; tokenId++) {
1522             _owners[tokenId] = _defaultOwner;
1523         }
1524         _mintCount[niftyType] += count;
1525         _balances[_defaultOwner] += count;
1526 
1527         emit ConsecutiveTransfer(tokenId00, tokenId01, address(0), _defaultOwner);
1528     }
1529 
1530     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, IERC165) returns (bool) {
1531         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1532     }    
1533 
1534     function _getRoyaltyReceiverByNiftyType(uint256 niftyType) private view returns (address) {
1535         if(_royaltyReceivers[niftyType] != address(0)) {            
1536             return _royaltyReceivers[niftyType];
1537         } else if(_royaltySplitters[niftyType] != address(0)) {            
1538             return _royaltySplitters[niftyType];
1539         }
1540 
1541         return address(0);   
1542     }
1543 }
1544 
1545 // File: contracts/core/BuilderShop.sol
1546 
1547 pragma solidity ^0.8.6;
1548 
1549 
1550 
1551 /**
1552  *   ::::::::::::::::::::::::::::::::::::::::::::
1553  * ::::::::::::::::::::::::::::::::::::::::::::::::
1554  * ::::::::::::::::::::::::::::::::::::::::::::::::
1555  * ::::::::::::NNNNNNNNN:::::::NNNNNNNN::::::::::::
1556  * ::::::::::::NNNNNNNNNN::::::NNNNNNNN::::::::::::
1557  * ::::::::::::NNNNNNNNNNN:::::NNNNNNNN::::::::::::
1558  * ::::::::::::NNNNNNNNNNNN::::NNNNNNNN::::::::::::
1559  * ::::::::::::NNNNNNNNNNNNN:::NNNNNNNN::::::::::::
1560  * ::::::::::::NNNNNNNNNNNNNN::NNNNNNNN::::::::::::
1561  * ::::::::::::NNNNNNNN:NNNNNN:NNNNNNNN::::::::::::
1562  * ::::::::::::NNNNNNNN::NNNNNNNNNNNNNN::::::::::::
1563  * ::::::::::::NNNNNNNN:::NNNNNNNNNNNNN::::::::::::
1564  * ::::::::::::NNNNNNNN::::NNNNNNNNNNNN::::::::::::
1565  * ::::::::::::NNNNNNNN:::::NNNNNNNNNNN::::::::::::
1566  * ::::::::::::NNNNNNNN::::::NNNNNNNNNN::::::::::::
1567  * ::::::::::::NNNNNNNN:::::::NNNNNNNNN::::::::::::
1568  * ::::::::::::::::::::::::::::::::::::::::::::::::
1569  * ::::::::::::::::::::::::::::::::::::::::::::::::
1570  *   ::::::::::::::::::::::::::::::::::::::::::::
1571  *  
1572  * @dev Nexus of the Nifty Gateway smartcontract constellation.
1573  * {BuilderShop} is a factory contract, when a new collection
1574  * is slated for deployment, a call is made to this factory 
1575  * contract to create it. 
1576  */
1577 contract BuilderShop is NiftyEntity {
1578 
1579     /**
1580      * @dev Tracks the latest {NiftyBuilderInstance} deployment, supplied as constructor 
1581      * argument. Every time a new contract is deployed from this "master" factory contract, 
1582      * it is given a contract id that is one higher than the previous contract deployed.
1583      */
1584     uint public _id;
1585 
1586     // Provided as a argument to {NiftyBuilderInstance} deployment.
1587     address public _defaultOwner;
1588 
1589     // Reference for validation of posible {NiftyBuilderInstance} by address.
1590     mapping (address => bool) public validBuilderInstance;
1591 
1592     // Log the creation of each {NiftyBuilderInstance} deployment. 
1593     event BuilderInstanceCreated(address instanceAddress, uint id);
1594 
1595     /**
1596      * @param niftyRegistryContract Points to the mainnet repository of addresses
1597      * allowed to invoke state mutating operations via the modifier 'onlyValidSender'.
1598      * @param defaultOwner_ The address to which all tokens are initially minted.
1599      */
1600     constructor(address niftyRegistryContract,
1601                 address defaultOwner_) NiftyEntity(niftyRegistryContract) {
1602         _defaultOwner = defaultOwner_;
1603     }
1604 
1605     /**
1606      * @dev Configurable address for defaultOwner.
1607      * @param defaultOwner account to which newly minted tokens are allocated.
1608      */ 
1609     function setDefaultOwner(address defaultOwner) onlyValidSender external {
1610         _defaultOwner = defaultOwner;
1611     }
1612 
1613     /**
1614      * @dev Allow anyone to check if a contract address is a valid nifty gateway contract.
1615      * @param instanceAddress address of potential spawned {NiftyBuilderInstance}.
1616      * @return bool whether or not the contract was initialized by this {BuilderShop}.
1617      */
1618     function isValidBuilderInstance(address instanceAddress) external view returns (bool) {
1619         return (validBuilderInstance[instanceAddress]);
1620     }
1621 
1622     /**
1623      * @dev Collections on the platform are associated with a call to this 
1624      * function which will generate a {NiftyBuilderInstance} to house the 
1625      * NFTs for that particular artist release. 
1626      * 
1627      * @param name Of the collection being deployed.
1628      * @param symbol Shorthand token identifier, for wallets, etc.
1629      * @param typeCount The number of different Nifty types (different 
1630      * individual NFTs) associated with the deployed collection.
1631      * @param baseURI The location where the artifact assets are stored.
1632      * @param creator The artist associated with the collection.
1633      */
1634     function createNewBuilderInstance(
1635         string memory name,
1636         string memory symbol,
1637         uint256 typeCount,
1638         string memory baseURI,
1639         string memory creator) external onlyValidSender { 
1640         
1641         _id += 1;
1642 
1643         NiftyBuilderInstance instance = new NiftyBuilderInstance(
1644             name,
1645             symbol,
1646             _id,
1647             typeCount,
1648             baseURI,
1649             creator,
1650             niftyRegistryContract,
1651             _defaultOwner
1652         );
1653         address instanceAddress = address(instance);
1654         validBuilderInstance[instanceAddress] = true;
1655 
1656         emit BuilderInstanceCreated(instanceAddress, _id);
1657     }
1658    
1659 }