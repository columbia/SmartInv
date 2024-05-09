1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 library SafeMath {
6     /**
7      * @dev Returns the addition of two unsigned integers, reverting on
8      * overflow.
9      *
10      * Counterpart to Solidity's `+` operator.
11      *
12      * Requirements:
13      *
14      * - Addition cannot overflow.
15      */
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         require(c >= a, "SafeMath: addition overflow");
19 
20         return c;
21     }
22 
23     /**
24      * @dev Returns the subtraction of two unsigned integers, reverting on
25      * overflow (when the result is negative).
26      *
27      * Counterpart to Solidity's `-` operator.
28      *
29      * Requirements:
30      *
31      * - Subtraction cannot overflow.
32      */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         return sub(a, b, "SafeMath: subtraction overflow");
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      *
45      * - Subtraction cannot overflow.
46      */
47     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         require(b <= a, errorMessage);
49         uint256 c = a - b;
50 
51         return c;
52     }
53 
54     /**
55      * @dev Returns the multiplication of two unsigned integers, reverting on
56      * overflow.
57      *
58      * Counterpart to Solidity's `*` operator.
59      *
60      * Requirements:
61      *
62      * - Multiplication cannot overflow.
63      */
64     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
66         // benefit is lost if 'b' is also tested.
67         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
68         if (a == 0) {
69             return 0;
70         }
71 
72         uint256 c = a * b;
73         require(c / a == b, "SafeMath: multiplication overflow");
74 
75         return c;
76     }
77 
78     /**
79      * @dev Returns the integer division of two unsigned integers. Reverts on
80      * division by zero. The result is rounded towards zero.
81      *
82      * Counterpart to Solidity's `/` operator. Note: this function uses a
83      * `revert` opcode (which leaves remaining gas untouched) while Solidity
84      * uses an invalid opcode to revert (consuming all remaining gas).
85      *
86      * Requirements:
87      *
88      * - The divisor cannot be zero.
89      */
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         return div(a, b, "SafeMath: division by zero");
92     }
93 
94     /**
95      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
96      * division by zero. The result is rounded towards zero.
97      *
98      * Counterpart to Solidity's `/` operator. Note: this function uses a
99      * `revert` opcode (which leaves remaining gas untouched) while Solidity
100      * uses an invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      *
104      * - The divisor cannot be zero.
105      */
106     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
107         require(b > 0, errorMessage);
108         uint256 c = a / b;
109         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
116      * Reverts when dividing by zero.
117      *
118      * Counterpart to Solidity's `%` operator. This function uses a `revert`
119      * opcode (which leaves remaining gas untouched) while Solidity uses an
120      * invalid opcode to revert (consuming all remaining gas).
121      *
122      * Requirements:
123      *
124      * - The divisor cannot be zero.
125      */
126     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
127         return mod(a, b, "SafeMath: modulo by zero");
128     }
129 
130     /**
131      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
132      * Reverts with custom message when dividing by zero.
133      *
134      * Counterpart to Solidity's `%` operator. This function uses a `revert`
135      * opcode (which leaves remaining gas untouched) while Solidity uses an
136      * invalid opcode to revert (consuming all remaining gas).
137      *
138      * Requirements:
139      *
140      * - The divisor cannot be zero.
141      */
142     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b != 0, errorMessage);
144         return a % b;
145     }
146 }
147 
148 /**
149  * @dev Provides information about the current execution context, including the
150  * sender of the transaction and its data. While these are generally available
151  * via msg.sender and msg.data, they should not be accessed in such a direct
152  * manner, since when dealing with meta-transactions the account sending and
153  * paying for execution may not be the actual sender (as far as an application
154  * is concerned).
155  *
156  * This contract is only required for intermediate, library-like contracts.
157  */
158 abstract contract Context {
159     function _msgSender() internal view virtual returns (address) {
160         return msg.sender;
161     }
162 
163     function _msgData() internal view virtual returns (bytes calldata) {
164         return msg.data;
165     }
166 }
167 
168 /**
169  * @dev Contract module which provides a basic access control mechanism, where
170  * there is an account (an owner) that can be granted exclusive access to
171  * specific functions.
172  *
173  * By default, the owner account will be the one that deploys the contract. This
174  * can later be changed with {transferOwnership}.
175  *
176  * This module is used through inheritance. It will make available the modifier
177  * `onlyOwner`, which can be applied to your functions to restrict their use to
178  * the owner.
179  */
180 abstract contract Ownable is Context {
181     address private _owner;
182 
183     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
184 
185     /**
186      * @dev Initializes the contract setting the deployer as the initial owner.
187      */
188     constructor() {
189         _setOwner(_msgSender());
190     }
191 
192     /**
193      * @dev Returns the address of the current owner.
194      */
195     function owner() public view virtual returns (address) {
196         return _owner;
197     }
198 
199     /**
200      * @dev Throws if called by any account other than the owner.
201      */
202     modifier onlyOwner() {
203         require(owner() == _msgSender(), "Ownable: caller is not the owner");
204         _;
205     }
206 
207     /**
208      * @dev Leaves the contract without owner. It will not be possible to call
209      * `onlyOwner` functions anymore. Can only be called by the current owner.
210      *
211      * NOTE: Renouncing ownership will leave the contract without an owner,
212      * thereby removing any functionality that is only available to the owner.
213      */
214     function renounceOwnership() public virtual onlyOwner {
215         _setOwner(address(0));
216     }
217 
218     /**
219      * @dev Transfers ownership of the contract to a new account (`newOwner`).
220      * Can only be called by the current owner.
221      */
222     function transferOwnership(address newOwner) public virtual onlyOwner {
223         require(newOwner != address(0), "Ownable: new owner is the zero address");
224         _setOwner(newOwner);
225     }
226 
227     function _setOwner(address newOwner) private {
228         address oldOwner = _owner;
229         _owner = newOwner;
230         emit OwnershipTransferred(oldOwner, newOwner);
231     }
232 }
233 
234 /**
235  * @dev Interface of the ERC20 standard as defined in the EIP.
236  */
237 interface IERC20 {
238     /**
239      * @dev Returns the amount of tokens in existence.
240      */
241     function totalSupply() external view returns (uint256);
242 
243     /**
244      * @dev Returns the amount of tokens owned by `account`.
245      */
246     function balanceOf(address account) external view returns (uint256);
247 
248     /**
249      * @dev Moves `amount` tokens from the caller's account to `recipient`.
250      *
251      * Returns a boolean value indicating whether the operation succeeded.
252      *
253      * Emits a {Transfer} event.
254      */
255     function transfer(address recipient, uint256 amount) external returns (bool);
256 
257     /**
258      * @dev Returns the remaining number of tokens that `spender` will be
259      * allowed to spend on behalf of `owner` through {transferFrom}. This is
260      * zero by default.
261      *
262      * This value changes when {approve} or {transferFrom} are called.
263      */
264     function allowance(address owner, address spender) external view returns (uint256);
265 
266     /**
267      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
268      *
269      * Returns a boolean value indicating whether the operation succeeded.
270      *
271      * IMPORTANT: Beware that changing an allowance with this method brings the risk
272      * that someone may use both the old and the new allowance by unfortunate
273      * transaction ordering. One possible solution to mitigate this race
274      * condition is to first reduce the spender's allowance to 0 and set the
275      * desired value afterwards:
276      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
277      *
278      * Emits an {Approval} event.
279      */
280     function approve(address spender, uint256 amount) external returns (bool);
281 
282     /**
283      * @dev Moves `amount` tokens from `sender` to `recipient` using the
284      * allowance mechanism. `amount` is then deducted from the caller's
285      * allowance.
286      *
287      * Returns a boolean value indicating whether the operation succeeded.
288      *
289      * Emits a {Transfer} event.
290      */
291     function transferFrom(
292         address sender,
293         address recipient,
294         uint256 amount
295     ) external returns (bool);
296 
297     /**
298      * @dev Emitted when `value` tokens are moved from one account (`from`) to
299      * another (`to`).
300      *
301      * Note that `value` may be zero.
302      */
303     event Transfer(address indexed from, address indexed to, uint256 value);
304 
305     /**
306      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
307      * a call to {approve}. `value` is the new allowance.
308      */
309     event Approval(address indexed owner, address indexed spender, uint256 value);
310 }
311 
312 /**
313  * @dev Interface for the optional metadata functions from the ERC20 standard.
314  *
315  * _Available since v4.1._
316  */
317 interface IERC20Metadata is IERC20 {
318     /**
319      * @dev Returns the name of the token.
320      */
321     function name() external view returns (string memory);
322 
323     /**
324      * @dev Returns the symbol of the token.
325      */
326     function symbol() external view returns (string memory);
327 
328     /**
329      * @dev Returns the decimals places of the token.
330      */
331     function decimals() external view returns (uint8);
332 }
333 
334 interface I$LOBE is IERC20, IERC20Metadata {
335     function mint(address to, uint256 amount) external;
336 }
337 
338 interface IERC165 {
339     /**
340      * @dev Returns true if this contract implements the interface defined by
341      * `interfaceId`. See the corresponding
342      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
343      * to learn more about how these ids are created.
344      *
345      * This function call must use less than 30 000 gas.
346      */
347     function supportsInterface(bytes4 interfaceId) external view returns (bool);
348 }
349 
350 interface IERC721 is IERC165 {
351     /**
352      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
353      */
354     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
355 
356     /**
357      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
358      */
359     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
360 
361     /**
362      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
363      */
364     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
365 
366     /**
367      * @dev Returns the number of tokens in ``owner``'s account.
368      */
369     function balanceOf(address owner) external view returns (uint256 balance);
370 
371     /**
372      * @dev Returns the owner of the `tokenId` token.
373      *
374      * Requirements:
375      *
376      * - `tokenId` must exist.
377      */
378     function ownerOf(uint256 tokenId) external view returns (address owner);
379 
380     /**
381      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
382      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
383      *
384      * Requirements:
385      *
386      * - `from` cannot be the zero address.
387      * - `to` cannot be the zero address.
388      * - `tokenId` token must exist and be owned by `from`.
389      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
390      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
391      *
392      * Emits a {Transfer} event.
393      */
394     function safeTransferFrom(
395         address from,
396         address to,
397         uint256 tokenId
398     ) external;
399 
400     /**
401      * @dev Transfers `tokenId` token from `from` to `to`.
402      *
403      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
404      *
405      * Requirements:
406      *
407      * - `from` cannot be the zero address.
408      * - `to` cannot be the zero address.
409      * - `tokenId` token must be owned by `from`.
410      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
411      *
412      * Emits a {Transfer} event.
413      */
414     function transferFrom(
415         address from,
416         address to,
417         uint256 tokenId
418     ) external;
419 
420     /**
421      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
422      * The approval is cleared when the token is transferred.
423      *
424      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
425      *
426      * Requirements:
427      *
428      * - The caller must own the token or be an approved operator.
429      * - `tokenId` must exist.
430      *
431      * Emits an {Approval} event.
432      */
433     function approve(address to, uint256 tokenId) external;
434 
435     /**
436      * @dev Returns the account approved for `tokenId` token.
437      *
438      * Requirements:
439      *
440      * - `tokenId` must exist.
441      */
442     function getApproved(uint256 tokenId) external view returns (address operator);
443     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
444     /**
445      * @dev Approve or remove `operator` as an operator for the caller.
446      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
447      *
448      * Requirements:
449      *
450      * - The `operator` cannot be the caller.
451      *
452      * Emits an {ApprovalForAll} event.
453      */
454     function setApprovalForAll(address operator, bool _approved) external;
455 
456     /**
457      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
458      *
459      * See {setApprovalForAll}
460      */
461     function isApprovedForAll(address owner, address operator) external view returns (bool);
462 
463     /**
464      * @dev Safely transfers `tokenId` token from `from` to `to`.
465      *
466      * Requirements:
467      *
468      * - `from` cannot be the zero address.
469      * - `to` cannot be the zero address.
470      * - `tokenId` token must exist and be owned by `from`.
471      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
472      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
473      *
474      * Emits a {Transfer} event.
475      */
476     function safeTransferFrom(
477         address from,
478         address to,
479         uint256 tokenId,
480         bytes calldata data
481     ) external;
482 }
483 
484 interface IERC721Receiver {
485     /**
486      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
487      * by `operator` from `from`, this function is called.
488      *
489      * It must return its Solidity selector to confirm the token transfer.
490      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
491      *
492      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
493      */
494     function onERC721Received(
495         address operator,
496         address from,
497         uint256 tokenId,
498         bytes calldata data
499     ) external returns (bytes4);
500 }
501 
502 abstract contract ReentrancyGuard {
503     // Booleans are more expensive than uint256 or any type that takes up a full
504     // word because each write operation emits an extra SLOAD to first read the
505     // slot's contents, replace the bits taken up by the boolean, and then write
506     // back. This is the compiler's defense against contract upgrades and
507     // pointer aliasing, and it cannot be disabled.
508 
509     // The values being non-zero value makes deployment a bit more expensive,
510     // but in exchange the refund on every call to nonReentrant will be lower in
511     // amount. Since refunds are capped to a percentage of the total
512     // transaction's gas, it is best to keep them low in cases like this one, to
513     // increase the likelihood of the full refund coming into effect.
514     uint256 private constant _NOT_ENTERED = 1;
515     uint256 private constant _ENTERED = 2;
516 
517     uint256 private _status;
518 
519     constructor() {
520         _status = _NOT_ENTERED;
521     }
522 
523     /**
524      * @dev Prevents a contract from calling itself, directly or indirectly.
525      * Calling a `nonReentrant` function from another `nonReentrant`
526      * function is not supported. It is possible to prevent this from happening
527      * by making the `nonReentrant` function external, and make it call a
528      * `private` function that does the actual work.
529      */
530     modifier nonReentrant() {
531         // On the first call to nonReentrant, _notEntered will be true
532         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
533 
534         // Any calls to nonReentrant after this point will fail
535         _status = _ENTERED;
536 
537         _;
538 
539         // By storing the original value once again, a refund is triggered (see
540         // https://eips.ethereum.org/EIPS/eip-2200)
541         _status = _NOT_ENTERED;
542     }
543 }
544 
545 contract NoBrainerStaking is Ownable, IERC721Receiver, ReentrancyGuard {
546     using SafeMath for uint256;
547 
548     I$LOBE public rewardsTokenContract;  // interface for $LOBE contract
549     IERC721 public stakeNFTContract;     // interface for NoBrainer
550 
551     uint256 public startTimestamp;   // staking start timestamp
552     mapping(address=>uint256) public lastUpdateTimestamp;    // last update timestamp for an address
553 
554     uint256 public rate = 100 ether;  // staking reward rate per day   100 * 10 ** 18   
555 
556     mapping(address=>uint256) public NFTbalanceForAddress;   // NoBrainer balance for an address
557     mapping(address=>uint256) private claimableForAddress;   // accumulated claimable balance before lastUpdateTmestap for an address
558 
559     mapping(uint256=>address) public NFTtokenOwnerForId;     //  NoBrainer owner address for tokenId already staked
560     mapping(address=>uint256[]) public NFTtokenIdsStakedForAddress;   // get list of staked tokenId list for an address
561 
562     uint256 public totalNFTstaked;                           // total NoBrainer staked
563     uint256 public totalRewardClaimed;                       // total reward claimed  (mint from $LOBE)
564     mapping(address=>uint256) public totalRewardClaimedForAddress;        // total reward claimed for an address (mint from $LOBE)
565 
566     // modifier for check if staking is started
567     modifier hasStarted() {
568         require(startTimestamp != 0, "NftStaking: staking not started");
569         _;
570     }
571 
572     modifier hasNotStarted() {
573         require(startTimestamp == 0, "NftStaking: staking has started");
574         _;
575     }
576 
577     event Started();
578     event NftStaked(address staker, uint256 tokenId);
579     event NftUnstaked(address staker, uint256 tokenId);
580     event RewardsClaimed(address staker, uint256 amount);
581 
582     constructor (address nftContract, address rewardContract) {
583         stakeNFTContract = IERC721(nftContract);
584         rewardsTokenContract = I$LOBE(rewardContract);
585     }
586 
587     // start staking
588     function start() public onlyOwner hasNotStarted {
589         startTimestamp = block.timestamp;
590         emit Started();
591     }
592 
593     // in case for update Nobrainer or $LOBE address
594     function updateContractAddress(address nftContract, address rewardContract) public onlyOwner {
595         stakeNFTContract = IERC721(nftContract);
596         rewardsTokenContract = I$LOBE(rewardContract);
597     }
598 
599     // update staking reward rate
600     function updateRate (uint256 _rate) public onlyOwner {
601         rate = _rate;
602     }
603 
604     // important!!!    in case NoBrainer recieved to staking contract for stake,  user must send it as safetransferfrom to call this function.
605     function onERC721Received(
606         address ,
607         address from,
608         uint256 tokenId,
609         bytes calldata 
610     ) external override returns (bytes4){
611         _stakeNFT(tokenId, from);
612         return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
613     }
614 
615     // get total claimable amount, updates everytime calling this function
616     function getClaimableAmount(address account) public view returns (uint256) {
617         return claimableForAddress[account] + ((block.timestamp - lastUpdateTimestamp[account]).mul(NFTbalanceForAddress[account]).mul(rate).div(1 days));
618     }
619 
620     // list NFT ids staked by address
621 
622     function listNFTStaked(address addr) public view returns (uint256 [] memory) {
623         return NFTtokenIdsStakedForAddress[addr];
624     }
625 
626     // stake NFT
627     function _stakeNFT(uint256 id, address from) internal hasStarted {
628         require(address(stakeNFTContract) == msg.sender, "NftStaking: not correct NFT staked!");
629         claimableForAddress[from] = getClaimableAmount(from);
630         NFTbalanceForAddress[from] = NFTbalanceForAddress[from].add(1);
631         totalNFTstaked = totalNFTstaked.add(1);
632         lastUpdateTimestamp[from] = block.timestamp;
633         NFTtokenOwnerForId[id] = from;
634         NFTtokenIdsStakedForAddress[from].push(id);
635         emit NftStaked(from, id);
636     }
637 
638     // list NFT by address
639 
640     function listNFT(address addr) public view returns (uint256 [] memory) {
641         uint256 tokenCount = stakeNFTContract.balanceOf(addr);
642         uint256[] memory tokensId;
643         if (tokenCount == 0) {
644             return new uint256[](0);
645     	}
646     	else {
647     		tokensId = new uint256[](tokenCount);
648             for(uint256 i = 0; i < tokenCount; i++){
649                 tokensId[i] = stakeNFTContract.tokenOfOwnerByIndex(addr, i);
650             }            
651     	}
652         return tokensId;
653     }
654 
655     // batch stake NFT
656     function batchStakeNFT() external hasStarted {        
657         uint256[] memory tokensId = listNFT(msg.sender);        
658         for (uint256 i=0; i < tokensId.length; i ++){
659             stakeNFTContract.safeTransferFrom(msg.sender, address(this), tokensId[i]);
660         }
661     }
662 
663     // unstake NFT, transfer back nft to original owner
664     function unstakeNft(uint256 id) public hasStarted {        
665         require(NFTtokenOwnerForId[id] == msg.sender, "NftStaking: token not staked or incorrect token owner!");
666         NFTtokenOwnerForId[id] = address(0);
667         claimableForAddress[msg.sender] = getClaimableAmount(msg.sender);        
668         NFTbalanceForAddress[msg.sender] = NFTbalanceForAddress[msg.sender].sub(1);
669         totalNFTstaked = totalNFTstaked.sub(1);
670         lastUpdateTimestamp[msg.sender] = block.timestamp;
671         for (uint i = 0; i < NFTtokenIdsStakedForAddress[msg.sender].length; i ++){
672             if (NFTtokenIdsStakedForAddress[msg.sender][i] == id){
673                 NFTtokenIdsStakedForAddress[msg.sender][i] = NFTtokenIdsStakedForAddress[msg.sender][NFTtokenIdsStakedForAddress[msg.sender].length - 1];
674                 break;
675             }
676         }
677         NFTtokenIdsStakedForAddress[msg.sender].pop();
678         try stakeNFTContract.safeTransferFrom(address(this), msg.sender, id)  {} catch {            
679             stakeNFTContract.transferFrom(address(this), msg.sender, id);
680         }
681         emit NftUnstaked(msg.sender, id);
682     }
683 
684     // batch unstake all NFT for msg.sender
685     function unstakeAllNFTForAddress() external hasStarted {
686         require(NFTtokenIdsStakedForAddress[msg.sender].length > 0, "NftStaing: Caller doesn't have any staked token!");
687         uint256 count = NFTtokenIdsStakedForAddress[msg.sender].length;
688         for(uint i = 0; i < count; i ++){
689             unstakeNft(NFTtokenIdsStakedForAddress[msg.sender][0]);
690         }
691     }
692 
693     // claim reward for stake holers
694     function claimReward() external hasStarted {
695         uint256 claimAmount = getClaimableAmount(msg.sender);
696         require(claimAmount > 0, "NftStaking: no claimable balance!");
697         claimableForAddress[msg.sender] = 0;
698         lastUpdateTimestamp[msg.sender] = block.timestamp;
699         rewardsTokenContract.mint(msg.sender, claimAmount);
700         totalRewardClaimed = totalRewardClaimed.add(claimAmount);
701         totalRewardClaimedForAddress[msg.sender] = totalRewardClaimedForAddress[msg.sender].add(claimAmount);
702         emit RewardsClaimed(msg.sender, claimAmount);
703     }
704 }