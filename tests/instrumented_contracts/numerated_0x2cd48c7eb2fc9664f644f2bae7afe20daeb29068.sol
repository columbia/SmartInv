1 // Sources flattened with hardhat v2.8.4 https://hardhat.org
2 
3 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.5.0
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Contract module that helps prevent reentrant calls to a function.
12  *
13  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
14  * available, which can be applied to functions to make sure there are no nested
15  * (reentrant) calls to them.
16  *
17  * Note that because there is a single `nonReentrant` guard, functions marked as
18  * `nonReentrant` may not call one another. This can be worked around by making
19  * those functions `private`, and then adding `external` `nonReentrant` entry
20  * points to them.
21  *
22  * TIP: If you would like to learn more about reentrancy and alternative ways
23  * to protect against it, check out our blog post
24  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
25  */
26 abstract contract ReentrancyGuard {
27     // Booleans are more expensive than uint256 or any type that takes up a full
28     // word because each write operation emits an extra SLOAD to first read the
29     // slot's contents, replace the bits taken up by the boolean, and then write
30     // back. This is the compiler's defense against contract upgrades and
31     // pointer aliasing, and it cannot be disabled.
32 
33     // The values being non-zero value makes deployment a bit more expensive,
34     // but in exchange the refund on every call to nonReentrant will be lower in
35     // amount. Since refunds are capped to a percentage of the total
36     // transaction's gas, it is best to keep them low in cases like this one, to
37     // increase the likelihood of the full refund coming into effect.
38     uint256 private constant _NOT_ENTERED = 1;
39     uint256 private constant _ENTERED = 2;
40 
41     uint256 private _status;
42 
43     constructor() {
44         _status = _NOT_ENTERED;
45     }
46 
47     /**
48      * @dev Prevents a contract from calling itself, directly or indirectly.
49      * Calling a `nonReentrant` function from another `nonReentrant`
50      * function is not supported. It is possible to prevent this from happening
51      * by making the `nonReentrant` function external, and making it call a
52      * `private` function that does the actual work.
53      */
54     modifier nonReentrant() {
55         // On the first call to nonReentrant, _notEntered will be true
56         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
57 
58         // Any calls to nonReentrant after this point will fail
59         _status = _ENTERED;
60 
61         _;
62 
63         // By storing the original value once again, a refund is triggered (see
64         // https://eips.ethereum.org/EIPS/eip-2200)
65         _status = _NOT_ENTERED;
66     }
67 }
68 
69 
70 // File contracts/PowrUp.sol
71 
72 pragma solidity 0.8.14;
73 
74 /**
75  * @dev Interface of the ERC165 standard, as defined in the
76  * https://eips.ethereum.org/EIPS/eip-165[EIP].
77  *
78  * Implementers can declare support of contract interfaces, which can then be
79  * queried by others ({ERC165Checker}).
80  *
81  * For an implementation, see {ERC165}.
82  */
83 interface IERC165 {
84     /**
85      * @dev Returns true if this contract implements the interface defined by
86      * `interfaceId`. See the corresponding
87      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
88      * to learn more about how these ids are created.
89      *
90      * This function call must use less than 30 000 gas.
91      */
92     function supportsInterface(bytes4 interfaceId) external view returns (bool);
93 }
94 
95 /**
96  * @dev Implementation of the {IERC165} interface.
97  *
98  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
99  * for the additional interface id that will be supported. For example:
100  *
101  * ```solidity
102  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
103  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
104  * }
105  * ```
106  *
107  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
108  */
109 abstract contract ERC165 is IERC165 {
110     /**
111      * @dev See {IERC165-supportsInterface}.
112      */
113     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
114         return interfaceId == type(IERC165).interfaceId;
115     }
116 }
117 
118 /**
119  * @dev Required interface of an ERC721 compliant contract.
120  */
121 interface IERC721 is IERC165 {
122     /**
123      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
124      */
125     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
126 
127     /**
128      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
129      */
130     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
131 
132     /**
133      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
134      */
135     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
136 
137     /**
138      * @dev Returns the number of tokens in ``owner``"s account.
139      */
140     function balanceOf(address owner) external view returns (uint256 balance);
141 
142     /**
143      * @dev Returns the owner of the `tokenId` token.
144      *
145      * Requirements:
146      *
147      * - `tokenId` must exist.
148      */
149     function ownerOf(uint256 tokenId) external view returns (address owner);
150 
151     /**
152      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
153      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
154      *
155      * Requirements:
156      *
157      * - `from` cannot be the zero address.
158      * - `to` cannot be the zero address.
159      * - `tokenId` token must exist and be owned by `from`.
160      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
161      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
162      *
163      * Emits a {Transfer} event.
164      */
165     function safeTransferFrom(
166         address from,
167         address to,
168         uint256 tokenId
169     ) external;
170 
171     /**
172      * @dev Transfers `tokenId` token from `from` to `to`.
173      *
174      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
175      *
176      * Requirements:
177      *
178      * - `from` cannot be the zero address.
179      * - `to` cannot be the zero address.
180      * - `tokenId` token must be owned by `from`.
181      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
182      *
183      * Emits a {Transfer} event.
184      */
185     function transferFrom(
186         address from,
187         address to,
188         uint256 tokenId
189     ) external;
190 
191     /**
192      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
193      * The approval is cleared when the token is transferred.
194      *
195      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
196      *
197      * Requirements:
198      *
199      * - The caller must own the token or be an approved operator.
200      * - `tokenId` must exist.
201      *
202      * Emits an {Approval} event.
203      */
204     function approve(address to, uint256 tokenId) external;
205 
206     /**
207      * @dev Returns the account approved for `tokenId` token.
208      *
209      * Requirements:
210      *
211      * - `tokenId` must exist.
212      */
213     function getApproved(uint256 tokenId) external view returns (address operator);
214 
215     /**
216      * @dev Approve or remove `operator` as an operator for the caller.
217      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
218      *
219      * Requirements:
220      *
221      * - The `operator` cannot be the caller.
222      *
223      * Emits an {ApprovalForAll} event.
224      */
225     function setApprovalForAll(address operator, bool _approved) external;
226 
227     /**
228      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
229      *
230      * See {setApprovalForAll}
231      */
232     function isApprovedForAll(address owner, address operator) external view returns (bool);
233 
234     /**
235      * @dev Safely transfers `tokenId` token from `from` to `to`.
236      *
237      * Requirements:
238      *
239      * - `from` cannot be the zero address.
240      * - `to` cannot be the zero address.
241      * - `tokenId` token must exist and be owned by `from`.
242      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
243      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
244      *
245      * Emits a {Transfer} event.
246      */
247     function safeTransferFrom(
248         address from,
249         address to,
250         uint256 tokenId,
251         bytes calldata data
252     ) external;
253 }
254 
255 /**
256  * @title ERC721 token receiver interface
257  * @dev Interface for any contract that wants to support safeTransfers
258  * from ERC721 asset contracts.
259  */
260 interface IERC721Receiver {
261     /**
262      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
263      * by `operator` from `from`, this function is called.
264      *
265      * It must return its Solidity selector to confirm the token transfer.
266      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
267      *
268      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
269      */
270     function onERC721Received(
271         address operator,
272         address from,
273         uint256 tokenId,
274         bytes calldata data
275     ) external returns (bytes4);
276 }
277 
278 
279 /**
280  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
281  * @dev See https://eips.ethereum.org/EIPS/eip-721
282  */
283 interface IERC721Metadata is IERC721 {
284     /**
285      * @dev Returns the token collection name.
286      */
287     function name() external view returns (string memory);
288 
289     /**
290      * @dev Returns the token collection symbol.
291      */
292     function symbol() external view returns (string memory);
293 
294     /**
295      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
296      */
297     function tokenURI(uint256 tokenId) external view returns (string memory);
298 }
299 
300 library Address {
301 
302     /**
303      * @dev Returns true if `account` is a contract.
304      *
305      * [IMPORTANT]
306      * ====
307      * It is unsafe to assume that an address for which this function returns
308      * false is an externally-owned account (EOA) and not a contract.
309      *
310      * Among others, `isContract` will return false for the following
311      * types of addresses:
312      *
313      *  - an externally-owned account
314      *  - a contract in construction
315      *  - an address where a contract will be created
316      *  - an address where a contract lived, but was destroyed
317      * ====
318      */
319     function isContract(address account) internal view returns (bool) {
320         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
321         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
322         // for accounts without code, i.e. `keccak256("")`
323         bytes32 codehash;
324         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
325         // solhint-disable-next-line no-inline-assembly
326         assembly { codehash := extcodehash(account) }
327         return (codehash != accountHash && codehash != 0x0);
328     }
329 }
330 
331 /**
332  * @dev Provides information about the current execution context, including the
333  * sender of the transaction and its data. While these are generally available
334  * via msg.sender and msg.data, they should not be accessed in such a direct
335  * manner, since when dealing with meta-transactions the account sending and
336  * paying for execution may not be the actual sender (as far as an application
337  * is concerned).
338  *
339  * This contract is only required for intermediate, library-like contracts.
340  */
341 abstract contract Context {
342     function _msgSender() internal view virtual returns (address) {
343         return msg.sender;
344     }
345 
346     function _msgData() internal view virtual returns (bytes calldata) {
347         return msg.data;
348     }
349 }
350 
351 interface IERC20 {
352 
353     function totalSupply() external view returns (uint256);
354     
355     function symbol() external view returns(string memory);
356     
357     function name() external view returns(string memory);
358 
359     /**
360      * @dev Returns the amount of tokens owned by `account`.
361      */
362     function balanceOf(address account) external view returns (uint256);
363     
364     /**
365      * @dev Returns the number of decimal places
366      */
367     function decimals() external view returns (uint8);
368 
369     /**
370      * @dev Moves `amount` tokens from the caller"s account to `recipient`.
371      *
372      * Returns a boolean value indicating whether the operation succeeded.
373      *
374      * Emits a {Transfer} event.
375      */
376     function transfer(address recipient, uint256 amount) external returns (bool);
377 
378     /**
379      * @dev Returns the remaining number of tokens that `spender` will be
380      * allowed to spend on behalf of `owner` through {transferFrom}. This is
381      * zero by default.
382      *
383      * This value changes when {approve} or {transferFrom} are called.
384      */
385     function allowance(address owner, address spender) external view returns (uint256);
386 
387     /**
388      * @dev Sets `amount` as the allowance of `spender` over the caller"s tokens.
389      *
390      * Returns a boolean value indicating whether the operation succeeded.
391      *
392      * IMPORTANT: Beware that changing an allowance with this method brings the risk
393      * that someone may use both the old and the new allowance by unfortunate
394      * transaction ordering. One possible solution to mitigate this race
395      * condition is to first reduce the spender"s allowance to 0 and set the
396      * desired value afterwards:
397      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
398      *
399      * Emits an {Approval} event.
400      */
401     function approve(address spender, uint256 amount) external returns (bool);
402 
403     /**
404      * @dev Moves `amount` tokens from `sender` to `recipient` using the
405      * allowance mechanism. `amount` is then deducted from the caller"s
406      * allowance.
407      *
408      * Returns a boolean value indicating whether the operation succeeded.
409      *
410      * Emits a {Transfer} event.
411      */
412     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
413 
414     /**
415      * @dev Emitted when `value` tokens are moved from one account (`from`) to
416      * another (`to`).
417      *
418      * Note that `value` may be zero.
419      */
420     event Transfer(address indexed from, address indexed to, uint256 value);
421 
422     /**
423      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
424      * a call to {approve}. `value` is the new allowance.
425      */
426     event Approval(address indexed owner, address indexed spender, uint256 value);
427 }
428 
429 contract Ownable {
430 
431     address public owner;
432     
433     // event for EVM logging
434     event OwnerSet(address indexed oldOwner, address indexed newOwner);
435     
436     // modifier to check if caller is owner
437     modifier onlyOwner() {
438         // If the first argument of "require" evaluates to "false", execution terminates and all
439         // changes to the state and to Ether balances are reverted.
440         // This used to consume all gas in old EVM versions, but not anymore.
441         // It is often a good idea to use "require" to check if functions are called correctly.
442         // As a second argument, you can also provide an explanation about what went wrong.
443         require(msg.sender == owner, "Caller is not owner");
444         _;
445     }
446     
447     /**
448      * @dev Set contract deployer as owner
449      */
450     constructor() {
451         owner = msg.sender; // "msg.sender" is sender of current call, contract deployer for a constructor
452         emit OwnerSet(address(0), owner);
453     }
454 
455     /**
456      * @dev Change owner
457      * @param newOwner address of new owner
458      */
459     function changeOwner(address newOwner) public onlyOwner {
460         emit OwnerSet(owner, newOwner);
461         owner = newOwner;
462     }
463 
464     /**
465      * @dev Return owner address 
466      * @return address of owner
467      */
468     function getOwner() external view returns (address) {
469         return owner;
470     }
471 }
472 
473 interface IAggregator {
474   function latestAnswer() external view returns (int256);
475   function latestTimestamp() external view returns (uint256);
476   function latestRound() external view returns (uint256);
477   function getAnswer(uint256 roundId) external view returns (int256);
478   function getTimestamp(uint256 roundId) external view returns (uint256);
479   function decimals() external view returns (uint8);
480 
481   event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 updatedAt);
482   event NewRound(uint256 indexed roundId, address indexed startedBy, uint256 startedAt);
483 }
484 
485 contract PowrUP is Context, ERC165, IERC721, IERC721Metadata, ReentrancyGuard, Ownable {
486 
487     using Address for address;
488 
489     // Token name
490     string private constant _name = "POW'r UP Ethereum Virtual Miner";
491 
492     // Token symbol
493     string private constant _symbol = "POWR";
494 
495     // total number of NFTs Minted
496     uint256 private _totalSupply;
497     uint256 public currentSupplyIndex;
498 
499     // Mapping from token ID to owner address
500     mapping(uint256 => address) private _owners;
501 
502     // Mapping owner address to token count
503     mapping(address => uint256) private _balances;
504 
505     // Mapping from token ID to approved address
506     mapping(uint256 => address) private _tokenApprovals;
507 
508     // Mapping from owner to operator approvals
509     mapping(address => mapping(address => bool)) private _operatorApprovals;
510 
511     // cost for minting NFT
512     uint256 public costUSD = 1000;
513 
514     // Mint Fee Recipient
515     address public mintRecipient;
516 
517     // base URI
518     string private baseURI = "url";
519     string private ending = ".json";
520 
521     // Contracts
522     IAggregator public aggregatorContract;
523 
524     // Enable Trading
525     bool public mintingEnabled = false;
526 
527     constructor() {
528         aggregatorContract = IAggregator(address(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419));
529     }
530 
531     ////////////////////////////////////////////////
532     ///////////   RESTRICTED FUNCTIONS   ///////////
533     ////////////////////////////////////////////////
534 
535     function enableMinting() external onlyOwner {
536         mintingEnabled = true;
537     }
538 
539     function disableMinting() external onlyOwner {
540         mintingEnabled = false;
541     }
542 
543     function setMintRecipient(address newRecipient) external onlyOwner {
544         mintRecipient = newRecipient;
545     }
546 
547     function withdraw() external onlyOwner {
548         (bool s,) = payable(msg.sender).call{value: address(this).balance}("");
549         require(s);
550     }
551 
552     function withdrawToken(address token_) external onlyOwner {
553         require(token_ != address(0), "Zero Address");
554         IERC20(token_).transfer(msg.sender, IERC20(token_).balanceOf(address(this)));
555     }
556 
557     function setCostUSD(uint256 newCost) external onlyOwner {
558         costUSD = newCost;
559     }
560 
561     function setBaseURI(string calldata newURI) external onlyOwner {
562         baseURI = newURI;
563     }
564 
565     function setURIExtention(string calldata newExtention) external onlyOwner {
566         ending = newExtention;
567     }
568 
569     function ownerMint(address to, uint256 qty) external onlyOwner {
570         // mint NFTs
571         for (uint i = 0; i < qty; i++) {
572             _safeMint(to, currentSupplyIndex);
573         }
574     }
575 
576 
577     ////////////////////////////////////////////////
578     ///////////     PUBLIC FUNCTIONS     ///////////
579     ////////////////////////////////////////////////
580 
581     /** 
582      * Mints `numberOfMints` NFTs To Caller
583      */
584     function mint(uint256 numberOfMints) payable external nonReentrant {
585         require(
586             mintingEnabled,
587             "Minting Not Enabled"
588         );
589         require(
590             numberOfMints > 0, 
591             "Invalid Input"
592         );
593 
594         // determine cost
595         int256 currentPrice = aggregatorContract.latestAnswer();
596         uint256 convertedPrice = uint(currentPrice) / 1 * (10 ** aggregatorContract.decimals());
597         uint cost = ((costUSD * numberOfMints) * 1e18) / convertedPrice;
598 
599         require(
600             msg.value >= cost * 99 / 100,
601             "Invalid Ethereum Amount"
602         );
603 
604         // mint tokens
605         for (uint i = 0; i < numberOfMints;) {
606             _safeMint(msg.sender, currentSupplyIndex);
607             unchecked { ++i; }
608         }
609     }
610 
611     function burn(uint256 tokenID) external {
612         require(_isApprovedOrOwner(_msgSender(), tokenID), "caller not owner nor approved");
613         _burn(tokenID);
614     }
615 
616     receive() external payable {}
617 
618     /**
619      * @dev See {IERC721-approve}.
620      */
621     function approve(address to, uint256 tokenId) public override {
622         address wpowner = ownerOf(tokenId);
623         require(to != wpowner, "ERC721: approval to current owner");
624 
625         require(
626             _msgSender() == wpowner || isApprovedForAll(wpowner, _msgSender()),
627             "ERC721: not approved or owner"
628         );
629 
630         _approve(to, tokenId);
631     }
632 
633     /**
634      * @dev See {IERC721-setApprovalForAll}.
635      */
636     function setApprovalForAll(address _operator, bool approved) public override {
637         _setApprovalForAll(_msgSender(), _operator, approved);
638     }
639 
640     /**
641      * @dev See {IERC721-transferFrom}.
642      */
643     function transferFrom(
644         address from,
645         address to,
646         uint256 tokenId
647     ) public override {
648         require(_isApprovedOrOwner(_msgSender(), tokenId), "caller not owner nor approved");
649         _transfer(from, to, tokenId);
650     }
651 
652     /**
653      * @dev See {IERC721-safeTransferFrom}.
654      */
655     function safeTransferFrom(
656         address from,
657         address to,
658         uint256 tokenId
659     ) public override {
660         safeTransferFrom(from, to, tokenId, "");
661     }
662 
663     /**
664      * @dev See {IERC721-safeTransferFrom}.
665      */
666     function safeTransferFrom(
667         address from,
668         address to,
669         uint256 tokenId,
670         bytes memory _data
671     ) public override {
672         require(_isApprovedOrOwner(_msgSender(), tokenId), "caller not owner nor approved");
673         _safeTransfer(from, to, tokenId, _data);
674     }
675 
676 
677     ////////////////////////////////////////////////
678     ///////////     READ FUNCTIONS       ///////////
679     ////////////////////////////////////////////////
680 
681     function totalSupply() external view returns (uint256) {
682         return _totalSupply;
683     }
684 
685     function getCurrentCost() external view returns (uint256) {
686         int256 currentPrice = aggregatorContract.latestAnswer();
687         uint256 convertedPrice = uint(currentPrice) / 1e8;
688         return (costUSD * 1e18) / convertedPrice;
689     }
690 
691     function getIDsByOwner(address owner, uint startIndex) external view returns (uint256[] memory) {
692         uint256[] memory ids = new uint256[](balanceOf(owner));
693         if (balanceOf(owner) == 0) return ids;
694         uint256 count = 0;
695         for (uint i = startIndex; i < _totalSupply; i++) {
696             if (_owners[i] == owner) {
697                 ids[count] = i;
698                 count++;
699             }
700         }
701         return ids;
702     }
703 
704     /**
705      * @dev See {IERC165-supportsInterface}.
706      */
707     function supportsInterface(bytes4 interfaceId) public view override(ERC165, IERC165) returns (bool) {
708         return
709             interfaceId == type(IERC721).interfaceId ||
710             interfaceId == type(IERC721Metadata).interfaceId ||
711             super.supportsInterface(interfaceId);
712     }
713 
714     /**
715      * @dev See {IERC721-balanceOf}.
716      */
717     function balanceOf(address wpowner) public view override returns (uint256) {
718         require(wpowner != address(0), "query for the zero address");
719         return _balances[wpowner];
720     }
721 
722     /**
723      * @dev See {IERC721-ownerOf}.
724      */
725     function ownerOf(uint256 tokenId) public view override returns (address) {
726         address wpowner = _owners[tokenId];
727         require(wpowner != address(0), "query for nonexistent token");
728         return wpowner;
729     }
730 
731     /**
732      * @dev See {IERC721Metadata-name}.
733      */
734     function name() public pure override returns (string memory) {
735         return _name;
736     }
737 
738     /**
739      * @dev See {IERC721Metadata-symbol}.
740      */
741     function symbol() public pure override returns (string memory) {
742         return _symbol;
743     }
744 
745     /**
746      * @dev See {IERC721Metadata-tokenURI}.
747      */
748     function tokenURI(uint256 tokenId) public view override returns (string memory) {
749         require(_exists(tokenId), "nonexistent token");
750 
751         string memory fHalf = string.concat(baseURI, uint2str(tokenId));
752         return string.concat(fHalf, ending);
753     }
754 
755     /**
756         Converts A Uint Into a String
757     */
758     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
759         if (_i == 0) {
760             return "0";
761         }
762         uint j = _i;
763         uint len;
764         while (j != 0) {
765             len++;
766             j /= 10;
767         }
768         bytes memory bstr = new bytes(len);
769         uint k = len;
770         while (_i != 0) {
771             k = k-1;
772             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
773             bytes1 b1 = bytes1(temp);
774             bstr[k] = b1;
775             _i /= 10;
776         }
777         return string(bstr);
778     }
779 
780     /**
781      * @dev See {IERC721-getApproved}.
782      */
783     function getApproved(uint256 tokenId) public view override returns (address) {
784         require(_exists(tokenId), "ERC721: query for nonexistent token");
785 
786         return _tokenApprovals[tokenId];
787     }
788 
789     /**
790      * @dev See {IERC721-isApprovedForAll}.
791      */
792     function isApprovedForAll(address wpowner, address _operator) public view override returns (bool) {
793         return _operatorApprovals[wpowner][_operator];
794     }
795 
796     /**
797      * @dev Returns whether `tokenId` exists.
798      *
799      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
800      *
801      * Tokens start existing when they are minted
802      */
803     function _exists(uint256 tokenId) internal view returns (bool) {
804         return _owners[tokenId] != address(0);
805     }
806 
807     /**
808      * @dev Returns whether `spender` is allowed to manage `tokenId`.
809      *
810      * Requirements:
811      *
812      * - `tokenId` must exist.
813      */
814     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
815         require(_exists(tokenId), "ERC721: nonexistent token");
816         address wpowner = ownerOf(tokenId);
817         return (spender == wpowner || getApproved(tokenId) == spender || isApprovedForAll(wpowner, spender));
818     }
819 
820     ////////////////////////////////////////////////
821     ///////////    INTERNAL FUNCTIONS    ///////////
822     ////////////////////////////////////////////////
823 
824 
825     function _transferIn(address token, uint256 amount) internal {
826         require(
827             IERC20(token).allowance(msg.sender, address(this)) >= amount,
828             "Insufficient Allowance"
829         );
830         uint bal = IERC20(token).balanceOf(mintRecipient);
831         require(
832             IERC20(token).transferFrom(msg.sender, mintRecipient, amount),
833             "Transfer From Fail"
834         );
835         uint After = IERC20(token).balanceOf(mintRecipient);
836         require(
837             After > bal,
838             "Zero Received"
839         );
840     }
841 
842     /**
843      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
844      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
845      */
846     function _safeMint(
847         address to,
848         uint256 tokenId
849     ) internal {
850         _mint(to, tokenId);
851         require(
852             _checkOnERC721Received(address(0), to, tokenId, ""),
853             "ERC721: transfer to non ERC721Receiver implementer"
854         );
855     }
856 
857     /**
858      * @dev Mints `tokenId` and transfers it to `to`.
859      *
860      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
861      *
862      * Requirements:
863      *
864      * - `tokenId` must not exist.
865      * - `to` cannot be the zero address.
866      *
867      * Emits a {Transfer} event.
868      */
869     function _mint(address to, uint256 tokenId) internal {
870         require(!_exists(tokenId), "ERC721: token already minted");
871 
872         _owners[tokenId] = to;
873         unchecked {
874             _balances[to] += 1;
875             _totalSupply++;
876             currentSupplyIndex++;
877         }
878 
879         emit Transfer(address(0), to, tokenId);
880     }
881 
882 
883     /**
884      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
885      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
886      *
887      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
888      *
889      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
890      * implement alternative mechanisms to perform token transfer, such as signature-based.
891      *
892      * Requirements:
893      *
894      * - `from` cannot be the zero address.
895      * - `to` cannot be the zero address.
896      * - `tokenId` token must exist and be owned by `from`.
897      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
898      *
899      * Emits a {Transfer} event.
900      */
901     function _safeTransfer(
902         address from,
903         address to,
904         uint256 tokenId,
905         bytes memory _data
906     ) internal {
907         _transfer(from, to, tokenId);
908         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: non ERC721Receiver implementer");
909     }
910 
911     /**
912      * @dev Destroys `tokenId`.
913      * The approval is cleared when the token is burned.
914      *
915      * Requirements:
916      *
917      * - `tokenId` must exist.
918      *
919      * Emits a {Transfer} event.
920      */
921     function _burn(uint256 tokenId) internal {
922         require(_exists(tokenId), "Token Does Not Exist");
923 
924         // owner of token
925         address owner = ownerOf(tokenId);
926 
927         // Clear approvals
928         _approve(address(0), tokenId);
929 
930         // decrement balance
931         _balances[owner] -= 1;
932         delete _owners[tokenId];
933 
934         // decrement total supply
935         _totalSupply -= 1;
936 
937         // emit transfer
938         emit Transfer(owner, address(0), tokenId);
939     }
940 
941     /**
942      * @dev Transfers `tokenId` from `from` to `to`.
943      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
944      *
945      * Requirements:
946      *
947      * - `to` cannot be the zero address.
948      * - `tokenId` token must be owned by `from`.
949      *
950      * Emits a {Transfer} event.
951      */
952     function _transfer(
953         address from,
954         address to,
955         uint256 tokenId
956     ) internal {
957         require(ownerOf(tokenId) == from, "Incorrect owner");
958         require(to != address(0), "zero address");
959         require(balanceOf(from) > 0, "Zero Balance");
960 
961         // Clear approvals from the previous owner
962         _approve(address(0), tokenId);
963 
964         // Allocate balances
965         _balances[from] -= 1;
966         _balances[to] += 1;
967         _owners[tokenId] = to;
968 
969         // emit transfer
970         emit Transfer(from, to, tokenId);
971     }
972 
973     /**
974      * @dev Approve `to` to operate on `tokenId`
975      *
976      * Emits a {Approval} event.
977      */
978     function _approve(address to, uint256 tokenId) internal {
979         _tokenApprovals[tokenId] = to;
980         emit Approval(ownerOf(tokenId), to, tokenId);
981     }
982 
983     /**
984      * @dev Approve `operator` to operate on all of `owner` tokens
985      *
986      * Emits a {ApprovalForAll} event.
987      */
988     function _setApprovalForAll(
989         address wpowner,
990         address _operator,
991         bool approved
992     ) internal {
993         require(wpowner != _operator, "ERC721: approve to caller");
994         _operatorApprovals[wpowner][_operator] = approved;
995         emit ApprovalForAll(wpowner, _operator, approved);
996     }
997 
998     function onReceivedRetval() public pure returns (bytes4) {
999         return IERC721Receiver.onERC721Received.selector;
1000     }
1001 
1002     /**
1003      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1004      * The call is not executed if the target address is not a contract.
1005      *
1006      * @param from address representing the previous owner of the given token ID
1007      * @param to target address that will receive the tokens
1008      * @param tokenId uint256 ID of the token to be transferred
1009      * @param _data bytes optional data to send along with the call
1010      * @return bool whether the call correctly returned the expected magic value
1011      */
1012     function _checkOnERC721Received(
1013         address from,
1014         address to,
1015         uint256 tokenId,
1016         bytes memory _data
1017     ) private returns (bool) {
1018         if (to.isContract()) {
1019             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1020                 return retval == IERC721Receiver.onERC721Received.selector;
1021             } catch (bytes memory reason) {
1022                 if (reason.length == 0) {
1023                     revert("ERC721: non ERC721Receiver implementer");
1024                 } else {
1025                     assembly {
1026                         revert(add(32, reason), mload(reason))
1027                     }
1028                 }
1029             }
1030         } else {
1031             return true;
1032         }
1033     }
1034 }