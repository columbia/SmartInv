1 /**
2  *Submitted for verification at Etherscan.io on 2021-12-29
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 // CAUTION
11 // This version of SafeMath should only be used with Solidity 0.8 or later,
12 // because it relies on the compiler's built in overflow checks.
13 
14 /**
15  * @dev Wrappers over Solidity's arithmetic operations.
16  *
17  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
18  * now has built in overflow checking.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, with an overflow flag.
23      *
24      * _Available since v3.4._
25      */
26     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
27         unchecked {
28             uint256 c = a + b;
29             if (c < a) return (false, 0);
30             return (true, c);
31         }
32     }
33 
34     /**
35      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
36      *
37      * _Available since v3.4._
38      */
39     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         unchecked {
41             if (b > a) return (false, 0);
42             return (true, a - b);
43         }
44     }
45 
46     /**
47      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
48      *
49      * _Available since v3.4._
50      */
51     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
52         unchecked {
53             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
54             // benefit is lost if 'b' is also tested.
55             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
56             if (a == 0) return (true, 0);
57             uint256 c = a * b;
58             if (c / a != b) return (false, 0);
59             return (true, c);
60         }
61     }
62 
63     /**
64      * @dev Returns the division of two unsigned integers, with a division by zero flag.
65      *
66      * _Available since v3.4._
67      */
68     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
69         unchecked {
70             if (b == 0) return (false, 0);
71             return (true, a / b);
72         }
73     }
74 
75     /**
76      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
77      *
78      * _Available since v3.4._
79      */
80     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
81         unchecked {
82             if (b == 0) return (false, 0);
83             return (true, a % b);
84         }
85     }
86 
87     /**
88      * @dev Returns the addition of two unsigned integers, reverting on
89      * overflow.
90      *
91      * Counterpart to Solidity's `+` operator.
92      *
93      * Requirements:
94      *
95      * - Addition cannot overflow.
96      */
97     function add(uint256 a, uint256 b) internal pure returns (uint256) {
98         return a + b;
99     }
100 
101     /**
102      * @dev Returns the subtraction of two unsigned integers, reverting on
103      * overflow (when the result is negative).
104      *
105      * Counterpart to Solidity's `-` operator.
106      *
107      * Requirements:
108      *
109      * - Subtraction cannot overflow.
110      */
111     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112         return a - b;
113     }
114 
115     /**
116      * @dev Returns the multiplication of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's `*` operator.
120      *
121      * Requirements:
122      *
123      * - Multiplication cannot overflow.
124      */
125     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126         return a * b;
127     }
128 
129     /**
130      * @dev Returns the integer division of two unsigned integers, reverting on
131      * division by zero. The result is rounded towards zero.
132      *
133      * Counterpart to Solidity's `/` operator.
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function div(uint256 a, uint256 b) internal pure returns (uint256) {
140         return a / b;
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * reverting when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
156         return a % b;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * CAUTION: This function is deprecated because it requires allocating memory for the error
164      * message unnecessarily. For custom revert reasons use {trySub}.
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(
173         uint256 a,
174         uint256 b,
175         string memory errorMessage
176     ) internal pure returns (uint256) {
177         unchecked {
178             require(b <= a, errorMessage);
179             return a - b;
180         }
181     }
182 
183     /**
184      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
185      * division by zero. The result is rounded towards zero.
186      *
187      * Counterpart to Solidity's `/` operator. Note: this function uses a
188      * `revert` opcode (which leaves remaining gas untouched) while Solidity
189      * uses an invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      *
193      * - The divisor cannot be zero.
194      */
195     function div(
196         uint256 a,
197         uint256 b,
198         string memory errorMessage
199     ) internal pure returns (uint256) {
200         unchecked {
201             require(b > 0, errorMessage);
202             return a / b;
203         }
204     }
205 
206     /**
207      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
208      * reverting with custom message when dividing by zero.
209      *
210      * CAUTION: This function is deprecated because it requires allocating memory for the error
211      * message unnecessarily. For custom revert reasons use {tryMod}.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function mod(
222         uint256 a,
223         uint256 b,
224         string memory errorMessage
225     ) internal pure returns (uint256) {
226         unchecked {
227             require(b > 0, errorMessage);
228             return a % b;
229         }
230     }
231 }
232 
233 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
234 
235 pragma solidity ^0.8.0;
236 
237 /**
238  * @dev Provides information about the current execution context, including the
239  * sender of the transaction and its data. While these are generally available
240  * via msg.sender and msg.data, they should not be accessed in such a direct
241  * manner, since when dealing with meta-transactions the account sending and
242  * paying for execution may not be the actual sender (as far as an application
243  * is concerned).
244  *
245  * This contract is only required for intermediate, library-like contracts.
246  */
247 abstract contract Context {
248     function _msgSender() internal view virtual returns (address) {
249         return msg.sender;
250     }
251 
252     function _msgData() internal view virtual returns (bytes calldata) {
253         return msg.data;
254     }
255 }
256 
257 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
258 
259 pragma solidity ^0.8.0;
260 
261 
262 /**
263  * @dev Contract module which provides a basic access control mechanism, where
264  * there is an account (an owner) that can be granted exclusive access to
265  * specific functions.
266  *
267  * By default, the owner account will be the one that deploys the contract. This
268  * can later be changed with {transferOwnership}.
269  *
270  * This module is used through inheritance. It will make available the modifier
271  * `onlyOwner`, which can be applied to your functions to restrict their use to
272  * the owner.
273  */
274 abstract contract Ownable is Context {
275     address private _owner;
276 
277     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
278 
279     /**
280      * @dev Initializes the contract setting the deployer as the initial owner.
281      */
282     constructor() {
283         _transferOwnership(_msgSender());
284     }
285 
286     /**
287      * @dev Returns the address of the current owner.
288      */
289     function owner() public view virtual returns (address) {
290         return _owner;
291     }
292 
293     /**
294      * @dev Throws if called by any account other than the owner.
295      */
296     modifier onlyOwner() {
297         require(owner() == _msgSender(), "Ownable: caller is not the owner");
298         _;
299     }
300 
301     /**
302      * @dev Leaves the contract without owner. It will not be possible to call
303      * `onlyOwner` functions anymore. Can only be called by the current owner.
304      *
305      * NOTE: Renouncing ownership will leave the contract without an owner,
306      * thereby removing any functionality that is only available to the owner.
307      */
308     function renounceOwnership() public virtual onlyOwner {
309         _transferOwnership(address(0));
310     }
311 
312     /**
313      * @dev Transfers ownership of the contract to a new account (`newOwner`).
314      * Can only be called by the current owner.
315      */
316     function transferOwnership(address newOwner) public virtual onlyOwner {
317         require(newOwner != address(0), "Ownable: new owner is the zero address");
318         _transferOwnership(newOwner);
319     }
320 
321     /**
322      * @dev Transfers ownership of the contract to a new account (`newOwner`).
323      * Internal function without access restriction.
324      */
325     function _transferOwnership(address newOwner) internal virtual {
326         address oldOwner = _owner;
327         _owner = newOwner;
328         emit OwnershipTransferred(oldOwner, newOwner);
329     }
330 
331 }
332 
333 
334 pragma solidity ^0.8.0;
335 
336 /**
337  * @title ERC721 token receiver interface
338  * @dev Interface for any contract that wants to support safeTransfers
339  * from ERC721 asset contracts.
340  */
341 interface IERC721Receiver {
342     /**
343      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
344      * by `operator` from `from`, this function is called.
345      *
346      * It must return its Solidity selector to confirm the token transfer.
347      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
348      *
349      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
350      */
351     function onERC721Received(
352         address operator,
353         address from,
354         uint256 tokenId,
355         bytes calldata data
356     ) external returns (bytes4);
357 }
358 
359 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
360 
361 pragma solidity ^0.8.0;
362 
363 /**
364  * @dev Interface of the ERC165 standard, as defined in the
365  * https://eips.ethereum.org/EIPS/eip-165[EIP].
366  *
367  * Implementers can declare support of contract interfaces, which can then be
368  * queried by others ({ERC165Checker}).
369  *
370  * For an implementation, see {ERC165}.
371  */
372 interface IERC165 {
373     /**
374      * @dev Returns true if this contract implements the interface defined by
375      * `interfaceId`. See the corresponding
376      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
377      * to learn more about how these ids are created.
378      *
379      * This function call must use less than 30 000 gas.
380      */
381     function supportsInterface(bytes4 interfaceId) external view returns (bool);
382 }
383 
384 
385 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
386 
387 pragma solidity ^0.8.0;
388 
389 
390 /**
391  * @dev Required interface of an ERC721 compliant contract.
392  */
393 interface IERC721 is IERC165 {
394     /**
395      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
396      */
397     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
398 
399     /**
400      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
401      */
402     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
403 
404     /**
405      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
406      */
407     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
408 
409     /**
410      * @dev Returns the number of tokens in ``owner``'s account.
411      */
412     function balanceOf(address owner) external view returns (uint256 balance);
413 
414     /**
415      * @dev Returns the owner of the `tokenId` token.
416      *
417      * Requirements:
418      *
419      * - `tokenId` must exist.
420      */
421     function ownerOf(uint256 tokenId) external view returns (address owner);
422 
423     /**
424      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
425      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
426      *
427      * Requirements:
428      *
429      * - `from` cannot be the zero address.
430      * - `to` cannot be the zero address.
431      * - `tokenId` token must exist and be owned by `from`.
432      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
433      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
434      *
435      * Emits a {Transfer} event.
436      */
437     function safeTransferFrom(
438         address from,
439         address to,
440         uint256 tokenId
441     ) external;
442 
443     /**
444      * @dev Transfers `tokenId` token from `from` to `to`.
445      *
446      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
447      *
448      * Requirements:
449      *
450      * - `from` cannot be the zero address.
451      * - `to` cannot be the zero address.
452      * - `tokenId` token must be owned by `from`.
453      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
454      *
455      * Emits a {Transfer} event.
456      */
457     function transferFrom(
458         address from,
459         address to,
460         uint256 tokenId
461     ) external;
462 
463     /**
464      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
465      * The approval is cleared when the token is transferred.
466      *
467      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
468      *
469      * Requirements:
470      *
471      * - The caller must own the token or be an approved operator.
472      * - `tokenId` must exist.
473      *
474      * Emits an {Approval} event.
475      */
476     function approve(address to, uint256 tokenId) external;
477 
478     /**
479      * @dev Returns the account approved for `tokenId` token.
480      *
481      * Requirements:
482      *
483      * - `tokenId` must exist.
484      */
485     function getApproved(uint256 tokenId) external view returns (address operator);
486 
487     /**
488      * @dev Approve or remove `operator` as an operator for the caller.
489      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
490      *
491      * Requirements:
492      *
493      * - The `operator` cannot be the caller.
494      *
495      * Emits an {ApprovalForAll} event.
496      */
497     function setApprovalForAll(address operator, bool _approved) external;
498 
499     /**
500      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
501      *
502      * See {setApprovalForAll}
503      */
504     function isApprovedForAll(address owner, address operator) external view returns (bool);
505 
506     /**
507      * @dev Safely transfers `tokenId` token from `from` to `to`.
508      *
509      * Requirements:
510      *
511      * - `from` cannot be the zero address.
512      * - `to` cannot be the zero address.
513      * - `tokenId` token must exist and be owned by `from`.
514      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
515      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
516      *
517      * Emits a {Transfer} event.
518      */
519     function safeTransferFrom(
520         address from,
521         address to,
522         uint256 tokenId,
523         bytes calldata data
524     ) external;
525 }
526 
527 contract KnightStaking is IERC721Receiver, Ownable {
528   using SafeMath for uint256;
529   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
530 
531   event RewardAdded(uint256 time, uint256 rewardAmount);
532   event RewardClaimed(uint256 tokenID, address owner);
533 
534   event Staked(address staker, uint256 tokenID, uint256 stakedTime);
535   event UnStaked(uint256 tokenID, uint256 unstakedTime);
536 
537   /*
538   Used to store the information of the Staked NFT.
539   */
540   struct StakedNFT{
541     uint256 startTime;
542     uint256 claimableReward;
543     address staker;
544     bool isStaked;
545     uint256 lastClaims;
546   }
547 
548   //staked tokenID list 
549   uint256[] public stakedNFTs;
550   //maps tokenID => Staked NFT
551   mapping(uint256 => StakedNFT) public stakedInfo;
552   //nft address
553   address public nft;
554 
555   constructor(address _nft){
556     nft = _nft;
557   }
558 
559   /*
560   Handle the eth receive function 
561   */
562   receive() external payable{
563     addReward();
564   }
565 
566   // reward = ( YourNFTStakedTime / TotalNFTStakedTime ) * AmountDistributed 
567   function addReward() public payable{
568     if(msg.value>0){
569         //perform distribution
570         uint256 totalTime = 0;
571         for(uint256 i=0; i < stakedNFTs.length ; i++){
572             StakedNFT memory staked = stakedInfo[stakedNFTs[i]];
573             totalTime += block.timestamp.sub(staked.startTime);
574         }
575         for(uint256 i=0; i< stakedNFTs.length; i++){
576             StakedNFT storage _stakedInfo = stakedInfo[stakedNFTs[i]];
577             uint256 timeSpan = block.timestamp.sub(_stakedInfo.startTime);
578             uint256 reward = timeSpan.mul(msg.value).div(totalTime);
579             _stakedInfo.startTime = block.timestamp;
580             _stakedInfo.claimableReward = reward; 
581         }
582         emit RewardAdded(block.timestamp, msg.value);
583     }
584    
585   }
586 
587   function batchStakeNFT(uint256[] memory tokenIDs) external{
588       uint256 tokenID = 0;
589       for(uint256 i=0; i<tokenIDs.length; i++){
590          tokenID = tokenIDs[i];
591          require(IERC721(nft).ownerOf(tokenID)==msg.sender, "Staking: Not the NFT owner!");
592          require(IERC721(nft).isApprovedForAll(msg.sender, address(this)), "Staking:Staking contract not set as operator!");
593         IERC721(nft).safeTransferFrom(msg.sender, address(this), tokenID);
594         _stakeNFT(tokenID);
595       }
596   }
597 
598   function stakeNFT(uint256 tokenID) public {
599     require(IERC721(nft).ownerOf(tokenID)==msg.sender, "Staking: Not the NFT owner!");
600     require(
601         address(this) == IERC721(nft).getApproved(tokenID) || IERC721(nft).isApprovedForAll(msg.sender, address(this)), 
602         "Staking: NFT not approved for the staking address OR Staking contract not set as operator!"
603     );
604     IERC721(nft).safeTransferFrom(msg.sender, address(this), tokenID);
605     _stakeNFT(tokenID);
606   }
607 
608   function _stakeNFT(uint256 _tokenID) internal{
609     stakedNFTs.push(_tokenID);
610 
611     if(hasNFTData(_tokenID)){
612       StakedNFT storage stakedNFT = stakedInfo[_tokenID];
613       require(!stakedNFT.isStaked, "Staking: NFT already staked!");
614       stakedNFT.staker = msg.sender;
615       stakedNFT.startTime = block.timestamp;
616       stakedNFT.isStaked = true;
617     }
618     else{
619       StakedNFT memory stakedNFT = StakedNFT({
620         startTime: block.timestamp,
621         claimableReward: 0,
622         staker: msg.sender,
623         isStaked: true,
624         lastClaims: 0
625       });
626       stakedInfo[_tokenID] = stakedNFT;
627     }
628     emit Staked(msg.sender, _tokenID, block.timestamp);
629   }
630 
631   function batchUnStakeNFT(uint256[] memory tokenIDs) external{
632       uint256 tokenID = 0;
633       for(uint256 i=0; i<tokenIDs.length; i++){
634          tokenID = tokenIDs[i];
635          claimReward(tokenID);
636          IERC721(nft).safeTransferFrom(address(this), msg.sender, tokenID);
637          _unstakeNFT(tokenID);
638       }
639   }
640 
641   function unstakeNFT(uint256 tokenID) public {
642     claimReward(tokenID);
643     IERC721(nft).safeTransferFrom(address(this), msg.sender, tokenID);
644     _unstakeNFT(tokenID);
645   }
646 
647   function _unstakeNFT(uint256 _tokenID) internal {
648     StakedNFT storage stakedNFT = stakedInfo[_tokenID];
649     require(stakedNFT.isStaked, "Staking: NFT not staked!");
650     require(stakedNFT.staker == msg.sender, "Staking: Not the owner of NFT!");
651 
652     stakedNFT.isStaked = false;
653     stakedNFT.startTime = 0;
654 
655     uint256 size = stakedNFTs.length;
656     uint256 lastElement = stakedNFTs[size-1];
657     stakedNFTs.pop();
658 
659 
660     emit UnStaked(_tokenID, block.timestamp);
661 
662     for(uint256 i=0; i< size-1 ; i++){
663       if(stakedNFTs[i] ==_tokenID){
664         stakedNFTs[i] = lastElement;
665         return;
666       }
667     }
668 
669   }
670 
671   function hasNFTData(uint256 _tokenID) internal view returns(bool){
672     if(stakedInfo[_tokenID].staker != address(0)){
673       return true;
674     }
675     return false;
676   }
677 
678   function claimReward(uint256 tokenID) public{
679     StakedNFT storage stakedNFT = stakedInfo[tokenID];
680     require(stakedNFT.staker == msg.sender, "Staking: Not the NFT owner");
681     uint256 claimableEth = stakedNFT.claimableReward;
682     stakedNFT.claimableReward = 0;
683     stakedNFT.lastClaims = block.timestamp;
684     stakedNFT.startTime = block.timestamp;
685     if(claimableEth>0){
686       withdrawEth(claimableEth);
687     }
688   }
689 
690   function withdrawEth(uint256 amount) internal{
691     (bool os, ) = payable(msg.sender).call{value: amount}("");
692     require(os);
693   }
694 
695   // getters
696   function getClaimableEth(uint256 tokenID) external view returns(uint256 ethValue){
697     return stakedInfo[tokenID].claimableReward;
698   }
699 
700   function getStakedNFTInfo(uint256 tokenID) external view returns(StakedNFT memory stakedNft){
701     stakedNft = stakedInfo[tokenID];
702   }
703 
704   function getStakedTime(uint256 tokenID) external view returns(uint256 startTime){
705     startTime = stakedInfo[tokenID].startTime;
706   }
707 
708   function getStakedInfo(uint256 tokenID) external view returns(StakedNFT memory nftInfo){
709     nftInfo = stakedInfo[tokenID];
710   }
711 
712   /*
713   Handle the ERC721 recieve.
714   */
715     function onERC721Received(
716         address,
717         address,
718         uint256,
719         bytes calldata data
720     )
721         public override returns(bytes4)
722     {
723         return _ERC721_RECEIVED;
724     }
725 
726 
727   //ERC721 support 
728   function supportsInterface(bytes4 interfaceID) external returns (bool){
729    
730     return interfaceID == _ERC721_RECEIVED ;
731   }
732 
733 }