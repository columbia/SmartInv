1 //             ((((((((((((((((((.                                             
2 //         ((((((((((((((((((((((((((*                                         
3 //      /(((((((((((((((((((((((((((((((*                                      
4 //     ((((((((((((#             #(((((((((                                    
5 //   (((((((((((                     ((((((((((((((((((((((,                   
6 //   ((((((((#         ((((((((((       (((((((((((((((((((((((((              
7 //  *(((((((       #(((((((((((((((((               /(((((((((((((((           
8 //  *((((((/     #((((((#        .((((((                 .((((((((((((.        
9 //   ((((((.    ((((((               #(((((((((((((#         (((((((((((       
10 //   ((((((/    ((((/                         .((((((((.      .((((((((((      
11 //   *((((((    ((((                              (((((((       ((((((((((     
12 //    ((((((,   ,(((.                               ((((((      .(((((((((     
13 //     ((((((    ((((                                (((((*      (((((((((     
14 //      ((((((    ((((                              ((((((      #(((((((((     
15 //       ((((((    #(((                            #(((((      ((((((((((      
16 //        ((((((/   .(((.                        ((((((,      ((((((((((       
17 //          ((((((    ((((                    (((((((       ((((((((((         
18 //           ((((((    /(((             ,((((((((        ((((((((((/           
19 //            /(((((#    ((((     ((((((((((         #(((((((((((              
20 //              ((((((    ((((((((((((          #((((((((((((*                 
21 //               ((((((/    ((,           (((((((((((((((                      
22 //                 ((((((          ,(((((((((((((((/                           
23 //                  ((((((*(((((((((((((((((((                                 
24 //                   ,(((((((((((((((((*                                       
25 //                     (((((((((,  
26 //           
27 // Killer GF by Zeronis and uwulabs                                  
28 // Made with love <3                                            
29 
30 
31 // SPDX-License-Identifier: MIT
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP.
37  */
38 interface IERC20 {
39     /**
40      * @dev Returns the amount of tokens in existence.
41      */
42     function totalSupply() external view returns (uint256);
43 
44     /**
45      * @dev Returns the amount of tokens owned by `account`.
46      */
47     function balanceOf(address account) external view returns (uint256);
48 
49     /**
50      * @dev Moves `amount` tokens from the caller's account to `recipient`.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a {Transfer} event.
55      */
56     function transfer(address recipient, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Returns the remaining number of tokens that `spender` will be
60      * allowed to spend on behalf of `owner` through {transferFrom}. This is
61      * zero by default.
62      *
63      * This value changes when {approve} or {transferFrom} are called.
64      */
65     function allowance(address owner, address spender) external view returns (uint256);
66 
67     /**
68      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * IMPORTANT: Beware that changing an allowance with this method brings the risk
73      * that someone may use both the old and the new allowance by unfortunate
74      * transaction ordering. One possible solution to mitigate this race
75      * condition is to first reduce the spender's allowance to 0 and set the
76      * desired value afterwards:
77      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
78      *
79      * Emits an {Approval} event.
80      */
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Moves `amount` tokens from `sender` to `recipient` using the
85      * allowance mechanism. `amount` is then deducted from the caller's
86      * allowance.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
93 
94     /**
95      * @dev Emitted when `value` tokens are moved from one account (`from`) to
96      * another (`to`).
97      *
98      * Note that `value` may be zero.
99      */
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 
102     /**
103      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
104      * a call to {approve}. `value` is the new allowance.
105      */
106     event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 
110 /**
111  * @dev Interface of the ERC165 standard, as defined in the
112  * https://eips.ethereum.org/EIPS/eip-165[EIP].
113  *
114  * Implementers can declare support of contract interfaces, which can then be
115  * queried by others ({ERC165Checker}).
116  *
117  * For an implementation, see {ERC165}.
118  */
119 interface IERC165 {
120     /**
121      * @dev Returns true if this contract implements the interface defined by
122      * `interfaceId`. See the corresponding
123      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
124      * to learn more about how these ids are created.
125      *
126      * This function call must use less than 30 000 gas.
127      */
128     function supportsInterface(bytes4 interfaceId) external view returns (bool);
129 }
130 
131 /**
132  * @dev Required interface of an ERC721 compliant contract.
133  */
134 interface IERC721Supply is IERC165 {
135     /**
136      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
137      */
138     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
139 
140     /**
141      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
142      */
143     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
144 
145     /**
146      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
147      */
148     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
149 
150     /**
151      * @dev Returns the total amount of tokens stored by the contract.
152      */
153     function totalSupply() external view returns (uint256);
154     
155     /**
156      * @dev Returns the number of tokens in ``owner``'s account.
157      */
158     function balanceOf(address owner) external view returns (uint256 balance);
159 
160     /**
161      * @dev Returns the owner of the `tokenId` token.
162      *
163      * Requirements:
164      *
165      * - `tokenId` must exist.
166      */
167     function ownerOf(uint256 tokenId) external view returns (address owner);
168 
169     /**
170      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
171      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
172      *
173      * Requirements:
174      *
175      * - `from` cannot be the zero address.
176      * - `to` cannot be the zero address.
177      * - `tokenId` token must exist and be owned by `from`.
178      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
179      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
180      *
181      * Emits a {Transfer} event.
182      */
183     function safeTransferFrom(
184         address from,
185         address to,
186         uint256 tokenId
187     ) external;
188 
189     /**
190      * @dev Transfers `tokenId` token from `from` to `to`.
191      *
192      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
193      *
194      * Requirements:
195      *
196      * - `from` cannot be the zero address.
197      * - `to` cannot be the zero address.
198      * - `tokenId` token must be owned by `from`.
199      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
200      *
201      * Emits a {Transfer} event.
202      */
203     function transferFrom(
204         address from,
205         address to,
206         uint256 tokenId
207     ) external;
208 
209     /**
210      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
211      * The approval is cleared when the token is transferred.
212      *
213      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
214      *
215      * Requirements:
216      *
217      * - The caller must own the token or be an approved operator.
218      * - `tokenId` must exist.
219      *
220      * Emits an {Approval} event.
221      */
222     function approve(address to, uint256 tokenId) external;
223 
224     /**
225      * @dev Returns the account approved for `tokenId` token.
226      *
227      * Requirements:
228      *
229      * - `tokenId` must exist.
230      */
231     function getApproved(uint256 tokenId) external view returns (address operator);
232 
233     /**
234      * @dev Approve or remove `operator` as an operator for the caller.
235      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
236      *
237      * Requirements:
238      *
239      * - The `operator` cannot be the caller.
240      *
241      * Emits an {ApprovalForAll} event.
242      */
243     function setApprovalForAll(address operator, bool _approved) external;
244 
245     /**
246      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
247      *
248      * See {setApprovalForAll}
249      */
250     function isApprovedForAll(address owner, address operator) external view returns (bool);
251 
252     /**
253      * @dev Safely transfers `tokenId` token from `from` to `to`.
254      *
255      * Requirements:
256      *
257      * - `from` cannot be the zero address.
258      * - `to` cannot be the zero address.
259      * - `tokenId` token must exist and be owned by `from`.
260      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
261      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
262      *
263      * Emits a {Transfer} event.
264      */
265     function safeTransferFrom(
266         address from,
267         address to,
268         uint256 tokenId,
269         bytes calldata data
270     ) external;
271 }
272 
273 /*
274  * @dev Provides information about the current execution context, including the
275  * sender of the transaction and its data. While these are generally available
276  * via msg.sender and msg.data, they should not be accessed in such a direct
277  * manner, since when dealing with meta-transactions the account sending and
278  * paying for execution may not be the actual sender (as far as an application
279  * is concerned).
280  *
281  * This contract is only required for intermediate, library-like contracts.
282  */
283 abstract contract Context {
284     function _msgSender() internal view virtual returns (address) {
285         return msg.sender;
286     }
287 
288     function _msgData() internal view virtual returns (bytes calldata) {
289         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
290         return msg.data;
291     }
292 }
293 
294 /**
295  * @dev Contract module which provides a basic access control mechanism, where
296  * there is an account (an owner) that can be granted exclusive access to
297  * specific functions.
298  *
299  * By default, the owner account will be the one that deploys the contract. This
300  * can later be changed with {transferOwnership}.
301  *
302  * This module is used through inheritance. It will make available the modifier
303  * `onlyOwner`, which can be applied to your functions to restrict their use to
304  * the owner.
305  */
306 abstract contract Ownable is Context {
307     address private _owner;
308 
309     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
310 
311     /**
312      * @dev Initializes the contract setting the deployer as the initial owner.
313      */
314     constructor() {
315         address msgSender = _msgSender();
316         _owner = msgSender;
317         emit OwnershipTransferred(address(0), msgSender);
318     }
319 
320     /**
321      * @dev Returns the address of the current owner.
322      */
323     function owner() public view virtual returns (address) {
324         return _owner;
325     }
326 
327     /**
328      * @dev Throws if called by any account other than the owner.
329      */
330     modifier onlyOwner() {
331         require(owner() == _msgSender(), "Ownable: caller is not the owner");
332         _;
333     }
334 
335     /**
336      * @dev Leaves the contract without owner. It will not be possible to call
337      * `onlyOwner` functions anymore. Can only be called by the current owner.
338      *
339      * NOTE: Renouncing ownership will leave the contract without an owner,
340      * thereby removing any functionality that is only available to the owner.
341      */
342     function renounceOwnership() public virtual onlyOwner {
343         emit OwnershipTransferred(_owner, address(0));
344         _owner = address(0);
345     }
346 
347     /**
348      * @dev Transfers ownership of the contract to a new account (`newOwner`).
349      * Can only be called by the current owner.
350      */
351     function transferOwnership(address newOwner) public virtual onlyOwner {
352         require(newOwner != address(0), "Ownable: new owner is the zero address");
353         emit OwnershipTransferred(_owner, newOwner);
354         _owner = newOwner;
355     }
356 }
357 
358 /**
359  * @dev Contract module that helps prevent reentrant calls to a function.
360  *
361  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
362  * available, which can be applied to functions to make sure there are no nested
363  * (reentrant) calls to them.
364  *
365  * Note that because there is a single `nonReentrant` guard, functions marked as
366  * `nonReentrant` may not call one another. This can be worked around by making
367  * those functions `private`, and then adding `external` `nonReentrant` entry
368  * points to them.
369  *
370  * TIP: If you would like to learn more about reentrancy and alternative ways
371  * to protect against it, check out our blog post
372  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
373  */
374 abstract contract ReentrancyGuard {
375     // Booleans are more expensive than uint256 or any type that takes up a full
376     // word because each write operation emits an extra SLOAD to first read the
377     // slot's contents, replace the bits taken up by the boolean, and then write
378     // back. This is the compiler's defense against contract upgrades and
379     // pointer aliasing, and it cannot be disabled.
380 
381     // The values being non-zero value makes deployment a bit more expensive,
382     // but in exchange the refund on every call to nonReentrant will be lower in
383     // amount. Since refunds are capped to a percentage of the total
384     // transaction's gas, it is best to keep them low in cases like this one, to
385     // increase the likelihood of the full refund coming into effect.
386     uint256 private constant _NOT_ENTERED = 1;
387     uint256 private constant _ENTERED = 2;
388 
389     uint256 private _status;
390 
391     constructor() {
392         _status = _NOT_ENTERED;
393     }
394 
395     /**
396      * @dev Prevents a contract from calling itself, directly or indirectly.
397      * Calling a `nonReentrant` function from another `nonReentrant`
398      * function is not supported. It is possible to prevent this from happening
399      * by making the `nonReentrant` function external, and make it call a
400      * `private` function that does the actual work.
401      */
402     modifier nonReentrant() {
403         // On the first call to nonReentrant, _notEntered will be true
404         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
405 
406         // Any calls to nonReentrant after this point will fail
407         _status = _ENTERED;
408 
409         _;
410 
411         // By storing the original value once again, a refund is triggered (see
412         // https://eips.ethereum.org/EIPS/eip-2200)
413         _status = _NOT_ENTERED;
414     }
415 }
416 
417 /**
418  * @dev These functions deal with verification of Merkle Trees proofs.
419  *
420  * The proofs can be generated using the JavaScript library
421  * https://github.com/miguelmota/merkletreejs[merkletreejs].
422  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
423  *
424  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
425  */
426 library MerkleProof {
427     /**
428      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
429      * defined by `root`. For this, a `proof` must be provided, containing
430      * sibling hashes on the branch from the leaf to the root of the tree. Each
431      * pair of leaves and each pair of pre-images are assumed to be sorted.
432      */
433     function verify(
434         bytes32[] memory proof,
435         bytes32 root,
436         bytes32 leaf
437     ) internal pure returns (bool) {
438         bytes32 computedHash = leaf;
439 
440         for (uint256 i = 0; i < proof.length; i++) {
441             bytes32 proofElement = proof[i];
442 
443             if (computedHash <= proofElement) {
444                 // Hash(current computed hash + current element of the proof)
445                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
446             } else {
447                 // Hash(current element of the proof + current computed hash)
448                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
449             }
450         }
451 
452         // Check if the computed hash (root) is equal to the provided root
453         return computedHash == root;
454     }
455 }
456 
457 interface Minter {
458   function MAX_SUPPLY() external returns (uint256);
459   function mintNFTs(address to, uint256[] memory tokenId) external;
460   function owner() external returns (address);
461 }
462 
463 contract KillerGFWaveLockSale is Ownable, ReentrancyGuard {
464   uint256 constant BASE = 1e18;
465 
466   uint256 constant TEAM_INDEX = 0;
467   uint256 constant UWULIST_INDEX = 1;
468   uint256 constant WHITELIST_INDEX = 2;
469 
470   uint256 constant SLOT_COUNT = 256/32;
471   uint256 constant MAX_WAVES = 6;
472   uint256 constant PRESALE_SLOT_INDEX = 0;
473   uint256 constant MINTED_SLOT_INDEX = 6;
474   uint256 constant BALANCE_SLOT_INDEX = 7;
475   
476   bytes32 public teamRoot;
477   bytes32 public uwuRoot;
478   bytes32 public whitelistRoot;
479 
480   address public nft; 
481   uint256 public amountForSale;
482   uint256 public amountSold;
483   uint256 public devSupply;
484   uint256 public devMinted;
485 
486   uint64 public teamMinted;
487   uint64 public uwuMinted;
488   uint64 public whitelistMinted;
489 
490   uint256 public buyPrice = 0.08 ether;
491   uint256 public uwuPrice = 0.065 ether;
492   
493   uint256 public startTime = type(uint256).max;
494   uint256 public constant waveTimeLength = 5 minutes;
495 
496   // Purchases are compressed into a single uint256, after 6 rounds the limit is simply removed anyways.
497   // The last uint32 slot is reserved for their balance. (left-most bytes first)
498   mapping(address => uint256) purchases;
499 
500   event Reserved(address sender, uint256 count);
501   event Minted(address sender, uint256 count);
502 
503   constructor(address _nft, address _owner, uint256 _startTime, uint256 saleCount, uint256 _ownerCount) Ownable() ReentrancyGuard() {
504     require(_startTime != 0, "No start time");
505     nft = _nft;
506     startTime = _startTime;
507     amountForSale = saleCount;
508     devSupply = _ownerCount;
509     transferOwnership(_owner);
510   }
511 
512   function withdrawETH() external onlyOwner {
513     uint256 fullAmount = address(this).balance;
514     sendValue(payable(msg.sender), fullAmount*700/1000);
515     sendValue(payable(0x354A70969F0b4a4C994403051A81C2ca45db3615), address(this).balance);
516   }
517 
518   function setStartTime(uint256 _startTime) external onlyOwner {
519     startTime = _startTime;
520   }
521 
522   function setPresaleRoots(bytes32 _whitelistRoot, bytes32 _uwulistRoot, bytes32 _teamRoot) external onlyOwner {
523     whitelistRoot = _whitelistRoot;
524     uwuRoot = _uwulistRoot;
525     teamRoot = _teamRoot;
526   }
527 
528   function setNFT(address _nft) external onlyOwner {
529     nft = _nft;
530   }
531   
532   function devMint(uint256 count) public onlyOwner {
533     devMintTo(msg.sender, count);
534   }
535 
536   function devMintTo(address to, uint256 count) public onlyOwner {
537     uint256 _devMinted = devMinted;
538     uint256 remaining = devSupply - _devMinted;
539     require(remaining != 0, "No more dev minted");
540     if (count > remaining) {
541       count = remaining;
542     } 
543     devMinted = _devMinted + count;
544 
545     uint256[] memory ids = new uint256[](count);
546     for (uint256 i; i < count; ++i) {
547       ids[i] = _devMinted+i+1;
548     }
549     Minter(nft).mintNFTs(to, ids);
550   }
551   
552   function presaleBuy(uint256[3] calldata amountsToBuy, uint256[3] calldata amounts, uint256[3] calldata indexes, bytes32[][3] calldata merkleProof) external payable { 
553     require(block.timestamp < startTime, "Presale has ended");
554     require(amountsToBuy.length == 3, "Not right length");
555     require(amountsToBuy.length == amounts.length, "Not equal amounts");
556     require(amounts.length == indexes.length, "Not equal indexes");
557     require(indexes.length == merkleProof.length, "Not equal proof");
558 
559     uint256 purchaseInfo = purchases[msg.sender];
560     require(!hasDoneWave(purchaseInfo, PRESALE_SLOT_INDEX), "Already whitelist minted");
561 
562     uint256 expectedPayment;
563     if (merkleProof[UWULIST_INDEX].length != 0) {
564       expectedPayment += amountsToBuy[UWULIST_INDEX]*uwuPrice;
565     }
566     if (merkleProof[WHITELIST_INDEX].length != 0) {
567       expectedPayment += amountsToBuy[WHITELIST_INDEX]*buyPrice;
568     } 
569     require(msg.value == expectedPayment, "Not right ETH sent");
570 
571     uint256 count;
572     if (merkleProof[TEAM_INDEX].length != 0) {
573       require(teamRoot.length != 0, "team root not assigned");
574       bytes32 node = keccak256(abi.encodePacked(indexes[TEAM_INDEX], msg.sender, amounts[TEAM_INDEX]));
575       require(MerkleProof.verify(merkleProof[TEAM_INDEX], teamRoot, node), 'MerkleProof: Invalid team proof.');
576       require(amountsToBuy[TEAM_INDEX] <= amounts[TEAM_INDEX], "Cant buy this many");
577       count += amountsToBuy[TEAM_INDEX];
578       teamMinted += uint64(amountsToBuy[TEAM_INDEX]);
579     }
580     if (merkleProof[UWULIST_INDEX].length != 0) {
581       require(uwuRoot.length != 0, "uwu root not assigned");
582       bytes32 node = keccak256(abi.encodePacked(indexes[UWULIST_INDEX], msg.sender, amounts[UWULIST_INDEX]));
583       require(MerkleProof.verify(merkleProof[UWULIST_INDEX], uwuRoot, node), 'MerkleProof: Invalid uwu proof.');
584       require(amountsToBuy[UWULIST_INDEX] <= amounts[UWULIST_INDEX], "Cant buy this many");
585       count += amountsToBuy[UWULIST_INDEX];
586       uwuMinted += uint64(amountsToBuy[UWULIST_INDEX]);
587     }
588     if (merkleProof[WHITELIST_INDEX].length != 0) {
589       require(whitelistRoot.length != 0, "wl root not assigned");
590       bytes32 node = keccak256(abi.encodePacked(indexes[WHITELIST_INDEX], msg.sender, amounts[WHITELIST_INDEX]));
591       require(MerkleProof.verify(merkleProof[WHITELIST_INDEX], whitelistRoot, node), 'MerkleProof: Invalid wl proof.');
592       require(amountsToBuy[WHITELIST_INDEX] <= amounts[WHITELIST_INDEX], "Cant buy this many");
593       count += amountsToBuy[WHITELIST_INDEX];
594       whitelistMinted += uint64(amountsToBuy[WHITELIST_INDEX]);
595     }  
596 
597     uint256 startSupply = currentMintIndex();
598     uint256 _amountSold = amountSold;
599     amountSold = _amountSold + count;
600     purchases[msg.sender] = _createNewPurchaseInfo(purchaseInfo, PRESALE_SLOT_INDEX, startSupply, count);
601 
602     emit Reserved(msg.sender, count);
603   }
604 
605   /*
606    * DM TylerTakesATrip#9279 he looks submissive and breedable.
607    */
608   function buyKGF(uint256 count) external payable nonReentrant {
609     uint256 _amountSold = amountSold;
610     uint256 _amountForSale = amountForSale;
611     uint256 remaining = _amountForSale - _amountSold;
612     require(remaining != 0, "Sold out! Sorry!");
613 
614     require(block.timestamp >= startTime, "Sale has not started");
615     require(tx.origin == msg.sender, "Only direct calls pls");
616     require(count > 0, "Cannot mint 0");
617 
618     uint256 wave = currentWave();
619     require(count <= maxPerTX(wave), "Max for TX in this wave");
620     require(wave < MAX_WAVES, "Not in main sale");
621     require(msg.value == count * buyPrice, "Not enough ETH");
622 
623     // Adjust for the last mint being incomplete.
624     uint256 ethAmountOwed;
625     if (count > remaining) {
626       ethAmountOwed = buyPrice * (count - remaining);
627       count = remaining;
628     }
629 
630     uint256 purchaseInfo = purchases[msg.sender];
631     require(!hasDoneWave(purchaseInfo, wave), "Already purchased this wave");
632 
633     uint256 startSupply = currentMintIndex();
634     amountSold = _amountSold + count;
635     purchases[msg.sender] = _createNewPurchaseInfo(purchaseInfo, wave, startSupply, count);
636     
637     emit Reserved(msg.sender, count);
638 
639     if (ethAmountOwed > 0) {
640       sendValue(payable(msg.sender), ethAmountOwed);
641     }
642   }
643 
644   // just mint, no tickets
645   // There is not enough demand if the sale is still incomplete at this point.  
646   // So just resort to a normal sale. 
647   function buyKGFPostSale(uint256 count) external payable {
648     uint256 _amountSold = amountSold;
649     uint256 _amountForSale = amountForSale;
650     uint256 remaining = _amountForSale - _amountSold;
651     require(remaining != 0, "Sold out! Sorry!");
652     require(block.timestamp >= startTime, "Sale has not started");
653 
654     require(count > 0, "Cannot mint 0");
655     require(count <= remaining, "Just out");
656     require(tx.origin == msg.sender, "Only direct calls pls");
657     require(msg.value == count * buyPrice, "Not enough ETH");
658 
659     uint256 wave = currentWave();
660     require(count <= maxPerTX(wave), "Max for TX in this wave");
661     require(wave >= MAX_WAVES, "Not in post sale");
662 
663     uint256 startSupply = currentMintIndex();
664     amountSold = _amountSold + count;
665     uint256[] memory ids = new uint256[](count);
666     for (uint256 i; i < count; ++i) {
667       ids[i] = startSupply + i;
668     }
669     Minter(nft).mintNFTs(msg.sender, ids);
670   }
671 
672   function mint(uint256 count) external nonReentrant {
673     _mintFor(msg.sender, count, msg.sender);
674   }
675 
676   function devMintFrom(address from, uint256 count) public onlyOwner {
677     require(block.timestamp > startTime + 3 days, "Too soon");
678     _mintFor(from, count, msg.sender);
679   }
680 
681   function devMintsFrom(address[] calldata froms, uint256[] calldata counts) public onlyOwner {
682     for (uint256 i; i < froms.length; ++i) {
683       devMintFrom(froms[i], counts[i]);
684     }
685   }
686 
687   function _mintFor(address account, uint256 count, address to) internal {
688     require(count > 0, "0?");
689     require(block.timestamp >= startTime, "Can only mint after the sale has begun");
690 
691     uint256 purchaseInfo = purchases[account];
692     uint256 _mintedBalance =_getSlot(purchaseInfo, MINTED_SLOT_INDEX);
693     uint256[] memory ids = _allIdsPurchased(purchaseInfo);
694     require(count <= ids.length-_mintedBalance, "Not enough balance");
695 
696     uint256 newMintedBalance = _mintedBalance + count;
697     purchases[account] = _writeDataSlot(purchaseInfo, MINTED_SLOT_INDEX, newMintedBalance);
698 
699     uint256[] memory mintableIds = new uint256[](count);
700     for (uint256 i; i < count; ++i) {
701       mintableIds[i] = ids[_mintedBalance+i];
702     }
703 
704     // Mint to the owner.
705     Minter(nft).mintNFTs(to, mintableIds);
706     
707     emit Minted(account, count);
708   }
709 
710   function wavePurchaseInfo(uint256 wave, address who) external view returns (uint256, uint256) {
711     uint256 cache = purchases[who];
712     return _getInfo(cache, wave);
713   }
714 
715   function currentMaxPerTX() external view returns (uint256) {
716     return maxPerTX(currentWave());
717   } 
718 
719   function allIdsPurchasedBy(address who) external view returns (uint256[] memory) {
720     uint256 cache = purchases[who];
721     return _allIdsPurchased(cache);
722   } 
723   
724   function mintedBalance(address who) external view returns (uint256) {
725     uint256 cache = purchases[who];
726     uint256 _mintedBalance =_getSlot(cache, MINTED_SLOT_INDEX);
727     return _mintedBalance;
728   }
729 
730   function currentWave() public view returns (uint256) {
731     if (block.timestamp < startTime) {
732       return 0;
733     }
734     uint256 timeSinceStart = block.timestamp - startTime;
735     uint256 _currentWave = timeSinceStart/waveTimeLength;
736     return _currentWave;
737   }
738 
739   function currentMintIndex() public view returns (uint256) {
740     return amountSold + devSupply + 1;
741   }
742 
743   function maxPerTX(uint256 _wave) public pure returns (uint256) {
744     if (_wave == 0) {
745       return 1;
746     } else if (_wave == 1) {
747       return 2;
748     } else if (_wave == 2) {
749       return 4;
750     } else {
751       return 8;
752     }
753   }
754 
755   function hasDoneWave(uint256 purchaseInfo, uint256 wave) public pure returns (bool) {
756     uint256 slot = _getSlot(purchaseInfo, wave);
757     return slot != 0;
758   }
759 
760   function balanceOf(address who) public view returns (uint256) {
761     uint256 cache = purchases[who];
762     uint256 currentBalance = _getSlot(cache, BALANCE_SLOT_INDEX);
763     uint256 _mintedBalance = _getSlot(cache, MINTED_SLOT_INDEX);
764     return currentBalance-_mintedBalance;
765   }
766 
767   function _createNewPurchaseInfo(uint256 purchaseInfo, uint256 wave, uint256 _startingSupply, uint256 count) internal pure returns (uint256) {
768     require(wave < MAX_WAVES, "Not a wave index");
769     uint256 purchase = _startingSupply<<8;
770     purchase |= count;
771     uint256 newWaveSlot = _writeWaveSlot(purchaseInfo, wave, purchase);
772     uint256 newBalance = _getBalance(purchaseInfo) + count;
773     return _writeDataSlot(newWaveSlot, BALANCE_SLOT_INDEX, newBalance);
774   }
775 
776   function _allIdsPurchased(uint256 purchaseInfo) internal pure returns (uint256[] memory) {
777     uint256 currentBalance = _getBalance(purchaseInfo);
778     if (currentBalance == 0) {
779       uint256[] memory empty;
780       return empty;
781     }
782 
783     uint256[] memory ids = new uint256[](currentBalance);
784 
785     uint256 index;
786     for (uint256 wave; wave < MAX_WAVES; ++wave) {
787       (uint256 supply, uint256 count) = _getInfo(purchaseInfo, wave);
788       if (count == 0)
789         continue;
790       for (uint256 i; i < count; ++i) {
791         ids[index] = supply + i;
792         ++index;
793       }
794     }
795     require(index == ids.length, "not all");
796 
797     return ids;
798   }
799 
800   function _getInfo(uint256 purchaseInfo, uint256 wave) internal pure returns (uint256, uint256) {
801     require(wave < MAX_WAVES, "Not a wave index");
802     uint256 slot = _getSlot(purchaseInfo, wave);
803     uint256 supply = slot>>8;
804     uint256 count = uint256(uint8(slot));
805     return (supply, count);
806   } 
807 
808   function _getBalance(uint256 purchaseInfo) internal pure returns (uint256) {
809     return _getSlot(purchaseInfo, BALANCE_SLOT_INDEX);
810   }
811 
812   function _writeWaveSlot(uint256 purchase, uint256 index, uint256 data) internal pure returns (uint256) {
813     require(index < MAX_WAVES, "not valid index");
814     uint256 writeIndex = 256 - ((index+1) * 32);
815     require(uint32(purchase<<writeIndex) == 0, "Cannot write in wave slot twice");
816     uint256 newSlot = data<<writeIndex;
817     uint256 newPurchase = purchase | newSlot;
818     return newPurchase;
819   }
820 
821   function _writeDataSlot(uint256 purchase, uint256 index, uint256 data) internal pure returns (uint256) {
822     require(index == MINTED_SLOT_INDEX || index == BALANCE_SLOT_INDEX, "not valid index");
823     uint256 writeIndex = 256 - ((index+1) * 32);
824     uint256 newSlot = uint256(uint32(data))<<writeIndex;
825     uint256 newPurchase = purchase>>(writeIndex+32)<<(writeIndex+32);
826     if (index == MINTED_SLOT_INDEX) 
827       newPurchase |= _getSlot(purchase, BALANCE_SLOT_INDEX);
828     newPurchase |= newSlot;
829     return newPurchase;
830   }
831 
832   function _getSlot(uint256 purchase, uint256 index) internal pure returns (uint256) {
833     require(index < SLOT_COUNT, "not valid index");
834     uint256 writeIndex = 256 - ((index+1) * 32);
835     uint256 slot = uint32(purchase>>writeIndex);
836     return slot;
837   }
838 
839   function sendValue(address payable recipient, uint256 amount) internal {
840     require(address(this).balance >= amount, "Address: insufficient balance");
841 
842     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
843     (bool success, ) = recipient.call{ value: amount }("");
844     require(success, "Address: unable to send value, recipient may have reverted");
845   }
846 }