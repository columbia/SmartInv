1 // Sources flattened with hardhat v2.6.8 https://hardhat.org
2 
3 // File contracts/IERC165.sol
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
20 
21 // File contracts/IERC721.sol
22 
23 pragma solidity ^0.8.0;
24 
25 interface IERC721 is IERC165 {
26     //@dev Emitted when `tokenId` token is transferred from `from` to `to`.
27     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
28 
29     //@dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
30     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
31 
32     //@dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
33     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
34 
35     //@dev Returns the number of tokens in ``owner``'s account.
36     function balanceOf(address owner) external view returns (uint256 balance);
37 
38     /**
39      * @dev Returns the owner of the `tokenId` token.
40      *
41      * Requirements:
42      *
43      * - `tokenId` must exist.
44      */
45     function ownerOf(uint256 tokenId) external view returns (address owner);
46 
47     /**
48      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
49      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
50      *
51      * Requirements:
52      *
53      * - `from` cannot be the zero address.
54      * - `to` cannot be the zero address.
55      * - `tokenId` token must exist and be owned by `from`.
56      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
57      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
58      *
59      * Emits a {Transfer} event.
60      */
61     function safeTransferFrom(address from,address to,uint256 tokenId) external;
62 
63     /**
64      * @dev Transfers `tokenId` token from `from` to `to`.
65      *
66      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
67      *
68      * Requirements:
69      *
70      * - `from` cannot be the zero address.
71      * - `to` cannot be the zero address.
72      * - `tokenId` token must be owned by `from`.
73      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transferFrom(address from, address to, uint256 tokenId) external;
78 
79     /**
80      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
81      * The approval is cleared when the token is transferred.
82      *
83      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
84      *
85      * Requirements:
86      *
87      * - The caller must own the token or be an approved operator.
88      * - `tokenId` must exist.
89      *
90      * Emits an {Approval} event.
91      */
92     function approve(address to, uint256 tokenId) external;
93 
94     /**
95      * @dev Returns the account approved for `tokenId` token.
96      *
97      * Requirements:
98      *
99      * - `tokenId` must exist.
100      */
101     function getApproved(uint256 tokenId) external view returns (address operator);
102 
103     /**
104      * @dev Approve or remove `operator` as an operator for the caller.
105      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
106      *
107      * Requirements:
108      * - The `operator` cannot be the caller.
109      *
110      * Emits an {ApprovalForAll} event.
111      */
112     function setApprovalForAll(address operator, bool _approved) external;
113 
114     //@dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
115     function isApprovedForAll(address owner, address operator) external view returns (bool);
116 
117     /**
118      * @dev Safely transfers `tokenId` token from `from` to `to`.
119      *
120      * Requirements:
121      *
122      * - `from` cannot be the zero address.
123      * - `to` cannot be the zero address.
124      * - `tokenId` token must exist and be owned by `from`.
125      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
126      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
127      *
128      * Emits a {Transfer} event.
129      */
130     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
131 }
132 
133 
134 // File contracts/IERC721Receiver.sol
135 
136 pragma solidity ^0.8.0;
137 interface IERC721Receiver {
138     /**
139      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
140      * by `operator` from `from`, this function is called.
141      *
142      * It must return its Solidity selector to confirm the token transfer.
143      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
144      *
145      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
146      */
147     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
148 }
149 
150 
151 // File contracts/IERC721Metadata.sol
152 
153 pragma solidity ^0.8.0;
154 
155 interface IERC721Metadata is IERC721 {
156     //@dev Returns the token collection name.
157     function name() external view returns (string memory);
158 
159     //@dev Returns the token collection symbol.
160     function symbol() external view returns (string memory);
161 
162     //@dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
163     function tokenURI(uint256 tokenId) external view returns (string memory);
164 }
165 
166 
167 // File contracts/Context.sol
168 
169 pragma solidity ^0.8.0;
170 
171 
172 
173 abstract contract Context {
174     function _msgSender() internal view virtual returns (address) {
175         return msg.sender;
176     }
177 
178     function _msgData() internal view virtual returns (bytes calldata) {
179         return msg.data;
180     }
181 }
182 
183 
184 // File contracts/Ownable.sol
185 
186 pragma solidity ^0.8.0;
187 
188 abstract contract Ownable is Context {
189     address private _owner;
190 
191     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
192 
193     /**
194      * @dev Initializes the contract setting the deployer as the initial owner.
195      */
196     constructor() {
197         _setOwner(_msgSender());
198     }
199 
200     /**
201      * @dev Returns the address of the current owner.
202      */
203     function owner() public view virtual returns (address) {
204         return _owner;
205     }
206 
207     /**
208      * @dev Throws if called by any account other than the owner.
209      */
210     modifier onlyOwner() {
211         require(owner() == _msgSender(), "Ownable: caller is not the owner");
212         _;
213     }
214 
215     /**
216      * @dev Leaves the contract without owner. It will not be possible to call
217      * `onlyOwner` functions anymore. Can only be called by the current owner.
218      *
219      * NOTE: Renouncing ownership will leave the contract without an owner,
220      * thereby removing any functionality that is only available to the owner.
221      */
222     function renounceOwnership() public virtual onlyOwner {
223         _setOwner(address(0));
224     }
225 
226     /**
227      * @dev Transfers ownership of the contract to a new account (`newOwner`).
228      * Can only be called by the current owner.
229      */
230     function transferOwnership(address newOwner) public virtual onlyOwner {
231         require(newOwner != address(0), "Ownable: new owner is the zero address");
232         _setOwner(newOwner);
233     }
234 
235     function _setOwner(address newOwner) private {
236         address oldOwner = _owner;
237         _owner = newOwner;
238         emit OwnershipTransferred(oldOwner, newOwner);
239     }
240 }
241 
242 
243 // File contracts/Functional.sol
244 
245 pragma solidity ^0.8.0;
246 
247 
248 abstract contract Functional {
249     function toString(uint256 value) internal pure returns (string memory) {
250         if (value == 0) {
251             return "0";
252         }
253         uint256 temp = value;
254         uint256 digits;
255         while (temp != 0) {
256             digits++;
257             temp /= 10;
258         }
259         bytes memory buffer = new bytes(digits);
260         while (value != 0) {
261             digits -= 1;
262             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
263             value /= 10;
264         }
265         return string(buffer);
266     }
267     
268     bool private _reentryKey = false;
269     modifier reentryLock {
270         require(!_reentryKey, "attempt to reenter a locked function");
271         _reentryKey = true;
272         _;
273         _reentryKey = false;
274     }
275 }
276 
277 
278 // File contracts/Address.sol
279 
280 pragma solidity ^0.8.0;
281 
282 library Address {
283     /**
284      * @dev Returns true if `account` is a contract.
285      *
286      * [IMPORTANT]
287      * ====
288      * It is unsafe to assume that an address for which this function returns
289      * false is an externally-owned account (EOA) and not a contract.
290      *
291      * Among others, `isContract` will return false for the following
292      * types of addresses:
293      *
294      *  - an externally-owned account
295      *  - a contract in construction
296      *  - an address where a contract will be created
297      *  - an address where a contract lived, but was destroyed
298      * ====
299      */
300     function isContract(address account) internal view returns (bool) {
301         // This method relies on extcodesize, which returns 0 for contracts in
302         // construction, since the code is only stored at the end of the
303         // constructor execution.
304 
305         uint256 size;
306         assembly {
307             size := extcodesize(account)
308         }
309         return size > 0;
310     }
311 
312     /**
313      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
314      * `recipient`, forwarding all available gas and reverting on errors.
315      *
316      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
317      * of certain opcodes, possibly making contracts go over the 2300 gas limit
318      * imposed by `transfer`, making them unable to receive funds via
319      * `transfer`. {sendValue} removes this limitation.
320      *
321      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
322      *
323      * IMPORTANT: because control is transferred to `recipient`, care must be
324      * taken to not create reentrancy vulnerabilities. Consider using
325      * {ReentrancyGuard} or the
326      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
327      */
328     function sendValue(address payable recipient, uint256 amount) internal {
329         require(address(this).balance >= amount, "Address: insufficient balance");
330 
331         (bool success, ) = recipient.call{value: amount}("");
332         require(success, "Address: unable to send value, recipient may have reverted");
333     }
334 
335     /**
336      * @dev Performs a Solidity function call using a low level `call`. A
337      * plain `call` is an unsafe replacement for a function call: use this
338      * function instead.
339      *
340      * If `target` reverts with a revert reason, it is bubbled up by this
341      * function (like regular Solidity function calls).
342      *
343      * Returns the raw returned data. To convert to the expected return value,
344      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
345      *
346      * Requirements:
347      *
348      * - `target` must be a contract.
349      * - calling `target` with `data` must not revert.
350      *
351      * _Available since v3.1._
352      */
353     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
354         return functionCall(target, data, "Address: low-level call failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
359      * `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCall(
364         address target,
365         bytes memory data,
366         string memory errorMessage
367     ) internal returns (bytes memory) {
368         return functionCallWithValue(target, data, 0, errorMessage);
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
373      * but also transferring `value` wei to `target`.
374      *
375      * Requirements:
376      *
377      * - the calling contract must have an ETH balance of at least `value`.
378      * - the called Solidity function must be `payable`.
379      *
380      * _Available since v3.1._
381      */
382     function functionCallWithValue(
383         address target,
384         bytes memory data,
385         uint256 value
386     ) internal returns (bytes memory) {
387         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
392      * with `errorMessage` as a fallback revert reason when `target` reverts.
393      *
394      * _Available since v3.1._
395      */
396     function functionCallWithValue(
397         address target,
398         bytes memory data,
399         uint256 value,
400         string memory errorMessage
401     ) internal returns (bytes memory) {
402         require(address(this).balance >= value, "Address: insufficient balance for call");
403         require(isContract(target), "Address: call to non-contract");
404 
405         (bool success, bytes memory returndata) = target.call{value: value}(data);
406         return _verifyCallResult(success, returndata, errorMessage);
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
411      * but performing a static call.
412      *
413      * _Available since v3.3._
414      */
415     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
416         return functionStaticCall(target, data, "Address: low-level static call failed");
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
421      * but performing a static call.
422      *
423      * _Available since v3.3._
424      */
425     function functionStaticCall(
426         address target,
427         bytes memory data,
428         string memory errorMessage
429     ) internal view returns (bytes memory) {
430         require(isContract(target), "Address: static call to non-contract");
431 
432         (bool success, bytes memory returndata) = target.staticcall(data);
433         return _verifyCallResult(success, returndata, errorMessage);
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
438      * but performing a delegate call.
439      *
440      * _Available since v3.4._
441      */
442     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
443         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
448      * but performing a delegate call.
449      *
450      * _Available since v3.4._
451      */
452     function functionDelegateCall(
453         address target,
454         bytes memory data,
455         string memory errorMessage
456     ) internal returns (bytes memory) {
457         require(isContract(target), "Address: delegate call to non-contract");
458 
459         (bool success, bytes memory returndata) = target.delegatecall(data);
460         return _verifyCallResult(success, returndata, errorMessage);
461     }
462 
463     function _verifyCallResult(
464         bool success,
465         bytes memory returndata,
466         string memory errorMessage
467     ) private pure returns (bytes memory) {
468         if (success) {
469             return returndata;
470         } else {
471             // Look for revert reason and bubble it up if present
472             if (returndata.length > 0) {
473                 // The easiest way to bubble the revert reason is using memory via assembly
474 
475                 assembly {
476                     let returndata_size := mload(returndata)
477                     revert(add(32, returndata), returndata_size)
478                 }
479             } else {
480                 revert(errorMessage);
481             }
482         }
483     }
484 }
485 
486 
487 // File contracts/ControlledAccess.sol
488 
489 pragma solidity ^0.8.0;
490 
491 /* @title ControlledAccess
492  * @dev The ControlledAccess contract allows function to be restricted to users
493  * that possess a signed authorization from the owner of the contract. This signed
494  * message includes the user to give permission to and the contract address to prevent
495  * reusing the same authorization message on different contract with same owner.
496  */
497 
498 contract ControlledAccess is Ownable {
499     address public signerAddress;
500 
501     /*
502      * @dev Requires msg.sender to have valid access message.
503      * @param _v ECDSA signature parameter v.
504      * @param _r ECDSA signature parameters r.
505      * @param _s ECDSA signature parameters s.
506      */
507     modifier onlyValidAccess(
508         bytes32 _r,
509         bytes32 _s,
510         uint8 _v
511     ) {
512         require(isValidAccessMessage(msg.sender, _r, _s, _v));
513         _;
514     }
515 
516     function setSignerAddress(address newAddress) external onlyOwner {
517         signerAddress = newAddress;
518     }
519 
520     /*
521      * @dev Verifies if message was signed by owner to give access to _add for this contract.
522      *      Assumes Geth signature prefix.
523      * @param _add Address of agent with access
524      * @param _v ECDSA signature parameter v.
525      * @param _r ECDSA signature parameters r.
526      * @param _s ECDSA signature parameters s.
527      * @return Validity of access message for a given address.
528      */
529     function isValidAccessMessage(
530         address _add,
531         bytes32 _r,
532         bytes32 _s,
533         uint8 _v
534     ) public view returns (bool) {
535         bytes32 hash = keccak256(abi.encode(owner(), _add));
536         bytes32 message = keccak256(
537             abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
538         );
539         address sig = ecrecover(message, _v, _r, _s);
540 
541         require(signerAddress == sig, "Signature does not match");
542 
543         return signerAddress == sig;
544     }
545 }
546 
547 
548 // File contracts/SODA.sol
549 
550 // ******************************************************************************************************************************
551 // **************************************************  Start of Main Contract ***************************************************
552 // ******************************************************************************************************************************
553 
554 pragma solidity ^0.8.0;
555 
556 
557 
558 
559 
560 
561 
562 contract SODA is IERC721, Ownable, Functional, ControlledAccess {
563 
564     using Address for address;
565 
566     // Token name
567     string private _name;
568 
569     // Token symbol
570     string private _symbol;
571 
572     // URI Root Location for Json Files
573     string private _baseURI;
574 
575     // Provenance hash proving random distribution
576     string public provenanceHash;
577 
578     // Mapping from token ID to owner address
579     mapping(uint256 => address) private _owners;
580 
581     // Mapping owner address to token count
582     mapping(address => uint256) private _balances;
583 
584     // Mapping from token ID to approved address
585     mapping(uint256 => address) private _tokenApprovals;
586 
587     // Mapping from owner to operator approvals
588     mapping(address => mapping(address => bool)) private _operatorApprovals;
589 
590     // Specific Functionality
591     bool public mintActive;
592     bool public presaleActive;
593     uint256 public price;
594     uint256 public totalTokens;
595     uint256 public numberMinted;
596     uint256 public maxPerWallet;
597     uint256 public maxPerTx;
598     uint256 public reservedTokens;
599 
600     uint256 public startingIndex;
601     uint256 public startingIndexBlock;
602     mapping(address => uint256) private _tokensMintedby;
603 
604     /**
605      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
606      */
607     constructor() {
608         _name = "Society of Derivative Apes";
609         _symbol = "SODA";
610 
611         mintActive = false;
612         presaleActive = false;
613         totalTokens = 9999; // 0-9998
614         price = 0.04 ether;
615         maxPerWallet = 6;
616         maxPerTx = 3;
617         reservedTokens = 100; // reserved for giveaways and such
618     }
619 
620     //@dev See {IERC165-supportsInterface}. Interfaces Supported by this Standard
621     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
622         return  interfaceId == type(IERC721).interfaceId ||
623                 interfaceId == type(IERC721Metadata).interfaceId ||
624                 interfaceId == type(IERC165).interfaceId ||
625                 interfaceId == SODA.onERC721Received.selector;
626     }
627 
628     // Standard Withdraw function for the owner to pull the contract
629     function withdraw() external onlyOwner {
630         uint256 sendAmount = address(this).balance;
631 
632         address founders = payable(0x62F9ACbD11350FB05B3215507dD1f6e05ed27aF5);
633         address liam = payable(0x3C31abE4b91c9e8bD39fB505CD98c59fc78cD8E6);
634         address drew = payable(0x30A8Bac5AED69b9fF46d4fC04A48388cDe5D3A59);
635         address yeti = payable(0xDF808192A2cb234e276eEF4551228e422a5b6B1A);
636         address community = payable(0x9fcDD9A89C0a5F8933659077b0Caf2c1EF20ac21);
637 
638         bool success;
639         (success, ) = founders.call{value: ((sendAmount * 51)/100)}("");
640         require(success, "Transaction Unsuccessful");
641 
642         (success, ) = liam.call{value: ((sendAmount * 13)/100)}("");
643         require(success, "Transaction Unsuccessful");
644 
645         (success, ) = drew.call{value: ((sendAmount * 13)/100)}("");
646         require(success, "Transaction Unsuccessful");
647 
648         (success, ) = yeti.call{value: ((sendAmount * 13)/100)}("");
649         require(success, "Transaction Unsuccessful");
650 
651         (success, ) = community.call{value: ((sendAmount * 10)/100)}("");
652         require(success, "Transaction Unsuccessful");
653      }
654 
655     function airDrop(address[] memory _to) external onlyOwner {
656         uint256 qty = _to.length;
657         require((numberMinted + qty) > numberMinted, "Math overflow error");
658         require((numberMinted + qty) < totalTokens, "Cannot fill order");
659 
660         uint256 mintSeedValue = numberMinted;
661         if (reservedTokens >= qty) {
662             reservedTokens -= qty;
663         } else {
664             reservedTokens = 0;
665         }
666 
667         for(uint256 i = 0; i < qty; i++) {
668             _safeMint(_to[i], mintSeedValue + i);
669             numberMinted ++;  //reservedTokens can be reset, numberMinted can not
670         }
671     }
672 
673     function mint(uint256 qty) external payable reentryLock {
674         require(mintActive);
675         require((qty + reservedTokens + numberMinted) < totalTokens, "Mint: Not enough availability");
676         require(qty <= maxPerTx, "Mint: Max tokens per transaction exceeded");
677         require((_tokensMintedby[_msgSender()] + qty) <= maxPerWallet, "Mint: Max tokens per wallet exceeded");
678         require(msg.value >= qty * price, "Mint: Insufficient Funds");
679 
680         uint256 mintSeedValue = numberMinted; //Store the starting value of the mint batch
681 
682         //Handle ETH transactions
683         uint256 cashIn = msg.value;
684         uint256 cashChange = cashIn - (qty * price);
685 
686         //send tokens
687         for(uint256 i = 0; i < qty; i++) {
688             _safeMint(_msgSender(), mintSeedValue + i);
689             numberMinted ++;
690             _tokensMintedby[_msgSender()] ++;
691         }
692 
693         if (cashChange > 0){
694             (bool success, ) = msg.sender.call{value: cashChange}("");
695             require(success, "Mint: unable to send change to user");
696         }
697     }
698 
699     function presaleMint(uint256 qty,
700         bytes32 _r,
701         bytes32 _s,
702         uint8 _v
703                         ) external payable onlyValidAccess(_r, _s, _v) reentryLock {
704         require(presaleActive);
705         require((_tokensMintedby[_msgSender()] + qty) <= maxPerTx, "Presale Mint: Max tokens during presale exceeded");
706         require((qty + reservedTokens + numberMinted) < totalTokens, "Mint: Not enough availability");
707         require(msg.value >= qty * price, "Mint: Insufficient Funds");
708 
709         uint256 mintSeedValue = numberMinted; //Store the starting value of the mint batch
710 
711         //Handle ETH transactions
712         uint256 cashIn = msg.value;
713         uint256 cashChange = cashIn - (qty * price);
714 
715         //send tokens
716         for(uint256 i = 0; i < qty; i++) {
717             _safeMint(_msgSender(), mintSeedValue + i);
718             numberMinted ++;
719             _tokensMintedby[_msgSender()] ++;
720         }
721 
722         if (cashChange > 0){
723             (bool success, ) = msg.sender.call{value: cashChange}("");
724             require(success, "Mint: unable to send change to user");
725         }
726     }
727 
728 
729     // allows holders to burn their own tokens if desired
730     /*
731     function burn(uint256 tokenID) external {
732         require(_msgSender() == ownerOf(tokenID));
733         _burn(tokenID);
734     }
735     */
736     //////////////////////////////////////////////////////////////
737     //////////////////// Setters and Getters /////////////////////
738     //////////////////////////////////////////////////////////////
739 
740     function setMaxPerWallet(uint256 maxWallet) external onlyOwner {
741         maxPerWallet = maxWallet;
742     }
743 
744     function setMaxPerTx(uint256 newMax) external onlyOwner {
745         maxPerTx = newMax;
746     }
747 
748     function setBaseURI(string memory newURI) public onlyOwner {
749         _baseURI = newURI;
750    }
751 
752     function activateMint() public onlyOwner {
753         mintActive = true;
754     }
755 
756     function activatePresale() public onlyOwner {
757         presaleActive = true;
758     }
759 
760     function deactivateMint() public onlyOwner {
761         mintActive = false;
762     }
763 
764     function deactivatePresale() public onlyOwner {
765         presaleActive = false;
766     }
767 
768     function setPrice(uint256 newPrice) public onlyOwner {
769         price = newPrice;
770     }
771 
772     function setTotalTokens(uint256 numTokens) public onlyOwner {
773         totalTokens = numTokens;
774     }
775 
776     function totalSupply() external view returns (uint256) {
777         return numberMinted;
778     }
779 
780     function getBalance(address tokenAddress) view external returns (uint256) {
781         return _balances[tokenAddress];
782     }
783 
784     /**
785      * @dev See {IERC721-balanceOf}.
786      */
787     function balanceOf(address owner) public view virtual override returns (uint256) {
788         require(owner != address(0), "ERC721: balance query for the zero address");
789         return _balances[owner];
790     }
791 
792     /**
793      * @dev See {IERC721-ownerOf}.
794      */
795     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
796         address owner = _owners[tokenId];
797         require(owner != address(0), "ERC721: owner query for nonexistent token");
798         return owner;
799     }
800 
801     /**
802      * @dev See {IERC721-approve}.
803      */
804     function approve(address to, uint256 tokenId) public virtual override {
805         address owner = ownerOf(tokenId);
806         require(to != owner, "ERC721: approval to current owner");
807 
808         require(
809             msg.sender == owner || isApprovedForAll(owner, msg.sender),
810             "ERC721: approve caller is not owner nor approved for all"
811         );
812 
813         _approve(to, tokenId);
814     }
815 
816     /**
817      * @dev See {IERC721-getApproved}.
818      */
819     function getApproved(uint256 tokenId) public view virtual override returns (address) {
820         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
821 
822         return _tokenApprovals[tokenId];
823     }
824 
825     /**
826      * @dev See {IERC721-setApprovalForAll}.
827      */
828     function setApprovalForAll(address operator, bool approved) public virtual override {
829         require(operator != msg.sender, "ERC721: approve to caller");
830 
831         _operatorApprovals[msg.sender][operator] = approved;
832         emit ApprovalForAll(msg.sender, operator, approved);
833     }
834 
835     /**
836      * @dev See {IERC721-isApprovedForAll}.
837      */
838     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
839         return _operatorApprovals[owner][operator];
840     }
841 
842     /**
843      * @dev See {IERC721-transferFrom}.
844      */
845     function transferFrom(
846         address from,
847         address to,
848         uint256 tokenId
849     ) public virtual override {
850         //solhint-disable-next-line max-line-length
851         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
852 
853         _transfer(from, to, tokenId);
854     }
855 
856     /**
857      * @dev See {IERC721-safeTransferFrom}.
858      */
859     function safeTransferFrom(
860         address from,
861         address to,
862         uint256 tokenId
863     ) public virtual override {
864         safeTransferFrom(from, to, tokenId, "");
865     }
866 
867     /**
868      * @dev See {IERC721-safeTransferFrom}.
869      */
870     function safeTransferFrom(
871         address from,
872         address to,
873         uint256 tokenId,
874         bytes memory _data
875     ) public virtual override {
876         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
877         _safeTransfer(from, to, tokenId, _data);
878     }
879 
880     /**
881      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
882      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
883      *
884      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
885      *
886      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
887      * implement alternative mechanisms to perform token transfer, such as signature-based.
888      *
889      * Requirements:
890      *
891      * - `from` cannot be the zero address.
892      * - `to` cannot be the zero address.
893      * - `tokenId` token must exist and be owned by `from`.
894      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
895      *
896      * Emits a {Transfer} event.
897      */
898     function _safeTransfer(
899         address from,
900         address to,
901         uint256 tokenId,
902         bytes memory _data
903     ) internal virtual {
904         _transfer(from, to, tokenId);
905         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
906     }
907 
908     /**
909      * @dev Returns whether `tokenId` exists.
910      *
911      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
912      *
913      * Tokens start existing when they are minted (`_mint`),
914      * and stop existing when they are burned (`_burn`).
915      */
916     function _exists(uint256 tokenId) internal view virtual returns (bool) {
917         return _owners[tokenId] != address(0);
918     }
919 
920     /**
921      * @dev Returns whether `spender` is allowed to manage `tokenId`.
922      *
923      * Requirements:
924      *
925      * - `tokenId` must exist.
926      */
927     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
928         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
929         address owner = ownerOf(tokenId);
930         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
931     }
932 
933     /**
934      * @dev Safely mints `tokenId` and transfers it to `to`.
935      *
936      * Requirements:
937      *
938      * - `tokenId` must not exist.
939      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
940      *
941      * Emits a {Transfer} event.
942      */
943     function _safeMint(address to, uint256 tokenId) internal virtual {
944         _safeMint(to, tokenId, "");
945     }
946 
947     /**
948      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
949      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
950      */
951     function _safeMint(
952         address to,
953         uint256 tokenId,
954         bytes memory _data
955     ) internal virtual {
956         _mint(to, tokenId);
957         require(
958             _checkOnERC721Received(address(0), to, tokenId, _data),
959             "ERC721: transfer to non ERC721Receiver implementer"
960         );
961     }
962 
963     /**
964      * @dev Mints `tokenId` and transfers it to `to`.
965      *
966      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
967      *
968      * Requirements:
969      *
970      * - `tokenId` must not exist.
971      * - `to` cannot be the zero address.
972      *
973      * Emits a {Transfer} event.
974      */
975     function _mint(address to, uint256 tokenId) internal virtual {
976         require(to != address(0), "ERC721: mint to the zero address");
977         require(!_exists(tokenId), "ERC721: token already minted");
978 
979         _beforeTokenTransfer(address(0), to, tokenId);
980 
981         _balances[to] += 1;
982         _owners[tokenId] = to;
983 
984         emit Transfer(address(0), to, tokenId);
985     }
986 
987     /**
988      * @dev Destroys `tokenId`.
989      * The approval is cleared when the token is burned.
990      *
991      * Requirements:
992      *
993      * - `tokenId` must exist.
994      *
995      * Emits a {Transfer} event.
996      */
997     function _burn(uint256 tokenId) internal virtual {
998         address owner = ownerOf(tokenId);
999 
1000         _beforeTokenTransfer(owner, address(0), tokenId);
1001 
1002         // Clear approvals
1003         _approve(address(0), tokenId);
1004 
1005         _balances[owner] -= 1;
1006         delete _owners[tokenId];
1007 
1008         emit Transfer(owner, address(0), tokenId);
1009     }
1010 
1011     /**
1012      * @dev Transfers `tokenId` from `from` to `to`.
1013      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1014      *
1015      * Requirements:
1016      *
1017      * - `to` cannot be the zero address.
1018      * - `tokenId` token must be owned by `from`.
1019      *
1020      * Emits a {Transfer} event.
1021      */
1022     function _transfer(
1023         address from,
1024         address to,
1025         uint256 tokenId
1026     ) internal virtual {
1027         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1028         require(to != address(0), "ERC721: transfer to the zero address");
1029 
1030         _beforeTokenTransfer(from, to, tokenId);
1031 
1032         // Clear approvals from the previous owner
1033         _approve(address(0), tokenId);
1034 
1035         _balances[from] -= 1;
1036         _balances[to] += 1;
1037         _owners[tokenId] = to;
1038 
1039         emit Transfer(from, to, tokenId);
1040     }
1041 
1042     /**
1043      * @dev Approve `to` to operate on `tokenId`
1044      *
1045      * Emits a {Approval} event.
1046      */
1047     function _approve(address to, uint256 tokenId) internal virtual {
1048         _tokenApprovals[tokenId] = to;
1049         emit Approval(ownerOf(tokenId), to, tokenId);
1050     }
1051 
1052     /**
1053      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1054      * The call is not executed if the target address is not a contract.
1055      *
1056      * @param from address representing the previous owner of the given token ID
1057      * @param to target address that will receive the tokens
1058      * @param tokenId uint256 ID of the token to be transferred
1059      * @param _data bytes optional data to send along with the call
1060      * @return bool whether the call correctly returned the expected magic value
1061      */
1062     function _checkOnERC721Received(
1063         address from,
1064         address to,
1065         uint256 tokenId,
1066         bytes memory _data
1067     ) private returns (bool) {
1068         if (to.isContract()) {
1069             try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
1070                 return retval == IERC721Receiver(to).onERC721Received.selector;
1071             } catch (bytes memory reason) {
1072                 if (reason.length == 0) {
1073                     revert("ERC721: transfer to non ERC721Receiver implementer");
1074                 } else {
1075                     assembly {
1076                         revert(add(32, reason), mload(reason))
1077                     }
1078                 }
1079             }
1080         } else {
1081             return true;
1082         }
1083     }
1084 
1085     // *********************** ERC721 Token Receiver **********************
1086     /**
1087      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1088      * by `operator` from `from`, this function is called.
1089      *
1090      * It must return its Solidity selector to confirm the token transfer.
1091      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1092      *
1093      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1094      */
1095     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4) {
1096         //InterfaceID=0x150b7a02
1097         return this.onERC721Received.selector;
1098     }
1099 
1100     /**
1101      * @dev Hook that is called before any token transfer. This includes minting
1102      * and burning.
1103      *
1104      * Calling conditions:
1105      *
1106      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1107      * transferred to `to`.
1108      * - When `from` is zero, `tokenId` will be minted for `to`.
1109      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1110      * - `from` and `to` are never both zero.
1111      *
1112      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1113      */
1114     function _beforeTokenTransfer(
1115         address from,
1116         address to,
1117         uint256 tokenId
1118     ) internal virtual {}
1119 
1120     // **************************************** Metadata Standard Functions **********
1121     //@dev Returns the token collection name.
1122     function name() external view returns (string memory){
1123         return _name;
1124     }
1125 
1126     //@dev Returns the token collection symbol.
1127     function symbol() external view returns (string memory){
1128         return _symbol;
1129     }
1130 
1131     //@dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1132     function tokenURI(uint256 tokenId) external view returns (string memory){
1133         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1134 
1135         return string(abi.encodePacked(_baseURI, toString(tokenId), ".json")); /// 0.json 135.json
1136 
1137     }
1138 
1139     function contractURI() public view returns (string memory) {
1140             return string(abi.encodePacked(_baseURI,"contract.json"));
1141     }
1142 
1143     function setProvenanceHash(string calldata hash) public onlyOwner {
1144         provenanceHash = hash;
1145     }
1146 
1147     /**
1148      * Set the starting index for the collection
1149      */
1150     function setStartingIndex() public onlyOwner {
1151         require(startingIndex == 0, "Starting index is already set");
1152         require(startingIndexBlock != 0, "Starting index block must be set");
1153 
1154         startingIndex = uint256(blockhash(startingIndexBlock)) % totalTokens;
1155         // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
1156         if (block.number % startingIndexBlock > 255) {
1157             startingIndex = uint256(blockhash(block.number - 1)) % totalTokens;
1158         }
1159         // Prevent default sequence
1160         if (startingIndex == 0) {
1161             startingIndex = startingIndex + 1;
1162         }
1163     }
1164 
1165     /**
1166      * Set the starting index block for the collection, essentially unblocking
1167      * setting starting index
1168      */
1169     function setStartingIndexBlock() public onlyOwner {
1170         require(startingIndex == 0, "Starting index is already set");
1171 
1172         startingIndexBlock = block.number;
1173     }
1174 
1175     receive() external payable {}
1176 
1177     fallback() external payable {}
1178 }