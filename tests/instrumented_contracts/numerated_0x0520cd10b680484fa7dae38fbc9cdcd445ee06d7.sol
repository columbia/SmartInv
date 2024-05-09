1 // SPDX-License-Identifier: MIT
2 // File: newAvaContract.sol
3 
4 /**
5  *Submitted for verification at Etherscan.io on 2022-09-22
6 */
7 
8 // File: @openzeppelin/contracts/utils/Strings.sol
9 
10 
11 pragma solidity ^0.8.0;
12 
13 /*
14     Fully commented standard ERC721 Distilled from OpenZeppelin Docs
15     Base for Building ERC721 by Martin McConnell
16     All the utility without the fluff.
17 */
18 
19 
20 interface IERC165 {
21     function supportsInterface(bytes4 interfaceId) external view returns (bool);
22 }
23 
24 interface IERC721 is IERC165 {
25     //@dev Emitted when `tokenId` token is transferred from `from` to `to`.
26     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
27 
28     //@dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
29     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
30 
31     //@dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
32     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
33 
34     //@dev Returns the number of tokens in ``owner``'s account.
35     function balanceOf(address owner) external view returns (uint256 balance);
36 
37     /**
38      * @dev Returns the owner of the `tokenId` token.
39      *
40      * Requirements:
41      *
42      * - `tokenId` must exist.
43      */
44     function ownerOf(uint256 tokenId) external view returns (address owner);
45 
46     /**
47      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
48      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
49      *
50      * Requirements:
51      *
52      * - `from` cannot be the zero address.
53      * - `to` cannot be the zero address.
54      * - `tokenId` token must exist and be owned by `from`.
55      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
56      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
57      *
58      * Emits a {Transfer} event.
59      */
60     function safeTransferFrom(address from,address to,uint256 tokenId) external;
61 
62     /**
63      * @dev Transfers `tokenId` token from `from` to `to`.
64      *
65      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
66      *
67      * Requirements:
68      *
69      * - `from` cannot be the zero address.
70      * - `to` cannot be the zero address.
71      * - `tokenId` token must be owned by `from`.
72      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
73      *
74      * Emits a {Transfer} event.
75      */
76     function transferFrom(address from, address to, uint256 tokenId) external;
77 
78     /**
79      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
80      * The approval is cleared when the token is transferred.
81      *
82      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
83      *
84      * Requirements:
85      *
86      * - The caller must own the token or be an approved operator.
87      * - `tokenId` must exist.
88      *
89      * Emits an {Approval} event.
90      */
91     function approve(address to, uint256 tokenId) external;
92 
93     /**
94      * @dev Returns the account approved for `tokenId` token.
95      *
96      * Requirements:
97      *
98      * - `tokenId` must exist.
99      */
100     function getApproved(uint256 tokenId) external view returns (address operator);
101 
102     /**
103      * @dev Approve or remove `operator` as an operator for the caller.
104      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
105      *
106      * Requirements:
107      * - The `operator` cannot be the caller.
108      *
109      * Emits an {ApprovalForAll} event.
110      */
111     function setApprovalForAll(address operator, bool _approved) external;
112 
113     //@dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
114     function isApprovedForAll(address owner, address operator) external view returns (bool);
115 
116     /**
117      * @dev Safely transfers `tokenId` token from `from` to `to`.
118      *
119      * Requirements:
120      *
121      * - `from` cannot be the zero address.
122      * - `to` cannot be the zero address.
123      * - `tokenId` token must exist and be owned by `from`.
124      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
125      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
126      *
127      * Emits a {Transfer} event.
128      */
129     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
130 }
131 
132 interface IERC721Metadata is IERC721 {
133     //@dev Returns the token collection name.
134     function name() external view returns (string memory);
135 
136     //@dev Returns the token collection symbol.
137     function symbol() external view returns (string memory);
138 
139     //@dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
140     function tokenURI(uint256 tokenId) external view returns (string memory);
141 }
142 
143 interface IERC721Receiver {
144     /**
145      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
146      * by `operator` from `from`, this function is called.
147      *
148      * It must return its Solidity selector to confirm the token transfer.
149      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
150      *
151      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
152      */
153     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
154 }
155 
156 library Address {
157     /**
158      * @dev Returns true if `account` is a contract.
159      *
160      * [IMPORTANT]
161      * ====
162      * It is unsafe to assume that an address for which this function returns
163      * false is an externally-owned account (EOA) and not a contract.
164      *
165      * Among others, `isContract` will return false for the following
166      * types of addresses:
167      *
168      *  - an externally-owned account
169      *  - a contract in construction
170      *  - an address where a contract will be created
171      *  - an address where a contract lived, but was destroyed
172      * ====
173      */
174     function isContract(address account) internal view returns (bool) {
175         // This method relies on extcodesize, which returns 0 for contracts in
176         // construction, since the code is only stored at the end of the
177         // constructor execution.
178 
179         uint256 size;
180         assembly {
181             size := extcodesize(account)
182         }
183         return size > 0;
184     }
185 
186     /**
187      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
188      * `recipient`, forwarding all available gas and reverting on errors.
189      *
190      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
191      * of certain opcodes, possibly making contracts go over the 2300 gas limit
192      * imposed by `transfer`, making them unable to receive funds via
193      * `transfer`. {sendValue} removes this limitation.
194      *
195      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
196      *
197      * IMPORTANT: because control is transferred to `recipient`, care must be
198      * taken to not create reentrancy vulnerabilities. Consider using
199      * {ReentrancyGuard} or the
200      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
201      */
202     function sendValue(address payable recipient, uint256 amount) internal {
203         require(address(this).balance >= amount, "Address: insufficient balance");
204 
205         (bool success, ) = recipient.call{value: amount}("");
206         require(success, "Addr: cant send val, rcpt revert");
207     }
208 
209     /**
210      * @dev Performs a Solidity function call using a low level `call`. A
211      * plain `call` is an unsafe replacement for a function call: use this
212      * function instead.
213      *
214      * If `target` reverts with a revert reason, it is bubbled up by this
215      * function (like regular Solidity function calls).
216      *
217      * Returns the raw returned data. To convert to the expected return value,
218      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
219      *
220      * Requirements:
221      *
222      * - `target` must be a contract.
223      * - calling `target` with `data` must not revert.
224      *
225      * _Available since v3.1._
226      */
227     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
228         return functionCall(target, data, "Address: low-level call failed");
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
233      * `errorMessage` as a fallback revert reason when `target` reverts.
234      *
235      * _Available since v3.1._
236      */
237     function functionCall(
238         address target,
239         bytes memory data,
240         string memory errorMessage
241     ) internal returns (bytes memory) {
242         return functionCallWithValue(target, data, 0, errorMessage);
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
247      * but also transferring `value` wei to `target`.
248      *
249      * Requirements:
250      *
251      * - the calling contract must have an ETH balance of at least `value`.
252      * - the called Solidity function must be `payable`.
253      *
254      * _Available since v3.1._
255      */
256     function functionCallWithValue(
257         address target,
258         bytes memory data,
259         uint256 value
260     ) internal returns (bytes memory) {
261         return functionCallWithValue(target, data, value, "Addr: low-level call value fail");
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
266      * with `errorMessage` as a fallback revert reason when `target` reverts.
267      *
268      * _Available since v3.1._
269      */
270     function functionCallWithValue(
271         address target,
272         bytes memory data,
273         uint256 value,
274         string memory errorMessage
275     ) internal returns (bytes memory) {
276         require(address(this).balance >= value, "Addr: insufficient balance call");
277         require(isContract(target), "Address: call to non-contract");
278 
279         (bool success, bytes memory returndata) = target.call{value: value}(data);
280         return _verifyCallResult(success, returndata, errorMessage);
281     }
282 
283     /**
284      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
285      * but performing a static call.
286      *
287      * _Available since v3.3._
288      */
289     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
290         return functionStaticCall(target, data, "Addr: low-level static call fail");
291     }
292 
293     /**
294      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
295      * but performing a static call.
296      *
297      * _Available since v3.3._
298      */
299     function functionStaticCall(
300         address target,
301         bytes memory data,
302         string memory errorMessage
303     ) internal view returns (bytes memory) {
304         require(isContract(target), "Addr: static call non-contract");
305 
306         (bool success, bytes memory returndata) = target.staticcall(data);
307         return _verifyCallResult(success, returndata, errorMessage);
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
312      * but performing a delegate call.
313      *
314      * _Available since v3.4._
315      */
316     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
317         return functionDelegateCall(target, data, "Addr: low-level del call failed");
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
322      * but performing a delegate call.
323      *
324      * _Available since v3.4._
325      */
326     function functionDelegateCall(
327         address target,
328         bytes memory data,
329         string memory errorMessage
330     ) internal returns (bytes memory) {
331         require(isContract(target), "Addr: delegate call non-contract");
332 
333         (bool success, bytes memory returndata) = target.delegatecall(data);
334         return _verifyCallResult(success, returndata, errorMessage);
335     }
336 
337     function _verifyCallResult(
338         bool success,
339         bytes memory returndata,
340         string memory errorMessage
341     ) private pure returns (bytes memory) {
342         if (success) {
343             return returndata;
344         } else {
345             // Look for revert reason and bubble it up if present
346             if (returndata.length > 0) {
347                 // The easiest way to bubble the revert reason is using memory via assembly
348 
349                 assembly {
350                     let returndata_size := mload(returndata)
351                     revert(add(32, returndata), returndata_size)
352                 }
353             } else {
354                 revert(errorMessage);
355             }
356         }
357     }
358 }
359 
360 abstract contract Context {
361     function _msgSender() internal view virtual returns (address) {
362         return msg.sender;
363     }
364 
365     function _msgData() internal view virtual returns (bytes calldata) {
366         return msg.data;
367     }
368 }
369 
370 abstract contract Ownable is Context {
371     address private _owner;
372 
373     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
374 
375     /**
376      * @dev Initializes the contract setting the deployer as the initial owner.
377      */
378     constructor() {
379         _setOwner(_msgSender());
380     }
381 
382     /**
383      * @dev Returns the address of the current owner.
384      */
385     function owner() public view virtual returns (address) {
386         return _owner;
387     }
388 
389     /**
390      * @dev Throws if called by any account other than the owner.
391      */
392     modifier onlyOwner() {
393         require(owner() == _msgSender(), "Ownable: caller is not the owner");
394         _;
395     }
396 
397     /**
398      * @dev Leaves the contract without owner. It will not be possible to call
399      * `onlyOwner` functions anymore. Can only be called by the current owner.
400      *
401      * NOTE: Renouncing ownership will leave the contract without an owner,
402      * thereby removing any functionality that is only available to the owner.
403      */
404     function renounceOwnership() public virtual onlyOwner {
405         _setOwner(address(0));
406     }
407 
408     /**
409      * @dev Transfers ownership of the contract to a new account (`newOwner`).
410      * Can only be called by the current owner.
411      */
412     function transferOwnership(address newOwner) public virtual onlyOwner {
413         require(newOwner != address(0), "Ownable: new owner is 0x address");
414         _setOwner(newOwner);
415     }
416 
417     function _setOwner(address newOwner) private {
418         address oldOwner = _owner;
419         _owner = newOwner;
420         emit OwnershipTransferred(oldOwner, newOwner);
421     }
422 }
423 
424 abstract contract Functional {
425     function toString(uint256 value) internal pure returns (string memory) {
426         if (value == 0) {
427             return "0";
428         }
429         uint256 temp = value;
430         uint256 digits;
431         while (temp != 0) {
432             digits++;
433             temp /= 10;
434         }
435         bytes memory buffer = new bytes(digits);
436         while (value != 0) {
437             digits -= 1;
438             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
439             value /= 10;
440         }
441         return string(buffer);
442     }
443     
444     bool private _reentryKey = false;
445     modifier reentryLock {
446         require(!_reentryKey, "attempt reenter locked function");
447         _reentryKey = true;
448         _;
449         _reentryKey = false;
450     }
451 }
452 
453 contract ERC721 {
454     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
455     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
456     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
457     function balanceOf(address owner) external view returns (uint256 balance){}
458     function ownerOf(uint256 tokenId) external view returns (address owner){}
459     function safeTransferFrom(address from,address to,uint256 tokenId) external{}
460     function transferFrom(address from, address to, uint256 tokenId) external{}
461     function approve(address to, uint256 tokenId) external{}
462     function getApproved(uint256 tokenId) external view returns (address operator){}
463     function setApprovalForAll(address operator, bool _approved) external{}
464     function isApprovedForAll(address owner, address operator) external view returns (bool){}
465     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external{}
466 }
467 
468 // ******************************************************************************************************************************
469 // **************************************************  Start of Main Contract ***************************************************
470 // ******************************************************************************************************************************
471 
472 contract AVIUSNFT is IERC721, Ownable, Functional {
473 
474     using Address for address;
475     
476     // Token name
477     string private _name;
478 
479     // Token symbol
480     string private _symbol;
481     
482     // URI Root Location for Json Files
483     string private _baseURI;
484 
485     // Mapping from token ID to owner address
486     mapping(uint256 => address) private _owners;
487 
488     // Mapping owner address to token count
489     mapping(address => uint256) private _balances;
490 
491     // Mapping from token ID to approved address
492     mapping(uint256 => address) private _tokenApprovals;
493 
494     // Mapping from owner to operator approvals
495     mapping(address => mapping(address => bool)) private _operatorApprovals;
496     
497     // Specific Functionality
498     bool public publicMintActive;
499     bool public whiteListActive;
500 	uint256 private _maxSupply;
501     uint256 public numberMinted;
502     uint256 public maxPerTxn;
503     uint256 public maxPerWallet = 10;
504 	bool private _revealed;
505     uint256 public nftprice;
506     
507     mapping(address => uint256) private _mintTracker;
508     address nftOwnerAddress      = payable(0x89AC334A1C882217916CB90f2A45cBA88cE35a52);
509     
510     //whitelist for holders
511     ERC721 CC; ///Elephants of Chameleons
512    
513     /**
514      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
515      */
516     constructor() {
517         _name = "AVIUS OBSCURIS";
518         _symbol = "AVONFT";
519         _baseURI = "https://aviusanimae.xyz/metadata/";
520        
521         CC = ERC721(0x0eDA3c383F13C36db1c96bD9c56f715B09b9E350); // AVA Burn token on etherscan
522         _maxSupply = 3333;
523     }
524 
525     //@dev See {IERC165-supportsInterface}. Interfaces Supported by this Standard
526     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
527         return  interfaceId == type(IERC721).interfaceId ||
528                 interfaceId == type(IERC721Metadata).interfaceId ||
529                 interfaceId == type(IERC165).interfaceId ||
530                 interfaceId == AVIUSNFT.onERC721Received.selector;
531     }
532     
533     // Standard Withdraw function for the owner to pull the contract
534     function withdraw() external onlyOwner {
535         uint256 sendAmount = address(this).balance;
536         (bool success, ) = nftOwnerAddress.call{value: sendAmount}("");
537         require(success, "Transaction Unsuccessful");
538     }
539     
540     function airDrop(address _to, uint256 qty) external onlyOwner {
541         require(!publicMintActive && !whiteListActive, "Mint is Active first deactivate it by owner");
542         require((numberMinted + qty) > numberMinted, "Math overflow error");
543         require((_mintTracker[_to] + qty) <= maxPerWallet, "Mint: Max tkn per wallet exceeded");
544         uint256 mintSeedValue = numberMinted;
545         _mintTracker[_to] = _mintTracker[_to] + qty;
546         for(uint256 i = 1; i <= qty; i++) {
547             _safeMint(_to, mintSeedValue + i);
548             numberMinted ++;  //reservedTokens can be reset, numberMinted can not
549         }
550     }
551 	function publicMint(uint256 qty) external payable reentryLock {
552 		require(publicMintActive, "Mint Not Active");
553         require((_mintTracker[msg.sender] + qty) <= maxPerWallet, "Mint: Max tkn per wallet exceeded");
554         require(numberMinted + qty <= _maxSupply, "Max supply exceeded");
555         require(msg.value >= 0, "Wrong Eth Amount");
556     	nftprice = msg.value;
557 		uint256 mintSeedValue = numberMinted;
558 		numberMinted += qty;
559 		_mintTracker[msg.sender] = _mintTracker[msg.sender] + qty;
560 		for(uint256 i = 1; i <= qty; i++) {
561         	_safeMint(_msgSender(), mintSeedValue + i);
562         }
563 	}
564     function whiteListMint(uint256 qty) external payable reentryLock {
565 		require(CC.balanceOf(_msgSender()) > 0, "Must have Avius Token");
566 		require(whiteListActive, "Mint Not Active");
567         require((_mintTracker[msg.sender] + qty) <= maxPerWallet, "Mint: Max tkn per wallet exceeded");
568         require(numberMinted + qty <= _maxSupply, "Max supply exceeded");
569         require(msg.value >= 0, "Wrong Eth Amount");
570     	nftprice = msg.value;
571 		uint256 mintSeedValue = numberMinted;
572 		numberMinted += qty;
573 		_mintTracker[msg.sender] = _mintTracker[msg.sender] + qty;
574 		for(uint256 i = 1; i <= qty; i++) {
575         	_safeMint(_msgSender(), mintSeedValue + i);
576         }
577 	}
578    
579     // allows holders to burn their own tokens if desired
580     function burn(uint256 tokenID, uint256 tokenIDTwo) external {
581         require(_msgSender() == (CC).ownerOf(tokenID), "Only token owner can call burn");
582         require(_msgSender() == (CC).ownerOf(tokenIDTwo), "Only token owner can call burn");
583         (CC).transferFrom(msg.sender, address(0x000000000000000000000000000000000000dEaD), tokenID);
584         (CC).transferFrom(msg.sender, address(0x000000000000000000000000000000000000dEaD), tokenIDTwo);
585     }
586     
587     //////////////////////////////////////////////////////////////
588     //////////////////// Setters and Getters /////////////////////
589     //////////////////////////////////////////////////////////////
590 	function reveal() external onlyOwner {
591 		_revealed = true;
592 	}
593 
594 	function changeMaxSupply( uint256 newValue ) external onlyOwner {
595 		_maxSupply = newValue;
596 	}
597 
598 	function hide() external onlyOwner {
599 		_revealed = false;
600 	}
601 
602     function setMaxMintThreshold(uint256 maxMints) external onlyOwner {
603         maxPerWallet = maxMints;
604     }
605     
606     function setBaseURI(string memory newURI) public onlyOwner {
607         _baseURI = newURI;
608     }
609     
610     function activatePublicMint() public onlyOwner {
611         publicMintActive = true;
612     }
613     
614     function deactivatePublicMint() public onlyOwner {
615         publicMintActive = false;
616     }
617 
618     function activeWhiteListMint() public onlyOwner {
619         whiteListActive = true;
620     }
621     
622     function deactivateWhiteListMint() public onlyOwner {
623         whiteListActive = false;
624     }
625    
626     function totalSupply() external view returns (uint256) {
627         return numberMinted; //stupid bs for etherscan's call
628     }
629     
630     function getBalance(address tokenAddress) view external returns (uint256) {
631         //return _balances[tokenAddress]; //shows 0 on etherscan due to overflow error
632         return _balances[tokenAddress] / (10**15); //temporary fix to report in finneys
633     }
634 
635     /**
636      * @dev See {IERC721-balanceOf}.
637      */
638     function balanceOf(address owner) public view virtual override returns (uint256) {
639         require(owner != address(0), "ERC721: bal qry for zero address");
640         return _balances[owner];
641     }
642 
643     /**
644      * @dev See {IERC721-ownerOf}.
645      */
646     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
647         address owner = _owners[tokenId];
648         require(owner != address(0), "ERC721: own query nonexist tkn");
649         return owner;
650     }
651 
652     /**
653      * @dev See {IERC721-approve}.
654      */
655     function approve(address to, uint256 tokenId) public virtual override {
656         address owner = ownerOf(tokenId);
657         require(to != owner, "ERC721: approval current owner");
658 
659         require(
660             msg.sender == owner || isApprovedForAll(owner, msg.sender),
661             "ERC721: caller !owner/!approved"
662         );
663 
664         _approve(to, tokenId);
665     }
666 
667     /**
668      * @dev See {IERC721-getApproved}.
669      */
670     function getApproved(uint256 tokenId) public view virtual override returns (address) {
671         require(_exists(tokenId), "ERC721: approved nonexistent tkn");
672         return _tokenApprovals[tokenId];
673     }
674 
675     /**
676      * @dev See {IERC721-setApprovalForAll}.
677      */
678     function setApprovalForAll(address operator, bool approved) public virtual override {
679         require(operator != msg.sender, "ERC721: approve to caller");
680 
681         _operatorApprovals[msg.sender][operator] = approved;
682         emit ApprovalForAll(msg.sender, operator, approved);
683     }
684 
685     /**
686      * @dev See {IERC721-isApprovedForAll}.
687      */
688     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
689         return _operatorApprovals[owner][operator];
690     }
691 
692     /**
693      * @dev See {IERC721-transferFrom}.
694      */
695     function transferFrom(
696         address from,
697         address to,
698         uint256 tokenId
699     ) public virtual override {
700         //solhint-disable-next-line max-line-length
701         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: txfr !owner/approved");
702         _transfer(from, to, tokenId);
703     }
704 
705     /**
706      * @dev See {IERC721-safeTransferFrom}.
707      */
708     function safeTransferFrom(
709         address from,
710         address to,
711         uint256 tokenId
712     ) public virtual override {
713         safeTransferFrom(from, to, tokenId, "");
714     }
715 
716     /**
717      * @dev See {IERC721-safeTransferFrom}.
718      */
719     function safeTransferFrom(
720         address from,
721         address to,
722         uint256 tokenId,
723         bytes memory _data
724     ) public virtual override {
725         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: txfr !owner/approved");
726         _safeTransfer(from, to, tokenId, _data);
727     }
728 
729     /**
730      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
731      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
732      *
733      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
734      *
735      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
736      * implement alternative mechanisms to perform token transfer, such as signature-based.
737      *
738      * Requirements:
739      *
740      * - `from` cannot be the zero address.
741      * - `to` cannot be the zero address.
742      * - `tokenId` token must exist and be owned by `from`.
743      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
744      *
745      * Emits a {Transfer} event.
746      */
747     function _safeTransfer(
748         address from,
749         address to,
750         uint256 tokenId,
751         bytes memory _data
752     ) internal virtual {
753         _transfer(from, to, tokenId);
754         require(_checkOnERC721Received(from, to, tokenId, _data), "txfr to non ERC721Reciever");
755     }
756 
757     /**
758      * @dev Returns whether `tokenId` exists.
759      *
760      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
761      *
762      * Tokens start existing when they are minted (`_mint`),
763      * and stop existing when they are burned (`_burn`).
764      */
765     function _exists(uint256 tokenId) internal view virtual returns (bool) {
766         return _owners[tokenId] != address(0);
767     }
768 
769     /**
770      * @dev Returns whether `spender` is allowed to manage `tokenId`.
771      *
772      * Requirements:
773      *
774      * - `tokenId` must exist.
775      */
776     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
777         require(_exists(tokenId), "ERC721: op query nonexistent tkn");
778         address owner = ownerOf(tokenId);
779         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
780     }
781 
782     /**
783      * @dev Safely mints `tokenId` and transfers it to `to`.
784      *
785      * Requirements:
786      *
787      * - `tokenId` must not exist.
788      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
789      *
790      * Emits a {Transfer} event.
791      */
792     function _safeMint(address to, uint256 tokenId) internal virtual {
793         _safeMint(to, tokenId, "");
794     }
795 
796     /**
797      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
798      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
799      */
800     function _safeMint(
801         address to,
802         uint256 tokenId,
803         bytes memory _data
804     ) internal virtual {
805         _mint(to, tokenId);
806         require(
807             _checkOnERC721Received(address(0), to, tokenId, _data),
808             "txfr to non ERC721Reciever"
809         );
810     }
811 
812     /**
813      * @dev Mints `tokenId` and transfers it to `to`.
814      *
815      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
816      *
817      * Requirements:
818      *
819      * - `tokenId` must not exist.
820      * - `to` cannot be the zero address.
821      *
822      * Emits a {Transfer} event.
823      */
824     function _mint(address to, uint256 tokenId) internal virtual {
825         require(to != address(0), "ERC721: mint to the zero address");
826         require(!_exists(tokenId), "ERC721: token already minted");
827 
828         _beforeTokenTransfer(address(0), to, tokenId);
829 
830         _balances[to] += 1;
831         _owners[tokenId] = to;
832 
833         emit Transfer(address(0), to, tokenId);
834     }
835 
836     /**
837      * @dev Destroys `tokenId`.
838      * The approval is cleared when the token is burned.
839      *
840      * Requirements:
841      *
842      * - `tokenId` must exist.
843      *
844      * Emits a {Transfer} event.
845      */
846     function _burn(uint256 tokenId) internal virtual {
847         address owner = ownerOf(tokenId);
848 
849         _beforeTokenTransfer(owner, address(0), tokenId);
850 
851         // Clear approvals
852         _approve(address(0), tokenId);
853 
854         _balances[owner] -= 1;
855         delete _owners[tokenId];
856 
857         emit Transfer(owner, address(0), tokenId);
858     }
859 
860     /**
861      * @dev Transfers `tokenId` from `from` to `to`.
862      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
863      *
864      * Requirements:
865      *
866      * - `to` cannot be the zero address.
867      * - `tokenId` token must be owned by `from`.
868      *
869      * Emits a {Transfer} event.
870      */
871     function _transfer(
872         address from,
873         address to,
874         uint256 tokenId
875     ) internal virtual {
876         require(ownerOf(tokenId) == from, "ERC721: txfr token not owned");
877         require(to != address(0), "ERC721: txfr to 0x0 address");
878         _beforeTokenTransfer(from, to, tokenId);
879 
880         // Clear approvals from the previous owner
881         _approve(address(0), tokenId);
882 
883         _balances[from] -= 1;
884         _balances[to] += 1;
885         _owners[tokenId] = to;
886 
887         emit Transfer(from, to, tokenId);
888     }
889 
890     /**
891      * @dev Approve `to` to operate on `tokenId`
892      *
893      * Emits a {Approval} event.
894      */
895     function _approve(address to, uint256 tokenId) internal virtual {
896         _tokenApprovals[tokenId] = to;
897         emit Approval(ownerOf(tokenId), to, tokenId);
898     }
899 
900     /**
901      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
902      * The call is not executed if the target address is not a contract.
903      *
904      * @param from address representing the previous owner of the given token ID
905      * @param to target address that will receive the tokens
906      * @param tokenId uint256 ID of the token to be transferred
907      * @param _data bytes optional data to send along with the call
908      * @return bool whether the call correctly returned the expected magic value
909      */
910     function _checkOnERC721Received(
911         address from,
912         address to,
913         uint256 tokenId,
914         bytes memory _data
915     ) private returns (bool) {
916         if (to.isContract()) {
917             try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
918                 return retval == IERC721Receiver(to).onERC721Received.selector;
919             } catch (bytes memory reason) {
920                 if (reason.length == 0) {
921                     revert("txfr to non ERC721Reciever");
922                 } else {
923                     assembly {
924                         revert(add(32, reason), mload(reason))
925                     }
926                 }
927             }
928         } else {
929             return true;
930         }
931     }
932     
933     // *********************** ERC721 Token Receiver **********************
934     /**
935      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
936      * by `operator` from `from`, this function is called.
937      *
938      * It must return its Solidity selector to confirm the token transfer.
939      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
940      *
941      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
942      */
943     function onERC721Received() external pure returns(bytes4) {
944         //InterfaceID=0x150b7a02
945         return this.onERC721Received.selector;
946     }
947 
948     /**
949      * @dev Hook that is called before any token transfer. This includes minting
950      * and burning.
951      *
952      * Calling conditions:
953      *
954      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
955      * transferred to `to`.
956      * - When `from` is zero, `tokenId` will be minted for `to`.
957      * - When `to` is zero, ``from``'s `tokenId` will be burned.
958      * - `from` and `to` are never both zero.
959      *
960      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
961      */
962     function _beforeTokenTransfer(
963         address from,
964         address to,
965         uint256 tokenId
966     ) internal virtual {}
967 
968     // **************************************** Metadata Standard Functions **********
969     //@dev Returns the token collection name.
970     function name() external view returns (string memory){
971         return _name;
972     }
973 
974     //@dev Returns the token collection symbol.
975     function symbol() external view returns (string memory){
976         return _symbol;
977     }
978 
979     //@dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
980     function tokenURI(uint256 tokenId) external view returns (string memory){
981         require(_exists(tokenId), "ERC721Metadata: URI 0x0 token");
982         string memory tokenuri;
983         if (_revealed){
984         	tokenuri = string(abi.encodePacked(_baseURI, toString(tokenId), ".json"));
985 		} else {
986 			tokenuri = string(abi.encodePacked(_baseURI, "mystery.json"));
987 		}
988         return tokenuri;
989     }
990     
991     function contractURI() public view returns (string memory) {
992             return string(abi.encodePacked(_baseURI,"contract.json"));
993     }
994     // *******************************************************************************
995 
996     receive() external payable {}
997     
998     fallback() external payable {}
999 }