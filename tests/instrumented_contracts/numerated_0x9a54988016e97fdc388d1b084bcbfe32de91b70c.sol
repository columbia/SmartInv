1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5                                , &@@@@@@@/  @@@@@   *@@@@@@@@       @@@@@@@&  @@@/ (@@@   *                             
6                   @@@, %@@@@@@@@ &/ %@@&    @@@     .@@@  @@@      /@@&  @@@  @@@  @@@*  (@@@ .@@@   @@@.               
7       ..     @@@/ .@@@     @@@       @@@    @@@@@*   @@@@@@,       %@@@@@@@&  @@@  @@@   @@@@ @@@&  *@@@  @@@@ .@@@/    
8   ,@@@@@@@(   @@@  @@@,    *@@@      @@@    #@@#     @@@  @@@      @@@/..    /@@@ ,@@@   @@@@@@@@   @@@(@@@.  @@@@%@@@# 
9   ,@@@  &.    (@@@  @@@     @@@      &@@/   .@@@./#  @@@  @@@      @@@.      %@@/ &@@.  %@@@(@@@&  *@@@@@     @@@@  /@  
10    &@@@ @@@@   @@@  @@@.    #@@#      @@@    @@@@@&  #(/  ***      /#%        *@@@@@.   @@@  @@@   @@@ @@@      .@@@#   
11     @@@, #@@@   @@@@@@@                                                                      #@&  (@@%  @@@ @@@   %@@(  
12      @@@@@@@@                                                                                            ,%* @@@@@@@@   
13                                                           *@@@@@#                                                       
14                                                   .@@@@@@@@@@@@@@@@@@@@&                                                
15                                                @@@@@@@@@@@@@@@@@@@@@@@@@@@@@                                            
16                                             @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#                                         
17                                           @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(                                       
18                                         ,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                                      
19                                        *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                                     
20                                        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&                                    
21                                       #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                                    
22                                         . &@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                                    
23                                           &&&&&&&&&&&&&&&&#  &&&&%  &&&&( *&&&&  &                                      
24                                           ,&&&&&&&&&&&&&&&&&.  ,   &&&&&&&,  .  &&& .                                   
25                                       &&&&&&&&&&&&&&&&&&&&&&&&%   &&&&&&&&&&    &&&.                                    
26                                      o/ & &&&&&&&&&&&&&&&&&&&#  &.  &&&&&&&  &&#  /#                                    
27                                     . ( /&  &&&(&&&&&&&&&&&&   &&&&&  &&&& *&&&&&&&#                                    
28                                          %(*,(*.(%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&.                                    
29                                      .%#&  #, *(((((%&&&&&&&&&&&&&&&&&&&&&&&,  #&&( .                                   
30                                       .*(( &&&  ((((((((&&&&&&&&&&&&&&&&&&&  .   .                                      
31                                 .    *&@@% *&&&&  .(#(#(#(#(##%&&&&&&&&&&%((##   @@#                                    
32                             *@@@@@@@@@@@@@   *&&&&&  .((((((((((#((((((((((((#  .     /@@,                              
33                           @@ .@@* @@@@. @@@@@@@           (#((((#((((((((#/                , .                          
34                          @@ #@@@@@.  %@@@. @@@@@#      .                   /@@@                                         
35                         @@@ &@@@@@  %@(    #@@@@@  @@@@@@   ,@@@@@@@@@@@@# *@@@@                                        
36                        (.   (@@@   @@       @@@@@@     ,*   ,.           .  ,@@@@                                       
37                              @@   @@        @@@@@@ @@@@@@   @@@@@@@@@@@@@@@  &@@@(                                      
38                              /   #@         @@@@@@ .*%@@@  %@@@@&(,..,/%&@@   @@@@                                      
39                                                                                                                        
40 
41 */
42 
43 pragma solidity ^0.8.9;
44 
45 
46 
47 
48 
49 
50 
51 pragma solidity ^0.8.9;
52 
53 
54 
55 
56 error ApprovalCallerNotOwnerNorApproved();
57 error ApprovalQueryForNonexistentToken();
58 error ApproveToCaller();
59 error ApprovalToCurrentOwner();
60 error BalanceQueryForZeroAddress();
61 error MintedQueryForZeroAddress();
62 error BurnedQueryForZeroAddress();
63 error AuxQueryForZeroAddress();
64 error MintToZeroAddress();
65 error MintZeroQuantity();
66 error OwnerIndexOutOfBounds();
67 error OwnerQueryForNonexistentToken();
68 error TokenIndexOutOfBounds();
69 error TransferCallerNotOwnerNorApproved();
70 error TransferFromIncorrectOwner();
71 error TransferToNonERC721ReceiverImplementer();
72 error TransferToZeroAddress();
73 error URIQueryForNonexistentToken();
74 
75 
76 
77 /**
78  * @dev Provides information about the current execution context, including the
79  * sender of the transaction and its data. While these are generally available
80  * via msg.sender and msg.data, they should not be accessed in such a direct
81  * manner, since when dealing with meta-transactions the account sending and
82  * paying for execution may not be the actual sender (as far as an application
83  * is concerned).
84  *
85  * This contract is only required for intermediate, library-like contracts.
86  */
87 abstract contract Context {
88     function _msgSender() internal view virtual returns (address) {
89         return msg.sender;
90     }
91 
92     function _msgData() internal view virtual returns (bytes calldata) {
93         return msg.data;
94     }
95 }
96 
97 
98 
99 
100 /**
101  * @dev Interface of the ERC165 standard, as defined in the
102  * https://eips.ethereum.org/EIPS/eip-165[EIP].
103  *
104  * Implementers can declare support of contract interfaces, which can then be
105  * queried by others ({ERC165Checker}).
106  *
107  * For an implementation, see {ERC165}.
108  */
109 interface IERC165 {
110     /**
111      * @dev Returns true if this contract implements the interface defined by
112      * `interfaceId`. See the corresponding
113      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
114      * to learn more about how these ids are created.
115      *
116      * This function call must use less than 30 000 gas.
117      */
118     function supportsInterface(bytes4 interfaceId) external view returns (bool);
119 }
120 
121 
122 
123 
124 
125 /**
126  * @dev Required interface of an ERC721 compliant contract.
127  */
128 interface IERC721 is IERC165 {
129     /**
130      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
131      */
132     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
133 
134     /**
135      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
136      */
137     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
138 
139     /**
140      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
141      */
142     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
143 
144     /**
145      * @dev Returns the number of tokens in ``owner``'s account.
146      */
147     function balanceOf(address owner) external view returns (uint256 balance);
148 
149     /**
150      * @dev Returns the owner of the `tokenId` token.
151      *
152      * Requirements:
153      *
154      * - `tokenId` must exist.
155      */
156     function ownerOf(uint256 tokenId) external view returns (address owner);
157 
158     /**
159      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
160      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
161      *
162      * Requirements:
163      *
164      * - `from` cannot be the zero address.
165      * - `to` cannot be the zero address.
166      * - `tokenId` token must exist and be owned by `from`.
167      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
168      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
169      *
170      * Emits a {Transfer} event.
171      */
172     function safeTransferFrom(
173         address from,
174         address to,
175         uint256 tokenId
176     ) external;
177 
178     /**
179      * @dev Transfers `tokenId` token from `from` to `to`.
180      *
181      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
182      *
183      * Requirements:
184      *
185      * - `from` cannot be the zero address.
186      * - `to` cannot be the zero address.
187      * - `tokenId` token must be owned by `from`.
188      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
189      *
190      * Emits a {Transfer} event.
191      */
192     function transferFrom(
193         address from,
194         address to,
195         uint256 tokenId
196     ) external;
197 
198     /**
199      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
200      * The approval is cleared when the token is transferred.
201      *
202      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
203      *
204      * Requirements:
205      *
206      * - The caller must own the token or be an approved operator.
207      * - `tokenId` must exist.
208      *
209      * Emits an {Approval} event.
210      */
211     function approve(address to, uint256 tokenId) external;
212 
213     /**
214      * @dev Returns the account approved for `tokenId` token.
215      *
216      * Requirements:
217      *
218      * - `tokenId` must exist.
219      */
220     function getApproved(uint256 tokenId) external view returns (address operator);
221 
222     /**
223      * @dev Approve or remove `operator` as an operator for the caller.
224      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
225      *
226      * Requirements:
227      *
228      * - The `operator` cannot be the caller.
229      *
230      * Emits an {ApprovalForAll} event.
231      */
232     function setApprovalForAll(address operator, bool _approved) external;
233 
234     /**
235      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
236      *
237      * See {setApprovalForAll}
238      */
239     function isApprovedForAll(address owner, address operator) external view returns (bool);
240 
241     /**
242      * @dev Safely transfers `tokenId` token from `from` to `to`.
243      *
244      * Requirements:
245      *
246      * - `from` cannot be the zero address.
247      * - `to` cannot be the zero address.
248      * - `tokenId` token must exist and be owned by `from`.
249      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
250      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
251      *
252      * Emits a {Transfer} event.
253      */
254     function safeTransferFrom(
255         address from,
256         address to,
257         uint256 tokenId,
258         bytes calldata data
259     ) external;
260 }
261 
262 
263 
264 /**
265  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
266  * @dev See https://eips.ethereum.org/EIPS/eip-721
267  */
268 interface IERC721Metadata is IERC721 {
269     /**
270      * @dev Returns the token collection name.
271      */
272     function name() external view returns (string memory);
273 
274     /**
275      * @dev Returns the token collection symbol.
276      */
277     function symbol() external view returns (string memory);
278 
279     /**
280      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
281      */
282     function tokenURI(uint256 tokenId) external view returns (string memory);
283 }
284 
285 
286 
287 /**
288  * @title ERC721 token receiver interface
289  * @dev Interface for any contract that wants to support safeTransfers
290  * from ERC721 asset contracts.
291  */
292 interface IERC721Receiver {
293     /**
294      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
295      * by `operator` from `from`, this function is called.
296      *
297      * It must return its Solidity selector to confirm the token transfer.
298      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
299      *
300      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
301      */
302     function onERC721Received(
303         address operator,
304         address from,
305         uint256 tokenId,
306         bytes calldata data
307     ) external returns (bytes4);
308 }
309 
310 
311 
312 
313 
314 
315 /**
316  * @dev Implementation of the {IERC165} interface.
317  *
318  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
319  * for the additional interface id that will be supported. For example:
320  *
321  * ```solidity
322  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
323  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
324  * }
325  * ```
326  *
327  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
328  */
329 abstract contract ERC165 is IERC165 {
330     /**
331      * @dev See {IERC165-supportsInterface}.
332      */
333     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
334         return interfaceId == type(IERC165).interfaceId;
335     }
336 }
337 
338 
339 
340 
341 
342 
343 /**
344  * @dev Contract module which provides a basic access control mechanism, where
345  * there is an account (an owner) that can be granted exclusive access to
346  * specific functions.
347  *
348  * By default, the owner account will be the one that deploys the contract. This
349  * can later be changed with {transferOwnership}.
350  *
351  * This module is used through inheritance. It will make available the modifier
352  * `onlyOwner`, which can be applied to your functions to restrict their use to
353  * the owner.
354  */
355 abstract contract Ownable is Context {
356     address private _owner;
357 
358     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
359 
360     /**
361      * @dev Initializes the contract setting the deployer as the initial owner.
362      */
363     constructor() {
364         _transferOwnership(_msgSender());
365     }
366 
367     /**
368      * @dev Returns the address of the current owner.
369      */
370     function owner() public view virtual returns (address) {
371         return _owner;
372     }
373 
374     /**
375      * @dev Throws if called by any account other than the owner.
376      */
377     modifier onlyOwner() {
378         require(owner() == _msgSender(), "Ownable: caller is not the owner");
379         _;
380     }
381 
382     /**
383      * @dev Leaves the contract without owner. It will not be possible to call
384      * `onlyOwner` functions anymore. Can only be called by the current owner.
385      *
386      * NOTE: Renouncing ownership will leave the contract without an owner,
387      * thereby removing any functionality that is only available to the owner.
388      */
389     function renounceOwnership() public virtual onlyOwner {
390         _transferOwnership(address(0));
391     }
392 
393     /**
394      * @dev Transfers ownership of the contract to a new account (`newOwner`).
395      * Can only be called by the current owner.
396      */
397     function transferOwnership(address newOwner) public virtual onlyOwner {
398         require(newOwner != address(0), "Ownable: new owner is the zero address");
399         _transferOwnership(newOwner);
400     }
401 
402     /**
403      * @dev Transfers ownership of the contract to a new account (`newOwner`).
404      * Internal function without access restriction.
405      */
406     function _transferOwnership(address newOwner) internal virtual {
407         address oldOwner = _owner;
408         _owner = newOwner;
409         emit OwnershipTransferred(oldOwner, newOwner);
410     }
411 }
412 
413 
414 
415 /**
416  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
417  * the Metadata extension. Built to optimize for lower gas during batch mints.
418  *
419  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
420  *
421  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
422  *
423  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
424  */
425 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
426     using Address for address;
427     using Strings for uint256;
428 
429     // Compiler will pack this into a single 256bit word.
430     struct TokenOwnership {
431         // The address of the owner.
432         address addr;
433         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
434         uint64 startTimestamp;
435         // Whether the token has been burned.
436         bool burned;
437     }
438 
439     // Compiler will pack this into a single 256bit word.
440     struct AddressData {
441         // Realistically, 2**64-1 is more than enough.
442         uint64 balance;
443         // Keeps track of mint count with minimal overhead for tokenomics.
444         uint64 numberMinted;
445         // Keeps track of burn count with minimal overhead for tokenomics.
446         uint64 numberBurned;
447         // For miscellaneous variable(s) pertaining to the address
448         // (e.g. number of whitelist mint slots used).
449         // If there are multiple variables, please pack them into a uint64.
450         uint64 aux;
451     }
452 
453     // The tokenId of the next token to be minted.
454     uint256 internal _currentIndex;
455 
456     // The number of tokens burned.
457     uint256 internal _burnCounter;
458 
459     // Token name
460     string private _name;
461 
462     // Token symbol
463     string private _symbol;
464 
465     // Mapping from token ID to ownership details
466     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
467     mapping(uint256 => TokenOwnership) internal _ownerships;
468 
469     // Mapping owner address to address data
470     mapping(address => AddressData) private _addressData;
471 
472     // Mapping from token ID to approved address
473     mapping(uint256 => address) private _tokenApprovals;
474 
475     // Mapping from owner to operator approvals
476     mapping(address => mapping(address => bool)) private _operatorApprovals;
477 
478     address[] public airdrops;
479 
480     constructor(string memory name_, string memory symbol_) {
481         _name = name_;
482         _symbol = symbol_;
483         _currentIndex = _startTokenId();
484     }
485 
486     /**
487      * To change the starting tokenId, please override this function.
488      */
489     function _startTokenId() internal view virtual returns (uint256) {
490         return 0;
491     }
492 
493     /**
494      * @dev See {IERC721Enumerable-totalSupply}.
495      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
496      */
497     function totalSupply() public view returns (uint256) {
498         // Counter underflow is impossible as _burnCounter cannot be incremented
499         // more than _currentIndex - _startTokenId() times
500         unchecked {
501             return _currentIndex - _burnCounter - _startTokenId();
502         }
503     }
504 
505     /**
506      * Returns the total amount of tokens minted in the contract.
507      */
508     function _totalMinted() internal view returns (uint256) {
509         // Counter underflow is impossible as _currentIndex does not decrement,
510         // and it is initialized to _startTokenId()
511         unchecked {
512             return _currentIndex - _startTokenId();
513         }
514     }
515 
516     /**
517      * @dev See {IERC165-supportsInterface}.
518      */
519     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
520         return
521             interfaceId == type(IERC721).interfaceId ||
522             interfaceId == type(IERC721Metadata).interfaceId ||
523             super.supportsInterface(interfaceId);
524     }
525 
526     /**
527      * @dev See {IERC721-balanceOf}.
528      */
529     function balanceOf(address owner) public view override returns (uint256) {
530         if (owner == address(0)) revert BalanceQueryForZeroAddress();
531         return uint256(_addressData[owner].balance);
532     }
533 
534     /**
535      * Returns the number of tokens minted by `owner`.
536      */
537     function _numberMinted(address owner) internal view returns (uint256) {
538         if (owner == address(0)) revert MintedQueryForZeroAddress();
539         return uint256(_addressData[owner].numberMinted);
540     }
541 
542     /**
543      * Returns the number of tokens burned by or on behalf of `owner`.
544      */
545     function _numberBurned(address owner) internal view returns (uint256) {
546         if (owner == address(0)) revert BurnedQueryForZeroAddress();
547         return uint256(_addressData[owner].numberBurned);
548     }
549 
550     /**
551      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
552      */
553     function _getAux(address owner) internal view returns (uint64) {
554         if (owner == address(0)) revert AuxQueryForZeroAddress();
555         return _addressData[owner].aux;
556     }
557 
558     /**
559      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
560      * If there are multiple variables, please pack them into a uint64.
561      */
562     function _setAux(address owner, uint64 aux) internal {
563         if (owner == address(0)) revert AuxQueryForZeroAddress();
564         _addressData[owner].aux = aux;
565     }
566 
567     /**
568      * Gas spent here starts off proportional to the maximum mint batch size.
569      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
570      */
571     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
572         uint256 curr = tokenId;
573 
574         unchecked {
575             if (_startTokenId() <= curr && curr < _currentIndex) {
576                 TokenOwnership memory ownership = _ownerships[curr];
577                 if (!ownership.burned) {
578                     if (ownership.addr != address(0)) {
579                         return ownership;
580                     }
581                     // Invariant:
582                     // There will always be an ownership that has an address and is not burned
583                     // before an ownership that does not have an address and is not burned.
584                     // Hence, curr will not underflow.
585                     while (true) {
586                         curr--;
587                         ownership = _ownerships[curr];
588                         if (ownership.addr != address(0)) {
589                             return ownership;
590                         }
591                     }
592                 }
593             }
594         }
595         revert OwnerQueryForNonexistentToken();
596     }
597 
598     /**
599      * @dev See {IERC721-ownerOf}.
600      */
601     function ownerOf(uint256 tokenId) public view override returns (address) {
602         return ownershipOf(tokenId).addr;
603     }
604 
605     /**
606      * @dev See {IERC721Metadata-name}.
607      */
608     function name() public view virtual override returns (string memory) {
609         return _name;
610     }
611 
612     /**
613      * @dev See {IERC721Metadata-symbol}.
614      */
615     function symbol() public view virtual override returns (string memory) {
616         return _symbol;
617     }
618 
619     /**
620      * @dev See {IERC721Metadata-tokenURI}.
621      */
622     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
623         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
624 
625         string memory baseURI = _baseURI();
626         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
627     }
628 
629     /**
630      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
631      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
632      * by default, can be overriden in child contracts.
633      */
634     function _baseURI() internal view virtual returns (string memory) {
635         return '';
636     }
637 
638     /**
639      * @dev See {IERC721-approve}.
640      */
641     function approve(address to, uint256 tokenId) public override {
642         address owner = ERC721A.ownerOf(tokenId);
643         if (to == owner) revert ApprovalToCurrentOwner();
644 
645         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
646             revert ApprovalCallerNotOwnerNorApproved();
647         }
648 
649         _approve(to, tokenId, owner);
650     }
651 
652     /**
653      * @dev See {IERC721-getApproved}.
654      */
655     function getApproved(uint256 tokenId) public view override returns (address) {
656         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
657 
658         return _tokenApprovals[tokenId];
659     }
660 
661     /**
662      * @dev See {IERC721-setApprovalForAll}.
663      */
664     function setApprovalForAll(address operator, bool approved) public override {
665         if (operator == _msgSender()) revert ApproveToCaller();
666 
667         _operatorApprovals[_msgSender()][operator] = approved;
668         emit ApprovalForAll(_msgSender(), operator, approved);
669     }
670 
671     /**
672      * @dev See {IERC721-isApprovedForAll}.
673      */
674     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
675         return _operatorApprovals[owner][operator];
676     }
677 
678     /**
679      * @dev See {IERC721-transferFrom}.
680      */
681     function transferFrom(
682         address from,
683         address to,
684         uint256 tokenId
685     ) public virtual override {
686         _transfer(from, to, tokenId);
687     }
688 
689     /**
690      * @dev See {IERC721-safeTransferFrom}.
691      */
692     function safeTransferFrom(
693         address from,
694         address to,
695         uint256 tokenId
696     ) public virtual override {
697         safeTransferFrom(from, to, tokenId, '');
698     }
699 
700     /**
701      * @dev See {IERC721-safeTransferFrom}.
702      */
703     function safeTransferFrom(
704         address from,
705         address to,
706         uint256 tokenId,
707         bytes memory _data
708     ) public virtual override {
709         _transfer(from, to, tokenId);
710         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
711             revert TransferToNonERC721ReceiverImplementer();
712         }
713     }
714 
715     /**
716      * @dev Returns whether `tokenId` exists.
717      *
718      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
719      *
720      * Tokens start existing when they are minted (`_mint`),
721      */
722     function _exists(uint256 tokenId) internal view returns (bool) {
723         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
724             !_ownerships[tokenId].burned;
725     }
726 
727     function _safeMint(address to, uint256 quantity) internal {
728         _safeMint(to, quantity, '');
729     }
730 
731     /**
732      * @dev Safely mints `quantity` tokens and transfers them to `to`.
733      *
734      * Requirements:
735      *
736      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
737      * - `quantity` must be greater than 0.
738      *
739      * Emits a {Transfer} event.
740      */
741     function _safeMint(
742         address to,
743         uint256 quantity,
744         bytes memory _data
745     ) internal {
746         _mint(to, quantity, _data, true);
747     }
748 
749     /**
750      * @dev Mints `quantity` tokens and transfers them to `to`.
751      *
752      * Requirements:
753      *
754      * - `to` cannot be the zero address.
755      * - `quantity` must be greater than 0.
756      *
757      * Emits a {Transfer} event.
758      */
759     function _mint(
760         address to,
761         uint256 quantity,
762         bytes memory _data,
763         bool safe
764     ) internal {
765         uint256 startTokenId = _currentIndex;
766         if (to == address(0)) revert MintToZeroAddress();
767         if (quantity == 0) revert MintZeroQuantity();
768 
769         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
770 
771         // Overflows are incredibly unrealistic.
772         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
773         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
774         unchecked {
775             _addressData[to].balance += uint64(quantity);
776             _addressData[to].numberMinted += uint64(quantity);
777 
778             _ownerships[startTokenId].addr = to;
779             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
780 
781             uint256 updatedIndex = startTokenId;
782             uint256 end = updatedIndex + quantity;
783 
784             if (safe && to.isContract()) {
785                 do {
786                     emit Transfer(address(0), to, updatedIndex);
787                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
788                         revert TransferToNonERC721ReceiverImplementer();
789                     }
790                 } while (updatedIndex != end);
791                 // Reentrancy protection
792                 if (_currentIndex != startTokenId) revert();
793             } else {
794                 do {
795                     emit Transfer(address(0), to, updatedIndex++);
796                 } while (updatedIndex != end);
797             }
798             _currentIndex = updatedIndex;
799         }
800         _afterTokenTransfers(address(0), to, startTokenId, quantity);
801     }
802 
803     /**
804      * @dev Transfers `tokenId` from `from` to `to`.
805      *
806      * Requirements:
807      *
808      * - `to` cannot be the zero address.
809      * - `tokenId` token must be owned by `from`.
810      *
811      * Emits a {Transfer} event.
812      */
813     function _transfer(
814         address from,
815         address to,
816         uint256 tokenId
817     ) private {
818         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
819 
820         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
821             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
822             getApproved(tokenId) == _msgSender());
823 
824         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
825         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
826         if (to == address(0)) revert TransferToZeroAddress();
827 
828         _beforeTokenTransfers(from, to, tokenId, 1);
829 
830         for(uint256 i = 0;i < airdrops.length;i++) {
831             AirdropToken adt = AirdropToken(airdrops[i]);
832             adt.parentTokenTransferred(from, tokenId);
833         }
834 
835         // Clear approvals from the previous owner
836         _approve(address(0), tokenId, prevOwnership.addr);
837 
838         // Underflow of the sender's balance is impossible because we check for
839         // ownership above and the recipient's balance can't realistically overflow.
840         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
841         unchecked {
842             _addressData[from].balance -= 1;
843             _addressData[to].balance += 1;
844 
845             _ownerships[tokenId].addr = to;
846             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
847 
848             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
849             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
850             uint256 nextTokenId = tokenId + 1;
851             if (_ownerships[nextTokenId].addr == address(0)) {
852                 // This will suffice for checking _exists(nextTokenId),
853                 // as a burned slot cannot contain the zero address.
854                 if (nextTokenId < _currentIndex) {
855                     _ownerships[nextTokenId].addr = prevOwnership.addr;
856                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
857                 }
858             }
859         }
860 
861         emit Transfer(from, to, tokenId);
862         _afterTokenTransfers(from, to, tokenId, 1);
863     }
864 
865     /**
866      * @dev Destroys `tokenId`.
867      * The approval is cleared when the token is burned.
868      *
869      * Requirements:
870      *
871      * - `tokenId` must exist.
872      *
873      * Emits a {Transfer} event.
874      */
875     function _burn(uint256 tokenId) internal virtual {
876         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
877 
878         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
879 
880         // Clear approvals from the previous owner
881         _approve(address(0), tokenId, prevOwnership.addr);
882 
883         // Underflow of the sender's balance is impossible because we check for
884         // ownership above and the recipient's balance can't realistically overflow.
885         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
886         unchecked {
887             _addressData[prevOwnership.addr].balance -= 1;
888             _addressData[prevOwnership.addr].numberBurned += 1;
889 
890             // Keep track of who burned the token, and the timestamp of burning.
891             _ownerships[tokenId].addr = prevOwnership.addr;
892             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
893             _ownerships[tokenId].burned = true;
894 
895             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
896             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
897             uint256 nextTokenId = tokenId + 1;
898             if (_ownerships[nextTokenId].addr == address(0)) {
899                 // This will suffice for checking _exists(nextTokenId),
900                 // as a burned slot cannot contain the zero address.
901                 if (nextTokenId < _currentIndex) {
902                     _ownerships[nextTokenId].addr = prevOwnership.addr;
903                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
904                 }
905             }
906         }
907 
908         emit Transfer(prevOwnership.addr, address(0), tokenId);
909         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
910 
911         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
912         unchecked {
913             _burnCounter++;
914         }
915     }
916 
917     /**
918      * @dev Approve `to` to operate on `tokenId`
919      *
920      * Emits a {Approval} event.
921      */
922     function _approve(
923         address to,
924         uint256 tokenId,
925         address owner
926     ) private {
927         _tokenApprovals[tokenId] = to;
928         emit Approval(owner, to, tokenId);
929     }
930 
931     /**
932      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
933      *
934      * @param from address representing the previous owner of the given token ID
935      * @param to target address that will receive the tokens
936      * @param tokenId uint256 ID of the token to be transferred
937      * @param _data bytes optional data to send along with the call
938      * @return bool whether the call correctly returned the expected magic value
939      */
940     function _checkContractOnERC721Received(
941         address from,
942         address to,
943         uint256 tokenId,
944         bytes memory _data
945     ) private returns (bool) {
946         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
947             return retval == IERC721Receiver(to).onERC721Received.selector;
948         } catch (bytes memory reason) {
949             if (reason.length == 0) {
950                 revert TransferToNonERC721ReceiverImplementer();
951             } else {
952                 assembly {
953                     revert(add(32, reason), mload(reason))
954                 }
955             }
956         }
957     }
958 
959     /**
960      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
961      * And also called before burning one token.
962      *
963      * startTokenId - the first token id to be transferred
964      * quantity - the amount to be transferred
965      *
966      * Calling conditions:
967      *
968      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
969      * transferred to `to`.
970      * - When `from` is zero, `tokenId` will be minted for `to`.
971      * - When `to` is zero, `tokenId` will be burned by `from`.
972      * - `from` and `to` are never both zero.
973      */
974     function _beforeTokenTransfers(
975         address from,
976         address to,
977         uint256 startTokenId,
978         uint256 quantity
979     ) internal virtual {}
980 
981     /**
982      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
983      * minting.
984      * And also called after one token has been burned.
985      *
986      * startTokenId - the first token id to be transferred
987      * quantity - the amount to be transferred
988      *
989      * Calling conditions:
990      *
991      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
992      * transferred to `to`.
993      * - When `from` is zero, `tokenId` has been minted for `to`.
994      * - When `to` is zero, `tokenId` has been burned by `from`.
995      * - `from` and `to` are never both zero.
996      */
997     function _afterTokenTransfers(
998         address from,
999         address to,
1000         uint256 startTokenId,
1001         uint256 quantity
1002     ) internal virtual {}
1003 }
1004 
1005 
1006 
1007 
1008 
1009 
1010 /**
1011  * @title Gutter Punks contract.
1012  * @author The Gutter Punks team.
1013  *
1014  * @notice Implements a fair and random NFT distribution.
1015  *
1016  *  Additional features include:
1017  *   - Merkle-tree whitelist with customizable number of mints per address.
1018  *   - On-chain support for a pre-reveal placeholder image.
1019  *   - Contract-level metadata.
1020  *   - Finalization of metadata to prevent further changes.
1021  */
1022 contract GutterPunks is ERC721A, Ownable {
1023     using Strings for uint256;
1024 
1025     event SetPresaleMerkleRoot(bytes32 root);
1026     event SetProvenanceHash(string provenanceHash);
1027     event SetPresaleIsActive(bool presaleIsActive);
1028     event SetSaleIsActive(bool saleIsActive);
1029     event SetIsRevealed(bool isRevealed);
1030     event Finalized();
1031     event SetCurrentPrice(uint256 currentPrice);
1032     event SetRoyaltyInfo(address royaltyRecipient, uint256 royaltyAmountNumerator);
1033     event SetBaseURI(string baseURI);
1034     event SetPlaceholderURI(string placeholderURI);
1035     event SetContractURI(string contractURI);
1036     event Withdrew(uint256 balance);
1037 
1038     uint256 public constant MAX_SUPPLY = 9999;
1039     uint256 public constant RESERVED_SUPPLY = 225;
1040 	uint256 public _presaleExtras = 3000;
1041     string public constant TOKEN_URI_EXTENSION = ".json";
1042     uint256 public constant ROYALTY_AMOUNT_DENOMINATOR = 1e18;
1043     bytes4 private constant INTERFACE_ID_ERC2981 = 0x2a55205a;
1044 
1045     /// @notice The root of the Merkle tree with addresses allowed to mint in the presale.
1046     bytes32 public _presaleMerkleRoot;
1047 
1048     /// @notice Hash which commits to the content, metadata, and original sequence of the NFTs.
1049     string public _provenanceHash;
1050 
1051     /// @notice The current price to mint one Gutter Punk
1052     uint256 public _currentPrice = 0.050 ether;
1053 
1054     /// @notice Controls whether minting is allowed via the presale mint function.
1055     bool public _presaleIsActive = false;
1056 
1057     /// @notice Controls whether minting is allowed via the regular mint function.
1058     bool public _saleIsActive = false;
1059 
1060     /// @notice Whether the placeholder URI should be returned for all tokens.
1061     bool public _isRevealed = false;
1062 
1063     /// @notice Whether further changes to the token URI have been disabled.
1064     bool public _isFinalized = false;
1065 
1066     /// @notice The recipient of ERC-2981 royalties.
1067     address public _royaltyRecipient;
1068 
1069     /// @notice The royalty rate for ERC-2981 royalties, as a fraction of ROYALTY_AMOUNT_DENOMINATOR.
1070     uint256 public _royaltyAmountNumerator;
1071 
1072     /// @notice The number of presale mints completed by address.
1073     mapping(address => uint256) public _numPresaleMints;
1074 
1075     /// @notice Whether the address used the voucher amount specified in the Merkle tree.
1076     ///  Note that we assume each address is only included once in the Merkle tree.
1077     mapping(address => bool) public _usedVoucher;
1078 
1079     string internal _baseTokenURI;
1080     string internal _placeholderURI;
1081     string internal _contractURI;
1082 
1083     modifier notFinalized() {
1084         require(
1085             !_isFinalized,
1086             "Metadata is finalized"
1087         );
1088         _;
1089     }
1090 
1091     constructor(
1092         string memory placeholderURI
1093     ) ERC721A("Gutter Punks", "GP") {
1094         _placeholderURI = placeholderURI;
1095     }
1096 	
1097     function _startTokenId() internal view override virtual returns (uint256) {
1098         return 1;
1099     }
1100 
1101     function setPresaleMerkleRoot(bytes32 root) external onlyOwner {
1102         _presaleMerkleRoot = root;
1103         emit SetPresaleMerkleRoot(root);
1104     }
1105 
1106     function setProvenanceHash(string calldata provenanceHash) external onlyOwner notFinalized {
1107         _provenanceHash = provenanceHash;
1108         emit SetProvenanceHash(provenanceHash);
1109     }
1110 
1111     function setPresaleIsActive(bool presaleIsActive) external onlyOwner {
1112         _presaleIsActive = presaleIsActive;
1113         emit SetPresaleIsActive(presaleIsActive);
1114     }
1115 
1116     function setSaleIsActive(bool saleIsActive) external onlyOwner {
1117         _saleIsActive = saleIsActive;
1118         emit SetSaleIsActive(saleIsActive);
1119     }
1120 
1121     function setCurrentPrice(uint256 currentPrice) external onlyOwner {
1122         _currentPrice = currentPrice;
1123         emit SetCurrentPrice(currentPrice);
1124     }
1125 
1126     function setIsRevealed(bool isRevealed) external onlyOwner notFinalized {
1127         _isRevealed = isRevealed;
1128         emit SetIsRevealed(isRevealed);
1129     }
1130 
1131     function setPresaleExtras(uint256 presaleExtras) external onlyOwner {
1132 		_presaleExtras = presaleExtras;
1133     }
1134 
1135     function finalize() external onlyOwner notFinalized {
1136         require(
1137             _isRevealed,
1138             "Must be revealed to finalize"
1139         );
1140         _isFinalized = true;
1141         emit Finalized();
1142     }
1143 
1144     function setRoyaltyInfo(address royaltyRecipient, uint256 royaltyAmountNumerator) external onlyOwner {
1145         _royaltyRecipient = royaltyRecipient;
1146         _royaltyAmountNumerator = royaltyAmountNumerator;
1147         emit SetRoyaltyInfo(royaltyRecipient, royaltyAmountNumerator);
1148     }
1149 
1150     function setBaseURI(string calldata baseURI) external onlyOwner notFinalized {
1151         _baseTokenURI = baseURI;
1152         emit SetBaseURI(baseURI);
1153     }
1154 
1155     function setPlaceholderURI(string calldata placeholderURI) external onlyOwner {
1156         _placeholderURI = placeholderURI;
1157         emit SetPlaceholderURI(placeholderURI);
1158     }
1159 
1160     function setContractURI(string calldata newContractURI) external onlyOwner {
1161         _contractURI = newContractURI;
1162         emit SetContractURI(newContractURI);
1163     }
1164 
1165     function withdraw() external onlyOwner {
1166         uint256 balance = address(this).balance;
1167         payable(msg.sender).transfer(balance);
1168         emit Withdrew(balance);
1169     }
1170 
1171     function mintReservedTokens(address recipient, uint256 numToMint) external onlyOwner {
1172         require(
1173             _totalMinted() + numToMint <= RESERVED_SUPPLY,
1174             "Mint would exceed reserved supply"
1175         );
1176 
1177         _mint(recipient, numToMint, '', true);
1178     }
1179 
1180     /**
1181      * @notice Called by users to mint from the presale.
1182      */
1183     function mintPresale(
1184         uint256 numToMint,
1185         uint256 maxMints,
1186         uint256 voucherAmount,
1187         bytes32[] calldata merkleProof
1188     ) external payable {
1189         require(
1190             _presaleIsActive,
1191             "Presale not active"
1192         );
1193 
1194         // The Merkle tree node contains: (address account, uint256 maxMints, uint256 voucherAmount)
1195         bytes32 leaf = keccak256(abi.encodePacked(msg.sender, maxMints, voucherAmount));
1196 
1197         // Verify the mint params are part of the Merkle tree, given the Merkle proof.
1198         require(
1199             MerkleProof.verify(merkleProof, _presaleMerkleRoot, leaf),
1200             "Invalid Merkle proof"
1201         );
1202 
1203         // Require that the minter does not exceed their max allocation given by the Merkle tree.
1204         uint256 newNumPresaleMints = _numPresaleMints[msg.sender] + numToMint;
1205 		uint256 presaleExtrasNeeded = 0;
1206 		if(newNumPresaleMints > maxMints) { 
1207 			presaleExtrasNeeded = newNumPresaleMints - maxMints;
1208 			require(
1209 				presaleExtrasNeeded <= _presaleExtras,
1210 				"Presale mints exceeded"
1211 			);
1212 		}
1213 
1214         // Use the voucher amount if it wasn't previously used.
1215         uint256 remainingVoucherAmount = 0;
1216         if (voucherAmount != 0 && !_usedVoucher[msg.sender]) {
1217             remainingVoucherAmount = voucherAmount;
1218             _usedVoucher[msg.sender] = true;
1219         }
1220 
1221         // Update storage (do this before minting as mint recipients may have callbacks).
1222         _numPresaleMints[msg.sender] = newNumPresaleMints;
1223 		if(presaleExtrasNeeded > 0) { _presaleExtras -= presaleExtrasNeeded; }
1224 
1225         // Mint tokens, checking for sufficient payment and supply.
1226         _mintInner(numToMint, remainingVoucherAmount);
1227     }
1228 
1229     /**
1230      * @notice Called by users to mint from the main sale.
1231      */
1232     function mint(uint256 numToMint) external payable {
1233         require(
1234             _saleIsActive,
1235             "Sale not active"
1236         );
1237 
1238         // Mint tokens, checking for sufficient payment and supply.
1239         _mintInner(numToMint, 0);
1240     }
1241 
1242     /**
1243      * @notice Implements ERC-2981 royalty info interface.
1244      */
1245     function royaltyInfo(uint256 /* tokenId */, uint256 salePrice) external view returns (address, uint256) {
1246         return (_royaltyRecipient, salePrice * _royaltyAmountNumerator / ROYALTY_AMOUNT_DENOMINATOR);
1247     }
1248 
1249     function contractURI() external view returns (string memory) {
1250         return _contractURI;
1251     }
1252 
1253     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1254         require(
1255             _exists(tokenId),
1256             "ERC721Metadata: URI query for nonexistent token"
1257         );
1258 
1259         if (!_isRevealed) {
1260             return _placeholderURI;
1261         }
1262 
1263         string memory baseURI = _baseTokenURI;
1264         return bytes(baseURI).length > 0
1265             ? string(abi.encodePacked(baseURI, tokenId.toString(), TOKEN_URI_EXTENSION))
1266             : "";
1267     }
1268     
1269     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1270         return (
1271             interfaceId == INTERFACE_ID_ERC2981 ||
1272             super.supportsInterface(interfaceId)
1273         );
1274     }
1275 
1276     function getCurrentPrice() public view returns (uint256) {
1277         return _currentPrice;
1278     }
1279 
1280     function getCost(uint256 numToMint) public view returns (uint256) {
1281         return numToMint * getCurrentPrice();
1282     }
1283 
1284     /**
1285      * @dev Mints `numToMint` tokens to msg.sender.
1286      *
1287      *  Reverts if the max supply would be exceeded.
1288      *  Reverts if the payment amount (`msg.value`) is insufficient.
1289      */
1290     function _mintInner(uint256 numToMint, uint256 voucherAmount) internal {
1291         require(
1292             _totalMinted() + numToMint <= MAX_SUPPLY,
1293             "Mint would exceed max supply"
1294         );
1295         require(
1296             getCost(numToMint) <= msg.value + voucherAmount,
1297             "Insufficient payment"
1298         );
1299 
1300         _mint(msg.sender, numToMint, '', true);
1301     }
1302 
1303 
1304     function addAirdropContract(address contAddress) external onlyOwner { 
1305         for(uint256 i = 0;i < airdrops.length;i++) {
1306             if(airdrops[i] == contAddress) return;
1307         }
1308         airdrops.push(contAddress);
1309     }
1310 
1311     function removeAirdropContract(address contAddress) external onlyOwner {
1312         uint256 contIndex = 0;
1313         bool found = false;
1314         for(uint256 i = 0;i < airdrops.length;i++) {
1315             if(airdrops[i] == contAddress) {
1316                 found = true;
1317                 contIndex = i;
1318                 break;
1319             }
1320         }
1321         require(found, "Airdrop contract not in list.");
1322         if(contIndex != (airdrops.length - 1)) {
1323             airdrops[contIndex] = airdrops[airdrops.length - 1];
1324         }
1325         airdrops.pop();
1326     }
1327 }
1328 
1329 
1330 
1331 
1332 /**
1333  * @dev These functions deal with verification of Merkle Trees proofs.
1334  *
1335  * The proofs can be generated using the JavaScript library
1336  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1337  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1338  *
1339  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1340  */
1341 library MerkleProof {
1342     /**
1343      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1344      * defined by `root`. For this, a `proof` must be provided, containing
1345      * sibling hashes on the branch from the leaf to the root of the tree. Each
1346      * pair of leaves and each pair of pre-images are assumed to be sorted.
1347      */
1348     function verify(
1349         bytes32[] memory proof,
1350         bytes32 root,
1351         bytes32 leaf
1352     ) internal pure returns (bool) {
1353         return processProof(proof, leaf) == root;
1354     }
1355 
1356     /**
1357      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1358      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1359      * hash matches the root of the tree. When processing the proof, the pairs
1360      * of leafs & pre-images are assumed to be sorted.
1361      *
1362      * _Available since v4.4._
1363      */
1364     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1365         bytes32 computedHash = leaf;
1366         for (uint256 i = 0; i < proof.length; i++) {
1367             bytes32 proofElement = proof[i];
1368             if (computedHash <= proofElement) {
1369                 // Hash(current computed hash + current element of the proof)
1370                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1371             } else {
1372                 // Hash(current element of the proof + current computed hash)
1373                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1374             }
1375         }
1376         return computedHash;
1377     }
1378 }
1379 
1380 
1381 
1382 
1383 
1384 
1385 /**
1386  * @dev String operations.
1387  */
1388 library Strings {
1389     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1390 
1391     /**
1392      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1393      */
1394     function toString(uint256 value) internal pure returns (string memory) {
1395         // Inspired by OraclizeAPI's implementation - MIT licence
1396         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1397 
1398         if (value == 0) {
1399             return "0";
1400         }
1401         uint256 temp = value;
1402         uint256 digits;
1403         while (temp != 0) {
1404             digits++;
1405             temp /= 10;
1406         }
1407         bytes memory buffer = new bytes(digits);
1408         while (value != 0) {
1409             digits -= 1;
1410             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1411             value /= 10;
1412         }
1413         return string(buffer);
1414     }
1415 
1416     /**
1417      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1418      */
1419     function toHexString(uint256 value) internal pure returns (string memory) {
1420         if (value == 0) {
1421             return "0x00";
1422         }
1423         uint256 temp = value;
1424         uint256 length = 0;
1425         while (temp != 0) {
1426             length++;
1427             temp >>= 8;
1428         }
1429         return toHexString(value, length);
1430     }
1431 
1432     /**
1433      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1434      */
1435     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1436         bytes memory buffer = new bytes(2 * length + 2);
1437         buffer[0] = "0";
1438         buffer[1] = "x";
1439         for (uint256 i = 2 * length + 1; i > 1; --i) {
1440             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1441             value >>= 4;
1442         }
1443         require(value == 0, "Strings: hex length insufficient");
1444         return string(buffer);
1445     }
1446 }
1447 
1448 
1449 /**
1450  * @dev Collection of functions related to the address type
1451  */
1452 library Address {
1453     /**
1454      * @dev Returns true if `account` is a contract.
1455      *
1456      * [IMPORTANT]
1457      * ====
1458      * It is unsafe to assume that an address for which this function returns
1459      * false is an externally-owned account (EOA) and not a contract.
1460      *
1461      * Among others, `isContract` will return false for the following
1462      * types of addresses:
1463      *
1464      *  - an externally-owned account
1465      *  - a contract in construction
1466      *  - an address where a contract will be created
1467      *  - an address where a contract lived, but was destroyed
1468      * ====
1469      */
1470     function isContract(address account) internal view returns (bool) {
1471         // This method relies on extcodesize, which returns 0 for contracts in
1472         // construction, since the code is only stored at the end of the
1473         // constructor execution.
1474 
1475         uint256 size;
1476         assembly {
1477             size := extcodesize(account)
1478         }
1479         return size > 0;
1480     }
1481 
1482     /**
1483      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1484      * `recipient`, forwarding all available gas and reverting on errors.
1485      *
1486      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1487      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1488      * imposed by `transfer`, making them unable to receive funds via
1489      * `transfer`. {sendValue} removes this limitation.
1490      *
1491      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1492      *
1493      * IMPORTANT: because control is transferred to `recipient`, care must be
1494      * taken to not create reentrancy vulnerabilities. Consider using
1495      * {ReentrancyGuard} or the
1496      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1497      */
1498     function sendValue(address payable recipient, uint256 amount) internal {
1499         require(address(this).balance >= amount, "Address: insufficient balance");
1500 
1501         (bool success, ) = recipient.call{value: amount}("");
1502         require(success, "Address: unable to send value, recipient may have reverted");
1503     }
1504 
1505     /**
1506      * @dev Performs a Solidity function call using a low level `call`. A
1507      * plain `call` is an unsafe replacement for a function call: use this
1508      * function instead.
1509      *
1510      * If `target` reverts with a revert reason, it is bubbled up by this
1511      * function (like regular Solidity function calls).
1512      *
1513      * Returns the raw returned data. To convert to the expected return value,
1514      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1515      *
1516      * Requirements:
1517      *
1518      * - `target` must be a contract.
1519      * - calling `target` with `data` must not revert.
1520      *
1521      * _Available since v3.1._
1522      */
1523     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1524         return functionCall(target, data, "Address: low-level call failed");
1525     }
1526 
1527     /**
1528      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1529      * `errorMessage` as a fallback revert reason when `target` reverts.
1530      *
1531      * _Available since v3.1._
1532      */
1533     function functionCall(
1534         address target,
1535         bytes memory data,
1536         string memory errorMessage
1537     ) internal returns (bytes memory) {
1538         return functionCallWithValue(target, data, 0, errorMessage);
1539     }
1540 
1541     /**
1542      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1543      * but also transferring `value` wei to `target`.
1544      *
1545      * Requirements:
1546      *
1547      * - the calling contract must have an ETH balance of at least `value`.
1548      * - the called Solidity function must be `payable`.
1549      *
1550      * _Available since v3.1._
1551      */
1552     function functionCallWithValue(
1553         address target,
1554         bytes memory data,
1555         uint256 value
1556     ) internal returns (bytes memory) {
1557         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1558     }
1559 
1560     /**
1561      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1562      * with `errorMessage` as a fallback revert reason when `target` reverts.
1563      *
1564      * _Available since v3.1._
1565      */
1566     function functionCallWithValue(
1567         address target,
1568         bytes memory data,
1569         uint256 value,
1570         string memory errorMessage
1571     ) internal returns (bytes memory) {
1572         require(address(this).balance >= value, "Address: insufficient balance for call");
1573         require(isContract(target), "Address: call to non-contract");
1574 
1575         (bool success, bytes memory returndata) = target.call{value: value}(data);
1576         return verifyCallResult(success, returndata, errorMessage);
1577     }
1578 
1579     /**
1580      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1581      * but performing a static call.
1582      *
1583      * _Available since v3.3._
1584      */
1585     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1586         return functionStaticCall(target, data, "Address: low-level static call failed");
1587     }
1588 
1589     /**
1590      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1591      * but performing a static call.
1592      *
1593      * _Available since v3.3._
1594      */
1595     function functionStaticCall(
1596         address target,
1597         bytes memory data,
1598         string memory errorMessage
1599     ) internal view returns (bytes memory) {
1600         require(isContract(target), "Address: static call to non-contract");
1601 
1602         (bool success, bytes memory returndata) = target.staticcall(data);
1603         return verifyCallResult(success, returndata, errorMessage);
1604     }
1605 
1606     /**
1607      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1608      * but performing a delegate call.
1609      *
1610      * _Available since v3.4._
1611      */
1612     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1613         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1614     }
1615 
1616     /**
1617      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1618      * but performing a delegate call.
1619      *
1620      * _Available since v3.4._
1621      */
1622     function functionDelegateCall(
1623         address target,
1624         bytes memory data,
1625         string memory errorMessage
1626     ) internal returns (bytes memory) {
1627         require(isContract(target), "Address: delegate call to non-contract");
1628 
1629         (bool success, bytes memory returndata) = target.delegatecall(data);
1630         return verifyCallResult(success, returndata, errorMessage);
1631     }
1632 
1633     /**
1634      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1635      * revert reason using the provided one.
1636      *
1637      * _Available since v4.3._
1638      */
1639     function verifyCallResult(
1640         bool success,
1641         bytes memory returndata,
1642         string memory errorMessage
1643     ) internal pure returns (bytes memory) {
1644         if (success) {
1645             return returndata;
1646         } else {
1647             // Look for revert reason and bubble it up if present
1648             if (returndata.length > 0) {
1649                 // The easiest way to bubble the revert reason is using memory via assembly
1650 
1651                 assembly {
1652                     let returndata_size := mload(returndata)
1653                     revert(add(32, returndata), returndata_size)
1654                 }
1655             } else {
1656                 revert(errorMessage);
1657             }
1658         }
1659     }
1660 }
1661 
1662 abstract contract AirdropToken {
1663     function parentTokenTransferred(address from, uint256 tokenId) virtual public;
1664 }