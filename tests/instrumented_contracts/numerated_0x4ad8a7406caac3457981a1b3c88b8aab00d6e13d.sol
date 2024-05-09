1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /*
6     Fully commented standard ERC721 Distilled from OpenZeppelin Docs
7     Base for Building ERC721 by Martin McConnell
8     All the utility without the fluff.
9 */
10 
11 
12 interface IERC165 {
13     function supportsInterface(bytes4 interfaceId) external view returns (bool);
14 }
15 
16 interface IERC721 is IERC165 {
17     //@dev Emitted when `tokenId` token is transferred from `from` to `to`.
18     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
19 
20     //@dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
21     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
22 
23     //@dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
24     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
25 
26     //@dev Returns the number of tokens in ``owner``'s account.
27     function balanceOf(address owner) external view returns (uint256 balance);
28 
29     /**
30      * @dev Returns the owner of the `tokenId` token.
31      *
32      * Requirements:
33      *
34      * - `tokenId` must exist.
35      */
36     function ownerOf(uint256 tokenId) external view returns (address owner);
37 
38     /**
39      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
40      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
41      *
42      * Requirements:
43      *
44      * - `from` cannot be the zero address.
45      * - `to` cannot be the zero address.
46      * - `tokenId` token must exist and be owned by `from`.
47      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
48      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
49      *
50      * Emits a {Transfer} event.
51      */
52     function safeTransferFrom(address from,address to,uint256 tokenId) external;
53 
54     /**
55      * @dev Transfers `tokenId` token from `from` to `to`.
56      *
57      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
58      *
59      * Requirements:
60      *
61      * - `from` cannot be the zero address.
62      * - `to` cannot be the zero address.
63      * - `tokenId` token must be owned by `from`.
64      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(address from, address to, uint256 tokenId) external;
69 
70     /**
71      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
72      * The approval is cleared when the token is transferred.
73      *
74      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
75      *
76      * Requirements:
77      *
78      * - The caller must own the token or be an approved operator.
79      * - `tokenId` must exist.
80      *
81      * Emits an {Approval} event.
82      */
83     function approve(address to, uint256 tokenId) external;
84 
85     /**
86      * @dev Returns the account approved for `tokenId` token.
87      *
88      * Requirements:
89      *
90      * - `tokenId` must exist.
91      */
92     function getApproved(uint256 tokenId) external view returns (address operator);
93 
94     /**
95      * @dev Approve or remove `operator` as an operator for the caller.
96      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
97      *
98      * Requirements:
99      * - The `operator` cannot be the caller.
100      *
101      * Emits an {ApprovalForAll} event.
102      */
103     function setApprovalForAll(address operator, bool _approved) external;
104 
105     //@dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
106     function isApprovedForAll(address owner, address operator) external view returns (bool);
107 
108     /**
109      * @dev Safely transfers `tokenId` token from `from` to `to`.
110      *
111      * Requirements:
112      *
113      * - `from` cannot be the zero address.
114      * - `to` cannot be the zero address.
115      * - `tokenId` token must exist and be owned by `from`.
116      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
117      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
118      *
119      * Emits a {Transfer} event.
120      */
121     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
122 }
123 
124 interface IERC721Metadata is IERC721 {
125     //@dev Returns the token collection name.
126     function name() external view returns (string memory);
127 
128     //@dev Returns the token collection symbol.
129     function symbol() external view returns (string memory);
130 
131     //@dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
132     function tokenURI(uint256 tokenId) external view returns (string memory);
133 }
134 
135 interface IERC721Receiver {
136     /**
137      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
138      * by `operator` from `from`, this function is called.
139      *
140      * It must return its Solidity selector to confirm the token transfer.
141      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
142      *
143      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
144      */
145     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
146 }
147 
148 library Address {
149     /**
150      * @dev Returns true if `account` is a contract.
151      *
152      * [IMPORTANT]
153      * ====
154      * It is unsafe to assume that an address for which this function returns
155      * false is an externally-owned account (EOA) and not a contract.
156      *
157      * Among others, `isContract` will return false for the following
158      * types of addresses:
159      *
160      *  - an externally-owned account
161      *  - a contract in construction
162      *  - an address where a contract will be created
163      *  - an address where a contract lived, but was destroyed
164      * ====
165      */
166     function isContract(address account) internal view returns (bool) {
167         // This method relies on extcodesize, which returns 0 for contracts in
168         // construction, since the code is only stored at the end of the
169         // constructor execution.
170 
171         uint256 size;
172         assembly {
173             size := extcodesize(account)
174         }
175         return size > 0;
176     }
177 
178     /**
179      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
180      * `recipient`, forwarding all available gas and reverting on errors.
181      *
182      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
183      * of certain opcodes, possibly making contracts go over the 2300 gas limit
184      * imposed by `transfer`, making them unable to receive funds via
185      * `transfer`. {sendValue} removes this limitation.
186      *
187      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
188      *
189      * IMPORTANT: because control is transferred to `recipient`, care must be
190      * taken to not create reentrancy vulnerabilities. Consider using
191      * {ReentrancyGuard} or the
192      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
193      */
194     function sendValue(address payable recipient, uint256 amount) internal {
195         require(address(this).balance >= amount, "Address: insufficient balance");
196 
197         (bool success, ) = recipient.call{value: amount}("");
198         require(success, "Addr: cant send val, rcpt revert");
199     }
200 
201     /**
202      * @dev Performs a Solidity function call using a low level `call`. A
203      * plain `call` is an unsafe replacement for a function call: use this
204      * function instead.
205      *
206      * If `target` reverts with a revert reason, it is bubbled up by this
207      * function (like regular Solidity function calls).
208      *
209      * Returns the raw returned data. To convert to the expected return value,
210      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
211      *
212      * Requirements:
213      *
214      * - `target` must be a contract.
215      * - calling `target` with `data` must not revert.
216      *
217      * _Available since v3.1._
218      */
219     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
220         return functionCall(target, data, "Address: low-level call failed");
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
225      * `errorMessage` as a fallback revert reason when `target` reverts.
226      *
227      * _Available since v3.1._
228      */
229     function functionCall(
230         address target,
231         bytes memory data,
232         string memory errorMessage
233     ) internal returns (bytes memory) {
234         return functionCallWithValue(target, data, 0, errorMessage);
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
239      * but also transferring `value` wei to `target`.
240      *
241      * Requirements:
242      *
243      * - the calling contract must have an ETH balance of at least `value`.
244      * - the called Solidity function must be `payable`.
245      *
246      * _Available since v3.1._
247      */
248     function functionCallWithValue(
249         address target,
250         bytes memory data,
251         uint256 value
252     ) internal returns (bytes memory) {
253         return functionCallWithValue(target, data, value, "Addr: low-level call value fail");
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
258      * with `errorMessage` as a fallback revert reason when `target` reverts.
259      *
260      * _Available since v3.1._
261      */
262     function functionCallWithValue(
263         address target,
264         bytes memory data,
265         uint256 value,
266         string memory errorMessage
267     ) internal returns (bytes memory) {
268         require(address(this).balance >= value, "Addr: insufficient balance call");
269         require(isContract(target), "Address: call to non-contract");
270 
271         (bool success, bytes memory returndata) = target.call{value: value}(data);
272         return _verifyCallResult(success, returndata, errorMessage);
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
277      * but performing a static call.
278      *
279      * _Available since v3.3._
280      */
281     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
282         return functionStaticCall(target, data, "Addr: low-level static call fail");
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
287      * but performing a static call.
288      *
289      * _Available since v3.3._
290      */
291     function functionStaticCall(
292         address target,
293         bytes memory data,
294         string memory errorMessage
295     ) internal view returns (bytes memory) {
296         require(isContract(target), "Addr: static call non-contract");
297 
298         (bool success, bytes memory returndata) = target.staticcall(data);
299         return _verifyCallResult(success, returndata, errorMessage);
300     }
301 
302     /**
303      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
304      * but performing a delegate call.
305      *
306      * _Available since v3.4._
307      */
308     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
309         return functionDelegateCall(target, data, "Addr: low-level del call failed");
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
314      * but performing a delegate call.
315      *
316      * _Available since v3.4._
317      */
318     function functionDelegateCall(
319         address target,
320         bytes memory data,
321         string memory errorMessage
322     ) internal returns (bytes memory) {
323         require(isContract(target), "Addr: delegate call non-contract");
324 
325         (bool success, bytes memory returndata) = target.delegatecall(data);
326         return _verifyCallResult(success, returndata, errorMessage);
327     }
328 
329     function _verifyCallResult(
330         bool success,
331         bytes memory returndata,
332         string memory errorMessage
333     ) private pure returns (bytes memory) {
334         if (success) {
335             return returndata;
336         } else {
337             // Look for revert reason and bubble it up if present
338             if (returndata.length > 0) {
339                 // The easiest way to bubble the revert reason is using memory via assembly
340 
341                 assembly {
342                     let returndata_size := mload(returndata)
343                     revert(add(32, returndata), returndata_size)
344                 }
345             } else {
346                 revert(errorMessage);
347             }
348         }
349     }
350 }
351 
352 abstract contract Context {
353     function _msgSender() internal view virtual returns (address) {
354         return msg.sender;
355     }
356 
357     function _msgData() internal view virtual returns (bytes calldata) {
358         return msg.data;
359     }
360 }
361 
362 abstract contract Ownable is Context {
363     address private _owner;
364 
365     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
366 
367     /**
368      * @dev Initializes the contract setting the deployer as the initial owner.
369      */
370     constructor() {
371         _setOwner(_msgSender());
372     }
373 
374     /**
375      * @dev Returns the address of the current owner.
376      */
377     function owner() public view virtual returns (address) {
378         return _owner;
379     }
380 
381     /**
382      * @dev Throws if called by any account other than the owner.
383      */
384     modifier onlyOwner() {
385         require(owner() == _msgSender(), "Ownable: caller is not the owner");
386         _;
387     }
388 
389     /**
390      * @dev Leaves the contract without owner. It will not be possible to call
391      * `onlyOwner` functions anymore. Can only be called by the current owner.
392      *
393      * NOTE: Renouncing ownership will leave the contract without an owner,
394      * thereby removing any functionality that is only available to the owner.
395      */
396     function renounceOwnership() public virtual onlyOwner {
397         _setOwner(address(0));
398     }
399 
400     /**
401      * @dev Transfers ownership of the contract to a new account (`newOwner`).
402      * Can only be called by the current owner.
403      */
404     function transferOwnership(address newOwner) public virtual onlyOwner {
405         require(newOwner != address(0), "Ownable: new owner is 0x address");
406         _setOwner(newOwner);
407     }
408 
409     function _setOwner(address newOwner) private {
410         address oldOwner = _owner;
411         _owner = newOwner;
412         emit OwnershipTransferred(oldOwner, newOwner);
413     }
414 }
415 
416 abstract contract Functional {
417     function toString(uint256 value) internal pure returns (string memory) {
418         if (value == 0) {
419             return "0";
420         }
421         uint256 temp = value;
422         uint256 digits;
423         while (temp != 0) {
424             digits++;
425             temp /= 10;
426         }
427         bytes memory buffer = new bytes(digits);
428         while (value != 0) {
429             digits -= 1;
430             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
431             value /= 10;
432         }
433         return string(buffer);
434     }
435     
436     bool private _reentryKey = false;
437     modifier reentryLock {
438         require(!_reentryKey, "attempt reenter locked function");
439         _reentryKey = true;
440         _;
441         _reentryKey = false;
442     }
443 }
444 
445 abstract contract Proxy is Ownable {
446     mapping(address => bool) private _isProxy;
447 
448     constructor() {
449         _isProxy[_msgSender()] = true;
450     }
451 
452     function assignProxy(address newProxy) external onlyOwner {
453         _isProxy[newProxy] = true;
454     }
455 
456     function revokeProxy(address badProxy) external onlyOwner {
457         _isProxy[badProxy] = false;
458     }
459 
460     function isProxy(address checkProxy) external view returns (bool) {
461         return _isProxy[checkProxy];
462     }
463 
464     modifier proxyAccess {
465         require(_isProxy[_msgSender()]);
466         _;
467     }
468 }
469 
470 // ******************************************************************************************************************************
471 // **************************************************  Start of Main Contract ***************************************************
472 // ******************************************************************************************************************************
473 
474 contract nftPandemic is IERC721, Proxy, Functional {
475 
476     using Address for address;
477     
478     // Token name
479     string private _name;
480 
481     // Token symbol
482     string private _symbol;
483     
484     // URI Root Location for Json Files
485     string private _baseURI;
486 
487     // Mapping from token ID to owner address
488     mapping(uint256 => address) private _owners;
489 
490     // Mapping owner address to token count
491     mapping(address => uint256) private _balances;
492 
493     // Mapping from token ID to approved address
494     mapping(uint256 => address) private _tokenApprovals;
495 
496     // Mapping from owner to operator approvals
497     mapping(address => mapping(address => bool)) private _operatorApprovals;
498     
499     // Specific Functionality
500     bool public mintActive;
501     uint256 private _revealTokens;  //for URI redirects
502     uint256 public price;
503     uint256 public totalTokens;
504     uint256 public numberMinted;
505     uint256 public maxPerWallet;
506     
507     mapping(address => uint256) private _mintTracker;
508 
509     /**
510      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
511      */
512     constructor() {
513         _name = "nftPandemic";
514         _symbol = "VIRUS";
515         _baseURI = "https://nftpandemic.io/metadata/";
516         
517         totalTokens = 6666;
518         price = 1 * (10 ** 15); // Replace leading value with price in finney
519 
520         maxPerWallet = 100;
521     }
522 
523     //@dev See {IERC165-supportsInterface}. Interfaces Supported by this Standard
524     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
525         return  interfaceId == type(IERC721).interfaceId ||
526                 interfaceId == type(IERC721Metadata).interfaceId ||
527                 interfaceId == type(IERC165).interfaceId ||
528                 interfaceId == nftPandemic.onERC721Received.selector;
529     }
530     
531     // Standard Withdraw function for the owner to pull the contract
532     function withdraw() external onlyOwner {
533         uint256 sendAmount = address(this).balance;
534         (bool success, ) = msg.sender.call{value: sendAmount}("");
535         require(success, "Transaction Unsuccessful");
536     }
537     
538     function ownerMint(address _to, uint256 qty) external onlyOwner {
539         require((numberMinted + qty) <= totalTokens, "Cannot fill order");
540         
541         uint256 mintSeedValue = numberMinted; //Store the starting value of the mint batch
542         numberMinted += qty;
543         
544         for(uint256 i = 0; i < qty; i++) {
545             _safeMint(_to, mintSeedValue + i);
546         }
547     }
548     
549     function airDrop(address[] memory _to) external onlyOwner {
550         uint256 qty = _to.length;
551         require((numberMinted + qty) <= totalTokens, "Cannot fill order");
552         
553         uint256 mintSeedValue = numberMinted;
554 		numberMinted += qty;
555         
556         for(uint256 i = 0; i < qty; i++) {
557             _safeMint(_to[i], mintSeedValue + i);
558         }
559     }
560     
561     function mint() external payable reentryLock {
562         address _to = _msgSender();
563         require(mintActive, "NOt OPen");
564         require(msg.value >= price, "Mint: Insufficient Funds");
565         require((2 + numberMinted) <= totalTokens, "Mint: Not enough avaialable");
566         require((_mintTracker[_to] + 2) <= maxPerWallet, "Mint: Max tkn per wallet exceeded");
567         
568         uint256 mintSeedValue = numberMinted; //Store the starting value of the mint batch
569         _mintTracker[_to] += 2;
570         numberMinted += 2;
571 
572         _safeMint(_to, mintSeedValue);
573         _safeMint(_to, mintSeedValue + 1);
574     }
575     
576     // allows holders to burn their own tokens if desired
577     function burn(uint256 tokenID) external {
578         require(_msgSender() == ownerOf(tokenID));
579         _burn(tokenID);
580     }
581     
582     //////////////////////////////////////////////////////////////
583     //////////////////// Setters and Getters /////////////////////
584     //////////////////////////////////////////////////////////////
585 
586     
587     function setMaxWalletThreshold(uint256 maxWallet) external onlyOwner {
588         maxPerWallet = maxWallet;
589     }
590     
591     function setBaseURI(string memory newURI) public onlyOwner {
592         _baseURI = newURI;
593     }
594     
595     function activateMint() public onlyOwner {
596         mintActive = true;
597     }
598     
599     function deactivateMint() public onlyOwner {
600         mintActive = false;
601     }
602     
603     function setPrice(uint256 newPrice) public onlyOwner {
604         price = newPrice;
605     }
606     
607     function setTotalTokens(uint256 numTokens) public onlyOwner {
608         totalTokens = numTokens;
609     }
610 
611     function totalSupply() external view returns (uint256) {
612         return numberMinted; //stupid bs for etherscan's call
613     }
614     
615     function revealTokens(uint256 numtoreveal) external onlyOwner {
616         _revealTokens = numtoreveal;
617     }
618 
619     /// Proxy functions for future extension contracts to save gas and make things interactive
620     function proxyMint(address to, uint256 tokenId) external proxyAccess {
621     	_safeMint(to, tokenId);
622     	numberMinted += 1;
623     }
624     
625     function proxyBurn(uint256 tokenId) external proxyAccess {
626     	_burn(tokenId);
627     	numberMinted -= 1;
628     }
629     
630     function proxyTransfer(address from, address to, uint256 tokenId) external proxyAccess {
631     	_transfer(from, to, tokenId);
632     }
633 
634     /**
635      * @dev See {IERC721-balanceOf}.
636      */
637     function balanceOf(address owner) public view virtual override returns (uint256) {
638         require(owner != address(0), "ERC721: bal qry for zero address");
639         return _balances[owner];
640     }
641 
642     /**
643      * @dev See {IERC721-ownerOf}.
644      */
645     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
646         address owner = _owners[tokenId];
647         require(owner != address(0), "ERC721: own query nonexist tkn");
648         return owner;
649     }
650 
651     /**
652      * @dev See {IERC721-approve}.
653      */
654     function approve(address to, uint256 tokenId) public virtual override {
655         address owner = ownerOf(tokenId);
656         require(to != owner, "ERC721: approval current owner");
657 
658         require(
659             msg.sender == owner || isApprovedForAll(owner, msg.sender),
660             "ERC721: caller !owner/!approved"
661         );
662 
663         _approve(to, tokenId);
664     }
665 
666     /**
667      * @dev See {IERC721-getApproved}.
668      */
669     function getApproved(uint256 tokenId) public view virtual override returns (address) {
670         require(_exists(tokenId), "ERC721: approved nonexistent tkn");
671         return _tokenApprovals[tokenId];
672     }
673 
674     /**
675      * @dev See {IERC721-setApprovalForAll}.
676      */
677     function setApprovalForAll(address operator, bool approved) public virtual override {
678         require(operator != msg.sender, "ERC721: approve to caller");
679 
680         _operatorApprovals[msg.sender][operator] = approved;
681         emit ApprovalForAll(msg.sender, operator, approved);
682     }
683 
684     /**
685      * @dev See {IERC721-isApprovedForAll}.
686      */
687     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
688         return _operatorApprovals[owner][operator];
689     }
690 
691     /**
692      * @dev See {IERC721-transferFrom}.
693      */
694     function transferFrom(
695         address from,
696         address to,
697         uint256 tokenId
698     ) public virtual override {
699         //solhint-disable-next-line max-line-length
700         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: txfr !owner/approved");
701         _transfer(from, to, tokenId);
702     }
703 
704     /**
705      * @dev See {IERC721-safeTransferFrom}.
706      */
707     function safeTransferFrom(
708         address from,
709         address to,
710         uint256 tokenId
711     ) public virtual override {
712         safeTransferFrom(from, to, tokenId, "");
713     }
714 
715     /**
716      * @dev See {IERC721-safeTransferFrom}.
717      */
718     function safeTransferFrom(
719         address from,
720         address to,
721         uint256 tokenId,
722         bytes memory _data
723     ) public virtual override {
724         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: txfr !owner/approved");
725         _safeTransfer(from, to, tokenId, _data);
726     }
727 
728     /**
729      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
730      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
731      *
732      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
733      *
734      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
735      * implement alternative mechanisms to perform token transfer, such as signature-based.
736      *
737      * Requirements:
738      *
739      * - `from` cannot be the zero address.
740      * - `to` cannot be the zero address.
741      * - `tokenId` token must exist and be owned by `from`.
742      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
743      *
744      * Emits a {Transfer} event.
745      */
746     function _safeTransfer(
747         address from,
748         address to,
749         uint256 tokenId,
750         bytes memory _data
751     ) internal virtual {
752         _transfer(from, to, tokenId);
753         require(_checkOnERC721Received(from, to, tokenId, _data), "txfr to non ERC721Reciever");
754     }
755 
756     /**
757      * @dev Returns whether `tokenId` exists.
758      *
759      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
760      *
761      * Tokens start existing when they are minted (`_mint`),
762      * and stop existing when they are burned (`_burn`).
763      */
764     function _exists(uint256 tokenId) internal view virtual returns (bool) {
765         return _owners[tokenId] != address(0);
766     }
767 
768     /**
769      * @dev Returns whether `spender` is allowed to manage `tokenId`.
770      *
771      * Requirements:
772      *
773      * - `tokenId` must exist.
774      */
775     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
776         require(_exists(tokenId), "ERC721: op query nonexistent tkn");
777         address owner = ownerOf(tokenId);
778         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
779     }
780 
781     /**
782      * @dev Safely mints `tokenId` and transfers it to `to`.
783      *
784      * Requirements:
785      *
786      * - `tokenId` must not exist.
787      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
788      *
789      * Emits a {Transfer} event.
790      */
791     function _safeMint(address to, uint256 tokenId) internal virtual {
792         _safeMint(to, tokenId, "");
793     }
794 
795     /**
796      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
797      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
798      */
799     function _safeMint(
800         address to,
801         uint256 tokenId,
802         bytes memory _data
803     ) internal virtual {
804         _mint(to, tokenId);
805         require(
806             _checkOnERC721Received(address(0), to, tokenId, _data),
807             "txfr to non ERC721Reciever"
808         );
809     }
810 
811     /**
812      * @dev Mints `tokenId` and transfers it to `to`.
813      *
814      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
815      *
816      * Requirements:
817      *
818      * - `tokenId` must not exist.
819      * - `to` cannot be the zero address.
820      *
821      * Emits a {Transfer} event.
822      */
823     function _mint(address to, uint256 tokenId) internal virtual {
824         require(to != address(0), "ERC721: mint to the zero address");
825         require(!_exists(tokenId), "ERC721: token already minted");
826 
827         _beforeTokenTransfer(address(0), to, tokenId);
828 
829         _balances[to] += 1;
830         _owners[tokenId] = to;
831 
832         emit Transfer(address(0), to, tokenId);
833     }
834 
835     /**
836      * @dev Destroys `tokenId`.
837      * The approval is cleared when the token is burned.
838      *
839      * Requirements:
840      *
841      * - `tokenId` must exist.
842      *
843      * Emits a {Transfer} event.
844      */
845     function _burn(uint256 tokenId) internal virtual {
846         address owner = ownerOf(tokenId);
847 
848         _beforeTokenTransfer(owner, address(0), tokenId);
849 
850         // Clear approvals
851         _approve(address(0), tokenId);
852 
853         _balances[owner] -= 1;
854         delete _owners[tokenId];
855 
856         emit Transfer(owner, address(0), tokenId);
857     }
858 
859     /**
860      * @dev Transfers `tokenId` from `from` to `to`.
861      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
862      *
863      * Requirements:
864      *
865      * - `to` cannot be the zero address.
866      * - `tokenId` token must be owned by `from`.
867      *
868      * Emits a {Transfer} event.
869      */
870     function _transfer(
871         address from,
872         address to,
873         uint256 tokenId
874     ) internal virtual {
875         require(ownerOf(tokenId) == from, "ERC721: txfr token not owned");
876         require(to != address(0), "ERC721: txfr to 0x0 address");
877         _beforeTokenTransfer(from, to, tokenId);
878 
879         // Clear approvals from the previous owner
880         _approve(address(0), tokenId);
881 
882         _balances[from] -= 1;
883         _balances[to] += 1;
884         _owners[tokenId] = to;
885 
886         emit Transfer(from, to, tokenId);
887     }
888 
889     /**
890      * @dev Approve `to` to operate on `tokenId`
891      *
892      * Emits a {Approval} event.
893      */
894     function _approve(address to, uint256 tokenId) internal virtual {
895         _tokenApprovals[tokenId] = to;
896         emit Approval(ownerOf(tokenId), to, tokenId);
897     }
898 
899     /**
900      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
901      * The call is not executed if the target address is not a contract.
902      *
903      * @param from address representing the previous owner of the given token ID
904      * @param to target address that will receive the tokens
905      * @param tokenId uint256 ID of the token to be transferred
906      * @param _data bytes optional data to send along with the call
907      * @return bool whether the call correctly returned the expected magic value
908      */
909     function _checkOnERC721Received(
910         address from,
911         address to,
912         uint256 tokenId,
913         bytes memory _data
914     ) private returns (bool) {
915         if (to.isContract()) {
916             try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
917                 return retval == IERC721Receiver(to).onERC721Received.selector;
918             } catch (bytes memory reason) {
919                 if (reason.length == 0) {
920                     revert("txfr to non ERC721Reciever");
921                 } else {
922                     assembly {
923                         revert(add(32, reason), mload(reason))
924                     }
925                 }
926             }
927         } else {
928             return true;
929         }
930     }
931     
932     // *********************** ERC721 Token Receiver **********************
933     /**
934      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
935      * by `operator` from `from`, this function is called.
936      *
937      * It must return its Solidity selector to confirm the token transfer.
938      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
939      *
940      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
941      */
942     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4) {
943         //InterfaceID=0x150b7a02
944         return this.onERC721Received.selector;
945     }
946 
947     /**
948      * @dev Hook that is called before any token transfer. This includes minting
949      * and burning.
950      *
951      * Calling conditions:
952      *
953      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
954      * transferred to `to`.
955      * - When `from` is zero, `tokenId` will be minted for `to`.
956      * - When `to` is zero, ``from``'s `tokenId` will be burned.
957      * - `from` and `to` are never both zero.
958      *
959      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
960      */
961     function _beforeTokenTransfer(
962         address from,
963         address to,
964         uint256 tokenId
965     ) internal virtual {}
966 
967     // **************************************** Metadata Standard Functions **********
968     //@dev Returns the token collection name.
969     function name() external view returns (string memory){
970         return _name;
971     }
972 
973     //@dev Returns the token collection symbol.
974     function symbol() external view returns (string memory){
975         return _symbol;
976     }
977 
978     //@dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
979     function tokenURI(uint256 tokenId) external view returns (string memory){
980         require(_exists(tokenId), "ERC721Metadata: URI 0x0 token");
981         string memory tokenuri;
982         
983         if (tokenId < _revealTokens) {
984             tokenuri = string(abi.encodePacked(_baseURI, toString(tokenId), ".json"));
985         } else {
986             tokenuri = string(abi.encodePacked(_baseURI, "mystery.json"));  
987         }
988         
989         return tokenuri;
990     }
991     
992     function contractURI() public view returns (string memory) {
993             return string(abi.encodePacked(_baseURI,"contract.json"));
994     }
995     // *******************************************************************************
996 
997     receive() external payable {}
998     
999     fallback() external payable {}
1000 }