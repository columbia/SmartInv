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
445 // ******************************************************************************************************************************
446 // **************************************************  Start of Main Contract ***************************************************
447 // ******************************************************************************************************************************
448 
449 contract Normies is IERC721, Ownable, Functional {
450 
451     using Address for address;
452     
453     // Token name
454     string private _name;
455 
456     // Token symbol
457     string private _symbol;
458     
459     // URI Root Location for Json Files
460     string private _baseURI;
461 
462     // Mapping from token ID to owner address
463     mapping(uint256 => address) private _owners;
464 
465     // Mapping owner address to token count
466     mapping(address => uint256) private _balances;
467 
468     // Mapping from token ID to approved address
469     mapping(uint256 => address) private _tokenApprovals;
470 
471     // Mapping from owner to operator approvals
472     mapping(address => mapping(address => bool)) private _operatorApprovals;
473     
474     // Specific Functionality
475     bool public mintActive;
476     bool public whitelistActive;
477     bool private _hideTokens;  //for URI redirects
478     uint256 public price;
479     uint256 public totalTokens;
480     uint256 public numberMinted;
481     uint256 public maxPerTxn;
482     uint256 public whiteListMax;
483     uint256 public WLprice;
484     
485     mapping(address => uint256) private _whitelist;
486 
487     //Distribution Wallets
488     address Founder =       payable(0xD61344DBd5321C7583B1166705f993Ff126DACf8); //85%
489     address Developer =     payable(0x2E07cd18E675c921E8c523E36D79788734E94f88); //5%
490     address Consulting =    payable(0xe9A36d2d6820539ec2F3b4ddC68Fd337BF8Ce293); //5%
491     address Community =     payable(0x9f4A549dD4415968f0279dB9Ae43AFfD7354CFDE); //5%
492 
493     /**
494      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
495      */
496     constructor() {
497         _name = "Paranormies";
498         _symbol = "NORMIE";
499         _baseURI = "https://paranormies.io/metadata/";
500         _hideTokens = true;
501         
502 
503         totalTokens = 9700;
504         price = 69 * (10 ** 15); // Replace leading value with price in finney  0.069E
505         WLprice = 69 * (10 ** 15);
506         maxPerTxn = 20;
507         whiteListMax = 4;
508     }
509 
510     //@dev See {IERC165-supportsInterface}. Interfaces Supported by this Standard
511     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
512         return  interfaceId == type(IERC721).interfaceId ||
513                 interfaceId == type(IERC721Metadata).interfaceId ||
514                 interfaceId == type(IERC165).interfaceId ||
515                 interfaceId == Normies.onERC721Received.selector;
516     }
517     
518     // Standard Withdraw function for the owner to pull the contract
519     function withdraw() external onlyOwner {
520         uint256 Funds = address(this).balance;
521         bool success;
522 
523         uint256 sendAmount = (Funds * 85) / 100;
524         (success, ) = Founder.call{value: sendAmount}("");
525         require(success, "Transaction Unsuccessful");
526         
527         sendAmount = (Funds * 5) / 100;
528         (success, ) = Developer.call{value: sendAmount}("");
529         require(success, "Transaction Unsuccessful"); 
530         
531         sendAmount = (Funds * 5) / 100;
532         (success, ) = Consulting.call{value: sendAmount}("");
533         require(success, "Transaction Unsuccessful");
534         
535         sendAmount = (Funds * 5) / 100;
536         (success, ) = Community.call{value: sendAmount}("");
537         require(success, "Transaction Unsuccessful");
538         
539     }
540     
541     function ownerMint(address _to, uint256 qty) external onlyOwner {
542         require((numberMinted + qty) > numberMinted, "Math overflow error");
543         require((numberMinted + qty) <= totalTokens, "Cannot fill order");
544         
545         uint256 mintSeedValue = numberMinted; //Store the starting value of the mint batch
546         
547         for(uint256 i = 0; i < qty; i++) {
548             _safeMint(_to, mintSeedValue + i);
549             numberMinted ++;  //reservedTokens can be reset, numberMinted can not
550         }
551     }
552 
553     function singleAirdrop(address _to) external onlyOwner {
554         require(numberMinted <= totalTokens, "Cannot Fill Order");
555 
556         uint256 mintSeedValue = numberMinted; //Store the starting value of the mint batch
557 
558         numberMinted ++;  //reservedTokens can be reset, numberMinted can not
559         _safeMint(_to, mintSeedValue);
560     }
561     
562     function airDrop(address[] memory _to) external onlyOwner {
563         uint256 qty = _to.length;
564         require((numberMinted + qty) > numberMinted, "Math overflow error");
565         require((numberMinted + qty) <= totalTokens, "Cannot fill order");
566         
567         uint256 mintSeedValue = numberMinted;
568         
569         for(uint256 i = 0; i < qty; i++) {
570             _safeMint(_to[i], mintSeedValue + i);
571             numberMinted ++;  //reservedTokens can be reset, numberMinted can not
572         }
573     }
574     
575     function mintWL(uint256 qty) external payable reentryLock {
576         require(whitelistActive, "WL not open");
577         require(msg.value == qty * WLprice, "WL: Wrong Eth Amount");
578         require((qty + numberMinted) <= totalTokens, "WL: Not enough avaialability");
579         require(_whitelist[_msgSender()] >= qty, "WL: unauth amount");
580 
581         _whitelist[_msgSender()] -= qty;
582         
583         uint256 mintSeedValue = numberMinted; //Store the starting value of the mint batch
584 
585         //send tokens
586         for(uint256 i = 0; i < qty; i++) {
587             _safeMint(_msgSender(), mintSeedValue + i);
588             numberMinted ++;
589         }
590 
591     }
592 
593     function mint(uint256 qty) external payable reentryLock {
594         require(mintActive, "mint not open");
595         require(msg.value >= qty * price, "Mint: Insufficient Funds");
596         require(qty <= maxPerTxn, "Mint: Above Trxn Threshold!");
597         require((qty + numberMinted) <= totalTokens, "Mint: Not enough avaialability");
598         
599         uint256 mintSeedValue = numberMinted; //Store the starting value of the mint batch
600 
601         //send tokens
602         for(uint256 i = 0; i < qty; i++) {
603             _safeMint(_msgSender(), mintSeedValue + i);
604             numberMinted ++;
605         }
606     }
607     
608     // allows holders to burn their own tokens if desired
609     function burn(uint256 tokenID) external {
610         require(_msgSender() == ownerOf(tokenID));
611         _burn(tokenID);
612     }
613     
614     //////////////////////////////////////////////////////////////
615     //////////////////// Setters and Getters /////////////////////
616     //////////////////////////////////////////////////////////////
617     
618     function whiteList(address account) external onlyOwner {
619         _whitelist[account] = whiteListMax;
620     }
621     
622     function whiteListMany(address[] memory accounts) external onlyOwner {
623         for (uint256 i; i < accounts.length; i++) {
624             _whitelist[accounts[i]] = whiteListMax;
625         }
626     }
627 
628     function checkWhitelist(address testAddress) external view returns (uint256) {
629         return _whitelist[testAddress];
630     }
631     
632     function setMaxMintThreshold(uint256 maxMints) external onlyOwner {
633         maxPerTxn = maxMints;
634     }
635     
636     function setWhitelistThreshold(uint whitelisterBuyLimit) external onlyOwner {
637         whiteListMax = whitelisterBuyLimit;
638     }
639     
640     function setBaseURI(string memory newURI) public onlyOwner {
641         _baseURI = newURI;
642     }
643     
644     function activateMint() public onlyOwner {
645         mintActive = true;
646     }
647     
648     function deactivateMint() public onlyOwner {
649         mintActive = false;
650     }
651 
652     function activateWL() public onlyOwner {
653         whitelistActive = true;
654     }
655     
656     function deactivateWL() public onlyOwner {
657         whitelistActive = false;
658     }
659     
660     function setPrice(uint256 newPrice) public onlyOwner {
661         price = newPrice;
662     }
663 
664     function setWhitelistPrice(uint256 newPrice) public onlyOwner {
665         WLprice = newPrice;
666     }
667 
668     function setTotalTokens(uint256 numTokens) public onlyOwner {
669         totalTokens = numTokens;
670     }
671 
672     function totalSupply() external view returns (uint256) {
673         return numberMinted; //stupid bs for etherscan's call
674     }
675     
676     function hideTokens() external onlyOwner {
677         _hideTokens = true;
678     }
679     
680     function revealTokens() external onlyOwner {
681         _hideTokens = false;
682     }
683     
684     function getBalance(address tokenAddress) view external returns (uint256) {
685         //return _balances[tokenAddress]; //shows 0 on etherscan due to overflow error
686         return _balances[tokenAddress] / (10**15); //temporary fix to report in finneys
687     }
688 
689     /**
690      * @dev See {IERC721-balanceOf}.
691      */
692     function balanceOf(address owner) public view virtual override returns (uint256) {
693         require(owner != address(0), "ERC721: bal qry for zero address");
694         return _balances[owner];
695     }
696 
697     /**
698      * @dev See {IERC721-ownerOf}.
699      */
700     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
701         address owner = _owners[tokenId];
702         require(owner != address(0), "ERC721: own query nonexist tkn");
703         return owner;
704     }
705 
706     /**
707      * @dev See {IERC721-approve}.
708      */
709     function approve(address to, uint256 tokenId) public virtual override {
710         address owner = ownerOf(tokenId);
711         require(to != owner, "ERC721: approval current owner");
712 
713         require(
714             msg.sender == owner || isApprovedForAll(owner, msg.sender),
715             "ERC721: caller !owner/!approved"
716         );
717 
718         _approve(to, tokenId);
719     }
720 
721     /**
722      * @dev See {IERC721-getApproved}.
723      */
724     function getApproved(uint256 tokenId) public view virtual override returns (address) {
725         require(_exists(tokenId), "ERC721: approved nonexistent tkn");
726         return _tokenApprovals[tokenId];
727     }
728 
729     /**
730      * @dev See {IERC721-setApprovalForAll}.
731      */
732     function setApprovalForAll(address operator, bool approved) public virtual override {
733         require(operator != msg.sender, "ERC721: approve to caller");
734 
735         _operatorApprovals[msg.sender][operator] = approved;
736         emit ApprovalForAll(msg.sender, operator, approved);
737     }
738 
739     /**
740      * @dev See {IERC721-isApprovedForAll}.
741      */
742     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
743         return _operatorApprovals[owner][operator];
744     }
745 
746     /**
747      * @dev See {IERC721-transferFrom}.
748      */
749     function transferFrom(
750         address from,
751         address to,
752         uint256 tokenId
753     ) public virtual override {
754         //solhint-disable-next-line max-line-length
755         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: txfr !owner/approved");
756         _transfer(from, to, tokenId);
757     }
758 
759     /**
760      * @dev See {IERC721-safeTransferFrom}.
761      */
762     function safeTransferFrom(
763         address from,
764         address to,
765         uint256 tokenId
766     ) public virtual override {
767         safeTransferFrom(from, to, tokenId, "");
768     }
769 
770     /**
771      * @dev See {IERC721-safeTransferFrom}.
772      */
773     function safeTransferFrom(
774         address from,
775         address to,
776         uint256 tokenId,
777         bytes memory _data
778     ) public virtual override {
779         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: txfr !owner/approved");
780         _safeTransfer(from, to, tokenId, _data);
781     }
782 
783     /**
784      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
785      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
786      *
787      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
788      *
789      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
790      * implement alternative mechanisms to perform token transfer, such as signature-based.
791      *
792      * Requirements:
793      *
794      * - `from` cannot be the zero address.
795      * - `to` cannot be the zero address.
796      * - `tokenId` token must exist and be owned by `from`.
797      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
798      *
799      * Emits a {Transfer} event.
800      */
801     function _safeTransfer(
802         address from,
803         address to,
804         uint256 tokenId,
805         bytes memory _data
806     ) internal virtual {
807         _transfer(from, to, tokenId);
808         require(_checkOnERC721Received(from, to, tokenId, _data), "txfr to non ERC721Reciever");
809     }
810 
811     /**
812      * @dev Returns whether `tokenId` exists.
813      *
814      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
815      *
816      * Tokens start existing when they are minted (`_mint`),
817      * and stop existing when they are burned (`_burn`).
818      */
819     function _exists(uint256 tokenId) internal view virtual returns (bool) {
820         return _owners[tokenId] != address(0);
821     }
822 
823     /**
824      * @dev Returns whether `spender` is allowed to manage `tokenId`.
825      *
826      * Requirements:
827      *
828      * - `tokenId` must exist.
829      */
830     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
831         require(_exists(tokenId), "ERC721: op query nonexistent tkn");
832         address owner = ownerOf(tokenId);
833         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
834     }
835 
836     /**
837      * @dev Safely mints `tokenId` and transfers it to `to`.
838      *
839      * Requirements:
840      *
841      * - `tokenId` must not exist.
842      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
843      *
844      * Emits a {Transfer} event.
845      */
846     function _safeMint(address to, uint256 tokenId) internal virtual {
847         _safeMint(to, tokenId, "");
848     }
849 
850     /**
851      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
852      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
853      */
854     function _safeMint(
855         address to,
856         uint256 tokenId,
857         bytes memory _data
858     ) internal virtual {
859         _mint(to, tokenId);
860         require(
861             _checkOnERC721Received(address(0), to, tokenId, _data),
862             "txfr to non ERC721Reciever"
863         );
864     }
865 
866     /**
867      * @dev Mints `tokenId` and transfers it to `to`.
868      *
869      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
870      *
871      * Requirements:
872      *
873      * - `tokenId` must not exist.
874      * - `to` cannot be the zero address.
875      *
876      * Emits a {Transfer} event.
877      */
878     function _mint(address to, uint256 tokenId) internal virtual {
879         require(to != address(0), "ERC721: mint to the zero address");
880         require(!_exists(tokenId), "ERC721: token already minted");
881 
882         _beforeTokenTransfer(address(0), to, tokenId);
883 
884         _balances[to] += 1;
885         _owners[tokenId] = to;
886 
887         emit Transfer(address(0), to, tokenId);
888     }
889 
890     /**
891      * @dev Destroys `tokenId`.
892      * The approval is cleared when the token is burned.
893      *
894      * Requirements:
895      *
896      * - `tokenId` must exist.
897      *
898      * Emits a {Transfer} event.
899      */
900     function _burn(uint256 tokenId) internal virtual {
901         address owner = ownerOf(tokenId);
902 
903         _beforeTokenTransfer(owner, address(0), tokenId);
904 
905         // Clear approvals
906         _approve(address(0), tokenId);
907 
908         _balances[owner] -= 1;
909         delete _owners[tokenId];
910 
911         emit Transfer(owner, address(0), tokenId);
912     }
913 
914     /**
915      * @dev Transfers `tokenId` from `from` to `to`.
916      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
917      *
918      * Requirements:
919      *
920      * - `to` cannot be the zero address.
921      * - `tokenId` token must be owned by `from`.
922      *
923      * Emits a {Transfer} event.
924      */
925     function _transfer(
926         address from,
927         address to,
928         uint256 tokenId
929     ) internal virtual {
930         require(ownerOf(tokenId) == from, "ERC721: txfr token not owned");
931         require(to != address(0), "ERC721: txfr to 0x0 address");
932         _beforeTokenTransfer(from, to, tokenId);
933 
934         // Clear approvals from the previous owner
935         _approve(address(0), tokenId);
936 
937         _balances[from] -= 1;
938         _balances[to] += 1;
939         _owners[tokenId] = to;
940 
941         emit Transfer(from, to, tokenId);
942     }
943 
944     /**
945      * @dev Approve `to` to operate on `tokenId`
946      *
947      * Emits a {Approval} event.
948      */
949     function _approve(address to, uint256 tokenId) internal virtual {
950         _tokenApprovals[tokenId] = to;
951         emit Approval(ownerOf(tokenId), to, tokenId);
952     }
953 
954     /**
955      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
956      * The call is not executed if the target address is not a contract.
957      *
958      * @param from address representing the previous owner of the given token ID
959      * @param to target address that will receive the tokens
960      * @param tokenId uint256 ID of the token to be transferred
961      * @param _data bytes optional data to send along with the call
962      * @return bool whether the call correctly returned the expected magic value
963      */
964     function _checkOnERC721Received(
965         address from,
966         address to,
967         uint256 tokenId,
968         bytes memory _data
969     ) private returns (bool) {
970         if (to.isContract()) {
971             try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
972                 return retval == IERC721Receiver(to).onERC721Received.selector;
973             } catch (bytes memory reason) {
974                 if (reason.length == 0) {
975                     revert("txfr to non ERC721Reciever");
976                 } else {
977                     assembly {
978                         revert(add(32, reason), mload(reason))
979                     }
980                 }
981             }
982         } else {
983             return true;
984         }
985     }
986     
987     // *********************** ERC721 Token Receiver **********************
988     /**
989      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
990      * by `operator` from `from`, this function is called.
991      *
992      * It must return its Solidity selector to confirm the token transfer.
993      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
994      *
995      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
996      */
997     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4) {
998         //InterfaceID=0x150b7a02
999         return this.onERC721Received.selector;
1000     }
1001 
1002     /**
1003      * @dev Hook that is called before any token transfer. This includes minting
1004      * and burning.
1005      *
1006      * Calling conditions:
1007      *
1008      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1009      * transferred to `to`.
1010      * - When `from` is zero, `tokenId` will be minted for `to`.
1011      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1012      * - `from` and `to` are never both zero.
1013      *
1014      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1015      */
1016     function _beforeTokenTransfer(
1017         address from,
1018         address to,
1019         uint256 tokenId
1020     ) internal virtual {}
1021 
1022     // **************************************** Metadata Standard Functions **********
1023     //@dev Returns the token collection name.
1024     function name() external view returns (string memory){
1025         return _name;
1026     }
1027 
1028     //@dev Returns the token collection symbol.
1029     function symbol() external view returns (string memory){
1030         return _symbol;
1031     }
1032 
1033     //@dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1034     function tokenURI(uint256 tokenId) external view returns (string memory){
1035         require(_exists(tokenId), "ERC721Metadata: URI 0x0 token");
1036         string memory tokenuri;
1037         
1038         if (_hideTokens) {
1039             //redirect to mystery box
1040             tokenuri = string(abi.encodePacked(_baseURI, "mystery.json"));
1041         } else {
1042             //Input flag data here to send to reveal URI
1043             tokenuri = string(abi.encodePacked(_baseURI, toString(tokenId), ".json"));
1044         }
1045         
1046         return tokenuri;
1047     }
1048     
1049     function contractURI() public view returns (string memory) {
1050             return string(abi.encodePacked(_baseURI,"contract.json"));
1051     }
1052     // *******************************************************************************
1053 
1054     receive() external payable {}
1055     
1056     fallback() external payable {}
1057 }