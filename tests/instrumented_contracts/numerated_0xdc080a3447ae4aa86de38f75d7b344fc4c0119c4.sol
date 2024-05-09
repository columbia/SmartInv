1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/access/Ownable.sol
28 
29 
30 
31 pragma solidity ^0.8.0;
32 
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         _setOwner(_msgSender());
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(owner() == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         _setOwner(address(0));
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         _setOwner(newOwner);
91     }
92 
93     function _setOwner(address newOwner) private {
94         address oldOwner = _owner;
95         _owner = newOwner;
96         emit OwnershipTransferred(oldOwner, newOwner);
97     }
98 }
99 
100 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
101 
102 
103 
104 pragma solidity ^0.8.0;
105 
106 /**
107  * @dev Interface of the ERC20 standard as defined in the EIP.
108  */
109 interface IERC20 {
110     /**
111      * @dev Returns the amount of tokens in existence.
112      */
113     function totalSupply() external view returns (uint256);
114 
115     /**
116      * @dev Returns the amount of tokens owned by `account`.
117      */
118     function balanceOf(address account) external view returns (uint256);
119 
120     /**
121      * @dev Moves `amount` tokens from the caller's account to `recipient`.
122      *
123      * Returns a boolean value indicating whether the operation succeeded.
124      *
125      * Emits a {Transfer} event.
126      */
127     function transfer(address recipient, uint256 amount) external returns (bool);
128 
129     /**
130      * @dev Returns the remaining number of tokens that `spender` will be
131      * allowed to spend on behalf of `owner` through {transferFrom}. This is
132      * zero by default.
133      *
134      * This value changes when {approve} or {transferFrom} are called.
135      */
136     function allowance(address owner, address spender) external view returns (uint256);
137 
138     /**
139      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * IMPORTANT: Beware that changing an allowance with this method brings the risk
144      * that someone may use both the old and the new allowance by unfortunate
145      * transaction ordering. One possible solution to mitigate this race
146      * condition is to first reduce the spender's allowance to 0 and set the
147      * desired value afterwards:
148      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
149      *
150      * Emits an {Approval} event.
151      */
152     function approve(address spender, uint256 amount) external returns (bool);
153 
154     /**
155      * @dev Moves `amount` tokens from `sender` to `recipient` using the
156      * allowance mechanism. `amount` is then deducted from the caller's
157      * allowance.
158      *
159      * Returns a boolean value indicating whether the operation succeeded.
160      *
161      * Emits a {Transfer} event.
162      */
163     function transferFrom(
164         address sender,
165         address recipient,
166         uint256 amount
167     ) external returns (bool);
168 
169     /**
170      * @dev Emitted when `value` tokens are moved from one account (`from`) to
171      * another (`to`).
172      *
173      * Note that `value` may be zero.
174      */
175     event Transfer(address indexed from, address indexed to, uint256 value);
176 
177     /**
178      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
179      * a call to {approve}. `value` is the new allowance.
180      */
181     event Approval(address indexed owner, address indexed spender, uint256 value);
182 }
183 
184 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
185 
186 
187 
188 pragma solidity ^0.8.0;
189 
190 /**
191  * @dev Interface of the ERC165 standard, as defined in the
192  * https://eips.ethereum.org/EIPS/eip-165[EIP].
193  *
194  * Implementers can declare support of contract interfaces, which can then be
195  * queried by others ({ERC165Checker}).
196  *
197  * For an implementation, see {ERC165}.
198  */
199 interface IERC165 {
200     /**
201      * @dev Returns true if this contract implements the interface defined by
202      * `interfaceId`. See the corresponding
203      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
204      * to learn more about how these ids are created.
205      *
206      * This function call must use less than 30 000 gas.
207      */
208     function supportsInterface(bytes4 interfaceId) external view returns (bool);
209 }
210 
211 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
212 
213 
214 
215 pragma solidity ^0.8.0;
216 
217 
218 /**
219  * @dev Required interface of an ERC721 compliant contract.
220  */
221 interface IERC721 is IERC165 {
222     /**
223      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
224      */
225     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
226 
227     /**
228      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
229      */
230     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
231 
232     /**
233      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
234      */
235     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
236 
237     /**
238      * @dev Returns the number of tokens in ``owner``'s account.
239      */
240     function balanceOf(address owner) external view returns (uint256 balance);
241 
242     /**
243      * @dev Returns the owner of the `tokenId` token.
244      *
245      * Requirements:
246      *
247      * - `tokenId` must exist.
248      */
249     function ownerOf(uint256 tokenId) external view returns (address owner);
250 
251     /**
252      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
253      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
254      *
255      * Requirements:
256      *
257      * - `from` cannot be the zero address.
258      * - `to` cannot be the zero address.
259      * - `tokenId` token must exist and be owned by `from`.
260      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
261      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
262      *
263      * Emits a {Transfer} event.
264      */
265     function safeTransferFrom(
266         address from,
267         address to,
268         uint256 tokenId
269     ) external;
270 
271     /**
272      * @dev Transfers `tokenId` token from `from` to `to`.
273      *
274      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
275      *
276      * Requirements:
277      *
278      * - `from` cannot be the zero address.
279      * - `to` cannot be the zero address.
280      * - `tokenId` token must be owned by `from`.
281      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
282      *
283      * Emits a {Transfer} event.
284      */
285     function transferFrom(
286         address from,
287         address to,
288         uint256 tokenId
289     ) external;
290 
291     /**
292      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
293      * The approval is cleared when the token is transferred.
294      *
295      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
296      *
297      * Requirements:
298      *
299      * - The caller must own the token or be an approved operator.
300      * - `tokenId` must exist.
301      *
302      * Emits an {Approval} event.
303      */
304     function approve(address to, uint256 tokenId) external;
305 
306     /**
307      * @dev Returns the account approved for `tokenId` token.
308      *
309      * Requirements:
310      *
311      * - `tokenId` must exist.
312      */
313     function getApproved(uint256 tokenId) external view returns (address operator);
314 
315     /**
316      * @dev Approve or remove `operator` as an operator for the caller.
317      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
318      *
319      * Requirements:
320      *
321      * - The `operator` cannot be the caller.
322      *
323      * Emits an {ApprovalForAll} event.
324      */
325     function setApprovalForAll(address operator, bool _approved) external;
326 
327     /**
328      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
329      *
330      * See {setApprovalForAll}
331      */
332     function isApprovedForAll(address owner, address operator) external view returns (bool);
333 
334     /**
335      * @dev Safely transfers `tokenId` token from `from` to `to`.
336      *
337      * Requirements:
338      *
339      * - `from` cannot be the zero address.
340      * - `to` cannot be the zero address.
341      * - `tokenId` token must exist and be owned by `from`.
342      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
343      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
344      *
345      * Emits a {Transfer} event.
346      */
347     function safeTransferFrom(
348         address from,
349         address to,
350         uint256 tokenId,
351         bytes calldata data
352     ) external;
353 }
354 
355 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
356 
357 
358 
359 pragma solidity ^0.8.0;
360 
361 
362 /**
363  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
364  * @dev See https://eips.ethereum.org/EIPS/eip-721
365  */
366 interface IERC721Enumerable is IERC721 {
367     /**
368      * @dev Returns the total amount of tokens stored by the contract.
369      */
370     function totalSupply() external view returns (uint256);
371 
372     /**
373      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
374      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
375      */
376     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
377 
378     /**
379      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
380      * Use along with {totalSupply} to enumerate all tokens.
381      */
382     function tokenByIndex(uint256 index) external view returns (uint256);
383 }
384 
385 // File: BCC.sol
386 
387 
388 pragma solidity 0.8.7;
389 
390 
391 
392 
393 contract BCCStaking is Ownable {
394     
395     // Modifiers
396     
397     modifier eoaOnly {
398         require(msg.sender == tx.origin);
399         _;
400     }
401     
402     modifier whenNotPaused {
403         require((!paused) || (msg.sender == owner()), 'The contract is paused!');
404         _;
405     }
406     
407     
408     // Events
409     
410     event Staked(address indexed from, uint indexed tokenId, uint timestamp);
411     event Unstaked(address indexed from, uint indexed tokenId, uint timestamp);
412     event RewardChanged(uint oldReward, uint newReward, uint timestamp);
413     
414     
415     // Storage Variables
416     
417     uint oldBaseReward;
418     uint baseRewardPerSecond;
419     uint rewardChangedAt;
420     
421     mapping(uint => address) public ownerOf;
422     mapping(address => uint) public lastClaimOfAccount;
423     mapping(address => uint[]) public addressToOwnedTokens;
424     
425     bool public paused = false;
426     
427     IERC721Enumerable nftContract;
428     IERC20 bccContract;
429     
430     
431     // Constructor
432     
433     constructor(IERC721Enumerable nftContract_, IERC20 bccContract_, uint baseRewardPerDay_, bool paused_) {
434         bccContract = bccContract_;
435         nftContract = nftContract_;
436         paused = paused_;
437         baseRewardPerSecond = ((baseRewardPerDay_ * 1e18) / 1 days) + 1;
438     }
439     
440     
441     // External functions
442     
443     function stakeAndUnstakeMultiple(uint[] memory stakeTokenIds, uint[] memory unstakeTokenIds) whenNotPaused eoaOnly external {
444         require(nftContract.isApprovedForAll(msg.sender,address(this)),"Approve the contract to transfer your tokens first!");
445         claimAll();
446         for(uint i = 0; i < stakeTokenIds.length; i++) {
447             stake(stakeTokenIds[i]);
448         }
449         for(uint i = 0; i < unstakeTokenIds.length; i++) {
450             unstake(unstakeTokenIds[i]);
451         }
452     }
453     
454     function stakeMultiple(uint[] memory tokenIds) whenNotPaused eoaOnly external {
455         require(nftContract.isApprovedForAll(msg.sender,address(this)),"Approve the contract to transfer your tokens first!");
456         claimAll();
457         for(uint i = 0; i < tokenIds.length; i++) {
458             stake(tokenIds[i]);
459         }
460         
461     }
462     
463     function unstakeMultiple(uint[] memory tokenIds) whenNotPaused eoaOnly external {
464         claimAll();
465         for(uint i = 0; i < tokenIds.length; i++) {
466             unstake(tokenIds[i]);
467         }
468     }
469     
470     function claimAll() whenNotPaused eoaOnly public {
471         uint reward = getClaimAmountOfAccount(msg.sender);
472         if(reward > 0) {
473             bccContract.transfer(msg.sender,reward);
474         }
475         lastClaimOfAccount[msg.sender] = block.timestamp;
476     }
477     
478     
479     // View Only
480     
481     function getTokensOfAccount(address account) external view returns(uint[] memory tokens) {
482         return addressToOwnedTokens[account];
483     }
484     
485     function getClaimAmountOfAccount(address account) public view returns(uint total) {
486         uint tokens = addressToOwnedTokens[account].length;
487         if(tokens == 0) {
488             return 0;
489         }
490         uint rewardChangedAt_ = rewardChangedAt;
491         uint lastClaim = lastClaimOfAccount[account];
492         uint endTimestamp = block.timestamp;
493         if(endTimestamp < rewardChangedAt_ || rewardChangedAt_ == 0) {
494             return (((endTimestamp - lastClaim) * ( rewardChangedAt_ == 0 ? baseRewardPerSecond : oldBaseReward)) * tokens);
495         } else if(lastClaim > rewardChangedAt_) {
496             return (((endTimestamp - lastClaim) * baseRewardPerSecond) * tokens);
497         } else {
498             return ((((endTimestamp - rewardChangedAt_) * baseRewardPerSecond) + ((rewardChangedAt_ - lastClaim) * oldBaseReward)) * tokens);
499         }
500     }
501     
502     function balanceOf(address account) public view returns(uint balance) {
503         return addressToOwnedTokens[account].length;
504     }
505     
506     function rewardPerDayPerToken() external view returns(uint rewardPerDay) {
507         if(block.timestamp < rewardChangedAt || rewardChangedAt == 0)
508             return ((rewardChangedAt == 0 ? baseRewardPerSecond : oldBaseReward) * 86400) / 1e18;
509         return (baseRewardPerSecond * 86400) / 1e18;
510     }
511     
512     
513     // Internal
514     
515     function stake(uint tokenId) internal {
516         nftContract.transferFrom(msg.sender,address(this),tokenId);
517         ownerOf[tokenId] = msg.sender;
518         addressToOwnedTokens[msg.sender].push(tokenId);
519         emit Staked(msg.sender,tokenId,block.timestamp);
520     }
521     
522     function unstake(uint tokenId) internal {
523         require(ownerOf[tokenId] == msg.sender, "Only the owner of the token can withdraw it!");
524         bool removed = false;
525         uint[] memory ownedTokens = addressToOwnedTokens[msg.sender];
526         for( uint i = 0; i < ownedTokens.length; i++) {
527             if(ownedTokens[i] == tokenId) {
528                 addressToOwnedTokens[msg.sender][i] = ownedTokens[ownedTokens.length - 1];
529                 addressToOwnedTokens[msg.sender].pop();
530                 removed = true;
531                 break;
532             }
533         }
534         require(removed, "Internal error!");
535         ownerOf[tokenId] = address(0);
536         nftContract.transferFrom(address(this),msg.sender,tokenId);
537         emit Unstaked(msg.sender,tokenId,block.timestamp);
538     }
539     
540     
541     // Owner Only
542     
543     function setBaseRewardPerDay(uint perDay, uint timestamp) external onlyOwner {
544         oldBaseReward = baseRewardPerSecond;
545         rewardChangedAt = timestamp;
546         baseRewardPerSecond = ((perDay * 1e18) / 1 days) + 1;
547         emit RewardChanged(oldBaseReward, baseRewardPerSecond, timestamp);
548     }
549     
550     function airdrop(address[] memory targets,uint[] memory amounts) external onlyOwner {
551         require(targets.length == amounts.length, "Invalid data");
552         for(uint i = 0; i < targets.length; i++) {
553             bccContract.transfer(targets[i],amounts[i]);
554         }
555     }
556     
557     function setContracts(IERC721Enumerable nftContract_, IERC20 bccContract_) external onlyOwner {
558         bccContract = bccContract_;
559         nftContract = nftContract_;
560     }
561     
562     function setPaused(bool state) external onlyOwner {
563         paused = state;
564     }
565     
566     function setEmergency(bool state) external onlyOwner {
567         emergency = state;
568     }
569     
570     function emergencyWithdrawBCCTokens(uint amount) external onlyOwner {
571         bccContract.transfer(msg.sender,amount);
572     }
573     
574     
575     // Emergency Only
576     
577     bool internal emergency = false;
578     
579     function emergencyReturnToken(uint tokenId) eoaOnly external {
580         require(emergency, 'You can only use this function in case of an emergency');
581         unstake(tokenId); 
582     }
583     
584 }