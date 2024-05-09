1 // File: contracts/interface/IERC165.sol
2 
3 /**
4  * @title IERC165
5  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
6  */
7 interface IERC165 {
8 
9   /**
10    * @notice Query if a contract implements an interface
11    * @param interfaceId The interface identifier, as specified in ERC-165
12    * @dev Interface identification is specified in ERC-165. This function
13    * uses less than 30,000 gas.
14    */
15   function supportsInterface(bytes4 interfaceId)
16     external
17     view
18     returns (bool);
19 }
20 
21 // File: contracts/interface/IERC721.sol
22 
23 /**
24  * @dev Required interface of an ERC721 compliant contract.
25  */
26 interface IERC721 is IERC165 {
27     /**
28      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
29      */
30     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
31 
32     /**
33      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
34      */
35     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
36 
37     /**
38      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
39      */
40     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
41 
42     /**
43      * @dev Returns the number of tokens in ``owner``'s account.
44      */
45     function balanceOf(address owner) external view returns (uint256 balance);
46 
47     /**
48      * @dev Returns the owner of the `tokenId` token.
49      *
50      * Requirements:
51      *
52      * - `tokenId` must exist.
53      */
54     function ownerOf(uint256 tokenId) external view returns (address owner);
55 
56     /**
57      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
58      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
59      *
60      * Requirements:
61      *
62      * - `from` cannot be the zero address.
63      * - `to` cannot be the zero address.
64      * - `tokenId` token must exist and be owned by `from`.
65      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
66      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
67      *
68      * Emits a {Transfer} event.
69      */
70     function safeTransferFrom(address from, address to, uint256 tokenId) external;
71 
72     /**
73      * @dev Transfers `tokenId` token from `from` to `to`.
74      *
75      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
76      *
77      * Requirements:
78      *
79      * - `from` cannot be the zero address.
80      * - `to` cannot be the zero address.
81      * - `tokenId` token must be owned by `from`.
82      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
83      *
84      * Emits a {Transfer} event.
85      */
86     function transferFrom(address from, address to, uint256 tokenId) external;
87 
88     /**
89      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
90      * The approval is cleared when the token is transferred.
91      *
92      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
93      *
94      * Requirements:
95      *
96      * - The caller must own the token or be an approved operator.
97      * - `tokenId` must exist.
98      *
99      * Emits an {Approval} event.
100      */
101     function approve(address to, uint256 tokenId) external;
102 
103     /**
104      * @dev Returns the account approved for `tokenId` token.
105      *
106      * Requirements:
107      *
108      * - `tokenId` must exist.
109      */
110     function getApproved(uint256 tokenId) external view returns (address operator);
111 
112     /**
113      * @dev Approve or remove `operator` as an operator for the caller.
114      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
115      *
116      * Requirements:
117      *
118      * - The `operator` cannot be the caller.
119      *
120      * Emits an {ApprovalForAll} event.
121      */
122     function setApprovalForAll(address operator, bool _approved) external;
123 
124     /**
125      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
126      *
127      * See {setApprovalForAll}
128      */
129     function isApprovedForAll(address owner, address operator) external view returns (bool);
130 
131     /**
132       * @dev Safely transfers `tokenId` token from `from` to `to`.
133       *
134       * Requirements:
135       *
136       * - `from` cannot be the zero address.
137       * - `to` cannot be the zero address.
138       * - `tokenId` token must exist and be owned by `from`.
139       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
140       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
141       *
142       * Emits a {Transfer} event.
143       */
144     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
145 }
146 
147 // File: contracts/interface/IERC721Receiver.sol
148 
149 /**
150  * @title ERC721 token receiver interface
151  * @dev Interface for any contract that wants to support safeTransfers
152  * from ERC721 asset contracts.
153  */
154 interface IERC721Receiver {
155     /**
156      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
157      * by `operator` from `from`, this function is called.
158      *
159      * It must return its Solidity selector to confirm the token transfer.
160      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
161      *
162      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
163      */
164     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
165 }
166 
167 // File: contracts/interface/IERC721Metadata.sol
168 
169 /**
170  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
171  * @dev See https://eips.ethereum.org/EIPS/eip-721
172  */
173 interface IERC721Metadata is IERC721 {
174 
175     /**
176      * @dev Returns the token collection name.
177      */
178     function name() external view returns (string memory);
179 
180     /**
181      * @dev Returns the token collection symbol.
182      */
183     function symbol() external view returns (string memory);
184 
185     /**
186      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
187      */
188     function tokenURI(uint256 tokenId) external view returns (string memory);
189 }
190 
191 // File: contracts/util/Context.sol
192 
193 /*
194  * @dev Provides information about the current execution context, including the
195  * sender of the transaction and its data. While these are generally available
196  * via msg.sender and msg.data, they should not be accessed in such a direct
197  * manner, since when dealing with meta-transactions the account sending and
198  * paying for execution may not be the actual sender (as far as an application
199  * is concerned).
200  *
201  * This contract is only required for intermediate, library-like contracts.
202  */
203 abstract contract Context {
204     function _msgSender() internal view virtual returns (address) {
205         return msg.sender;
206     }
207 }
208 
209 // File: contracts/util/Strings.sol
210 
211 /**
212  * @dev String operations.
213  */
214 library Strings {
215     bytes16 private constant alphabet = "0123456789abcdef";
216 
217     /**
218      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
219      */
220     function toString(uint256 value) internal pure returns (string memory) {
221         // Inspired by OraclizeAPI's implementation - MIT licence
222         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
223 
224         if (value == 0) {
225             return "0";
226         }
227         uint256 temp = value;
228         uint256 digits;
229         while (temp != 0) {
230             digits++;
231             temp /= 10;
232         }
233         bytes memory buffer = new bytes(digits);
234         while (value != 0) {
235             digits -= 1;
236             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
237             value /= 10;
238         }
239         return string(buffer);
240     }
241 
242 }
243 
244 // File: contracts/standard/ERC165.sol
245 
246 /**
247  * @dev Implementation of the {IERC165} interface.
248  *
249  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
250  * for the additional interface id that will be supported. For example:
251  *
252  * ```solidity
253  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
254  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
255  * }
256  * ```
257  *
258  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
259  */
260 abstract contract ERC165 is IERC165 {
261     /**
262      * @dev See {IERC165-supportsInterface}.
263      */
264     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
265         return interfaceId == type(IERC165).interfaceId;
266     }
267 }
268 
269 // File: contracts/core/NiftyEntity.sol
270 
271 /**
272  * @dev Authenticator of state mutating operations for Nifty Gateway contracts. 
273  *
274  * addresses for stateful operations. 
275  *
276  * Rinkeby: 0xCefBf44ff649B6E0Bc63785699c6F1690b8cF73b
277  * Mainnet: 0x6e53130dDfF21E3BC963Ee902005223b9A202106
278  */
279 contract NiftyEntity {
280    
281    // Address of {NiftyRegistry} contract. 
282    address internal immutable niftyRegistryContract;
283    
284    /**
285     * @dev Determines whether accounts are allowed to invoke state mutating operations on child contracts.
286     */
287     modifier onlyValidSender() {
288         NiftyRegistry niftyRegistry = NiftyRegistry(niftyRegistryContract);
289         bool isValid = niftyRegistry.isValidNiftySender(msg.sender);
290         require(isValid, "NiftyEntity: Invalid msg.sender");
291         _;
292     }
293     
294    /**
295     * @param _niftyRegistryContract Points to the repository of authenticated
296     */
297     constructor(address _niftyRegistryContract) {
298         niftyRegistryContract = _niftyRegistryContract;
299     }
300 }
301 
302 /**
303  * @dev Defined to mediate interaction with externally deployed {NiftyRegistry} dependency. 
304  */
305 interface NiftyRegistry {
306    function isValidNiftySender(address sending_key) external view returns (bool);
307 }
308 
309 // File: contracts/core/ERC721.sol
310 
311 /**
312  * @dev Nifty Gateway implementation of Non-Fungible Token Standard.
313  */
314 contract ERC721 is NiftyEntity, Context, ERC165, IERC721, IERC721Metadata {
315 
316     // Tracked individual instance spawned by {BuilderShop} contract. 
317     uint immutable public _id;
318 
319     // Number of distinct NFTs housed in this contract. 
320     uint immutable public _typeCount;
321 
322     // Intial receiver of all newly minted NFTs.
323     address immutable public _defaultOwner;
324 
325     // Component(s) of 'tokenId' calculation. 
326     uint immutable internal topLevelMultiplier;
327     uint immutable internal midLevelMultiplier;
328 
329     // Token name.
330     string private _name;
331 
332     // Token symbol.
333     string private _symbol;
334 
335     // Token artifact location.
336     string private _baseURI;
337 
338     // Mapping from Nifty type to name of token.
339     mapping(uint256 => string) private _niftyTypeName;
340 
341     // Mapping from Nifty type to IPFS hash of canonical artifcat file.
342     mapping(uint256 => string) private _niftyTypeIPFSHashes;
343 
344     // Mapping from token ID to owner address.
345     mapping (uint256 => address) internal _owners;
346 
347     // Mapping owner address to token count, by aggregating all _typeCount NFTs in the contact.
348     mapping (address => uint256) internal _balances;
349 
350     // Mapping from token ID to approved address.
351     mapping (uint256 => address) private _tokenApprovals;
352 
353     // Mapping from owner to operator approvals.
354     mapping (address => mapping (address => bool)) private _operatorApprovals;
355 
356     /**
357      * @dev Initializes the token collection.
358      *
359      * @param name_ Of the collection being deployed.
360      * @param symbol_ Shorthand token identifier, for wallets, etc.
361      * @param id_ Number instance deployed by {BuilderShop} contract.
362      * @param baseURI_ The location where the artifact assets are stored.
363      * @param typeCount_ The number of different Nifty types (different 
364      * individual NFTs) associated with the deployed collection.
365      * @param defaultOwner_ Intial receiver of all newly minted NFTs.
366      * @param niftyRegistryContract Points to the repository of authenticated
367      * addresses for stateful operations. 
368      */
369     constructor(string memory name_, 
370                 string memory symbol_,
371                 uint id_,
372                 string memory baseURI_,
373                 uint typeCount_,
374                 address defaultOwner_, 
375                 address niftyRegistryContract) NiftyEntity(niftyRegistryContract) {
376         _name = name_;
377         _symbol = symbol_;
378         _id = id_;
379         _baseURI = baseURI_;
380         _typeCount = typeCount_;
381         _defaultOwner = defaultOwner_;
382 
383         midLevelMultiplier = 10000;
384         topLevelMultiplier = id_ * 100000000;
385     }
386 
387     /**
388      * @dev See {IERC165-supportsInterface}.
389      */
390     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
391         return interfaceId == type(IERC721).interfaceId
392             || interfaceId == type(IERC721Metadata).interfaceId
393             || super.supportsInterface(interfaceId);
394     }
395 
396     /**
397      * @dev See {IERC721-balanceOf}.
398      */
399     function balanceOf(address owner) public view virtual override returns (uint256) {
400         require(owner != address(0), "ERC721: balance query for the zero address");
401         return _balances[owner];
402     }
403 
404     /**
405      * @dev See {IERC721-ownerOf}.
406      */
407     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
408         address owner = _owners[tokenId];
409         require(owner != address(0), "ERC721: owner query for nonexistent token");
410         return owner;
411     }
412 
413     /**
414      * @dev See {IERC721Metadata-name}.
415      */
416     function name() public view virtual override returns (string memory) {
417         return _name;
418     }
419 
420     /**
421      * @dev See {IERC721Metadata-symbol}.
422      */
423     function symbol() public view virtual override returns (string memory) {
424         return _symbol;
425     }
426 
427     /**
428      * @dev Returns the link to artificat location for a given token by 'tokenId'.
429      * Throws if the token ID does not exist. May return an empty string.
430      * @param tokenId uint256 ID of the token to query.
431      * @return The location where the artifact assets are stored.
432      */
433     function tokenURI(uint256 tokenId) external view override returns (string memory) {
434         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
435         string memory tokenIdStr = Strings.toString(tokenId);
436         return string(abi.encodePacked(_baseURI, tokenIdStr));
437     }
438 
439     /**
440      * @dev Returns an IPFS hash for a given token ID.
441      * Throws if the token ID does not exist. May return an empty string.
442      * @param tokenId uint256 ID of the token to query.
443      * @return IPFS hash for this (_typeCount) NFT. 
444      */
445     function tokenIPFSHash(uint256 tokenId) external view returns (string memory) {
446         require(_exists(tokenId), "ERC721Metadata: IPFS hash query for nonexistent token");
447         uint niftyType = _getNiftyTypeId(tokenId);
448         return _niftyTypeIPFSHashes[niftyType];
449     }
450     
451     /**
452      * @dev Determine which NFT in the contract (_typeCount) is associated 
453      * with this 'tokenId'.
454      */
455     function _getNiftyTypeId(uint tokenId) private view returns (uint) {
456         return (tokenId - topLevelMultiplier) / midLevelMultiplier;
457     }
458 
459     /**
460      * @dev Returns the Name for a given token ID.
461      * Throws if the token ID does not exist. May return an empty string.
462      * @param tokenId uint256 ID of the token to query
463      */
464     function tokenName(uint256 tokenId) external view returns (string memory) {
465         require(_exists(tokenId), "ERC721Metadata: Name query for nonexistent token");
466         uint niftyType = _getNiftyTypeId(tokenId);
467         return _niftyTypeName[niftyType];
468     }
469    
470     /**
471      * @dev Internal function to set the token IPFS hash for a nifty type.
472      * @param niftyType uint256 ID component of the token to set its IPFS hash
473      * @param ipfs_hash string IPFS link to assign
474      */
475     function _setTokenIPFSHashNiftyType(uint256 niftyType, string memory ipfs_hash) internal {
476         require(bytes(_niftyTypeIPFSHashes[niftyType]).length == 0, "ERC721Metadata: IPFS hash already set");
477         _niftyTypeIPFSHashes[niftyType] = ipfs_hash;
478     }
479 
480     /**
481      * @dev Internal function to set the name for a nifty type.
482      * @param niftyType uint256 of nifty type name to be set
483      * @param nifty_type_name name of nifty type
484      */
485     function _setNiftyTypeName(uint256 niftyType, string memory nifty_type_name) internal {
486         _niftyTypeName[niftyType] = nifty_type_name;
487     }
488 
489     /**
490      * @dev Base URI for computing {tokenURI}.
491      */
492     function _setBaseURI(string memory baseURI_) internal {
493         _baseURI = baseURI_;
494     }
495 
496     /**
497      * @dev See {IERC721-approve}.
498      */
499     function approve(address to, uint256 tokenId) public virtual override {
500         address owner = ERC721.ownerOf(tokenId);
501         require(to != owner, "ERC721: approval to current owner");
502 
503         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
504             "ERC721: approve caller is not owner nor approved for all"
505         );
506 
507         _approve(to, tokenId);
508     }
509 
510     /**
511      * @dev See {IERC721-getApproved}.
512      */
513     function getApproved(uint256 tokenId) public view virtual override returns (address) {
514         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
515         return _tokenApprovals[tokenId];
516     }
517 
518     /**
519      * @dev See {IERC721-setApprovalForAll}.
520      */
521     function setApprovalForAll(address operator, bool approved) public virtual override {
522         require(operator != _msgSender(), "ERC721: approve to caller");
523         _operatorApprovals[_msgSender()][operator] = approved;
524         emit ApprovalForAll(_msgSender(), operator, approved);
525     }
526 
527     /**
528      * @dev See {IERC721-isApprovedForAll}.
529      */
530     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
531         return _operatorApprovals[owner][operator];
532     }
533 
534     /**
535      * @dev See {IERC721-transferFrom}.
536      */
537     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
538         //solhint-disable-next-line max-line-length
539         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
540         _transfer(from, to, tokenId);
541     }
542 
543     /**
544      * @dev See {IERC721-safeTransferFrom}.
545      */
546     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
547         safeTransferFrom(from, to, tokenId, "");
548     }
549 
550     /**
551      * @dev See {IERC721-safeTransferFrom}.
552      */
553     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
554         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
555         _safeTransfer(from, to, tokenId, _data);
556     }
557 
558     /**
559      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
560      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
561      *
562      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
563      *
564      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
565      * implement alternative mechanisms to perform token transfer, such as signature-based.
566      *
567      * Requirements:
568      *
569      * - `from` cannot be the zero address.
570      * - `to` cannot be the zero address.
571      * - `tokenId` token must exist and be owned by `from`.
572      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
573      *
574      * Emits a {Transfer} event.
575      */
576     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
577         _transfer(from, to, tokenId);
578         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
579     }
580 
581     /**
582      * @dev Returns whether `tokenId` exists.
583      *
584      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
585      *
586      * Tokens start existing when they are minted (`_mint`),
587      * and stop existing when they are burned (`_burn`).
588      */
589     function _exists(uint256 tokenId) internal view virtual returns (bool) {
590         return _owners[tokenId] != address(0);
591     }
592 
593     /**
594      * @dev Returns whether `spender` is allowed to manage `tokenId`.
595      *
596      * Requirements:
597      *
598      * - `tokenId` must exist.
599      */
600     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
601         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
602         address owner = ERC721.ownerOf(tokenId);
603         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
604     }
605 
606     /**
607      * @dev Destroys `tokenId`.
608      * The approval is cleared when the token is burned.
609      *
610      * Requirements:
611      *
612      * - `tokenId` must exist.
613      *
614      * Emits a {Transfer} event.
615      */
616     function _burn(uint256 tokenId) internal virtual {
617         address owner = ERC721.ownerOf(tokenId);
618 
619         // Clear approvals
620         _approve(address(0), tokenId);
621 
622         _balances[owner] -= 1;
623         delete _owners[tokenId];
624 
625         emit Transfer(owner, address(0), tokenId);
626     }
627 
628     /**
629      * @dev Transfers `tokenId` from `from` to `to`.
630      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
631      *
632      * Requirements:
633      *
634      * - `to` cannot be the zero address.
635      * - `tokenId` token must be owned by `from`.
636      *
637      * Emits a {Transfer} event.
638      */
639     function _transfer(address from, address to, uint256 tokenId) internal virtual {
640         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
641         require(to != address(0), "ERC721: transfer to the zero address");
642 
643         // Clear approvals from the previous owner
644         _approve(address(0), tokenId);
645 
646         _balances[from] -= 1;
647         _balances[to] += 1;
648         _owners[tokenId] = to;
649 
650         emit Transfer(from, to, tokenId);
651     }
652 
653     /**
654      * @dev Approve `to` to operate on `tokenId`
655      *
656      * Emits a {Approval} event.
657      */
658     function _approve(address to, uint256 tokenId) internal virtual {
659         _tokenApprovals[tokenId] = to;
660         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
661     }
662 
663     /**
664      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
665      * The call is not executed if the target address is not a contract.
666      *
667      * @param from address representing the previous owner of the given token ID
668      * @param to target address that will receive the tokens
669      * @param tokenId uint256 ID of the token to be transferred
670      * @param _data bytes optional data to send along with the call
671      * @return bool whether the call correctly returned the expected magic value
672      */
673     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
674         private returns (bool)
675     {
676         if (isContract(to)) {
677             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
678                 return retval == IERC721Receiver(to).onERC721Received.selector;
679             } catch (bytes memory reason) {
680                 if (reason.length == 0) {
681                     revert("ERC721: transfer to non ERC721Receiver implementer");
682                 } else {
683                     // solhint-disable-next-line no-inline-assembly
684                     assembly {
685                         revert(add(32, reason), mload(reason))
686                     }
687                 }
688             }
689         } else {
690             return true;
691         }
692     }
693 
694     /**
695      * @dev Returns true if `account` is a contract.
696      *
697      * [IMPORTANT]
698      * ====
699      * It is unsafe to assume that an address for which this function returns
700      * false is an externally-owned account (EOA) and not a contract.
701      *
702      * Among others, `isContract` will return false for the following
703      * types of addresses:
704      *
705      *  - an externally-owned account
706      *  - a contract in construction
707      *  - an address where a contract will be created
708      *  - an address where a contract lived, but was destroyed
709      * ====
710      */
711     function isContract(address account) internal view returns (bool) {
712         // This method relies on extcodesize, which returns 0 for contracts in
713         // construction, since the code is only stored at the end of the
714         // constructor execution.
715 
716         uint256 size;
717         // solhint-disable-next-line no-inline-assembly
718         assembly { size := extcodesize(account) }
719         return size > 0;
720     }
721 }
722 
723 // File: contracts/standard/ERC721Burnable.sol
724 
725 /**
726  * @title ERC721 Burnable Token
727  * @dev ERC721 Token that can be irreversibly burned (destroyed).
728  */
729 abstract contract ERC721Burnable is Context, ERC721 {
730     /**
731      * @dev Burns `tokenId`. See {ERC721-_burn}.
732      *
733      * Requirements:
734      *
735      * - The caller must own `tokenId` or be an approved operator.
736      */
737     function burn(uint256 tokenId) public virtual {
738         //solhint-disable-next-line max-line-length
739         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
740         _burn(tokenId);
741     }
742 }
743 
744 // File: contracts/core/NiftyBuilderInstance.sol
745 
746 /**
747  * @dev Nifty Gateway extension of customized NFT contract, encapsulates
748  * logic for minting new tokens, and concluding the minting process. 
749  */
750 contract NiftyBuilderInstance is ERC721, ERC721Burnable {
751 
752     // The artist associated with the collection.
753     string private _creator;
754 
755     // Number of NFTs minted for a given 'typeCount'. 
756     mapping (uint256 => uint256) public _mintCount;
757 
758     /**
759      * @dev Serves as a gas cost optimized boolean flag 
760      * to indicate whether the minting process has been 
761      * concluded for a given 'typeCount', correspinds 
762      * to the {_getFinalized} and {setFinalized}.
763      */
764     mapping (uint256 => bytes32) private _finalized;
765 
766     /**
767      * @dev Emitted when tokens are created.
768      */
769     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed fromAddress, address indexed toAddress);
770 
771     /**
772      * @dev Ultimate instantiation of a Nifty Gateway NFT collection. 
773      * 
774      * @param name Of the collection being deployed.
775      * @param symbol Shorthand token identifier, for wallets, etc.
776      * @param id Number instance deployed by {BuilderShop} contract.
777      * @param typeCount The number of different Nifty types (different 
778      * individual NFTs) associated with the deployed collection.
779      * @param baseURI The location where the artifact assets are stored.
780      * @param creator_ The artist associated with the collection.
781      * @param niftyRegistryContract Points to the repository of authenticated
782      * addresses for stateful operations. 
783      * @param defaultOwner Intial receiver of all newly minted NFTs.
784      */
785     constructor(
786         string memory name,
787         string memory symbol,
788         uint id,
789         uint typeCount,
790         string memory baseURI,
791         string memory creator_,
792         address niftyRegistryContract,
793         address defaultOwner) ERC721(name, symbol, id, baseURI, typeCount, defaultOwner, niftyRegistryContract) {
794 
795         _creator = creator_;
796     }
797 
798     /**
799      * @dev Generate canonical Nifty Gateway token representation. 
800      * Nifty contracts have a data model called a 'niftyType' (typeCount) 
801      * The 'niftyType' refers to a specific nifty in our contract, note 
802      * that it gives no information about the edition size. In a given 
803      * contract, 'niftyType' 1 could be an edition of 10, while 'niftyType' 
804      * 2 is a 1/1, etc.
805      * The token IDs are encoded as follows: {id}{niftyType}{edition #}
806      * 'niftyType' has 4 digits, and edition number does as well, to allow 
807      * for 9999 possible 'niftyType' and 9999 of each edition in each contract.
808      * Example token id: [500010270]
809      * This is from contract #5, it is 'niftyType' 1 in the contract, and it is 
810      * edition #270 of 'niftyType' 1.
811      */
812     function _encodeTokenId(uint niftyType, uint tokenNumber) private view returns (uint) {
813         return (topLevelMultiplier + (niftyType * midLevelMultiplier) + tokenNumber);
814     }
815 
816     /**
817      * @dev Determine whether it is possible to mint additional NFTs for this 'niftyType'.
818      */
819     function _getFinalized(uint256 niftyType) public view returns (bool) {
820         bytes32 chunk = _finalized[niftyType / 256];
821         return (chunk & bytes32(1 << (niftyType % 256))) != 0x0;
822     }
823 
824     /**
825      * @dev Prevent the minting of additional NFTs of this 'niftyType'.
826      */
827     function setFinalized(uint256 niftyType) public onlyValidSender {
828         uint256 quotient = niftyType / 256;
829         bytes32 chunk = _finalized[quotient];
830         _finalized[quotient] = chunk | bytes32(1 << (niftyType % 256));
831     }
832 
833     /**
834      * @dev The artist of this collection.
835      */
836     function creator() public view virtual returns (string memory) {
837         return _creator;
838     }
839 
840     /**
841      * @dev Assign the root location where the artifact assets are stored.
842      */
843     function setBaseURI(string memory baseURI) public onlyValidSender {
844         _setBaseURI(baseURI);
845     }
846 
847     /**
848      * @dev Allow owner to change nifty name, by 'niftyType'.
849      */
850     function setNiftyName(uint niftyType, string memory niftyName) public onlyValidSender {
851         _setNiftyTypeName(niftyType, niftyName);
852     }
853 
854     /**
855      * @dev Assign the IPFS hash of canonical artifcat file, by 'niftyType'.
856      */   
857     function setNiftyIPFSHash(uint niftyType, string memory hashIPFS) public onlyValidSender {
858         _setTokenIPFSHashNiftyType(niftyType, hashIPFS);
859     }
860 
861     /**
862      * @dev Create specified number of nifties en masse.
863      * Once an NFT collection is spawned by the factory contract, we make calls to set the IPFS
864      * hash (above) for each Nifty type in the collection. 
865      * Subsequently calls are issued to this function to mint the appropriate number of tokens 
866      * for the project.
867      */
868     function mintNifty(uint niftyType, uint count) public onlyValidSender {
869         require(!_getFinalized(niftyType), "NiftyBuilderInstance: minting concluded for nifty type");
870             
871         uint tokenNumber = _mintCount[niftyType] + 1;
872         uint tokenId00 = _encodeTokenId(niftyType, tokenNumber);
873         uint tokenId01 = tokenId00 + count - 1;
874         
875         for (uint tokenId = tokenId00; tokenId <= tokenId01; tokenId++) {
876             _owners[tokenId] = _defaultOwner;
877         }
878         //TODO: Assign _balances by niftyType to make _mintCount mapping redundant
879         _mintCount[niftyType] += count;
880         _balances[_defaultOwner] += count;
881 
882         emit ConsecutiveTransfer(tokenId00, tokenId01, address(0), _defaultOwner);
883     }
884 
885 }