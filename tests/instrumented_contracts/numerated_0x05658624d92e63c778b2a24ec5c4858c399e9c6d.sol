1 // File: contracts/core/NiftyEntity.sol
2 
3 /**
4  * @dev Authenticator of state mutating operations for Nifty Gateway contracts. 
5  *
6  * addresses for stateful operations. 
7  *
8  * Rinkeby: 0xCefBf44ff649B6E0Bc63785699c6F1690b8cF73b
9  * Mainnet: 0x6e53130dDfF21E3BC963Ee902005223b9A202106
10  */
11 contract NiftyEntity {
12    
13    // Address of {NiftyRegistry} contract. 
14    address internal immutable niftyRegistryContract;
15    
16    /**
17     * @dev Determines whether accounts are allowed to invoke state mutating operations on child contracts.
18     */
19     modifier onlyValidSender() {
20         NiftyRegistry niftyRegistry = NiftyRegistry(niftyRegistryContract);
21         bool isValid = niftyRegistry.isValidNiftySender(msg.sender);
22         require(isValid, "NiftyEntity: Invalid msg.sender");
23         _;
24     }
25     
26    /**
27     * @param _niftyRegistryContract Points to the repository of authenticated
28     */
29     constructor(address _niftyRegistryContract) {
30         niftyRegistryContract = _niftyRegistryContract;
31     }
32 }
33 
34 /**
35  * @dev Defined to mediate interaction with externally deployed {NiftyRegistry} dependency. 
36  */
37 interface NiftyRegistry {
38    function isValidNiftySender(address sending_key) external view returns (bool);
39 }
40 
41 // File: contracts/interface/IERC165.sol
42 
43 /**
44  * @title IERC165
45  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
46  */
47 interface IERC165 {
48 
49   /**
50    * @notice Query if a contract implements an interface
51    * @param interfaceId The interface identifier, as specified in ERC-165
52    * @dev Interface identification is specified in ERC-165. This function
53    * uses less than 30,000 gas.
54    */
55   function supportsInterface(bytes4 interfaceId)
56     external
57     view
58     returns (bool);
59 }
60 
61 // File: contracts/interface/IERC721.sol
62 
63 /**
64  * @dev Required interface of an ERC721 compliant contract.
65  */
66 interface IERC721 is IERC165 {
67     /**
68      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
71 
72     /**
73      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
74      */
75     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
76 
77     /**
78      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
79      */
80     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
81 
82     /**
83      * @dev Returns the number of tokens in ``owner``'s account.
84      */
85     function balanceOf(address owner) external view returns (uint256 balance);
86 
87     /**
88      * @dev Returns the owner of the `tokenId` token.
89      *
90      * Requirements:
91      *
92      * - `tokenId` must exist.
93      */
94     function ownerOf(uint256 tokenId) external view returns (address owner);
95 
96     /**
97      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
98      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
99      *
100      * Requirements:
101      *
102      * - `from` cannot be the zero address.
103      * - `to` cannot be the zero address.
104      * - `tokenId` token must exist and be owned by `from`.
105      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
106      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
107      *
108      * Emits a {Transfer} event.
109      */
110     function safeTransferFrom(address from, address to, uint256 tokenId) external;
111 
112     /**
113      * @dev Transfers `tokenId` token from `from` to `to`.
114      *
115      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
116      *
117      * Requirements:
118      *
119      * - `from` cannot be the zero address.
120      * - `to` cannot be the zero address.
121      * - `tokenId` token must be owned by `from`.
122      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
123      *
124      * Emits a {Transfer} event.
125      */
126     function transferFrom(address from, address to, uint256 tokenId) external;
127 
128     /**
129      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
130      * The approval is cleared when the token is transferred.
131      *
132      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
133      *
134      * Requirements:
135      *
136      * - The caller must own the token or be an approved operator.
137      * - `tokenId` must exist.
138      *
139      * Emits an {Approval} event.
140      */
141     function approve(address to, uint256 tokenId) external;
142 
143     /**
144      * @dev Returns the account approved for `tokenId` token.
145      *
146      * Requirements:
147      *
148      * - `tokenId` must exist.
149      */
150     function getApproved(uint256 tokenId) external view returns (address operator);
151 
152     /**
153      * @dev Approve or remove `operator` as an operator for the caller.
154      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
155      *
156      * Requirements:
157      *
158      * - The `operator` cannot be the caller.
159      *
160      * Emits an {ApprovalForAll} event.
161      */
162     function setApprovalForAll(address operator, bool _approved) external;
163 
164     /**
165      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
166      *
167      * See {setApprovalForAll}
168      */
169     function isApprovedForAll(address owner, address operator) external view returns (bool);
170 
171     /**
172       * @dev Safely transfers `tokenId` token from `from` to `to`.
173       *
174       * Requirements:
175       *
176       * - `from` cannot be the zero address.
177       * - `to` cannot be the zero address.
178       * - `tokenId` token must exist and be owned by `from`.
179       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
180       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
181       *
182       * Emits a {Transfer} event.
183       */
184     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
185 }
186 
187 // File: contracts/interface/IERC721Receiver.sol
188 
189 /**
190  * @title ERC721 token receiver interface
191  * @dev Interface for any contract that wants to support safeTransfers
192  * from ERC721 asset contracts.
193  */
194 interface IERC721Receiver {
195     /**
196      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
197      * by `operator` from `from`, this function is called.
198      *
199      * It must return its Solidity selector to confirm the token transfer.
200      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
201      *
202      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
203      */
204     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
205 }
206 
207 // File: contracts/interface/IERC721Metadata.sol
208 
209 /**
210  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
211  * @dev See https://eips.ethereum.org/EIPS/eip-721
212  */
213 interface IERC721Metadata is IERC721 {
214 
215     /**
216      * @dev Returns the token collection name.
217      */
218     function name() external view returns (string memory);
219 
220     /**
221      * @dev Returns the token collection symbol.
222      */
223     function symbol() external view returns (string memory);
224 
225     /**
226      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
227      */
228     function tokenURI(uint256 tokenId) external view returns (string memory);
229 }
230 
231 // File: contracts/util/Context.sol
232 
233 /*
234  * @dev Provides information about the current execution context, including the
235  * sender of the transaction and its data. While these are generally available
236  * via msg.sender and msg.data, they should not be accessed in such a direct
237  * manner, since when dealing with meta-transactions the account sending and
238  * paying for execution may not be the actual sender (as far as an application
239  * is concerned).
240  *
241  * This contract is only required for intermediate, library-like contracts.
242  */
243 abstract contract Context {
244     function _msgSender() internal view virtual returns (address) {
245         return msg.sender;
246     }
247 }
248 
249 // File: contracts/util/Strings.sol
250 
251 /**
252  * @dev String operations.
253  */
254 library Strings {
255     bytes16 private constant alphabet = "0123456789abcdef";
256 
257     /**
258      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
259      */
260     function toString(uint256 value) internal pure returns (string memory) {
261         // Inspired by OraclizeAPI's implementation - MIT licence
262         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
263 
264         if (value == 0) {
265             return "0";
266         }
267         uint256 temp = value;
268         uint256 digits;
269         while (temp != 0) {
270             digits++;
271             temp /= 10;
272         }
273         bytes memory buffer = new bytes(digits);
274         while (value != 0) {
275             digits -= 1;
276             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
277             value /= 10;
278         }
279         return string(buffer);
280     }
281 
282 }
283 
284 // File: contracts/standard/ERC165.sol
285 
286 /**
287  * @dev Implementation of the {IERC165} interface.
288  *
289  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
290  * for the additional interface id that will be supported. For example:
291  *
292  * ```solidity
293  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
294  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
295  * }
296  * ```
297  *
298  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
299  */
300 abstract contract ERC165 is IERC165 {
301     /**
302      * @dev See {IERC165-supportsInterface}.
303      */
304     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
305         return interfaceId == type(IERC165).interfaceId;
306     }
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
371                 uint256 id_,
372                 string memory baseURI_,
373                 uint256 typeCount_,
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
447         uint256 niftyType = _getNiftyTypeId(tokenId);
448         return _niftyTypeIPFSHashes[niftyType];
449     }
450     
451     /**
452      * @dev Determine which NFT in the contract (_typeCount) is associated 
453      * with this 'tokenId'.
454      */
455     function _getNiftyTypeId(uint256 tokenId) private view returns (uint256) {
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
466         uint256 niftyType = _getNiftyTypeId(tokenId);
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
747  * XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
748  * XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  .***   XXXXXXXXXXXXXXXXXX
749  * XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  ,*********  XXXXXXXXXXXXXXXX
750  * XXXXXXXXXXXXXXXXXXXXXXXXXXXX  ***************  XXXXXXXXXXXXX
751  * XXXXXXXXXXXXXXXXXXXXXXXXX  .*******************  XXXXXXXXXXX
752  * XXXXXXXXXXXXXXXXXXXXXXX  ***********    **********  XXXXXXXX
753  * XXXXXXXXXXXXXXXXXXXX   ***********       ***********  XXXXXX
754  * XXXXXXXXXXXXXXXXXX  ***********         ***************  XXX
755  * XXXXXXXXXXXXXXXX  ***********           ****    ********* XX
756  * XXXXXXXXXXXXXXXX *********      ***    ***      *********  X
757  * XXXXXXXXXXXXXXXX  **********  *****          *********** XXX
758  * XXXXXXXXXXXX   /////.*************         ***********  XXXX
759  * XXXXXXXXX  /////////...***********      ************  XXXXXX
760  * XXXXXXX/ ///////////..... /////////   ///////////   XXXXXXXX
761  * XXXXXX  /    //////.........///////////////////   XXXXXXXXXX
762  * XXXXXXXXXX .///////...........//////////////   XXXXXXXXXXXXX
763  * XXXXXXXXX .///////.....//..////  /////////  XXXXXXXXXXXXXXXX
764  * XXXXXXX# /////////////////////  XXXXXXXXXXXXXXXXXXXXXXXXXXXX
765  * XXXXX   ////////////////////   XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
766  * XX   ////////////// //////   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
767  * XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
768  *
769  * @dev Nifty Gateway extension of customized NFT contract, encapsulates
770  * logic for minting new tokens, and concluding the minting process. 
771  */
772 contract NiftyBuilderInstance is ERC721, ERC721Burnable {
773 
774     // The artist associated with the collection.
775     string private _creator;
776 
777     // Number of NFTs minted for a given 'typeCount'. 
778     mapping (uint256 => uint256) public _mintCount;
779 
780     /**
781      * @dev Serves as a gas cost optimized boolean flag 
782      * to indicate whether the minting process has been 
783      * concluded for a given 'typeCount', correspinds 
784      * to the {_getFinalized} and {setFinalized}.
785      */
786     mapping (uint256 => bytes32) private _finalized;
787 
788     /**
789      * @dev Emitted when tokens are created.
790      */
791     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed fromAddress, address indexed toAddress);
792 
793     /**
794      * @dev Ultimate instantiation of a Nifty Gateway NFT collection. 
795      * 
796      * @param name Of the collection being deployed.
797      * @param symbol Shorthand token identifier, for wallets, etc.
798      * @param id Number instance deployed by {BuilderShop} contract.
799      * @param typeCount The number of different Nifty types (different 
800      * individual NFTs) associated with the deployed collection.
801      * @param baseURI The location where the artifact assets are stored.
802      * @param creator_ The artist associated with the collection.
803      * @param niftyRegistryContract Points to the repository of authenticated
804      * addresses for stateful operations. 
805      * @param defaultOwner Intial receiver of all newly minted NFTs.
806      */
807     constructor(
808         string memory name,
809         string memory symbol,
810         uint256 id,
811         uint256 typeCount,
812         string memory baseURI,
813         string memory creator_,
814         address niftyRegistryContract,
815         address defaultOwner) ERC721(name, symbol, id, baseURI, typeCount, defaultOwner, niftyRegistryContract) {
816 
817         _creator = creator_;
818     }
819 
820     /**
821      * @dev Generate canonical Nifty Gateway token representation. 
822      * Nifty contracts have a data model called a 'niftyType' (typeCount) 
823      * The 'niftyType' refers to a specific nifty in our contract, note 
824      * that it gives no information about the edition size. In a given 
825      * contract, 'niftyType' 1 could be an edition of 10, while 'niftyType' 
826      * 2 is a 1/1, etc.
827      * The token IDs are encoded as follows: {id}{niftyType}{edition #}
828      * 'niftyType' has 4 digits, and edition number does as well, to allow 
829      * for 9999 possible 'niftyType' and 9999 of each edition in each contract.
830      * Example token id: [500010270]
831      * This is from contract #5, it is 'niftyType' 1 in the contract, and it is 
832      * edition #270 of 'niftyType' 1.
833      */
834     function _encodeTokenId(uint256 niftyType, uint256 tokenNumber) private view returns (uint256) {
835         return (topLevelMultiplier + (niftyType * midLevelMultiplier) + tokenNumber);
836     }
837 
838     /**
839      * @dev Determine whether it is possible to mint additional NFTs for this 'niftyType'.
840      */
841     function _getFinalized(uint256 niftyType) public view returns (bool) {
842         bytes32 chunk = _finalized[niftyType / 256];
843         return (chunk & bytes32(1 << (niftyType % 256))) != 0x0;
844     }
845 
846     /**
847      * @dev Prevent the minting of additional NFTs of this 'niftyType'.
848      */
849     function setFinalized(uint256 niftyType) public onlyValidSender {
850         uint256 quotient = niftyType / 256;
851         bytes32 chunk = _finalized[quotient];
852         _finalized[quotient] = chunk | bytes32(1 << (niftyType % 256));
853     }
854 
855     /**
856      * @dev The artist of this collection.
857      */
858     function creator() public view virtual returns (string memory) {
859         return _creator;
860     }
861 
862     /**
863      * @dev Assign the root location where the artifact assets are stored.
864      */
865     function setBaseURI(string memory baseURI) public onlyValidSender {
866         _setBaseURI(baseURI);
867     }
868 
869     /**
870      * @dev Allow owner to change nifty name, by 'niftyType'.
871      */
872     function setNiftyName(uint256 niftyType, string memory niftyName) public onlyValidSender {
873         _setNiftyTypeName(niftyType, niftyName);
874     }
875 
876     /**
877      * @dev Assign the IPFS hash of canonical artifcat file, by 'niftyType'.
878      */   
879     function setNiftyIPFSHash(uint256 niftyType, string memory hashIPFS) public onlyValidSender {
880         _setTokenIPFSHashNiftyType(niftyType, hashIPFS);
881     }
882 
883     /**
884      * @dev Create specified number of nifties en masse.
885      * Once an NFT collection is spawned by the factory contract, we make calls to set the IPFS
886      * hash (above) for each Nifty type in the collection. 
887      * Subsequently calls are issued to this function to mint the appropriate number of tokens 
888      * for the project.
889      */
890     function mintNifty(uint256 niftyType, uint256 count) public onlyValidSender {
891         require(!_getFinalized(niftyType), "NiftyBuilderInstance: minting concluded for nifty type");
892             
893         uint256 tokenNumber = _mintCount[niftyType] + 1;
894         uint256 tokenId00 = _encodeTokenId(niftyType, tokenNumber);
895         uint256 tokenId01 = tokenId00 + count - 1;
896         
897         for (uint256 tokenId = tokenId00; tokenId <= tokenId01; tokenId++) {
898             _owners[tokenId] = _defaultOwner;
899         }
900         _mintCount[niftyType] += count;
901         _balances[_defaultOwner] += count;
902 
903         emit ConsecutiveTransfer(tokenId00, tokenId01, address(0), _defaultOwner);
904     }
905 
906 }
907 
908 // File: contracts/core/BuilderShop.sol
909 
910 // SPDX-License-Identifier: MIT
911 pragma solidity ^0.8.6;
912 
913 
914 
915 /**
916  *   ::::::::::::::::::::::::::::::::::::::::::::
917  * ::::::::::::::::::::::::::::::::::::::::::::::::
918  * ::::::::::::::::::::::::::::::::::::::::::::::::
919  * ::::::::::::NNNNNNNNN:::::::NNNNNNNN::::::::::::
920  * ::::::::::::NNNNNNNNNN::::::NNNNNNNN::::::::::::
921  * ::::::::::::NNNNNNNNNNN:::::NNNNNNNN::::::::::::
922  * ::::::::::::NNNNNNNNNNNN::::NNNNNNNN::::::::::::
923  * ::::::::::::NNNNNNNNNNNNN:::NNNNNNNN::::::::::::
924  * ::::::::::::NNNNNNNNNNNNNN::NNNNNNNN::::::::::::
925  * ::::::::::::NNNNNNNN:NNNNNN:NNNNNNNN::::::::::::
926  * ::::::::::::NNNNNNNN::NNNNNNNNNNNNNN::::::::::::
927  * ::::::::::::NNNNNNNN:::NNNNNNNNNNNNN::::::::::::
928  * ::::::::::::NNNNNNNN::::NNNNNNNNNNNN::::::::::::
929  * ::::::::::::NNNNNNNN:::::NNNNNNNNNNN::::::::::::
930  * ::::::::::::NNNNNNNN::::::NNNNNNNNNN::::::::::::
931  * ::::::::::::NNNNNNNN:::::::NNNNNNNNN::::::::::::
932  * ::::::::::::::::::::::::::::::::::::::::::::::::
933  * ::::::::::::::::::::::::::::::::::::::::::::::::
934  *   ::::::::::::::::::::::::::::::::::::::::::::
935  *  
936  * @dev Nexus of the Nifty Gateway smartcontract constellation.
937  * {BuilderShop} is a factory contract, when a new collection
938  * is slated for deployment, a call is made to this factory 
939  * contract to create it. 
940  */
941 contract BuilderShop is NiftyEntity {
942 
943     /**
944      * @dev Tracks the latest {NiftyBuilderInstance} deployment, supplied as constructor 
945      * argument. Every time a new contract is deployed from this "master" factory contract, 
946      * it is given a contract id that is one higher than the previous contract deployed.
947      */
948     uint public _id;
949 
950     // Provided as a argument to {NiftyBuilderInstance} deployment.
951     address public _defaultOwner;
952 
953     // Reference for validation of posible {NiftyBuilderInstance} by address.
954     mapping (address => bool) public validBuilderInstance;
955 
956     // Log the creation of each {NiftyBuilderInstance} deployment. 
957     event BuilderInstanceCreated(address instanceAddress, uint id);
958 
959     /**
960      * @param niftyRegistryContract Points to the mainnet repository of addresses
961      * allowed to invoke state mutating operations via the modifier 'onlyValidSender'.
962      * @param defaultOwner_ The address to which all tokens are initially minted.
963      */
964     constructor(address niftyRegistryContract,
965                 address defaultOwner_) NiftyEntity(niftyRegistryContract) {
966         _defaultOwner = defaultOwner_;
967     }
968 
969     /**
970      * @dev Configurable address for defaultOwner.
971      * @param defaultOwner account to which newly minted tokens are allocated.
972      */ 
973     function setDefaultOwner(address defaultOwner) onlyValidSender external {
974         _defaultOwner = defaultOwner;
975     }
976 
977     /**
978      * @dev Allow anyone to check if a contract address is a valid nifty gateway contract.
979      * @param instanceAddress address of potential spawned {NiftyBuilderInstance}.
980      * @return bool whether or not the contract was initialized by this {BuilderShop}.
981      */
982     function isValidBuilderInstance(address instanceAddress) external view returns (bool) {
983         return (validBuilderInstance[instanceAddress]);
984     }
985 
986     /**
987      * @dev Collections on the platform are associated with a call to this 
988      * function which will generate a {NiftyBuilderInstance} to house the 
989      * NFTs for that particular artist release. 
990      * 
991      * @param name Of the collection being deployed.
992      * @param symbol Shorthand token identifier, for wallets, etc.
993      * @param typeCount The number of different Nifty types (different 
994      * individual NFTs) associated with the deployed collection.
995      * @param baseURI The location where the artifact assets are stored.
996      * @param creator The artist associated with the collection.
997      */
998     function createNewBuilderInstance(
999         string memory name,
1000         string memory symbol,
1001         uint256 typeCount,
1002         string memory baseURI,
1003         string memory creator) external onlyValidSender { 
1004         
1005         _id += 1;
1006 
1007         NiftyBuilderInstance instance = new NiftyBuilderInstance(
1008             name,
1009             symbol,
1010             _id,
1011             typeCount,
1012             baseURI,
1013             creator,
1014             niftyRegistryContract,
1015             _defaultOwner
1016         );
1017         address instanceAddress = address(instance);
1018         validBuilderInstance[instanceAddress] = true;
1019 
1020         emit BuilderInstanceCreated(instanceAddress, _id);
1021     }
1022    
1023 }