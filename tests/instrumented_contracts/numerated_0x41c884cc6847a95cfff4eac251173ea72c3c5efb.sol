1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-24
3 */
4 
5 // File: contracts/interface/IERC165.sol
6 
7 /**
8  * @title IERC165
9  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
10  */
11 interface IERC165 {
12 
13   /**
14    * @notice Query if a contract implements an interface
15    * @param interfaceId The interface identifier, as specified in ERC-165
16    * @dev Interface identification is specified in ERC-165. This function
17    * uses less than 30,000 gas.
18    */
19   function supportsInterface(bytes4 interfaceId)
20     external
21     view
22     returns (bool);
23 }
24 
25 // File: contracts/interface/IERC721.sol
26 
27 /**
28  * @dev Required interface of an ERC721 compliant contract.
29  */
30 interface IERC721 is IERC165 {
31     /**
32      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
33      */
34     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
35 
36     /**
37      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
38      */
39     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
43      */
44     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
45 
46     /**
47      * @dev Returns the number of tokens in ``owner``'s account.
48      */
49     function balanceOf(address owner) external view returns (uint256 balance);
50 
51     /**
52      * @dev Returns the owner of the `tokenId` token.
53      *
54      * Requirements:
55      *
56      * - `tokenId` must exist.
57      */
58     function ownerOf(uint256 tokenId) external view returns (address owner);
59 
60     /**
61      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
62      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
63      *
64      * Requirements:
65      *
66      * - `from` cannot be the zero address.
67      * - `to` cannot be the zero address.
68      * - `tokenId` token must exist and be owned by `from`.
69      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
70      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
71      *
72      * Emits a {Transfer} event.
73      */
74     function safeTransferFrom(address from, address to, uint256 tokenId) external;
75 
76     /**
77      * @dev Transfers `tokenId` token from `from` to `to`.
78      *
79      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
80      *
81      * Requirements:
82      *
83      * - `from` cannot be the zero address.
84      * - `to` cannot be the zero address.
85      * - `tokenId` token must be owned by `from`.
86      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(address from, address to, uint256 tokenId) external;
91 
92     /**
93      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
94      * The approval is cleared when the token is transferred.
95      *
96      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
97      *
98      * Requirements:
99      *
100      * - The caller must own the token or be an approved operator.
101      * - `tokenId` must exist.
102      *
103      * Emits an {Approval} event.
104      */
105     function approve(address to, uint256 tokenId) external;
106 
107     /**
108      * @dev Returns the account approved for `tokenId` token.
109      *
110      * Requirements:
111      *
112      * - `tokenId` must exist.
113      */
114     function getApproved(uint256 tokenId) external view returns (address operator);
115 
116     /**
117      * @dev Approve or remove `operator` as an operator for the caller.
118      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
119      *
120      * Requirements:
121      *
122      * - The `operator` cannot be the caller.
123      *
124      * Emits an {ApprovalForAll} event.
125      */
126     function setApprovalForAll(address operator, bool _approved) external;
127 
128     /**
129      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
130      *
131      * See {setApprovalForAll}
132      */
133     function isApprovedForAll(address owner, address operator) external view returns (bool);
134 
135     /**
136       * @dev Safely transfers `tokenId` token from `from` to `to`.
137       *
138       * Requirements:
139       *
140       * - `from` cannot be the zero address.
141       * - `to` cannot be the zero address.
142       * - `tokenId` token must exist and be owned by `from`.
143       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
144       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
145       *
146       * Emits a {Transfer} event.
147       */
148     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
149 }
150 
151 // File: contracts/interface/IERC721Receiver.sol
152 
153 /**
154  * @title ERC721 token receiver interface
155  * @dev Interface for any contract that wants to support safeTransfers
156  * from ERC721 asset contracts.
157  */
158 interface IERC721Receiver {
159     /**
160      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
161      * by `operator` from `from`, this function is called.
162      *
163      * It must return its Solidity selector to confirm the token transfer.
164      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
165      *
166      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
167      */
168     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
169 }
170 
171 // File: contracts/interface/IERC721Metadata.sol
172 
173 /**
174  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
175  * @dev See https://eips.ethereum.org/EIPS/eip-721
176  */
177 interface IERC721Metadata is IERC721 {
178 
179     /**
180      * @dev Returns the token collection name.
181      */
182     function name() external view returns (string memory);
183 
184     /**
185      * @dev Returns the token collection symbol.
186      */
187     function symbol() external view returns (string memory);
188 
189     /**
190      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
191      */
192     function tokenURI(uint256 tokenId) external view returns (string memory);
193 }
194 
195 // File: contracts/util/Context.sol
196 
197 /*
198  * @dev Provides information about the current execution context, including the
199  * sender of the transaction and its data. While these are generally available
200  * via msg.sender and msg.data, they should not be accessed in such a direct
201  * manner, since when dealing with meta-transactions the account sending and
202  * paying for execution may not be the actual sender (as far as an application
203  * is concerned).
204  *
205  * This contract is only required for intermediate, library-like contracts.
206  */
207 abstract contract Context {
208     function _msgSender() internal view virtual returns (address) {
209         return msg.sender;
210     }
211 }
212 
213 // File: contracts/util/Strings.sol
214 
215 /**
216  * @dev String operations.
217  */
218 library Strings {
219     bytes16 private constant alphabet = "0123456789abcdef";
220 
221     /**
222      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
223      */
224     function toString(uint256 value) internal pure returns (string memory) {
225         // Inspired by OraclizeAPI's implementation - MIT licence
226         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
227 
228         if (value == 0) {
229             return "0";
230         }
231         uint256 temp = value;
232         uint256 digits;
233         while (temp != 0) {
234             digits++;
235             temp /= 10;
236         }
237         bytes memory buffer = new bytes(digits);
238         while (value != 0) {
239             digits -= 1;
240             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
241             value /= 10;
242         }
243         return string(buffer);
244     }
245 
246 }
247 
248 // File: contracts/standard/ERC165.sol
249 
250 /**
251  * @dev Implementation of the {IERC165} interface.
252  *
253  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
254  * for the additional interface id that will be supported. For example:
255  *
256  * ```solidity
257  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
258  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
259  * }
260  * ```
261  *
262  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
263  */
264 abstract contract ERC165 is IERC165 {
265     /**
266      * @dev See {IERC165-supportsInterface}.
267      */
268     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
269         return interfaceId == type(IERC165).interfaceId;
270     }
271 }
272 
273 // File: contracts/core/NiftyEntity.sol
274 
275 /**
276  * @dev Authenticator of state mutating operations for Nifty Gateway contracts. 
277  *
278  * addresses for stateful operations. 
279  *
280  * Rinkeby: 0xCefBf44ff649B6E0Bc63785699c6F1690b8cF73b
281  * Mainnet: 0x6e53130dDfF21E3BC963Ee902005223b9A202106
282  */
283 contract NiftyEntity {
284    
285    // Address of {NiftyRegistry} contract. 
286    address internal immutable niftyRegistryContract;
287    
288    /**
289     * @dev Determines whether accounts are allowed to invoke state mutating operations on child contracts.
290     */
291     modifier onlyValidSender() {
292         NiftyRegistry niftyRegistry = NiftyRegistry(niftyRegistryContract);
293         bool isValid = niftyRegistry.isValidNiftySender(msg.sender);
294         require(isValid, "NiftyEntity: Invalid msg.sender");
295         _;
296     }
297     
298    /**
299     * @param _niftyRegistryContract Points to the repository of authenticated
300     */
301     constructor(address _niftyRegistryContract) {
302         niftyRegistryContract = _niftyRegistryContract;
303     }
304 }
305 
306 /**
307  * @dev Defined to mediate interaction with externally deployed {NiftyRegistry} dependency. 
308  */
309 interface NiftyRegistry {
310    function isValidNiftySender(address sending_key) external view returns (bool);
311 }
312 
313 // File: contracts/core/ERC721.sol
314 
315 /**
316  * @dev Nifty Gateway implementation of Non-Fungible Token Standard.
317  */
318 contract ERC721 is NiftyEntity, Context, ERC165, IERC721, IERC721Metadata {
319 
320     // Tracked individual instance spawned by {BuilderShop} contract. 
321     uint immutable public _id;
322 
323     // Number of distinct NFTs housed in this contract. 
324     uint immutable public _typeCount;
325 
326     // Intial receiver of all newly minted NFTs.
327     address immutable public _defaultOwner;
328 
329     // Component(s) of 'tokenId' calculation. 
330     uint immutable internal topLevelMultiplier;
331     uint immutable internal midLevelMultiplier;
332 
333     // Token name.
334     string private _name;
335 
336     // Token symbol.
337     string private _symbol;
338 
339     // Token artifact location.
340     string private _baseURI;
341 
342     // Mapping from Nifty type to name of token.
343     mapping(uint256 => string) private _niftyTypeName;
344 
345     // Mapping from Nifty type to IPFS hash of canonical artifcat file.
346     mapping(uint256 => string) private _niftyTypeIPFSHashes;
347 
348     // Mapping from token ID to owner address.
349     mapping (uint256 => address) internal _owners;
350 
351     // Mapping owner address to token count, by aggregating all _typeCount NFTs in the contact.
352     mapping (address => uint256) internal _balances;
353 
354     // Mapping from token ID to approved address.
355     mapping (uint256 => address) private _tokenApprovals;
356 
357     // Mapping from owner to operator approvals.
358     mapping (address => mapping (address => bool)) private _operatorApprovals;
359 
360     /**
361      * @dev Initializes the token collection.
362      *
363      * @param name_ Of the collection being deployed.
364      * @param symbol_ Shorthand token identifier, for wallets, etc.
365      * @param id_ Number instance deployed by {BuilderShop} contract.
366      * @param baseURI_ The location where the artifact assets are stored.
367      * @param typeCount_ The number of different Nifty types (different 
368      * individual NFTs) associated with the deployed collection.
369      * @param defaultOwner_ Intial receiver of all newly minted NFTs.
370      * @param niftyRegistryContract Points to the repository of authenticated
371      * addresses for stateful operations. 
372      */
373     constructor(string memory name_, 
374                 string memory symbol_,
375                 uint id_,
376                 string memory baseURI_,
377                 uint typeCount_,
378                 address defaultOwner_, 
379                 address niftyRegistryContract) NiftyEntity(niftyRegistryContract) {
380         _name = name_;
381         _symbol = symbol_;
382         _id = id_;
383         _baseURI = baseURI_;
384         _typeCount = typeCount_;
385         _defaultOwner = defaultOwner_;
386 
387         midLevelMultiplier = 10000;
388         topLevelMultiplier = id_ * 100000000;
389     }
390 
391     /**
392      * @dev See {IERC165-supportsInterface}.
393      */
394     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
395         return interfaceId == type(IERC721).interfaceId
396             || interfaceId == type(IERC721Metadata).interfaceId
397             || super.supportsInterface(interfaceId);
398     }
399 
400     /**
401      * @dev See {IERC721-balanceOf}.
402      */
403     function balanceOf(address owner) public view virtual override returns (uint256) {
404         require(owner != address(0), "ERC721: balance query for the zero address");
405         return _balances[owner];
406     }
407 
408     /**
409      * @dev See {IERC721-ownerOf}.
410      */
411     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
412         address owner = _owners[tokenId];
413         require(owner != address(0), "ERC721: owner query for nonexistent token");
414         return owner;
415     }
416 
417     /**
418      * @dev See {IERC721Metadata-name}.
419      */
420     function name() public view virtual override returns (string memory) {
421         return _name;
422     }
423 
424     /**
425      * @dev See {IERC721Metadata-symbol}.
426      */
427     function symbol() public view virtual override returns (string memory) {
428         return _symbol;
429     }
430 
431     /**
432      * @dev Returns the link to artificat location for a given token by 'tokenId'.
433      * Throws if the token ID does not exist. May return an empty string.
434      * @param tokenId uint256 ID of the token to query.
435      * @return The location where the artifact assets are stored.
436      */
437     function tokenURI(uint256 tokenId) external view override returns (string memory) {
438         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
439         string memory tokenIdStr = Strings.toString(tokenId);
440         return string(abi.encodePacked(_baseURI, tokenIdStr));
441     }
442 
443     /**
444      * @dev Returns an IPFS hash for a given token ID.
445      * Throws if the token ID does not exist. May return an empty string.
446      * @param tokenId uint256 ID of the token to query.
447      * @return IPFS hash for this (_typeCount) NFT. 
448      */
449     function tokenIPFSHash(uint256 tokenId) external view returns (string memory) {
450         require(_exists(tokenId), "ERC721Metadata: IPFS hash query for nonexistent token");
451         uint niftyType = _getNiftyTypeId(tokenId);
452         return _niftyTypeIPFSHashes[niftyType];
453     }
454     
455     /**
456      * @dev Determine which NFT in the contract (_typeCount) is associated 
457      * with this 'tokenId'.
458      */
459     function _getNiftyTypeId(uint tokenId) private view returns (uint) {
460         return (tokenId - topLevelMultiplier) / midLevelMultiplier;
461     }
462 
463     /**
464      * @dev Returns the Name for a given token ID.
465      * Throws if the token ID does not exist. May return an empty string.
466      * @param tokenId uint256 ID of the token to query
467      */
468     function tokenName(uint256 tokenId) external view returns (string memory) {
469         require(_exists(tokenId), "ERC721Metadata: Name query for nonexistent token");
470         uint niftyType = _getNiftyTypeId(tokenId);
471         return _niftyTypeName[niftyType];
472     }
473    
474     /**
475      * @dev Internal function to set the token IPFS hash for a nifty type.
476      * @param niftyType uint256 ID component of the token to set its IPFS hash
477      * @param ipfs_hash string IPFS link to assign
478      */
479     function _setTokenIPFSHashNiftyType(uint256 niftyType, string memory ipfs_hash) internal {
480         require(bytes(_niftyTypeIPFSHashes[niftyType]).length == 0, "ERC721Metadata: IPFS hash already set");
481         _niftyTypeIPFSHashes[niftyType] = ipfs_hash;
482     }
483 
484     /**
485      * @dev Internal function to set the name for a nifty type.
486      * @param niftyType uint256 of nifty type name to be set
487      * @param nifty_type_name name of nifty type
488      */
489     function _setNiftyTypeName(uint256 niftyType, string memory nifty_type_name) internal {
490         _niftyTypeName[niftyType] = nifty_type_name;
491     }
492 
493     /**
494      * @dev Base URI for computing {tokenURI}.
495      */
496     function _setBaseURI(string memory baseURI_) internal {
497         _baseURI = baseURI_;
498     }
499 
500     /**
501      * @dev See {IERC721-approve}.
502      */
503     function approve(address to, uint256 tokenId) public virtual override {
504         address owner = ERC721.ownerOf(tokenId);
505         require(to != owner, "ERC721: approval to current owner");
506 
507         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
508             "ERC721: approve caller is not owner nor approved for all"
509         );
510 
511         _approve(to, tokenId);
512     }
513 
514     /**
515      * @dev See {IERC721-getApproved}.
516      */
517     function getApproved(uint256 tokenId) public view virtual override returns (address) {
518         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
519         return _tokenApprovals[tokenId];
520     }
521 
522     /**
523      * @dev See {IERC721-setApprovalForAll}.
524      */
525     function setApprovalForAll(address operator, bool approved) public virtual override {
526         require(operator != _msgSender(), "ERC721: approve to caller");
527         _operatorApprovals[_msgSender()][operator] = approved;
528         emit ApprovalForAll(_msgSender(), operator, approved);
529     }
530 
531     /**
532      * @dev See {IERC721-isApprovedForAll}.
533      */
534     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
535         return _operatorApprovals[owner][operator];
536     }
537 
538     /**
539      * @dev See {IERC721-transferFrom}.
540      */
541     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
542         //solhint-disable-next-line max-line-length
543         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
544         _transfer(from, to, tokenId);
545     }
546 
547     /**
548      * @dev See {IERC721-safeTransferFrom}.
549      */
550     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
551         safeTransferFrom(from, to, tokenId, "");
552     }
553 
554     /**
555      * @dev See {IERC721-safeTransferFrom}.
556      */
557     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
558         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
559         _safeTransfer(from, to, tokenId, _data);
560     }
561 
562     /**
563      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
564      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
565      *
566      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
567      *
568      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
569      * implement alternative mechanisms to perform token transfer, such as signature-based.
570      *
571      * Requirements:
572      *
573      * - `from` cannot be the zero address.
574      * - `to` cannot be the zero address.
575      * - `tokenId` token must exist and be owned by `from`.
576      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
577      *
578      * Emits a {Transfer} event.
579      */
580     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
581         _transfer(from, to, tokenId);
582         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
583     }
584 
585     /**
586      * @dev Returns whether `tokenId` exists.
587      *
588      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
589      *
590      * Tokens start existing when they are minted (`_mint`),
591      * and stop existing when they are burned (`_burn`).
592      */
593     function _exists(uint256 tokenId) internal view virtual returns (bool) {
594         return _owners[tokenId] != address(0);
595     }
596 
597     /**
598      * @dev Returns whether `spender` is allowed to manage `tokenId`.
599      *
600      * Requirements:
601      *
602      * - `tokenId` must exist.
603      */
604     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
605         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
606         address owner = ERC721.ownerOf(tokenId);
607         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
608     }
609 
610     /**
611      * @dev Destroys `tokenId`.
612      * The approval is cleared when the token is burned.
613      *
614      * Requirements:
615      *
616      * - `tokenId` must exist.
617      *
618      * Emits a {Transfer} event.
619      */
620     function _burn(uint256 tokenId) internal virtual {
621         address owner = ERC721.ownerOf(tokenId);
622 
623         // Clear approvals
624         _approve(address(0), tokenId);
625 
626         _balances[owner] -= 1;
627         delete _owners[tokenId];
628 
629         emit Transfer(owner, address(0), tokenId);
630     }
631 
632     /**
633      * @dev Transfers `tokenId` from `from` to `to`.
634      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
635      *
636      * Requirements:
637      *
638      * - `to` cannot be the zero address.
639      * - `tokenId` token must be owned by `from`.
640      *
641      * Emits a {Transfer} event.
642      */
643     function _transfer(address from, address to, uint256 tokenId) internal virtual {
644         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
645         require(to != address(0), "ERC721: transfer to the zero address");
646 
647         // Clear approvals from the previous owner
648         _approve(address(0), tokenId);
649 
650         _balances[from] -= 1;
651         _balances[to] += 1;
652         _owners[tokenId] = to;
653 
654         emit Transfer(from, to, tokenId);
655     }
656 
657     /**
658      * @dev Approve `to` to operate on `tokenId`
659      *
660      * Emits a {Approval} event.
661      */
662     function _approve(address to, uint256 tokenId) internal virtual {
663         _tokenApprovals[tokenId] = to;
664         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
665     }
666 
667     /**
668      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
669      * The call is not executed if the target address is not a contract.
670      *
671      * @param from address representing the previous owner of the given token ID
672      * @param to target address that will receive the tokens
673      * @param tokenId uint256 ID of the token to be transferred
674      * @param _data bytes optional data to send along with the call
675      * @return bool whether the call correctly returned the expected magic value
676      */
677     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
678         private returns (bool)
679     {
680         if (isContract(to)) {
681             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
682                 return retval == IERC721Receiver(to).onERC721Received.selector;
683             } catch (bytes memory reason) {
684                 if (reason.length == 0) {
685                     revert("ERC721: transfer to non ERC721Receiver implementer");
686                 } else {
687                     // solhint-disable-next-line no-inline-assembly
688                     assembly {
689                         revert(add(32, reason), mload(reason))
690                     }
691                 }
692             }
693         } else {
694             return true;
695         }
696     }
697 
698     /**
699      * @dev Returns true if `account` is a contract.
700      *
701      * [IMPORTANT]
702      * ====
703      * It is unsafe to assume that an address for which this function returns
704      * false is an externally-owned account (EOA) and not a contract.
705      *
706      * Among others, `isContract` will return false for the following
707      * types of addresses:
708      *
709      *  - an externally-owned account
710      *  - a contract in construction
711      *  - an address where a contract will be created
712      *  - an address where a contract lived, but was destroyed
713      * ====
714      */
715     function isContract(address account) internal view returns (bool) {
716         // This method relies on extcodesize, which returns 0 for contracts in
717         // construction, since the code is only stored at the end of the
718         // constructor execution.
719 
720         uint256 size;
721         // solhint-disable-next-line no-inline-assembly
722         assembly { size := extcodesize(account) }
723         return size > 0;
724     }
725 }
726 
727 // File: contracts/standard/ERC721Burnable.sol
728 
729 /**
730  * @title ERC721 Burnable Token
731  * @dev ERC721 Token that can be irreversibly burned (destroyed).
732  */
733 abstract contract ERC721Burnable is Context, ERC721 {
734     /**
735      * @dev Burns `tokenId`. See {ERC721-_burn}.
736      *
737      * Requirements:
738      *
739      * - The caller must own `tokenId` or be an approved operator.
740      */
741     function burn(uint256 tokenId) public virtual {
742         //solhint-disable-next-line max-line-length
743         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
744         _burn(tokenId);
745     }
746 }
747 
748 // File: contracts/core/NiftyBuilderInstance.sol
749 
750 /**
751  * @dev Nifty Gateway extension of customized NFT contract, encapsulates
752  * logic for minting new tokens, and concluding the minting process. 
753  */
754 contract NiftyBuilderInstance is ERC721, ERC721Burnable {
755 
756     // The artist associated with the collection.
757     string private _creator;
758 
759     // Number of NFTs minted for a given 'typeCount'. 
760     mapping (uint256 => uint256) public _mintCount;
761 
762     /**
763      * @dev Serves as a gas cost optimized boolean flag 
764      * to indicate whether the minting process has been 
765      * concluded for a given 'typeCount', correspinds 
766      * to the {_getFinalized} and {setFinalized}.
767      */
768     mapping (uint256 => bytes32) private _finalized;
769 
770     /**
771      * @dev Emitted when tokens are created.
772      */
773     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed fromAddress, address indexed toAddress);
774 
775     /**
776      * @dev Ultimate instantiation of a Nifty Gateway NFT collection. 
777      * 
778      * @param name Of the collection being deployed.
779      * @param symbol Shorthand token identifier, for wallets, etc.
780      * @param id Number instance deployed by {BuilderShop} contract.
781      * @param typeCount The number of different Nifty types (different 
782      * individual NFTs) associated with the deployed collection.
783      * @param baseURI The location where the artifact assets are stored.
784      * @param creator_ The artist associated with the collection.
785      * @param niftyRegistryContract Points to the repository of authenticated
786      * addresses for stateful operations. 
787      * @param defaultOwner Intial receiver of all newly minted NFTs.
788      */
789     constructor(
790         string memory name,
791         string memory symbol,
792         uint id,
793         uint typeCount,
794         string memory baseURI,
795         string memory creator_,
796         address niftyRegistryContract,
797         address defaultOwner) ERC721(name, symbol, id, baseURI, typeCount, defaultOwner, niftyRegistryContract) {
798 
799         _creator = creator_;
800     }
801 
802     /**
803      * @dev Generate canonical Nifty Gateway token representation. 
804      * Nifty contracts have a data model called a 'niftyType' (typeCount) 
805      * The 'niftyType' refers to a specific nifty in our contract, note 
806      * that it gives no information about the edition size. In a given 
807      * contract, 'niftyType' 1 could be an edition of 10, while 'niftyType' 
808      * 2 is a 1/1, etc.
809      * The token IDs are encoded as follows: {id}{niftyType}{edition #}
810      * 'niftyType' has 4 digits, and edition number does as well, to allow 
811      * for 9999 possible 'niftyType' and 9999 of each edition in each contract.
812      * Example token id: [500010270]
813      * This is from contract #5, it is 'niftyType' 1 in the contract, and it is 
814      * edition #270 of 'niftyType' 1.
815      */
816     function _encodeTokenId(uint niftyType, uint tokenNumber) private view returns (uint) {
817         return (topLevelMultiplier + (niftyType * midLevelMultiplier) + tokenNumber);
818     }
819 
820     /**
821      * @dev Determine whether it is possible to mint additional NFTs for this 'niftyType'.
822      */
823     function _getFinalized(uint256 niftyType) public view returns (bool) {
824         bytes32 chunk = _finalized[niftyType / 256];
825         return (chunk & bytes32(1 << (niftyType % 256))) != 0x0;
826     }
827 
828     /**
829      * @dev Prevent the minting of additional NFTs of this 'niftyType'.
830      */
831     function setFinalized(uint256 niftyType) public onlyValidSender {
832         uint256 quotient = niftyType / 256;
833         bytes32 chunk = _finalized[quotient];
834         _finalized[quotient] = chunk | bytes32(1 << (niftyType % 256));
835     }
836 
837     /**
838      * @dev The artist of this collection.
839      */
840     function creator() public view virtual returns (string memory) {
841         return _creator;
842     }
843 
844     /**
845      * @dev Assign the root location where the artifact assets are stored.
846      */
847     function setBaseURI(string memory baseURI) public onlyValidSender {
848         _setBaseURI(baseURI);
849     }
850 
851     /**
852      * @dev Allow owner to change nifty name, by 'niftyType'.
853      */
854     function setNiftyName(uint niftyType, string memory niftyName) public onlyValidSender {
855         _setNiftyTypeName(niftyType, niftyName);
856     }
857 
858     /**
859      * @dev Assign the IPFS hash of canonical artifcat file, by 'niftyType'.
860      */   
861     function setNiftyIPFSHash(uint niftyType, string memory hashIPFS) public onlyValidSender {
862         _setTokenIPFSHashNiftyType(niftyType, hashIPFS);
863     }
864 
865     /**
866      * @dev Create specified number of nifties en masse.
867      * Once an NFT collection is spawned by the factory contract, we make calls to set the IPFS
868      * hash (above) for each Nifty type in the collection. 
869      * Subsequently calls are issued to this function to mint the appropriate number of tokens 
870      * for the project.
871      */
872     function mintNifty(uint niftyType, uint count) public onlyValidSender {
873         require(!_getFinalized(niftyType), "NiftyBuilderInstance: minting concluded for nifty type");
874             
875         uint tokenNumber = _mintCount[niftyType] + 1;
876         uint tokenId00 = _encodeTokenId(niftyType, tokenNumber);
877         uint tokenId01 = tokenId00 + count - 1;
878         
879         for (uint tokenId = tokenId00; tokenId <= tokenId01; tokenId++) {
880             _owners[tokenId] = _defaultOwner;
881         }
882         //TODO: Assign _balances by niftyType to make _mintCount mapping redundant
883         _mintCount[niftyType] += count;
884         _balances[_defaultOwner] += count;
885 
886         emit ConsecutiveTransfer(tokenId00, tokenId01, address(0), _defaultOwner);
887     }
888 
889 }