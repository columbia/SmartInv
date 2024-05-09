1 /**
2  *Submitted for verification at Etherscan.io on 2022-03-11
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
202         require(success, "Addr: cant send val, rcpt revert");
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
257         return functionCallWithValue(target, data, value, "Addr: low-level call value fail");
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
272         require(address(this).balance >= value, "Addr: insufficient balance call");
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
286         return functionStaticCall(target, data, "Addr: low-level static call fail");
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
300         require(isContract(target), "Addr: static call non-contract");
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
313         return functionDelegateCall(target, data, "Addr: low-level del call failed");
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
327         require(isContract(target), "Addr: delegate call non-contract");
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
409         require(newOwner != address(0), "Ownable: new owner is 0x address");
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
442         require(!_reentryKey, "attempt reenter locked function");
443         _reentryKey = true;
444         _;
445         _reentryKey = false;
446     }
447 }
448 
449 contract ERC721 {
450     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
451     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
452     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
453     function balanceOf(address owner) external view returns (uint256 balance){}
454     function ownerOf(uint256 tokenId) external view returns (address owner){}
455     function safeTransferFrom(address from,address to,uint256 tokenId) external{}
456     function transferFrom(address from, address to, uint256 tokenId) external{}
457     function approve(address to, uint256 tokenId) external{}
458     function getApproved(uint256 tokenId) external view returns (address operator){}
459     function setApprovalForAll(address operator, bool _approved) external{}
460     function isApprovedForAll(address owner, address operator) external view returns (bool){}
461     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external{}
462 }
463 
464 // ******************************************************************************************************************************
465 // **************************************************  Start of Main Contract ***************************************************
466 // ******************************************************************************************************************************
467 
468 contract Chroma is IERC721, Ownable, Functional {
469 
470     using Address for address;
471     
472     // Token name
473     string private _name;
474 
475     // Token symbol
476     string private _symbol;
477     
478     // URI Root Location for Json Files
479     string private _baseURI;
480 
481     // Mapping from token ID to owner address
482     mapping(uint256 => address) private _owners;
483 
484     // Mapping owner address to token count
485     mapping(address => uint256) private _balances;
486 
487     mapping(address => uint256) private _tokensMintedby;
488 
489     // Mapping from owner to operator approvals
490     mapping(address => mapping(address => bool)) private _operatorApprovals;
491 
492     mapping(uint256 => address) private _tokenApprovals;
493     
494     // Specific Functionality
495     bool public mintActive;
496     bool public partnerMintActive;
497     bool private _revealed;
498     uint256 public totalTokens;
499     uint256 public price;
500     uint256 public numberMinted;
501     uint256 public reservedTokens;
502     uint256 public maxperwallet;
503     uint256 public maxPerPartnerWallet;
504 
505     address contractor      = payable(0x54F37a25e2C21492fD7990de9D3668d1a87a3346); //30
506     address toronto         = payable(0xb3a05B0feCC927e32ab448415C7D0EFC694fD5E4); //15
507     address doxxed          = payable(0xC1FDc68dc63d3316F32420d4d2c3DeA43091bCDD); //55
508     
509     mapping(address => uint256) private _mintTracker;
510     
511     //whitelist for holders
512     ERC721 REFLECT; 
513     
514     /**
515      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
516      */
517     constructor() {
518         _name = "CHROMA";
519         _symbol = "CHRNFT";
520         _baseURI = "https://everythingisenergy.io/metadata/";
521         
522         REFLECT = ERC721(0x5fFf521Cf177782BF21d4B03F20aa616573Eb8dd);
523       
524         price = 10 * (10 ** 16); // Replace leading value with price in finney
525         totalTokens = 999;
526         reservedTokens = 49;
527         maxperwallet = 3;
528         maxPerPartnerWallet = 2;
529     }
530 
531     //@dev See {IERC165-supportsInterface}. Interfaces Supported by this Standard
532     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
533         return  interfaceId == type(IERC721).interfaceId ||
534                 interfaceId == type(IERC721Metadata).interfaceId ||
535                 interfaceId == type(IERC165).interfaceId ||
536                 interfaceId == Chroma.onERC721Received.selector;
537     }
538     
539 
540     function ownerMint(address _to, uint256 qty) external onlyOwner {
541         require((numberMinted + qty) > numberMinted, "Math overflow error");
542         require((numberMinted + qty) <= totalTokens, "Cannot fill order");
543         
544         uint256 mintSeedValue = numberMinted; //Store the starting value of the mint batch
545         if (reservedTokens >= qty) {
546             reservedTokens -= qty;
547         } else {
548             reservedTokens = 0;
549         }
550         
551         for(uint256 i = 0; i < qty; i++) {
552             _safeMint(_to, mintSeedValue + i);
553             numberMinted ++;  //reservedTokens can be reset, numberMinted can not
554         }
555     }
556 
557 
558     function partnerMint(uint256 qty) external payable reentryLock {
559         require((1 + reservedTokens + numberMinted + qty) <= totalTokens, "Not enough supply");
560         require(REFLECT.balanceOf(_msgSender()) > 0, "Must Hold Reflections NFT");
561         require((_tokensMintedby[_msgSender()] + qty ) <= maxPerPartnerWallet, "Max Mint Reached");
562         require(msg.value == qty * price, "Wrong Eth Amount");
563         require(partnerMintActive,"Partner Mint Is Not Active");
564         
565         uint256 mintSeedValue = numberMinted;
566          for(uint256 i = 0; i < qty; i++) {
567             _safeMint(_msgSender(), mintSeedValue + i);
568             _tokensMintedby[_msgSender()] ++;
569             numberMinted += 1;
570         }
571 
572     }   
573    
574     
575     function mint(uint256 qty) external payable reentryLock {
576         require((1 + reservedTokens + numberMinted + qty) <= totalTokens, "Not enough supply");
577         require((_tokensMintedby[_msgSender()] + qty) <= maxperwallet, "Max Mint Reached");
578         require(mintActive,"Mint Is Not Active");
579         require(msg.value == qty * price, "Wrong Eth Amount");
580         
581         uint256 mintSeedValue = numberMinted;
582          for(uint256 i = 0; i < qty; i++) {
583             _safeMint(_msgSender(), mintSeedValue + i);
584             _tokensMintedby[_msgSender()] ++;
585             numberMinted += 1;
586         }
587     }
588 
589     function withdraw() external onlyOwner {
590         uint256 sendAmount = address(this).balance;
591 
592         bool success;
593         (success, ) = contractor.call{value: ((sendAmount * 30)/100)}("");
594         require(success, "Transaction Unsuccessful");
595         
596         (success, ) = toronto.call{value: ((sendAmount * 15)/100)}("");
597         require(success, "Transaction Unsuccessful");
598         
599         (success, ) = doxxed.call{value: ((sendAmount * 55)/100)}("");
600         require(success, "Transaction Unsuccessful");
601         
602      }
603     
604    
605     
606     //////////////////////////////////////////////////////////////
607     //////////////////// Setters and Getters /////////////////////
608     //////////////////////////////////////////////////////////////
609     function reveal() external onlyOwner {
610         _revealed = true;
611     }
612     
613     function setMaxPerWallet(uint256 newMax) public onlyOwner{
614     	maxperwallet = newMax;
615     }
616     
617     function setMaxPerPartnerWallet(uint256 newMax) public onlyOwner{
618     	maxPerPartnerWallet = newMax;
619     }
620 
621     function changeMaxSupply( uint256 newValue ) external onlyOwner {
622         totalTokens = newValue;
623     }
624 
625     function hide() external onlyOwner {
626         _revealed = false;
627     }
628 
629     function setBaseURI(string memory newURI) public onlyOwner {
630         _baseURI = newURI;
631     }
632     
633     function activateMint() public onlyOwner {
634         mintActive = true;
635     }
636     
637     function deactivateMint() public onlyOwner {
638         mintActive = false;
639     }
640 
641     function activatePartnerMint() public onlyOwner {
642         partnerMintActive = true;
643     }
644     
645     function deactivatePartnerMint() public onlyOwner {
646         partnerMintActive = false;
647     }
648     
649     function setPrice(uint256 newPrice) public onlyOwner {
650         price = newPrice;
651     }
652     
653     function totalSupply() external view returns (uint256) {
654         return numberMinted; //stupid bs for etherscan's call
655     }
656     
657     function getBalance(address tokenAddress) view external returns (uint256) {
658         //return _balances[tokenAddress]; //shows 0 on etherscan due to overflow error
659         return _balances[tokenAddress] / (10**15); //temporary fix to report in finneys
660     }
661 
662     /**
663      * @dev See {IERC721-balanceOf}.
664      */
665     function balanceOf(address owner) public view virtual override returns (uint256) {
666         require(owner != address(0), "ERC721: bal qry for zero address");
667         return _balances[owner];
668     }
669 
670     /**
671      * @dev See {IERC721-ownerOf}.
672      */
673     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
674         address owner = _owners[tokenId];
675         require(owner != address(0), "ERC721: own query nonexist tkn");
676         return owner;
677     }
678 
679     /**
680      * @dev See {IERC721-approve}.
681      */
682     function approve(address to, uint256 tokenId) public virtual override {
683         address owner = ownerOf(tokenId);
684         require(to != owner, "ERC721: approval current owner");
685 
686         require(
687             msg.sender == owner || isApprovedForAll(owner, msg.sender),
688             "ERC721: caller !owner/!approved"
689         );
690 
691         _approve(to, tokenId);
692     }
693 
694     /**
695      * @dev Approve `to` to operate on `tokenId`
696      *
697      * Emits a {Approval} event.
698      */
699     function _approve(address to, uint256 tokenId) internal virtual {
700         _tokenApprovals[tokenId] = to;
701         emit Approval(ownerOf(tokenId), to, tokenId);
702     }
703 
704     /**
705      * @dev See {IERC721-getApproved}.
706      */
707     function getApproved(uint256 tokenId) public view virtual override returns (address) {
708         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
709 
710         return _tokenApprovals[tokenId];
711     }
712 
713     /**
714      * @dev See {IERC721-setApprovalForAll}.
715      */
716     function setApprovalForAll(address operator, bool approved) public virtual override {
717         require(operator != msg.sender, "ERC721: approve to caller");
718 
719         _operatorApprovals[msg.sender][operator] = approved;
720         emit ApprovalForAll(msg.sender, operator, approved);
721     }
722 
723     /**
724      * @dev See {IERC721-isApprovedForAll}.
725      */
726     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
727         return _operatorApprovals[owner][operator];
728     }
729 
730     /**
731      * @dev See {IERC721-transferFrom}.
732      */
733     function transferFrom(
734         address from,
735         address to,
736         uint256 tokenId
737     ) public virtual override {
738         //solhint-disable-next-line max-line-length
739         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: txfr !owner/approved");
740         _transfer(from, to, tokenId);
741     }
742 
743     /**
744      * @dev See {IERC721-safeTransferFrom}.
745      */
746     function safeTransferFrom(
747         address from,
748         address to,
749         uint256 tokenId
750     ) public virtual override {
751         safeTransferFrom(from, to, tokenId, "");
752     }
753 
754     /**
755      * @dev See {IERC721-safeTransferFrom}.
756      */
757     function safeTransferFrom(
758         address from,
759         address to,
760         uint256 tokenId,
761         bytes memory _data
762     ) public virtual override {
763         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: txfr !owner/approved");
764         _safeTransfer(from, to, tokenId, _data);
765     }
766 
767     /**
768      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
769      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
770      *
771      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
772      *
773      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
774      * implement alternative mechanisms to perform token transfer, such as signature-based.
775      *
776      * Requirements:
777      *
778      * - `from` cannot be the zero address.
779      * - `to` cannot be the zero address.
780      * - `tokenId` token must exist and be owned by `from`.
781      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
782      *
783      * Emits a {Transfer} event.
784      */
785     function _safeTransfer(
786         address from,
787         address to,
788         uint256 tokenId,
789         bytes memory _data
790     ) internal virtual {
791         _transfer(from, to, tokenId);
792         require(_checkOnERC721Received(from, to, tokenId, _data), "txfr to non ERC721Reciever");
793     }
794 
795     /**
796      * @dev Returns whether `tokenId` exists.
797      *
798      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
799      *
800      * Tokens start existing when they are minted (`_mint`),
801      * and stop existing when they are burned (`_burn`).
802      */
803     function _exists(uint256 tokenId) internal view virtual returns (bool) {
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
814     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
815         require(_exists(tokenId), "ERC721: op query nonexistent tkn");
816         address owner = ownerOf(tokenId);
817         return (spender == owner || isApprovedForAll(owner, spender));
818     }
819 
820     /**
821      * @dev Safely mints `tokenId` and transfers it to `to`.
822      *
823      * Requirements:
824      *
825      * - `tokenId` must not exist.
826      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
827      *
828      * Emits a {Transfer} event.
829      */
830     function _safeMint(address to, uint256 tokenId) internal virtual {
831         _safeMint(to, tokenId, "");
832     }
833 
834     /**
835      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
836      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
837      */
838     function _safeMint(
839         address to,
840         uint256 tokenId,
841         bytes memory _data
842     ) internal virtual {
843         _mint(to, tokenId);
844         require(
845             _checkOnERC721Received(address(0), to, tokenId, _data),
846             "txfr to non ERC721Reciever"
847         );
848     }
849 
850     /**
851      * @dev Mints `tokenId` and transfers it to `to`.
852      *
853      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
854      *
855      * Requirements:
856      *
857      * - `tokenId` must not exist.
858      * - `to` cannot be the zero address.
859      *
860      * Emits a {Transfer} event.
861      */
862     function _mint(address to, uint256 tokenId) internal virtual {
863         require(to != address(0), "ERC721: mint to the zero address");
864         require(!_exists(tokenId), "ERC721: token already minted");
865 
866         _beforeTokenTransfer(address(0), to, tokenId);
867 
868         _balances[to] += 1;
869         _owners[tokenId] = to;
870 
871         emit Transfer(address(0), to, tokenId);
872     }
873 
874     /**
875      * @dev Destroys `tokenId`.
876      * The approval is cleared when the token is burned.
877      *
878      * Requirements:
879      *
880      * - `tokenId` must exist.
881      *
882      * Emits a {Transfer} event.
883      */
884     function _burn(uint256 tokenId) internal virtual {
885         address owner = ownerOf(tokenId);
886 
887         _beforeTokenTransfer(owner, address(0), tokenId);
888 
889         // Clear approvals
890         _approve(address(0), tokenId);
891 
892         _balances[owner] -= 1;
893         delete _owners[tokenId];
894 
895         emit Transfer(owner, address(0), tokenId);
896     }
897 
898     /**
899      * @dev Transfers `tokenId` from `from` to `to`.
900      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
901      *
902      * Requirements:
903      *
904      * - `to` cannot be the zero address.
905      * - `tokenId` token must be owned by `from`.
906      *
907      * Emits a {Transfer} event.
908      */
909     function _transfer(
910         address from,
911         address to,
912         uint256 tokenId
913     ) internal virtual {
914         require(ownerOf(tokenId) == from, "ERC721: txfr token not owned");
915         require(to != address(0), "ERC721: txfr to 0x0 address");
916         _beforeTokenTransfer(from, to, tokenId);
917 
918         // Clear approvals from the previous owner
919         _approve(address(0), tokenId);
920 
921         _balances[from] -= 1;
922         _balances[to] += 1;
923         _owners[tokenId] = to;
924 
925         emit Transfer(from, to, tokenId);
926     }
927 
928     /**
929      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
930      * The call is not executed if the target address is not a contract.
931      *
932      * @param from address representing the previous owner of the given token ID
933      * @param to target address that will receive the tokens
934      * @param tokenId uint256 ID of the token to be transferred
935      * @param _data bytes optional data to send along with the call
936      * @return bool whether the call correctly returned the expected magic value
937      */
938     function _checkOnERC721Received(
939         address from,
940         address to,
941         uint256 tokenId,
942         bytes memory _data
943     ) private returns (bool) {
944         if (to.isContract()) {
945             try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
946                 return retval == IERC721Receiver(to).onERC721Received.selector;
947             } catch (bytes memory reason) {
948                 if (reason.length == 0) {
949                     revert("txfr to non ERC721Reciever");
950                 } else {
951                     assembly {
952                         revert(add(32, reason), mload(reason))
953                     }
954                 }
955             }
956         } else {
957             return true;
958         }
959     }
960     
961     // *********************** ERC721 Token Receiver **********************
962     /**
963      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
964      * by `operator` from `from`, this function is called.
965      *
966      * It must return its Solidity selector to confirm the token transfer.
967      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
968      *
969      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
970      */
971     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external pure returns(bytes4) {
972         //InterfaceID=0x150b7a02
973         return this.onERC721Received.selector;
974     }
975 
976     /**
977      * @dev Hook that is called before any token transfer. This includes minting
978      * and burning.
979      *
980      * Calling conditions:
981      *
982      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
983      * transferred to `to`.
984      * - When `from` is zero, `tokenId` will be minted for `to`.
985      * - When `to` is zero, ``from``'s `tokenId` will be burned.
986      * - `from` and `to` are never both zero.
987      *
988      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
989      */
990     function _beforeTokenTransfer(
991         address from,
992         address to,
993         uint256 tokenId
994     ) internal virtual {}
995 
996     // **************************************** Metadata Standard Functions **********
997     //@dev Returns the token collection name.
998     function name() external view returns (string memory){
999         return _name;
1000     }
1001 
1002     //@dev Returns the token collection symbol.
1003     function symbol() external view returns (string memory){
1004         return _symbol;
1005     }
1006 
1007     //@dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1008     function tokenURI(uint256 tokenId) external view returns (string memory){
1009         require(_exists(tokenId), "ERC721Metadata: URI 0x0 token");
1010         string memory tokenuri;
1011         if (_revealed){
1012             tokenuri = string(abi.encodePacked(_baseURI, toString(tokenId), ".json"));
1013         } else {
1014             tokenuri = string(abi.encodePacked(_baseURI, "mystery.json"));
1015         }
1016         return tokenuri;
1017     }
1018     
1019     function contractURI() public view returns (string memory) {
1020             return string(abi.encodePacked(_baseURI,"contract.json"));
1021     }
1022     // *******************************************************************************
1023 
1024     receive() external payable {}
1025     
1026     fallback() external payable {}
1027 }