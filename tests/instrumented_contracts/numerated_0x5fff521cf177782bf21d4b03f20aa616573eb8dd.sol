1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /*
6     Fully commented standard ERC721 Distilled from OpenZeppelin Docs
7     Base for Building ERC721 by Martin McConnell
8     All the utility without the fluff.*/
9 
10 
11 interface IERC165 {
12     function supportsInterface(bytes4 interfaceId) external view returns (bool);
13 }
14 
15 interface IERC721 is IERC165 {
16     //@dev Emitted when `tokenId` token is transferred from `from` to `to`.
17     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
18 
19     //@dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
20     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
21 
22     //@dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
23     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
24 
25     //@dev Returns the number of tokens in ``owner``'s account.
26     function balanceOf(address owner) external view returns (uint256 balance);
27 
28     /**
29      * @dev Returns the owner of the `tokenId` token.
30      *
31      * Requirements:
32      *
33      * - `tokenId` must exist.
34      */
35     function ownerOf(uint256 tokenId) external view returns (address owner);
36 
37     /**
38      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
39      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
40      *
41      * Requirements:
42      *
43      * - `from` cannot be the zero address.
44      * - `to` cannot be the zero address.
45      * - `tokenId` token must exist and be owned by `from`.
46      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
47      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
48      *
49      * Emits a {Transfer} event.
50      */
51     function safeTransferFrom(address from,address to,uint256 tokenId) external;
52 
53     /**
54      * @dev Transfers `tokenId` token from `from` to `to`.
55      *
56      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
57      *
58      * Requirements:
59      *
60      * - `from` cannot be the zero address.
61      * - `to` cannot be the zero address.
62      * - `tokenId` token must be owned by `from`.
63      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(address from, address to, uint256 tokenId) external;
68 
69     /**
70      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
71      * The approval is cleared when the token is transferred.
72      *
73      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
74      *
75      * Requirements:
76      *
77      * - The caller must own the token or be an approved operator.
78      * - `tokenId` must exist.
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address to, uint256 tokenId) external;
83 
84     /**
85      * @dev Returns the account approved for `tokenId` token.
86      *
87      * Requirements:
88      *
89      * - `tokenId` must exist.
90      */
91     function getApproved(uint256 tokenId) external view returns (address operator);
92 
93     /**
94      * @dev Approve or remove `operator` as an operator for the caller.
95      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
96      *
97      * Requirements:
98      * - The `operator` cannot be the caller.
99      *
100      * Emits an {ApprovalForAll} event.
101      */
102     function setApprovalForAll(address operator, bool _approved) external;
103 
104     //@dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
105     function isApprovedForAll(address owner, address operator) external view returns (bool);
106 
107     /**
108      * @dev Safely transfers `tokenId` token from `from` to `to`.
109      *
110      * Requirements:
111      *
112      * - `from` cannot be the zero address.
113      * - `to` cannot be the zero address.
114      * - `tokenId` token must exist and be owned by `from`.
115      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
116      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
117      *
118      * Emits a {Transfer} event.
119      */
120     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
121 }
122 
123 interface IERC721Metadata is IERC721 {
124     //@dev Returns the token collection name.
125     function name() external view returns (string memory);
126 
127     //@dev Returns the token collection symbol.
128     function symbol() external view returns (string memory);
129 
130     //@dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
131     function tokenURI(uint256 tokenId) external view returns (string memory);
132 }
133 
134 interface IERC721Receiver {
135     /**
136      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
137      * by `operator` from `from`, this function is called.
138      *
139      * It must return its Solidity selector to confirm the token transfer.
140      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
141      *
142      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
143      */
144     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
145 }
146 
147 library Address {
148     /**
149      * @dev Returns true if `account` is a contract.
150      *
151      * [IMPORTANT]
152      * ====
153      * It is unsafe to assume that an address for which this function returns
154      * false is an externally-owned account (EOA) and not a contract.
155      *
156      * Among others, `isContract` will return false for the following
157      * types of addresses:
158      *
159      *  - an externally-owned account
160      *  - a contract in construction
161      *  - an address where a contract will be created
162      *  - an address where a contract lived, but was destroyed
163      * ====
164      */
165     function isContract(address account) internal view returns (bool) {
166         // This method relies on extcodesize, which returns 0 for contracts in
167         // construction, since the code is only stored at the end of the
168         // constructor execution.
169 
170         uint256 size;
171         assembly {
172             size := extcodesize(account)
173         }
174         return size > 0;
175     }
176 
177     /**
178      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
179      * `recipient`, forwarding all available gas and reverting on errors.
180      *
181      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
182      * of certain opcodes, possibly making contracts go over the 2300 gas limit
183      * imposed by `transfer`, making them unable to receive funds via
184      * `transfer`. {sendValue} removes this limitation.
185      *
186      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
187      *
188      * IMPORTANT: because control is transferred to `recipient`, care must be
189      * taken to not create reentrancy vulnerabilities. Consider using
190      * {ReentrancyGuard} or the
191      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
192      */
193     function sendValue(address payable recipient, uint256 amount) internal {
194         require(address(this).balance >= amount, "Address: insufficient balance");
195 
196         (bool success, ) = recipient.call{value: amount}("");
197         require(success, "Addr: cant send val, rcpt revert");
198     }
199 
200     /**
201      * @dev Performs a Solidity function call using a low level `call`. A
202      * plain `call` is an unsafe replacement for a function call: use this
203      * function instead.
204      *
205      * If `target` reverts with a revert reason, it is bubbled up by this
206      * function (like regular Solidity function calls).
207      *
208      * Returns the raw returned data. To convert to the expected return value,
209      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
210      *
211      * Requirements:
212      *
213      * - `target` must be a contract.
214      * - calling `target` with `data` must not revert.
215      *
216      * _Available since v3.1._
217      */
218     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
219         return functionCall(target, data, "Address: low-level call failed");
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
224      * `errorMessage` as a fallback revert reason when `target` reverts.
225      *
226      * _Available since v3.1._
227      */
228     function functionCall(
229         address target,
230         bytes memory data,
231         string memory errorMessage
232     ) internal returns (bytes memory) {
233         return functionCallWithValue(target, data, 0, errorMessage);
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
238      * but also transferring `value` wei to `target`.
239      *
240      * Requirements:
241      *
242      * - the calling contract must have an ETH balance of at least `value`.
243      * - the called Solidity function must be `payable`.
244      *
245      * _Available since v3.1._
246      */
247     function functionCallWithValue(
248         address target,
249         bytes memory data,
250         uint256 value
251     ) internal returns (bytes memory) {
252         return functionCallWithValue(target, data, value, "Addr: low-level call value fail");
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
257      * with `errorMessage` as a fallback revert reason when `target` reverts.
258      *
259      * _Available since v3.1._
260      */
261     function functionCallWithValue(
262         address target,
263         bytes memory data,
264         uint256 value,
265         string memory errorMessage
266     ) internal returns (bytes memory) {
267         require(address(this).balance >= value, "Addr: insufficient balance call");
268         require(isContract(target), "Address: call to non-contract");
269 
270         (bool success, bytes memory returndata) = target.call{value: value}(data);
271         return _verifyCallResult(success, returndata, errorMessage);
272     }
273 
274     /**
275      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
276      * but performing a static call.
277      *
278      * _Available since v3.3._
279      */
280     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
281         return functionStaticCall(target, data, "Addr: low-level static call fail");
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
286      * but performing a static call.
287      *
288      * _Available since v3.3._
289      */
290     function functionStaticCall(
291         address target,
292         bytes memory data,
293         string memory errorMessage
294     ) internal view returns (bytes memory) {
295         require(isContract(target), "Addr: static call non-contract");
296 
297         (bool success, bytes memory returndata) = target.staticcall(data);
298         return _verifyCallResult(success, returndata, errorMessage);
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
303      * but performing a delegate call.
304      *
305      * _Available since v3.4._
306      */
307     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
308         return functionDelegateCall(target, data, "Addr: low-level del call failed");
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
313      * but performing a delegate call.
314      *
315      * _Available since v3.4._
316      */
317     function functionDelegateCall(
318         address target,
319         bytes memory data,
320         string memory errorMessage
321     ) internal returns (bytes memory) {
322         require(isContract(target), "Addr: delegate call non-contract");
323 
324         (bool success, bytes memory returndata) = target.delegatecall(data);
325         return _verifyCallResult(success, returndata, errorMessage);
326     }
327 
328     function _verifyCallResult(
329         bool success,
330         bytes memory returndata,
331         string memory errorMessage
332     ) private pure returns (bytes memory) {
333         if (success) {
334             return returndata;
335         } else {
336             // Look for revert reason and bubble it up if present
337             if (returndata.length > 0) {
338                 // The easiest way to bubble the revert reason is using memory via assembly
339 
340                 assembly {
341                     let returndata_size := mload(returndata)
342                     revert(add(32, returndata), returndata_size)
343                 }
344             } else {
345                 revert(errorMessage);
346             }
347         }
348     }
349 }
350 
351 abstract contract Context {
352     function _msgSender() internal view virtual returns (address) {
353         return msg.sender;
354     }
355 
356     function _msgData() internal view virtual returns (bytes calldata) {
357         return msg.data;
358     }
359 }
360 
361 abstract contract Ownable is Context {
362     address private _owner;
363 
364     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
365 
366     /**
367      * @dev Initializes the contract setting the deployer as the initial owner.
368      */
369     constructor() {
370         _setOwner(_msgSender());
371     }
372 
373     /**
374      * @dev Returns the address of the current owner.
375      */
376     function owner() public view virtual returns (address) {
377         return _owner;
378     }
379 
380     /**
381      * @dev Throws if called by any account other than the owner.
382      */
383     modifier onlyOwner() {
384         require(owner() == _msgSender(), "Ownable: caller is not the owner");
385         _;
386     }
387 
388     /**
389      * @dev Leaves the contract without owner. It will not be possible to call
390      * `onlyOwner` functions anymore. Can only be called by the current owner.
391      *
392      * NOTE: Renouncing ownership will leave the contract without an owner,
393      * thereby removing any functionality that is only available to the owner.
394      */
395     function renounceOwnership() public virtual onlyOwner {
396         _setOwner(address(0));
397     }
398 
399     /**
400      * @dev Transfers ownership of the contract to a new account (`newOwner`).
401      * Can only be called by the current owner.
402      */
403     function transferOwnership(address newOwner) public virtual onlyOwner {
404         require(newOwner != address(0), "Ownable: new owner is 0x address");
405         _setOwner(newOwner);
406     }
407 
408     function _setOwner(address newOwner) private {
409         address oldOwner = _owner;
410         _owner = newOwner;
411         emit OwnershipTransferred(oldOwner, newOwner);
412     }
413 }
414 
415 abstract contract Functional {
416     function toString(uint256 value) internal pure returns (string memory) {
417         if (value == 0) {
418             return "0";
419         }
420         uint256 temp = value;
421         uint256 digits;
422         while (temp != 0) {
423             digits++;
424             temp /= 10;
425         }
426         bytes memory buffer = new bytes(digits);
427         while (value != 0) {
428             digits -= 1;
429             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
430             value /= 10;
431         }
432         return string(buffer);
433     }
434     
435     bool private _reentryKey = false;
436     modifier reentryLock {
437         require(!_reentryKey, "attempt reenter locked function");
438         _reentryKey = true;
439         _;
440         _reentryKey = false;
441     }
442 }
443 
444 
445 // ******************************************************************************************************************************
446 // **************************************************  Start of Main Contract ***************************************************
447 // ******************************************************************************************************************************
448 
449 contract Reflections is IERC721, Ownable, Functional {
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
481     uint256 public maxPerWallet;
482     uint256 public reservedTokens;
483     
484     mapping(address => uint256) private _mintTracker;
485     mapping(address => bool) private _whitelist;
486     
487 	address doxxed = payable(0xC1FDc68dc63d3316F32420d4d2c3DeA43091bCDD); 
488     address artist = payable(0x5039CDa148fDd50818D5Eb8dBfd8bE0c0Bd1B082);
489     address toronto = payable(0xB9f14dae23fe34c267881339B35dCE1e297093Da);
490 
491     /**
492      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
493      */
494     constructor() {
495         _name = "Reflections NFT";
496         _symbol = "RFL";
497         _baseURI = "https://reflectionsnft.io/metadata/";
498         _hideTokens = true;
499         
500         
501         totalTokens = 3333;
502         price = 100 * (10 ** 15); // Replace leading value with price in finney
503 
504         maxPerWallet = 2;
505         reservedTokens = 233; // uncomment to reserve tokens for the owner or other purposes
506     }
507 
508     //@dev See {IERC165-supportsInterface}. Interfaces Supported by this Standard
509     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
510         return  interfaceId == type(IERC721).interfaceId ||
511                 interfaceId == type(IERC721Metadata).interfaceId ||
512                 interfaceId == type(IERC165).interfaceId ||
513                 interfaceId == Reflections.onERC721Received.selector;
514     }
515     
516     // Standard Withdraw function for the owner to pull the contract
517     function withdraw() external onlyOwner {
518         uint256 totalBalance = address(this).balance;
519 
520         bool success;
521 
522         uint256 sendAmount = (totalBalance * 55) / 100;
523         (success, ) = doxxed.call{value: sendAmount}("");
524         require(success, "Transaction Unsuccessful");
525 
526         sendAmount = (totalBalance * 30) / 100;
527         (success, ) = artist.call{value: sendAmount}("");
528         require(success, "Transaction Unsuccessful");
529 
530         sendAmount = (totalBalance * 15) / 100;
531         (success, ) = toronto.call{value: sendAmount}("");
532         require(success, "Transaction Unsuccessful");
533     }
534     
535     function ownerMint(address _to, uint256 qty) external onlyOwner {
536         require((numberMinted + qty) > numberMinted, "Math overflow error");
537         require((numberMinted + qty) <= totalTokens, "Cannot fill order");
538         
539         uint256 mintSeedValue = numberMinted; //Store the starting value of the mint batch
540         if (reservedTokens >= qty) {
541             reservedTokens -= qty;
542         } else {
543             reservedTokens = 0;
544         }
545         
546         for(uint256 i = 0; i < qty; i++) {
547             _safeMint(_to, mintSeedValue + i);
548             numberMinted ++;  //reservedTokens can be reset, numberMinted can not
549         }
550     }
551     
552     function airDrop(address[] memory _to) external onlyOwner {
553         uint256 qty = _to.length;
554         require((numberMinted + qty) > numberMinted, "Math overflow error");
555         require((numberMinted + qty) <= totalTokens, "Cannot fill order");
556         
557         uint256 mintSeedValue = numberMinted;
558         if (reservedTokens >= qty) {
559             reservedTokens -= qty;
560         } else {
561             reservedTokens = 0;
562         }
563         
564         for(uint256 i = 0; i < qty; i++) {
565             _safeMint(_to[i], mintSeedValue + i);
566             numberMinted ++;  //reservedTokens can be reset, numberMinted can not
567         }
568     }
569     
570     function mint() external payable reentryLock {
571         address _to = _msgSender();
572         require(msg.value == price, "Mint: Insufficient Funds");
573         require((1 + reservedTokens + numberMinted) <= totalTokens, "Mint: Not enough avaialability");
574         require((_mintTracker[_msgSender()] + 1) <= maxPerWallet, "Mint: Max tkn per wallet exceeded");
575         require(mintActive, "Mint not open");
576         
577         uint256 mintSeedValue = numberMinted; //Store the starting value of the mint batch
578         _mintTracker[_msgSender()]++;
579 
580         //send tokens
581         _safeMint(_to, mintSeedValue);
582         numberMinted ++;
583     }
584 
585     function WLmint() external payable reentryLock {
586         address _to = _msgSender();
587         require(msg.value == price, "Mint: Insufficient Funds");
588         require((1 + reservedTokens + numberMinted) <= totalTokens, "Mint: Not enough avaialability");
589         require(whitelistActive, "Whitelist not open");
590         require(_whitelist[_msgSender()] == true, "not Whitelisted or already purchased");
591 
592         _whitelist[_msgSender()] = false; //clear name from whitelist
593         _mintTracker[_msgSender()]++;
594         
595         uint256 mintSeedValue = numberMinted; //Store the starting value of the mint batch
596 
597         //send tokens
598         _safeMint(_to, mintSeedValue);
599         numberMinted ++;
600     }
601 
602     // allows holders to burn their own tokens if desired
603     function burn(uint256 tokenID) external {
604         require(_msgSender() == ownerOf(tokenID));
605         _burn(tokenID);
606     }
607     
608     //////////////////////////////////////////////////////////////
609     //////////////////// Setters and Getters /////////////////////
610     //////////////////////////////////////////////////////////////
611     
612     function whiteList(address account) external onlyOwner {
613         _whitelist[account] = true;
614     }
615     
616     function whiteListMany(address[] memory accounts) external onlyOwner {
617         for (uint256 i; i < accounts.length; i++) {
618             _whitelist[accounts[i]] = true;
619         }
620     }
621     
622     function checkWhitelist(address testAddress) external view returns (bool) {
623         if (_whitelist[testAddress] == true) { return true; }
624         return false;
625     }
626     
627     function setMaxWalletThreshold(uint256 maxWallet) external onlyOwner {
628         maxPerWallet = maxWallet;
629     }
630     
631     function setBaseURI(string memory newURI) public onlyOwner {
632         _baseURI = newURI;
633     }
634     
635     function activateMint() public onlyOwner {
636         mintActive = true;
637     }
638     
639     function deactivateMint() public onlyOwner {
640         mintActive = false;
641     }
642 
643     function activateWL() public onlyOwner {
644         whitelistActive = true;
645     }
646     
647     function deactivateWL() public onlyOwner {
648         whitelistActive = false;
649     }
650     
651     function setPrice(uint256 newPrice) public onlyOwner {
652         price = newPrice;
653     }
654     
655     function setTotalTokens(uint256 numTokens) public onlyOwner {
656         totalTokens = numTokens;
657     }
658     
659     function setReserve(uint256 newReserve) public onlyOwner {
660         reservedTokens = newReserve;
661     }
662 
663     function totalSupply() external view returns (uint256) {
664         return numberMinted; //stupid bs for etherscan's call
665     }
666     
667     function hideTokens() external onlyOwner {
668         _hideTokens = true;
669     }
670     
671     function revealTokens() external onlyOwner {
672         _hideTokens = false;
673     }
674     
675     function getBalance(address tokenAddress) view external returns (uint256) {
676         //return _balances[tokenAddress]; //shows 0 on etherscan due to overflow error
677         return _balances[tokenAddress] / (10**15); //temporary fix to report in finneys
678     }
679 
680     /**
681      * @dev See {IERC721-balanceOf}.
682      */
683     function balanceOf(address owner) public view virtual override returns (uint256) {
684         require(owner != address(0), "ERC721: bal qry for zero address");
685         return _balances[owner];
686     }
687 
688     /**
689      * @dev See {IERC721-ownerOf}.
690      */
691     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
692         address owner = _owners[tokenId];
693         require(owner != address(0), "ERC721: own query nonexist tkn");
694         return owner;
695     }
696 
697     /**
698      * @dev See {IERC721-approve}.
699      */
700     function approve(address to, uint256 tokenId) public virtual override {
701         address owner = ownerOf(tokenId);
702         require(to != owner, "ERC721: approval current owner");
703 
704         require(
705             msg.sender == owner || isApprovedForAll(owner, msg.sender),
706             "ERC721: caller !owner/!approved"
707         );
708 
709         _approve(to, tokenId);
710     }
711 
712     /**
713      * @dev See {IERC721-getApproved}.
714      */
715     function getApproved(uint256 tokenId) public view virtual override returns (address) {
716         require(_exists(tokenId), "ERC721: approved nonexistent tkn");
717         return _tokenApprovals[tokenId];
718     }
719 
720     /**
721      * @dev See {IERC721-setApprovalForAll}.
722      */
723     function setApprovalForAll(address operator, bool approved) public virtual override {
724         require(operator != msg.sender, "ERC721: approve to caller");
725 
726         _operatorApprovals[msg.sender][operator] = approved;
727         emit ApprovalForAll(msg.sender, operator, approved);
728     }
729 
730     /**
731      * @dev See {IERC721-isApprovedForAll}.
732      */
733     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
734         return _operatorApprovals[owner][operator];
735     }
736 
737     /**
738      * @dev See {IERC721-transferFrom}.
739      */
740     function transferFrom(
741         address from,
742         address to,
743         uint256 tokenId
744     ) public virtual override {
745         //solhint-disable-next-line max-line-length
746         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: txfr !owner/approved");
747         _transfer(from, to, tokenId);
748     }
749 
750     /**
751      * @dev See {IERC721-safeTransferFrom}.
752      */
753     function safeTransferFrom(
754         address from,
755         address to,
756         uint256 tokenId
757     ) public virtual override {
758         safeTransferFrom(from, to, tokenId, "");
759     }
760 
761     /**
762      * @dev See {IERC721-safeTransferFrom}.
763      */
764     function safeTransferFrom(
765         address from,
766         address to,
767         uint256 tokenId,
768         bytes memory _data
769     ) public virtual override {
770         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: txfr !owner/approved");
771         _safeTransfer(from, to, tokenId, _data);
772     }
773 
774     /**
775      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
776      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
777      *
778      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
779      *
780      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
781      * implement alternative mechanisms to perform token transfer, such as signature-based.
782      *
783      * Requirements:
784      *
785      * - `from` cannot be the zero address.
786      * - `to` cannot be the zero address.
787      * - `tokenId` token must exist and be owned by `from`.
788      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
789      *
790      * Emits a {Transfer} event.
791      */
792     function _safeTransfer(
793         address from,
794         address to,
795         uint256 tokenId,
796         bytes memory _data
797     ) internal virtual {
798         _transfer(from, to, tokenId);
799         require(_checkOnERC721Received(from, to, tokenId, _data), "txfr to non ERC721Reciever");
800     }
801 
802     /**
803      * @dev Returns whether `tokenId` exists.
804      *
805      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
806      *
807      * Tokens start existing when they are minted (`_mint`),
808      * and stop existing when they are burned (`_burn`).
809      */
810     function _exists(uint256 tokenId) internal view virtual returns (bool) {
811         return _owners[tokenId] != address(0);
812     }
813 
814     /**
815      * @dev Returns whether `spender` is allowed to manage `tokenId`.
816      *
817      * Requirements:
818      *
819      * - `tokenId` must exist.
820      */
821     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
822         require(_exists(tokenId), "ERC721: op query nonexistent tkn");
823         address owner = ownerOf(tokenId);
824         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
825     }
826 
827     /**
828      * @dev Safely mints `tokenId` and transfers it to `to`.
829      *
830      * Requirements:
831      *
832      * - `tokenId` must not exist.
833      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
834      *
835      * Emits a {Transfer} event.
836      */
837     function _safeMint(address to, uint256 tokenId) internal virtual {
838         _safeMint(to, tokenId, "");
839     }
840 
841     /**
842      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
843      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
844      */
845     function _safeMint(
846         address to,
847         uint256 tokenId,
848         bytes memory _data
849     ) internal virtual {
850         _mint(to, tokenId);
851         require(
852             _checkOnERC721Received(address(0), to, tokenId, _data),
853             "txfr to non ERC721Reciever"
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
869     function _mint(address to, uint256 tokenId) internal virtual {
870         require(to != address(0), "ERC721: mint to the zero address");
871         require(!_exists(tokenId), "ERC721: token already minted");
872 
873         _beforeTokenTransfer(address(0), to, tokenId);
874 
875         _balances[to] += 1;
876         _owners[tokenId] = to;
877 
878         emit Transfer(address(0), to, tokenId);
879     }
880 
881     /**
882      * @dev Destroys `tokenId`.
883      * The approval is cleared when the token is burned.
884      *
885      * Requirements:
886      *
887      * - `tokenId` must exist.
888      *
889      * Emits a {Transfer} event.
890      */
891     function _burn(uint256 tokenId) internal virtual {
892         address owner = ownerOf(tokenId);
893 
894         _beforeTokenTransfer(owner, address(0), tokenId);
895 
896         // Clear approvals
897         _approve(address(0), tokenId);
898 
899         _balances[owner] -= 1;
900         delete _owners[tokenId];
901 
902         emit Transfer(owner, address(0), tokenId);
903     }
904 
905     /**
906      * @dev Transfers `tokenId` from `from` to `to`.
907      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
908      *
909      * Requirements:
910      *
911      * - `to` cannot be the zero address.
912      * - `tokenId` token must be owned by `from`.
913      *
914      * Emits a {Transfer} event.
915      */
916     function _transfer(
917         address from,
918         address to,
919         uint256 tokenId
920     ) internal virtual {
921         require(ownerOf(tokenId) == from, "ERC721: txfr token not owned");
922         require(to != address(0), "ERC721: txfr to 0x0 address");
923         _beforeTokenTransfer(from, to, tokenId);
924 
925         // Clear approvals from the previous owner
926         _approve(address(0), tokenId);
927 
928         _balances[from] -= 1;
929         _balances[to] += 1;
930         _owners[tokenId] = to;
931 
932         emit Transfer(from, to, tokenId);
933     }
934 
935     /**
936      * @dev Approve `to` to operate on `tokenId`
937      *
938      * Emits a {Approval} event.
939      */
940     function _approve(address to, uint256 tokenId) internal virtual {
941         _tokenApprovals[tokenId] = to;
942         emit Approval(ownerOf(tokenId), to, tokenId);
943     }
944 
945     /**
946      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
947      * The call is not executed if the target address is not a contract.
948      *
949      * @param from address representing the previous owner of the given token ID
950      * @param to target address that will receive the tokens
951      * @param tokenId uint256 ID of the token to be transferred
952      * @param _data bytes optional data to send along with the call
953      * @return bool whether the call correctly returned the expected magic value
954      */
955     function _checkOnERC721Received(
956         address from,
957         address to,
958         uint256 tokenId,
959         bytes memory _data
960     ) private returns (bool) {
961         if (to.isContract()) {
962             try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
963                 return retval == IERC721Receiver(to).onERC721Received.selector;
964             } catch (bytes memory reason) {
965                 if (reason.length == 0) {
966                     revert("txfr to non ERC721Reciever");
967                 } else {
968                     assembly {
969                         revert(add(32, reason), mload(reason))
970                     }
971                 }
972             }
973         } else {
974             return true;
975         }
976     }
977     
978     // *********************** ERC721 Token Receiver **********************
979     /**
980      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
981      * by `operator` from `from`, this function is called.
982      *
983      * It must return its Solidity selector to confirm the token transfer.
984      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
985      *
986      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
987      */
988     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4) {
989         //InterfaceID=0x150b7a02
990         return this.onERC721Received.selector;
991     }
992 
993     /**
994      * @dev Hook that is called before any token transfer. This includes minting
995      * and burning.
996      *
997      * Calling conditions:
998      *
999      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1000      * transferred to `to`.
1001      * - When `from` is zero, `tokenId` will be minted for `to`.
1002      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1003      * - `from` and `to` are never both zero.
1004      *
1005      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1006      */
1007     function _beforeTokenTransfer(
1008         address from,
1009         address to,
1010         uint256 tokenId
1011     ) internal virtual {}
1012 
1013     // **************************************** Metadata Standard Functions **********
1014     //@dev Returns the token collection name.
1015     function name() external view returns (string memory){
1016         return _name;
1017     }
1018 
1019     //@dev Returns the token collection symbol.
1020     function symbol() external view returns (string memory){
1021         return _symbol;
1022     }
1023 
1024     //@dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1025     function tokenURI(uint256 tokenId) external view returns (string memory){
1026         require(_exists(tokenId), "ERC721Metadata: URI 0x0 token");
1027         string memory tokenuri;
1028         
1029         if (_hideTokens) {
1030             //redirect to mystery box
1031             tokenuri = string(abi.encodePacked(_baseURI, "mystery.json"));
1032         } else {
1033             //Input flag data here to send to reveal URI
1034             tokenuri = string(abi.encodePacked(_baseURI, toString(tokenId), ".json"));
1035         }
1036         
1037         return tokenuri;
1038     }
1039     
1040     function contractURI() public view returns (string memory) {
1041             return string(abi.encodePacked(_baseURI,"contract.json"));
1042     }
1043     // *******************************************************************************
1044 
1045     receive() external payable {}
1046     
1047     fallback() external payable {}
1048 }