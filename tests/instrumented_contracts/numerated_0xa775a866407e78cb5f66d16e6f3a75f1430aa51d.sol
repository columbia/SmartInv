1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-03
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /*
10     Fully commented standard ERC721 Distilled from OpenZeppelin Docs
11     Base for Building ERC721 by Martin McConnell
12     All the utility without the fluff.
13 */
14 
15 
16 interface IERC165 {
17     function supportsInterface(bytes4 interfaceId) external view returns (bool);
18 }
19 
20 interface IERC721 is IERC165 {
21     //@dev Emitted when `tokenId` token is transferred from `from` to `to`.
22     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
23 
24     //@dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
25     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
26 
27     //@dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
28     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
29 
30     //@dev Returns the number of tokens in ``owner``'s account.
31     function balanceOf(address owner) external view returns (uint256 balance);
32 
33     /**
34      * @dev Returns the owner of the `tokenId` token.
35      *
36      * Requirements:
37      *
38      * - `tokenId` must exist.
39      */
40     function ownerOf(uint256 tokenId) external view returns (address owner);
41 
42     /**
43      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
44      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
45      *
46      * Requirements:
47      *
48      * - `from` cannot be the zero address.
49      * - `to` cannot be the zero address.
50      * - `tokenId` token must exist and be owned by `from`.
51      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
52      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
53      *
54      * Emits a {Transfer} event.
55      */
56     function safeTransferFrom(address from,address to,uint256 tokenId) external;
57 
58     /**
59      * @dev Transfers `tokenId` token from `from` to `to`.
60      *
61      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
62      *
63      * Requirements:
64      *
65      * - `from` cannot be the zero address.
66      * - `to` cannot be the zero address.
67      * - `tokenId` token must be owned by `from`.
68      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
69      *
70      * Emits a {Transfer} event.
71      */
72     function transferFrom(address from, address to, uint256 tokenId) external;
73 
74     /**
75      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
76      * The approval is cleared when the token is transferred.
77      *
78      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
79      *
80      * Requirements:
81      *
82      * - The caller must own the token or be an approved operator.
83      * - `tokenId` must exist.
84      *
85      * Emits an {Approval} event.
86      */
87     function approve(address to, uint256 tokenId) external;
88 
89     /**
90      * @dev Returns the account approved for `tokenId` token.
91      *
92      * Requirements:
93      *
94      * - `tokenId` must exist.
95      */
96     function getApproved(uint256 tokenId) external view returns (address operator);
97 
98     /**
99      * @dev Approve or remove `operator` as an operator for the caller.
100      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
101      *
102      * Requirements:
103      * - The `operator` cannot be the caller.
104      *
105      * Emits an {ApprovalForAll} event.
106      */
107     function setApprovalForAll(address operator, bool _approved) external;
108 
109     //@dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
110     function isApprovedForAll(address owner, address operator) external view returns (bool);
111 
112     /**
113      * @dev Safely transfers `tokenId` token from `from` to `to`.
114      *
115      * Requirements:
116      *
117      * - `from` cannot be the zero address.
118      * - `to` cannot be the zero address.
119      * - `tokenId` token must exist and be owned by `from`.
120      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
121      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
122      *
123      * Emits a {Transfer} event.
124      */
125     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
126 }
127 
128 interface IERC721Metadata is IERC721 {
129     //@dev Returns the token collection name.
130     function name() external view returns (string memory);
131 
132     //@dev Returns the token collection symbol.
133     function symbol() external view returns (string memory);
134 
135     //@dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
136     function tokenURI(uint256 tokenId) external view returns (string memory);
137 }
138 
139 interface IERC721Receiver {
140     /**
141      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
142      * by `operator` from `from`, this function is called.
143      *
144      * It must return its Solidity selector to confirm the token transfer.
145      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
146      *
147      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
148      */
149     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
150 }
151 
152 library Address {
153     /**
154      * @dev Returns true if `account` is a contract.
155      *
156      * [IMPORTANT]
157      * ====
158      * It is unsafe to assume that an address for which this function returns
159      * false is an externally-owned account (EOA) and not a contract.
160      *
161      * Among others, `isContract` will return false for the following
162      * types of addresses:
163      *
164      *  - an externally-owned account
165      *  - a contract in construction
166      *  - an address where a contract will be created
167      *  - an address where a contract lived, but was destroyed
168      * ====
169      */
170     function isContract(address account) internal view returns (bool) {
171         // This method relies on extcodesize, which returns 0 for contracts in
172         // construction, since the code is only stored at the end of the
173         // constructor execution.
174 
175         uint256 size;
176         assembly {
177             size := extcodesize(account)
178         }
179         return size > 0;
180     }
181 
182     /**
183      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
184      * `recipient`, forwarding all available gas and reverting on errors.
185      *
186      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
187      * of certain opcodes, possibly making contracts go over the 2300 gas limit
188      * imposed by `transfer`, making them unable to receive funds via
189      * `transfer`. {sendValue} removes this limitation.
190      *
191      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
192      *
193      * IMPORTANT: because control is transferred to `recipient`, care must be
194      * taken to not create reentrancy vulnerabilities. Consider using
195      * {ReentrancyGuard} or the
196      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
197      */
198     function sendValue(address payable recipient, uint256 amount) internal {
199         require(address(this).balance >= amount, "Address: insufficient balance");
200 
201         (bool success, ) = recipient.call{value: amount}("");
202         require(success, "Address: unable to send value, recipient may have reverted");
203     }
204 
205     /**
206      * @dev Performs a Solidity function call using a low level `call`. A
207      * plain `call` is an unsafe replacement for a function call: use this
208      * function instead.
209      *
210      * If `target` reverts with a revert reason, it is bubbled up by this
211      * function (like regular Solidity function calls).
212      *
213      * Returns the raw returned data. To convert to the expected return value,
214      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
215      *
216      * Requirements:
217      *
218      * - `target` must be a contract.
219      * - calling `target` with `data` must not revert.
220      *
221      * _Available since v3.1._
222      */
223     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
224         return functionCall(target, data, "Address: low-level call failed");
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
229      * `errorMessage` as a fallback revert reason when `target` reverts.
230      *
231      * _Available since v3.1._
232      */
233     function functionCall(
234         address target,
235         bytes memory data,
236         string memory errorMessage
237     ) internal returns (bytes memory) {
238         return functionCallWithValue(target, data, 0, errorMessage);
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
243      * but also transferring `value` wei to `target`.
244      *
245      * Requirements:
246      *
247      * - the calling contract must have an ETH balance of at least `value`.
248      * - the called Solidity function must be `payable`.
249      *
250      * _Available since v3.1._
251      */
252     function functionCallWithValue(
253         address target,
254         bytes memory data,
255         uint256 value
256     ) internal returns (bytes memory) {
257         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
262      * with `errorMessage` as a fallback revert reason when `target` reverts.
263      *
264      * _Available since v3.1._
265      */
266     function functionCallWithValue(
267         address target,
268         bytes memory data,
269         uint256 value,
270         string memory errorMessage
271     ) internal returns (bytes memory) {
272         require(address(this).balance >= value, "Address: insufficient balance for call");
273         require(isContract(target), "Address: call to non-contract");
274 
275         (bool success, bytes memory returndata) = target.call{value: value}(data);
276         return _verifyCallResult(success, returndata, errorMessage);
277     }
278 
279     /**
280      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
281      * but performing a static call.
282      *
283      * _Available since v3.3._
284      */
285     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
286         return functionStaticCall(target, data, "Address: low-level static call failed");
287     }
288 
289     /**
290      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
291      * but performing a static call.
292      *
293      * _Available since v3.3._
294      */
295     function functionStaticCall(
296         address target,
297         bytes memory data,
298         string memory errorMessage
299     ) internal view returns (bytes memory) {
300         require(isContract(target), "Address: static call to non-contract");
301 
302         (bool success, bytes memory returndata) = target.staticcall(data);
303         return _verifyCallResult(success, returndata, errorMessage);
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
308      * but performing a delegate call.
309      *
310      * _Available since v3.4._
311      */
312     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
313         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
318      * but performing a delegate call.
319      *
320      * _Available since v3.4._
321      */
322     function functionDelegateCall(
323         address target,
324         bytes memory data,
325         string memory errorMessage
326     ) internal returns (bytes memory) {
327         require(isContract(target), "Address: delegate call to non-contract");
328 
329         (bool success, bytes memory returndata) = target.delegatecall(data);
330         return _verifyCallResult(success, returndata, errorMessage);
331     }
332 
333     function _verifyCallResult(
334         bool success,
335         bytes memory returndata,
336         string memory errorMessage
337     ) private pure returns (bytes memory) {
338         if (success) {
339             return returndata;
340         } else {
341             // Look for revert reason and bubble it up if present
342             if (returndata.length > 0) {
343                 // The easiest way to bubble the revert reason is using memory via assembly
344 
345                 assembly {
346                     let returndata_size := mload(returndata)
347                     revert(add(32, returndata), returndata_size)
348                 }
349             } else {
350                 revert(errorMessage);
351             }
352         }
353     }
354 }
355 
356 abstract contract Context {
357     function _msgSender() internal view virtual returns (address) {
358         return msg.sender;
359     }
360 
361     function _msgData() internal view virtual returns (bytes calldata) {
362         return msg.data;
363     }
364 }
365 
366 abstract contract Ownable is Context {
367     address private _owner;
368 
369     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
370 
371     /**
372      * @dev Initializes the contract setting the deployer as the initial owner.
373      */
374     constructor() {
375         _setOwner(_msgSender());
376     }
377 
378     /**
379      * @dev Returns the address of the current owner.
380      */
381     function owner() public view virtual returns (address) {
382         return _owner;
383     }
384 
385     /**
386      * @dev Throws if called by any account other than the owner.
387      */
388     modifier onlyOwner() {
389         require(owner() == _msgSender(), "Ownable: caller is not the owner");
390         _;
391     }
392 
393     /**
394      * @dev Leaves the contract without owner. It will not be possible to call
395      * `onlyOwner` functions anymore. Can only be called by the current owner.
396      *
397      * NOTE: Renouncing ownership will leave the contract without an owner,
398      * thereby removing any functionality that is only available to the owner.
399      */
400     function renounceOwnership() public virtual onlyOwner {
401         _setOwner(address(0));
402     }
403 
404     /**
405      * @dev Transfers ownership of the contract to a new account (`newOwner`).
406      * Can only be called by the current owner.
407      */
408     function transferOwnership(address newOwner) public virtual onlyOwner {
409         require(newOwner != address(0), "Ownable: new owner is the zero address");
410         _setOwner(newOwner);
411     }
412 
413     function _setOwner(address newOwner) private {
414         address oldOwner = _owner;
415         _owner = newOwner;
416         emit OwnershipTransferred(oldOwner, newOwner);
417     }
418 }
419 
420 abstract contract Functional {
421     function toString(uint256 value) internal pure returns (string memory) {
422         if (value == 0) {
423             return "0";
424         }
425         uint256 temp = value;
426         uint256 digits;
427         while (temp != 0) {
428             digits++;
429             temp /= 10;
430         }
431         bytes memory buffer = new bytes(digits);
432         while (value != 0) {
433             digits -= 1;
434             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
435             value /= 10;
436         }
437         return string(buffer);
438     }
439     
440     bool private _reentryKey = false;
441     modifier reentryLock {
442         require(!_reentryKey, "attempt to reenter a locked function");
443         _reentryKey = true;
444         _;
445         _reentryKey = false;
446     }
447 }
448 
449 // ******************************************************************************************************************************
450 // **************************************************  Start of Main Contract ***************************************************
451 // ******************************************************************************************************************************
452 
453 contract Booble is IERC721, Ownable, Functional {
454 
455     using Address for address;
456     
457     // Token name
458     string private _name;
459 
460     // Token symbol
461     string private _symbol;
462     
463     // URI Root Location for Json Files
464     string private _baseURI;
465 
466     // Mapping from token ID to owner address
467     mapping(uint256 => address) private _owners;
468 
469     // Mapping owner address to token count
470     mapping(address => uint256) private _balances;
471 
472     // Mapping from token ID to approved address
473     mapping(uint256 => address) private _tokenApprovals;
474 
475     // Mapping from owner to operator approvals
476     mapping(address => mapping(address => bool)) private _operatorApprovals;
477     
478     // Specific Functionality
479     bool public mintActive;
480     bool private _hideTokens;  //for URI redirects
481     uint256 public price;
482     uint256 public pricePublic;
483     uint256 public totalTokens;
484     uint256 public numberMinted;
485     uint256 public maxPerTxn;
486     uint256 public reservedTokens;
487     uint256 public discountPrice;
488     uint256 public freeMinted;
489     bool public sendOnContract;
490 
491     address contractor      = payable(0x2E07cd18E675c921E8c523E36D79788734E94f88); //5
492     address toronto         = payable(0x9618AA6B6BF62a3DBEC457e8792C372673a3c5c3); //15
493     address doxxed          = payable(0xC1FDc68dc63d3316F32420d4d2c3DeA43091bCDD); //80
494 
495     /**
496      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
497      */
498     constructor() {
499         _name = "Boobles";
500         _symbol = "BNFT";
501         _baseURI = "https://boobles.io/metadata/";
502         _hideTokens = true;
503         
504         totalTokens = 8008; // 0-9999   
505         price = 15 * (10 ** 15);
506         maxPerTxn = 50;
507     }
508 
509     //@dev See {IERC165-supportsInterface}. Interfaces Supported by this Standard
510     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
511         return  interfaceId == type(IERC721).interfaceId ||
512                 interfaceId == type(IERC721Metadata).interfaceId ||
513                 interfaceId == type(IERC165).interfaceId ||
514                 interfaceId == Booble.onERC721Received.selector;
515     }
516     
517     // Standard Withdraw function for the owner to pull the contract
518     function withdraw() external onlyOwner {
519         uint256 sendAmount = address(this).balance;
520 
521         bool success;
522         (success, ) = contractor.call{value: ((sendAmount * 5)/100)}("");
523         require(success, "Transaction Unsuccessful");
524         
525         (success, ) = toronto.call{value: ((sendAmount * 15)/100)}("");
526         require(success, "Transaction Unsuccessful");
527         
528         (success, ) = doxxed.call{value: ((sendAmount * 80)/100)}("");
529         require(success, "Transaction Unsuccessful");
530         
531      }
532     
533     function ownerMint(address _to, uint256 qty) external onlyOwner {
534         require((numberMinted + qty) > numberMinted, "Math overflow error");
535         require((numberMinted + qty) < totalTokens, "Cannot fill order");
536         
537         uint256 mintSeedValue = numberMinted; //Store the starting value of the mint batch
538         
539         for(uint256 i = 0; i < qty; i++) {
540             _safeMint(_to, mintSeedValue + i);
541             numberMinted ++;  //reservedTokens can be reset, numberMinted can not
542         }
543     }
544 
545     /*Function to mint token with 0 ETH price utpo 499*/
546 
547     function FreeMint() external reentryLock {
548         require(mintActive, "Mint is not Active");
549         require(freeMinted < 250, "Free Mints Sold Out");
550         require(numberMinted < totalTokens, "Collection Sold Out");
551 
552         uint256 mintSeedValue = numberMinted;
553         numberMinted += 1;
554         freeMinted += 1;
555 
556         _safeMint(_msgSender(), mintSeedValue );
557     }
558 
559     /* 0.015 for everyone */
560     
561     function publicMint(uint256 qty) external payable reentryLock {
562         require(totalTokens >= qty + numberMinted, "sold out");
563         require(qty <= maxPerTxn, "max 50 per txn");
564         require(mintActive, "Mint is not Active");
565         require(msg.value == qty * price, "Wrong Eth Amount");
566         
567         uint256 mintSeedValue = numberMinted;
568         numberMinted += qty;
569         
570         for(uint256 i = 0; i < qty; i++) {
571             _safeMint(_msgSender(), mintSeedValue + i);
572         }
573        
574     }
575      
576     //////////////////////////////////////////////////////////////
577     //////////////////// Setters and Getters /////////////////////
578     //////////////////////////////////////////////////////////////
579     
580     function setDiscountPrice(uint256 newPrice) external onlyOwner {
581         discountPrice = newPrice;
582     }
583 
584     function setBaseURI(string memory newURI) public onlyOwner {
585         _baseURI = newURI;
586     }
587     
588     function activateMint() public onlyOwner {
589         mintActive = true;
590     }
591     
592     function deactivateMint() public onlyOwner {
593         mintActive = false;
594     }
595     
596     function setPrice(uint256 newPrice) public onlyOwner {
597         price = newPrice;
598     }
599     
600     function setTotalTokens(uint256 numTokens) public onlyOwner {
601         totalTokens = numTokens;
602     }
603 
604     function totalSupply() external view returns (uint256) {
605         return numberMinted; //stupid bs for etherscan's call
606     }
607     
608     function hideTokens() external onlyOwner {
609         _hideTokens = true;
610     }
611     
612     function revealTokens() external onlyOwner {
613         _hideTokens = false;
614     }
615     
616     function getBalance(address tokenAddress) view external returns (uint256) {
617         //return _balances[tokenAddress]; //shows 0 on etherscan due to overflow error
618         return _balances[tokenAddress] / (10**15); //temporary fix to report in finneys
619     }
620 
621     /**
622      * @dev See {IERC721-balanceOf}.
623      */
624     function balanceOf(address owner) public view virtual override returns (uint256) {
625         require(owner != address(0), "ERC721: balance query for the zero address");
626         return _balances[owner];
627     }
628 
629     /**
630      * @dev See {IERC721-ownerOf}.
631      */
632     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
633         address owner = _owners[tokenId];
634         require(owner != address(0), "ERC721: owner query for nonexistent token");
635         return owner;
636     }
637 
638     /**
639      * @dev See {IERC721-approve}.
640      */
641     function approve(address to, uint256 tokenId) public virtual override {
642         address owner = ownerOf(tokenId);
643         require(to != owner, "ERC721: approval to current owner");
644 
645         require(
646             msg.sender == owner || isApprovedForAll(owner, msg.sender),
647             "ERC721: approve caller is not owner nor approved for all"
648         );
649 
650         _approve(to, tokenId);
651     }
652 
653     /**
654      * @dev See {IERC721-getApproved}.
655      */
656     function getApproved(uint256 tokenId) public view virtual override returns (address) {
657         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
658 
659         return _tokenApprovals[tokenId];
660     }
661 
662     /**
663      * @dev See {IERC721-setApprovalForAll}.
664      */
665     function setApprovalForAll(address operator, bool approved) public virtual override {
666         require(operator != msg.sender, "ERC721: approve to caller");
667 
668         _operatorApprovals[msg.sender][operator] = approved;
669         emit ApprovalForAll(msg.sender, operator, approved);
670     }
671 
672     /**
673      * @dev See {IERC721-isApprovedForAll}.
674      */
675     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
676         return _operatorApprovals[owner][operator];
677     }
678 
679     /**
680      * @dev See {IERC721-transferFrom}.
681      */
682     function transferFrom(
683         address from,
684         address to,
685         uint256 tokenId
686     ) public virtual override {
687         //solhint-disable-next-line max-line-length
688         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
689 
690         _transfer(from, to, tokenId);
691     }
692 
693     /**
694      * @dev See {IERC721-safeTransferFrom}.
695      */
696     function safeTransferFrom(
697         address from,
698         address to,
699         uint256 tokenId
700     ) public virtual override {
701         safeTransferFrom(from, to, tokenId, "");
702     }
703 
704     /**
705      * @dev See {IERC721-safeTransferFrom}.
706      */
707     function safeTransferFrom(
708         address from,
709         address to,
710         uint256 tokenId,
711         bytes memory _data
712     ) public virtual override {
713         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
714         _safeTransfer(from, to, tokenId, _data);
715     }
716 
717     /**
718      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
719      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
720      *
721      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
722      *
723      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
724      * implement alternative mechanisms to perform token transfer, such as signature-based.
725      *
726      * Requirements:
727      *
728      * - `from` cannot be the zero address.
729      * - `to` cannot be the zero address.
730      * - `tokenId` token must exist and be owned by `from`.
731      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
732      *
733      * Emits a {Transfer} event.
734      */
735     function _safeTransfer(
736         address from,
737         address to,
738         uint256 tokenId,
739         bytes memory _data
740     ) internal virtual {
741         _transfer(from, to, tokenId);
742         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
743     }
744 
745     /**
746      * @dev Returns whether `tokenId` exists.
747      *
748      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
749      *
750      * Tokens start existing when they are minted (`_mint`),
751      * and stop existing when they are burned (`_burn`).
752      */
753     function _exists(uint256 tokenId) internal view virtual returns (bool) {
754         return _owners[tokenId] != address(0);
755     }
756 
757     /**
758      * @dev Returns whether `spender` is allowed to manage `tokenId`.
759      *
760      * Requirements:
761      *
762      * - `tokenId` must exist.
763      */
764     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
765         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
766         address owner = ownerOf(tokenId);
767         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
768     }
769 
770     /**
771      * @dev Safely mints `tokenId` and transfers it to `to`.
772      *
773      * Requirements:
774      *
775      * - `tokenId` must not exist.
776      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
777      *
778      * Emits a {Transfer} event.
779      */
780     function _safeMint(address to, uint256 tokenId) internal virtual {
781         _safeMint(to, tokenId, "");
782     }
783 
784     /**
785      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
786      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
787      */
788     function _safeMint(
789         address to,
790         uint256 tokenId,
791         bytes memory _data
792     ) internal virtual {
793         _mint(to, tokenId);
794         require(
795             _checkOnERC721Received(address(0), to, tokenId, _data),
796             "ERC721: transfer to non ERC721Receiver implementer"
797         );
798     }
799 
800     /**
801      * @dev Mints `tokenId` and transfers it to `to`.
802      *
803      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
804      *
805      * Requirements:
806      *
807      * - `tokenId` must not exist.
808      * - `to` cannot be the zero address.
809      *
810      * Emits a {Transfer} event.
811      */
812     function _mint(address to, uint256 tokenId) internal virtual {
813         require(to != address(0), "ERC721: mint to the zero address");
814         require(!_exists(tokenId), "ERC721: token already minted");
815 
816         _beforeTokenTransfer(address(0), to, tokenId);
817 
818         _balances[to] += 1;
819         _owners[tokenId] = to;
820 
821         emit Transfer(address(0), to, tokenId);
822     }
823 
824     /**
825      * @dev Destroys `tokenId`.
826      * The approval is cleared when the token is burned.
827      *
828      * Requirements:
829      *
830      * - `tokenId` must exist.
831      *
832      * Emits a {Transfer} event.
833      */
834     function _burn(uint256 tokenId) internal virtual {
835         address owner = ownerOf(tokenId);
836 
837         _beforeTokenTransfer(owner, address(0), tokenId);
838 
839         // Clear approvals
840         _approve(address(0), tokenId);
841 
842         _balances[owner] -= 1;
843         delete _owners[tokenId];
844 
845         emit Transfer(owner, address(0), tokenId);
846     }
847 
848     /**
849      * @dev Transfers `tokenId` from `from` to `to`.
850      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
851      *
852      * Requirements:
853      *
854      * - `to` cannot be the zero address.
855      * - `tokenId` token must be owned by `from`.
856      *
857      * Emits a {Transfer} event.
858      */
859     function _transfer(
860         address from,
861         address to,
862         uint256 tokenId
863     ) internal virtual {
864         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
865         require(to != address(0), "ERC721: transfer to the zero address");
866 
867         _beforeTokenTransfer(from, to, tokenId);
868 
869         // Clear approvals from the previous owner
870         _approve(address(0), tokenId);
871 
872         _balances[from] -= 1;
873         _balances[to] += 1;
874         _owners[tokenId] = to;
875 
876         emit Transfer(from, to, tokenId);
877     }
878 
879     /**
880      * @dev Approve `to` to operate on `tokenId`
881      *
882      * Emits a {Approval} event.
883      */
884     function _approve(address to, uint256 tokenId) internal virtual {
885         _tokenApprovals[tokenId] = to;
886         emit Approval(ownerOf(tokenId), to, tokenId);
887     }
888 
889     /**
890      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
891      * The call is not executed if the target address is not a contract.
892      *
893      * @param from address representing the previous owner of the given token ID
894      * @param to target address that will receive the tokens
895      * @param tokenId uint256 ID of the token to be transferred
896      * @param _data bytes optional data to send along with the call
897      * @return bool whether the call correctly returned the expected magic value
898      */
899     function _checkOnERC721Received(
900         address from,
901         address to,
902         uint256 tokenId,
903         bytes memory _data
904     ) private returns (bool) {
905         if (to.isContract()) {
906             try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
907                 sendOnContract = true;
908                 return retval == IERC721Receiver(to).onERC721Received.selector;
909             } catch (bytes memory reason) {
910                 if (reason.length == 0) {
911                     revert("ERC721: transfer to non ERC721Receiver implementer");
912                 } else {
913                     assembly {
914                         revert(add(32, reason), mload(reason))
915                     }
916                 }
917             }
918         } else {
919             return true;
920         }
921     }
922     
923     // *********************** ERC721 Token Receiver **********************
924     /**
925      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
926      * by `operator` from `from`, this function is called.
927      *
928      * It must return its Solidity selector to confirm the token transfer.
929      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
930      *
931      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
932      */
933     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4) {
934         //InterfaceID=0x150b7a02
935         return this.onERC721Received.selector;
936     }
937 
938     /**
939      * @dev Hook that is called before any token transfer. This includes minting
940      * and burning.
941      *
942      * Calling conditions:
943      *
944      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
945      * transferred to `to`.
946      * - When `from` is zero, `tokenId` will be minted for `to`.
947      * - When `to` is zero, ``from``'s `tokenId` will be burned.
948      * - `from` and `to` are never both zero.
949      *
950      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
951      */
952     function _beforeTokenTransfer(
953         address from,
954         address to,
955         uint256 tokenId
956     ) internal virtual {}
957 
958     // **************************************** Metadata Standard Functions **********
959     //@dev Returns the token collection name.
960     function name() external view returns (string memory){
961         return _name;
962     }
963 
964     //@dev Returns the token collection symbol.
965     function symbol() external view returns (string memory){
966         return _symbol;
967     }
968 
969     //@dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
970     function tokenURI(uint256 tokenId) external view returns (string memory){
971         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
972         
973         string memory tokenuri;
974         
975         if (_hideTokens) {
976             //redirect to mystery box
977             tokenuri = string(abi.encodePacked(_baseURI, "mystery.json"));
978         } else {
979             //Input flag data here to send to reveal URI
980             tokenuri = string(abi.encodePacked(_baseURI, toString(tokenId), ".json")); /// 0.json 135.json
981         }
982         
983         return tokenuri;
984     }
985     
986     function contractURI() public view returns (string memory) {
987             return string(abi.encodePacked(_baseURI,"contract.json"));
988     }
989     // *******************************************************************************
990 
991     receive() external payable {}
992     
993     fallback() external payable {}
994 }