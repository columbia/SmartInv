1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /*
6    SSS		DDDD	    GGG		NN   NN
7  SSSSSSS	DDDDDD	   GGGGG	NNN  NN
8  SS   SS	DD   DD	  GG   GG	NNN  NN
9   SS		DD   DD	  GG   GG	NNNNNNN
10    SSS		DD   DD	  GG		NNNNNNN
11      SS		DD   DD	  GG  GGG	NN NNNN
12  SS   SS	DD   DD	  GG   GG	NN  NNN
13  SSSSSSS	DDDDDD	   GGGGGG	NN  NNN
14    SSS		DDDD	    GGGGG	NN   NN
15 */
16 
17 
18 interface IERC165 {
19     function supportsInterface(bytes4 interfaceId) external view returns (bool);
20 }
21 
22 interface IERC721 is IERC165 {
23     //@dev Emitted when `tokenId` token is transferred from `from` to `to`.
24     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
25 
26     //@dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
27     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
28 
29     //@dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
30     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
31 
32     //@dev Returns the number of tokens in ``owner``'s account.
33     function balanceOf(address owner) external view returns (uint256 balance);
34 
35     /**
36      * @dev Returns the owner of the `tokenId` token.
37      *
38      * Requirements:
39      *
40      * - `tokenId` must exist.
41      */
42     function ownerOf(uint256 tokenId) external view returns (address owner);
43 
44     /**
45      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
46      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
47      *
48      * Requirements:
49      *
50      * - `from` cannot be the zero address.
51      * - `to` cannot be the zero address.
52      * - `tokenId` token must exist and be owned by `from`.
53      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
54      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
55      *
56      * Emits a {Transfer} event.
57      */
58     function safeTransferFrom(address from,address to,uint256 tokenId) external;
59 
60     /**
61      * @dev Transfers `tokenId` token from `from` to `to`.
62      *
63      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
64      *
65      * Requirements:
66      *
67      * - `from` cannot be the zero address.
68      * - `to` cannot be the zero address.
69      * - `tokenId` token must be owned by `from`.
70      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transferFrom(address from, address to, uint256 tokenId) external;
75 
76     /**
77      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
78      * The approval is cleared when the token is transferred.
79      *
80      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
81      *
82      * Requirements:
83      *
84      * - The caller must own the token or be an approved operator.
85      * - `tokenId` must exist.
86      *
87      * Emits an {Approval} event.
88      */
89     function approve(address to, uint256 tokenId) external;
90 
91     /**
92      * @dev Returns the account approved for `tokenId` token.
93      *
94      * Requirements:
95      *
96      * - `tokenId` must exist.
97      */
98     function getApproved(uint256 tokenId) external view returns (address operator);
99 
100     /**
101      * @dev Approve or remove `operator` as an operator for the caller.
102      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
103      *
104      * Requirements:
105      * - The `operator` cannot be the caller.
106      *
107      * Emits an {ApprovalForAll} event.
108      */
109     function setApprovalForAll(address operator, bool _approved) external;
110 
111     //@dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
112     function isApprovedForAll(address owner, address operator) external view returns (bool);
113 
114     /**
115      * @dev Safely transfers `tokenId` token from `from` to `to`.
116      *
117      * Requirements:
118      *
119      * - `from` cannot be the zero address.
120      * - `to` cannot be the zero address.
121      * - `tokenId` token must exist and be owned by `from`.
122      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
123      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
124      *
125      * Emits a {Transfer} event.
126      */
127     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
128 }
129 
130 interface IERC721Metadata is IERC721 {
131     //@dev Returns the token collection name.
132     function name() external view returns (string memory);
133 
134     //@dev Returns the token collection symbol.
135     function symbol() external view returns (string memory);
136 
137     //@dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
138     function tokenURI(uint256 tokenId) external view returns (string memory);
139 }
140 
141 interface IERC721Receiver {
142     /**
143      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
144      * by `operator` from `from`, this function is called.
145      *
146      * It must return its Solidity selector to confirm the token transfer.
147      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
148      *
149      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
150      */
151     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
152 }
153 
154 library Address {
155     /**
156      * @dev Returns true if `account` is a contract.
157      *
158      * [IMPORTANT]
159      * ====
160      * It is unsafe to assume that an address for which this function returns
161      * false is an externally-owned account (EOA) and not a contract.
162      *
163      * Among others, `isContract` will return false for the following
164      * types of addresses:
165      *
166      *  - an externally-owned account
167      *  - a contract in construction
168      *  - an address where a contract will be created
169      *  - an address where a contract lived, but was destroyed
170      * ====
171      */
172     function isContract(address account) internal view returns (bool) {
173         // This method relies on extcodesize, which returns 0 for contracts in
174         // construction, since the code is only stored at the end of the
175         // constructor execution.
176 
177         uint256 size;
178         assembly {
179             size := extcodesize(account)
180         }
181         return size > 0;
182     }
183 
184     /**
185      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
186      * `recipient`, forwarding all available gas and reverting on errors.
187      *
188      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
189      * of certain opcodes, possibly making contracts go over the 2300 gas limit
190      * imposed by `transfer`, making them unable to receive funds via
191      * `transfer`. {sendValue} removes this limitation.
192      *
193      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
194      *
195      * IMPORTANT: because control is transferred to `recipient`, care must be
196      * taken to not create reentrancy vulnerabilities. Consider using
197      * {ReentrancyGuard} or the
198      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
199      */
200     function sendValue(address payable recipient, uint256 amount) internal {
201         require(address(this).balance >= amount, "Address: insufficient balance");
202 
203         (bool success, ) = recipient.call{value: amount}("");
204         require(success, "Addr: cant send val, rcpt revert");
205     }
206 
207     /**
208      * @dev Performs a Solidity function call using a low level `call`. A
209      * plain `call` is an unsafe replacement for a function call: use this
210      * function instead.
211      *
212      * If `target` reverts with a revert reason, it is bubbled up by this
213      * function (like regular Solidity function calls).
214      *
215      * Returns the raw returned data. To convert to the expected return value,
216      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
217      *
218      * Requirements:
219      *
220      * - `target` must be a contract.
221      * - calling `target` with `data` must not revert.
222      *
223      * _Available since v3.1._
224      */
225     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
226         return functionCall(target, data, "Address: low-level call failed");
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
231      * `errorMessage` as a fallback revert reason when `target` reverts.
232      *
233      * _Available since v3.1._
234      */
235     function functionCall(
236         address target,
237         bytes memory data,
238         string memory errorMessage
239     ) internal returns (bytes memory) {
240         return functionCallWithValue(target, data, 0, errorMessage);
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
245      * but also transferring `value` wei to `target`.
246      *
247      * Requirements:
248      *
249      * - the calling contract must have an ETH balance of at least `value`.
250      * - the called Solidity function must be `payable`.
251      *
252      * _Available since v3.1._
253      */
254     function functionCallWithValue(
255         address target,
256         bytes memory data,
257         uint256 value
258     ) internal returns (bytes memory) {
259         return functionCallWithValue(target, data, value, "Addr: low-level call value fail");
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
264      * with `errorMessage` as a fallback revert reason when `target` reverts.
265      *
266      * _Available since v3.1._
267      */
268     function functionCallWithValue(
269         address target,
270         bytes memory data,
271         uint256 value,
272         string memory errorMessage
273     ) internal returns (bytes memory) {
274         require(address(this).balance >= value, "Addr: insufficient balance call");
275         require(isContract(target), "Address: call to non-contract");
276 
277         (bool success, bytes memory returndata) = target.call{value: value}(data);
278         return _verifyCallResult(success, returndata, errorMessage);
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
283      * but performing a static call.
284      *
285      * _Available since v3.3._
286      */
287     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
288         return functionStaticCall(target, data, "Addr: low-level static call fail");
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
293      * but performing a static call.
294      *
295      * _Available since v3.3._
296      */
297     function functionStaticCall(
298         address target,
299         bytes memory data,
300         string memory errorMessage
301     ) internal view returns (bytes memory) {
302         require(isContract(target), "Addr: static call non-contract");
303 
304         (bool success, bytes memory returndata) = target.staticcall(data);
305         return _verifyCallResult(success, returndata, errorMessage);
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
310      * but performing a delegate call.
311      *
312      * _Available since v3.4._
313      */
314     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
315         return functionDelegateCall(target, data, "Addr: low-level del call failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
320      * but performing a delegate call.
321      *
322      * _Available since v3.4._
323      */
324     function functionDelegateCall(
325         address target,
326         bytes memory data,
327         string memory errorMessage
328     ) internal returns (bytes memory) {
329         require(isContract(target), "Addr: delegate call non-contract");
330 
331         (bool success, bytes memory returndata) = target.delegatecall(data);
332         return _verifyCallResult(success, returndata, errorMessage);
333     }
334 
335     function _verifyCallResult(
336         bool success,
337         bytes memory returndata,
338         string memory errorMessage
339     ) private pure returns (bytes memory) {
340         if (success) {
341             return returndata;
342         } else {
343             // Look for revert reason and bubble it up if present
344             if (returndata.length > 0) {
345                 // The easiest way to bubble the revert reason is using memory via assembly
346 
347                 assembly {
348                     let returndata_size := mload(returndata)
349                     revert(add(32, returndata), returndata_size)
350                 }
351             } else {
352                 revert(errorMessage);
353             }
354         }
355     }
356 }
357 
358 abstract contract Context {
359     function _msgSender() internal view virtual returns (address) {
360         return msg.sender;
361     }
362 
363     function _msgData() internal view virtual returns (bytes calldata) {
364         return msg.data;
365     }
366 }
367 
368 abstract contract Ownable is Context {
369     address private _owner;
370 
371     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
372 
373     /**
374      * @dev Initializes the contract setting the deployer as the initial owner.
375      */
376     constructor() {
377         _setOwner(_msgSender());
378     }
379 
380     /**
381      * @dev Returns the address of the current owner.
382      */
383     function owner() public view virtual returns (address) {
384         return _owner;
385     }
386 
387     /**
388      * @dev Throws if called by any account other than the owner.
389      */
390     modifier onlyOwner() {
391         require(owner() == _msgSender(), "Ownable: caller is not the owner");
392         _;
393     }
394 
395     /**
396      * @dev Leaves the contract without owner. It will not be possible to call
397      * `onlyOwner` functions anymore. Can only be called by the current owner.
398      *
399      * NOTE: Renouncing ownership will leave the contract without an owner,
400      * thereby removing any functionality that is only available to the owner.
401      */
402     function renounceOwnership() public virtual onlyOwner {
403         _setOwner(address(0));
404     }
405 
406     /**
407      * @dev Transfers ownership of the contract to a new account (`newOwner`).
408      * Can only be called by the current owner.
409      */
410     function transferOwnership(address newOwner) public virtual onlyOwner {
411         require(newOwner != address(0), "Ownable: new owner is 0x address");
412         _setOwner(newOwner);
413     }
414 
415     function _setOwner(address newOwner) private {
416         address oldOwner = _owner;
417         _owner = newOwner;
418         emit OwnershipTransferred(oldOwner, newOwner);
419     }
420 }
421 
422 abstract contract Functional {
423     function toString(uint256 value) internal pure returns (string memory) {
424         if (value == 0) {
425             return "0";
426         }
427         uint256 temp = value;
428         uint256 digits;
429         while (temp != 0) {
430             digits++;
431             temp /= 10;
432         }
433         bytes memory buffer = new bytes(digits);
434         while (value != 0) {
435             digits -= 1;
436             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
437             value /= 10;
438         }
439         return string(buffer);
440     }
441     
442     bool private _reentryKey = false;
443     modifier reentryLock {
444         require(!_reentryKey, "attempt reenter locked function");
445         _reentryKey = true;
446         _;
447         _reentryKey = false;
448     }
449 }
450 
451 
452 // ******************************************************************************************************************************
453 // **************************************************  Start of Main Contract ***************************************************
454 // ******************************************************************************************************************************
455 
456 contract ScoundrelDragons is IERC721, Ownable, Functional {
457 
458     using Address for address;
459     
460     // Token name
461     string private _name;
462 
463     // Token symbol
464     string private _symbol;
465     
466     // URI Root Location for Json Files
467     string private _baseURI;
468 
469     // Mapping from token ID to owner address
470     mapping(uint256 => address) private _owners;
471 
472     // Mapping owner address to token count
473     mapping(address => uint256) private _balances;
474 
475     // Mapping from token ID to approved address
476     mapping(uint256 => address) private _tokenApprovals;
477 
478     // Mapping from owner to operator approvals
479     mapping(address => mapping(address => bool)) private _operatorApprovals;
480     
481     // Specific Functionality
482     bool public mintActive;
483     bool private _revealTokens;  //for URI redirects
484     uint256 public totalTokens;
485     uint256 public numberMinted;
486     uint256 public maxPerWallet;
487     
488     mapping(address => uint256) private _mintTracker;
489 
490     /**
491      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
492      */
493     constructor() {
494         _name = "Scoundrels Dragons";
495         _symbol = "SDGN";
496         _baseURI = "https://scoundrelsmint.io/metadata/";
497         
498         totalTokens = 1000;
499         maxPerWallet = 5;
500     }
501 
502     //@dev See {IERC165-supportsInterface}. Interfaces Supported by this Standard
503     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
504         return  interfaceId == type(IERC721).interfaceId ||
505                 interfaceId == type(IERC721Metadata).interfaceId ||
506                 interfaceId == type(IERC165).interfaceId ||
507                 interfaceId == ScoundrelDragons.onERC721Received.selector;
508     }
509     
510     // Standard Withdraw function for the owner to pull the contract
511     function withdraw() external onlyOwner {
512         uint256 sendAmount = address(this).balance;
513         (bool success, ) = msg.sender.call{value: sendAmount}("");
514         require(success, "Transaction Unsuccessful");
515     }
516 
517     function airDrop(address _to) external onlyOwner {
518         require((numberMinted + 1) <= totalTokens, "Cannot fill order");
519         _safeMint(_to, numberMinted);
520     }
521     
522     function mint() external reentryLock {
523         require(mintActive, "Not open for business");
524         require((numberMinted + 1) <= totalTokens, "Mint: Not enough avaialability");
525         require((_mintTracker[_msgSender()] + 1) <= maxPerWallet, "Mint: Max tkn per wallet exceeded");
526 
527         _mintTracker[_msgSender()] += 1;
528 
529         //send tokens
530         _safeMint(_msgSender(), numberMinted);
531         numberMinted += 1;
532     }
533     
534     // allows holders to burn their own tokens if desired
535     function burn(uint256 tokenID) external {
536         require(_msgSender() == ownerOf(tokenID));
537         _burn(tokenID);
538     }
539     
540     //////////////////////////////////////////////////////////////
541     //////////////////// Setters and Getters /////////////////////
542     //////////////////////////////////////////////////////////////   
543     function setMaxWalletThreshold(uint256 maxWallet) external onlyOwner {
544         maxPerWallet = maxWallet;
545     }
546     
547     function setBaseURI(string memory newURI) public onlyOwner {
548         _baseURI = newURI;
549     }
550     
551     function activateMint() public onlyOwner {
552         mintActive = true;
553     }
554     
555     function deactivateMint() public onlyOwner {
556         mintActive = false;
557     }
558     
559     function setTotalTokens(uint256 numTokens) public onlyOwner {
560         totalTokens = numTokens;
561     }
562 
563     function totalSupply() external view returns (uint256) {
564         return numberMinted; //stupid bs for etherscan's call
565     }
566     
567     function hideTokens() external onlyOwner {
568         _revealTokens = false;
569     }
570     
571     function revealTokens() external onlyOwner {
572         _revealTokens = true;
573     }
574 
575     /**
576      * @dev See {IERC721-balanceOf}.
577      */
578     function balanceOf(address owner) public view virtual override returns (uint256) {
579         require(owner != address(0), "ERC721: bal qry for zero address");
580         return _balances[owner];
581     }
582 
583     /**
584      * @dev See {IERC721-ownerOf}.
585      */
586     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
587         address owner = _owners[tokenId];
588         require(owner != address(0), "ERC721: own query nonexist tkn");
589         return owner;
590     }
591 
592     /**
593      * @dev See {IERC721-approve}.
594      */
595     function approve(address to, uint256 tokenId) public virtual override {
596         address owner = ownerOf(tokenId);
597         require(to != owner, "ERC721: approval current owner");
598 
599         require(
600             msg.sender == owner || isApprovedForAll(owner, msg.sender),
601             "ERC721: caller !owner/!approved"
602         );
603 
604         _approve(to, tokenId);
605     }
606 
607     /**
608      * @dev See {IERC721-getApproved}.
609      */
610     function getApproved(uint256 tokenId) public view virtual override returns (address) {
611         require(_exists(tokenId), "ERC721: approved nonexistent tkn");
612         return _tokenApprovals[tokenId];
613     }
614 
615     /**
616      * @dev See {IERC721-setApprovalForAll}.
617      */
618     function setApprovalForAll(address operator, bool approved) public virtual override {
619         require(operator != msg.sender, "ERC721: approve to caller");
620 
621         _operatorApprovals[msg.sender][operator] = approved;
622         emit ApprovalForAll(msg.sender, operator, approved);
623     }
624 
625     /**
626      * @dev See {IERC721-isApprovedForAll}.
627      */
628     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
629         return _operatorApprovals[owner][operator];
630     }
631 
632     /**
633      * @dev See {IERC721-transferFrom}.
634      */
635     function transferFrom(
636         address from,
637         address to,
638         uint256 tokenId
639     ) public virtual override {
640         //solhint-disable-next-line max-line-length
641         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: txfr !owner/approved");
642         _transfer(from, to, tokenId);
643     }
644 
645     /**
646      * @dev See {IERC721-safeTransferFrom}.
647      */
648     function safeTransferFrom(
649         address from,
650         address to,
651         uint256 tokenId
652     ) public virtual override {
653         safeTransferFrom(from, to, tokenId, "");
654     }
655 
656     /**
657      * @dev See {IERC721-safeTransferFrom}.
658      */
659     function safeTransferFrom(
660         address from,
661         address to,
662         uint256 tokenId,
663         bytes memory _data
664     ) public virtual override {
665         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: txfr !owner/approved");
666         _safeTransfer(from, to, tokenId, _data);
667     }
668 
669     /**
670      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
671      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
672      *
673      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
674      *
675      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
676      * implement alternative mechanisms to perform token transfer, such as signature-based.
677      *
678      * Requirements:
679      *
680      * - `from` cannot be the zero address.
681      * - `to` cannot be the zero address.
682      * - `tokenId` token must exist and be owned by `from`.
683      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
684      *
685      * Emits a {Transfer} event.
686      */
687     function _safeTransfer(
688         address from,
689         address to,
690         uint256 tokenId,
691         bytes memory _data
692     ) internal virtual {
693         _transfer(from, to, tokenId);
694         require(_checkOnERC721Received(from, to, tokenId, _data), "txfr to non ERC721Reciever");
695     }
696 
697     /**
698      * @dev Returns whether `tokenId` exists.
699      *
700      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
701      *
702      * Tokens start existing when they are minted (`_mint`),
703      * and stop existing when they are burned (`_burn`).
704      */
705     function _exists(uint256 tokenId) internal view virtual returns (bool) {
706         return _owners[tokenId] != address(0);
707     }
708 
709     /**
710      * @dev Returns whether `spender` is allowed to manage `tokenId`.
711      *
712      * Requirements:
713      *
714      * - `tokenId` must exist.
715      */
716     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
717         require(_exists(tokenId), "ERC721: op query nonexistent tkn");
718         address owner = ownerOf(tokenId);
719         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
720     }
721 
722     /**
723      * @dev Safely mints `tokenId` and transfers it to `to`.
724      *
725      * Requirements:
726      *
727      * - `tokenId` must not exist.
728      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
729      *
730      * Emits a {Transfer} event.
731      */
732     function _safeMint(address to, uint256 tokenId) internal virtual {
733         _safeMint(to, tokenId, "");
734     }
735 
736     /**
737      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
738      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
739      */
740     function _safeMint(
741         address to,
742         uint256 tokenId,
743         bytes memory _data
744     ) internal virtual {
745         _mint(to, tokenId);
746         require(
747             _checkOnERC721Received(address(0), to, tokenId, _data),
748             "txfr to non ERC721Reciever"
749         );
750     }
751 
752     /**
753      * @dev Mints `tokenId` and transfers it to `to`.
754      *
755      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
756      *
757      * Requirements:
758      *
759      * - `tokenId` must not exist.
760      * - `to` cannot be the zero address.
761      *
762      * Emits a {Transfer} event.
763      */
764     function _mint(address to, uint256 tokenId) internal virtual {
765         require(to != address(0), "ERC721: mint to the zero address");
766         require(!_exists(tokenId), "ERC721: token already minted");
767 
768         _beforeTokenTransfer(address(0), to, tokenId);
769 
770         _balances[to] += 1;
771         _owners[tokenId] = to;
772 
773         emit Transfer(address(0), to, tokenId);
774     }
775 
776     /**
777      * @dev Destroys `tokenId`.
778      * The approval is cleared when the token is burned.
779      *
780      * Requirements:
781      *
782      * - `tokenId` must exist.
783      *
784      * Emits a {Transfer} event.
785      */
786     function _burn(uint256 tokenId) internal virtual {
787         address owner = ownerOf(tokenId);
788 
789         _beforeTokenTransfer(owner, address(0), tokenId);
790 
791         // Clear approvals
792         _approve(address(0), tokenId);
793 
794         _balances[owner] -= 1;
795         delete _owners[tokenId];
796 
797         emit Transfer(owner, address(0), tokenId);
798     }
799 
800     /**
801      * @dev Transfers `tokenId` from `from` to `to`.
802      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
803      *
804      * Requirements:
805      *
806      * - `to` cannot be the zero address.
807      * - `tokenId` token must be owned by `from`.
808      *
809      * Emits a {Transfer} event.
810      */
811     function _transfer(
812         address from,
813         address to,
814         uint256 tokenId
815     ) internal virtual {
816         require(ownerOf(tokenId) == from, "ERC721: txfr token not owned");
817         require(to != address(0), "ERC721: txfr to 0x0 address");
818         _beforeTokenTransfer(from, to, tokenId);
819 
820         // Clear approvals from the previous owner
821         _approve(address(0), tokenId);
822 
823         _balances[from] -= 1;
824         _balances[to] += 1;
825         _owners[tokenId] = to;
826 
827         emit Transfer(from, to, tokenId);
828     }
829 
830     /**
831      * @dev Approve `to` to operate on `tokenId`
832      *
833      * Emits a {Approval} event.
834      */
835     function _approve(address to, uint256 tokenId) internal virtual {
836         _tokenApprovals[tokenId] = to;
837         emit Approval(ownerOf(tokenId), to, tokenId);
838     }
839 
840     /**
841      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
842      * The call is not executed if the target address is not a contract.
843      *
844      * @param from address representing the previous owner of the given token ID
845      * @param to target address that will receive the tokens
846      * @param tokenId uint256 ID of the token to be transferred
847      * @param _data bytes optional data to send along with the call
848      * @return bool whether the call correctly returned the expected magic value
849      */
850     function _checkOnERC721Received(
851         address from,
852         address to,
853         uint256 tokenId,
854         bytes memory _data
855     ) private returns (bool) {
856         if (to.isContract()) {
857             try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
858                 return retval == IERC721Receiver(to).onERC721Received.selector;
859             } catch (bytes memory reason) {
860                 if (reason.length == 0) {
861                     revert("txfr to non ERC721Reciever");
862                 } else {
863                     assembly {
864                         revert(add(32, reason), mload(reason))
865                     }
866                 }
867             }
868         } else {
869             return true;
870         }
871     }
872     
873     // *********************** ERC721 Token Receiver **********************
874     /**
875      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
876      * by `operator` from `from`, this function is called.
877      *
878      * It must return its Solidity selector to confirm the token transfer.
879      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
880      *
881      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
882      */
883     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4) {
884         //InterfaceID=0x150b7a02
885         return this.onERC721Received.selector;
886     }
887 
888     /**
889      * @dev Hook that is called before any token transfer. This includes minting
890      * and burning.
891      *
892      * Calling conditions:
893      *
894      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
895      * transferred to `to`.
896      * - When `from` is zero, `tokenId` will be minted for `to`.
897      * - When `to` is zero, ``from``'s `tokenId` will be burned.
898      * - `from` and `to` are never both zero.
899      *
900      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
901      */
902     function _beforeTokenTransfer(
903         address from,
904         address to,
905         uint256 tokenId
906     ) internal virtual {}
907 
908     // **************************************** Metadata Standard Functions **********
909     //@dev Returns the token collection name.
910     function name() external view returns (string memory){
911         return _name;
912     }
913 
914     //@dev Returns the token collection symbol.
915     function symbol() external view returns (string memory){
916         return _symbol;
917     }
918 
919     //@dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
920     function tokenURI(uint256 tokenId) external view returns (string memory){
921         require(_exists(tokenId), "ERC721Metadata: URI 0x0 token");
922         string memory tokenuri;
923         
924         if (!_revealTokens) {
925             //redirect to mystery box
926             tokenuri = string(abi.encodePacked(_baseURI, "mystery.json"));
927         } else {
928             //Input flag data here to send to reveal URI
929             tokenuri = string(abi.encodePacked(_baseURI, toString(tokenId), ".json"));
930         }
931         
932         return tokenuri;
933     }
934     
935     function contractURI() public view returns (string memory) {
936             return string(abi.encodePacked(_baseURI,"contract.json"));
937     }
938     // *******************************************************************************
939 
940     receive() external payable {}
941     
942     fallback() external payable {}
943 }