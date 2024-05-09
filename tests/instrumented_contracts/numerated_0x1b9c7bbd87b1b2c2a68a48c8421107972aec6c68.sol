1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.8.14;
3 
4 /**
5  * @dev https://eips.ethereum.org/EIPS/eip-1167[EIP 1167] is a standard for
6  * deploying minimal proxy contracts, also known as "clones".
7  *
8  */
9 contract Cloneable {
10 
11     /**
12         @dev Deploys and returns the address of a clone of address(this
13         Created by DeFi Mark To Allow Clone Contract To Easily Create Clones Of Itself
14         Without redundancy
15      */
16     function clone() external returns(address) {
17         return _clone(address(this));
18     }
19 
20     /**
21      * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
22      *
23      * This function uses the create opcode, which should never revert.
24      */
25     function _clone(address implementation) internal returns (address instance) {
26         /// @solidity memory-safe-assembly
27         assembly {
28             let ptr := mload(0x40)
29             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
30             mstore(add(ptr, 0x14), shl(0x60, implementation))
31             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
32             instance := create(0, ptr, 0x37)
33         }
34         require(instance != address(0), "ERC1167: create failed");
35     }
36 }
37 
38 /**
39  * @title Owner
40  * @dev Set & change owner
41  */
42 contract Ownable {
43 
44     address private owner;
45     
46     // event for EVM logging
47     event OwnerSet(address indexed oldOwner, address indexed newOwner);
48     
49     // modifier to check if caller is owner
50     modifier onlyOwner() {
51         // If the first argument of 'require' evaluates to 'false', execution terminates and all
52         // changes to the state and to Ether balances are reverted.
53         // This used to consume all gas in old EVM versions, but not anymore.
54         // It is often a good idea to use 'require' to check if functions are called correctly.
55         // As a second argument, you can also provide an explanation about what went wrong.
56         require(msg.sender == owner, "Caller is not owner");
57         _;
58     }
59     
60     /**
61      * @dev Set contract deployer as owner
62      */
63     constructor() {
64         owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
65         emit OwnerSet(address(0), owner);
66     }
67 
68     /**
69      * @dev Change owner
70      * @param newOwner address of new owner
71      */
72     function changeOwner(address newOwner) public onlyOwner {
73         emit OwnerSet(owner, newOwner);
74         owner = newOwner;
75     }
76 
77     /**
78      * @dev Return owner address 
79      * @return address of owner
80      */
81     function getOwner() external view returns (address) {
82         return owner;
83     }
84 }
85 
86 interface IERC20 {
87 
88     function totalSupply() external view returns (uint256);
89     
90     function symbol() external view returns(string memory);
91     
92     function name() external view returns(string memory);
93 
94     /**
95      * @dev Returns the amount of tokens owned by `account`.
96      */
97     function balanceOf(address account) external view returns (uint256);
98     
99     /**
100      * @dev Returns the number of decimal places
101      */
102     function decimals() external view returns (uint8);
103 
104     /**
105      * @dev Moves `amount` tokens from the caller's account to `recipient`.
106      *
107      * Returns a boolean value indicating whether the operation succeeded.
108      *
109      * Emits a {Transfer} event.
110      */
111     function transfer(address recipient, uint256 amount) external returns (bool);
112 
113     /**
114      * @dev Returns the remaining number of tokens that `spender` will be
115      * allowed to spend on behalf of `owner` through {transferFrom}. This is
116      * zero by default.
117      *
118      * This value changes when {approve} or {transferFrom} are called.
119      */
120     function allowance(address owner, address spender) external view returns (uint256);
121 
122     /**
123      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
124      *
125      * Returns a boolean value indicating whether the operation succeeded.
126      *
127      * IMPORTANT: Beware that changing an allowance with this method brings the risk
128      * that someone may use both the old and the new allowance by unfortunate
129      * transaction ordering. One possible solution to mitigate this race
130      * condition is to first reduce the spender's allowance to 0 and set the
131      * desired value afterwards:
132      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133      *
134      * Emits an {Approval} event.
135      */
136     function approve(address spender, uint256 amount) external returns (bool);
137 
138     /**
139      * @dev Moves `amount` tokens from `sender` to `recipient` using the
140      * allowance mechanism. `amount` is then deducted from the caller's
141      * allowance.
142      *
143      * Returns a boolean value indicating whether the operation succeeded.
144      *
145      * Emits a {Transfer} event.
146      */
147     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
148 
149     /**
150      * @dev Emitted when `value` tokens are moved from one account (`from`) to
151      * another (`to`).
152      *
153      * Note that `value` may be zero.
154      */
155     event Transfer(address indexed from, address indexed to, uint256 value);
156 
157     /**
158      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
159      * a call to {approve}. `value` is the new allowance.
160      */
161     event Approval(address indexed owner, address indexed spender, uint256 value);
162 }
163 
164 abstract contract ReentrancyGuard {
165     uint256 private constant _NOT_ENTERED = 1;
166     uint256 private constant _ENTERED = 2;
167     uint256 private _status;
168     constructor () {
169         _status = _NOT_ENTERED;
170     }
171 
172     modifier nonReentrant() {
173         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
174         _status = _ENTERED;
175         _;
176         _status = _NOT_ENTERED;
177     }
178 }
179 
180 /**
181  * @dev Required interface of an ERC721 compliant contract.
182  */
183 interface IERC721 {
184     /**
185      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
186      */
187     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
188 
189     /**
190      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
191      */
192     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
193 
194     /**
195      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
196      */
197     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
198 
199     /**
200      * @dev Returns the number of tokens in ``owner``'s account.
201      */
202     function balanceOf(address owner) external view returns (uint256 balance);
203 
204     /**
205      * @dev Returns the owner of the `tokenId` token.
206      *
207      * Requirements:
208      *
209      * - `tokenId` must exist.
210      */
211     function ownerOf(uint256 tokenId) external view returns (address owner);
212 
213     /**
214      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
215      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
216      *
217      * Requirements:
218      *
219      * - `from` cannot be the zero address.
220      * - `to` cannot be the zero address.
221      * - `tokenId` token must exist and be owned by `from`.
222      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
223      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
224      *
225      * Emits a {Transfer} event.
226      */
227     function safeTransferFrom(
228         address from,
229         address to,
230         uint256 tokenId
231     ) external;
232 
233     /**
234      * @dev Transfers `tokenId` token from `from` to `to`.
235      *
236      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
237      *
238      * Requirements:
239      *
240      * - `from` cannot be the zero address.
241      * - `to` cannot be the zero address.
242      * - `tokenId` token must be owned by `from`.
243      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
244      *
245      * Emits a {Transfer} event.
246      */
247     function transferFrom(
248         address from,
249         address to,
250         uint256 tokenId
251     ) external;
252 
253     /**
254      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
255      * The approval is cleared when the token is transferred.
256      *
257      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
258      *
259      * Requirements:
260      *
261      * - The caller must own the token or be an approved operator.
262      * - `tokenId` must exist.
263      *
264      * Emits an {Approval} event.
265      */
266     function approve(address to, uint256 tokenId) external;
267 
268     /**
269      * @dev Returns the account approved for `tokenId` token.
270      *
271      * Requirements:
272      *
273      * - `tokenId` must exist.
274      */
275     function getApproved(uint256 tokenId) external view returns (address operator);
276 
277     /**
278      * @dev Approve or remove `operator` as an operator for the caller.
279      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
280      *
281      * Requirements:
282      *
283      * - The `operator` cannot be the caller.
284      *
285      * Emits an {ApprovalForAll} event.
286      */
287     function setApprovalForAll(address operator, bool _approved) external;
288 
289     /**
290      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
291      *
292      * See {setApprovalForAll}
293      */
294     function isApprovedForAll(address owner, address operator) external view returns (bool);
295 
296     /**
297      * @dev Safely transfers `tokenId` token from `from` to `to`.
298      *
299      * Requirements:
300      *
301      * - `from` cannot be the zero address.
302      * - `to` cannot be the zero address.
303      * - `tokenId` token must exist and be owned by `from`.
304      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
305      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
306      *
307      * Emits a {Transfer} event.
308      */
309     function safeTransferFrom(
310         address from,
311         address to,
312         uint256 tokenId,
313         bytes calldata data
314     ) external;
315 }
316 
317 interface IERC721Metadata {
318     function tokenURI(uint256 tokenId) external view returns (string memory);
319 }
320 
321 contract NFTStakingData is ReentrancyGuard {
322 
323     uint256 internal constant PRECISION = 10**18;
324 
325     address public NFT;
326     address public rewardToken;
327     uint256 public lockTime;
328 
329     address public lockTimeSetter;
330 
331     uint256 public dividendsPerNFT;
332     uint256 public totalDividends;
333     uint256 public totalStaked;
334 
335     string public name;
336     string public symbol;
337 
338     struct UserInfo {
339         uint256[] tokenIds;
340         uint256 balance;
341         uint256 totalExcluded;
342         uint256 totalRewardsClaimed;
343     }
344 
345     struct StakedTokenId {
346         uint256 index;      // index in user token id array
347         uint256 timeLocked; // time the id was locked
348         address owner;
349     }
350 
351     mapping ( address => UserInfo ) public userInfo;
352     mapping ( uint256 => StakedTokenId ) public tokenInfo;
353 }
354 
355 contract NFTStaking is NFTStakingData, Cloneable, IERC721, IERC721Metadata {
356 
357     function __init__(
358         address NFT_,
359         address rewardToken_,
360         uint256 lockTime_,
361         string calldata name_,
362         string calldata symbol_,
363         address lockTimeSetter_
364     ) external {
365         require(
366             NFT_ != address(0) &&
367             NFT == address(0),
368             'Invalid Init'
369         );
370 
371         NFT = NFT_;
372         rewardToken = rewardToken_;
373         lockTime = lockTime_;
374         name = name_;
375         symbol = symbol_;
376         lockTimeSetter = lockTimeSetter_;
377     }
378 
379     function setLockTime(uint256 newLockTime) external nonReentrant {
380         require(
381             msg.sender == lockTimeSetter,
382             'Only Setter Can Call'
383         );
384         require(
385             newLockTime <= 10**7,
386             'Lock Time Too Long'
387         );
388         lockTime = newLockTime;
389     }
390 
391     function setLockTimeSetter(address newSetter) external nonReentrant {
392         require(
393             msg.sender == lockTimeSetter,
394             'Only Setter Can Call'
395         );
396         lockTimeSetter = newSetter;
397     }
398 
399     function stake(uint256 tokenId) external nonReentrant {
400         _stake(tokenId);
401     }
402 
403     function batchStake(uint256[] calldata tokenIds) external nonReentrant {
404         _batchStake(tokenIds);
405     }
406 
407     function withdraw(uint256 tokenId) external nonReentrant {
408         _withdraw(tokenId);
409     }
410 
411     function batchWithdraw(uint256[] calldata tokenIds) external nonReentrant {
412         _batchWithdraw(tokenIds);
413     }
414 
415     function claimRewards() external nonReentrant {
416         _claimRewards(msg.sender);
417     }
418 
419     function _stake(uint256 tokenId) internal {
420 
421         // ensure message sender is owner of nft
422         require(
423             isOwner(tokenId, msg.sender),
424             'Sender Not NFT Owner'
425         );
426         require(
427             tokenInfo[tokenId].owner == address(0),
428             'Already Staked'
429         );
430 
431         // claim rewards if applicable
432         _claimRewards(msg.sender);    
433 
434         // send nft to self
435         IERC721(NFT).transferFrom(msg.sender, address(this), tokenId);
436 
437         // ensure nft is now owned by `this`
438         require(
439             isOwner(tokenId, address(this)),
440             'NFT Ownership Not Transferred'
441         );
442 
443         // increment total staked and user balance
444         totalStaked++;
445         userInfo[msg.sender].balance++;
446 
447         // reset total rewards
448         userInfo[msg.sender].totalExcluded = getCumulativeDividends(userInfo[msg.sender].balance);
449         
450         // set current tokenId index to length of user id array
451         tokenInfo[tokenId].index = userInfo[msg.sender].tokenIds.length;
452         tokenInfo[tokenId].timeLocked = block.number;
453         tokenInfo[tokenId].owner = msg.sender;
454 
455         // push new token id to user id array
456         userInfo[msg.sender].tokenIds.push(tokenId);
457 
458         emit Transfer(address(0), msg.sender, tokenId);
459     }
460 
461     function _batchStake(uint256[] calldata tokenIds) internal {
462 
463         // claim rewards if applicable
464         _claimRewards(msg.sender);   
465 
466         // length of array
467         uint256 len = tokenIds.length; 
468 
469         for (uint i = 0; i < len;) {
470             // ensure message sender is owner of nft
471             require(
472                 isOwner(tokenIds[i], msg.sender),
473                 'Sender Not NFT Owner'
474             );
475             require(
476                 tokenInfo[tokenIds[i]].owner == address(0),
477                 'Already Staked'
478             );
479 
480             // send nft to self
481             IERC721(NFT).transferFrom(msg.sender, address(this), tokenIds[i]);
482 
483             // ensure nft is now owned by `this`
484             require(
485                 isOwner(tokenIds[i], address(this)),
486                 'NFT Ownership Not Transferred'
487             );
488 
489             // set current tokenId index to length of user id array
490             tokenInfo[tokenIds[i]].index = userInfo[msg.sender].tokenIds.length;
491             tokenInfo[tokenIds[i]].timeLocked = block.number;
492             tokenInfo[tokenIds[i]].owner = msg.sender;
493 
494             // push new token id to user id array
495             userInfo[msg.sender].tokenIds.push(tokenIds[i]);
496 
497             emit Transfer(address(0), msg.sender, tokenIds[i]);
498             unchecked { ++i; }
499         }
500 
501         // increment total staked and user balance
502         totalStaked += len;
503         userInfo[msg.sender].balance += len;
504 
505         // reset total rewards
506         userInfo[msg.sender].totalExcluded = getCumulativeDividends(userInfo[msg.sender].balance);
507     }
508 
509     function _withdraw(uint256 tokenId) internal {
510         require(
511             isOwner(tokenId, address(this)),
512             'NFT Is Not Staked'
513         );
514         require(
515             tokenInfo[tokenId].owner == msg.sender,
516             'Only Owner Can Withdraw'
517         );
518         require(
519             hasStakedNFT(msg.sender, tokenId),
520             'User Has Not Staked tokenId'
521         );
522         require(
523             timeUntilUnlock(tokenId) == 0,
524             'Token Still Locked'
525         );
526 
527         // claim pending rewards if any
528         _claimRewards(msg.sender);
529         
530         // decrement balance
531         userInfo[msg.sender].balance -= 1;
532         totalStaked -= 1;
533 
534         // reset total rewards
535         userInfo[msg.sender].totalExcluded = getCumulativeDividends(userInfo[msg.sender].balance);
536 
537         // remove nft from user array
538         _removeNFT(msg.sender, tokenId);
539         
540         // send nft to caller
541         IERC721(NFT).transferFrom(address(this), msg.sender, tokenId);
542 
543         emit Transfer(msg.sender, address(0), tokenId);
544     }
545 
546     function _batchWithdraw(uint256[] calldata tokenIds) internal {
547 
548         // claim pending rewards if any
549         _claimRewards(msg.sender);
550 
551         // length of array
552         uint256 len = tokenIds.length;
553 
554         // decrement balance
555         userInfo[msg.sender].balance -= len;
556         totalStaked -= len;
557 
558         // reset total rewards
559         userInfo[msg.sender].totalExcluded = getCumulativeDividends(userInfo[msg.sender].balance);
560 
561         for (uint i = 0; i < len;) {
562             
563             require(
564                 isOwner(tokenIds[i], address(this)),
565                 'NFT Is Not Staked'
566             );
567             require(
568                 hasStakedNFT(msg.sender, tokenIds[i]),
569                 'User Has Not Staked tokenId'
570             );
571             require(
572                 timeUntilUnlock(tokenIds[i]) == 0,
573                 'Token Still Locked'
574             );
575 
576             // remove nft from user array
577             _removeNFT(msg.sender, tokenIds[i]);
578 
579             // send nft to caller
580             IERC721(NFT).transferFrom(address(this), msg.sender, tokenIds[i]);
581 
582             // emit event
583             emit Transfer(msg.sender, address(0), tokenIds[i]);
584 
585             unchecked { ++i; }
586         }
587     }
588 
589     /**
590         Claims Reward For User
591      */
592     function _claimRewards(address user) internal {
593 
594         // return if zero balance
595         if (userInfo[user].balance == 0) {
596             return;
597         }
598 
599         // fetch pending rewards
600         uint pending = pendingRewards(user);
601         uint max = rewardBalanceOf();
602         if (pending > max) {
603             pending = max;
604         }
605         
606         // reset total rewards
607         userInfo[user].totalExcluded = getCumulativeDividends(userInfo[user].balance);
608 
609         // return if no rewards
610         if (pending == 0) {
611             return;
612         }
613 
614         // incremenet total rewards claimed
615         unchecked {
616             userInfo[user].totalRewardsClaimed += pending;
617         }
618 
619         // transfer reward to user
620         require(
621             IERC20(rewardToken).transfer(
622                 user,
623                 pending
624             ),
625             'Failure Reward Transfer'
626         );
627     }
628 
629     /**
630         Pending Token Rewards For `account`
631      */
632     function pendingRewards(address account) public view returns (uint256) {
633         if(userInfo[account].balance == 0){ return 0; }
634 
635         uint256 accountTotalDividends = getCumulativeDividends(userInfo[account].balance);
636         uint256 accountTotalExcluded = userInfo[account].totalExcluded;
637 
638         if(accountTotalDividends <= accountTotalExcluded){ return 0; }
639 
640         return accountTotalDividends - accountTotalExcluded;
641     }
642 
643     /**
644         Cumulative Dividends For A Number Of Tokens
645      */
646     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
647         return (share * dividendsPerNFT) / PRECISION;
648     }
649 
650     function giveRewards(uint256 amount) external {
651         
652         uint balBefore = rewardBalanceOf();
653         IERC20(rewardToken).transferFrom(
654             msg.sender,
655             address(this),
656             amount
657         );
658         uint balAfter = rewardBalanceOf();
659         require(
660             balAfter > balBefore,
661             'Zero Rewards'
662         );
663 
664         uint received = balAfter - balBefore;
665 
666         totalDividends += received;
667         dividendsPerNFT += ( received * PRECISION ) / totalStaked;
668     }
669 
670     function _removeNFT(address user, uint256 tokenId) internal {
671         
672         uint lastElement = userInfo[user].tokenIds[userInfo[user].tokenIds.length - 1];
673         uint removeIndex = tokenInfo[tokenId].index;
674 
675         userInfo[user].tokenIds[removeIndex] = lastElement;
676         tokenInfo[lastElement].index = removeIndex;
677         userInfo[user].tokenIds.pop();
678 
679         delete tokenInfo[tokenId];
680     }
681 
682     function timeUntilUnlock(uint256 tokenId) public view returns (uint256) {
683         uint unlockTime = tokenInfo[tokenId].timeLocked + lockTime;
684         return unlockTime <= block.number ? 0 : unlockTime - block.number;
685     }
686 
687     function isOwner(uint256 tokenId, address user) public view returns (bool) {
688         return IERC721(NFT).ownerOf(tokenId) == user;
689     }
690 
691     function listUserStakedNFTs(address user) public view returns (uint256[] memory) {
692         return userInfo[user].tokenIds;
693     }
694 
695     function fetchBalancePendingAndTotalRewards(address user) public view returns (uint256, uint256, uint256) {
696         return (userInfo[user].balance, pendingRewards(user), userInfo[user].totalRewardsClaimed);
697     }
698     
699     function listUserStakedNFTsAndURIs(address user) public view returns (uint256[] memory, string[] memory) {
700         
701         uint len = userInfo[user].tokenIds.length;
702         string[] memory uris = new string[](len);
703         for (uint i = 0; i < len;) {
704             uris[i] = IERC721Metadata(NFT).tokenURI(userInfo[user].tokenIds[i]);
705             unchecked {
706                 ++i;
707             }
708         }
709         return (userInfo[user].tokenIds, uris);
710     }
711 
712     function listUserStakedNFTsURIsAndRemainingLockTimes(address user) public view returns (
713         uint256[] memory, 
714         string[] memory,
715         uint256[] memory
716     ) {
717         
718         uint len = userInfo[user].tokenIds.length;
719         string[] memory uris = new string[](len);
720         uint256[] memory remainingLocks = new uint256[](len);
721         for (uint i = 0; i < len;) {
722             uris[i] = IERC721Metadata(NFT).tokenURI(userInfo[user].tokenIds[i]);
723             remainingLocks[i] = timeUntilUnlock(userInfo[user].tokenIds[i]);
724             unchecked {
725                 ++i;
726             }
727         }
728         return (userInfo[user].tokenIds, uris, remainingLocks);
729     }
730 
731     function listUserTotalNFTs(address user, uint min, uint max) public view returns (uint256[] memory) {
732         
733         IERC721 NFT_ = IERC721(NFT);
734         uint len = NFT_.balanceOf(user);
735 
736         uint256[] memory ids = new uint256[](len);
737         uint count = 0;
738 
739         for (uint i = min; i < max;) {
740 
741             if (NFT_.ownerOf(i) == user) {
742                 ids[count] = i;
743                 count++;
744             }
745             
746             unchecked {++i;}
747         }
748         return (ids);
749     }
750 
751     function listUserTotalNFTsAndUris(address user, uint min, uint max) public view returns (uint256[] memory, string[] memory) {
752         
753         IERC721 NFT_ = IERC721(NFT);
754         uint len = NFT_.balanceOf(user);
755 
756         uint256[] memory ids = new uint256[](len);
757         string[] memory uris = new string[](len);
758         uint count = 0;
759 
760         for (uint i = min; i < max;) {
761 
762             if (NFT_.ownerOf(i) == user) {
763                 ids[count] = i;
764                 uris[count] = IERC721Metadata(NFT).tokenURI(i);
765                 count++;
766             }
767             
768             unchecked {++i;}
769         }
770         return (ids, uris);
771     }
772 
773     function hasStakedNFT(address user, uint256 tokenId) public view returns (bool) {
774         if (userInfo[user].tokenIds.length <= tokenInfo[tokenId].index || tokenInfo[tokenId].owner != user) {
775             return false;
776         }
777         return userInfo[user].tokenIds[tokenInfo[tokenId].index] == tokenId;
778     }
779 
780     function hasStakedNFTs(address user, uint256[] calldata tokenId) public view returns (bool[] memory) {
781         uint len = tokenId.length;
782         bool[] memory hasStaked = new bool[](len);
783         for (uint i = 0; i < len;) {
784             hasStaked[i] = userInfo[user].tokenIds[tokenInfo[tokenId[i]].index] == tokenId[i];
785             unchecked {
786                 ++i;
787             }
788         }
789         return hasStaked;
790     }
791 
792     function rewardBalanceOf() public view returns (uint256) {
793         return IERC20(rewardToken).balanceOf(address(this));
794     }
795 
796     function totalSupply() public view returns (uint256) {
797         return IERC721(NFT).balanceOf(address(this));
798     }
799 
800     /**
801      * @dev Returns the number of tokens in ``owner``'s account.
802      */
803     function balanceOf(address owner) external view override returns (uint256 balance) {
804         return userInfo[owner].balance;
805     }
806 
807     /**
808      * @dev Returns the owner of the `tokenId` token.
809      *
810      * Requirements:
811      *
812      * - `tokenId` must exist.
813      */
814     function ownerOf(uint256 tokenId) external view override returns (address owner) {
815         return tokenInfo[tokenId].owner;
816     }
817 
818     /**
819      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
820      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
821      *
822      * Requirements:
823      *
824      * - `from` cannot be the zero address.
825      * - `to` cannot be the zero address.
826      * - `tokenId` token must exist and be owned by `from`.
827      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
828      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
829      *
830      * Emits a {Transfer} event.
831      */
832     function safeTransferFrom(
833         address,
834         address,
835         uint256
836     ) external override {
837 
838     }
839 
840     /**
841      * @dev Transfers `tokenId` token from `from` to `to`.
842      *
843      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
844      *
845      * Requirements:
846      *
847      * - `from` cannot be the zero address.
848      * - `to` cannot be the zero address.
849      * - `tokenId` token must be owned by `from`.
850      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
851      *
852      * Emits a {Transfer} event.
853      */
854     function transferFrom(
855         address,
856         address,
857         uint256
858     ) external override {
859 
860     }
861 
862     /**
863      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
864      * The approval is cleared when the token is transferred.
865      *
866      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
867      *
868      * Requirements:
869      *
870      * - The caller must own the token or be an approved operator.
871      * - `tokenId` must exist.
872      *
873      * Emits an {Approval} event.
874      */
875     function approve(address, uint256) external override {
876         emit Approval(address(0), address(0), 0);
877         return;
878     }
879 
880     /**
881      * @dev Returns the account approved for `tokenId` token.
882      *
883      * Requirements:
884      *
885      * - `tokenId` must exist.
886      */
887     function getApproved(uint256 a) external view override returns (address operator) {
888         return a == uint(uint160(msg.sender)) ? address(0) : msg.sender;
889     }
890 
891     /**
892      * @dev Approve or remove `operator` as an operator for the caller.
893      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
894      *
895      * Requirements:
896      *
897      * - The `operator` cannot be the caller.
898      *
899      * Emits an {ApprovalForAll} event.
900      */
901     function setApprovalForAll(address, bool) external override {
902         emit Approval(address(0), address(0), 0);
903         return;
904     }
905 
906     function isApprovedForAll(address a, address b) external view override returns (bool) {
907         return a == b && a == NFT;
908     }
909 
910     /**
911      * @dev Safely transfers `tokenId` token from `from` to `to`.
912      *
913      * Requirements:
914      *
915      * - `from` cannot be the zero address.
916      * - `to` cannot be the zero address.
917      * - `tokenId` token must exist and be owned by `from`.
918      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
919      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
920      *
921      * Emits a {Transfer} event.
922      */
923     function safeTransferFrom(
924         address,
925         address,
926         uint256,
927         bytes calldata
928     ) external override {
929 
930     }
931 
932     function tokenURI(uint256 tokenId) external view override returns (string memory) {
933         return IERC721Metadata(NFT).tokenURI(tokenId);
934     }
935 
936 }