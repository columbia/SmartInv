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
352 /**
353  * @dev String operations.
354  */
355 library Strings {
356     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
357 
358     /**
359      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
360      */
361     function toString(uint256 value) internal pure returns (string memory) {
362         // Inspired by OraclizeAPI's implementation - MIT licence
363         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
364 
365         if (value == 0) {
366             return "0";
367         }
368         uint256 temp = value;
369         uint256 digits;
370         while (temp != 0) {
371             digits++;
372             temp /= 10;
373         }
374         bytes memory buffer = new bytes(digits);
375         while (value != 0) {
376             digits -= 1;
377             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
378             value /= 10;
379         }
380         return string(buffer);
381     }
382 
383     /**
384      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
385      */
386     function toHexString(uint256 value) internal pure returns (string memory) {
387         if (value == 0) {
388             return "0x00";
389         }
390         uint256 temp = value;
391         uint256 length = 0;
392         while (temp != 0) {
393             length++;
394             temp >>= 8;
395         }
396         return toHexString(value, length);
397     }
398 
399     /**
400      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
401      */
402     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
403         bytes memory buffer = new bytes(2 * length + 2);
404         buffer[0] = "0";
405         buffer[1] = "x";
406         for (uint256 i = 2 * length + 1; i > 1; --i) {
407             buffer[i] = _HEX_SYMBOLS[value & 0xf];
408             value >>= 4;
409         }
410         require(value == 0, "Strings: hex length insufficient");
411         return string(buffer);
412     }
413 }
414 
415 abstract contract Context {
416     function _msgSender() internal view virtual returns (address) {
417         return msg.sender;
418     }
419 
420     function _msgData() internal view virtual returns (bytes calldata) {
421         return msg.data;
422     }
423 }
424 
425 abstract contract Ownable is Context {
426     address private _owner;
427 
428     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
429 
430     /**
431      * @dev Initializes the contract setting the deployer as the initial owner.
432      */
433     constructor() {
434         _setOwner(_msgSender());
435     }
436 
437     /**
438      * @dev Returns the address of the current owner.
439      */
440     function owner() public view virtual returns (address) {
441         return _owner;
442     }
443 
444     /**
445      * @dev Throws if called by any account other than the owner.
446      */
447     modifier onlyOwner() {
448         require(owner() == _msgSender(), "Ownable: caller is not the owner");
449         _;
450     }
451 
452     /**
453      * @dev Leaves the contract without owner. It will not be possible to call
454      * `onlyOwner` functions anymore. Can only be called by the current owner.
455      *
456      * NOTE: Renouncing ownership will leave the contract without an owner,
457      * thereby removing any functionality that is only available to the owner.
458      */
459     function renounceOwnership() public virtual onlyOwner {
460         _setOwner(address(0));
461     }
462 
463     /**
464      * @dev Transfers ownership of the contract to a new account (`newOwner`).
465      * Can only be called by the current owner.
466      */
467     function transferOwnership(address newOwner) public virtual onlyOwner {
468         require(newOwner != address(0), "Ownable: new owner is the zero address");
469         _setOwner(newOwner);
470     }
471 
472     function _setOwner(address newOwner) private {
473         address oldOwner = _owner;
474         _owner = newOwner;
475         emit OwnershipTransferred(oldOwner, newOwner);
476     }
477 }
478 
479 // ******************************************************************************************************************************
480 // **************************************************  Start of Main Contract ***************************************************
481 // ******************************************************************************************************************************
482 
483 contract goldenEaglez is IERC721, Ownable {
484 
485     using Address for address;
486     using Strings for uint256;
487     
488     // Token name
489     string private _name;
490 
491     // Token symbol
492     string private _symbol;
493     
494     // URI Root Location for Json Files
495     string private _baseURI;
496 
497     // Mapping from token ID to owner address
498     mapping(uint256 => address) private _owners;
499 
500     // Mapping owner address to token count
501     mapping(address => uint256) private _balances;
502 
503     // Mapping from token ID to approved address
504     mapping(uint256 => address) private _tokenApprovals;
505 
506     // Mapping from owner to operator approvals
507     mapping(address => mapping(address => bool)) private _operatorApprovals;
508     
509     // PandaBugz Specific Functionality
510     bool public mintActive;
511     bool private reentrancyLock;
512     uint256 public price;
513     uint256 public totalTokens = 10000;
514     uint256 public numberMinted;
515     uint256 private _maxMintsPerTxn;
516     uint256 public earlyMint;
517     
518     mapping(address => bool) _whitelist;
519 
520     /**
521      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
522      */
523     constructor() {
524         _name = "Golden Eaglez Kartel";
525         _symbol = "GEK";
526         _baseURI = "https://herodev.mypinata.cloud/ipfs/QmUBv8AVVD3bh76J364ATqL22ZsuWmovuY2kSKEkCovGqd/";
527         
528         price = 8 * (10 ** 16); // 0.08eth
529         _maxMintsPerTxn = 20;
530         earlyMint = 1500;
531     }
532 
533     //@dev See {IERC165-supportsInterface}. Interfaces Supported by this Standard
534     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
535         return  interfaceId == type(IERC721).interfaceId ||
536                 interfaceId == type(IERC721Metadata).interfaceId ||
537                 interfaceId == type(IERC165).interfaceId ||
538                 interfaceId == goldenEaglez.onERC721Received.selector;
539     }
540     
541     function withdraw() external onlyOwner {
542         uint256 sendAmount = address(this).balance;
543         
544         (bool success, ) = msg.sender.call{value: sendAmount}("");
545         require(success, "Transaction Unsuccessful");
546     }
547     
548     function ownerMint(address _to, uint256 qty) external onlyOwner{
549         uint256 mintSeedValue = numberMinted; //Store the starting value of the mint batch
550         numberMinted += qty;
551         
552         for(uint256 i = 0; i < qty; i++) {
553             _safeMint(_to, mintSeedValue + i);
554         }
555     }
556     
557     function mint(address _to, uint256 qty) external payable {
558         require(msg.value >= qty * price, "Mint: Insufficient Funds");
559         require(qty <= _maxMintsPerTxn, "Mint: Above Transaction Threshold!");
560         
561         if (mintActive) {
562             require(qty < totalTokens - numberMinted, "Mint: Not enough NFTs remaining to fill order");
563         } else {
564             require(qty < earlyMint - numberMinted, "Mint: Not enough NFTs remaining to fill order");
565             require(_whitelist[_msgSender()]);
566         }
567         
568         require(!reentrancyLock);  //Lock up this whole function just in case
569         reentrancyLock = true;
570         
571         uint256 mintSeedValue = numberMinted; //Store the starting value of the mint batch
572         numberMinted += qty;
573         
574         //Handle ETH transactions
575         uint256 cashIn = msg.value;
576         uint256 cashChange = cashIn - (qty * price);
577         
578         //send tokens
579         for(uint256 i = 0; i < qty; i++) {
580             _safeMint(_to, mintSeedValue + i);
581         }
582                 
583         if (cashChange > 0){
584             (bool success, ) = msg.sender.call{value: cashChange}("");
585             require(success, "Mint: unable to send change to user");
586         }
587         reentrancyLock = false;
588     }
589     
590     function burn(uint256 tokenID) external {
591         require(_msgSender() == ownerOf(tokenID));
592         _burn(tokenID);
593     }
594     
595     //////////////////// Setters and Getters
596     
597     function whiteList(address account) external onlyOwner {
598         _whitelist[account] = true;
599     }
600     
601     function whiteListMany(address[] memory accounts) external onlyOwner {
602         for (uint256 i; i < accounts.length; i++) {
603             _whitelist[accounts[i]] = true;
604         }
605     }
606     
607     function checkWhitelist(address testAddress) external view returns (bool) {
608         if (_whitelist[testAddress] == true) { return true; }
609         return false;
610     }
611     
612     function setMaximumMintThreshold(uint256 maxMints) external onlyOwner {
613         _maxMintsPerTxn = maxMints;
614     }
615     
616     function viewMaxMintThreshold() external view onlyOwner returns(uint256) {
617         return _maxMintsPerTxn;
618     }
619     
620     function setBaseURI(string memory newURI) public onlyOwner {
621         _baseURI = newURI;
622     }
623     
624     function setActive(bool setBoolValue) public onlyOwner {
625         mintActive = setBoolValue;
626     }
627     
628     function setPrice(uint256 newPrice) public onlyOwner {
629         price = newPrice;
630     }
631     
632     function setTotalTokens(uint256 numTokens) public onlyOwner {
633         totalTokens = numTokens;
634     }
635     
636     function getBalance(address tokenAddress) view external returns (uint256) {
637         return _balances[tokenAddress];
638     }
639     
640     // **************************************** Metadata Standard Functions **********
641     //@dev Returns the token collection name.
642     function name() external view returns (string memory){
643         return _name;
644     }
645 
646     //@dev Returns the token collection symbol.
647     function symbol() external view returns (string memory){
648         return _symbol;
649     }
650 
651     //@dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
652     function tokenURI(uint256 tokenId) external view returns (string memory){   //Fill out file location here later
653         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
654         string memory tokenuri = string(abi.encodePacked(_baseURI, tokenId.toString(), ".json"));
655         return tokenuri;
656     }
657     // *******************************************************************************
658 
659     /**
660      * @dev See {IERC721-balanceOf}.
661      */
662     function balanceOf(address owner) public view virtual override returns (uint256) {
663         require(owner != address(0), "ERC721: balance query for the zero address");
664         return _balances[owner];
665     }
666 
667     /**
668      * @dev See {IERC721-ownerOf}.
669      */
670     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
671         address owner = _owners[tokenId];
672         require(owner != address(0), "ERC721: owner query for nonexistent token");
673         return owner;
674     }
675 
676     /**
677      * @dev See {IERC721-approve}.
678      */
679     function approve(address to, uint256 tokenId) public virtual override {
680         address owner = ownerOf(tokenId);
681         require(to != owner, "ERC721: approval to current owner");
682 
683         require(
684             msg.sender == owner || isApprovedForAll(owner, msg.sender),
685             "ERC721: approve caller is not owner nor approved for all"
686         );
687 
688         _approve(to, tokenId);
689     }
690 
691     /**
692      * @dev See {IERC721-getApproved}.
693      */
694     function getApproved(uint256 tokenId) public view virtual override returns (address) {
695         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
696 
697         return _tokenApprovals[tokenId];
698     }
699 
700     /**
701      * @dev See {IERC721-setApprovalForAll}.
702      */
703     function setApprovalForAll(address operator, bool approved) public virtual override {
704         require(operator != msg.sender, "ERC721: approve to caller");
705 
706         _operatorApprovals[msg.sender][operator] = approved;
707         emit ApprovalForAll(msg.sender, operator, approved);
708     }
709 
710     /**
711      * @dev See {IERC721-isApprovedForAll}.
712      */
713     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
714         return _operatorApprovals[owner][operator];
715     }
716 
717     /**
718      * @dev See {IERC721-transferFrom}.
719      */
720     function transferFrom(
721         address from,
722         address to,
723         uint256 tokenId
724     ) public virtual override {
725         //solhint-disable-next-line max-line-length
726         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
727 
728         _transfer(from, to, tokenId);
729     }
730 
731     /**
732      * @dev See {IERC721-safeTransferFrom}.
733      */
734     function safeTransferFrom(
735         address from,
736         address to,
737         uint256 tokenId
738     ) public virtual override {
739         safeTransferFrom(from, to, tokenId, "");
740     }
741 
742     /**
743      * @dev See {IERC721-safeTransferFrom}.
744      */
745     function safeTransferFrom(
746         address from,
747         address to,
748         uint256 tokenId,
749         bytes memory _data
750     ) public virtual override {
751         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
752         _safeTransfer(from, to, tokenId, _data);
753     }
754 
755     /**
756      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
757      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
758      *
759      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
760      *
761      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
762      * implement alternative mechanisms to perform token transfer, such as signature-based.
763      *
764      * Requirements:
765      *
766      * - `from` cannot be the zero address.
767      * - `to` cannot be the zero address.
768      * - `tokenId` token must exist and be owned by `from`.
769      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
770      *
771      * Emits a {Transfer} event.
772      */
773     function _safeTransfer(
774         address from,
775         address to,
776         uint256 tokenId,
777         bytes memory _data
778     ) internal virtual {
779         _transfer(from, to, tokenId);
780         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
781     }
782 
783     /**
784      * @dev Returns whether `tokenId` exists.
785      *
786      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
787      *
788      * Tokens start existing when they are minted (`_mint`),
789      * and stop existing when they are burned (`_burn`).
790      */
791     function _exists(uint256 tokenId) internal view virtual returns (bool) {
792         return _owners[tokenId] != address(0);
793     }
794 
795     /**
796      * @dev Returns whether `spender` is allowed to manage `tokenId`.
797      *
798      * Requirements:
799      *
800      * - `tokenId` must exist.
801      */
802     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
803         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
804         address owner = ownerOf(tokenId);
805         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
806     }
807 
808     /**
809      * @dev Safely mints `tokenId` and transfers it to `to`.
810      *
811      * Requirements:
812      *
813      * - `tokenId` must not exist.
814      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
815      *
816      * Emits a {Transfer} event.
817      */
818     function _safeMint(address to, uint256 tokenId) internal virtual {
819         _safeMint(to, tokenId, "");
820     }
821 
822     /**
823      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
824      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
825      */
826     function _safeMint(
827         address to,
828         uint256 tokenId,
829         bytes memory _data
830     ) internal virtual {
831         _mint(to, tokenId);
832         require(
833             _checkOnERC721Received(address(0), to, tokenId, _data),
834             "ERC721: transfer to non ERC721Receiver implementer"
835         );
836     }
837 
838     /**
839      * @dev Mints `tokenId` and transfers it to `to`.
840      *
841      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
842      *
843      * Requirements:
844      *
845      * - `tokenId` must not exist.
846      * - `to` cannot be the zero address.
847      *
848      * Emits a {Transfer} event.
849      */
850     function _mint(address to, uint256 tokenId) internal virtual {
851         require(to != address(0), "ERC721: mint to the zero address");
852         require(!_exists(tokenId), "ERC721: token already minted");
853 
854         _beforeTokenTransfer(address(0), to, tokenId);
855 
856         _balances[to] += 1;
857         _owners[tokenId] = to;
858 
859         emit Transfer(address(0), to, tokenId);
860     }
861 
862     /**
863      * @dev Destroys `tokenId`.
864      * The approval is cleared when the token is burned.
865      *
866      * Requirements:
867      *
868      * - `tokenId` must exist.
869      *
870      * Emits a {Transfer} event.
871      */
872     function _burn(uint256 tokenId) internal virtual {
873         address owner = ownerOf(tokenId);
874 
875         _beforeTokenTransfer(owner, address(0), tokenId);
876 
877         // Clear approvals
878         _approve(address(0), tokenId);
879 
880         _balances[owner] -= 1;
881         delete _owners[tokenId];
882 
883         emit Transfer(owner, address(0), tokenId);
884     }
885 
886     /**
887      * @dev Transfers `tokenId` from `from` to `to`.
888      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
889      *
890      * Requirements:
891      *
892      * - `to` cannot be the zero address.
893      * - `tokenId` token must be owned by `from`.
894      *
895      * Emits a {Transfer} event.
896      */
897     function _transfer(
898         address from,
899         address to,
900         uint256 tokenId
901     ) internal virtual {
902         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
903         require(to != address(0), "ERC721: transfer to the zero address");
904 
905         _beforeTokenTransfer(from, to, tokenId);
906 
907         // Clear approvals from the previous owner
908         _approve(address(0), tokenId);
909 
910         _balances[from] -= 1;
911         _balances[to] += 1;
912         _owners[tokenId] = to;
913 
914         emit Transfer(from, to, tokenId);
915     }
916 
917     /**
918      * @dev Approve `to` to operate on `tokenId`
919      *
920      * Emits a {Approval} event.
921      */
922     function _approve(address to, uint256 tokenId) internal virtual {
923         _tokenApprovals[tokenId] = to;
924         emit Approval(ownerOf(tokenId), to, tokenId);
925     }
926 
927     /**
928      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
929      * The call is not executed if the target address is not a contract.
930      *
931      * @param from address representing the previous owner of the given token ID
932      * @param to target address that will receive the tokens
933      * @param tokenId uint256 ID of the token to be transferred
934      * @param _data bytes optional data to send along with the call
935      * @return bool whether the call correctly returned the expected magic value
936      */
937     function _checkOnERC721Received(
938         address from,
939         address to,
940         uint256 tokenId,
941         bytes memory _data
942     ) private returns (bool) {
943         if (to.isContract()) {
944             try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
945                 return retval == IERC721Receiver(to).onERC721Received.selector;
946             } catch (bytes memory reason) {
947                 if (reason.length == 0) {
948                     revert("ERC721: transfer to non ERC721Receiver implementer");
949                 } else {
950                     assembly {
951                         revert(add(32, reason), mload(reason))
952                     }
953                 }
954             }
955         } else {
956             return true;
957         }
958     }
959     
960     // *********************** ERC721 Token Receiver **********************
961     /**
962      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
963      * by `operator` from `from`, this function is called.
964      *
965      * It must return its Solidity selector to confirm the token transfer.
966      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
967      *
968      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
969      */
970     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4) {
971         //InterfaceID=0x150b7a02
972         return this.onERC721Received.selector;
973     }
974 
975     /**
976      * @dev Hook that is called before any token transfer. This includes minting
977      * and burning.
978      *
979      * Calling conditions:
980      *
981      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
982      * transferred to `to`.
983      * - When `from` is zero, `tokenId` will be minted for `to`.
984      * - When `to` is zero, ``from``'s `tokenId` will be burned.
985      * - `from` and `to` are never both zero.
986      *
987      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
988      */
989     function _beforeTokenTransfer(
990         address from,
991         address to,
992         uint256 tokenId
993     ) internal virtual {}
994 
995     receive() external payable {}
996     
997     fallback() external payable {}
998 }