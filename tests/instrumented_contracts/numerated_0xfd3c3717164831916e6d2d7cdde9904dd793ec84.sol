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
198         require(success, "Address: unable to send value, recipient may have reverted");
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
253         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
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
268         require(address(this).balance >= value, "Address: insufficient balance for call");
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
282         return functionStaticCall(target, data, "Address: low-level static call failed");
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
296         require(isContract(target), "Address: static call to non-contract");
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
309         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
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
323         require(isContract(target), "Address: delegate call to non-contract");
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
405         require(newOwner != address(0), "Ownable: new owner is the zero address");
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
438         require(!_reentryKey, "attempt to reenter a locked function");
439         _reentryKey = true;
440         _;
441         _reentryKey = false;
442     }
443 }
444 
445 contract ERC721 {
446     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
447     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
448     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
449     function balanceOf(address owner) external view returns (uint256 balance){}
450     function ownerOf(uint256 tokenId) external view returns (address owner){}
451     function safeTransferFrom(address from,address to,uint256 tokenId) external{}
452     function transferFrom(address from, address to, uint256 tokenId) external{}
453     function approve(address to, uint256 tokenId) external{}
454     function getApproved(uint256 tokenId) external view returns (address operator){}
455     function setApprovalForAll(address operator, bool _approved) external{}
456     function isApprovedForAll(address owner, address operator) external view returns (bool){}
457     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external{}
458 }
459 
460 // ******************************************************************************************************************************
461 // **************************************************  Start of Main Contract ***************************************************
462 // ******************************************************************************************************************************
463 
464 contract Chameleon is IERC721, Ownable, Functional {
465 
466     using Address for address;
467     
468     // Token name
469     string private _name;
470 
471     // Token symbol
472     string private _symbol;
473     
474     // URI Root Location for Json Files
475     string private _baseURI;
476 
477     // Mapping from token ID to owner address
478     mapping(uint256 => address) private _owners;
479 
480     // Mapping owner address to token count
481     mapping(address => uint256) private _balances;
482 
483     // Mapping from token ID to approved address
484     mapping(uint256 => address) private _tokenApprovals;
485 
486     // Mapping from owner to operator approvals
487     mapping(address => mapping(address => bool)) private _operatorApprovals;
488     
489     // Specific Functionality
490     bool public mintActive;
491     bool public whitelistActive;
492     bool public discountMintActive;
493     bool private _hideTokens;  //for URI redirects
494     uint256 public price;
495     uint256 public totalTokens;
496     uint256 public numberMinted;
497     uint256 public maxPerWallet;
498     uint256 public whitelistMax;
499     uint256 public reservedTokens;
500     uint256 public discountPrice;
501     uint256 public whitelistPrice;
502     
503     ERC721[] private _contractList;
504     mapping(address => uint256) private _tokensMintedby;
505     mapping(address => bool) private _whitelist;
506 
507     /**
508      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
509      */
510     constructor() {
511         _name = "Chameleon Collective";
512         _symbol = "CCNFT";
513         _baseURI = "https://chameleoncollective.io/metadata/";
514         _hideTokens = true;
515         
516         totalTokens = 10000; // 0-9999
517         price = 45 * (10 ** 15); // Replace leading value with price in finney
518         whitelistPrice = 40 * (10 ** 15);
519         discountPrice = 35 * (10 ** 15);
520         maxPerWallet = 100;
521         whitelistMax = 100;
522         reservedTokens = 300; // reserved for giveaways and such
523     }
524 
525     //@dev See {IERC165-supportsInterface}. Interfaces Supported by this Standard
526     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
527         return  interfaceId == type(IERC721).interfaceId ||
528                 interfaceId == type(IERC721Metadata).interfaceId ||
529                 interfaceId == type(IERC165).interfaceId ||
530                 interfaceId == Chameleon.onERC721Received.selector;
531     }
532     
533     // Standard Withdraw function for the owner to pull the contract
534     function withdraw() external onlyOwner {
535         uint256 sendAmount = address(this).balance;
536         
537         address cmanager        = payable(0x543874CeA651a5Dd4CDF88B2Ed9B92aF57b8507E);
538         address founder         = payable(0xF561266D093c73F67c7CAA2Ab74CC71a43554e57);
539         address coo             = payable(0xa4D4FeA9799cd5015955f248994D445C6bEB9436);
540         address marketing       = payable(0x17895988aB2B64f041813936bF46Fb9133a6B160);
541         address dev             = payable(0x2496286BDB820d40C402802F828ae265b244188A);
542         address community       = payable(0x855bFE65652868920729b9d92D8d6030D01e3bFF);
543         
544         bool success;
545         (success, ) = cmanager.call{value: ((sendAmount * 35)/1000)}("");
546         require(success, "Transaction Unsuccessful");
547         
548         (success, ) = founder.call{value: ((sendAmount * 175)/1000)}("");
549         require(success, "Transaction Unsuccessful");
550         
551         (success, ) = coo.call{value: ((sendAmount * 5)/100)}("");
552         require(success, "Transaction Unsuccessful");
553         
554         (success, ) = marketing.call{value: ((sendAmount * 5)/100)}("");
555         require(success, "Transaction Unsuccessful");
556         
557         (success, ) = dev.call{value: ((sendAmount * 5)/100)}("");
558         require(success, "Transaction Unsuccessful");
559         
560         (success, ) = community.call{value: ((sendAmount * 64)/100)}("");
561         require(success, "Transaction Unsuccessful");
562         
563      }
564     
565     // Improved Withdraw function that implements approved wallets
566     /*
567     function withdraw() external {
568         require (approvedRecipients)
569         sendAmount = whatever was calculated
570         (bool success, ) = msg.sender.call{value: sendAmount}("");
571         require(success, "Transaction Unsuccessful");
572     }
573     */
574     
575     function ownerMint(address _to, uint256 qty) external onlyOwner {
576         require((numberMinted + qty) > numberMinted, "Math overflow error");
577         require((numberMinted + qty) < totalTokens, "Cannot fill order");
578         
579         uint256 mintSeedValue = numberMinted; //Store the starting value of the mint batch
580         if (reservedTokens >= qty) {
581             reservedTokens -= qty;
582         } else {
583             reservedTokens = 0;
584         }
585         
586         for(uint256 i = 0; i < qty; i++) {
587             _safeMint(_to, mintSeedValue + i);
588             numberMinted ++;  //reservedTokens can be reset, numberMinted can not
589         }
590     }
591     
592     function airDrop(address[] memory _to) external onlyOwner {
593         uint256 qty = _to.length;
594         require((numberMinted + qty) > numberMinted, "Math overflow error");
595         require((numberMinted + qty) < totalTokens, "Cannot fill order");
596         
597         uint256 mintSeedValue = numberMinted;
598         if (reservedTokens >= qty) {
599             reservedTokens -= qty;
600         } else {
601             reservedTokens = 0;
602         }
603         
604         for(uint256 i = 0; i < qty; i++) {
605             _safeMint(_to[i], mintSeedValue + i);
606             numberMinted ++;  //reservedTokens can be reset, numberMinted can not
607         }
608     }
609     
610     function discountMint(uint256 qty) external payable reentryLock {
611         require(msg.value >= qty * discountPrice, "Mint: Insufficient Funds");
612         require((qty + reservedTokens + numberMinted) < totalTokens, "Mint: Not enough avaialability");
613         require((_tokensMintedby[_msgSender()] + qty) <= maxPerWallet, "Mint: Max tokens per wallet exceeded");
614         require(checkForDiscount(_msgSender()), "Discount Not Active"); //check for holders
615         require(discountMintActive);
616         
617         uint256 mintSeedValue = numberMinted; //Store the starting value of the mint batch
618         
619         //Handle ETH transactions
620         uint256 cashIn = msg.value;
621         uint256 cashChange = cashIn - (qty * discountPrice);
622         
623         //send tokens
624         for(uint256 i = 0; i < qty; i++) {
625             _safeMint(_msgSender(), mintSeedValue + i);
626             numberMinted ++;
627             _tokensMintedby[_msgSender()] ++;
628         }
629                 
630         if (cashChange > 0){
631             (bool success, ) = msg.sender.call{value: cashChange}("");
632             require(success, "Mint: unable to send change to user");
633         }
634     }
635     
636     function checkForDiscount(address toValidate) public view returns(bool) {
637         for (uint256 i; i < _contractList.length; i++){
638             if (_contractList[i].balanceOf(toValidate) > 0){
639                 return true;
640             }
641         }
642         return false;
643     }
644     
645     function mint(uint256 qty) external payable reentryLock {
646         require((qty + reservedTokens + numberMinted) < totalTokens, "Mint: Not enough avaialability");
647         require((_tokensMintedby[_msgSender()] + qty) <= maxPerWallet, "Mint: Max tokens per wallet exceeded");
648         uint256 mintPrice;
649         
650         if(!mintActive){
651             mintPrice = whitelistPrice;
652             require((_tokensMintedby[_msgSender()] + qty) <= whitelistMax, "Mint: Cannot mint more at this time");
653             require(_whitelist[_msgSender()], "Mint: Unauthorized Access");
654             require(whitelistActive, "Mint: Whitelist Mint not Open");
655         } else {
656             mintPrice = price;
657         }
658         
659         require(msg.value >= qty * mintPrice, "Mint: Insufficient Funds");
660         
661         uint256 mintSeedValue = numberMinted; //Store the starting value of the mint batch
662         
663         //Handle ETH transactions
664         uint256 cashIn = msg.value;
665         uint256 cashChange = cashIn - (qty * mintPrice);
666         
667         //send tokens
668         for(uint256 i = 0; i < qty; i++) {
669             _safeMint(_msgSender(), mintSeedValue + i);
670             numberMinted ++;
671             _tokensMintedby[_msgSender()] ++;
672         }
673                 
674         if (cashChange > 0){
675             (bool success, ) = msg.sender.call{value: cashChange}("");
676             require(success, "Mint: unable to send change to user");
677         }
678     }
679     
680     // allows holders to burn their own tokens if desired
681     /*
682     function burn(uint256 tokenID) external {
683         require(_msgSender() == ownerOf(tokenID));
684         _burn(tokenID);
685     }
686     */
687     //////////////////////////////////////////////////////////////
688     //////////////////// Setters and Getters /////////////////////
689     //////////////////////////////////////////////////////////////
690     
691     function addDiscountContract(address newContract) external onlyOwner {
692         _contractList.push(ERC721(newContract));
693     }
694     
695     function setDiscountPrice(uint256 newPrice) external onlyOwner {
696         discountPrice = newPrice;
697     }
698     
699     function setWhitelistPrice(uint256 newPrice) external onlyOwner {
700         whitelistPrice = newPrice;
701     }
702     
703     function setMaxPerWallet(uint256 maxWallet) external onlyOwner {
704         maxPerWallet = maxWallet;
705     }
706     
707     function setWhitelistMax(uint256 maxWhitelist) external onlyOwner {
708         whitelistMax = maxWhitelist;
709     }
710     
711     function setBaseURI(string memory newURI) public onlyOwner {
712         _baseURI = newURI;
713     }
714     
715     function activateMint() public onlyOwner {
716         mintActive = true;
717     }
718     
719     function activateWhitelist() public onlyOwner {
720         whitelistActive = true;
721     }
722 
723     function activateDiscountMint() public onlyOwner {
724         discountMintActive = true;
725     }
726     
727     function deactivateMint() public onlyOwner {
728         mintActive = false;
729     }
730     
731     function deactivateWhitelist() public onlyOwner {
732         whitelistActive = false;
733     }
734     
735     function deactivateDiscountMint() public onlyOwner {
736         discountMintActive = false;
737     }
738     
739     function setPrice(uint256 newPrice) public onlyOwner {
740         price = newPrice;
741     }
742     
743     function whiteList(address account) external onlyOwner {
744         _whitelist[account] = true;
745     }
746     
747     function whiteListMany(address[] memory accounts) external onlyOwner {
748         for (uint256 i; i < accounts.length; i++) {
749             _whitelist[accounts[i]] = true;
750         }
751     }
752     
753     function checkWhitelist(address testAddress) external view returns (bool) {
754         if (_whitelist[testAddress] == true) { return true; }
755         return false;
756     }
757     
758     function setTotalTokens(uint256 numTokens) public onlyOwner {
759         totalTokens = numTokens;
760     }
761 
762     function totalSupply() external view returns (uint256) {
763         return numberMinted; //stupid bs for etherscan's call
764     }
765     
766     function hideTokens() external onlyOwner {
767         _hideTokens = true;
768     }
769     
770     function revealTokens() external onlyOwner {
771         _hideTokens = false;
772     }
773     
774     function getBalance(address tokenAddress) view external returns (uint256) {
775         //return _balances[tokenAddress]; //shows 0 on etherscan due to overflow error
776         return _balances[tokenAddress] / (10**15); //temporary fix to report in finneys
777     }
778 
779     /**
780      * @dev See {IERC721-balanceOf}.
781      */
782     function balanceOf(address owner) public view virtual override returns (uint256) {
783         require(owner != address(0), "ERC721: balance query for the zero address");
784         return _balances[owner];
785     }
786 
787     /**
788      * @dev See {IERC721-ownerOf}.
789      */
790     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
791         address owner = _owners[tokenId];
792         require(owner != address(0), "ERC721: owner query for nonexistent token");
793         return owner;
794     }
795 
796     /**
797      * @dev See {IERC721-approve}.
798      */
799     function approve(address to, uint256 tokenId) public virtual override {
800         address owner = ownerOf(tokenId);
801         require(to != owner, "ERC721: approval to current owner");
802 
803         require(
804             msg.sender == owner || isApprovedForAll(owner, msg.sender),
805             "ERC721: approve caller is not owner nor approved for all"
806         );
807 
808         _approve(to, tokenId);
809     }
810 
811     /**
812      * @dev See {IERC721-getApproved}.
813      */
814     function getApproved(uint256 tokenId) public view virtual override returns (address) {
815         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
816 
817         return _tokenApprovals[tokenId];
818     }
819 
820     /**
821      * @dev See {IERC721-setApprovalForAll}.
822      */
823     function setApprovalForAll(address operator, bool approved) public virtual override {
824         require(operator != msg.sender, "ERC721: approve to caller");
825 
826         _operatorApprovals[msg.sender][operator] = approved;
827         emit ApprovalForAll(msg.sender, operator, approved);
828     }
829 
830     /**
831      * @dev See {IERC721-isApprovedForAll}.
832      */
833     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
834         return _operatorApprovals[owner][operator];
835     }
836 
837     /**
838      * @dev See {IERC721-transferFrom}.
839      */
840     function transferFrom(
841         address from,
842         address to,
843         uint256 tokenId
844     ) public virtual override {
845         //solhint-disable-next-line max-line-length
846         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
847 
848         _transfer(from, to, tokenId);
849     }
850 
851     /**
852      * @dev See {IERC721-safeTransferFrom}.
853      */
854     function safeTransferFrom(
855         address from,
856         address to,
857         uint256 tokenId
858     ) public virtual override {
859         safeTransferFrom(from, to, tokenId, "");
860     }
861 
862     /**
863      * @dev See {IERC721-safeTransferFrom}.
864      */
865     function safeTransferFrom(
866         address from,
867         address to,
868         uint256 tokenId,
869         bytes memory _data
870     ) public virtual override {
871         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
872         _safeTransfer(from, to, tokenId, _data);
873     }
874 
875     /**
876      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
877      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
878      *
879      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
880      *
881      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
882      * implement alternative mechanisms to perform token transfer, such as signature-based.
883      *
884      * Requirements:
885      *
886      * - `from` cannot be the zero address.
887      * - `to` cannot be the zero address.
888      * - `tokenId` token must exist and be owned by `from`.
889      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
890      *
891      * Emits a {Transfer} event.
892      */
893     function _safeTransfer(
894         address from,
895         address to,
896         uint256 tokenId,
897         bytes memory _data
898     ) internal virtual {
899         _transfer(from, to, tokenId);
900         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
901     }
902 
903     /**
904      * @dev Returns whether `tokenId` exists.
905      *
906      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
907      *
908      * Tokens start existing when they are minted (`_mint`),
909      * and stop existing when they are burned (`_burn`).
910      */
911     function _exists(uint256 tokenId) internal view virtual returns (bool) {
912         return _owners[tokenId] != address(0);
913     }
914 
915     /**
916      * @dev Returns whether `spender` is allowed to manage `tokenId`.
917      *
918      * Requirements:
919      *
920      * - `tokenId` must exist.
921      */
922     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
923         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
924         address owner = ownerOf(tokenId);
925         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
926     }
927 
928     /**
929      * @dev Safely mints `tokenId` and transfers it to `to`.
930      *
931      * Requirements:
932      *
933      * - `tokenId` must not exist.
934      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
935      *
936      * Emits a {Transfer} event.
937      */
938     function _safeMint(address to, uint256 tokenId) internal virtual {
939         _safeMint(to, tokenId, "");
940     }
941 
942     /**
943      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
944      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
945      */
946     function _safeMint(
947         address to,
948         uint256 tokenId,
949         bytes memory _data
950     ) internal virtual {
951         _mint(to, tokenId);
952         require(
953             _checkOnERC721Received(address(0), to, tokenId, _data),
954             "ERC721: transfer to non ERC721Receiver implementer"
955         );
956     }
957 
958     /**
959      * @dev Mints `tokenId` and transfers it to `to`.
960      *
961      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
962      *
963      * Requirements:
964      *
965      * - `tokenId` must not exist.
966      * - `to` cannot be the zero address.
967      *
968      * Emits a {Transfer} event.
969      */
970     function _mint(address to, uint256 tokenId) internal virtual {
971         require(to != address(0), "ERC721: mint to the zero address");
972         require(!_exists(tokenId), "ERC721: token already minted");
973 
974         _beforeTokenTransfer(address(0), to, tokenId);
975 
976         _balances[to] += 1;
977         _owners[tokenId] = to;
978 
979         emit Transfer(address(0), to, tokenId);
980     }
981 
982     /**
983      * @dev Destroys `tokenId`.
984      * The approval is cleared when the token is burned.
985      *
986      * Requirements:
987      *
988      * - `tokenId` must exist.
989      *
990      * Emits a {Transfer} event.
991      */
992     function _burn(uint256 tokenId) internal virtual {
993         address owner = ownerOf(tokenId);
994 
995         _beforeTokenTransfer(owner, address(0), tokenId);
996 
997         // Clear approvals
998         _approve(address(0), tokenId);
999 
1000         _balances[owner] -= 1;
1001         delete _owners[tokenId];
1002 
1003         emit Transfer(owner, address(0), tokenId);
1004     }
1005 
1006     /**
1007      * @dev Transfers `tokenId` from `from` to `to`.
1008      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1009      *
1010      * Requirements:
1011      *
1012      * - `to` cannot be the zero address.
1013      * - `tokenId` token must be owned by `from`.
1014      *
1015      * Emits a {Transfer} event.
1016      */
1017     function _transfer(
1018         address from,
1019         address to,
1020         uint256 tokenId
1021     ) internal virtual {
1022         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1023         require(to != address(0), "ERC721: transfer to the zero address");
1024 
1025         _beforeTokenTransfer(from, to, tokenId);
1026 
1027         // Clear approvals from the previous owner
1028         _approve(address(0), tokenId);
1029 
1030         _balances[from] -= 1;
1031         _balances[to] += 1;
1032         _owners[tokenId] = to;
1033 
1034         emit Transfer(from, to, tokenId);
1035     }
1036 
1037     /**
1038      * @dev Approve `to` to operate on `tokenId`
1039      *
1040      * Emits a {Approval} event.
1041      */
1042     function _approve(address to, uint256 tokenId) internal virtual {
1043         _tokenApprovals[tokenId] = to;
1044         emit Approval(ownerOf(tokenId), to, tokenId);
1045     }
1046 
1047     /**
1048      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1049      * The call is not executed if the target address is not a contract.
1050      *
1051      * @param from address representing the previous owner of the given token ID
1052      * @param to target address that will receive the tokens
1053      * @param tokenId uint256 ID of the token to be transferred
1054      * @param _data bytes optional data to send along with the call
1055      * @return bool whether the call correctly returned the expected magic value
1056      */
1057     function _checkOnERC721Received(
1058         address from,
1059         address to,
1060         uint256 tokenId,
1061         bytes memory _data
1062     ) private returns (bool) {
1063         if (to.isContract()) {
1064             try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
1065                 return retval == IERC721Receiver(to).onERC721Received.selector;
1066             } catch (bytes memory reason) {
1067                 if (reason.length == 0) {
1068                     revert("ERC721: transfer to non ERC721Receiver implementer");
1069                 } else {
1070                     assembly {
1071                         revert(add(32, reason), mload(reason))
1072                     }
1073                 }
1074             }
1075         } else {
1076             return true;
1077         }
1078     }
1079     
1080     // *********************** ERC721 Token Receiver **********************
1081     /**
1082      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1083      * by `operator` from `from`, this function is called.
1084      *
1085      * It must return its Solidity selector to confirm the token transfer.
1086      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1087      *
1088      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1089      */
1090     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4) {
1091         //InterfaceID=0x150b7a02
1092         return this.onERC721Received.selector;
1093     }
1094 
1095     /**
1096      * @dev Hook that is called before any token transfer. This includes minting
1097      * and burning.
1098      *
1099      * Calling conditions:
1100      *
1101      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1102      * transferred to `to`.
1103      * - When `from` is zero, `tokenId` will be minted for `to`.
1104      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1105      * - `from` and `to` are never both zero.
1106      *
1107      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1108      */
1109     function _beforeTokenTransfer(
1110         address from,
1111         address to,
1112         uint256 tokenId
1113     ) internal virtual {}
1114 
1115     // **************************************** Metadata Standard Functions **********
1116     //@dev Returns the token collection name.
1117     function name() external view returns (string memory){
1118         return _name;
1119     }
1120 
1121     //@dev Returns the token collection symbol.
1122     function symbol() external view returns (string memory){
1123         return _symbol;
1124     }
1125 
1126     //@dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1127     function tokenURI(uint256 tokenId) external view returns (string memory){
1128         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1129         
1130         string memory tokenuri;
1131         
1132         if (_hideTokens) {
1133             //redirect to mystery box
1134             tokenuri = string(abi.encodePacked(_baseURI, "mystery.json"));
1135         } else {
1136             //Input flag data here to send to reveal URI
1137             tokenuri = string(abi.encodePacked(_baseURI, toString(tokenId), ".json")); /// 0.json 135.json
1138         }
1139         
1140         return tokenuri;
1141     }
1142     
1143     function contractURI() public view returns (string memory) {
1144             return string(abi.encodePacked(_baseURI,"contract.json"));
1145     }
1146     // *******************************************************************************
1147 
1148     receive() external payable {}
1149     
1150     fallback() external payable {}
1151 }