1 /**
2  *Submitted for verification at Etherscan.io on 2022-01-12
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-01-12
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-01-12
11 */
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2022-01-12
15 */
16 
17 /**
18  *Submitted for verification at Etherscan.io on 2022-01-11
19 */
20 
21 // SPDX-License-Identifier: MIT
22 pragma solidity 0.8.7;
23 
24 
25  
26 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
27 /**
28  * @dev Interface of the ERC165 standard, as defined in the
29  * https://eips.ethereum.org/EIPS/eip-165[EIP].
30  *
31  * Implementers can declare support of contract interfaces, which can then be
32  * queried by others ({ERC165Checker}).
33  *
34  * For an implementation, see {ERC165}.
35  */
36 interface IERC165 {
37     /**
38      * @dev Returns true if this contract implements the interface defined by
39      * `interfaceId`. See the corresponding
40      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
41      * to learn more about how these ids are created.
42      *
43      * This function call must use less than 30 000 gas.
44      */
45     function supportsInterface(bytes4 interfaceId) external view returns (bool);
46 }
47 
48  
49 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
50 /**
51  * @dev Required interface of an ERC721 compliant contract.
52  */
53 interface IERC721 is IERC165 {
54     /**
55      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
56      */
57     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
58 
59     /**
60      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
61      */
62     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
63 
64     /**
65      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
66      */
67     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
68 
69     /**
70      * @dev Returns the number of tokens in ``owner``'s account.
71      */
72     function balanceOf(address owner) external view returns (uint256 balance);
73 
74     /**
75      * @dev Returns the owner of the `tokenId` token.
76      *
77      * Requirements:
78      *
79      * - `tokenId` must exist.
80      */
81     function ownerOf(uint256 tokenId) external view returns (address owner);
82 
83     /**
84      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
85      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
86      *
87      * Requirements:
88      *
89      * - `from` cannot be the zero address.
90      * - `to` cannot be the zero address.
91      * - `tokenId` token must exist and be owned by `from`.
92      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
93      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
94      *
95      * Emits a {Transfer} event.
96      */
97     function safeTransferFrom(
98         address from,
99         address to,
100         uint256 tokenId
101     ) external;
102 
103     /**
104      * @dev Transfers `tokenId` token from `from` to `to`.
105      *
106      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
107      *
108      * Requirements:
109      *
110      * - `from` cannot be the zero address.
111      * - `to` cannot be the zero address.
112      * - `tokenId` token must be owned by `from`.
113      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
114      *
115      * Emits a {Transfer} event.
116      */
117     function transferFrom(
118         address from,
119         address to,
120         uint256 tokenId
121     ) external;
122 
123     /**
124      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
125      * The approval is cleared when the token is transferred.
126      *
127      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
128      *
129      * Requirements:
130      *
131      * - The caller must own the token or be an approved operator.
132      * - `tokenId` must exist.
133      *
134      * Emits an {Approval} event.
135      */
136     function approve(address to, uint256 tokenId) external;
137 
138     /**
139      * @dev Returns the account approved for `tokenId` token.
140      *
141      * Requirements:
142      *
143      * - `tokenId` must exist.
144      */
145     function getApproved(uint256 tokenId) external view returns (address operator);
146 
147     /**
148      * @dev Approve or remove `operator` as an operator for the caller.
149      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
150      *
151      * Requirements:
152      *
153      * - The `operator` cannot be the caller.
154      *
155      * Emits an {ApprovalForAll} event.
156      */
157     function setApprovalForAll(address operator, bool _approved) external;
158 
159     /**
160      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
161      *
162      * See {setApprovalForAll}
163      */
164     function isApprovedForAll(address owner, address operator) external view returns (bool);
165 
166     /**
167      * @dev Safely transfers `tokenId` token from `from` to `to`.
168      *
169      * Requirements:
170      *
171      * - `from` cannot be the zero address.
172      * - `to` cannot be the zero address.
173      * - `tokenId` token must exist and be owned by `from`.
174      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
175      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
176      *
177      * Emits a {Transfer} event.
178      */
179     function safeTransferFrom(
180         address from,
181         address to,
182         uint256 tokenId,
183         bytes calldata data
184     ) external;
185 }
186 
187  
188 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
189 /**
190  * @dev Interface of the ERC20 standard as defined in the EIP.
191  */
192 interface IERC20 {
193     /**
194      * @dev Returns the amount of tokens in existence.
195      */
196     function totalSupply() external view returns (uint256);
197 
198     /**
199      * @dev Returns the amount of tokens owned by `account`.
200      */
201     function balanceOf(address account) external view returns (uint256);
202 
203     /**
204      * @dev Moves `amount` tokens from the caller's account to `recipient`.
205      *
206      * Returns a boolean value indicating whether the operation succeeded.
207      *
208      * Emits a {Transfer} event.
209      */
210     function transfer(address recipient, uint256 amount) external returns (bool);
211 
212     /**
213      * @dev Returns the remaining number of tokens that `spender` will be
214      * allowed to spend on behalf of `owner` through {transferFrom}. This is
215      * zero by default.
216      *
217      * This value changes when {approve} or {transferFrom} are called.
218      */
219     function allowance(address owner, address spender) external view returns (uint256);
220 
221     /**
222      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
223      *
224      * Returns a boolean value indicating whether the operation succeeded.
225      *
226      * IMPORTANT: Beware that changing an allowance with this method brings the risk
227      * that someone may use both the old and the new allowance by unfortunate
228      * transaction ordering. One possible solution to mitigate this race
229      * condition is to first reduce the spender's allowance to 0 and set the
230      * desired value afterwards:
231      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
232      *
233      * Emits an {Approval} event.
234      */
235     function approve(address spender, uint256 amount) external returns (bool);
236 
237     /**
238      * @dev Moves `amount` tokens from `sender` to `recipient` using the
239      * allowance mechanism. `amount` is then deducted from the caller's
240      * allowance.
241      *
242      * Returns a boolean value indicating whether the operation succeeded.
243      *
244      * Emits a {Transfer} event.
245      */
246     function transferFrom(
247         address sender,
248         address recipient,
249         uint256 amount
250     ) external returns (bool);
251 
252     /**
253      * @dev Emitted when `value` tokens are moved from one account (`from`) to
254      * another (`to`).
255      *
256      * Note that `value` may be zero.
257      */
258     event Transfer(address indexed from, address indexed to, uint256 value);
259 
260     /**
261      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
262      * a call to {approve}. `value` is the new allowance.
263      */
264     event Approval(address indexed owner, address indexed spender, uint256 value);
265 }
266 
267  
268 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
269 /**
270  * @dev Provides information about the current execution context, including the
271  * sender of the transaction and its data. While these are generally available
272  * via msg.sender and msg.data, they should not be accessed in such a direct
273  * manner, since when dealing with meta-transactions the account sending and
274  * paying for execution may not be the actual sender (as far as an application
275  * is concerned).
276  *
277  * This contract is only required for intermediate, library-like contracts.
278  */
279 abstract contract Context {
280     function _msgSender() internal view virtual returns (address) {
281         return msg.sender;
282     }
283 
284     function _msgData() internal view virtual returns (bytes calldata) {
285         return msg.data;
286     }
287 }
288 
289  
290 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
291 /**
292  * @dev Contract module which provides a basic access control mechanism, where
293  * there is an account (an owner) that can be granted exclusive access to
294  * specific functions.
295  *
296  * By default, the owner account will be the one that deploys the contract. This
297  * can later be changed with {transferOwnership}.
298  *
299  * This module is used through inheritance. It will make available the modifier
300  * `onlyOwner`, which can be applied to your functions to restrict their use to
301  * the owner.
302  */
303 abstract contract Ownable is Context {
304     address private _owner;
305 
306     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
307 
308     /**
309      * @dev Initializes the contract setting the deployer as the initial owner.
310      */
311     constructor() {
312         _transferOwnership(_msgSender());
313     }
314 
315     /**
316      * @dev Returns the address of the current owner.
317      */
318     function owner() public view virtual returns (address) {
319         return _owner;
320     }
321 
322     /**
323      * @dev Throws if called by any account other than the owner.
324      */
325     modifier onlyOwner() {
326         require(owner() == _msgSender(), "Ownable: caller is not the owner");
327         _;
328     }
329 
330     /**
331      * @dev Leaves the contract without owner. It will not be possible to call
332      * `onlyOwner` functions anymore. Can only be called by the current owner.
333      *
334      * NOTE: Renouncing ownership will leave the contract without an owner,
335      * thereby removing any functionality that is only available to the owner.
336      */
337     function renounceOwnership() public virtual onlyOwner {
338         _transferOwnership(address(0));
339     }
340 
341     /**
342      * @dev Transfers ownership of the contract to a new account (`newOwner`).
343      * Can only be called by the current owner.
344      */
345     function transferOwnership(address newOwner) public virtual onlyOwner {
346         require(newOwner != address(0), "Ownable: new owner is the zero address");
347         _transferOwnership(newOwner);
348     }
349 
350     /**
351      * @dev Transfers ownership of the contract to a new account (`newOwner`).
352      * Internal function without access restriction.
353      */
354     function _transferOwnership(address newOwner) internal virtual {
355         address oldOwner = _owner;
356         _owner = newOwner;
357         emit OwnershipTransferred(oldOwner, newOwner);
358     }
359 }
360 
361  
362 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
363 /**
364  * @title ERC721 token receiver interface
365  * @dev Interface for any contract that wants to support safeTransfers
366  * from ERC721 asset contracts.
367  */
368 interface IERC721Receiver {
369     /**
370      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
371      * by `operator` from `from`, this function is called.
372      *
373      * It must return its Solidity selector to confirm the token transfer.
374      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
375      *
376      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
377      */
378     function onERC721Received(
379         address operator,
380         address from,
381         uint256 tokenId,
382         bytes calldata data
383     ) external returns (bytes4);
384 }
385 
386  
387 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
388 // CAUTION
389 // This version of SafeMath should only be used with Solidity 0.8 or later,
390 // because it relies on the compiler's built in overflow checks.
391 /**
392  * @dev Wrappers over Solidity's arithmetic operations.
393  *
394  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
395  * now has built in overflow checking.
396  */
397 library SafeMath {
398     /**
399      * @dev Returns the addition of two unsigned integers, with an overflow flag.
400      *
401      * _Available since v3.4._
402      */
403     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
404         unchecked {
405             uint256 c = a + b;
406             if (c < a) return (false, 0);
407             return (true, c);
408         }
409     }
410 
411     /**
412      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
413      *
414      * _Available since v3.4._
415      */
416     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
417         unchecked {
418             if (b > a) return (false, 0);
419             return (true, a - b);
420         }
421     }
422 
423     /**
424      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
425      *
426      * _Available since v3.4._
427      */
428     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
429         unchecked {
430             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
431             // benefit is lost if 'b' is also tested.
432             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
433             if (a == 0) return (true, 0);
434             uint256 c = a * b;
435             if (c / a != b) return (false, 0);
436             return (true, c);
437         }
438     }
439 
440     /**
441      * @dev Returns the division of two unsigned integers, with a division by zero flag.
442      *
443      * _Available since v3.4._
444      */
445     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
446         unchecked {
447             if (b == 0) return (false, 0);
448             return (true, a / b);
449         }
450     }
451 
452     /**
453      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
454      *
455      * _Available since v3.4._
456      */
457     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
458         unchecked {
459             if (b == 0) return (false, 0);
460             return (true, a % b);
461         }
462     }
463 
464     /**
465      * @dev Returns the addition of two unsigned integers, reverting on
466      * overflow.
467      *
468      * Counterpart to Solidity's `+` operator.
469      *
470      * Requirements:
471      *
472      * - Addition cannot overflow.
473      */
474     function add(uint256 a, uint256 b) internal pure returns (uint256) {
475         return a + b;
476     }
477 
478     /**
479      * @dev Returns the subtraction of two unsigned integers, reverting on
480      * overflow (when the result is negative).
481      *
482      * Counterpart to Solidity's `-` operator.
483      *
484      * Requirements:
485      *
486      * - Subtraction cannot overflow.
487      */
488     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
489         return a - b;
490     }
491 
492     /**
493      * @dev Returns the multiplication of two unsigned integers, reverting on
494      * overflow.
495      *
496      * Counterpart to Solidity's `*` operator.
497      *
498      * Requirements:
499      *
500      * - Multiplication cannot overflow.
501      */
502     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
503         return a * b;
504     }
505 
506     /**
507      * @dev Returns the integer division of two unsigned integers, reverting on
508      * division by zero. The result is rounded towards zero.
509      *
510      * Counterpart to Solidity's `/` operator.
511      *
512      * Requirements:
513      *
514      * - The divisor cannot be zero.
515      */
516     function div(uint256 a, uint256 b) internal pure returns (uint256) {
517         return a / b;
518     }
519 
520     /**
521      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
522      * reverting when dividing by zero.
523      *
524      * Counterpart to Solidity's `%` operator. This function uses a `revert`
525      * opcode (which leaves remaining gas untouched) while Solidity uses an
526      * invalid opcode to revert (consuming all remaining gas).
527      *
528      * Requirements:
529      *
530      * - The divisor cannot be zero.
531      */
532     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
533         return a % b;
534     }
535 
536     /**
537      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
538      * overflow (when the result is negative).
539      *
540      * CAUTION: This function is deprecated because it requires allocating memory for the error
541      * message unnecessarily. For custom revert reasons use {trySub}.
542      *
543      * Counterpart to Solidity's `-` operator.
544      *
545      * Requirements:
546      *
547      * - Subtraction cannot overflow.
548      */
549     function sub(
550         uint256 a,
551         uint256 b,
552         string memory errorMessage
553     ) internal pure returns (uint256) {
554         unchecked {
555             require(b <= a, errorMessage);
556             return a - b;
557         }
558     }
559 
560     /**
561      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
562      * division by zero. The result is rounded towards zero.
563      *
564      * Counterpart to Solidity's `/` operator. Note: this function uses a
565      * `revert` opcode (which leaves remaining gas untouched) while Solidity
566      * uses an invalid opcode to revert (consuming all remaining gas).
567      *
568      * Requirements:
569      *
570      * - The divisor cannot be zero.
571      */
572     function div(
573         uint256 a,
574         uint256 b,
575         string memory errorMessage
576     ) internal pure returns (uint256) {
577         unchecked {
578             require(b > 0, errorMessage);
579             return a / b;
580         }
581     }
582 
583     /**
584      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
585      * reverting with custom message when dividing by zero.
586      *
587      * CAUTION: This function is deprecated because it requires allocating memory for the error
588      * message unnecessarily. For custom revert reasons use {tryMod}.
589      *
590      * Counterpart to Solidity's `%` operator. This function uses a `revert`
591      * opcode (which leaves remaining gas untouched) while Solidity uses an
592      * invalid opcode to revert (consuming all remaining gas).
593      *
594      * Requirements:
595      *
596      * - The divisor cannot be zero.
597      */
598     function mod(
599         uint256 a,
600         uint256 b,
601         string memory errorMessage
602     ) internal pure returns (uint256) {
603         unchecked {
604             require(b > 0, errorMessage);
605             return a % b;
606         }
607     }
608 }
609 
610 contract BearStaking is Ownable, IERC721Receiver{
611   using SafeMath for uint256;
612 
613   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
614 
615   //StakedBear Struct
616   struct StakedBear{
617     address owner;
618     uint256 lastClaimed;
619     bool isStaked;
620     bool isEmergencyOut;
621     uint256 emergencyOutTime;
622   }
623 
624   //event 
625   event RewardClaimed(uint256 tokenID, address owner);
626   event Staked(address staker, uint256 tokenID, uint256 stakedTime);
627   event UnStaked(uint256 tokenID, uint256 unstakedTime);
628 
629   // token_id => StakedBear
630   mapping(uint256 => StakedBear) public stakedBear;
631   uint256[] public bears;
632 
633   //NFT address
634   address public bearNFT = 0x838E240c0FcBd12fBfFdB327d35A32DD2E73C7ea;
635   //ERC20 address
636   address public honey = 0x4F0c5042A11830fEaBA227840402e2409b0FC9dC;
637 
638   //reward discription 
639   uint256 public rate = 10 * 10**18;
640   //reward interval
641   uint256 public rewardPeroid = 1 days;
642 
643   // reward = delta * rate / peroid
644   function calculateReward(uint256 _lastClaimed, uint256 _rewardEndTime) view internal returns(uint256){
645     return _rewardEndTime.sub(_lastClaimed).mul(rate).div(rewardPeroid); 
646   }
647 
648   function batchStakeNFT(uint256[] memory _tokenIds) external {
649       for(uint256 i=0;i<_tokenIds.length;i++){
650           stakeNFT(_tokenIds[i]);
651       }
652   }  
653   function stakeNFT(uint256 _tokenId) public {
654     require(!stakedBear[_tokenId].isStaked, "Staking: NFT already on staked!");
655     require(IERC721(bearNFT).ownerOf(_tokenId)==msg.sender, "Staking: Not the NFT owner!");
656     require(
657         address(this) == IERC721(bearNFT).getApproved(_tokenId) || IERC721(bearNFT).isApprovedForAll(msg.sender, address(this)), 
658         "Staking: NFT not approved for the staking address OR Staking not set as operator!"
659     );
660     IERC721(bearNFT).safeTransferFrom(msg.sender, address(this), _tokenId, " ");
661     _stakeNFT(_tokenId);
662   }
663 
664   function batchUnstakeNFT(uint256[] memory _tokenIds) external {
665       for(uint256 i=0;i<_tokenIds.length;i++){
666           unstakeNFT(_tokenIds[i]);
667       }
668   }  
669   function unstakeNFT(uint256 _tokenId) public {
670     require(stakedBear[_tokenId].isStaked, "Staking: NFT not on staked!");
671     IERC721(bearNFT).safeTransferFrom(address(this), msg.sender, _tokenId, " ");
672     claimReward(_tokenId);
673     _unstakeNFT(_tokenId);
674   }
675 
676   function batchUnstakeWithoutRewardNFT(uint256[] memory _tokenIds) external{
677       for(uint256 i=0;i<_tokenIds.length; i++){
678           unstakeWithoutRewardNFT(_tokenIds[i]);
679       }
680   }
681   function unstakeWithoutRewardNFT(uint256 _tokenId) public {
682     stakedBear[_tokenId].emergencyOutTime = block.timestamp;
683     stakedBear[_tokenId].isEmergencyOut = true;
684     require(stakedBear[_tokenId].isStaked, "Staking: NFT not on staked!");
685     IERC721(bearNFT).safeTransferFrom(address(this), msg.sender, _tokenId, " ");
686     _unstakeNFT(_tokenId);
687   }
688 
689   function _stakeNFT(uint256 _tokenId) internal{
690     StakedBear storage bear = stakedBear[_tokenId];
691     require(!bear.isStaked, "Staking: NFT already in staking!");
692     bear.isStaked = true;
693     bear.owner = msg.sender;
694     bear.lastClaimed = block.timestamp;
695     bear.isEmergencyOut = false;
696     //add bear
697     bears.push(_tokenId);
698     emit Staked(msg.sender, _tokenId, block.timestamp);
699   }
700 
701   function _unstakeNFT(uint256 _tokenId) internal {
702     StakedBear storage bear = stakedBear[_tokenId];
703     require(bear.isStaked, "Staking: NFT not staked!");
704     require(bear.owner == msg.sender, "Staking: Not the owner of NFT!");
705     bear.isStaked = false;
706 
707     emit UnStaked(_tokenId, block.timestamp);
708     //remove from bears.
709     for(uint256 i=0; i<bears.length; i++){
710         if(bears[i] == _tokenId){
711             bears[i] = bears[bears.length-1];
712             bears.pop();
713             return;
714         }
715     }
716   }
717 
718   function claimReward(uint256 _tokenId) public {
719     StakedBear storage bear = stakedBear[_tokenId];
720     require(bear.owner != address(0), "Staking: Bear not in staking!"); 
721     require(bear.owner == msg.sender, "Staking: Not the owner of NFT!"); 
722     uint256 reward = 0;
723     if(bear.isEmergencyOut){
724         require(bear.emergencyOutTime > bear.lastClaimed, "Staking: Already Claimed Reward!");
725         reward = calculateReward(bear.lastClaimed, bear.emergencyOutTime);
726 
727     }else{
728         require(bear.isStaked, "Staking: Not in staking!");
729         reward = calculateReward(bear.lastClaimed, block.timestamp);
730     }
731     bear.lastClaimed = block.timestamp;
732     //transfer honey
733     IERC20(honey).transfer(msg.sender, reward);
734     emit RewardClaimed(_tokenId, msg.sender);
735   }
736 
737   function claimBatchReward(uint256[] memory _tokenIds) external{
738     for(uint i=0; i<_tokenIds.length; i++){
739       claimReward(_tokenIds[i]);
740     }
741   }
742 
743   function getStakedBear(address wallet)  public view returns(uint256[] memory){
744       uint256[] memory stakedBears = new uint256[](bears.length);
745       uint256 count=0;
746       for(uint256 i=0; i<bears.length; i++){
747         StakedBear memory _bear = stakedBear[bears[i]];
748         if(_bear.owner==wallet && _bear.isStaked){
749             stakedBears[count] = bears[i];
750             count++;
751         }
752       }
753       uint256[] memory userStakedBears = new uint256[](count);
754       for(uint256 i=0; i<count; i++){
755           userStakedBears[i] = stakedBears[i];
756       }
757       return userStakedBears;
758   }
759 
760   function getClaimableToken(address wallet) external view returns(uint256){
761       uint256[] memory stakedBears = getStakedBear(wallet);
762       uint256 reward = 0;
763       for(uint256 i=0; i<stakedBears.length; i++){
764           if(stakedBear[stakedBears[i]].isEmergencyOut)
765             reward += calculateReward(stakedBear[stakedBears[i]].lastClaimed, stakedBear[stakedBears[i]].emergencyOutTime);
766           else
767             reward += calculateReward(stakedBear[stakedBears[i]].lastClaimed, block.timestamp);
768       }
769       return reward;
770   }
771 
772   function getTotalStakedBears() external view returns(uint256){
773       return bears.length;
774   }
775   
776   //----------- Rescue Ether and tokens ------------//
777   function withdraw() external payable onlyOwner {
778     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
779     require(os);
780   }
781 
782   function withdrawToken(uint256 amount) external onlyOwner{
783     IERC20(honey).transfer(msg.sender, amount);
784   }
785 
786 
787   //------ Callbacks -------------------//
788   /*
789   Handle the ERC721 recieve.
790   */
791   function onERC721Received(
792         address,
793         address,
794         uint256,
795         bytes calldata data
796     )
797         public override returns(bytes4)
798     {
799         return _ERC721_RECEIVED;
800     }
801 
802 
803   //ERC721 support 
804   function supportsInterface(bytes4 interfaceID) external returns (bool){
805     return interfaceID == _ERC721_RECEIVED ;
806   }
807 }