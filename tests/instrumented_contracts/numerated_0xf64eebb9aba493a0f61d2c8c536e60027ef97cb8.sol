1 // Sources flattened with hardhat v2.6.3 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/ReentrancyGuard.sol@v3.4.2
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /**
10  * @dev Contract module that helps prevent reentrant calls to a function.
11  *
12  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
13  * available, which can be applied to functions to make sure there are no nested
14  * (reentrant) calls to them.
15  *
16  * Note that because there is a single `nonReentrant` guard, functions marked as
17  * `nonReentrant` may not call one another. This can be worked around by making
18  * those functions `private`, and then adding `external` `nonReentrant` entry
19  * points to them.
20  *
21  * TIP: If you would like to learn more about reentrancy and alternative ways
22  * to protect against it, check out our blog post
23  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
24  */
25 abstract contract ReentrancyGuard {
26     // Booleans are more expensive than uint256 or any type that takes up a full
27     // word because each write operation emits an extra SLOAD to first read the
28     // slot's contents, replace the bits taken up by the boolean, and then write
29     // back. This is the compiler's defense against contract upgrades and
30     // pointer aliasing, and it cannot be disabled.
31 
32     // The values being non-zero value makes deployment a bit more expensive,
33     // but in exchange the refund on every call to nonReentrant will be lower in
34     // amount. Since refunds are capped to a percentage of the total
35     // transaction's gas, it is best to keep them low in cases like this one, to
36     // increase the likelihood of the full refund coming into effect.
37     uint256 private constant _NOT_ENTERED = 1;
38     uint256 private constant _ENTERED = 2;
39 
40     uint256 private _status;
41 
42     constructor () internal {
43         _status = _NOT_ENTERED;
44     }
45 
46     /**
47      * @dev Prevents a contract from calling itself, directly or indirectly.
48      * Calling a `nonReentrant` function from another `nonReentrant`
49      * function is not supported. It is possible to prevent this from happening
50      * by making the `nonReentrant` function external, and make it call a
51      * `private` function that does the actual work.
52      */
53     modifier nonReentrant() {
54         // On the first call to nonReentrant, _notEntered will be true
55         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
56 
57         // Any calls to nonReentrant after this point will fail
58         _status = _ENTERED;
59 
60         _;
61 
62         // By storing the original value once again, a refund is triggered (see
63         // https://eips.ethereum.org/EIPS/eip-2200)
64         _status = _NOT_ENTERED;
65     }
66 }
67 
68 
69 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.2
70 
71 pragma solidity >=0.6.0 <0.8.0;
72 
73 /**
74  * @dev Wrappers over Solidity's arithmetic operations with added overflow
75  * checks.
76  *
77  * Arithmetic operations in Solidity wrap on overflow. This can easily result
78  * in bugs, because programmers usually assume that an overflow raises an
79  * error, which is the standard behavior in high level programming languages.
80  * `SafeMath` restores this intuition by reverting the transaction when an
81  * operation overflows.
82  *
83  * Using this library instead of the unchecked operations eliminates an entire
84  * class of bugs, so it's recommended to use it always.
85  */
86 library SafeMath {
87     /**
88      * @dev Returns the addition of two unsigned integers, with an overflow flag.
89      *
90      * _Available since v3.4._
91      */
92     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
93         uint256 c = a + b;
94         if (c < a) return (false, 0);
95         return (true, c);
96     }
97 
98     /**
99      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
100      *
101      * _Available since v3.4._
102      */
103     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
104         if (b > a) return (false, 0);
105         return (true, a - b);
106     }
107 
108     /**
109      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
110      *
111      * _Available since v3.4._
112      */
113     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
114         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
115         // benefit is lost if 'b' is also tested.
116         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
117         if (a == 0) return (true, 0);
118         uint256 c = a * b;
119         if (c / a != b) return (false, 0);
120         return (true, c);
121     }
122 
123     /**
124      * @dev Returns the division of two unsigned integers, with a division by zero flag.
125      *
126      * _Available since v3.4._
127      */
128     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
129         if (b == 0) return (false, 0);
130         return (true, a / b);
131     }
132 
133     /**
134      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
135      *
136      * _Available since v3.4._
137      */
138     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
139         if (b == 0) return (false, 0);
140         return (true, a % b);
141     }
142 
143     /**
144      * @dev Returns the addition of two unsigned integers, reverting on
145      * overflow.
146      *
147      * Counterpart to Solidity's `+` operator.
148      *
149      * Requirements:
150      *
151      * - Addition cannot overflow.
152      */
153     function add(uint256 a, uint256 b) internal pure returns (uint256) {
154         uint256 c = a + b;
155         require(c >= a, "SafeMath: addition overflow");
156         return c;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting on
161      * overflow (when the result is negative).
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
170         require(b <= a, "SafeMath: subtraction overflow");
171         return a - b;
172     }
173 
174     /**
175      * @dev Returns the multiplication of two unsigned integers, reverting on
176      * overflow.
177      *
178      * Counterpart to Solidity's `*` operator.
179      *
180      * Requirements:
181      *
182      * - Multiplication cannot overflow.
183      */
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         if (a == 0) return 0;
186         uint256 c = a * b;
187         require(c / a == b, "SafeMath: multiplication overflow");
188         return c;
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers, reverting on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b) internal pure returns (uint256) {
204         require(b > 0, "SafeMath: division by zero");
205         return a / b;
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * reverting when dividing by zero.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
221         require(b > 0, "SafeMath: modulo by zero");
222         return a % b;
223     }
224 
225     /**
226      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
227      * overflow (when the result is negative).
228      *
229      * CAUTION: This function is deprecated because it requires allocating memory for the error
230      * message unnecessarily. For custom revert reasons use {trySub}.
231      *
232      * Counterpart to Solidity's `-` operator.
233      *
234      * Requirements:
235      *
236      * - Subtraction cannot overflow.
237      */
238     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
239         require(b <= a, errorMessage);
240         return a - b;
241     }
242 
243     /**
244      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
245      * division by zero. The result is rounded towards zero.
246      *
247      * CAUTION: This function is deprecated because it requires allocating memory for the error
248      * message unnecessarily. For custom revert reasons use {tryDiv}.
249      *
250      * Counterpart to Solidity's `/` operator. Note: this function uses a
251      * `revert` opcode (which leaves remaining gas untouched) while Solidity
252      * uses an invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      *
256      * - The divisor cannot be zero.
257      */
258     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
259         require(b > 0, errorMessage);
260         return a / b;
261     }
262 
263     /**
264      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
265      * reverting with custom message when dividing by zero.
266      *
267      * CAUTION: This function is deprecated because it requires allocating memory for the error
268      * message unnecessarily. For custom revert reasons use {tryMod}.
269      *
270      * Counterpart to Solidity's `%` operator. This function uses a `revert`
271      * opcode (which leaves remaining gas untouched) while Solidity uses an
272      * invalid opcode to revert (consuming all remaining gas).
273      *
274      * Requirements:
275      *
276      * - The divisor cannot be zero.
277      */
278     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
279         require(b > 0, errorMessage);
280         return a % b;
281     }
282 }
283 
284 
285 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.2
286 
287 pragma solidity >=0.6.0 <0.8.0;
288 
289 /**
290  * @dev Interface of the ERC20 standard as defined in the EIP.
291  */
292 interface IERC20 {
293     /**
294      * @dev Returns the amount of tokens in existence.
295      */
296     function totalSupply() external view returns (uint256);
297 
298     /**
299      * @dev Returns the amount of tokens owned by `account`.
300      */
301     function balanceOf(address account) external view returns (uint256);
302 
303     /**
304      * @dev Moves `amount` tokens from the caller's account to `recipient`.
305      *
306      * Returns a boolean value indicating whether the operation succeeded.
307      *
308      * Emits a {Transfer} event.
309      */
310     function transfer(address recipient, uint256 amount) external returns (bool);
311 
312     /**
313      * @dev Returns the remaining number of tokens that `spender` will be
314      * allowed to spend on behalf of `owner` through {transferFrom}. This is
315      * zero by default.
316      *
317      * This value changes when {approve} or {transferFrom} are called.
318      */
319     function allowance(address owner, address spender) external view returns (uint256);
320 
321     /**
322      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
323      *
324      * Returns a boolean value indicating whether the operation succeeded.
325      *
326      * IMPORTANT: Beware that changing an allowance with this method brings the risk
327      * that someone may use both the old and the new allowance by unfortunate
328      * transaction ordering. One possible solution to mitigate this race
329      * condition is to first reduce the spender's allowance to 0 and set the
330      * desired value afterwards:
331      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
332      *
333      * Emits an {Approval} event.
334      */
335     function approve(address spender, uint256 amount) external returns (bool);
336 
337     /**
338      * @dev Moves `amount` tokens from `sender` to `recipient` using the
339      * allowance mechanism. `amount` is then deducted from the caller's
340      * allowance.
341      *
342      * Returns a boolean value indicating whether the operation succeeded.
343      *
344      * Emits a {Transfer} event.
345      */
346     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
347 
348     /**
349      * @dev Emitted when `value` tokens are moved from one account (`from`) to
350      * another (`to`).
351      *
352      * Note that `value` may be zero.
353      */
354     event Transfer(address indexed from, address indexed to, uint256 value);
355 
356     /**
357      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
358      * a call to {approve}. `value` is the new allowance.
359      */
360     event Approval(address indexed owner, address indexed spender, uint256 value);
361 }
362 
363 
364 // File contracts/interface/IDetailedERC20.sol
365 
366 pragma solidity ^0.6.12;
367 
368 interface IDetailedERC20 is IERC20 {
369   function name() external returns (string memory);
370   function symbol() external returns (string memory);
371   function decimals() external returns (uint8);
372 }
373 
374 
375 // File contracts/interface/IMintableERC20.sol
376 
377 pragma solidity ^0.6.12;
378 
379 interface IMintableERC20 is IDetailedERC20{
380   function mint(address _recipient, uint256 _amount) external;
381 }
382 
383 
384 // File @openzeppelin/contracts/introspection/IERC165.sol@v3.4.2
385 
386 pragma solidity >=0.6.0 <0.8.0;
387 
388 /**
389  * @dev Interface of the ERC165 standard, as defined in the
390  * https://eips.ethereum.org/EIPS/eip-165[EIP].
391  *
392  * Implementers can declare support of contract interfaces, which can then be
393  * queried by others ({ERC165Checker}).
394  *
395  * For an implementation, see {ERC165}.
396  */
397 interface IERC165 {
398     /**
399      * @dev Returns true if this contract implements the interface defined by
400      * `interfaceId`. See the corresponding
401      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
402      * to learn more about how these ids are created.
403      *
404      * This function call must use less than 30 000 gas.
405      */
406     function supportsInterface(bytes4 interfaceId) external view returns (bool);
407 }
408 
409 
410 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v3.4.2
411 
412 pragma solidity >=0.6.2 <0.8.0;
413 
414 /**
415  * @dev Required interface of an ERC721 compliant contract.
416  */
417 interface IERC721 is IERC165 {
418     /**
419      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
420      */
421     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
422 
423     /**
424      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
425      */
426     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
427 
428     /**
429      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
430      */
431     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
432 
433     /**
434      * @dev Returns the number of tokens in ``owner``'s account.
435      */
436     function balanceOf(address owner) external view returns (uint256 balance);
437 
438     /**
439      * @dev Returns the owner of the `tokenId` token.
440      *
441      * Requirements:
442      *
443      * - `tokenId` must exist.
444      */
445     function ownerOf(uint256 tokenId) external view returns (address owner);
446 
447     /**
448      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
449      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
450      *
451      * Requirements:
452      *
453      * - `from` cannot be the zero address.
454      * - `to` cannot be the zero address.
455      * - `tokenId` token must exist and be owned by `from`.
456      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
457      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
458      *
459      * Emits a {Transfer} event.
460      */
461     function safeTransferFrom(address from, address to, uint256 tokenId) external;
462 
463     /**
464      * @dev Transfers `tokenId` token from `from` to `to`.
465      *
466      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
467      *
468      * Requirements:
469      *
470      * - `from` cannot be the zero address.
471      * - `to` cannot be the zero address.
472      * - `tokenId` token must be owned by `from`.
473      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
474      *
475      * Emits a {Transfer} event.
476      */
477     function transferFrom(address from, address to, uint256 tokenId) external;
478 
479     /**
480      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
481      * The approval is cleared when the token is transferred.
482      *
483      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
484      *
485      * Requirements:
486      *
487      * - The caller must own the token or be an approved operator.
488      * - `tokenId` must exist.
489      *
490      * Emits an {Approval} event.
491      */
492     function approve(address to, uint256 tokenId) external;
493 
494     /**
495      * @dev Returns the account approved for `tokenId` token.
496      *
497      * Requirements:
498      *
499      * - `tokenId` must exist.
500      */
501     function getApproved(uint256 tokenId) external view returns (address operator);
502 
503     /**
504      * @dev Approve or remove `operator` as an operator for the caller.
505      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
506      *
507      * Requirements:
508      *
509      * - The `operator` cannot be the caller.
510      *
511      * Emits an {ApprovalForAll} event.
512      */
513     function setApprovalForAll(address operator, bool _approved) external;
514 
515     /**
516      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
517      *
518      * See {setApprovalForAll}
519      */
520     function isApprovedForAll(address owner, address operator) external view returns (bool);
521 
522     /**
523       * @dev Safely transfers `tokenId` token from `from` to `to`.
524       *
525       * Requirements:
526       *
527       * - `from` cannot be the zero address.
528       * - `to` cannot be the zero address.
529       * - `tokenId` token must exist and be owned by `from`.
530       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
531       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
532       *
533       * Emits a {Transfer} event.
534       */
535     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
536 }
537 
538 
539 // File @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol@v3.4.2
540 
541 pragma solidity >=0.6.2 <0.8.0;
542 
543 /**
544  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
545  * @dev See https://eips.ethereum.org/EIPS/eip-721
546  */
547 interface IERC721Enumerable is IERC721 {
548 
549     /**
550      * @dev Returns the total amount of tokens stored by the contract.
551      */
552     function totalSupply() external view returns (uint256);
553 
554     /**
555      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
556      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
557      */
558     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
559 
560     /**
561      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
562      * Use along with {totalSupply} to enumerate all tokens.
563      */
564     function tokenByIndex(uint256 index) external view returns (uint256);
565 }
566 
567 
568 // File contracts/MGGTokenBox.sol
569 
570 pragma solidity ^0.6.12;
571 pragma experimental ABIEncoderV2;
572 
573 
574 
575 ///
576 /// @dev A contract which allows HOE owner to claim their MGG every week
577 ///
578 
579 contract MGGTokenBox is ReentrancyGuard {
580   using SafeMath for uint256;
581 
582   event PendingGovernanceUpdated(
583     address pendingGovernance
584   );
585 
586   event GovernanceUpdated(
587     address governance
588   );
589 
590   event RewardRateUpdated(
591     uint256 rewardRate
592   );
593 
594   event TokensClaimed(
595     address indexed user,
596     uint256 week,
597     uint256 hoeId,
598     uint256 amount
599   );
600 
601   /// @dev The token which will be minted as a reward for staking.
602   IMintableERC20 public reward;
603 
604   IERC721Enumerable public hoeContract;
605 
606   /// @dev The address of the account which currently has administrative capabilities over this contract.
607   address public governance;
608 
609   address public pendingGovernance;
610 
611   uint256 private constant SECONDS_PER_WEEK = 604800; /* 86400 seconds in a day , 604800 seconds in a week */
612 
613   // Track claimed tokens by week
614   // IMPORTANT: The format of the mapping is:
615   // weekClaimedByTokenId[week][tokenId][claimed]
616 
617   mapping(uint256 => mapping(uint256 => bool)) public weekClaimedByTokenId;
618 
619   uint256 private _startTimestamp;
620 
621   uint256 public tokenIdStart = 0;
622   uint256 public tokenIdEnd = 9999;
623 
624   uint256 public rewardPerHOEPerWeek;
625 
626 
627   constructor(
628     IMintableERC20 _reward,
629     address _hoeContractAddress,
630     uint256 startTimestamp_,
631     uint256 _rewardPerHOEPerWeek,
632     address _governance
633   ) public {
634     require(_governance != address(0), "MGGTokenBox: governance address cannot be 0x0");
635 
636     reward = _reward;
637     hoeContract = IERC721Enumerable(_hoeContractAddress);
638     _startTimestamp = startTimestamp_;
639     rewardPerHOEPerWeek = _rewardPerHOEPerWeek;
640     governance = _governance;
641   }
642 
643   /// @dev A modifier which reverts when the caller is not the governance.
644   modifier onlyGovernance() {
645     require(msg.sender == governance, "MGGTokenBox: only governance");
646     _;
647   }
648 
649   /// @dev Sets the governance.
650   ///
651   /// This function can only called by the current governance.
652   ///
653   /// @param _pendingGovernance the new pending governance.
654   function setPendingGovernance(address _pendingGovernance) external onlyGovernance {
655     require(_pendingGovernance != address(0), "MGGTokenBox: pending governance address cannot be 0x0");
656     pendingGovernance = _pendingGovernance;
657 
658     emit PendingGovernanceUpdated(_pendingGovernance);
659   }
660 
661   function acceptGovernance() external {
662     require(msg.sender == pendingGovernance, "MGGTokenBox: only pending governance");
663 
664     address _pendingGovernance = pendingGovernance;
665     governance = _pendingGovernance;
666 
667     emit GovernanceUpdated(_pendingGovernance);
668   }
669 
670   function updateRewardRate(uint256 rewardRate) external onlyGovernance {
671     rewardPerHOEPerWeek = rewardRate;
672     emit RewardRateUpdated(rewardRate);
673   }
674 
675   function currentWeek() public view returns (uint256 weekNumber) {
676       return uint256(block.timestamp / SECONDS_PER_WEEK);
677   }
678 
679   function startWeek()public view returns (uint256 weekNumber) {
680       return uint256(_startTimestamp / SECONDS_PER_WEEK);
681   }
682 
683   function getClaimStatus(uint256 week, uint256 tokenId)public view returns (bool claimed) {
684       return weekClaimedByTokenId[week][tokenId];
685   }
686 
687   /// @notice Claim MGG for a given HOE ID
688   /// @param tokenId The tokenId of the HOE NFT
689   function claimById(uint256 tokenId, uint256 week) external nonReentrant{
690 
691       // Check that the msgSender owns the token that is being claimed
692       require(
693           msg.sender == hoeContract.ownerOf(tokenId),
694           "MUST_OWN_TOKEN_ID"
695       );
696 
697       require(
698           !weekClaimedByTokenId[week][tokenId],
699           "Already Claimed"
700       );
701 
702       // Further Checks, Effects, and Interactions are contained within the
703       // _claim() function
704       _claim(tokenId, msg.sender, week);
705   }
706 
707     /// @notice Claim MGG for all tokens owned by the sender
708     /// @notice This function will run out of gas if you have too much HOE!
709     function claimAllForOwner(uint256 week) external {
710         uint256 tokenBalanceOwner = hoeContract.balanceOf(msg.sender);
711 
712         // Checks
713         require(tokenBalanceOwner > 0, "NO_TOKENS_OWNED");
714 
715         // i < tokenBalanceOwner because tokenBalanceOwner is 1-indexed
716         for (uint256 i = 0; i < tokenBalanceOwner; i++) {
717             // Further Checks, Effects, and Interactions are contained within
718             // the _claim() function
719 
720             if(!weekClaimedByTokenId[week][hoeContract.tokenOfOwnerByIndex(msg.sender, i)]){
721               _claim(
722                   hoeContract.tokenOfOwnerByIndex(msg.sender, i),
723                   msg.sender,
724                   week
725               );
726             }
727         }
728     }
729 
730     /// @dev Internal function to mint MGG upon claiming
731     function _claim(uint256 tokenId, address tokenOwner, uint256 week) internal {
732         // Checks
733         // Check that the token ID is in range
734         // We use >= and <= to here because all of the token IDs are 0-indexed
735         require(
736             tokenId >= tokenIdStart && tokenId <= tokenIdEnd,
737             "TOKEN_ID_OUT_OF_RANGE"
738         );
739 
740         require(
741             week >= startWeek() && week <= currentWeek(),
742             "Need Valid Week"
743         );
744 
745         // Check that MGG have not already been claimed this week
746         // for a given tokenId
747         require(
748             !weekClaimedByTokenId[week][tokenId],
749             "Already Claimed"
750         );
751 
752         // Mark that MGG has been claimed for this week for the
753         // given tokenId
754         weekClaimedByTokenId[week][tokenId] = true;
755 
756 
757 
758         // Send MGG to the owner of the token ID
759         reward.mint(tokenOwner, rewardPerHOEPerWeek);
760     }
761 
762 }