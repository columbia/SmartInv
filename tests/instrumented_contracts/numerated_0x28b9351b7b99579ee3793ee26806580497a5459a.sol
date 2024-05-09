1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-01
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // File: newAvaContract.sol
7 
8 /**
9  *Submitted for verification at Etherscan.io on 2022-09-22
10 */
11 
12 // File: @openzeppelin/contracts/utils/Strings.sol
13 
14 
15 pragma solidity ^0.8.0;
16 
17 /*
18     Fully commented standard ERC721 Distilled from OpenZeppelin Docs
19     Base for Building ERC721 by Martin McConnell
20     All the utility without the fluff.
21 */
22 
23 
24 interface IERC165 {
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 interface IERC721 is IERC165 {
29     //@dev Emitted when `tokenId` token is transferred from `from` to `to`.
30     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
31 
32     //@dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
33     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
34 
35     //@dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
36     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
37 
38     //@dev Returns the number of tokens in ``owner``'s account.
39     function balanceOf(address owner) external view returns (uint256 balance);
40 
41     /**
42      * @dev Returns the owner of the `tokenId` token.
43      *
44      * Requirements:
45      *
46      * - `tokenId` must exist.
47      */
48     function ownerOf(uint256 tokenId) external view returns (address owner);
49 
50     /**
51      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
52      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
53      *
54      * Requirements:
55      *
56      * - `from` cannot be the zero address.
57      * - `to` cannot be the zero address.
58      * - `tokenId` token must exist and be owned by `from`.
59      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
60      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
61      *
62      * Emits a {Transfer} event.
63      */
64     function safeTransferFrom(address from,address to,uint256 tokenId) external;
65 
66     /**
67      * @dev Transfers `tokenId` token from `from` to `to`.
68      *
69      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
70      *
71      * Requirements:
72      *
73      * - `from` cannot be the zero address.
74      * - `to` cannot be the zero address.
75      * - `tokenId` token must be owned by `from`.
76      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transferFrom(address from, address to, uint256 tokenId) external;
81 
82     /**
83      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
84      * The approval is cleared when the token is transferred.
85      *
86      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
87      *
88      * Requirements:
89      *
90      * - The caller must own the token or be an approved operator.
91      * - `tokenId` must exist.
92      *
93      * Emits an {Approval} event.
94      */
95     function approve(address to, uint256 tokenId) external;
96 
97     /**
98      * @dev Returns the account approved for `tokenId` token.
99      *
100      * Requirements:
101      *
102      * - `tokenId` must exist.
103      */
104     function getApproved(uint256 tokenId) external view returns (address operator);
105 
106     /**
107      * @dev Approve or remove `operator` as an operator for the caller.
108      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
109      *
110      * Requirements:
111      * - The `operator` cannot be the caller.
112      *
113      * Emits an {ApprovalForAll} event.
114      */
115     function setApprovalForAll(address operator, bool _approved) external;
116 
117     //@dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
118     function isApprovedForAll(address owner, address operator) external view returns (bool);
119 
120     /**
121      * @dev Safely transfers `tokenId` token from `from` to `to`.
122      *
123      * Requirements:
124      *
125      * - `from` cannot be the zero address.
126      * - `to` cannot be the zero address.
127      * - `tokenId` token must exist and be owned by `from`.
128      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
129      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
130      *
131      * Emits a {Transfer} event.
132      */
133     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
134 }
135 
136 interface IERC721Metadata is IERC721 {
137     //@dev Returns the token collection name.
138     function name() external view returns (string memory);
139 
140     //@dev Returns the token collection symbol.
141     function symbol() external view returns (string memory);
142 
143     //@dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
144     function tokenURI(uint256 tokenId) external view returns (string memory);
145 }
146 
147 interface IERC721Receiver {
148     /**
149      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
150      * by `operator` from `from`, this function is called.
151      *
152      * It must return its Solidity selector to confirm the token transfer.
153      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
154      *
155      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
156      */
157     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
158 }
159 
160 library Address {
161     /**
162      * @dev Returns true if `account` is a contract.
163      *
164      * [IMPORTANT]
165      * ====
166      * It is unsafe to assume that an address for which this function returns
167      * false is an externally-owned account (EOA) and not a contract.
168      *
169      * Among others, `isContract` will return false for the following
170      * types of addresses:
171      *
172      *  - an externally-owned account
173      *  - a contract in construction
174      *  - an address where a contract will be created
175      *  - an address where a contract lived, but was destroyed
176      * ====
177      */
178     function isContract(address account) internal view returns (bool) {
179         // This method relies on extcodesize, which returns 0 for contracts in
180         // construction, since the code is only stored at the end of the
181         // constructor execution.
182 
183         uint256 size;
184         assembly {
185             size := extcodesize(account)
186         }
187         return size > 0;
188     }
189 
190     /**
191      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
192      * `recipient`, forwarding all available gas and reverting on errors.
193      *
194      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
195      * of certain opcodes, possibly making contracts go over the 2300 gas limit
196      * imposed by `transfer`, making them unable to receive funds via
197      * `transfer`. {sendValue} removes this limitation.
198      *
199      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
200      *
201      * IMPORTANT: because control is transferred to `recipient`, care must be
202      * taken to not create reentrancy vulnerabilities. Consider using
203      * {ReentrancyGuard} or the
204      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
205      */
206     function sendValue(address payable recipient, uint256 amount) internal {
207         require(address(this).balance >= amount, "Address: insufficient balance");
208 
209         (bool success, ) = recipient.call{value: amount}("");
210         require(success, "Addr: cant send val, rcpt revert");
211     }
212 
213     /**
214      * @dev Performs a Solidity function call using a low level `call`. A
215      * plain `call` is an unsafe replacement for a function call: use this
216      * function instead.
217      *
218      * If `target` reverts with a revert reason, it is bubbled up by this
219      * function (like regular Solidity function calls).
220      *
221      * Returns the raw returned data. To convert to the expected return value,
222      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
223      *
224      * Requirements:
225      *
226      * - `target` must be a contract.
227      * - calling `target` with `data` must not revert.
228      *
229      * _Available since v3.1._
230      */
231     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
232         return functionCall(target, data, "Address: low-level call failed");
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
237      * `errorMessage` as a fallback revert reason when `target` reverts.
238      *
239      * _Available since v3.1._
240      */
241     function functionCall(
242         address target,
243         bytes memory data,
244         string memory errorMessage
245     ) internal returns (bytes memory) {
246         return functionCallWithValue(target, data, 0, errorMessage);
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
251      * but also transferring `value` wei to `target`.
252      *
253      * Requirements:
254      *
255      * - the calling contract must have an ETH balance of at least `value`.
256      * - the called Solidity function must be `payable`.
257      *
258      * _Available since v3.1._
259      */
260     function functionCallWithValue(
261         address target,
262         bytes memory data,
263         uint256 value
264     ) internal returns (bytes memory) {
265         return functionCallWithValue(target, data, value, "Addr: low-level call value fail");
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
270      * with `errorMessage` as a fallback revert reason when `target` reverts.
271      *
272      * _Available since v3.1._
273      */
274     function functionCallWithValue(
275         address target,
276         bytes memory data,
277         uint256 value,
278         string memory errorMessage
279     ) internal returns (bytes memory) {
280         require(address(this).balance >= value, "Addr: insufficient balance call");
281         require(isContract(target), "Address: call to non-contract");
282 
283         (bool success, bytes memory returndata) = target.call{value: value}(data);
284         return _verifyCallResult(success, returndata, errorMessage);
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
289      * but performing a static call.
290      *
291      * _Available since v3.3._
292      */
293     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
294         return functionStaticCall(target, data, "Addr: low-level static call fail");
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
299      * but performing a static call.
300      *
301      * _Available since v3.3._
302      */
303     function functionStaticCall(
304         address target,
305         bytes memory data,
306         string memory errorMessage
307     ) internal view returns (bytes memory) {
308         require(isContract(target), "Addr: static call non-contract");
309 
310         (bool success, bytes memory returndata) = target.staticcall(data);
311         return _verifyCallResult(success, returndata, errorMessage);
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
316      * but performing a delegate call.
317      *
318      * _Available since v3.4._
319      */
320     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
321         return functionDelegateCall(target, data, "Addr: low-level del call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
326      * but performing a delegate call.
327      *
328      * _Available since v3.4._
329      */
330     function functionDelegateCall(
331         address target,
332         bytes memory data,
333         string memory errorMessage
334     ) internal returns (bytes memory) {
335         require(isContract(target), "Addr: delegate call non-contract");
336 
337         (bool success, bytes memory returndata) = target.delegatecall(data);
338         return _verifyCallResult(success, returndata, errorMessage);
339     }
340 
341     function _verifyCallResult(
342         bool success,
343         bytes memory returndata,
344         string memory errorMessage
345     ) private pure returns (bytes memory) {
346         if (success) {
347             return returndata;
348         } else {
349             // Look for revert reason and bubble it up if present
350             if (returndata.length > 0) {
351                 // The easiest way to bubble the revert reason is using memory via assembly
352 
353                 assembly {
354                     let returndata_size := mload(returndata)
355                     revert(add(32, returndata), returndata_size)
356                 }
357             } else {
358                 revert(errorMessage);
359             }
360         }
361     }
362 }
363 
364 abstract contract Context {
365     function _msgSender() internal view virtual returns (address) {
366         return msg.sender;
367     }
368 
369     function _msgData() internal view virtual returns (bytes calldata) {
370         return msg.data;
371     }
372 }
373 
374 abstract contract Ownable is Context {
375     address private _owner;
376 
377     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
378 
379     /**
380      * @dev Initializes the contract setting the deployer as the initial owner.
381      */
382     constructor() {
383         _setOwner(_msgSender());
384     }
385 
386     /**
387      * @dev Returns the address of the current owner.
388      */
389     function owner() public view virtual returns (address) {
390         return _owner;
391     }
392 
393     /**
394      * @dev Throws if called by any account other than the owner.
395      */
396     modifier onlyOwner() {
397         require(owner() == _msgSender(), "Ownable: caller is not the owner");
398         _;
399     }
400 
401     /**
402      * @dev Leaves the contract without owner. It will not be possible to call
403      * `onlyOwner` functions anymore. Can only be called by the current owner.
404      *
405      * NOTE: Renouncing ownership will leave the contract without an owner,
406      * thereby removing any functionality that is only available to the owner.
407      */
408     function renounceOwnership() public virtual onlyOwner {
409         _setOwner(address(0));
410     }
411 
412     /**
413      * @dev Transfers ownership of the contract to a new account (`newOwner`).
414      * Can only be called by the current owner.
415      */
416     function transferOwnership(address newOwner) public virtual onlyOwner {
417         require(newOwner != address(0), "Ownable: new owner is 0x address");
418         _setOwner(newOwner);
419     }
420 
421     function _setOwner(address newOwner) private {
422         address oldOwner = _owner;
423         _owner = newOwner;
424         emit OwnershipTransferred(oldOwner, newOwner);
425     }
426 }
427 
428 abstract contract Functional {
429     function toString(uint256 value) internal pure returns (string memory) {
430         if (value == 0) {
431             return "0";
432         }
433         uint256 temp = value;
434         uint256 digits;
435         while (temp != 0) {
436             digits++;
437             temp /= 10;
438         }
439         bytes memory buffer = new bytes(digits);
440         while (value != 0) {
441             digits -= 1;
442             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
443             value /= 10;
444         }
445         return string(buffer);
446     }
447     
448     bool private _reentryKey = false;
449     modifier reentryLock {
450         require(!_reentryKey, "attempt reenter locked function");
451         _reentryKey = true;
452         _;
453         _reentryKey = false;
454     }
455 }
456 
457 contract ERC721 {
458     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
459     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
460     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
461     function balanceOf(address owner) external view returns (uint256 balance){}
462     function ownerOf(uint256 tokenId) external view returns (address owner){}
463     function safeTransferFrom(address from,address to,uint256 tokenId) external{}
464     function transferFrom(address from, address to, uint256 tokenId) external{}
465     function approve(address to, uint256 tokenId) external{}
466     function getApproved(uint256 tokenId) external view returns (address operator){}
467     function setApprovalForAll(address operator, bool _approved) external{}
468     function isApprovedForAll(address owner, address operator) external view returns (bool){}
469     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external{}
470 }
471 
472 // ******************************************************************************************************************************
473 // **************************************************  Start of Main Contract ***************************************************
474 // ******************************************************************************************************************************
475 
476 contract AVIUSNEW is IERC721, Ownable, Functional {
477 
478     using Address for address;
479     
480     // Token name
481     string private _name;
482 
483     // Token symbol
484     string private _symbol;
485     
486     // URI Root Location for Json Files
487     string private _baseURI;
488 
489     // Mapping from token ID to owner address
490     mapping(uint256 => address) private _owners;
491 
492     // Mapping owner address to token count
493     mapping(address => uint256) private _balances;
494 
495     // Mapping from token ID to approved address
496     mapping(uint256 => address) private _tokenApprovals;
497 
498     // Mapping from owner to operator approvals
499     mapping(address => mapping(address => bool)) private _operatorApprovals;
500     
501     // Specific Functionality
502     bool public publicMintActive;
503     bool public whiteListActive;
504 	uint256 public _maxSupply;
505     uint256 public numberMinted;
506     uint256 public maxPerTxn;
507     uint256 public maxPerWallet = 10;
508 	bool private _revealed;
509     uint256 public nftprice;
510     uint public excludeCount; 
511     uint256[] public tokens;
512     mapping(address => uint256) private _mintTracker;
513     mapping(uint256 => bool) public excludedToken;
514        
515     address nftOwnerAddress      = payable(0x89AC334A1C882217916CB90f2A45cBA88cE35a52);
516     
517     //whitelist for holders
518     ERC721 CC; ///Elephants of Chameleons
519    
520     /**
521      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
522      */
523     constructor() {
524         _name = " AVIUS OBSCURIS NEW";
525         _symbol = "AVONew";
526         _baseURI = "https://aviusanimae.xyz/metadata/";
527        
528         CC = ERC721(0x0eDA3c383F13C36db1c96bD9c56f715B09b9E350); // AVA Burn token on etherscan
529 
530         _maxSupply = 5000; // 5000
531     }
532 
533     //@dev See {IERC165-supportsInterface}. Interfaces Supported by this Standard
534     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
535         return  interfaceId == type(IERC721).interfaceId ||
536                 interfaceId == type(IERC721Metadata).interfaceId ||
537                 interfaceId == type(IERC165).interfaceId ||
538                 interfaceId == AVIUSNEW.onERC721Received.selector;
539     }
540     
541     // Standard Withdraw function for the owner to pull the contract
542     function withdraw() external onlyOwner {
543         uint256 sendAmount = address(this).balance;
544         (bool success, ) = nftOwnerAddress.call{value: sendAmount}("");
545         require(success, "Transaction Unsuccessful");
546     }
547     
548     function airDrop(address _to, uint256 qty, uint256[] memory ids) external onlyOwner {
549         require(!publicMintActive && !whiteListActive, "Mint is Active first deactivate it by owner");
550         require((numberMinted + qty) > numberMinted, "Math overflow error");
551         require((_mintTracker[_to] + qty) <= maxPerWallet, "Mint: Max tkn per wallet exceeded");
552         require(qty == (ids.length)/2, "Please exclude 2x tokens to mintx new token");
553         uint256 mintSeedValue = numberMinted;
554         uint256 length = ids.length;
555        
556         for(uint i =0; i <length ; i++)
557         {
558             require(!excludedToken[ids[i]],"Anima Token must not be excluded ");
559             excludedToken[ids[i]] = true;
560             tokens.push(ids[i]);
561             excludeCount ++;
562         }
563         _mintTracker[_to] = _mintTracker[_to] + qty;
564        for(uint256 i = 1; i <= qty; i++) {
565             _safeMint(_to, mintSeedValue + i);
566             numberMinted ++;  //reservedTokens can be reset, numberMinted can not
567        }
568     }
569 
570     function excludeAnimaToken(uint256 _id1) public view returns(bool )
571     {
572         return (excludedToken[_id1]);
573     }
574 
575     function getAll() public view returns (uint256[] memory)
576     {
577     uint256[] memory  ret = new uint256[](excludeCount);
578     
579     for (uint i = 0; i < excludeCount; i++) {
580         ret[i] = tokens[i];
581     }
582     return ret;
583     }
584     
585 	function publicMint(uint256 qty) external payable reentryLock {
586 		require(publicMintActive, "Mint Not Active");
587         require((_mintTracker[msg.sender] + qty) <= maxPerWallet, "Mint: Max tkn per wallet exceeded");
588         require(numberMinted + qty <= _maxSupply, "Max supply exceeded");
589         require((msg.value >= 0) && (msg.value <= 100000000000000000), "Wrong Eth Amount");
590     
591         require(qty > 0, "Pease mint foronly 1 qunatity");
592       
593     	nftprice = msg.value;
594 		uint256 mintSeedValue = numberMinted;
595 		numberMinted += qty;
596 		_mintTracker[msg.sender] = _mintTracker[msg.sender] + qty;
597 		for(uint256 i = 1; i <= qty; i++) {
598         	_safeMint(_msgSender(), mintSeedValue + qty);
599         }
600 	}
601     function whiteListMint(uint256 qty, uint256[] memory ids) external payable reentryLock {
602 		require(CC.balanceOf(_msgSender()) >= 2, "Must have Avius Token");
603 		require(whiteListActive, "Mint Not Active");
604         
605         require((_mintTracker[msg.sender] + qty) <= maxPerWallet, "Mint: Max tkn per wallet exceeded");
606         require(numberMinted + qty <= _maxSupply, "Max supply exceeded");
607         require(msg.value >= 0, "Wrong Eth Amount");
608         require(qty == (ids.length)/2, "Please exclude 2x tokens to mintx new token");
609         for(uint i =0; i <ids.length ; i++)
610         {
611           require(!excludedToken[ids[i]],"Anima Token must not be excluded ");
612            require(msg.sender == (CC).ownerOf(ids[i]),"Called does not hold these token IDs");
613             }
614         uint length = ids.length;
615         
616         for(uint i =0; i <length ; i++)
617         {
618            
619             excludedToken[ids[i]] = true;
620             tokens.push(ids[i]);
621             excludeCount++;
622         }
623 
624     	nftprice = msg.value;
625 		uint256 mintSeedValue = numberMinted;
626 		numberMinted += qty;
627 		_mintTracker[msg.sender] = _mintTracker[msg.sender] + qty;
628 		for(uint256 i = 1; i <= qty; i++) {
629         	_safeMint(_msgSender(), mintSeedValue + i);
630         }
631 	}
632    
633     // allows holders to burn their own tokens if desired
634     function burn(uint256 tokenID, uint256 tokenIDTwo) external {
635         require(_msgSender() == (CC).ownerOf(tokenID), "Only token owner can call burn");
636         require(_msgSender() == (CC).ownerOf(tokenIDTwo), "Only token owner can call burn");
637         (CC).transferFrom(msg.sender, address(0x000000000000000000000000000000000000dEaD), tokenID);
638         (CC).transferFrom(msg.sender, address(0x000000000000000000000000000000000000dEaD), tokenIDTwo);
639     }
640     
641     //////////////////////////////////////////////////////////////
642     //////////////////// Setters and Getters /////////////////////
643     //////////////////////////////////////////////////////////////
644 	function reveal() external onlyOwner {
645 		_revealed = true;
646 	}
647 
648 	function changeMaxSupply( uint256 newValue ) external onlyOwner {
649 		_maxSupply = newValue;
650 	}
651 
652 	function hide() external onlyOwner {
653 		_revealed = false;
654 	}
655 
656     function setMaxMintThreshold(uint256 maxMints) external onlyOwner {
657         maxPerWallet = maxMints;
658     }
659     
660     function setBaseURI(string memory newURI) public onlyOwner {
661         _baseURI = newURI;
662     }
663     
664     function activatePublicMint() public onlyOwner {
665         publicMintActive = true;
666     }
667     
668     function deactivatePublicMint() public onlyOwner {
669         publicMintActive = false;
670     }
671 
672     function activeWhiteListMint() public onlyOwner {
673         whiteListActive = true;
674     }
675     
676     function deactivateWhiteListMint() public onlyOwner {
677         whiteListActive = false;
678     }
679    
680     function totalSupply() external view returns (uint256) {
681         return numberMinted; //stupid bs for etherscan's call
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
997     function onERC721Received() external pure returns(bytes4) {
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
1037         if (_revealed){
1038         	tokenuri = string(abi.encodePacked(_baseURI, toString(tokenId), ".json"));
1039 		} else {
1040 			tokenuri = string(abi.encodePacked(_baseURI, "mystery.json"));
1041 		}
1042         return tokenuri;
1043     }
1044     
1045     function contractURI() public view returns (string memory) {
1046             return string(abi.encodePacked(_baseURI,"contract.json"));
1047     }
1048     // *******************************************************************************
1049 
1050     receive() external payable {}
1051     
1052     fallback() external payable {}
1053 }