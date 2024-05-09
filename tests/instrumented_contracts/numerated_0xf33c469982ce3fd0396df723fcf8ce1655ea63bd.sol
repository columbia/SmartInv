1 /**
2  *Submitted for verification at Etherscan.io on 2022-03-08
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-02-21
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-01-24
11 */
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2022-01-22
15 */
16 
17 // SPDX-License-Identifier: MIT
18 pragma solidity ^0.8.0;
19 
20 
21 
22 /*
23  * @dev Provides information about the current execution context, including the
24  * sender of the transaction and its data. While these are generally available
25  * via msg.sender and msg.data, they should not be accessed in such a direct
26  * manner, since when dealing with meta-transactions the account sending and
27  * paying for execution may not be the actual sender (as far as an application
28  * is concerned).
29  *
30  * This contract is only required for intermediate, library-like contracts.
31  */
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address) {
34         return msg.sender;
35     }
36 
37     function _msgData() internal view virtual returns (bytes calldata) {
38         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
39         return msg.data;
40     }
41 }
42 
43 /**
44  * @dev Contract module which allows children to implement an emergency stop
45  * mechanism that can be triggered by an authorized account.
46  *
47  * This module is used through inheritance. It will make available the
48  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
49  * the functions of your contract. Note that they will not be pausable by
50  * simply including this module, only once the modifiers are put in place.
51  */
52 abstract contract Pausable is Context {
53     /**
54      * @dev Emitted when the pause is triggered by `account`.
55      */
56     event Paused(address account);
57 
58     /**
59      * @dev Emitted when the pause is lifted by `account`.
60      */
61     event Unpaused(address account);
62 
63     bool private _paused;
64 
65     /**
66      * @dev Initializes the contract in unpaused state.
67      */
68     constructor () {
69         _paused = false;
70     }
71 
72     /**
73      * @dev Returns true if the contract is paused, and false otherwise.
74      */
75     function paused() public view virtual returns (bool) {
76         return _paused;
77     }
78 
79     /**
80      * @dev Modifier to make a function callable only when the contract is not paused.
81      *
82      * Requirements:
83      *
84      * - The contract must not be paused.
85      */
86     modifier whenNotPaused() {
87         require(!paused(), "Pausable: paused");
88         _;
89     }
90 
91     /**
92      * @dev Modifier to make a function callable only when the contract is paused.
93      *
94      * Requirements:
95      *
96      * - The contract must be paused.
97      */
98     modifier whenPaused() {
99         require(paused(), "Pausable: not paused");
100         _;
101     }
102 
103     /**
104      * @dev Triggers stopped state.
105      *
106      * Requirements:
107      *
108      * - The contract must not be paused.
109      */
110     function _pause() internal virtual whenNotPaused {
111         _paused = true;
112         emit Paused(_msgSender());
113     }
114 
115     /**
116      * @dev Returns to normal state.
117      *
118      * Requirements:
119      *
120      * - The contract must be paused.
121      */
122     function _unpause() internal virtual whenPaused {
123         _paused = false;
124         emit Unpaused(_msgSender());
125     }
126 }
127 
128 /**
129  * @dev Contract module which provides a basic access control mechanism, where
130  * there is an account (an owner) that can be granted exclusive access to
131  * specific functions.
132  *
133  * By default, the owner account will be the one that deploys the contract. This
134  * can later be changed with {transferOwnership}.
135  *
136  * This module is used through inheritance. It will make available the modifier
137  * `onlyOwner`, which can be applied to your functions to restrict their use to
138  * the owner.
139  */
140 abstract contract Ownable is Context {
141     address private _owner;
142 
143     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
144 
145     /**
146      * @dev Initializes the contract setting the deployer as the initial owner.
147      */
148     constructor () {
149         address msgSender = _msgSender();
150         _owner = msgSender;
151         emit OwnershipTransferred(address(0), msgSender);
152     }
153 
154     /**
155      * @dev Returns the address of the current owner.
156      */
157     function owner() public view virtual returns (address) {
158         return _owner;
159     }
160 
161     /**
162      * @dev Throws if called by any account other than the owner.
163      */
164     modifier onlyOwner() {
165         require(owner() == _msgSender(), "Ownable: caller is not the owner");
166         _;
167     }
168 
169     /**
170      * @dev Leaves the contract without owner. It will not be possible to call
171      * `onlyOwner` functions anymore. Can only be called by the current owner.
172      *
173      * NOTE: Renouncing ownership will leave the contract without an owner,
174      * thereby removing any functionality that is only available to the owner.
175      */
176     function renounceOwnership() public virtual onlyOwner {
177         emit OwnershipTransferred(_owner, address(0));
178         _owner = address(0);
179     }
180 
181     /**
182      * @dev Transfers ownership of the contract to a new account (`newOwner`).
183      * Can only be called by the current owner.
184      */
185     function transferOwnership(address newOwner) public virtual onlyOwner {
186         require(newOwner != address(0), "Ownable: new owner is the zero address");
187         emit OwnershipTransferred(_owner, newOwner);
188         _owner = newOwner;
189     }
190 }
191 
192 
193 /**
194  * @dev Interface of the ERC165 standard, as defined in the
195  * https://eips.ethereum.org/EIPS/eip-165[EIP].
196  *
197  * Implementers can declare support of contract interfaces, which can then be
198  * queried by others ({ERC165Checker}).
199  *
200  * For an implementation, see {ERC165}.
201  */
202 interface IERC165 {
203     /**
204      * @dev Returns true if this contract implements the interface defined by
205      * `interfaceId`. See the corresponding
206      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
207      * to learn more about how these ids are created.
208      *
209      * This function call must use less than 30 000 gas.
210      */
211     function supportsInterface(bytes4 interfaceId) external view returns (bool);
212 }
213 
214 
215 /**
216  * @dev Implementation of the {IERC165} interface.
217  *
218  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
219  * for the additional interface id that will be supported. For example:
220  *
221  * ```solidity
222  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
223  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
224  * }
225  * ```
226  *
227  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
228  */
229 abstract contract ERC165 is IERC165 {
230     /**
231      * @dev See {IERC165-supportsInterface}.
232      */
233     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
234         return interfaceId == type(IERC165).interfaceId;
235     }
236 }
237 
238 
239 
240 /**
241  * @dev Required interface of an ERC721 compliant contract.
242  */
243 interface IERC721 is IERC165 {
244     /**
245      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
246      */
247     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
248 
249     /**
250      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
251      */
252     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
253 
254     /**
255      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
256      */
257     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
258 
259     /**
260      * @dev Returns the number of tokens in ``owner``'s account.
261      */
262     function balanceOf(address owner) external view returns (uint256 balance);
263 
264     /**
265      * @dev Returns the owner of the `tokenId` token.
266      *
267      * Requirements:
268      *
269      * - `tokenId` must exist.
270      */
271     function ownerOf(uint256 tokenId) external view returns (address owner);
272 
273     /**
274      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
275      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
276      *
277      * Requirements:
278      *
279      * - `from` cannot be the zero address.
280      * - `to` cannot be the zero address.
281      * - `tokenId` token must exist and be owned by `from`.
282      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
283      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
284      *
285      * Emits a {Transfer} event.
286      */
287     function safeTransferFrom(address from, address to, uint256 tokenId) external;
288 
289     /**
290      * @dev Transfers `tokenId` token from `from` to `to`.
291      *
292      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
293      *
294      * Requirements:
295      *
296      * - `from` cannot be the zero address.
297      * - `to` cannot be the zero address.
298      * - `tokenId` token must be owned by `from`.
299      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
300      *
301      * Emits a {Transfer} event.
302      */
303     function transferFrom(address from, address to, uint256 tokenId) external;
304 
305     /**
306      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
307      * The approval is cleared when the token is transferred.
308      *
309      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
310      *
311      * Requirements:
312      *
313      * - The caller must own the token or be an approved operator.
314      * - `tokenId` must exist.
315      *
316      * Emits an {Approval} event.
317      */
318     function approve(address to, uint256 tokenId) external;
319 
320     /**
321      * @dev Returns the account approved for `tokenId` token.
322      *
323      * Requirements:
324      *
325      * - `tokenId` must exist.
326      */
327     function getApproved(uint256 tokenId) external view returns (address operator);
328 
329     /**
330      * @dev Approve or remove `operator` as an operator for the caller.
331      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
332      *
333      * Requirements:
334      *
335      * - The `operator` cannot be the caller.
336      *
337      * Emits an {ApprovalForAll} event.
338      */
339     function setApprovalForAll(address operator, bool _approved) external;
340 
341     /**
342      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
343      *
344      * See {setApprovalForAll}
345      */
346     function isApprovedForAll(address owner, address operator) external view returns (bool);
347 
348     /**
349       * @dev Safely transfers `tokenId` token from `from` to `to`.
350       *
351       * Requirements:
352       *
353       * - `from` cannot be the zero address.
354       * - `to` cannot be the zero address.
355       * - `tokenId` token must exist and be owned by `from`.
356       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
357       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
358       *
359       * Emits a {Transfer} event.
360       */
361     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
362 }
363 
364 /**
365  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
366  * @dev See https://eips.ethereum.org/EIPS/eip-721
367  */
368 interface IERC721Metadata is IERC721 {
369 
370     /**
371      * @dev Returns the token collection name.
372      */
373     function name() external view returns (string memory);
374 
375     /**
376      * @dev Returns the token collection symbol.
377      */
378     function symbol() external view returns (string memory);
379 
380     /**
381      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
382      */
383     function tokenURI(uint256 tokenId) external view returns (string memory);
384 }
385 
386 
387 /**
388  * @title ERC721 token receiver interface
389  * @dev Interface for any contract that wants to support safeTransfers
390  * from ERC721 asset contracts.
391  */
392 interface IERC721Receiver {
393     /**
394      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
395      * by `operator` from `from`, this function is called.
396      *
397      * It must return its Solidity selector to confirm the token transfer.
398      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
399      *
400      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
401      */
402     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
403 }
404 
405 
406 /**
407  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
408  * @dev See https://eips.ethereum.org/EIPS/eip-721
409  */
410 interface IERC721Enumerable is IERC721 {
411 
412     /**
413      * @dev Returns the total amount of tokens stored by the contract.
414      */
415     function totalSupply() external view returns (uint256);
416 
417     /**
418      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
419      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
420      */
421     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
422 
423     /**
424      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
425      * Use along with {totalSupply} to enumerate all tokens.
426      */
427     function tokenByIndex(uint256 index) external view returns (uint256);
428 }
429 
430 library Address {
431     /**
432      * @dev Returns true if `account` is a contract.
433      *
434      * [IMPORTANT]
435      * ====
436      * It is unsafe to assume that an address for which this function returns
437      * false is an externally-owned account (EOA) and not a contract.
438      *
439      * Among others, `isContract` will return false for the following
440      * types of addresses:
441      *
442      *  - an externally-owned account
443      *  - a contract in construction
444      *  - an address where a contract will be created
445      *  - an address where a contract lived, but was destroyed
446      * ====
447      */
448     function isContract(address account) internal view returns (bool) {
449         // This method relies on extcodesize, which returns 0 for contracts in
450         // construction, since the code is only stored at the end of the
451         // constructor execution.
452 
453         uint256 size;
454         // solhint-disable-next-line no-inline-assembly
455         assembly { size := extcodesize(account) }
456         return size > 0;
457     }
458 }
459 
460 library Strings {
461     /**
462      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
463      */
464     function toString(uint256 value) internal pure returns (string memory) {
465         // Inspired by OraclizeAPI's implementation - MIT licence
466         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
467 
468         if (value == 0) {
469             return "0";
470         }
471         uint256 temp = value;
472         uint256 digits;
473         while (temp != 0) {
474             digits++;
475             temp /= 10;
476         }
477         bytes memory buffer = new bytes(digits);
478         while (value != 0) {
479             digits -= 1;
480             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
481             value /= 10;
482         }
483         return string(buffer);
484     }
485 }
486 /**
487  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
488  * the Metadata extension, but not including the Enumerable extension, which is available separately as
489  * {ERC721Enumerable}.
490  */
491 contract ERC721 is Context, ERC165, IERC721Metadata {
492     using Address for address;
493     using Strings for uint256;
494 
495     // Token name
496     string private _name;
497 
498     // Token symbol
499     string private _symbol;
500 
501     // Optional mapping for token URIs
502     mapping (uint256 => string) private _tokenURIs;
503 
504     // Base URI
505     string private _baseURI;
506 
507     // Mapping from token ID to owner address
508     mapping (uint256 => address) private _owners;
509 
510     // Mapping owner address to token count
511     mapping (address => uint256) private _balances;
512 
513     // Mapping from token ID to approved address
514     mapping (uint256 => address) private _tokenApprovals;
515 
516     // Mapping from owner to operator approvals
517     mapping (address => mapping (address => bool)) private _operatorApprovals;
518     
519 
520     /**
521      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
522      */
523     constructor (string memory name_, string memory symbol_) {
524         _name = name_;
525         _symbol = symbol_;
526     }
527 
528     /**
529      * @dev See {IERC165-supportsInterface}.
530      */
531     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
532         return interfaceId == type(IERC721).interfaceId
533             || interfaceId == type(IERC721Metadata).interfaceId
534             || super.supportsInterface(interfaceId);
535     }
536 
537     /**
538      * @dev See {IERC721-balanceOf}.
539      */
540     function balanceOf(address owner) public view virtual override returns (uint256) {
541         require(owner != address(0), "ERC721: balance query for the zero address");
542         return _balances[owner];
543     }
544 
545     /**
546      * @dev See {IERC721-ownerOf}.
547      */
548     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
549         address owner = _owners[tokenId];
550         require(owner != address(0), "ERC721: owner query for nonexistent token");
551         return owner;
552     }
553 
554     /**
555      * @dev See {IERC721Metadata-name}.
556      */
557     function name() public view virtual override returns (string memory) {
558         return _name;
559     }
560 
561     /**
562      * @dev See {IERC721Metadata-symbol}.
563      */
564     function symbol() public view virtual override returns (string memory) {
565         return _symbol;
566     }
567 
568     /**
569      * @dev See {IERC721Metadata-tokenURI}.
570      */
571 
572     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
573         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
574 
575         string memory _tokenURI = _tokenURIs[tokenId];
576 
577         // If there is no base URI, return the token URI.
578         if (bytes(_baseURI).length == 0) {
579             return _tokenURI;
580         }
581         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
582         if (bytes(_tokenURI).length > 0) {
583             return string(abi.encodePacked(_baseURI, _tokenURI));
584         }
585         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
586         return string(abi.encodePacked(_baseURI, tokenId.toString()));
587     }
588 
589      /**
590      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
591      *
592      * Requirements:
593      *
594      * - `tokenId` must exist.
595      */
596     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
597         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
598         _tokenURIs[tokenId] = _tokenURI;
599     }
600 
601     /**
602      * @dev Internal function to set the base URI for all token IDs. It is
603      * automatically added as a prefix to the value returned in {tokenURI},
604      * or to the token ID if {tokenURI} is empty.
605      */
606     function _setBaseURI(string memory baseURI_) internal virtual {
607         _baseURI = baseURI_;
608     }
609 
610      /**
611     * @dev Returns the base URI set via {_setBaseURI}. This will be
612     * automatically added as a prefix in {tokenURI} to each token's URI, or
613     * to the token ID if no specific URI is set for that token ID.
614     */
615     function baseURI() internal view returns (string memory) {
616         return _baseURI;
617     }
618 
619     /**
620      * @dev See {IERC721-approve}.
621      */
622     function approve(address to, uint256 tokenId) public virtual override {
623         address owner = ERC721.ownerOf(tokenId);
624         require(to != owner, "ERC721: approval to current owner");
625 
626         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
627             "ERC721: approve caller is not owner nor approved for all"
628         );
629 
630         _approve(to, tokenId);
631     }
632 
633     /**
634      * @dev See {IERC721-getApproved}.
635      */
636     function getApproved(uint256 tokenId) public view virtual override returns (address) {
637         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
638 
639         return _tokenApprovals[tokenId];
640     }
641 
642     /**
643      * @dev See {IERC721-setApprovalForAll}.
644      */
645     function setApprovalForAll(address operator, bool approved) public virtual override {
646         require(operator != _msgSender(), "ERC721: approve to caller");
647 
648         _operatorApprovals[_msgSender()][operator] = approved;
649         emit ApprovalForAll(_msgSender(), operator, approved);
650     }
651 
652     /**
653      * @dev See {IERC721-isApprovedForAll}.
654      */
655     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
656         return _operatorApprovals[owner][operator];
657     }
658 
659     /**
660      * @dev See {IERC721-transferFrom}.
661      */
662     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
663         //solhint-disable-next-line max-line-length
664         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
665 
666         _transfer(from, to, tokenId);
667     }
668 
669     /**
670      * @dev See {IERC721-safeTransferFrom}.
671      */
672     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
673         safeTransferFrom(from, to, tokenId, "");
674     }
675 
676     /**
677      * @dev See {IERC721-safeTransferFrom}.
678      */
679     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
680         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
681         _safeTransfer(from, to, tokenId, _data);
682     }
683 
684     /**
685      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
686      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
687      *
688      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
689      *
690      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
691      * implement alternative mechanisms to perform token transfer, such as signature-based.
692      *
693      * Requirements:
694      *
695      * - `from` cannot be the zero address.
696      * - `to` cannot be the zero address.
697      * - `tokenId` token must exist and be owned by `from`.
698      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
699      *
700      * Emits a {Transfer} event.
701      */
702     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
703         _transfer(from, to, tokenId);
704         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
705     }
706 
707     /**
708      * @dev Returns whether `tokenId` exists.
709      *
710      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
711      *
712      * Tokens start existing when they are minted (`_mint`),
713      * and stop existing when they are burned (`_burn`).
714      */
715     function _exists(uint256 tokenId) internal view virtual returns (bool) {
716         return _owners[tokenId] != address(0);
717     }
718 
719     /**
720      * @dev Returns whether `spender` is allowed to manage `tokenId`.
721      *
722      * Requirements:
723      *
724      * - `tokenId` must exist.
725      */
726     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
727         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
728         address owner = ERC721.ownerOf(tokenId);
729         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
730     }
731 
732     /**
733      * @dev Safely mints `tokenId` and transfers it to `to`.
734      *
735      * Requirements:
736      *
737      * - `tokenId` must not exist.
738      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
739      *
740      * Emits a {Transfer} event.
741      */
742     function _safeMint(address to, uint256 tokenId) internal virtual {
743         _safeMint(to, tokenId, "");
744     }
745 
746     /**
747      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
748      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
749      */
750     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
751         _mint(to, tokenId);
752         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
753     }
754 
755     /**
756      * @dev Mints `tokenId` and transfers it to `to`.
757      *
758      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
759      *
760      * Requirements:
761      *
762      * - `tokenId` must not exist.
763      * - `to` cannot be the zero address.
764      *
765      * Emits a {Transfer} event.
766      */
767     function _mint(address to, uint256 tokenId) internal virtual {
768         require(to != address(0), "ERC721: mint to the zero address");
769         require(!_exists(tokenId), "ERC721: token already minted");
770 
771         _beforeTokenTransfer(address(0), to, tokenId);
772 
773         _balances[to] += 1;
774         _owners[tokenId] = to;
775 
776         emit Transfer(address(0), to, tokenId);
777     }
778 
779     /**
780      * @dev Destroys `tokenId`.
781      * The approval is cleared when the token is burned.
782      *
783      * Requirements:
784      *
785      * - `tokenId` must exist.
786      *
787      * Emits a {Transfer} event.
788      */
789     function _burn(uint256 tokenId) internal virtual {
790         address owner = ERC721.ownerOf(tokenId);
791 
792         _beforeTokenTransfer(owner, address(0), tokenId);
793 
794         // Clear approvals
795         _approve(address(0), tokenId);
796         // Clear metadata (if any)
797 
798         if (bytes(_tokenURIs[tokenId]).length != 0) {
799             delete _tokenURIs[tokenId];
800         }
801         _balances[owner] -= 1;
802         delete _owners[tokenId];
803 
804         emit Transfer(owner, address(0), tokenId);
805     }
806 
807     /**
808      * @dev Transfers `tokenId` from `from` to `to`.
809      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
810      *
811      * Requirements:
812      *
813      * - `to` cannot be the zero address.
814      * - `tokenId` token must be owned by `from`.
815      *
816      * Emits a {Transfer} event.
817      */
818     function _transfer(address from, address to, uint256 tokenId) internal virtual {
819         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
820         require(to != address(0), "ERC721: transfer to the zero address");
821 
822         _beforeTokenTransfer(from, to, tokenId);
823 
824         // Clear approvals from the previous owner
825         _approve(address(0), tokenId);
826 
827         _balances[from] -= 1;
828         _balances[to] += 1;
829         _owners[tokenId] = to;
830 
831         emit Transfer(from, to, tokenId);
832     }
833 
834     /**
835      * @dev Approve `to` to operate on `tokenId`
836      *
837      * Emits a {Approval} event.
838      */
839     function _approve(address to, uint256 tokenId) internal virtual {
840         _tokenApprovals[tokenId] = to;
841         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
842     }
843 
844     /**
845      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
846      * The call is not executed if the target address is not a contract.
847      *
848      * @param from address representing the previous owner of the given token ID
849      * @param to target address that will receive the tokens
850      * @param tokenId uint256 ID of the token to be transferred
851      * @param _data bytes optional data to send along with the call
852      * @return bool whether the call correctly returned the expected magic value
853      */
854     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
855         private returns (bool)
856     {
857         if (to.isContract()) {
858             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
859                 return retval == IERC721Receiver(to).onERC721Received.selector;
860             } catch (bytes memory reason) {
861                 if (reason.length == 0) {
862                     revert("ERC721: transfer to non ERC721Receiver implementer");
863                 } else {
864                     // solhint-disable-next-line no-inline-assembly
865                     assembly {
866                         revert(add(32, reason), mload(reason))
867                     }
868                 }
869             }
870         } else {
871             return true;
872         }
873     }
874 
875     /**
876      * @dev Hook that is called before any token transfer. This includes minting
877      * and burning.
878      *
879      * Calling conditions:
880      *
881      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
882      * transferred to `to`.
883      * - When `from` is zero, `tokenId` will be minted for `to`.
884      * - When `to` is zero, ``from``'s `tokenId` will be burned.
885      * - `from` cannot be the zero address.
886      * - `to` cannot be the zero address.
887      *
888      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
889      */
890     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
891 }
892 
893 
894 /**
895  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
896  * enumerability of all the token ids in the contract as well as all token ids owned by each
897  * account.
898  */
899 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
900     // Mapping from owner to list of owned token IDs
901     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
902 
903     // Mapping from token ID to index of the owner tokens list
904     mapping(uint256 => uint256) private _ownedTokensIndex;
905 
906     // Array with all token ids, used for enumeration
907     uint256[] private _allTokens;
908 
909     // Mapping from token id to position in the allTokens array
910     mapping(uint256 => uint256) private _allTokensIndex;
911 
912     /**
913      * @dev See {IERC165-supportsInterface}.
914      */
915     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
916         return interfaceId == type(IERC721Enumerable).interfaceId
917             || super.supportsInterface(interfaceId);
918     }
919 
920     /**
921      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
922      */
923     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
924         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
925         return _ownedTokens[owner][index];
926     }
927 
928     /**
929      * @dev See {IERC721Enumerable-totalSupply}.
930      */
931     function totalSupply() public view virtual override returns (uint256) {
932         return _allTokens.length;
933     }
934 
935     /**
936      * @dev See {IERC721Enumerable-tokenByIndex}.
937      */
938     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
939         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
940         return _allTokens[index];
941     }
942 
943     /**
944      * @dev Hook that is called before any token transfer. This includes minting
945      * and burning.
946      *
947      * Calling conditions:
948      *
949      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
950      * transferred to `to`.
951      * - When `from` is zero, `tokenId` will be minted for `to`.
952      * - When `to` is zero, ``from``'s `tokenId` will be burned.
953      * - `from` cannot be the zero address.
954      * - `to` cannot be the zero address.
955      *
956      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
957      */
958     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
959         super._beforeTokenTransfer(from, to, tokenId);
960 
961         if (from == address(0)) {
962             _addTokenToAllTokensEnumeration(tokenId);
963         } else if (from != to) {
964             _removeTokenFromOwnerEnumeration(from, tokenId);
965         }
966         if (to == address(0)) {
967             _removeTokenFromAllTokensEnumeration(tokenId);
968         } else if (to != from) {
969             _addTokenToOwnerEnumeration(to, tokenId);
970         }
971     }
972 
973     /**
974      * @dev Private function to add a token to this extension's ownership-tracking data structures.
975      * @param to address representing the new owner of the given token ID
976      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
977      */
978     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
979         uint256 length = ERC721.balanceOf(to);
980         _ownedTokens[to][length] = tokenId;
981         _ownedTokensIndex[tokenId] = length;
982     }
983 
984     /**
985      * @dev Private function to add a token to this extension's token tracking data structures.
986      * @param tokenId uint256 ID of the token to be added to the tokens list
987      */
988     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
989         _allTokensIndex[tokenId] = _allTokens.length;
990         _allTokens.push(tokenId);
991     }
992 
993     /**
994      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
995      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
996      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
997      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
998      * @param from address representing the previous owner of the given token ID
999      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1000      */
1001     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1002         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1003         // then delete the last slot (swap and pop).
1004 
1005         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1006         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1007 
1008         // When the token to delete is the last token, the swap operation is unnecessary
1009         if (tokenIndex != lastTokenIndex) {
1010             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1011 
1012             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1013             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1014         }
1015 
1016         // This also deletes the contents at the last position of the array
1017         delete _ownedTokensIndex[tokenId];
1018         delete _ownedTokens[from][lastTokenIndex];
1019     }
1020 
1021     /**
1022      * @dev Private function to remove a token from this extension's token tracking data structures.
1023      * This has O(1) time complexity, but alters the order of the _allTokens array.
1024      * @param tokenId uint256 ID of the token to be removed from the tokens list
1025      */
1026     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1027         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1028         // then delete the last slot (swap and pop).
1029 
1030         uint256 lastTokenIndex = _allTokens.length - 1;
1031         uint256 tokenIndex = _allTokensIndex[tokenId];
1032 
1033         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1034         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1035         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1036         uint256 lastTokenId = _allTokens[lastTokenIndex];
1037 
1038         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1039         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1040 
1041         // This also deletes the contents at the last position of the array
1042         delete _allTokensIndex[tokenId];
1043         _allTokens.pop();
1044     }
1045 }
1046 
1047 contract RoswellNFT is ERC721Enumerable, Ownable, Pausable {
1048      
1049     constructor(string memory baseURI, string memory name, string memory symbol) ERC721(name, symbol) {
1050         _setBaseURI(baseURI);
1051     }
1052 
1053     bool private revealed = false;
1054 
1055     uint256 private maxSupply = 11111;
1056 
1057     uint256 private preSaleSupply = 2000;
1058 
1059     string private notRevealURI;
1060 
1061     uint256 private preSaleStartDate;
1062 
1063     uint256 private preSaleEndDate;
1064 
1065     uint256 private publicSaleDate;
1066 
1067     uint256 private publicSaleEndDate;
1068 
1069     uint256 private preSalePrice; 
1070 
1071     uint256 private publicSalePrice;
1072 
1073     mapping(address => uint256) private ownedToken;
1074 
1075     mapping(address => bool) private whitelistUsers;
1076 
1077     event PreSaleMint(address user, uint256 count, uint256 amount, uint256 time);
1078     event PublicSaleMint(address user, uint256 count, uint256 time);
1079     event Mint(address user, uint256 tokenId);
1080 
1081     function pause() public onlyOwner {
1082         _pause();
1083     }
1084 
1085     function unpause() public onlyOwner {
1086         _unpause();
1087     }
1088 
1089     function preSaleMint(address _to) public payable whenNotPaused{
1090         require(preSaleStartDate <= block.timestamp && preSaleEndDate > block.timestamp, "Presale ended or not started yet");
1091         require(isWhitelisted(_to), "User is not whitelisted");     
1092         require(totalSupply() <= preSaleSupply, "Supply limit reached!");            
1093         require(ownedToken[_to] == 0, "You can't pre-buy more tokens");           
1094         _safeMint(_to, totalSupply() + 1);       
1095         ownedToken[_to]++;
1096         emit PreSaleMint(_to, 1, msg.value, block.timestamp);
1097     }
1098 
1099     function publicSaleMint(address _to ,uint256 _mintAmount) public onlyOwner{
1100         uint256 supply = totalSupply();
1101         require(supply + _mintAmount <= maxSupply, "Supply limit reached!");       
1102         for (uint256 i = 1; i <= _mintAmount; i++) {
1103             _safeMint(_to, supply + i);
1104         }
1105         emit PublicSaleMint(_to, _mintAmount, block.timestamp);
1106     }
1107 
1108     function adminMint(address _to ,uint256 _tokenId) public onlyOwner{      
1109         _safeMint(_to, _tokenId);  
1110         emit Mint (_to, _tokenId);     
1111     }
1112 
1113     function setNotRevealedURI(string memory _newURI) public onlyOwner {
1114         notRevealURI = _newURI;
1115     }
1116     
1117     function setBaseURI(string memory _baseURI) public onlyOwner {
1118         _setBaseURI(_baseURI);
1119     }  
1120 
1121     function setPresalePrice(uint256 _newPrice) public onlyOwner {
1122         preSalePrice = _newPrice;
1123     }
1124 
1125     function setPublicSalePrice(uint256 _newPrice) public onlyOwner {
1126         publicSalePrice = _newPrice;
1127     }
1128   
1129     function setPresaleStartTime(uint256 _time) public onlyOwner {
1130         preSaleStartDate = _time;
1131     }
1132 
1133     function setPresaleEndTime(uint256 _time) public onlyOwner {
1134         preSaleEndDate = _time;
1135     }
1136 
1137     function setPublicSaleTime(uint256 _time) public onlyOwner {
1138         publicSaleDate = _time;
1139     }
1140 
1141     function setPublicSaleEndTime(uint256 _time) public onlyOwner {
1142         publicSaleEndDate = _time;
1143     }
1144 
1145     function whitelist(address _account) public onlyOwner {        
1146         whitelistUsers[_account] = true;
1147     }
1148 
1149     function burn(uint256 _tokenId) public {
1150         //solhint-disable-next-line max-line-length
1151         require(_isApprovedOrOwner(_msgSender(), _tokenId), "ERC721Burnable: caller is not owner nor approved");
1152         _burn(_tokenId);        
1153     }
1154 
1155     function removeWhitelistedUsers(address _account) public onlyOwner {      
1156         whitelistUsers[_account] = false;
1157     }
1158 
1159     function getPreSalePrice() public view returns (uint256) {
1160         return preSalePrice;
1161     }
1162 
1163     function getPublicSalePrice() public view returns (uint256) {
1164         return publicSalePrice;
1165     }
1166 
1167     function getPreSaleStartTime() public view returns (uint256) {
1168         return preSaleStartDate;
1169     }
1170 
1171     function getPreSaleEndTime() public view returns (uint256) {
1172         return preSaleEndDate;
1173     }
1174 
1175     function getPublicSaleTime() public view returns (uint256) {
1176         return publicSaleDate;
1177     }
1178 
1179     function getPublicSaleEndTime() public view returns (uint256) {
1180         return publicSaleEndDate;
1181     }
1182 
1183     function getNotRevealedURI() public view returns (string memory) {
1184         return notRevealURI;
1185     }
1186 
1187     function tokenOwner(address _user) public view returns (uint256[] memory)
1188     {
1189         uint256 ownerTokenCount = balanceOf(_user);
1190         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1191         for (uint256 i; i < ownerTokenCount; i++) {
1192             tokenIds[i] = tokenOfOwnerByIndex(_user, i);
1193         }
1194         return tokenIds;
1195     }
1196 
1197     function isWhitelisted(address _user) public view returns (bool) {
1198        return whitelistUsers[_user];
1199     }
1200 
1201     function tokenURI(uint256 _tokenId) public view  override returns (string memory)
1202     {
1203         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1204         if(revealed == false) {
1205             return notRevealURI;
1206         }else {
1207             return super.tokenURI(_tokenId);
1208         }
1209     }
1210 
1211     function getReveal() public view returns (bool){
1212         return revealed;
1213     }
1214 
1215     function reveal() public onlyOwner {
1216         require (revealed == false, "NFTs already revealed");
1217         revealed = true;
1218     }
1219 
1220     function unReveal() public onlyOwner {
1221         require (revealed == true, "NFTs already UNrevealed");
1222         revealed = false;
1223     }
1224 
1225     function getOwnerToken(address _user) public view returns (uint256){
1226         return ownedToken[_user];
1227     }
1228 
1229     function withdraw() public onlyOwner {
1230         payable(owner()).transfer(address(this).balance);
1231     }
1232 }