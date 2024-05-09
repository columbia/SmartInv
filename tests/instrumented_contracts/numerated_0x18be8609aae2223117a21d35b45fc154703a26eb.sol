1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 //███╗░░░███╗███████╗██╗░░██╗░█████╗░███████╗██╗░░░██╗██╗░░██╗██╗
6 //████╗░████║██╔════╝██║░██╔╝██╔══██╗╚════██║██║░░░██║██║░██╔╝██║
7 //██╔████╔██║█████╗░░█████═╝░███████║░░███╔═╝██║░░░██║█████═╝░██║
8 //██║╚██╔╝██║██╔══╝░░██╔═██╗░██╔══██║██╔══╝░░██║░░░██║██╔═██╗░██║
9 //██║░╚═╝░██║███████╗██║░╚██╗██║░░██║███████╗╚██████╔╝██║░╚██╗██║
10 //╚═╝░░░░░╚═╝╚══════╝╚═╝░░╚═╝╚═╝░░╚═╝╚══════╝░╚═════╝░╚═╝░░╚═╝╚═╝ REBOOTED
11 
12 
13 interface IERC165 {
14     function supportsInterface(bytes4 interfaceId) external view returns (bool);
15 }
16 
17 interface IERC721 is IERC165 {
18     //@dev Emitted when `tokenId` token is transferred from `from` to `to`.
19     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
20 
21     //@dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
22     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
23 
24     //@dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
25     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
26 
27     //@dev Returns the number of tokens in ``owner``'s account.
28     function balanceOf(address owner) external view returns (uint256 balance);
29 
30     /**
31      * @dev Returns the owner of the `tokenId` token.
32      *
33      * Requirements:
34      *
35      * - `tokenId` must exist.
36      */
37     function ownerOf(uint256 tokenId) external view returns (address owner);
38 
39     /**
40      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
41      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
42      *
43      * Requirements:
44      *
45      * - `from` cannot be the zero address.
46      * - `to` cannot be the zero address.
47      * - `tokenId` token must exist and be owned by `from`.
48      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
49      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
50      *
51      * Emits a {Transfer} event.
52      */
53     function safeTransferFrom(address from,address to,uint256 tokenId) external;
54 
55     /**
56      * @dev Transfers `tokenId` token from `from` to `to`.
57      *
58      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
59      *
60      * Requirements:
61      *
62      * - `from` cannot be the zero address.
63      * - `to` cannot be the zero address.
64      * - `tokenId` token must be owned by `from`.
65      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transferFrom(address from, address to, uint256 tokenId) external;
70 
71     /**
72      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
73      * The approval is cleared when the token is transferred.
74      *
75      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
76      *
77      * Requirements:
78      *
79      * - The caller must own the token or be an approved operator.
80      * - `tokenId` must exist.
81      *
82      * Emits an {Approval} event.
83      */
84     function approve(address to, uint256 tokenId) external;
85 
86     /**
87      * @dev Returns the account approved for `tokenId` token.
88      *
89      * Requirements:
90      *
91      * - `tokenId` must exist.
92      */
93     function getApproved(uint256 tokenId) external view returns (address operator);
94 
95     /**
96      * @dev Approve or remove `operator` as an operator for the caller.
97      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
98      *
99      * Requirements:
100      * - The `operator` cannot be the caller.
101      *
102      * Emits an {ApprovalForAll} event.
103      */
104     function setApprovalForAll(address operator, bool _approved) external;
105 
106     //@dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
107     function isApprovedForAll(address owner, address operator) external view returns (bool);
108 
109     /**
110      * @dev Safely transfers `tokenId` token from `from` to `to`.
111      *
112      * Requirements:
113      *
114      * - `from` cannot be the zero address.
115      * - `to` cannot be the zero address.
116      * - `tokenId` token must exist and be owned by `from`.
117      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
118      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
119      *
120      * Emits a {Transfer} event.
121      */
122     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
123 }
124 
125 interface IERC721Metadata is IERC721 {
126     //@dev Returns the token collection name.
127     function name() external view returns (string memory);
128 
129     //@dev Returns the token collection symbol.
130     function symbol() external view returns (string memory);
131 
132     //@dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
133     function tokenURI(uint256 tokenId) external view returns (string memory);
134 }
135 
136 interface IERC721Receiver {
137     /**
138      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
139      * by `operator` from `from`, this function is called.
140      *
141      * It must return its Solidity selector to confirm the token transfer.
142      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
143      *
144      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
145      */
146     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
147 }
148 
149 library Address {
150     /**
151      * @dev Returns true if `account` is a contract.
152      *
153      * [IMPORTANT]
154      * ====
155      * It is unsafe to assume that an address for which this function returns
156      * false is an externally-owned account (EOA) and not a contract.
157      *
158      * Among others, `isContract` will return false for the following
159      * types of addresses:
160      *
161      *  - an externally-owned account
162      *  - a contract in construction
163      *  - an address where a contract will be created
164      *  - an address where a contract lived, but was destroyed
165      * ====
166      */
167     function isContract(address account) internal view returns (bool) {
168         // This method relies on extcodesize, which returns 0 for contracts in
169         // construction, since the code is only stored at the end of the
170         // constructor execution.
171 
172         uint256 size;
173         assembly {
174             size := extcodesize(account)
175         }
176         return size > 0;
177     }
178 
179     /**
180      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
181      * `recipient`, forwarding all available gas and reverting on errors.
182      *
183      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
184      * of certain opcodes, possibly making contracts go over the 2300 gas limit
185      * imposed by `transfer`, making them unable to receive funds via
186      * `transfer`. {sendValue} removes this limitation.
187      *
188      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
189      *
190      * IMPORTANT: because control is transferred to `recipient`, care must be
191      * taken to not create reentrancy vulnerabilities. Consider using
192      * {ReentrancyGuard} or the
193      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
194      */
195     function sendValue(address payable recipient, uint256 amount) internal {
196         require(address(this).balance >= amount, "Address: insufficient balance");
197 
198         (bool success, ) = recipient.call{value: amount}("");
199         require(success, "Addr: cant send val, rcpt revert");
200     }
201 
202     /**
203      * @dev Performs a Solidity function call using a low level `call`. A
204      * plain `call` is an unsafe replacement for a function call: use this
205      * function instead.
206      *
207      * If `target` reverts with a revert reason, it is bubbled up by this
208      * function (like regular Solidity function calls).
209      *
210      * Returns the raw returned data. To convert to the expected return value,
211      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
212      *
213      * Requirements:
214      *
215      * - `target` must be a contract.
216      * - calling `target` with `data` must not revert.
217      *
218      * _Available since v3.1._
219      */
220     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
221         return functionCall(target, data, "Address: low-level call failed");
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
226      * `errorMessage` as a fallback revert reason when `target` reverts.
227      *
228      * _Available since v3.1._
229      */
230     function functionCall(
231         address target,
232         bytes memory data,
233         string memory errorMessage
234     ) internal returns (bytes memory) {
235         return functionCallWithValue(target, data, 0, errorMessage);
236     }
237 
238     /**
239      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
240      * but also transferring `value` wei to `target`.
241      *
242      * Requirements:
243      *
244      * - the calling contract must have an ETH balance of at least `value`.
245      * - the called Solidity function must be `payable`.
246      *
247      * _Available since v3.1._
248      */
249     function functionCallWithValue(
250         address target,
251         bytes memory data,
252         uint256 value
253     ) internal returns (bytes memory) {
254         return functionCallWithValue(target, data, value, "Addr: low-level call value fail");
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
259      * with `errorMessage` as a fallback revert reason when `target` reverts.
260      *
261      * _Available since v3.1._
262      */
263     function functionCallWithValue(
264         address target,
265         bytes memory data,
266         uint256 value,
267         string memory errorMessage
268     ) internal returns (bytes memory) {
269         require(address(this).balance >= value, "Addr: insufficient balance call");
270         require(isContract(target), "Address: call to non-contract");
271 
272         (bool success, bytes memory returndata) = target.call{value: value}(data);
273         return _verifyCallResult(success, returndata, errorMessage);
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
278      * but performing a static call.
279      *
280      * _Available since v3.3._
281      */
282     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
283         return functionStaticCall(target, data, "Addr: low-level static call fail");
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
288      * but performing a static call.
289      *
290      * _Available since v3.3._
291      */
292     function functionStaticCall(
293         address target,
294         bytes memory data,
295         string memory errorMessage
296     ) internal view returns (bytes memory) {
297         require(isContract(target), "Addr: static call non-contract");
298 
299         (bool success, bytes memory returndata) = target.staticcall(data);
300         return _verifyCallResult(success, returndata, errorMessage);
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
305      * but performing a delegate call.
306      *
307      * _Available since v3.4._
308      */
309     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
310         return functionDelegateCall(target, data, "Addr: low-level del call failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
315      * but performing a delegate call.
316      *
317      * _Available since v3.4._
318      */
319     function functionDelegateCall(
320         address target,
321         bytes memory data,
322         string memory errorMessage
323     ) internal returns (bytes memory) {
324         require(isContract(target), "Addr: delegate call non-contract");
325 
326         (bool success, bytes memory returndata) = target.delegatecall(data);
327         return _verifyCallResult(success, returndata, errorMessage);
328     }
329 
330     function _verifyCallResult(
331         bool success,
332         bytes memory returndata,
333         string memory errorMessage
334     ) private pure returns (bytes memory) {
335         if (success) {
336             return returndata;
337         } else {
338             // Look for revert reason and bubble it up if present
339             if (returndata.length > 0) {
340                 // The easiest way to bubble the revert reason is using memory via assembly
341 
342                 assembly {
343                     let returndata_size := mload(returndata)
344                     revert(add(32, returndata), returndata_size)
345                 }
346             } else {
347                 revert(errorMessage);
348             }
349         }
350     }
351 }
352 
353 abstract contract Context {
354     function _msgSender() internal view virtual returns (address) {
355         return msg.sender;
356     }
357 
358     function _msgData() internal view virtual returns (bytes calldata) {
359         return msg.data;
360     }
361 }
362 
363 abstract contract Ownable is Context {
364     address private _owner;
365 
366     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
367 
368     /**
369      * @dev Initializes the contract setting the deployer as the initial owner.
370      */
371     constructor() {
372         _setOwner(_msgSender());
373     }
374 
375     /**
376      * @dev Returns the address of the current owner.
377      */
378     function owner() public view virtual returns (address) {
379         return _owner;
380     }
381 
382     /**
383      * @dev Throws if called by any account other than the owner.
384      */
385     modifier onlyOwner() {
386         require(owner() == _msgSender(), "Ownable: caller is not the owner");
387         _;
388     }
389 
390     /**
391      * @dev Leaves the contract without owner. It will not be possible to call
392      * `onlyOwner` functions anymore. Can only be called by the current owner.
393      *
394      * NOTE: Renouncing ownership will leave the contract without an owner,
395      * thereby removing any functionality that is only available to the owner.
396      */
397     function renounceOwnership() public virtual onlyOwner {
398         _setOwner(address(0));
399     }
400 
401     /**
402      * @dev Transfers ownership of the contract to a new account (`newOwner`).
403      * Can only be called by the current owner.
404      */
405     function transferOwnership(address newOwner) public virtual onlyOwner {
406         require(newOwner != address(0), "Ownable: new owner is 0x address");
407         _setOwner(newOwner);
408     }
409 
410     function _setOwner(address newOwner) private {
411         address oldOwner = _owner;
412         _owner = newOwner;
413         emit OwnershipTransferred(oldOwner, newOwner);
414     }
415 }
416 
417 abstract contract Functional {
418     function toString(uint256 value) internal pure returns (string memory) {
419         if (value == 0) {
420             return "0";
421         }
422         uint256 temp = value;
423         uint256 digits;
424         while (temp != 0) {
425             digits++;
426             temp /= 10;
427         }
428         bytes memory buffer = new bytes(digits);
429         while (value != 0) {
430             digits -= 1;
431             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
432             value /= 10;
433         }
434         return string(buffer);
435     }
436     
437     bool private _reentryKey = false;
438     modifier reentryLock {
439         require(!_reentryKey, "attempt reenter locked function");
440         _reentryKey = true;
441         _;
442         _reentryKey = false;
443     }
444 }
445 
446 contract ERC721 {
447     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
448     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
449     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
450     function balanceOf(address owner) external view returns (uint256 balance){}
451     function ownerOf(uint256 tokenId) external view returns (address owner){}
452     function safeTransferFrom(address from,address to,uint256 tokenId) external{}
453     function transferFrom(address from, address to, uint256 tokenId) external{}
454     function approve(address to, uint256 tokenId) external{}
455     function getApproved(uint256 tokenId) external view returns (address operator){}
456     function setApprovalForAll(address operator, bool _approved) external{}
457     function isApprovedForAll(address owner, address operator) external view returns (bool){}
458     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external{}
459     
460     //Added for Mekazuki contract functionality
461     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId){}
462     
463 }
464 
465 // ******************************************************************************************************************************
466 // **************************************************  Start of Main Contract ***************************************************
467 // ******************************************************************************************************************************
468 
469 contract MEKAZUKI2 is IERC721, Ownable, Functional {
470 
471     using Address for address;
472     
473     // Token name
474     string private _name;
475 
476     // Token symbol
477     string private _symbol;
478     
479     // URI Root Location for Json Files
480     string private _baseURI;
481 
482     // Mapping from token ID to owner address
483     mapping(uint256 => address) private _owners;
484 
485     // Mapping owner address to token count
486     mapping(address => uint256) private _balances;
487 
488     // Mapping from token ID to approved address
489     mapping(uint256 => address) private _tokenApprovals;
490 
491     // Mapping from owner to operator approvals
492     mapping(address => mapping(address => bool)) private _operatorApprovals;
493     
494     // Specific Functionality
495     bool public mintActive;
496     uint256 public price;
497     uint256 public totalTokens;
498     uint256 public numberMinted;
499     uint256 public maxPerTxn;
500     uint256 public mintStart;
501     
502     address public BURN_WALLET;
503     
504     //whitelist for holders
505     ERC721 OGContract; ///Define interaction contract
506 
507     /**
508      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
509      */
510     constructor() {
511         _name = "MEKAZUKI Genesis";
512         _symbol = "MKZ!";
513         _baseURI = "https://mekazuki.me/metadata/";
514         
515         OGContract = ERC721(0x84845C3b92656c3459f8D704dfBC6a3830A94fe3);  //MEKAZUKI MAINNET
516         BURN_WALLET = 0x000000000000000000000000000000000000dEaD;
517         
518         totalTokens = 5001;
519         price = 20 * (10 ** 15); // Replace leading value with price in finney
520         
521         maxPerTxn = 20;
522         mintStart = 3411; // Defines the position that we will start minting if that feature is opened.
523     }
524 
525     //@dev See {IERC165-supportsInterface}. Interfaces Supported by this Standard
526     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
527         return  interfaceId == type(IERC721).interfaceId ||
528                 interfaceId == type(IERC721Metadata).interfaceId ||
529                 interfaceId == type(IERC165).interfaceId ||
530                 interfaceId == MEKAZUKI2.onERC721Received.selector;
531     }
532     
533     // Standard Withdraw function for the owner to pull the contract
534     function withdraw() external onlyOwner {
535         uint256 sendAmount = address(this).balance;
536         (bool success, ) = msg.sender.call{value: sendAmount}("");
537         require(success, "Transaction Unsuccessful");
538     }
539     
540     function airDrop(address[] memory _to) external onlyOwner {
541         uint256 qty = _to.length;
542         require((numberMinted + mintStart + qty) > numberMinted, "Math overflow error");
543         require((numberMinted + mintStart + qty) <= totalTokens, "Cannot fill order");
544         
545         uint256 mintSeedValue = numberMinted + mintStart;
546         
547         for(uint256 i = 0; i < qty; i++) {
548             _safeMint(_to[i], mintSeedValue + i);
549             numberMinted ++;  //reservedTokens can be reset, numberMinted can not
550         }
551     }
552     
553     function migrate(uint256 OGtokenId) external reentryLock {
554         require(OGtokenId <= 3411);
555     	OGContract.transferFrom(_msgSender(), BURN_WALLET, OGtokenId);
556         _safeMint(_msgSender(), OGtokenId);    	
557     }
558     
559     function migrateAll() external reentryLock {
560     	uint256 numTokens = OGContract.balanceOf(_msgSender());
561     	for(uint256 i = 0; i < numTokens; i++){
562     		uint256 transferToken = OGContract.tokenOfOwnerByIndex(_msgSender(), 0);
563             if (transferToken <= 3411){
564     		    OGContract.transferFrom(_msgSender(), BURN_WALLET, transferToken);
565                 _safeMint(_msgSender(), transferToken);
566             }
567     	}
568     }
569     
570     function mint(uint256 qty) external payable reentryLock {
571         address _to = _msgSender();
572         require(mintActive, "Mint not available.");
573         require(msg.value == qty * price, "Mint: Insufficient Funds");
574         require(qty <= maxPerTxn, "Mint: Above Trxn Threshold!");
575         require((qty + mintStart + numberMinted) <= totalTokens, "Mint: Not enough avaialability");
576         
577         uint256 mintSeedValue = numberMinted + mintStart; //Start minting at the right spot
578         numberMinted += qty;
579         
580         //send tokens
581         for(uint256 i = 0; i < qty; i++) {
582             _safeMint(_to, mintSeedValue + i);
583         }
584     }
585     
586     // allows holders to burn their own tokens if desired
587     function burn(uint256 tokenID) external {
588         require(_msgSender() == ownerOf(tokenID));
589         _burn(tokenID);
590     }
591     
592     //////////////////////////////////////////////////////////////
593     //////////////////// Setters and Getters /////////////////////
594     //////////////////////////////////////////////////////////////
595     function setOGContract(address newContract) external onlyOwner {
596         OGContract = ERC721(newContract);
597     }
598 
599     function setMintStart(uint256 mintStartNewValue) external onlyOwner {
600     	mintStart = mintStartNewValue;
601     }
602     
603     function setMaxMintThreshold(uint256 maxMints) external onlyOwner {
604         maxPerTxn = maxMints;
605     }
606     
607     function setBaseURI(string memory newURI) public onlyOwner {
608         _baseURI = newURI;
609     }
610     
611     function activateMint() public onlyOwner {
612         mintActive = true;
613     }
614     
615     function deactivateMint() public onlyOwner {
616         mintActive = false;
617     }
618     
619     function setPrice(uint256 newPrice) public onlyOwner {
620         price = newPrice;
621     }
622     
623     function setTotalTokens(uint256 numTokens) public onlyOwner {
624         totalTokens = numTokens;
625     }
626 
627     function totalSupply() external view returns (uint256) {
628         return numberMinted + mintStart; //stupid bs for etherscan's call
629     }
630 
631     /**
632      * @dev See {IERC721-balanceOf}.
633      */
634     function balanceOf(address owner) public view virtual override returns (uint256) {
635         require(owner != address(0), "ERC721: bal qry for zero address");
636         return _balances[owner];
637     }
638 
639     /**
640      * @dev See {IERC721-ownerOf}.
641      */
642     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
643         address owner = _owners[tokenId];
644         require(owner != address(0), "ERC721: own query nonexist tkn");
645         return owner;
646     }
647 
648     /**
649      * @dev See {IERC721-approve}.
650      */
651     function approve(address to, uint256 tokenId) public virtual override {
652         address owner = ownerOf(tokenId);
653         require(to != owner, "ERC721: approval current owner");
654 
655         require(
656             msg.sender == owner || isApprovedForAll(owner, msg.sender),
657             "ERC721: caller !owner/!approved"
658         );
659 
660         _approve(to, tokenId);
661     }
662 
663     /**
664      * @dev See {IERC721-getApproved}.
665      */
666     function getApproved(uint256 tokenId) public view virtual override returns (address) {
667         require(_exists(tokenId), "ERC721: approved nonexistent tkn");
668         return _tokenApprovals[tokenId];
669     }
670 
671     /**
672      * @dev See {IERC721-setApprovalForAll}.
673      */
674     function setApprovalForAll(address operator, bool approved) public virtual override {
675         require(operator != msg.sender, "ERC721: approve to caller");
676 
677         _operatorApprovals[msg.sender][operator] = approved;
678         emit ApprovalForAll(msg.sender, operator, approved);
679     }
680 
681     /**
682      * @dev See {IERC721-isApprovedForAll}.
683      */
684     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
685         return _operatorApprovals[owner][operator];
686     }
687 
688     /**
689      * @dev See {IERC721-transferFrom}.
690      */
691     function transferFrom(
692         address from,
693         address to,
694         uint256 tokenId
695     ) public virtual override {
696         //solhint-disable-next-line max-line-length
697         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: txfr !owner/approved");
698         _transfer(from, to, tokenId);
699     }
700 
701     /**
702      * @dev See {IERC721-safeTransferFrom}.
703      */
704     function safeTransferFrom(
705         address from,
706         address to,
707         uint256 tokenId
708     ) public virtual override {
709         safeTransferFrom(from, to, tokenId, "");
710     }
711 
712     /**
713      * @dev See {IERC721-safeTransferFrom}.
714      */
715     function safeTransferFrom(
716         address from,
717         address to,
718         uint256 tokenId,
719         bytes memory _data
720     ) public virtual override {
721         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: txfr !owner/approved");
722         _safeTransfer(from, to, tokenId, _data);
723     }
724 
725     /**
726      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
727      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
728      *
729      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
730      *
731      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
732      * implement alternative mechanisms to perform token transfer, such as signature-based.
733      *
734      * Requirements:
735      *
736      * - `from` cannot be the zero address.
737      * - `to` cannot be the zero address.
738      * - `tokenId` token must exist and be owned by `from`.
739      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
740      *
741      * Emits a {Transfer} event.
742      */
743     function _safeTransfer(
744         address from,
745         address to,
746         uint256 tokenId,
747         bytes memory _data
748     ) internal virtual {
749         _transfer(from, to, tokenId);
750         require(_checkOnERC721Received(from, to, tokenId, _data), "txfr to non ERC721Reciever");
751     }
752 
753     /**
754      * @dev Returns whether `tokenId` exists.
755      *
756      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
757      *
758      * Tokens start existing when they are minted (`_mint`),
759      * and stop existing when they are burned (`_burn`).
760      */
761     function _exists(uint256 tokenId) internal view virtual returns (bool) {
762         return _owners[tokenId] != address(0);
763     }
764 
765     /**
766      * @dev Returns whether `spender` is allowed to manage `tokenId`.
767      *
768      * Requirements:
769      *
770      * - `tokenId` must exist.
771      */
772     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
773         require(_exists(tokenId), "ERC721: op query nonexistent tkn");
774         address owner = ownerOf(tokenId);
775         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
776     }
777 
778     /**
779      * @dev Safely mints `tokenId` and transfers it to `to`.
780      *
781      * Requirements:
782      *
783      * - `tokenId` must not exist.
784      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
785      *
786      * Emits a {Transfer} event.
787      */
788     function _safeMint(address to, uint256 tokenId) internal virtual {
789         _safeMint(to, tokenId, "");
790     }
791 
792     /**
793      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
794      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
795      */
796     function _safeMint(
797         address to,
798         uint256 tokenId,
799         bytes memory _data
800     ) internal virtual {
801         _mint(to, tokenId);
802         require(
803             _checkOnERC721Received(address(0), to, tokenId, _data),
804             "txfr to non ERC721Reciever"
805         );
806     }
807 
808     /**
809      * @dev Mints `tokenId` and transfers it to `to`.
810      *
811      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
812      *
813      * Requirements:
814      *
815      * - `tokenId` must not exist.
816      * - `to` cannot be the zero address.
817      *
818      * Emits a {Transfer} event.
819      */
820     function _mint(address to, uint256 tokenId) internal virtual {
821         require(to != address(0), "ERC721: mint to the zero address");
822         require(!_exists(tokenId), "ERC721: token already minted");
823 
824         _beforeTokenTransfer(address(0), to, tokenId);
825 
826         _balances[to] += 1;
827         _owners[tokenId] = to;
828 
829         emit Transfer(address(0), to, tokenId);
830     }
831 
832     /**
833      * @dev Destroys `tokenId`.
834      * The approval is cleared when the token is burned.
835      *
836      * Requirements:
837      *
838      * - `tokenId` must exist.
839      *
840      * Emits a {Transfer} event.
841      */
842     function _burn(uint256 tokenId) internal virtual {
843         address owner = ownerOf(tokenId);
844 
845         _beforeTokenTransfer(owner, address(0), tokenId);
846 
847         // Clear approvals
848         _approve(address(0), tokenId);
849 
850         _balances[owner] -= 1;
851         delete _owners[tokenId];
852 
853         emit Transfer(owner, address(0), tokenId);
854     }
855 
856     /**
857      * @dev Transfers `tokenId` from `from` to `to`.
858      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
859      *
860      * Requirements:
861      *
862      * - `to` cannot be the zero address.
863      * - `tokenId` token must be owned by `from`.
864      *
865      * Emits a {Transfer} event.
866      */
867     function _transfer(
868         address from,
869         address to,
870         uint256 tokenId
871     ) internal virtual {
872         require(ownerOf(tokenId) == from, "ERC721: txfr token not owned");
873         require(to != address(0), "ERC721: txfr to 0x0 address");
874         _beforeTokenTransfer(from, to, tokenId);
875 
876         // Clear approvals from the previous owner
877         _approve(address(0), tokenId);
878 
879         _balances[from] -= 1;
880         _balances[to] += 1;
881         _owners[tokenId] = to;
882 
883         emit Transfer(from, to, tokenId);
884     }
885 
886     /**
887      * @dev Approve `to` to operate on `tokenId`
888      *
889      * Emits a {Approval} event.
890      */
891     function _approve(address to, uint256 tokenId) internal virtual {
892         _tokenApprovals[tokenId] = to;
893         emit Approval(ownerOf(tokenId), to, tokenId);
894     }
895 
896     /**
897      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
898      * The call is not executed if the target address is not a contract.
899      *
900      * @param from address representing the previous owner of the given token ID
901      * @param to target address that will receive the tokens
902      * @param tokenId uint256 ID of the token to be transferred
903      * @param _data bytes optional data to send along with the call
904      * @return bool whether the call correctly returned the expected magic value
905      */
906     function _checkOnERC721Received(
907         address from,
908         address to,
909         uint256 tokenId,
910         bytes memory _data
911     ) private returns (bool) {
912         if (to.isContract()) {
913             try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
914                 return retval == IERC721Receiver(to).onERC721Received.selector;
915             } catch (bytes memory reason) {
916                 if (reason.length == 0) {
917                     revert("txfr to non ERC721Reciever");
918                 } else {
919                     assembly {
920                         revert(add(32, reason), mload(reason))
921                     }
922                 }
923             }
924         } else {
925             return true;
926         }
927     }
928     
929     // *********************** ERC721 Token Receiver **********************
930     /**
931      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
932      * by `operator` from `from`, this function is called.
933      *
934      * It must return its Solidity selector to confirm the token transfer.
935      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
936      *
937      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
938      */
939     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4) {
940         //InterfaceID=0x150b7a02
941         return this.onERC721Received.selector;
942     }
943 
944     /**
945      * @dev Hook that is called before any token transfer. This includes minting
946      * and burning.
947      *
948      * Calling conditions:
949      *
950      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
951      * transferred to `to`.
952      * - When `from` is zero, `tokenId` will be minted for `to`.
953      * - When `to` is zero, ``from``'s `tokenId` will be burned.
954      * - `from` and `to` are never both zero.
955      *
956      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
957      */
958     function _beforeTokenTransfer(
959         address from,
960         address to,
961         uint256 tokenId
962     ) internal virtual {}
963 
964     // **************************************** Metadata Standard Functions **********
965     //@dev Returns the token collection name.
966     function name() external view returns (string memory){
967         return _name;
968     }
969 
970     //@dev Returns the token collection symbol.
971     function symbol() external view returns (string memory){
972         return _symbol;
973     }
974 
975     //@dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
976     function tokenURI(uint256 tokenId) external view returns (string memory){
977         require(_exists(tokenId), "Nonexistent Token ID");
978         string memory tokenuri;
979         
980         tokenuri = string(abi.encodePacked(_baseURI, toString(tokenId), ".json"));
981         
982         return tokenuri;
983     }
984     
985     function contractURI() public view returns (string memory) {
986         return string(abi.encodePacked(_baseURI,"contract.json"));
987     }
988     // *******************************************************************************
989 
990     receive() external payable {}
991     
992     fallback() external payable {}
993 }