1 // File: newAvaContract.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2022-09-22
5 */
6 
7 // File: @openzeppelin/contracts/utils/Strings.sol
8 
9 
10 pragma solidity ^0.8.0;
11 
12 /*
13     Fully commented standard ERC721 Distilled from OpenZeppelin Docs
14     Base for Building ERC721 by Martin McConnell
15     All the utility without the fluff.
16 */
17 
18 
19 interface IERC165 {
20     function supportsInterface(bytes4 interfaceId) external view returns (bool);
21 }
22 
23 interface IERC721 is IERC165 {
24     //@dev Emitted when `tokenId` token is transferred from `from` to `to`.
25     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
26 
27     //@dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
28     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
29 
30     //@dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
31     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
32 
33     //@dev Returns the number of tokens in ``owner``'s account.
34     function balanceOf(address owner) external view returns (uint256 balance);
35 
36     /**
37      * @dev Returns the owner of the `tokenId` token.
38      *
39      * Requirements:
40      *
41      * - `tokenId` must exist.
42      */
43     function ownerOf(uint256 tokenId) external view returns (address owner);
44 
45     /**
46      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
47      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
48      *
49      * Requirements:
50      *
51      * - `from` cannot be the zero address.
52      * - `to` cannot be the zero address.
53      * - `tokenId` token must exist and be owned by `from`.
54      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
55      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
56      *
57      * Emits a {Transfer} event.
58      */
59     function safeTransferFrom(address from,address to,uint256 tokenId) external;
60 
61     /**
62      * @dev Transfers `tokenId` token from `from` to `to`.
63      *
64      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
65      *
66      * Requirements:
67      *
68      * - `from` cannot be the zero address.
69      * - `to` cannot be the zero address.
70      * - `tokenId` token must be owned by `from`.
71      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transferFrom(address from, address to, uint256 tokenId) external;
76 
77     /**
78      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
79      * The approval is cleared when the token is transferred.
80      *
81      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
82      *
83      * Requirements:
84      *
85      * - The caller must own the token or be an approved operator.
86      * - `tokenId` must exist.
87      *
88      * Emits an {Approval} event.
89      */
90     function approve(address to, uint256 tokenId) external;
91 
92     /**
93      * @dev Returns the account approved for `tokenId` token.
94      *
95      * Requirements:
96      *
97      * - `tokenId` must exist.
98      */
99     function getApproved(uint256 tokenId) external view returns (address operator);
100 
101     /**
102      * @dev Approve or remove `operator` as an operator for the caller.
103      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
104      *
105      * Requirements:
106      * - The `operator` cannot be the caller.
107      *
108      * Emits an {ApprovalForAll} event.
109      */
110     function setApprovalForAll(address operator, bool _approved) external;
111 
112     //@dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
113     function isApprovedForAll(address owner, address operator) external view returns (bool);
114 
115     /**
116      * @dev Safely transfers `tokenId` token from `from` to `to`.
117      *
118      * Requirements:
119      *
120      * - `from` cannot be the zero address.
121      * - `to` cannot be the zero address.
122      * - `tokenId` token must exist and be owned by `from`.
123      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
124      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
125      *
126      * Emits a {Transfer} event.
127      */
128     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
129 }
130 
131 interface IERC721Metadata is IERC721 {
132     //@dev Returns the token collection name.
133     function name() external view returns (string memory);
134 
135     //@dev Returns the token collection symbol.
136     function symbol() external view returns (string memory);
137 
138     //@dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
139     function tokenURI(uint256 tokenId) external view returns (string memory);
140 }
141 
142 interface IERC721Receiver {
143     /**
144      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
145      * by `operator` from `from`, this function is called.
146      *
147      * It must return its Solidity selector to confirm the token transfer.
148      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
149      *
150      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
151      */
152     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
153 }
154 
155 library Address {
156     /**
157      * @dev Returns true if `account` is a contract.
158      *
159      * [IMPORTANT]
160      * ====
161      * It is unsafe to assume that an address for which this function returns
162      * false is an externally-owned account (EOA) and not a contract.
163      *
164      * Among others, `isContract` will return false for the following
165      * types of addresses:
166      *
167      *  - an externally-owned account
168      *  - a contract in construction
169      *  - an address where a contract will be created
170      *  - an address where a contract lived, but was destroyed
171      * ====
172      */
173     function isContract(address account) internal view returns (bool) {
174         // This method relies on extcodesize, which returns 0 for contracts in
175         // construction, since the code is only stored at the end of the
176         // constructor execution.
177 
178         uint256 size;
179         assembly {
180             size := extcodesize(account)
181         }
182         return size > 0;
183     }
184 
185     /**
186      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
187      * `recipient`, forwarding all available gas and reverting on errors.
188      *
189      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
190      * of certain opcodes, possibly making contracts go over the 2300 gas limit
191      * imposed by `transfer`, making them unable to receive funds via
192      * `transfer`. {sendValue} removes this limitation.
193      *
194      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
195      *
196      * IMPORTANT: because control is transferred to `recipient`, care must be
197      * taken to not create reentrancy vulnerabilities. Consider using
198      * {ReentrancyGuard} or the
199      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
200      */
201     function sendValue(address payable recipient, uint256 amount) internal {
202         require(address(this).balance >= amount, "Address: insufficient balance");
203 
204         (bool success, ) = recipient.call{value: amount}("");
205         require(success, "Addr: cant send val, rcpt revert");
206     }
207 
208     /**
209      * @dev Performs a Solidity function call using a low level `call`. A
210      * plain `call` is an unsafe replacement for a function call: use this
211      * function instead.
212      *
213      * If `target` reverts with a revert reason, it is bubbled up by this
214      * function (like regular Solidity function calls).
215      *
216      * Returns the raw returned data. To convert to the expected return value,
217      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
218      *
219      * Requirements:
220      *
221      * - `target` must be a contract.
222      * - calling `target` with `data` must not revert.
223      *
224      * _Available since v3.1._
225      */
226     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
227         return functionCall(target, data, "Address: low-level call failed");
228     }
229 
230     /**
231      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
232      * `errorMessage` as a fallback revert reason when `target` reverts.
233      *
234      * _Available since v3.1._
235      */
236     function functionCall(
237         address target,
238         bytes memory data,
239         string memory errorMessage
240     ) internal returns (bytes memory) {
241         return functionCallWithValue(target, data, 0, errorMessage);
242     }
243 
244     /**
245      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
246      * but also transferring `value` wei to `target`.
247      *
248      * Requirements:
249      *
250      * - the calling contract must have an ETH balance of at least `value`.
251      * - the called Solidity function must be `payable`.
252      *
253      * _Available since v3.1._
254      */
255     function functionCallWithValue(
256         address target,
257         bytes memory data,
258         uint256 value
259     ) internal returns (bytes memory) {
260         return functionCallWithValue(target, data, value, "Addr: low-level call value fail");
261     }
262 
263     /**
264      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
265      * with `errorMessage` as a fallback revert reason when `target` reverts.
266      *
267      * _Available since v3.1._
268      */
269     function functionCallWithValue(
270         address target,
271         bytes memory data,
272         uint256 value,
273         string memory errorMessage
274     ) internal returns (bytes memory) {
275         require(address(this).balance >= value, "Addr: insufficient balance call");
276         require(isContract(target), "Address: call to non-contract");
277 
278         (bool success, bytes memory returndata) = target.call{value: value}(data);
279         return _verifyCallResult(success, returndata, errorMessage);
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
284      * but performing a static call.
285      *
286      * _Available since v3.3._
287      */
288     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
289         return functionStaticCall(target, data, "Addr: low-level static call fail");
290     }
291 
292     /**
293      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
294      * but performing a static call.
295      *
296      * _Available since v3.3._
297      */
298     function functionStaticCall(
299         address target,
300         bytes memory data,
301         string memory errorMessage
302     ) internal view returns (bytes memory) {
303         require(isContract(target), "Addr: static call non-contract");
304 
305         (bool success, bytes memory returndata) = target.staticcall(data);
306         return _verifyCallResult(success, returndata, errorMessage);
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
311      * but performing a delegate call.
312      *
313      * _Available since v3.4._
314      */
315     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
316         return functionDelegateCall(target, data, "Addr: low-level del call failed");
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
321      * but performing a delegate call.
322      *
323      * _Available since v3.4._
324      */
325     function functionDelegateCall(
326         address target,
327         bytes memory data,
328         string memory errorMessage
329     ) internal returns (bytes memory) {
330         require(isContract(target), "Addr: delegate call non-contract");
331 
332         (bool success, bytes memory returndata) = target.delegatecall(data);
333         return _verifyCallResult(success, returndata, errorMessage);
334     }
335 
336     function _verifyCallResult(
337         bool success,
338         bytes memory returndata,
339         string memory errorMessage
340     ) private pure returns (bytes memory) {
341         if (success) {
342             return returndata;
343         } else {
344             // Look for revert reason and bubble it up if present
345             if (returndata.length > 0) {
346                 // The easiest way to bubble the revert reason is using memory via assembly
347 
348                 assembly {
349                     let returndata_size := mload(returndata)
350                     revert(add(32, returndata), returndata_size)
351                 }
352             } else {
353                 revert(errorMessage);
354             }
355         }
356     }
357 }
358 
359 abstract contract Context {
360     function _msgSender() internal view virtual returns (address) {
361         return msg.sender;
362     }
363 
364     function _msgData() internal view virtual returns (bytes calldata) {
365         return msg.data;
366     }
367 }
368 
369 abstract contract Ownable is Context {
370     address private _owner;
371 
372     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
373 
374     /**
375      * @dev Initializes the contract setting the deployer as the initial owner.
376      */
377     constructor() {
378         _setOwner(_msgSender());
379     }
380 
381     /**
382      * @dev Returns the address of the current owner.
383      */
384     function owner() public view virtual returns (address) {
385         return _owner;
386     }
387 
388     /**
389      * @dev Throws if called by any account other than the owner.
390      */
391     modifier onlyOwner() {
392         require(owner() == _msgSender(), "Ownable: caller is not the owner");
393         _;
394     }
395 
396     /**
397      * @dev Leaves the contract without owner. It will not be possible to call
398      * `onlyOwner` functions anymore. Can only be called by the current owner.
399      *
400      * NOTE: Renouncing ownership will leave the contract without an owner,
401      * thereby removing any functionality that is only available to the owner.
402      */
403     function renounceOwnership() public virtual onlyOwner {
404         _setOwner(address(0));
405     }
406 
407     /**
408      * @dev Transfers ownership of the contract to a new account (`newOwner`).
409      * Can only be called by the current owner.
410      */
411     function transferOwnership(address newOwner) public virtual onlyOwner {
412         require(newOwner != address(0), "Ownable: new owner is 0x address");
413         _setOwner(newOwner);
414     }
415 
416     function _setOwner(address newOwner) private {
417         address oldOwner = _owner;
418         _owner = newOwner;
419         emit OwnershipTransferred(oldOwner, newOwner);
420     }
421 }
422 
423 abstract contract Functional {
424     function toString(uint256 value) internal pure returns (string memory) {
425         if (value == 0) {
426             return "0";
427         }
428         uint256 temp = value;
429         uint256 digits;
430         while (temp != 0) {
431             digits++;
432             temp /= 10;
433         }
434         bytes memory buffer = new bytes(digits);
435         while (value != 0) {
436             digits -= 1;
437             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
438             value /= 10;
439         }
440         return string(buffer);
441     }
442     
443     bool private _reentryKey = false;
444     modifier reentryLock {
445         require(!_reentryKey, "attempt reenter locked function");
446         _reentryKey = true;
447         _;
448         _reentryKey = false;
449     }
450 }
451 
452 contract ERC721 {
453     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
454     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
455     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
456     function balanceOf(address owner) external view returns (uint256 balance){}
457     function ownerOf(uint256 tokenId) external view returns (address owner){}
458     function safeTransferFrom(address from,address to,uint256 tokenId) external{}
459     function transferFrom(address from, address to, uint256 tokenId) external{}
460     function approve(address to, uint256 tokenId) external{}
461     function getApproved(uint256 tokenId) external view returns (address operator){}
462     function setApprovalForAll(address operator, bool _approved) external{}
463     function isApprovedForAll(address owner, address operator) external view returns (bool){}
464     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external{}
465 }
466 
467 // ******************************************************************************************************************************
468 // **************************************************  Start of Main Contract ***************************************************
469 // ******************************************************************************************************************************
470 
471 contract AVIUS is IERC721, Ownable, Functional {
472 
473     using Address for address;
474     
475     // Token name
476     string private _name;
477 
478     // Token symbol
479     string private _symbol;
480     
481     // URI Root Location for Json Files
482     string private _baseURI;
483 
484     // Mapping from token ID to owner address
485     mapping(uint256 => address) private _owners;
486 
487     // Mapping owner address to token count
488     mapping(address => uint256) private _balances;
489 
490     // Mapping from token ID to approved address
491     mapping(uint256 => address) private _tokenApprovals;
492 
493     // Mapping from owner to operator approvals
494     mapping(address => mapping(address => bool)) private _operatorApprovals;
495     
496     // Specific Functionality
497     bool public mintActive;
498 	uint256 private _maxSupply;
499     uint256 public numberMinted;
500     uint256 public maxPerTxn;
501 	bool private _revealed;
502     uint256 public nftprice;
503     
504     mapping(address => uint256) private _mintTracker;
505     address nftOwnerAddress      = payable(0x89AC334A1C882217916CB90f2A45cBA88cE35a52);
506     
507     //whitelist for holders
508     ERC721 CC; ///Elephants of Chameleons
509    
510     /**
511      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
512      */
513     constructor() {
514         _name = "AVIUS OBSCURIS";
515         _symbol = "AVO";
516         _baseURI = "https://aviusanimae.xyz/metadata/";
517         //_baseURI = "http://localhost:3000/";
518         
519         //CC = ERC721(0x45eeEd78125386e49dc80c5640d8eACf1Ef4ca89);
520         CC = ERC721(0x0eDA3c383F13C36db1c96bD9c56f715B09b9E350); // AVA Burn token on etherscan
521         _maxSupply = 3333;
522     }
523 
524     //@dev See {IERC165-supportsInterface}. Interfaces Supported by this Standard
525     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
526         return  interfaceId == type(IERC721).interfaceId ||
527                 interfaceId == type(IERC721Metadata).interfaceId ||
528                 interfaceId == type(IERC165).interfaceId ||
529                 interfaceId == AVIUS.onERC721Received.selector;
530     }
531     
532     // Standard Withdraw function for the owner to pull the contract
533     function withdraw() external onlyOwner {
534         uint256 sendAmount = address(this).balance;
535         (bool success, ) = nftOwnerAddress.call{value: sendAmount}("");
536         require(success, "Transaction Unsuccessful");
537     }
538     
539 	function Mint(uint256 qty) external payable reentryLock {
540 		//require(CC.balanceOf(_msgSender()) > 0, "must have Master");
541 		require(mintActive, "Mint Not Active");
542         require(numberMinted + qty <= _maxSupply, "Max supply exceeded");
543         require(msg.value >= 0, "Wrong Eth Amount");
544     	nftprice = msg.value;
545 		uint256 mintSeedValue = numberMinted;
546 		numberMinted += qty;
547 		
548 		for(uint256 i = 1; i <= qty; i++) {
549         	_safeMint(_msgSender(), mintSeedValue + i);
550         }
551 	}
552    
553     // allows holders to burn their own tokens if desired
554     function burn(uint256 tokenID, uint256 tokenIDTwo) external {
555         require(_msgSender() == (CC).ownerOf(tokenID), "Only token owner can call burn");
556         require(_msgSender() == (CC).ownerOf(tokenIDTwo), "Only token owner can call burn");
557         (CC).transferFrom(msg.sender, address(0x000000000000000000000000000000000000dEaD), tokenID);
558         (CC).transferFrom(msg.sender, address(0x000000000000000000000000000000000000dEaD), tokenIDTwo);
559     }
560     
561     //////////////////////////////////////////////////////////////
562     //////////////////// Setters and Getters /////////////////////
563     //////////////////////////////////////////////////////////////
564 	function reveal() external onlyOwner {
565 		_revealed = true;
566 	}
567 
568 	function changeMaxSupply( uint256 newValue ) external onlyOwner {
569 		_maxSupply = newValue;
570 	}
571 
572 	function hide() external onlyOwner {
573 		_revealed = false;
574 	}
575 
576     function setMaxMintThreshold(uint256 maxMints) external onlyOwner {
577         maxPerTxn = maxMints;
578     }
579     
580     function setBaseURI(string memory newURI) public onlyOwner {
581         _baseURI = newURI;
582     }
583     
584     function activateMint() public onlyOwner {
585         mintActive = true;
586     }
587     
588     function deactivateMint() public onlyOwner {
589         mintActive = false;
590     }
591    
592     function totalSupply() external view returns (uint256) {
593         return numberMinted; //stupid bs for etherscan's call
594     }
595     
596     function getBalance(address tokenAddress) view external returns (uint256) {
597         //return _balances[tokenAddress]; //shows 0 on etherscan due to overflow error
598         return _balances[tokenAddress] / (10**15); //temporary fix to report in finneys
599     }
600 
601     /**
602      * @dev See {IERC721-balanceOf}.
603      */
604     function balanceOf(address owner) public view virtual override returns (uint256) {
605         require(owner != address(0), "ERC721: bal qry for zero address");
606         return _balances[owner];
607     }
608 
609     /**
610      * @dev See {IERC721-ownerOf}.
611      */
612     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
613         address owner = _owners[tokenId];
614         require(owner != address(0), "ERC721: own query nonexist tkn");
615         return owner;
616     }
617 
618     /**
619      * @dev See {IERC721-approve}.
620      */
621     function approve(address to, uint256 tokenId) public virtual override {
622         address owner = ownerOf(tokenId);
623         require(to != owner, "ERC721: approval current owner");
624 
625         require(
626             msg.sender == owner || isApprovedForAll(owner, msg.sender),
627             "ERC721: caller !owner/!approved"
628         );
629 
630         _approve(to, tokenId);
631     }
632 
633     /**
634      * @dev See {IERC721-getApproved}.
635      */
636     function getApproved(uint256 tokenId) public view virtual override returns (address) {
637         require(_exists(tokenId), "ERC721: approved nonexistent tkn");
638         return _tokenApprovals[tokenId];
639     }
640 
641     /**
642      * @dev See {IERC721-setApprovalForAll}.
643      */
644     function setApprovalForAll(address operator, bool approved) public virtual override {
645         require(operator != msg.sender, "ERC721: approve to caller");
646 
647         _operatorApprovals[msg.sender][operator] = approved;
648         emit ApprovalForAll(msg.sender, operator, approved);
649     }
650 
651     /**
652      * @dev See {IERC721-isApprovedForAll}.
653      */
654     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
655         return _operatorApprovals[owner][operator];
656     }
657 
658     /**
659      * @dev See {IERC721-transferFrom}.
660      */
661     function transferFrom(
662         address from,
663         address to,
664         uint256 tokenId
665     ) public virtual override {
666         //solhint-disable-next-line max-line-length
667         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: txfr !owner/approved");
668         _transfer(from, to, tokenId);
669     }
670 
671     /**
672      * @dev See {IERC721-safeTransferFrom}.
673      */
674     function safeTransferFrom(
675         address from,
676         address to,
677         uint256 tokenId
678     ) public virtual override {
679         safeTransferFrom(from, to, tokenId, "");
680     }
681 
682     /**
683      * @dev See {IERC721-safeTransferFrom}.
684      */
685     function safeTransferFrom(
686         address from,
687         address to,
688         uint256 tokenId,
689         bytes memory _data
690     ) public virtual override {
691         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: txfr !owner/approved");
692         _safeTransfer(from, to, tokenId, _data);
693     }
694 
695     /**
696      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
697      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
698      *
699      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
700      *
701      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
702      * implement alternative mechanisms to perform token transfer, such as signature-based.
703      *
704      * Requirements:
705      *
706      * - `from` cannot be the zero address.
707      * - `to` cannot be the zero address.
708      * - `tokenId` token must exist and be owned by `from`.
709      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
710      *
711      * Emits a {Transfer} event.
712      */
713     function _safeTransfer(
714         address from,
715         address to,
716         uint256 tokenId,
717         bytes memory _data
718     ) internal virtual {
719         _transfer(from, to, tokenId);
720         require(_checkOnERC721Received(from, to, tokenId, _data), "txfr to non ERC721Reciever");
721     }
722 
723     /**
724      * @dev Returns whether `tokenId` exists.
725      *
726      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
727      *
728      * Tokens start existing when they are minted (`_mint`),
729      * and stop existing when they are burned (`_burn`).
730      */
731     function _exists(uint256 tokenId) internal view virtual returns (bool) {
732         return _owners[tokenId] != address(0);
733     }
734 
735     /**
736      * @dev Returns whether `spender` is allowed to manage `tokenId`.
737      *
738      * Requirements:
739      *
740      * - `tokenId` must exist.
741      */
742     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
743         require(_exists(tokenId), "ERC721: op query nonexistent tkn");
744         address owner = ownerOf(tokenId);
745         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
746     }
747 
748     /**
749      * @dev Safely mints `tokenId` and transfers it to `to`.
750      *
751      * Requirements:
752      *
753      * - `tokenId` must not exist.
754      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
755      *
756      * Emits a {Transfer} event.
757      */
758     function _safeMint(address to, uint256 tokenId) internal virtual {
759         _safeMint(to, tokenId, "");
760     }
761 
762     /**
763      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
764      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
765      */
766     function _safeMint(
767         address to,
768         uint256 tokenId,
769         bytes memory _data
770     ) internal virtual {
771         _mint(to, tokenId);
772         require(
773             _checkOnERC721Received(address(0), to, tokenId, _data),
774             "txfr to non ERC721Reciever"
775         );
776     }
777 
778     /**
779      * @dev Mints `tokenId` and transfers it to `to`.
780      *
781      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
782      *
783      * Requirements:
784      *
785      * - `tokenId` must not exist.
786      * - `to` cannot be the zero address.
787      *
788      * Emits a {Transfer} event.
789      */
790     function _mint(address to, uint256 tokenId) internal virtual {
791         require(to != address(0), "ERC721: mint to the zero address");
792         require(!_exists(tokenId), "ERC721: token already minted");
793 
794         _beforeTokenTransfer(address(0), to, tokenId);
795 
796         _balances[to] += 1;
797         _owners[tokenId] = to;
798 
799         emit Transfer(address(0), to, tokenId);
800     }
801 
802     /**
803      * @dev Destroys `tokenId`.
804      * The approval is cleared when the token is burned.
805      *
806      * Requirements:
807      *
808      * - `tokenId` must exist.
809      *
810      * Emits a {Transfer} event.
811      */
812     function _burn(uint256 tokenId) internal virtual {
813         address owner = ownerOf(tokenId);
814 
815         _beforeTokenTransfer(owner, address(0), tokenId);
816 
817         // Clear approvals
818         _approve(address(0), tokenId);
819 
820         _balances[owner] -= 1;
821         delete _owners[tokenId];
822 
823         emit Transfer(owner, address(0), tokenId);
824     }
825 
826     /**
827      * @dev Transfers `tokenId` from `from` to `to`.
828      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
829      *
830      * Requirements:
831      *
832      * - `to` cannot be the zero address.
833      * - `tokenId` token must be owned by `from`.
834      *
835      * Emits a {Transfer} event.
836      */
837     function _transfer(
838         address from,
839         address to,
840         uint256 tokenId
841     ) internal virtual {
842         require(ownerOf(tokenId) == from, "ERC721: txfr token not owned");
843         require(to != address(0), "ERC721: txfr to 0x0 address");
844         _beforeTokenTransfer(from, to, tokenId);
845 
846         // Clear approvals from the previous owner
847         _approve(address(0), tokenId);
848 
849         _balances[from] -= 1;
850         _balances[to] += 1;
851         _owners[tokenId] = to;
852 
853         emit Transfer(from, to, tokenId);
854     }
855 
856     /**
857      * @dev Approve `to` to operate on `tokenId`
858      *
859      * Emits a {Approval} event.
860      */
861     function _approve(address to, uint256 tokenId) internal virtual {
862         _tokenApprovals[tokenId] = to;
863         emit Approval(ownerOf(tokenId), to, tokenId);
864     }
865 
866     /**
867      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
868      * The call is not executed if the target address is not a contract.
869      *
870      * @param from address representing the previous owner of the given token ID
871      * @param to target address that will receive the tokens
872      * @param tokenId uint256 ID of the token to be transferred
873      * @param _data bytes optional data to send along with the call
874      * @return bool whether the call correctly returned the expected magic value
875      */
876     function _checkOnERC721Received(
877         address from,
878         address to,
879         uint256 tokenId,
880         bytes memory _data
881     ) private returns (bool) {
882         if (to.isContract()) {
883             try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
884                 return retval == IERC721Receiver(to).onERC721Received.selector;
885             } catch (bytes memory reason) {
886                 if (reason.length == 0) {
887                     revert("txfr to non ERC721Reciever");
888                 } else {
889                     assembly {
890                         revert(add(32, reason), mload(reason))
891                     }
892                 }
893             }
894         } else {
895             return true;
896         }
897     }
898     
899     // *********************** ERC721 Token Receiver **********************
900     /**
901      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
902      * by `operator` from `from`, this function is called.
903      *
904      * It must return its Solidity selector to confirm the token transfer.
905      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
906      *
907      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
908      */
909     function onERC721Received() external pure returns(bytes4) {
910         //InterfaceID=0x150b7a02
911         return this.onERC721Received.selector;
912     }
913 
914     /**
915      * @dev Hook that is called before any token transfer. This includes minting
916      * and burning.
917      *
918      * Calling conditions:
919      *
920      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
921      * transferred to `to`.
922      * - When `from` is zero, `tokenId` will be minted for `to`.
923      * - When `to` is zero, ``from``'s `tokenId` will be burned.
924      * - `from` and `to` are never both zero.
925      *
926      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
927      */
928     function _beforeTokenTransfer(
929         address from,
930         address to,
931         uint256 tokenId
932     ) internal virtual {}
933 
934     // **************************************** Metadata Standard Functions **********
935     //@dev Returns the token collection name.
936     function name() external view returns (string memory){
937         return _name;
938     }
939 
940     //@dev Returns the token collection symbol.
941     function symbol() external view returns (string memory){
942         return _symbol;
943     }
944 
945     //@dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
946     function tokenURI(uint256 tokenId) external view returns (string memory){
947         require(_exists(tokenId), "ERC721Metadata: URI 0x0 token");
948         string memory tokenuri;
949         if (_revealed){
950         	tokenuri = string(abi.encodePacked(_baseURI, toString(tokenId), ".json"));
951 		} else {
952 			tokenuri = string(abi.encodePacked(_baseURI, "mystery.json"));
953 		}
954         return tokenuri;
955     }
956     
957     function contractURI() public view returns (string memory) {
958             return string(abi.encodePacked(_baseURI,"contract.json"));
959     }
960     // *******************************************************************************
961 
962     receive() external payable {}
963     
964     fallback() external payable {}
965 }